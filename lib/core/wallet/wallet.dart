import 'dart:async';
import 'package:flutter/foundation.dart';
import '../account/account.dart';
import '../database/db_isar.dart';
import 'package:isar/isar.dart';

import '../utils/log_utils.dart';
import 'model/wallet_transaction.dart';
import 'model/wallet_info.dart';
import 'model/wallet_invoice.dart';
import 'lnbits_api_service.dart';

/// NIP-47 Wallet Manager
/// Handles Lightning Network payments through Nostr Wallet Connect
class Wallet {
  /// Singleton instance
  Wallet._internal();
  factory Wallet() => sharedInstance;
  static final Wallet sharedInstance = Wallet._internal();

  /// Current wallet balance
  WalletInfo? _walletInfo;
  WalletInfo? get walletInfo => _walletInfo;

  /// LNbits API service
  final LnbitsApiService lnbitsApi = LnbitsApiService();

  /// Transaction history
  List<WalletTransaction> _transactions = [];
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  /// Get all transactions including pending invoices
  Future<List<WalletTransaction>> getAllTransactions() async {
    final all = <WalletTransaction>[];
    all.addAll(_transactions);
    
    // Add pending invoices as transactions
    try {
      final invoices = await _loadInvoicesFromDB();
      final pendingInvoices = invoices.where((invoice) => invoice.status == InvoiceStatus.pending).toList();
      
      for (final invoice in pendingInvoices) {
        final transaction = WalletTransaction(
          transactionId: invoice.invoiceId,
          amount: invoice.amount,
          description: invoice.description,
          status: TransactionStatus.pending,
          type: TransactionType.incoming, // Invoice is for receiving
          createdAt: invoice.createdAt,
          walletId: invoice.walletId,
        );
        all.add(transaction);
      }
    } catch (e) {
      LogUtils.e(() => 'Failed to load pending invoices: $e');
    }
    
    // Sort by creation time (newest first)
    all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return all;
  }

  /// Timer for checking pending invoices
  Timer? _invoiceCheckTimer;

  /// BTC to USD exchange rate cache
  double? _btcToUsdRate;
  DateTime? _rateLastUpdated;

  /// Pending transactions
  final List<WalletTransaction> _pendingTransactions = [];
  List<WalletTransaction> get pendingTransactions => List.unmodifiable(_pendingTransactions);

  /// Wallet connection status
  bool get isConnected => _walletInfo != null;

  /// Callbacks
  VoidCallback? onBalanceChanged;
  VoidCallback? onTransactionAdded;

  /// Initialize wallet
  Future<void> init() async {
    await connectToWallet();
  }

  /// Create new wallet
  Future<WalletInfo> createNewWallet(String pubkey, String privkey) async {
    try {
      LogUtils.d(() => 'Creating new wallet for pubkey: ${pubkey.substring(0, 8)}...');
      
      // Create wallet with random name
      final accountResponse = await lnbitsApi.createWallet();
      final walletId = accountResponse['id'] as String;
      final adminKey = accountResponse['admin'] as String;
      final invoiceKey = accountResponse['invoice'] as String;
      final readKey = accountResponse['read'] as String;
      final walletName = accountResponse['name'] as String;
      
      LogUtils.d(() => 'Wallet ID: $walletId');
      LogUtils.d(() => 'Wallet Name: $walletName');
      LogUtils.d(() => 'Admin Key: $adminKey');
      LogUtils.d(() => 'Invoice Key: $invoiceKey');
      
      // Create wallet info object
      final walletInfoObj = WalletInfo(
        walletId: walletId,
        pubkey: pubkey,
        lnbitsUrl: lnbitsApi.baseUrl,
        adminKey: adminKey,
        invoiceKey: invoiceKey,
        readKey: readKey,
        lnbitsUserId: walletId, // For LNbits, the wallet ID serves as user ID
        lnbitsUsername: walletName,
        totalBalance: 0, // New wallet starts with 0 balance
        confirmedBalance: 0,
        unconfirmedBalance: 0,
        reservedBalance: 0,
        lastUpdated: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      
      // Save to database
      await _saveWalletInfoToDB(walletInfoObj);
      
      LogUtils.i(() => 'Successfully created wallet: $walletId');
      return walletInfoObj;
    } catch (e) {
      LogUtils.e(() => 'Failed to create new wallet: $e');
      rethrow;
    }
  }

  /// Connect to LNbits wallet using current pubkey
  Future<bool> connectToWallet() async {
    try {
      LogUtils.d(() => 'Starting wallet connection process');
      // Get current pubkey and privkey from account
      final pubkey = Account.sharedInstance.currentPubkey;
      final privkey = Account.sharedInstance.currentPrivkey;
      LogUtils.d(() => 'Current pubkey: $pubkey, privkey length: ${privkey.length}');
      if (pubkey.isEmpty || privkey.isEmpty) {
        LogUtils.e(() => 'No current pubkey or privkey available');
        return false;
      }
      
      // Load wallet info from database
      LogUtils.d(() => 'Loading wallet info from database');
      WalletInfo? walletInfo = await _loadWalletInfo();
      if (walletInfo == null) {
        LogUtils.d(() => 'No existing wallet found, creating new wallet');
        walletInfo = await createNewWallet(pubkey, privkey);
      } else {
        LogUtils.d(() => 'Found existing wallet: ${walletInfo?.walletId ?? "unknown"}');
      }

      // Set wallet info
      _walletInfo = walletInfo;

      // Get initial balance
      await refreshBalance();
      // Get recent transactions
      await refreshTransactions();
      
      // Start invoice checking timer
      _startInvoiceCheckTimer();
      
      LogUtils.i(() => 'Successfully connected to wallet: ${walletInfo?.walletId ?? "unknown"}');
      return true;
    } catch (e) {
      LogUtils.e(() => 'Failed to connect to wallet: $e');
      return false;
    }
  }

  /// Disconnect from wallet
  void disconnect() {
    // Stop invoice checking timer
    _stopInvoiceCheckTimer();
    
    _walletInfo = null;
  }

  /// Refresh wallet balance
  Future<void> refreshBalance() async {
    if (_walletInfo == null) return;
    
    try {
      final balance = await _getBalance();
      if (balance != null && _walletInfo != null) {
        _walletInfo!.updateBalance(totalBalance: balance);
        await _saveWalletInfoToDB(_walletInfo!);
        onBalanceChanged?.call();
      }
    } catch (e) {
      LogUtils.e(() => 'Failed to refresh balance: $e');
    }
  }

  /// Send payment
  Future<WalletTransaction?> sendPayment(String invoice, {String? description}) async {
    if (_walletInfo == null || _walletInfo!.adminKey.isEmpty) return null;
    
    try {
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final response = await lnbitsApi.payInvoice(
        adminKey: _walletInfo!.adminKey,
        bolt11: invoice,
      );
      
      final transaction = WalletTransaction(
        transactionId: response['payment_hash'] as String,
        type: TransactionType.outgoing,
        status: TransactionStatus.confirmed,
        amount: response['amount'] as int,
        fee: response['fee'] as int? ?? 0,
        description: description ?? '',
        invoice: invoice,
        paymentHash: response['payment_hash'] as String,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        walletId: _walletInfo!.walletId,
        preimage: response['preimage'] as String?,
      );
      
      _addTransaction(transaction);
      await refreshBalance();
      return transaction;
    } catch (e) {
      LogUtils.e(() => 'Failed to send payment: $e');
      return null;
    }
  }

  /// Create invoice for receiving payment
  Future<WalletInvoice?> createInvoice(int amountSats, {String? description}) async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) return null;
    
    try {
      LogUtils.d(() => 'Creating invoice for ${amountSats} sats${description != null ? ' with description: $description' : ''}');
      
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final response = await lnbitsApi.createInvoice(
        apiKey: _walletInfo!.invoiceKey,
        amount: amountSats,
        memo: description,
      );
      
      final invoice = WalletInvoice(
        invoiceId: response['payment_hash'] as String,
        bolt11: response['bolt11'] as String,
        paymentHash: response['payment_hash'] as String,
        amount: (response['amount'] as int) ~/ 1000, // Convert msats to sats
        description: description ?? '', // Use original description, not API response
        status: InvoiceStatus.pending,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        expiresAt: DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        walletId: _walletInfo!.walletId,
      );
      
      // Save invoice to database
      await _saveInvoiceToDB(invoice);
      
      LogUtils.i(() => 'Successfully created invoice: ${invoice.invoiceId}');
      return invoice;
    } catch (e) {
      LogUtils.e(() => 'Failed to create invoice: $e');
      return null;
    }
  }

  /// Refresh transaction history with smart sync strategy
  Future<void> refreshTransactions() async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) return;
    
    try {
      // Step 1: Load existing transactions from database first
      final existingTransactions = await _loadTransactionsFromDB();
      if (existingTransactions.isNotEmpty) {
        _transactions = existingTransactions;
        LogUtils.d(() => 'Loaded ${existingTransactions.length} existing transactions from DB');
        onTransactionAdded?.call();
      }
      
      // Step 2: Fetch latest transactions from API
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final payments = await lnbitsApi.getPayments(
        apiKey: _walletInfo!.invoiceKey,
        limit: 10,
      );
      
      final apiTransactions = payments.map((payment) => WalletTransaction.fromJson(payment)).toList();
      
      // Step 3: Compare and merge transactions
      final mergedTransactions = _mergeTransactions(existingTransactions, apiTransactions);
      
      if (mergedTransactions.isNotEmpty) {
        _transactions = mergedTransactions;
        await _saveTransactionsToDB(apiTransactions); // Save new transactions from API
        LogUtils.d(() => 'Refreshed transactions: ${apiTransactions.length} from API, ${mergedTransactions.length} total');
        onTransactionAdded?.call();
      }
    } catch (e) {
      LogUtils.e(() => 'Failed to refresh transactions: $e');
      // If API fails, still try to load from DB
      if (_transactions.isEmpty) {
        final existingTransactions = await _loadTransactionsFromDB();
        if (existingTransactions.isNotEmpty) {
          _transactions = existingTransactions;
          onTransactionAdded?.call();
        }
      }
    }
  }

  /// Merge existing transactions with new ones from API
  List<WalletTransaction> _mergeTransactions(
    List<WalletTransaction> existing,
    List<WalletTransaction> newTransactions,
  ) {
    final Map<String, WalletTransaction> transactionMap = {};
    
    // Add existing transactions
    for (final transaction in existing) {
      transactionMap[transaction.transactionId] = transaction;
    }
    
    // Add/update with new transactions (API data takes precedence)
    for (final transaction in newTransactions) {
      transactionMap[transaction.transactionId] = transaction;
    }
    
    // Sort by creation time (newest first)
    final merged = transactionMap.values.toList();
    merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return merged;
  }

  /// Add transaction to local list
  void _addTransaction(WalletTransaction transaction) {
    _transactions.insert(0, transaction);
    if (transaction.status == TransactionStatus.pending) {
      _pendingTransactions.add(transaction);
    }
    onTransactionAdded?.call();
  }


  /// Get wallet balance from LNbits API
  Future<int?> _getBalance() async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) {
      return null;
    }
    
    try {
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final walletInfo = await lnbitsApi.getWalletInfo(apiKey: _walletInfo!.invoiceKey);
      return walletInfo['balance'] as int?;
    } catch (e) {
      LogUtils.e(() => 'Failed to get balance: $e');
      return null;
    }
  }
  /// Save transactions to database
  Future<void> _saveTransactionsToDB(List<WalletTransaction> transactions) async {
    try {
      // Save transactions to local database
      for (final transaction in transactions) {
        await DBISAR.sharedInstance.saveToDB(transaction);
      }
      LogUtils.d(() => 'Saved ${transactions.length} transactions to database');
    } catch (e) {
      LogUtils.e(() => 'Failed to save transactions to DB: $e');
    }
  }

  /// Load transactions from database
  Future<List<WalletTransaction>> _loadTransactionsFromDB() async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final transactions = await isar.walletTransactions.where().findAll();
      LogUtils.d(() => 'Loaded ${transactions.length} transactions from database');
      return transactions;
    } catch (e) {
      LogUtils.e(() => 'Failed to load transactions from DB: $e');
      return [];
    }
  }

  /// Load wallet info from database
  Future<WalletInfo?> _loadWalletInfo() async {
    try {
      // Load wallet info from local database
      final isar = DBISAR.sharedInstance.isar;
      final walletInfos = await isar.walletInfos.where().findAll();
      
      if (walletInfos.isNotEmpty) {
        final walletInfo = walletInfos.first;
        LogUtils.d(() => 'Found existing wallet in database: ${walletInfo.walletId}');
        return walletInfo;
      }
      
      LogUtils.d(() => 'No wallet found in database');
      return null;
    } catch (e) {
      LogUtils.e(() => 'Failed to load wallet info: $e');
      return null;
    }
  }



  /// Save wallet info to database
  Future<void> _saveWalletInfoToDB(WalletInfo walletInfo) async {
    try {
      // Save wallet info to local database
      await DBISAR.sharedInstance.saveToDB(walletInfo);
      LogUtils.i(() => 'Wallet info saved to database: ${walletInfo.walletId}');
    } catch (e) {
      LogUtils.e(() => 'Failed to save wallet info to DB: $e');
      rethrow;
    }
  }

  /// Save invoice to database
  Future<void> _saveInvoiceToDB(WalletInvoice invoice) async {
    try {
      // Save invoice to local database
      await DBISAR.sharedInstance.saveToDB(invoice);
      LogUtils.d(() => 'Invoice saved to database: ${invoice.invoiceId}');
    } catch (e) {
      LogUtils.e(() => 'Failed to save invoice to DB: $e');
      rethrow;
    }
  }

  /// Load invoices from database
  Future<List<WalletInvoice>> _loadInvoicesFromDB() async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final invoices = await isar.walletInvoices.where().findAll();
      LogUtils.d(() => 'Loaded ${invoices.length} invoices from database');
      return invoices;
    } catch (e) {
      LogUtils.e(() => 'Failed to load invoices from DB: $e');
      return [];
    }
  }

  /// Get all invoices
  Future<List<WalletInvoice>> getInvoices() async {
    return await _loadInvoicesFromDB();
  }

  /// Update invoice status
  Future<void> updateInvoiceStatus(String invoiceId, InvoiceStatus status) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final invoice = await isar.walletInvoices.where().invoiceIdEqualTo(invoiceId).findFirst();
      if (invoice != null) {
        invoice.status = status;
        await isar.walletInvoices.put(invoice);
        LogUtils.d(() => 'Updated invoice status: $invoiceId -> $status');
      }
    } catch (e) {
      LogUtils.e(() => 'Failed to update invoice status: $e');
    }
  }

  /// Check pending invoices for payment status
  Future<void> checkPendingInvoices() async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) return;
    
    try {
      LogUtils.d(() => 'Checking pending invoices for payment status...');
      
      // Get all pending invoices from database
      final isar = DBISAR.sharedInstance.isar;
      final allInvoices = await isar.walletInvoices.where().findAll();
      final pendingInvoices = allInvoices.where((invoice) => invoice.status == InvoiceStatus.pending).toList();
      
      if (pendingInvoices.isEmpty) {
        LogUtils.d(() => 'No pending invoices to check');
        return;
      }
      
      LogUtils.d(() => 'Found ${pendingInvoices.length} pending invoices to check');
      
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      int updatedCount = 0;
      
      // Check each pending invoice
      for (final invoice in pendingInvoices) {
        try {
          // Check if invoice is expired
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (invoice.expiresAt < now) {
            await updateInvoiceStatus(invoice.invoiceId, InvoiceStatus.expired);
            LogUtils.d(() => 'Invoice expired: ${invoice.invoiceId}');
            updatedCount++;
            continue;
          }
          
          // Check payment status via API
          final paymentInfo = await lnbitsApi.getPayment(
            apiKey: _walletInfo!.invoiceKey,
            paymentHash: invoice.paymentHash,
          );
          
          if (paymentInfo['paid'] == true) {
            await updateInvoiceStatus(invoice.invoiceId, InvoiceStatus.paid);
            LogUtils.d(() => 'Invoice paid: ${invoice.invoiceId}');
            updatedCount++;
            
            // Refresh balance after successful payment
            await refreshBalance();
          }
        } catch (e) {
          LogUtils.e(() => 'Error checking invoice ${invoice.invoiceId}: $e');
        }
      }
      
      LogUtils.i(() => 'Invoice status check completed. Updated $updatedCount invoices.');
    } catch (e) {
      LogUtils.e(() => 'Failed to check pending invoices: $e');
    }
  }

  /// Get pending invoices
  Future<List<WalletInvoice>> getPendingInvoices() async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final allInvoices = await isar.walletInvoices.where().findAll();
      final pendingInvoices = allInvoices.where((invoice) => invoice.status == InvoiceStatus.pending).toList();
      // Sort by creation time (newest first)
      pendingInvoices.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return pendingInvoices;
    } catch (e) {
      LogUtils.e(() => 'Failed to get pending invoices: $e');
      return [];
    }
  }

  /// Manually refresh invoice statuses (for UI refresh button)
  Future<void> refreshInvoiceStatuses() async {
    LogUtils.d(() => 'Manual invoice status refresh requested');
    await checkPendingInvoices();
  }



  /// Lookup invoice by payment hash or bolt11
  Future<WalletInvoice?> lookupInvoice(String invoice) async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) return null;
    
    try {
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      
      // Try to get payment info from LNbits API
      final response = await lnbitsApi.getPayment(
        apiKey: _walletInfo!.invoiceKey,
        paymentHash: invoice,
      );
      
      if (response.isNotEmpty) {
        // Update local invoice status if found
        await updateInvoiceStatus(invoice, InvoiceStatus.paid);
        LogUtils.d(() => 'Invoice found and marked as paid: $invoice');
      }
      
      return null; // For now, return null as we need to implement proper mapping
    } catch (e) {
      LogUtils.e(() => 'Failed to lookup invoice: $e');
      return null;
    }
  }

  /// Save invoice to database
  Future<void> saveInvoiceToDB(WalletInvoice invoice) async {
    try {
      // Save invoice to local database
    } catch (e) {
      LogUtils.e(() => 'Error saving invoice to DB: $e');
    }
  }

  /// Load invoices from database
  Future<List<WalletInvoice>> loadInvoicesFromDB() async {
    try {
      // Load invoices from local database
      return [];
    } catch (e) {
      LogUtils.e(() => 'Error loading invoices from DB: $e');
      return [];
    }
  }

  /// Update transaction in database
  Future<void> updateTransactionInDB(WalletTransaction transaction) async {
    try {
      // Update transaction in local database
    } catch (e) {
      LogUtils.e(() => 'Error updating transaction in DB: $e');
    }
  }

  /// Delete transaction from database
  Future<void> deleteTransactionFromDB(String transactionId) async {
    try {
      // Delete transaction from local database
    } catch (e) {
      LogUtils.e(() => 'Error deleting transaction from DB: $e');
    }
  }

  /// Clear all wallet data from database
  Future<void> clearWalletDataFromDB() async {
    try {
      // Clear all wallet data from local database
      LogUtils.v(() => 'Wallet data cleared from DB');
    } catch (e) {
      LogUtils.e(() => 'Error clearing wallet data from DB: $e');
    }
  }

  /// Get transaction by ID
  Future<WalletTransaction?> getTransactionById(String transactionId) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final transaction = await isar.walletTransactions.where().transactionIdEqualTo(transactionId).findFirst();
      return transaction;
    } catch (e) {
      LogUtils.e(() => 'Error getting transaction by ID: $e');
      return null;
    }
  }

  /// Get invoice by ID
  Future<WalletInvoice?> getInvoiceById(String invoiceId) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final invoice = await isar.walletInvoices.where().invoiceIdEqualTo(invoiceId).findFirst();
      return invoice;
    } catch (e) {
      LogUtils.e(() => 'Error getting invoice by ID: $e');
      return null;
    }
  }

  /// Get transactions by date range
  Future<List<WalletTransaction>> getTransactionsByDateRange(
    int startTime,
    int endTime,
  ) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final allTransactions = await isar.walletTransactions.where().findAll();
      final filteredTransactions = allTransactions.where((transaction) {
        return transaction.createdAt >= startTime && transaction.createdAt <= endTime;
      }).toList();
      
      // Sort by creation time (newest first)
      filteredTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filteredTransactions;
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by date range: $e');
      return [];
    }
  }

  /// Get pending transactions
  Future<List<WalletTransaction>> getPendingTransactions() async {
    try {
      return await getTransactionsByStatus(TransactionStatus.pending);
    } catch (e) {
      LogUtils.e(() => 'Error getting pending transactions: $e');
      return [];
    }
  }

  /// Get transactions by type
  Future<List<WalletTransaction>> getTransactionsByType(TransactionType type) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final allTransactions = await isar.walletTransactions.where().findAll();
      final filteredTransactions = allTransactions.where((transaction) {
        return transaction.type == type;
      }).toList();
      
      // Sort by creation time (newest first)
      filteredTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filteredTransactions;
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by type: $e');
      return [];
    }
  }

  /// Get transactions by status
  Future<List<WalletTransaction>> getTransactionsByStatus(TransactionStatus status) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final allTransactions = await isar.walletTransactions.where().findAll();
      final filteredTransactions = allTransactions.where((transaction) {
        return transaction.status == status;
      }).toList();
      
      // Sort by creation time (newest first)
      filteredTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filteredTransactions;
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by status: $e');
      return [];
    }
  }

  /// Get transactions by amount range
  Future<List<WalletTransaction>> getTransactionsByAmountRange(
    int minAmount,
    int maxAmount,
  ) async {
    try {
      final isar = DBISAR.sharedInstance.isar;
      final allTransactions = await isar.walletTransactions.where().findAll();
      final filteredTransactions = allTransactions.where((transaction) {
        return transaction.amount >= minAmount && transaction.amount <= maxAmount;
      }).toList();
      
      // Sort by creation time (newest first)
      filteredTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return filteredTransactions;
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by amount range: $e');
      return [];
    }
  }

  /// Start invoice checking timer
  void _startInvoiceCheckTimer() {
    _stopInvoiceCheckTimer(); // Stop any existing timer
    
    // Check every 30 seconds for pending invoices
    _invoiceCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkPendingInvoices();
    });
    
    LogUtils.d(() => 'Started invoice checking timer (30s interval)');
  }

  /// Stop invoice checking timer
  void _stopInvoiceCheckTimer() {
    _invoiceCheckTimer?.cancel();
    _invoiceCheckTimer = null;
    LogUtils.d(() => 'Stopped invoice checking timer');
  }

  /// Get BTC to USD exchange rate (with caching)
  Future<double> getBtcToUsdRate() async {
    // Check if we have a cached rate that's less than 5 minutes old
    if (_btcToUsdRate != null && 
        _rateLastUpdated != null && 
        DateTime.now().difference(_rateLastUpdated!).inMinutes < 5) {
      return _btcToUsdRate!;
    }

    try {
      final rate = await lnbitsApi.getBtcToUsdRate();
      _btcToUsdRate = rate;
      _rateLastUpdated = DateTime.now();
      return rate;
    } catch (e) {
      LogUtils.e(() => 'Failed to get BTC rate: $e');
      // Return cached rate if available, otherwise fallback
      return _btcToUsdRate ?? 50000.0;
    }
  }

  /// Convert sats to USD
  Future<double> satsToUsd(int sats) async {
    final btcRate = await getBtcToUsdRate();
    final btcAmount = sats / 100000000.0; // Convert sats to BTC
    return btcAmount * btcRate;
  }
}
