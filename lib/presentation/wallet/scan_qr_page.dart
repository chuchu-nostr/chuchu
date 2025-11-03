import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/wallet/wallet.dart';

/// QR Code Scanner Page
/// Scans QR codes to get Lightning invoices
class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  
  bool _isProcessing = false;
  String? _lastScannedCode;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleScan(BarcodeCapture capture) {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isEmpty) return;
    
    final Barcode barcode = barcodes.first;
    final String? code = barcode.rawValue;
    
    if (code == null || code.isEmpty) return;
    
    // Prevent duplicate scans
    if (code == _lastScannedCode) return;
    _lastScannedCode = code;
    
    setState(() {
      _isProcessing = true;
    });
    
    // Check if it's a Lightning invoice (BOLT11)
    if (_isLightningInvoice(code)) {
      _processLightningInvoice(code);
    } else {
      // Show error if not a Lightning invoice
      _showInvalidInvoiceDialog(code);
    }
  }

  /// Check if the scanned code is a Lightning invoice (BOLT11)
  bool _isLightningInvoice(String code) {
    // BOLT11 invoices start with lnbc, lntb, or lnbcrt
    final RegExp regExp = RegExp(r'^(lnbc|lntb|lnbcrt)[0-9a-zA-Z]+$');
    return regExp.hasMatch(code.trim());
  }

  /// Process the Lightning invoice
  Future<void> _processLightningInvoice(String invoice) async {
    // Stop the scanner
    await controller.stop();
    
    // Return the invoice to the previous page
    Navigator.of(context).pop(invoice);
  }

  /// Show dialog for invalid invoice
  void _showInvalidInvoiceDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Invoice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('The scanned QR code does not appear to be a Lightning invoice.'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                code.length > 100 ? '${code.substring(0, 100)}...' : code,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Lightning invoices should start with "lnbc", "lntb", or "lnbcrt".',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isProcessing = false;
                _lastScannedCode = null;
              });
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Scanner view
          MobileScanner(
            controller: controller,
            onDetect: _handleScan,
          ),
          
          // Overlay with scanning area
          _buildOverlay(),
          
          // Processing indicator
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Processing invoice...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build scanning overlay with guide
  Widget _buildOverlay() {
    return CustomPaint(
      painter: ScannerOverlayPainter(),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.orange, width: 4),
                          left: BorderSide(color: Colors.orange, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.orange, width: 4),
                          right: BorderSide(color: Colors.orange, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.orange, width: 4),
                          left: BorderSide(color: Colors.orange, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.orange, width: 4),
                          right: BorderSide(color: Colors.orange, width: 4),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Position the Lightning invoice QR code\nwithin the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Draw dark overlay
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Calculate scanning area (center square)
    final scanSize = 250.0;
    final left = (size.width - scanSize) / 2;
    final top = (size.height - scanSize) / 2;
    final scanArea = Rect.fromLTWH(left, top, scanSize, scanSize);

    // Clear the scanning area
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;
    canvas.drawRect(scanArea, clearPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

