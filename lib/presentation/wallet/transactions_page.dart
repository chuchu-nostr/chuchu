import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/wallet/wallet.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import 'transaction_detail_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final Wallet _wallet = Wallet();
  List<WalletTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final transactions = await _wallet.getAllTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load transactions: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshTransactions() async {
    await _wallet.refreshTransactions();
    await _loadTransactions();
  }

  void _showTransactionDetail(WalletTransaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailPage(transaction: transaction),
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
            height: 40, // Set fixed height for container
            alignment: Alignment.centerLeft, // Left align with vertical center
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
          SizedBox(height: 2),
          _buildStatusChip(tx.status),
          if (tx.fee > 0) ...[
            SizedBox(height: 2),
            Text(
              'Fee: ${tx.fee} sats',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case TransactionStatus.confirmed:
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green[700]!;
        statusText = 'Confirmed';
        break;
      case TransactionStatus.pending:
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[700]!;
        statusText = 'Pending';
        break;
      case TransactionStatus.failed:
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red[700]!;
        statusText = 'Failed';
        break;
      case TransactionStatus.expired:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey[700]!;
        statusText = 'Expired';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }



  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your transaction history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshTransactions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _transactions.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _refreshTransactions,
                  child: ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(_transactions[index]);
                    },
                  ),
                ),
    );
  }
}
