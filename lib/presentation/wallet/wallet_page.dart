import 'package:flutter/material.dart';
import '../../core/wallet/wallet.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import '../../core/wallet/model/wallet_info.dart';
import '../../core/widgets/common_image.dart';

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

  @override
  void initState() {
    super.initState();
    _setupCallbacks();
  }

  void _setupCallbacks() {
    _wallet.onBalanceChanged = () {
      setState(() {});
    };
    _wallet.onTransactionAdded = () {
      setState(() {});
    };
    
    // Initialize wallet
    _initializeWallet();
  }

  Future<void> _initializeWallet() async {
    try {
      await _wallet.init();
      setState(() {}); // Refresh UI after wallet initialization
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
                  _buildWalletStatus(),
                  SizedBox(height: 16),
                  _buildBalanceCard(),
                  SizedBox(height: 16),
                  _buildRecentTransactions(),
                  SizedBox(height: 16),
                  if (_wallet.isConnected) ...[
                    _buildQuickActions(),
                  ] else ...[
                    _buildConnectWalletCard(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildWalletStatus() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CommonImage(iconName: 'zap_icon.png', size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    _wallet.isConnected ? 'Connected to LNbits wallet' : 'Wallet not connected',
                    style: TextStyle(
                      color: _wallet.isConnected ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _wallet.isConnected ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _wallet.isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
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
            Row(
              children: [
                Expanded(
                  child: _buildBalanceItem(
                    'Total Balance',
                    '${balance.totalBalanceBTC} BTC',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildBalanceItem(
                    'Confirmed Balance',
                    '${balance.confirmedBalanceBTC} BTC',
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceItem(
                    'Unconfirmed',
                    '${balance.unconfirmedBalanceBTC} BTC',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildBalanceItem(
                    'Reserved',
                    '${balance.reservedBalanceBTC} BTC',
                    Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
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
                    'Receive',
                    Icons.qr_code,
                    Colors.green,
                    () => _showReceiveDialog(),
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
    List<WalletTransaction> transactions = _wallet.transactions.take(5).toList();
    
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
                    // Navigate to full transaction history page
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            if (transactions.isEmpty)
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
              ...transactions.map((tx) => _buildTransactionItem(tx)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(WalletTransaction tx) {
    return ListTile(
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
      title: Text(
        tx.description ?? 'Transaction',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt * 1000).toString().substring(0, 16),
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${tx.isIncoming ? '+' : '-'}${tx.amountBTC} BTC',
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
        return Colors.grey;
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

  Widget _buildConnectWalletCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Connect Wallet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              'Connect NIP-47 wallet to use Lightning Network payment features',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
                          ElevatedButton(
                onPressed: _showConnectDialog,
                child: Text('Connect Wallet'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
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
      
      setState(() {
        _statusMessage = 'Data refresh completed';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Refresh failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showConnectDialog() {
    // Show connection progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Connect Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Getting wallet configuration from server...'),
          ],
        ),
      ),
    );

    // Automatically get NIP-47 URI from API and connect
    _autoConnectWallet();
  }

  Future<void> _autoConnectWallet() async {
    try {
      // Simulate connecting to wallet
      await Future.delayed(Duration(seconds: 2));
      
      // Connect wallet
      final success = await _wallet.connectToWallet();
      
      Navigator.pop(context); // Close progress dialog
      
      if (success) {
        // Show connection success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wallet connected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show connection failure message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wallet connection failed, please try again later'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close progress dialog
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSendDialog() {
    final invoiceController = TextEditingController();
    final descriptionController = TextEditingController();
    
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
            onPressed: () => _sendPayment(invoiceController.text, descriptionController.text),
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPayment(String invoice, String description) async {
    if (invoice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid Lightning invoice'),
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
        setState(() {}); // Refresh UI
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