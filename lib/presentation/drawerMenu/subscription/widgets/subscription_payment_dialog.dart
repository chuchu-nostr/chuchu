import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/wallet/wallet.dart';
import '../../../../core/widgets/common_toast.dart';

class SubscriptionPaymentDialog extends StatefulWidget {
  final String invoice;
  final String bolt11;
  final int amount;
  final String description;
  final DateTime? expiresAt;
  final VoidCallback? onPaymentSuccess;

  const SubscriptionPaymentDialog({
    super.key,
    required this.invoice,
    required this.bolt11,
    required this.amount,
    required this.description,
    this.expiresAt,
    this.onPaymentSuccess,
  });

  @override
  State<SubscriptionPaymentDialog> createState() => _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  bool _isPaying = false;
  String _selectedPaymentMethod = 'wallet';
  int _currentStep = 1; // 1: Show payment info, 2: Select wallet type
  bool _showQRCode = false; // Control QR code display

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStepIndicator(),
                const SizedBox(height: 20),
                if (_currentStep == 1) ...[
                  _buildInvoiceInfo(),
                  const SizedBox(height: 24),
                  _buildStep1Buttons(),
                ] else ...[
                  _buildPaymentMethods(),
                  const SizedBox(height: 24),
                  _buildStep2Buttons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.payment,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _currentStep == 1 ? 'Payment Information' : 'Select Payment Method',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepItem(1, 'Payment Info', _currentStep >= 1),
        Container(
          height: 2,
          width: 40,
          color: _currentStep >= 2 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
        _buildStepItem(2, 'Select Wallet', _currentStep >= 2),
      ],
    );
  }

  Widget _buildStepItem(int step, String label, bool isActive) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Amount', '${widget.amount} sats'),
          _buildInfoRow('Description', widget.description),
          if (widget.expiresAt != null) ...[
            _buildInfoRow('Expires', _formatExpirationTime(widget.expiresAt!)),
          ],
          const SizedBox(height: 12),
          _buildBolt11Section(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QR Code',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: _buildQRCode(),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCode() {
    // For now, we'll create a simple placeholder QR code
    // In a real implementation, you would use a QR code package like qr_flutter
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'QR Code',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.amount} sats',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBolt11Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BOLT11 Invoice:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.bolt11,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.bolt11));
                  CommonToast.instance.show(context, 'Invoice copied to clipboard');
                },
                icon: const Icon(Icons.copy, size: 20),
                tooltip: 'Copy invoice',
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showQRCode = !_showQRCode;
                  });
                },
                icon: Icon(
                  _showQRCode ? Icons.visibility_off : Icons.qr_code,
                  size: 20,
                ),
                tooltip: _showQRCode ? 'Hide QR code' : 'Show QR code',
              ),
            ],
          ),
        ),
        if (_showQRCode) ...[
          const SizedBox(height: 12),
          _buildQRCodeSection(),
        ],
      ],
    );
  }

  String _formatExpirationTime(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);
    
    if (difference.isNegative) {
      return 'Expired';
    }
    
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;
    
    if (days > 0) {
      return '${days}d ${hours % 24}h ${minutes % 60}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes % 60}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'wallet',
          'Internal Wallet',
          'Pay using your connected wallet',
          Icons.account_balance_wallet,
        ),
        const SizedBox(height: 8),
        _buildPaymentOption(
          'external',
          'External Wallet',
          'Pay using external Lightning wallet',
          Icons.payment,
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected 
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1Buttons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 2;
              });
            },
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Buttons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isPaying ? null : () {
              setState(() {
                _currentStep = 1;
              });
            },
            child: const Text('Back'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isPaying ? null : _handlePayment,
            child: _isPaying 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Pay Now'),
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    setState(() {
      _isPaying = true;
    });

    try {
      switch (_selectedPaymentMethod) {
        case 'wallet':
          await _payWithWallet();
          break;
        case 'external':
          await _payWithExternalWallet();
          break;
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Payment failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isPaying = false;
        });
      }
    }
  }

  Future<void> _payWithWallet() async {
    try {
      final wallet = Wallet();
      
      if (!wallet.isConnected) {
        CommonToast.instance.show(context, 'Wallet not connected');
        return;
      }

      // Pay using internal wallet
      final transaction = await wallet.sendPayment(
        widget.bolt11,
        description: widget.description,
      );

      if (transaction != null) {
        CommonToast.instance.show(context, 'Payment successful!');
        Navigator.of(context).pop();
        widget.onPaymentSuccess?.call();
      } else {
        CommonToast.instance.show(context, 'Payment failed');
      }
    } catch (e) {
      CommonToast.instance.show(context, 'Payment error: ${e.toString()}');
    }
  }

  Future<void> _payWithExternalWallet() async {
    // Copy invoice to clipboard for external wallet
    await Clipboard.setData(ClipboardData(text: widget.bolt11));
    CommonToast.instance.show(
      context, 
      'Invoice copied to clipboard. Please paste it in your external Lightning wallet.',
    );
    
    // Show instructions
    _showExternalWalletInstructions();
  }

  void _showExternalWalletInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Wallet Payment'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The invoice has been copied to your clipboard.'),
            SizedBox(height: 12),
            Text('To pay with an external Lightning wallet:'),
            SizedBox(height: 8),
            Text('1. Open your Lightning wallet app'),
            Text('2. Look for "Pay Invoice" or "Scan QR" option'),
            Text('3. Paste the invoice or scan the QR code'),
            Text('4. Confirm the payment'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}
