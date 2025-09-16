import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import '../../core/wallet/model/wallet_invoice.dart';
import '../../core/wallet/wallet.dart';

class TransactionDetailPage extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionDetailPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<WalletInvoice?>(
        future: _getInvoiceDetails(),
        builder: (context, snapshot) {
          final invoice = snapshot.data;
          final isInvoice = invoice != null;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountCard(isInvoice ? invoice : null),
                SizedBox(height: 16),
                if (isInvoice) ...[
                  _buildInvoiceDetailsCard(invoice),
                ] else ...[
                  _buildTimestampCard(null),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<WalletInvoice?> _getInvoiceDetails() async {
    try {
      final wallet = Wallet.sharedInstance;
      final invoices = await wallet.getInvoices();
      return invoices.where((invoice) => invoice.invoiceId == transaction.transactionId).firstOrNull;
    } catch (e) {
      return null;
    }
  }

  Widget _buildAmountCard(WalletInvoice? invoice) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${transaction.isIncoming ? '+' : '-'}${transaction.amount} sats',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: transaction.isIncoming ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceDetailsCard(WalletInvoice invoice) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(transaction.createdAt * 1000);
    final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRowWithCopy('Payment Hash', invoice.paymentHash),
            if (invoice.description?.isNotEmpty == true)
              _buildDetailRow('Description', invoice.description!),
            _buildDetailRow('Status', _getInvoiceStatusText(invoice.status)),
            if (invoice.preimage != null)
              _buildDetailRow('Preimage', invoice.preimage!),
            SizedBox(height: 16),
            // BOLT11 Section
            Row(
              children: [
                Text(
                  'BOLT11 Invoice',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.copy, size: 18),
                  onPressed: () => _copyToClipboard(invoice.bolt11),
                  tooltip: 'Copy BOLT11',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                invoice.bolt11,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(height: 16),
            // Timestamps Section
            Text(
              'Timestamps',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            _buildDetailRow('Created', '$formattedDate $formattedTime'),
            _buildDetailRow('Expires', _formatTimestamp(invoice.expiresAt)),
            if (invoice.paidAt != null) ...[
              _buildDetailRow('Paid At', _formatTimestamp(invoice.paidAt!)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildDetailRowWithCopy(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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
          IconButton(
            icon: Icon(Icons.copy, size: 16),
            onPressed: () => _copyToClipboard(value),
            tooltip: 'Copy $label',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestampCard(WalletInvoice? invoice) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(transaction.createdAt * 1000);
    final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timestamps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Created', '$formattedDate $formattedTime'),
            if (invoice != null) ...[
              _buildDetailRow('Expires', _formatTimestamp(invoice.expiresAt)),
              if (invoice.paidAt != null) ...[
                _buildDetailRow('Paid At', _formatTimestamp(invoice.paidAt!)),
              ],
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    return '$formattedDate $formattedTime';
  }

  Color _getStatusColor() {
    switch (transaction.status) {
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

  String _getStatusText() {
    switch (transaction.status) {
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

  String _getInvoiceStatusText(InvoiceStatus status) {
    switch (status) {
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.expired:
        return 'Expired';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // Note: In a real app, you might want to show a snackbar here
  }
}
