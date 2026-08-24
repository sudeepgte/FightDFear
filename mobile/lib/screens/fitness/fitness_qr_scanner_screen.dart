import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';

class FitnessQrScannerScreen extends StatefulWidget {
  const FitnessQrScannerScreen({super.key});

  static const Color primaryRose = Color(0xFFF43F5E);
  static const Color darkRose = Color(0xFFE11D48);

  @override
  State<FitnessQrScannerScreen> createState() => _FitnessQrScannerScreenState();
}

class _FitnessQrScannerScreenState extends State<FitnessQrScannerScreen> {
  final MobileScannerController _scannerCtrl = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _scannerCtrl.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final raw = barcodes.first.rawValue?.trim();
    if (raw == null || raw.isEmpty) return;

    _processToken(raw);
  }

  Future<void> _processToken(String token) async {
    setState(() => _isProcessing = true);
    final fitness = context.read<AuthState>().services.fitness;

    // Show processing modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: FitnessQrScannerScreen.primaryRose),
                SizedBox(height: 16),
                Text('Verifying workout session...', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final res = await fitness.checkInWithQr(token: token);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // dismiss loading dialog

      if (res['success'] == true) {
        _showResultDialog(
          isSuccess: true,
          alreadyCheckedIn: res['alreadyCheckedIn'] == true,
          message: res['message']?.toString() ?? 'Attendance confirmed successfully!',
          trainerName: res['trainerName']?.toString() ?? 'Coach',
          completedSessions: res['completedSessions'],
          remainingSessions: res['remainingSessions'],
        );
      } else {
        _showResultDialog(
          isSuccess: false,
          alreadyCheckedIn: false,
          message: res['error']?.toString() ?? res['message']?.toString() ?? 'Invalid QR code or session expired.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // dismiss loading
      _showResultDialog(
        isSuccess: false,
        alreadyCheckedIn: false,
        message: 'Network error or invalid QR code: $e',
      );
    }
  }

  void _showResultDialog({
    required bool isSuccess,
    required bool alreadyCheckedIn,
    required String message,
    String? trainerName,
    dynamic completedSessions,
    dynamic remainingSessions,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? (alreadyCheckedIn ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5))
                      : const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess
                      ? (alreadyCheckedIn ? Icons.info_outline : Icons.check_circle_rounded)
                      : Icons.error_outline_rounded,
                  size: 38,
                  color: isSuccess
                      ? (alreadyCheckedIn ? const Color(0xFF2563EB) : const Color(0xFF10B981))
                      : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isSuccess
                    ? (alreadyCheckedIn ? 'Already Checked In!' : 'Attendance Confirmed!')
                    : 'Check-In Failed',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black84, height: 1.4),
              ),
              if (completedSessions != null && remainingSessions != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    'Sessions: $completedSessions attended · $remainingSessions remaining',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF0F172A)),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isSuccess ? const Color(0xFF10B981) : FitnessQrScannerScreen.primaryRose,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(dCtx);
                    if (isSuccess) {
                      Navigator.pop(context, true); // return success to parent screen
                    } else {
                      setState(() => _isProcessing = false); // re-enable scanner
                    }
                  },
                  child: Text(isSuccess ? 'Done' : 'Try Again', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openManualTokenDialog() {
    final tokenCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Enter QR Token', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the session token displayed on your trainer\'s dashboard screen:',
                  style: TextStyle(fontSize: 13, color: Colors.black84)),
              const SizedBox(height: 14),
              TextField(
                controller: tokenCtrl,
                decoration: InputDecoration(
                  hintText: 'e.g. FIT-XXXX-XXXX',
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: FitnessQrScannerScreen.primaryRose,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final token = tokenCtrl.text.trim();
                if (token.isEmpty) return;
                Navigator.pop(dCtx);
                _processToken(token);
              },
              child: const Text('Submit Token'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Scan Coach Workout QR', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: () {
              _scannerCtrl.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () => _scannerCtrl.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerCtrl,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off, size: 56, color: Colors.white70),
                      const SizedBox(height: 16),
                      Text(
                        'Camera error: ${error.errorCode.name}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please ensure camera permissions are granted or enter the token manually.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: FitnessQrScannerScreen.primaryRose),
                        onPressed: _openManualTokenDialog,
                        icon: const Icon(Icons.keyboard),
                        label: const Text('Enter Token Manually'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Viewfinder reticle overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: FitnessQrScannerScreen.primaryRose, width: 3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: FitnessQrScannerScreen.primaryRose.withAlpha(50),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Bottom helper pill & manual entry action
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Align trainer\'s QR code within the frame',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    backgroundColor: Colors.black.withAlpha(140),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _openManualTokenDialog,
                  icon: const Icon(Icons.keyboard_outlined, size: 18),
                  label: const Text('Enter Token Manually', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
