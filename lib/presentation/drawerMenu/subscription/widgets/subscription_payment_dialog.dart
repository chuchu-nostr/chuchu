import 'dart:async';
import 'dart:ui';
import 'package:chuchu/core/theme/app_theme.dart';
import 'package:chuchu/core/utils/widget_tool_utils.dart';
import 'package:chuchu/core/widgets/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
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

  /// Show the payment dialog with blur effect
  static Future<T?> show<T>({
    required BuildContext context,
    required String invoice,
    required String bolt11,
    required int amount,
    required String description,
    DateTime? expiresAt,
    VoidCallback? onPaymentSuccess,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Payment Dialog',
      barrierColor: Colors.transparent,
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            Center(
              child: SafeArea(
                child: SubscriptionPaymentDialog(
                  invoice: invoice,
                  bolt11: bolt11,
                  amount: amount,
                  description: description,
                  expiresAt: expiresAt,
                  onPaymentSuccess: onPaymentSuccess,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  State<SubscriptionPaymentDialog> createState() =>
      _SubscriptionPaymentDialogState();
}

class _SubscriptionPaymentDialogState extends State<SubscriptionPaymentDialog> {
  bool _isPaying = false;
  String _selectedPaymentMethod = 'wallet';
  int _currentStep = 1; // 1: Show payment info, 2: Select wallet type
  bool _showQRCode = false; // Control QR code display
  bool _isExternalWalletDialogOpen =
      false; // Track external wallet dialog state

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
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
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.black87,
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
          height: 1,
          width: 40,
          color:
              _currentStep >= 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ).setPadding(EdgeInsets.symmetric(horizontal: 12)),
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
            color:
                isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color:
                    isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color:
                isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kBgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice Details',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            // width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 14,
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
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        // ),
      ),
      child: QrImageView(
        data: widget.bolt11,
        version: QrVersions.auto,
        size: 250.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        errorStateBuilder: (context, error) {
          return Container(
            width: 184,
            height: 184,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 40, color: Colors.grey[600]),
                const SizedBox(height: 8),
                Text(
                  'QR Error',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBolt11Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BOLT11 Invoice:',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
            // border: Border.all(
            //   color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            // ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.bolt11,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.bolt11));
                  CommonToast.instance.show(
                    context,
                    'Invoice copied to clipboard',
                  );
                },
                iconSize: 20,
                icon: CommonImage(
                  iconName: 'copy_icon.png',
                  size: 20,
                  color: Theme.of(context).colorScheme.outline,
                ),
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
                  color: Theme.of(context).colorScheme.outline,
                ),
                tooltip: _showQRCode ? 'Hide QR code' : 'Show QR code',
              ),
            ],
          ),
        ),
        if (_showQRCode) ...[const SizedBox(height: 12), _buildQRCodeSection()],
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
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == value;
    final isDisabled = _isPaying; // Disable during payment

    return InkWell(
      onTap:
          isDisabled
              ? null
              : () {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDisabled
                  ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                  : (isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isDisabled
                    ? Theme.of(context).colorScheme.outline.withOpacity(0.2)
                    : (isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.3)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isDisabled
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                      : (isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      color:
                          isDisabled
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.4)
                              : (isSelected
                                  ? Color(0xFF861043)
                                  : Colors.black87),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color:
                          isDisabled
                              ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.4)
                              : (isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged:
                  isDisabled
                      ? null
                      : (value) {
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
          child: Container(
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 50,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _currentStep = 2;
                  });
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: getBrandGradientHorizontal(),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Buttons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            child: OutlinedButton(
              onPressed:
                  _isPaying
                      ? null
                      : () {
                        setState(() {
                          _currentStep = 1;
                        });
                      },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                side: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 50,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: _isPaying ? null : _handlePayment,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: _isPaying ? null : getBrandGradientHorizontal(),
                    color:
                        _isPaying
                            ? Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.3)
                            : null,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isPaying)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else ...[
                        Text(
                          'Pay Now',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.payment_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
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
      // Initialize wallet instance
      final wallet = Wallet();

      // Check wallet connection status
      if (!wallet.isConnected) {
        CommonToast.instance.show(context, 'Wallet not connected');
        return;
      }

      // Execute payment using internal wallet
      final transaction = await wallet.sendPayment(
        widget.bolt11,
        description: widget.description,
      );

      // Handle payment result
      if (transaction != null) {
        // Wait for payment status callback to complete
        await _waitForPaymentStatusCallback();
      } else {
        // Payment failed - show error message
        CommonToast.instance.show(context, 'Payment failed');
      }
    } catch (e) {
      // Handle any unexpected errors during payment
      CommonToast.instance.show(context, 'Payment error: ${e.toString()}');
    }
  }

  /// Wait for payment status callback to complete
  Future<void> _waitForPaymentStatusCallback() async {
    final wallet = Wallet();

    // Check wallet connection status
    if (!wallet.isConnected) {
      CommonToast.instance.show(context, 'Wallet not connected');
      return;
    }
    final completer = Completer<void>();

    // Set up payment status callback
    wallet.onPaymentStatusChanged = (paymentHash, isPaid, details) {
      if (isPaid) {
        // Handle payment success - update UI, etc.
        widget.onPaymentSuccess?.call();

        // Complete the completer to signal callback is done
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    };

    // Wait for the callback to complete (with timeout)
    try {
      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('Payment status callback timeout');
          // Return null instead of throwing exception
          return null;
        },
      );
    } catch (e) {
      print('Error waiting for payment status callback: $e');
    }
  }

  Future<void> _payWithExternalWallet() async {
    // return _showExternalWalletInstructions();

    // Initialize wallet instance
    final wallet = Wallet();

    // Check wallet connection status
    if (!wallet.isConnected) {
      CommonToast.instance.show(context, 'Wallet not connected');
      return;
    }

    // Set up payment status callback
    wallet.onPaymentStatusChanged = (paymentHash, isPaid, details) {
      if (isPaid) {
        // Handle payment success - update UI, etc.
        widget.onPaymentSuccess?.call();

        // Check if external wallet dialog is still open and close it
        if (_isExternalWalletDialogOpen && mounted) {
          Navigator.of(context).pop();
          _isExternalWalletDialogOpen = false;
        }
      }
    };

    _showExternalWalletInstructions();
  }

  void _showExternalWalletInstructions() {
    // Mark that external wallet dialog is open
    _isExternalWalletDialogOpen = true;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'External Wallet Instructions',
      barrierColor: Colors.transparent,
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
            Center(
              child: SafeArea(
                child: Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFDF2F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.payment,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'External Wallet Payment',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _isExternalWalletDialogOpen = false;
                                  },
                                  icon: const Icon(Icons.close),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey[100],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Instructions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFFDF2F8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFFCE7F3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Payment Instructions',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInstructionStep(
                                    '1',
                                    'Open your Lightning wallet app',
                                  ),
                                  _buildInstructionStep(
                                    '2',
                                    'Look for "Pay Invoice" or "Scan QR" option',
                                  ),
                                  _buildInstructionStep(
                                    '3',
                                    'Paste the invoice or scan the QR code',
                                  ),
                                  _buildInstructionStep(
                                    '4',
                                    'Confirm the payment',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Invoice Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CommonImage(
                                        iconName: 'record_icon.png',
                                        size: 20,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Invoice',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await Clipboard.setData(
                                            ClipboardData(text: widget.bolt11),
                                          );
                                          CommonToast.instance.show(
                                            context,
                                            'Invoice copied to clipboard',
                                          );
                                        },
                                        icon: const Icon(Icons.copy, size: 16),
                                        label: const Text('Copy'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          minimumSize: const Size(0, 32),
                                          textStyle: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kBgLight,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color(0xFFF1F5F9),
                                      ),
                                    ),
                                    child: Text(
                                      widget.bolt11,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        letterSpacing: 0.1,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // QR Code Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                // color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CommonImage(
                                        iconName: 'qr_code_icon.png',
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'QR Code',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildExternalQRCode(),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.green[200]!,
                                      ),
                                    ),
                                    child: Text(
                                      'Amount: ${widget.amount} sats',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _isExternalWalletDialogOpen = false;
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: getBrandGradientHorizontal(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Got it!',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Color(0xFFFCCEE8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFC6005C),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExternalQRCode() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: QrImageView(
          data: widget.bolt11,
          version: QrVersions.auto,
          size: 250.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          errorStateBuilder: (context, error) {
            return Container(
              width: 184,
              height: 184,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 40, color: Colors.grey[600]),
                  const SizedBox(height: 8),
                  Text(
                    'QR Error',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
