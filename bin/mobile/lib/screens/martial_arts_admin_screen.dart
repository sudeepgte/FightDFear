import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/martial_arts_admin_service.dart';

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
  bool _loggedIn = false;
  bool _busy = false;
  String _tab = 'pending';
  List<Map<String, dynamic>> _centres = [];

  @override
  void initState() {
    super.initState();
    _admin = MartialArtsAdminService(context.read<AuthState>().api);
    _bootstrap();
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
    final res = await _admin.listCentres(status: _tab);
    if (!mounted) return;
    _centres = (res['centres'] is List)
        ? (res['centres'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin — Martial Arts'),
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
                  TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
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
                SegmentedButton<String>(
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
                Expanded(
                  child: _centres.isEmpty
                      ? Center(child: Text('No $_tab centres'))
                      : ListView.builder(
                          itemCount: _centres.length,
                          itemBuilder: (_, i) {
                            final c = _centres[i];
                            final id = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
                            return ListTile(
                              title: Text(c['name']?.toString() ?? ''),
                              subtitle: Text('${c['location'] ?? ''}\n${c['email'] ?? ''}'),
                              isThreeLine: true,
                              trailing: _tab == 'pending' && id != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check, color: Colors.green),
                                          onPressed: () async {
                                            await _admin.approve(id);
                                            await _load();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () async {
                                            await _admin.reject(id);
                                            await _load();
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
