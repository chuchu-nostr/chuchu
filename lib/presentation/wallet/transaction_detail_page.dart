import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/wallet/model/wallet_transaction.dart';
import '../../core/wallet/model/wallet_invoice.dart';
import '../../core/wallet/wallet.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_image.dart';

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
                _buildTransactionIdCard(),
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
      return invoices.where((invoice) => invoice.invoiceId == widget.transaction.transactionId).firstOrNull;
    } catch (e) {
      return null;
    }
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildAmountCard() {
    final amount = widget.transaction.amount;
    final formattedAmount = _formatAmount(amount);
    final isIncoming = widget.transaction.isIncoming;
    final isConfirmed = widget.transaction.status == TransactionStatus.confirmed;

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
          if (isConfirmed)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFD0FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF007A55),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Confirmed',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF007A55),
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
    final hasMultipleParts = parts.length > 1;

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
          if (hasMultipleParts)
            ...parts.map((part) => Padding(
                  padding: EdgeInsets.only(bottom: parts.indexOf(part) < parts.length - 1 ? 4 : 0),
                  child: Text(
                    part.trim(),
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

  Widget _buildTransactionIdCard() {
    final transactionId = widget.transaction.transactionId;

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
                'Transaction ID',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () => _copyToClipboard(transactionId),
                child: CommonImage(
                  iconName: 'copy_icon.png',
                  size: 20,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SelectableText(
            transactionId,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

}
