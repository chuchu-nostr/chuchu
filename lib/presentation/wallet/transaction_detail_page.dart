import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import '../../core/wallet/model/wallet_invoice.dart';
import '../../core/wallet/wallet.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_image.dart';
import '../../core/widgets/common_toast.dart';

class TransactionDetailPage extends StatefulWidget {
  final WalletTransaction transaction;

  const TransactionDetailPage({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  double? _usdValue;

  @override
  void initState() {
    super.initState();
    _loadUsdValue();
  }

  Future<void> _loadUsdValue() async {
    try {
      final wallet = Wallet.sharedInstance;
      final usdValue = await wallet.satsToUsd(widget.transaction.amount);
      if (mounted) {
        setState(() {
          _usdValue = usdValue;
        });
      }
    } catch (e) {
      // Ignore error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: kTitleColor,
              size: 24,
            ),
          ),
        ),
        title: Text(
          'Transaction Details',
          style: GoogleFonts.inter(
            color: kTitleColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kTitleColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: FutureBuilder<WalletInvoice?>(
        future: _getInvoiceDetails(),
        builder: (context, snapshot) {
          final invoice = snapshot.data;
          final description = widget.transaction.description ?? (invoice?.description ?? '');
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountCard(),
                SizedBox(height: 16),
                if (description.isNotEmpty) ...[
                  _buildDescriptionCard(description),
                  SizedBox(height: 16),
                ],
                _buildTimestampsCard(),
                SizedBox(height: 16),
                if (invoice != null) ...[
                  _buildInvoiceCard(invoice),
                  SizedBox(height: 16),
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
      
      // Only look for invoices if this is an incoming transaction
      // Outgoing transactions (sending payments) don't have invoices
      if (!widget.transaction.isIncoming) {
        return null;
      }
      
      // Try to find invoice by transactionId (invoiceId) or paymentHash
      // This works for both pending invoices and paid invoices
      for (final invoice in invoices) {
        // Match by invoiceId
        if (invoice.invoiceId == widget.transaction.transactionId) {
          return invoice;
        }
        // Match by paymentHash (transactionId might be paymentHash for paid transactions)
        if (invoice.paymentHash == widget.transaction.transactionId) {
          return invoice;
        }
        // Match by transaction's paymentHash
        if (widget.transaction.paymentHash != null && 
            invoice.paymentHash == widget.transaction.paymentHash) {
          return invoice;
        }
        // Also try matching by invoice's bolt11 if transaction has invoice field
        if (widget.transaction.invoice != null && 
            widget.transaction.invoice!.isNotEmpty &&
            invoice.bolt11 == widget.transaction.invoice) {
          return invoice;
        }
      }
      
      return null;
    } catch (e) {
      // If no invoice found, return null
      return null;
    }
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.confirmed:
        return Colors.green[700]!;
      case TransactionStatus.pending:
        return Colors.orange[700]!;
      case TransactionStatus.failed:
        return Colors.red[700]!;
      case TransactionStatus.expired:
        return Colors.deepOrange[700]!;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.confirmed:
        return 'Confirmed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.expired:
        return 'Expired';
    }
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.confirmed:
        return Icons.check_circle;
      case TransactionStatus.pending:
        return Icons.access_time;
      case TransactionStatus.failed:
        return Icons.error;
      case TransactionStatus.expired:
        return Icons.schedule;
    }
  }

  Widget _buildAmountCard() {
    final amount = widget.transaction.amount;
    final formattedAmount = _formatAmount(amount);
    final isIncoming = widget.transaction.isIncoming;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isIncoming ? '+' : '-'}$formattedAmount',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isIncoming ? Color(0xFF10B981) : Color(0xFF1E293B),
                        height: 1.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'sats',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                if (_usdValue != null) ...[
                  SizedBox(height: 4),
                  Text(
                    '≈ \$${_usdValue!.toStringAsFixed(2)} USD',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(widget.transaction.status),
                  size: 16,
                  color: _getStatusColor(widget.transaction.status),
                ),
                SizedBox(width: 6),
                Text(
                  _getStatusText(widget.transaction.status),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _getStatusColor(widget.transaction.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(String description) {
    // Split description by semicolon and filter out empty strings
    final parts = description.split(';').where((part) => part.trim().isNotEmpty).toList();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          SizedBox(height: 8),
          if (parts.length > 1)
            ...parts.asMap().entries.map((entry) => Padding(
                  padding: EdgeInsets.only(bottom: entry.key < parts.length - 1 ? 4 : 0),
                  child: Text(
                    entry.value.trim(),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                ))
          else
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimestampsCard() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(widget.transaction.createdAt * 1000);
    final formattedDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final formattedTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timestamps',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Created',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Text(
                '$formattedDate $formattedTime',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: kTitleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(WalletInvoice invoice) {
    String _formatInvoiceStatus(InvoiceStatus status) {
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

    Color _getInvoiceStatusColor(InvoiceStatus status) {
      switch (status) {
        case InvoiceStatus.pending:
          return Colors.orange[700]!;
        case InvoiceStatus.paid:
          return Colors.green[700]!;
        case InvoiceStatus.expired:
          return Colors.deepOrange[700]!;
        case InvoiceStatus.cancelled:
          return Colors.red[700]!;
      }
    }

    String _formatExpiryTime(int expiresAt) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
      final formattedDate = '${expiryDate.year}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}';
      final formattedTime = '${expiryDate.hour.toString().padLeft(2, '0')}:${expiryDate.minute.toString().padLeft(2, '0')}:${expiryDate.second.toString().padLeft(2, '0')}';
      return '$formattedDate $formattedTime';
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Invoice Information',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getInvoiceStatusColor(invoice.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatInvoiceStatus(invoice.status),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getInvoiceStatusColor(invoice.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (invoice.bolt11.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'BOLT11 Invoice',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _copyToClipboard(invoice.bolt11),
                  child: CommonImage(
                    iconName: 'copy_icon.png',
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                invoice.bolt11,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
          if (invoice.paymentHash.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Payment Hash',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => _copyToClipboard(invoice.paymentHash),
                  child: CommonImage(
                    iconName: 'copy_icon.png',
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            SelectableText(
              invoice.paymentHash,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 16),
          ],
          Row(
            children: [
              Text(
                'Expires At',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Text(
                _formatExpiryTime(invoice.expiresAt),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: invoice.status == InvoiceStatus.expired 
                      ? Colors.deepOrange[700] 
                      : kTitleColor,
                ),
              ),
            ],
          ),
          if (invoice.paidAt != null) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Paid At',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Spacer(),
                Text(
                  _formatExpiryTime(invoice.paidAt!),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    CommonToast.instance.show(context, 'Copied to clipboard', toastType: ToastType.success);
  }

}
