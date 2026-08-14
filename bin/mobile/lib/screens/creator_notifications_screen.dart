import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/creator_hub_service.dart';
import '../widgets/module_theme.dart';

class CreatorNotificationsScreen extends StatefulWidget {
  const CreatorNotificationsScreen({super.key});

  @override
  State<CreatorNotificationsScreen> createState() => _CreatorNotificationsScreenState();
}

class _CreatorNotificationsScreenState extends State<CreatorNotificationsScreen> {
  late final CreatorHubService _api;
  bool _loading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.notifications();
      if (res['success'] == true) {
        _items = ModuleTheme.toList(res['notifications']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  IconData _iconFor(String? type) {
    return switch (type) {
      'FOLLOW' => Icons.person_add_outlined,
      'MONEY_RECEIVED' => Icons.payments_outlined,
      'LANDMARK' => Icons.emoji_events_outlined,
      _ => Icons.notifications_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _loading
          ? ModuleTheme.loading()
          : RefreshIndicator(
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(children: const [SizedBox(height: 80), Center(child: Text('No notifications'))])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final n = _items[i];
                        return Card(
                          child: ListTile(
                            leading: Icon(_iconFor(n['type']?.toString()), color: const Color(0xFFF43F5E)),
                            title: Text(n['message']?.toString() ?? ''),
                            subtitle: Text(n['createdAt']?.toString() ?? ''),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
