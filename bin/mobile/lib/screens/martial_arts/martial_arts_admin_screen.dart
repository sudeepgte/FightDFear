import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/martial_arts_admin_service.dart';

class MartialArtsAdminScreen extends StatefulWidget {
  const MartialArtsAdminScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);

  @override
  State<MartialArtsAdminScreen> createState() => _MartialArtsAdminScreenState();
}

class _MartialArtsAdminScreenState extends State<MartialArtsAdminScreen> {
  late final MartialArtsAdminService _admin;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loggedIn = false;
  bool _busy = false;
  bool _loadingList = false;
  String _tab = 'pending';
  String? _error;
  List<Map<String, dynamic>> _centres = [];

  @override
  void initState() {
    super.initState();
    _admin = MartialArtsAdminService(context.read<AuthState>().api);
    _bootstrap();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    _loggedIn = await _admin.isLoggedIn();
    if (_loggedIn) await _load();
    if (mounted) setState(() {});
  }

  Future<void> _login() async {
    setState(() => _busy = true);
    final res = await _admin.login(email: _emailCtrl.text.trim(), password: _passCtrl.text);
    if (!mounted) return;
    if (res['success'] == true) {
      _loggedIn = true;
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Login failed')),
      );
    }
    setState(() => _busy = false);
  }

  Future<void> _load() async {
    setState(() {
      _loadingList = true;
      _error = null;
    });
    final res = await _admin.listCentres(status: _tab);
    if (!mounted) return;
    if (res['success'] == true) {
      _centres = (res['centres'] is List)
          ? (res['centres'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
          : [];
    } else {
      _centres = [];
      _error = res['error']?.toString() ?? 'Could not load centres';
      if (res['error']?.toString().toLowerCase().contains('login') == true ||
          res['error']?.toString().toLowerCase().contains('unauthorized') == true) {
        _loggedIn = false;
      }
    }
    setState(() => _loadingList = false);
  }

  String _statusLabel(Map<String, dynamic> c) {
    final label = c['centreProfileStatusLabel']?.toString();
    if (label != null && label.isNotEmpty) return label;
    return c['centreProfileStatus']?.toString() ?? (_tab == 'pending' ? 'Pending' : 'Approved');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin — Self-Defense Trainers'),
        actions: [
          if (_loggedIn)
            IconButton(
              onPressed: () async {
                await _admin.logout();
                setState(() {
                  _loggedIn = false;
                  _centres = [];
                });
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: !_loggedIn
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Admin email')),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _login,
                    style: FilledButton.styleFrom(backgroundColor: MartialArtsAdminScreen.primary),
                    child: _busy ? const CircularProgressIndicator() : const Text('Sign in'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'pending', label: Text('Pending')),
                      ButtonSegment(value: 'approved', label: Text('Approved')),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (s) {
                      _tab = s.first;
                      _load();
                    },
                  ),
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(_error!, style: const TextStyle(color: Colors.red)),
                  ),
                Expanded(
                  child: _loadingList
                      ? const Center(child: CircularProgressIndicator())
                      : _centres.isEmpty
                          ? Center(child: Text('No $_tab trainers / centres'))
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: _centres.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final c = _centres[i];
                                  final id = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
                                  final pct = c['profileCompletionPct'];
                                  final programs = c['programs'] is List ? c['programs'] as List : const [];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  c['name']?.toString() ?? '',
                                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                                ),
                                              ),
                                              Chip(
                                                label: Text(_statusLabel(c), style: const TextStyle(fontSize: 11)),
                                                visualDensity: VisualDensity.compact,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text('${c['email'] ?? ''} · ${c['phoneNumber'] ?? ''}'),
                                          Text(c['location']?.toString().isNotEmpty == true
                                              ? c['location'].toString()
                                              : 'Location not set'),
                                          if (pct != null) Text('Profile $pct% · ${programs.length} program(s)'),
                                          if (_tab == 'pending' && id != null) ...[
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                FilledButton.icon(
                                                  onPressed: () async {
                                                    final res = await _admin.approve(id);
                                                    if (!mounted) return;
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          res['success'] == true
                                                              ? 'Approved'
                                                              : (res['error']?.toString() ?? 'Approve failed'),
                                                        ),
                                                      ),
                                                    );
                                                    await _load();
                                                  },
                                                  icon: const Icon(Icons.check, size: 18),
                                                  label: const Text('Approve'),
                                                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
                                                ),
                                                const SizedBox(width: 8),
                                                OutlinedButton.icon(
                                                  onPressed: () async {
                                                    final res = await _admin.reject(id);
                                                    if (!mounted) return;
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          res['success'] == true
                                                              ? 'Rejected'
                                                              : (res['error']?.toString() ?? 'Reject failed'),
                                                        ),
                                                      ),
                                                    );
                                                    await _load();
                                                  },
                                                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                                  label: const Text('Reject'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
    );
  }
}
