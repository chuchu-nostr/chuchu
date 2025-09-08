import 'package:flutter/material.dart';
import '../../core/wallet/wallet.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import 'transaction_detail_page.dart';
import 'transactions_page.dart';
import '../../core/wallet/model/wallet_info.dart';

/// Wallet Page
/// Simple wallet interface navigated from profile page
class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final Wallet _wallet = Wallet.sharedInstance;
  bool _isLoading = false;
  String _statusMessage = '';
  double? _usdValue;
  List<WalletTransaction> _allTransactions = [];

  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }

  @override
  void dispose() {
    // Cleanup wallet resources
    _wallet.dispose();
    super.dispose();
  }

  void _setupCallbacks() {
    _wallet.onBalanceChanged = () {
      _updateUsdValue();
      _updateTransactions();
      if (mounted) {
        setState(() {});
      }
    };
    _wallet.onTransactionAdded = () {
      _updateTransactions();
      if (mounted) {
        setState(() {});
      }
    };
    
    // Initialize wallet
    _initializeWallet();
  }

  Future<void> _updateTransactions() async {
    try {
      _allTransactions = await _wallet.getAllTransactions();
    } catch (e) {
      print('Failed to update transactions: $e');
    }
  }

  Future<void> _updateUsdValue() async {
    if (_wallet.walletInfo != null) {
      try {
        final usdValue = await _wallet.satsToUsd(_wallet.walletInfo!.totalBalance);
        if (mounted) {
          setState(() {
            _usdValue = usdValue;
          });
        }
      } catch (e) {
        print('Failed to get USD value: $e');
      }
    }
  }

  Future<void> _initializeWallet() async {
    try {
      await _wallet.init();
      await _updateUsdValue(); // Update USD value after wallet initialization
      await _updateTransactions(); // Load transactions including pending invoices
      if (mounted) {
        setState(() {}); // Refresh UI after wallet initialization
      }
    } catch (e) {
      print('Failed to initialize wallet: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(_statusMessage),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(),
                  SizedBox(height: 16),
                  _buildQuickActions(),
                  SizedBox(height: 16),
                  _buildRecentTransactions(),
                ],
              ),
            ),
    );
  }



  Widget _buildBalanceCard() {
    WalletInfo? balance = _wallet.walletInfo;
    
    // Show loading state if no balance data
    if (balance == null) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text(
                      'Loading balance...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Center(
              child: _buildBalanceItem(
                'Total Balance',
                '${balance.totalBalance} sats',
                Colors.blue,
                usdValue: _usdValue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, Color color, {double? usdValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 12,
        //     color: Colors.grey[600],
        //   ),
        // ),
        // SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (usdValue != null) ...[
          SizedBox(height: 2),
          Text(
            '≈ \$${usdValue.toStringAsFixed(2)} USD',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Send',
                    Icons.send,
                    Colors.blue,
                    () => _showSendDialog(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Scan',
                    Icons.qr_code_scanner,
                    Colors.orange,
                    () => _showScanDialog(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Receive',
                    Icons.qr_code,
                    Colors.green,
                    () => _showReceiveDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsPage(),
                      ),
                    );
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            if (_allTransactions.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No transaction records',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._allTransactions.take(5).map((tx) => _buildTransactionItem(tx)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(WalletTransaction tx) {
    return ListTile(
      onTap: () => _showTransactionDetail(tx),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tx.isIncoming ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          tx.isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
          color: tx.isIncoming ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
      title: tx.description?.isNotEmpty == true 
        ? Text(
            tx.description!,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        : Container(
            height: 40, // 给容器一个固定高度
            alignment: Alignment.centerLeft, // 左对齐但垂直居中
            child: Text(
              DateTime.fromMillisecondsSinceEpoch(tx.createdAt * 1000).toString().substring(0, 16),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      subtitle: tx.description?.isNotEmpty == true 
        ? Text(
            DateTime.fromMillisecondsSinceEpoch(tx.createdAt * 1000).toString().substring(0, 16),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${tx.isIncoming ? '+' : '-'}${tx.amount} sats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: tx.isIncoming ? Colors.green : Colors.red,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(tx.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getStatusText(tx.status),
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor(tx.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.confirmed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.expired:
        return Colors.deepOrange; 
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.confirmed:
        return 'Confirmed';
      case TransactionStatus.pending:
        return 'Processing';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.expired:
        return 'Expired';
    }
  }

  void _showTransactionDetail(WalletTransaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailPage(transaction: transaction),
      ),
    );
  }



  Future<void> _refreshData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = 'Refreshing data...';
    });

    try {
      // Refresh balance and transactions
      await _wallet.refreshBalance();
      await _wallet.refreshTransactions();
      
      // Also refresh invoice statuses
      await _wallet.refreshInvoiceStatuses();
      
      // Update transactions list including pending invoices
      await _updateTransactions();
      
      if (mounted) {
        setState(() {
          _statusMessage = 'Data refresh completed';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Refresh failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  void _showSendDialog() {
    final invoiceController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: invoiceController,
              decoration: InputDecoration(
                labelText: 'Lightning Invoice (BOLT11)',
                hintText: 'lnbc...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _parseInvoiceAndConfirm(invoiceController.text),
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  Future<void> _parseInvoiceAndConfirm(String invoice) async {
    if (invoice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid Lightning invoice'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context); // Close first dialog
    
    // Show loading dialog while parsing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Parsing Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Parsing invoice details...'),
          ],
        ),
      ),
    );

    try {
      // Parse invoice to get amount and description
      final invoiceData = await _wallet.parseInvoice(invoice);
      
      Navigator.pop(context); // Close loading dialog
      
      if (invoiceData != null) {
        _showConfirmPaymentDialog(invoice, invoiceData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to parse invoice'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error parsing invoice: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showConfirmPaymentDialog(String invoice, Map<String, dynamic> invoiceData) {
    final amount = invoiceData['amount'] as int;
    final description = invoiceData['description'] as String? ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildPaymentDetailRow('Amount', '$amount sats'),
            if (description.isNotEmpty)
              _buildPaymentDetailRow('Description', description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _sendPayment(invoice, description),
            child: Text('Send Payment'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPayment(String invoice, String description) async {
    Navigator.pop(context); // Close confirm dialog
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Sending Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing payment...'),
          ],
        ),
      ),
    );

    try {
      final transaction = await _wallet.sendPayment(invoice, description: description);
      
      Navigator.pop(context); // Close loading dialog
      
      if (transaction != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          setState(() {}); // Refresh UI
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showReceiveDialog() {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount (sats)',
                hintText: '1000',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _createInvoice(amountController.text, descriptionController.text),
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createInvoice(String amountText, String description) async {
    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context); // Close dialog
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Creating Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating invoice...'),
          ],
        ),
      ),
    );

    try {
      final invoice = await _wallet.createInvoice(amount, description: description.isEmpty ? null : description);
      
      Navigator.pop(context); // Close loading dialog
      
      if (invoice != null) {
        _showInvoiceDialog(invoice);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create invoice'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice creation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showInvoiceDialog(invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invoice Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${invoice.amount} sats'),
            if (invoice.description.isNotEmpty) ...[
              SizedBox(height: 8),
              Text('Description: ${invoice.description}'),
            ],
            SizedBox(height: 16),
            Text('BOLT11 Invoice:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                invoice.bolt11,
                style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Share this invoice to receive payment',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Copy to clipboard functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invoice copied to clipboard')),
              );
            },
            child: Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showScanDialog() {
    final invoiceController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scan QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'QR Scanner not implemented yet.\nPlease paste the invoice manually:',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            TextField(
              controller: invoiceController,
              decoration: InputDecoration(
                labelText: 'Lightning Invoice',
                hintText: 'lnbc...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (invoiceController.text.isNotEmpty) {
                _sendPayment(invoiceController.text, '');
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}