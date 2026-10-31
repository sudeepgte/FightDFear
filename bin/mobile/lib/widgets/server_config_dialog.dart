import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/api_config.dart';
import '../services/auth_state.dart';

class ServerConfigDialog extends StatefulWidget {
  const ServerConfigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const ServerConfigDialog(),
    );
  }

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late final TextEditingController _urlCtrl;
  bool _testing = false;
  String? _testResult;
  bool _testSuccess = false;

  @override
  void initState() {
    super.initState();
    final current = context.read<AuthState>().apiBaseUrl;
    _urlCtrl = TextEditingController(text: current);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final target = _urlCtrl.text.trim();
    if (target.isEmpty) return;
    setState(() {
      _testing = true;
      _testResult = null;
    });
    final auth = context.read<AuthState>();
    final ok = await auth.pingServer(target);
    if (!mounted) return;
    setState(() {
      _testing = false;
      _testSuccess = ok;
      _testResult = ok
          ? 'Connected successfully! Server is online.'
          : 'Cannot reach server at $target. Make sure backend is running on port 8084 and phone is on the same Wi-Fi.';
    });
  }

  Future<void> _save() async {
    final target = _urlCtrl.text.trim();
    final auth = context.read<AuthState>();
    await auth.setServerUrl(target.isEmpty ? null : target);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Server URL updated to: ${auth.apiBaseUrl}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUrl = context.watch<AuthState>().apiBaseUrl;

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.dns_outlined, color: Color(0xFFF43F5E)),
          SizedBox(width: 10),
          Text('Server Connection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select or enter the backend server URL (port 8084):',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlCtrl,
              decoration: InputDecoration(
                labelText: 'Server Base URL',
                hintText: 'http://10.222.42.179:8084',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => _urlCtrl.clear(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Presets:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ActionChip(
                  label: const Text('My PC Wi-Fi', style: TextStyle(fontSize: 11)),
                  avatar: const Icon(Icons.wifi, size: 14),
                  onPressed: () {
                    _urlCtrl.text = ApiConfig.defaultLocalLanHost;
                    _testConnection();
                  },
                ),
                ActionChip(
                  label: const Text('Emulator (10.0.2.2)', style: TextStyle(fontSize: 11)),
                  avatar: const Icon(Icons.phone_android, size: 14),
                  onPressed: () {
                    _urlCtrl.text = ApiConfig.androidEmulatorHost;
                    _testConnection();
                  },
                ),
                ActionChip(
                  label: const Text('Localhost', style: TextStyle(fontSize: 11)),
                  avatar: const Icon(Icons.laptop, size: 14),
                  onPressed: () {
                    _urlCtrl.text = ApiConfig.localhostHost;
                    _testConnection();
                  },
                ),
                ActionChip(
                  label: const Text('Cloud Server', style: TextStyle(fontSize: 11)),
                  avatar: const Icon(Icons.cloud_outlined, size: 14),
                  onPressed: () {
                    _urlCtrl.text = ApiConfig.productionHost;
                    _testConnection();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _testing ? null : _testConnection,
              icon: _testing
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.network_check, size: 18),
              label: Text(_testing ? 'Testing...' : 'Test Connection'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _testSuccess ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _testSuccess ? Colors.green.shade300 : Colors.red.shade300,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _testSuccess ? Icons.check_circle : Icons.error_outline,
                      color: _testSuccess ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _testSuccess ? Colors.green.shade900 : Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Active URL: $currentUrl',
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF43F5E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Save & Apply'),
        ),
      ],
    );
  }
}
