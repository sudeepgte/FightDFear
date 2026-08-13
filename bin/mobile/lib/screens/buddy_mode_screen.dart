import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

class BuddyModeScreen extends StatefulWidget {
  const BuddyModeScreen({super.key});

  @override
  State<BuddyModeScreen> createState() => _BuddyModeScreenState();
}

class _BuddyModeScreenState extends State<BuddyModeScreen> {
  late final BuddyService _api;
  final _destinationCtrl = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  String? _error;
  bool _active = false;
  List<Map<String, dynamic>> _matches = [];
  List<Map<String, dynamic>> _incoming = [];
  List<Map<String, dynamic>> _outgoing = [];

  @override
  void initState() {
    super.initState();
    _api = BuddyService(context.read<AuthState>().api);
    _loadState();
  }

  @override
  void dispose() {
    _destinationCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.state();
      if (!mounted) return;
      if (res['success'] == true) {
        _active = res['activeAvailability'] == true;
        _incoming = ModuleTheme.toList(res['incoming']);
        _outgoing = ModuleTheme.toList(res['outgoing']);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<Position?> _currentPosition() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required for Buddy Mode')),
        );
      }
      return null;
    }
    return Geolocator.getCurrentPosition();
  }

  Future<void> _start() async {
    final dest = _destinationCtrl.text.trim();
    if (dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your destination')),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final pos = await _currentPosition();
      if (pos == null) return;
      final res = await _api.startAvailability(
        latitude: pos.latitude,
        longitude: pos.longitude,
        destination: dest,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await _loadState();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message']?.toString() ?? 'Buddy Mode started')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Could not start')),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _stop() async {
    setState(() => _busy = true);
    try {
      await _api.stopAvailability();
      await _loadState();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _findMatches() async {
    final dest = _destinationCtrl.text.trim();
    if (dest.isEmpty) return;
    setState(() => _busy = true);
    try {
      final pos = await _currentPosition();
      if (pos == null) return;
      final res = await _api.matches(
        latitude: pos.latitude,
        longitude: pos.longitude,
        destination: dest,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() => _matches = ModuleTheme.toList(res['matches']));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'No matches')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendRequest(dynamic availabilityId) async {
    if (availabilityId is! num) return;
    final res = await _api.sendRequest(availabilityId.toInt());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? '')),
    );
    _loadState();
  }

  Future<void> _respond(int id, bool accept) async {
    final res = accept ? await _api.acceptRequest(id) : await _api.rejectRequest(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? '')),
    );
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Buddy Mode'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _loadState)
              : RefreshIndicator(
                  onRefresh: _loadState,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _active ? 'You are available as a buddy' : 'Find or offer a walking buddy',
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _destinationCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Destination',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (_active)
                                OutlinedButton(
                                  onPressed: _busy ? null : _stop,
                                  child: const Text('Stop availability'),
                                )
                              else ...[
                                FilledButton(
                                  onPressed: _busy ? null : _start,
                                  child: const Text('Start as buddy'),
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: _busy ? null : _findMatches,
                                  child: const Text('Find buddies nearby'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (_matches.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Nearby buddies', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ..._matches.map((m) {
                          return Card(
                            child: ListTile(
                              title: Text(m['name']?.toString() ?? 'Buddy'),
                              subtitle: Text('${m['destination'] ?? ''} · ${m['distanceKm'] ?? ''} km'),
                              trailing: FilledButton(
                                onPressed: () => _sendRequest(m['availabilityId']),
                                child: const Text('Request'),
                              ),
                            ),
                          );
                        }),
                      ],
                      if (_incoming.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Incoming requests', style: TextStyle(fontWeight: FontWeight.w700)),
                        ..._incoming.map((r) {
                          final id = r['id'];
                          return Card(
                            child: ListTile(
                              title: Text(r['fromName']?.toString() ?? 'Request'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: id is num ? () => _respond(id.toInt(), true) : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: id is num ? () => _respond(id.toInt(), false) : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                      if (_outgoing.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Sent requests', style: TextStyle(fontWeight: FontWeight.w700)),
                        ..._outgoing.map((r) => Card(
                              child: ListTile(
                                title: Text(r['toName']?.toString() ?? 'Buddy'),
                                subtitle: Text(r['status']?.toString() ?? ''),
                              ),
                            )),
                      ],
                    ],
                  ),
                ),
    );
  }
}
