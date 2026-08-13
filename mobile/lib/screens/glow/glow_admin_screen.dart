import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/glow_admin_service.dart';
import '../../services/martial_arts_admin_service.dart';

class GlowAdminScreen extends StatefulWidget {
  const GlowAdminScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);

  @override
  State<GlowAdminScreen> createState() => _GlowAdminScreenState();
}

class _GlowAdminScreenState extends State<GlowAdminScreen> {
  late final MartialArtsAdminService _adminAuth;
  late final GlowAdminService _glow;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loggedIn = false;
  bool _busy = false;
  String _kind = 'salons';
  String _status = 'pending';
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _adminAuth = MartialArtsAdminService(api);
    _glow = GlowAdminService(api);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _loggedIn = await _adminAuth.isLoggedIn();
    if (_loggedIn) await _load();
    if (mounted) setState(() {});
  }

  Future<void> _login() async {
    setState(() => _busy = true);
    final res = await _adminAuth.login(email: _emailCtrl.text.trim(), password: _passCtrl.text);
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
    final res = _kind == 'salons'
        ? await _glow.listSalons(status: _status)
        : await _glow.listStylists(status: _status);
    if (!mounted) return;
    final key = _kind == 'salons' ? 'salons' : 'stylists';
    _items = (res[key] is List)
        ? (res[key] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin — Glow Space'),
        actions: [
          if (_loggedIn)
            IconButton(
              onPressed: () async {
                await _adminAuth.logout();
                setState(() {
                  _loggedIn = false;
                  _items = [];
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
                    style: FilledButton.styleFrom(backgroundColor: GlowAdminScreen.primary),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Salons'),
                        selected: _kind == 'salons',
                        onSelected: (_) {
                          _kind = 'salons';
                          _load();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Stylists'),
                        selected: _kind == 'stylists',
                        onSelected: (_) {
                          _kind = 'stylists';
                          _load();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Pending'),
                        selected: _status == 'pending',
                        onSelected: (_) {
                          _status = 'pending';
                          _load();
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Approved'),
                        selected: _status == 'approved',
                        onSelected: (_) {
                          _status = 'approved';
                          _load();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _items.isEmpty
                      ? Center(child: Text('No $_status $_kind'))
                      : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (_, i) {
                            final item = _items[i];
                            final id = item['id'] is int ? item['id'] as int : int.tryParse('${item['id']}');
                            final title = _kind == 'salons'
                                ? (item['name']?.toString() ?? 'Salon')
                                : '${item['firstName'] ?? ''} ${item['lastName'] ?? ''}'.trim();
                            final statusLabel = item['partnerProfileStatusLabel']?.toString();
                            final baseSubtitle = _kind == 'salons'
                                ? '${item['city'] ?? ''} · ${item['username'] ?? ''}'
                                : '${item['email'] ?? ''} · ${item['specialization'] ?? ''}';
                            final subtitle = (statusLabel != null && statusLabel.isNotEmpty)
                                ? '$baseSubtitle\n$statusLabel'
                                : baseSubtitle;
                            return ListTile(
                              title: Text(title.isEmpty ? 'Provider' : title),
                              subtitle: Text(subtitle),
                              isThreeLine: statusLabel != null && statusLabel.isNotEmpty,
                              trailing: _status == 'pending' && id != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check, color: Colors.green),
                                          onPressed: () async {
                                            if (_kind == 'salons') {
                                              await _glow.approveSalon(id);
                                            } else {
                                              await _glow.approveStylist(id);
                                            }
                                            await _load();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          onPressed: () async {
                                            if (_kind == 'salons') {
                                              await _glow.rejectSalon(id);
                                            } else {
                                              await _glow.rejectStylist(id);
                                            }
                                            await _load();
                                          },
                                        ),
                                      ],
                                    )
                                  : (statusLabel != null && statusLabel.isNotEmpty
                                      ? Text(
                                          statusLabel,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : null),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
