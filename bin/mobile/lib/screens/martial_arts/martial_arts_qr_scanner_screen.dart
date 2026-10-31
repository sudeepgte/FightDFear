import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/martial_arts_service.dart';

class MartialArtsQrScannerScreen extends StatefulWidget {
  const MartialArtsQrScannerScreen({super.key});

  static const Color primaryRose = Color(0xFFF43F5E);

  @override
  State<MartialArtsQrScannerScreen> createState() => _MartialArtsQrScannerScreenState();
}

class _MartialArtsQrScannerScreenState extends State<MartialArtsQrScannerScreen> {
  final MobileScannerController _scannerCtrl = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;
  final _manualCtrl = TextEditingController();

  @override
  void dispose() {
    _scannerCtrl.dispose();
    _manualCtrl.dispose();
    super.dispose();
  }

  Future<void> _processToken(String token) async {
    if (_isProcessing) return;
    final clean = token.trim();
    if (clean.isEmpty) return;
    setState(() => _isProcessing = true);

    final api = MartialArtsService(context.read<AuthState>().api);
    try {
      final res = await api.qrCheckIn(clean);
      if (!mounted) return;
      if (res['success'] == true || res['error'] == null) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: MartialArtsQrScannerScreen.primaryRose, size: 48),
            title: const Text('Attendance Recorded'),
            content: Text(
              'Centre: ${res['centreName'] ?? '—'}\n'
              'Batch: ${res['batchName'] ?? '—'}\n'
              'Date: ${res['date'] ?? '—'}\n'
              'Time: ${res['time'] ?? res['checkedInAt'] ?? '—'}',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(backgroundColor: MartialArtsQrScannerScreen.primaryRose),
                child: const Text('Done'),
              ),
            ],
          ),
        );
        if (mounted) Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Check-in failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Scan Attendance QR'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  controller: _scannerCtrl,
                  onDetect: (capture) {
                    final raw = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
                    if (raw != null) _processToken(raw);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                const Text(
                  'Scan the QR displayed by your Martial Arts centre.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _manualCtrl,
                  decoration: InputDecoration(
                    hintText: 'Or enter session code',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: MartialArtsQrScannerScreen.primaryRose),
                      onPressed: () => _processToken(_manualCtrl.text),
                    ),
                  ),
                  onSubmitted: _processToken,
                ),
                if (_isProcessing) ...[
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(color: MartialArtsQrScannerScreen.primaryRose),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
