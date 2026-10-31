import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/landing_service.dart';
import '../creator/creator_hub_screen.dart';
import '../safety/home_screen.dart';
import '../auth/login_screen.dart';
import '../events/women_events_screen.dart';

class LandingNotificationsScreen extends StatefulWidget {
  const LandingNotificationsScreen({super.key, this.onOpenRoute});

  final ValueChanged<String?>? onOpenRoute;

  @override
  State<LandingNotificationsScreen> createState() => _LandingNotificationsScreenState();
}

class _LandingNotificationsScreenState extends State<LandingNotificationsScreen> {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  late final LandingService _api;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _api = LandingService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.notifications();
      if (!mounted) return;
      if (res['success'] == true) {
        final list = (res['notifications'] as List?) ?? [];
        _items = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        // Mark broadcasts read when user opens the screen while logged in.
        if (context.read<AuthState>().loggedIn) {
          await _api.markNotificationsRead();
        }
      } else {
        _error = res['error']?.toString() ?? 'Could not load notifications';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  IconData _iconFor(Map<String, dynamic> n) {
    final type = (n['type']?.toString() ?? '').toUpperCase();
    final source = (n['source']?.toString() ?? '').toUpperCase();
    if (source == 'SYSTEM' || type == 'TIP') return Icons.lightbulb_outline;
    if (source == 'EVENT') return Icons.event_outlined;
    if (source == 'OFFER') return Icons.local_offer_outlined;
    if (type == 'ALERT' || type == 'WARNING') return Icons.warning_amber_rounded;
    if (source == 'CREATOR') return Icons.groups_outlined;
    return Icons.campaign_outlined;
  }

  void _openItem(Map<String, dynamic> n) {
    final route = n['route']?.toString();
    if (route == null || route.isEmpty) return;

    if (widget.onOpenRoute != null) {
      Navigator.pop(context);
      widget.onOpenRoute!(route);
      return;
    }

    switch (route) {
      case 'sos':
        if (context.read<AuthState>().loggedIn) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LoginScreen(redirectToSos: true)),
          );
        }
      case 'events':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WomenEventsScreen()));
      case 'community':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreatorHubScreen()));
      case 'login':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFC),
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _items.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('No notifications yet')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final n = _items[i];
                            final title = n['title']?.toString() ?? 'Update';
                            final message = n['message']?.toString() ?? '';
                            final when = n['createdAt']?.toString();
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: Color(0xFFFCE7F3)),
                              ),
                              child: ListTile(
                                onTap: () => _openItem(n),
                                leading: CircleAvatar(
                                  backgroundColor: primary.withValues(alpha: 0.12),
                                  child: Icon(_iconFor(n), color: primary),
                                ),
                                title: Text(title,
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(message),
                                    if (when != null && when.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(when,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    ],
                                  ],
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
