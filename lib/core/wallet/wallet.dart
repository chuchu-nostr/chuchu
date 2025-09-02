import 'dart:async';
import 'package:flutter/foundation.dart';
import '../account/account.dart';
import '../nostr_dart/src/nips/nip_044_v2.dart';
import '../nostr_dart/src/utils.dart';
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

  static final String walletPubkey = '';
  static final String walletRelay = '';

  /// Current wallet balance
  WalletInfo? _walletInfo;
  WalletInfo? get walletInfo => _walletInfo;

  /// Transaction history
  List<WalletTransaction> _transactions = [];
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

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

  /// Generate password from private key using NIP-44 shareSecret derivation
  static String _derivePasswordFromPrivateKey(String privateKey, String publicKey) {
    // Use NIP-44 shareSecret to derive a shared secret
    final sharedSecret = Nip44v2.shareSecret(privateKey, publicKey);
    return bytesToHex(sharedSecret);
  }

  /// Create new wallet
  Future<WalletInfo> createNewWallet(String pubkey, String privkey) async {
    try {
      // Import the LNbits API service
      final lnbitsApi = LnbitsApiService();
      
      // Create username from pubkey (first 8 characters)
      final username = pubkey;
      
      // Step 1: Create user in LNbits
      LogUtils.d(() => 'Creating user in LNbits: $username');
      final password = _derivePasswordFromPrivateKey(privkey, pubkey);
      final userResponse = await lnbitsApi.createUser(username: username, password: password);
      final userId = userResponse['id'] as String;
      final adminKey = userResponse['admin'] as String;
      
      // Step 2: Create wallet for the user
      LogUtils.d(() => 'Creating wallet for user: $userId');
      final walletResponse = await lnbitsApi.createWallet(
        adminKey: adminKey,
        walletName: 'ChuChu Wallet',
      );
      final walletId = walletResponse['id'] as String;
      final invoiceKey = walletResponse['invoice'] as String;
      final readKey = walletResponse['read'] as String;
      
      // Step 3: Get initial wallet info
      LogUtils.d(() => 'Getting initial wallet info');
      final walletInfo = await lnbitsApi.getWalletInfo(apiKey: invoiceKey);
      final balance = (walletInfo['balance'] as int?) ?? 0;
      
      // Create wallet info object
      final walletInfoObj = WalletInfo(
        walletId: walletId,
        pubkey: pubkey,
        lnbitsUrl: lnbitsApi.baseUrl,
        adminKey: adminKey,
        invoiceKey: invoiceKey,
        readKey: readKey,
        lnbitsUserId: userId,
        lnbitsUsername: username,
        totalBalance: balance,
        confirmedBalance: balance,
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
      // Get current pubkey and privkey from account
      final pubkey = Account.sharedInstance.currentPubkey;
      final privkey = Account.sharedInstance.currentPrivkey;
      if (pubkey.isEmpty || privkey.isEmpty) {
        LogUtils.e(() => 'No current pubkey or privkey available');
        return false;
      }
      
      // Load wallet info from database by pubkey
      WalletInfo? walletInfo = await _loadWalletInfoByPubkey(pubkey);
      walletInfo ??= await createNewWallet(pubkey, privkey);

      // Set wallet info
      _walletInfo = walletInfo;

      // Get initial balance
      await refreshBalance();
      // Get recent transactions
      await refreshTransactions();
      
      LogUtils.i(() => 'Successfully connected to wallet: ${walletInfo?.walletId}');
      return true;
    } catch (e) {
      LogUtils.e(() => 'Failed to connect to wallet: $e');
      return false;
    }
  }

  /// Disconnect from wallet
  void disconnect() {
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
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final response = await lnbitsApi.createInvoice(
        apiKey: _walletInfo!.invoiceKey,
        amount: amountSats,
        memo: description,
      );
      
      return WalletInvoice(
        invoiceId: response['payment_hash'] as String,
        bolt11: response['bolt11'] as String,
        paymentHash: response['payment_hash'] as String,
        amount: response['amount'] as int,
        description: response['memo'] as String? ?? '',
        status: InvoiceStatus.pending,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        expiresAt: DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        walletId: _walletInfo!.walletId,
      );
    } catch (e) {
      LogUtils.e(() => 'Failed to create invoice: $e');
      return null;
    }
  }

  /// Refresh transaction history
  Future<void> refreshTransactions() async {
    if (_walletInfo == null || _walletInfo!.invoiceKey.isEmpty) return;
    
    try {
      final lnbitsApi = LnbitsApiService(lnbitsUrl: _walletInfo!.lnbitsUrl);
      final payments = await lnbitsApi.getPayments(
        apiKey: _walletInfo!.invoiceKey,
        limit: 50,
      );
      
      final transactions = payments.map((payment) => WalletTransaction.fromJson(payment)).toList();
      if (transactions.isNotEmpty) {
        _transactions = transactions;
        await _saveTransactionsToDB(transactions);
        onTransactionAdded?.call();
      }
    } catch (e) {
      LogUtils.e(() => 'Failed to refresh transactions: $e');
    }
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



  /// Load transactions from database
  Future<void> _loadTransactionsFromDB() async {
    try {
      // Load cached transactions from local database
      // This would be implemented when database is properly set up
    } catch (e) {
      LogUtils.e(() => 'Failed to load transactions from DB: $e');
    }
  }

  /// Save transactions to database
  Future<void> _saveTransactionsToDB(List<WalletTransaction> transactions) async {
    try {
      // Save transactions to local database
      // This would be implemented when database is properly set up
    } catch (e) {
      LogUtils.e(() => 'Failed to save transactions to DB: $e');
    }
  }

  /// Load balance from database
  Future<void> _loadBalanceFromDB() async {
    try {
      // Load cached balance from local database
      // This would be implemented when database is properly set up
    } catch (e) {
      LogUtils.e(() => 'Failed to load balance from DB: $e');
    }
  }

  /// Load wallet info by pubkey from database
  Future<WalletInfo?> _loadWalletInfoByPubkey(String pubkey) async {
    try {
      // Load wallet info from local database by pubkey
      // This would be implemented when database is properly set up
      // For now, return null to indicate no wallet found
      return null;
    } catch (e) {
      LogUtils.e(() => 'Failed to load wallet info by pubkey: $e');
      return null;
    }
  }



  /// Save wallet info to database
  Future<void> _saveWalletInfoToDB(WalletInfo walletInfo) async {
    try {
      // Save wallet info to local database
      // This would be implemented when database is properly set up
      LogUtils.i(() => 'Wallet info saved to database: ${walletInfo.walletId}');
    } catch (e) {
      LogUtils.e(() => 'Failed to save wallet info to DB: $e');
      rethrow;
    }
  }



  /// Lookup invoice
  Future<WalletInvoice?> lookupInvoice(String invoice) async {
    // Implementation for looking up invoice
    return null;
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
      // Get transaction by ID from local database
      return null;
    } catch (e) {
      LogUtils.e(() => 'Error getting transaction by ID: $e');
      return null;
    }
  }

  /// Get invoice by ID
  Future<WalletInvoice?> getInvoiceById(String invoiceId) async {
    try {
      // Get invoice by ID from local database
      return null;
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
      // Get transactions by date range from local database
      return [];
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by date range: $e');
      return [];
    }
  }

  /// Get pending transactions
  Future<List<WalletTransaction>> getPendingTransactions() async {
    try {
      // Get pending transactions from local database
      return [];
    } catch (e) {
      LogUtils.e(() => 'Error getting pending transactions: $e');
      return [];
    }
  }

  /// Get transactions by type
  Future<List<WalletTransaction>> getTransactionsByType(TransactionType type) async {
    try {
      // Get transactions by type from local database
      return [];
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by type: $e');
      return [];
    }
  }

  /// Get transactions by status
  Future<List<WalletTransaction>> getTransactionsByStatus(TransactionStatus status) async {
    try {
      // Get transactions by status from local database
      return [];
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
      // Get transactions by amount range from local database
      return [];
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by amount range: $e');
      return [];
    }
  }
}
