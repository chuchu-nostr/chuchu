import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/log_utils.dart';
import 'wallet.dart';
import 'model/wallet_transaction.dart';
import 'model/wallet_balance.dart';
import 'model/wallet_invoice.dart';

/// Wallet Manager
/// Central manager for all wallet operations
class WalletManager {
  /// Singleton instance
  WalletManager._internal();
  factory WalletManager() => sharedInstance;
  static final WalletManager sharedInstance = WalletManager._internal();

  /// Main wallet instance
  final Wallet _wallet = Wallet.sharedInstance;

  /// Wallet connection status
  bool get isConnected => _wallet.isConnected;
  bool get isWalletAvailable => _wallet.walletURI != null;

  /// Wallet balance
  WalletBalance? get balance => _wallet.balance;

  /// Transaction history
  List<WalletTransaction> get transactions => _wallet.transactions;
  List<WalletTransaction> get pendingTransactions => _wallet.pendingTransactions;

  /// Initialize wallet manager
  Future<void> init() async {
    try {
      await _wallet.init();
      LogUtils.i(() => 'Wallet manager initialized successfully');
    } catch (e) {
      LogUtils.e(() => 'Failed to initialize wallet manager: $e');
    }
  }

  /// Connect to wallet
  Future<bool> connectToWallet(String uri) async {
    try {
      final success = await _wallet.connectToWallet(uri);
      if (success) {
        LogUtils.i(() => 'Successfully connected to wallet');
      } else {
        LogUtils.w(() => 'Failed to connect to wallet');
      }
      return success;
    } catch (e) {
      LogUtils.e(() => 'Error connecting to wallet: $e');
      return false;
    }
  }

  /// Disconnect from wallet
  void disconnect() {
    _wallet.disconnect();
    LogUtils.i(() => 'Disconnected from wallet');
  }

  /// Refresh wallet balance
  Future<void> refreshBalance() async {
    try {
      await _wallet.refreshBalance();
      LogUtils.v(() => 'Wallet balance refreshed');
    } catch (e) {
      LogUtils.e(() => 'Failed to refresh balance: $e');
    }
  }

  /// Send payment
  Future<WalletTransaction?> sendPayment(String invoice, {String? description}) async {
    try {
      final transaction = await _wallet.sendPayment(invoice, description: description);
      if (transaction != null) {
        LogUtils.i(() => 'Payment sent successfully: ${transaction.transactionId}');
      } else {
        LogUtils.w(() => 'Failed to send payment');
      }
      return transaction;
    } catch (e) {
      LogUtils.e(() => 'Error sending payment: $e');
      return null;
    }
  }

  /// Create invoice for receiving payment
  Future<WalletInvoice?> createInvoice(int amountSats, {String? description}) async {
    try {
      final invoice = await _wallet.createInvoice(amountSats, description: description);
      if (invoice != null) {
        LogUtils.i(() => 'Invoice created successfully: ${invoice.invoiceId}');
      } else {
        LogUtils.w(() => 'Failed to create invoice');
      }
      return invoice;
    } catch (e) {
      LogUtils.e(() => 'Error creating invoice: $e');
      return null;
    }
  }

  /// Refresh transaction history
  Future<void> refreshTransactions() async {
    try {
      await _wallet.refreshTransactions();
      LogUtils.v(() => 'Transaction history refreshed');
    } catch (e) {
      LogUtils.e(() => 'Failed to refresh transactions: $e');
    }
  }

  /// Set callbacks for wallet events
  void setCallbacks({
    VoidCallback? onBalanceChanged,
    VoidCallback? onTransactionAdded,
    VoidCallback? onConnectionStatusChanged,
  }) {
    _wallet.onBalanceChanged = onBalanceChanged;
    _wallet.onTransactionAdded = onTransactionAdded;
    _wallet.onConnectionStatusChanged = onConnectionStatusChanged;
  }

  /// Lookup invoice
  Future<WalletInvoice?> lookupInvoice(String invoice) async {
    try {
      return await _wallet.lookupInvoice(invoice);
    } catch (e) {
      LogUtils.e(() => 'Error looking up invoice: $e');
      return null;
    }
  }

  /// Save invoice to database
  Future<void> saveInvoiceToDB(WalletInvoice invoice) async {
    try {
      await _wallet.saveInvoiceToDB(invoice);
    } catch (e) {
      LogUtils.e(() => 'Error saving invoice to DB: $e');
    }
  }

  /// Load invoices from database
  Future<List<WalletInvoice>> loadInvoicesFromDB() async {
    try {
      return await _wallet.loadInvoicesFromDB();
    } catch (e) {
      LogUtils.e(() => 'Error loading invoices from DB: $e');
      return [];
    }
  }

  /// Update transaction in database
  Future<void> updateTransactionInDB(WalletTransaction transaction) async {
    try {
      await _wallet.updateTransactionInDB(transaction);
    } catch (e) {
      LogUtils.e(() => 'Error updating transaction in DB: $e');
    }
  }

  /// Delete transaction from database
  Future<void> deleteTransactionFromDB(String transactionId) async {
    try {
      await _wallet.deleteTransactionFromDB(transactionId);
    } catch (e) {
      LogUtils.e(() => 'Error deleting transaction from DB: $e');
    }
  }

  /// Clear all wallet data from database
  Future<void> clearWalletDataFromDB() async {
    try {
      await _wallet.clearWalletDataFromDB();
      LogUtils.v(() => 'Wallet data cleared from DB');
    } catch (e) {
      LogUtils.e(() => 'Error clearing wallet data from DB: $e');
    }
  }

  /// Get transaction by ID
  Future<WalletTransaction?> getTransactionById(String transactionId) async {
    try {
      return await _wallet.getTransactionById(transactionId);
    } catch (e) {
      LogUtils.e(() => 'Error getting transaction by ID: $e');
      return null;
    }
  }

  /// Get invoice by ID
  Future<WalletInvoice?> getInvoiceById(String invoiceId) async {
    try {
      return await _wallet.getInvoiceById(invoiceId);
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
      return await _wallet.getTransactionsByDateRange(startTime, endTime);
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by date range: $e');
      return [];
    }
  }

  /// Get pending transactions
  Future<List<WalletTransaction>> getPendingTransactions() async {
    try {
      return await _wallet.getPendingTransactions();
    } catch (e) {
      LogUtils.e(() => 'Error getting pending transactions: $e');
      return [];
    }
  }

  /// Get transactions by type
  Future<List<WalletTransaction>> getTransactionsByType(TransactionType type) async {
    try {
      return await _wallet.getTransactionsByType(type);
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by type: $e');
      return [];
    }
  }

  /// Get transactions by status
  Future<List<WalletTransaction>> getTransactionsByStatus(TransactionStatus status) async {
    try {
      return await _wallet.getTransactionsByStatus(status);
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
      return await _wallet.getTransactionsByAmountRange(minAmount, maxAmount);
    } catch (e) {
      LogUtils.e(() => 'Error getting transactions by amount range: $e');
      return [];
    }
  }
}
