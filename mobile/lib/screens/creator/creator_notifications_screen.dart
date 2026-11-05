import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../widgets/module_theme.dart';
import 'creator_chat_screen.dart';
import 'creator_hub_screen.dart';
import 'creator_profile_screen.dart';

class CreatorNotificationsScreen extends StatefulWidget {
  const CreatorNotificationsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<CreatorNotificationsScreen> createState() => _CreatorNotificationsScreenState();
}

class _CreatorNotificationsScreenState extends State<CreatorNotificationsScreen> {
  late final CreatorHubService _api;
  bool _loading = true;
  String _filter = 'ALL';
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
      'CHAT_MESSAGE' => Icons.chat_bubble_outline,
      'LIKE' || 'COMMENT' => Icons.favorite_outline,
      _ => Icons.notifications_outlined,
    };
  }

  bool _matches(Map<String, dynamic> n) {
    final type = (n['type'] ?? '').toString().toUpperCase();
    return switch (_filter) {
      'FOLLOW' => type == 'FOLLOW',
      'ENGAGEMENT' => type == 'LIKE' || type == 'COMMENT' || type == 'LANDMARK',
      'CHAT' => type == 'CHAT_MESSAGE',
      _ => true,
    };
  }

  void _open(Map<String, dynamic> n) {
    final type = (n['type'] ?? '').toString().toUpperCase();
    final senderId = n['senderId'];
    if (type == 'CHAT_MESSAGE' && senderId is num) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CreatorChatScreen(initialPeerId: senderId.toInt())),
      );
      return;
    }
    if (type == 'FOLLOW' && senderId is num) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CreatorProfileScreen(creatorId: senderId.toInt())),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreatorHubScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _items.where(_matches).toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: const Text('Notifications'),
        actions: [
          if (_items.isNotEmpty)
            TextButton.icon(
              onPressed: () async {
                final res = await _api.markAllNotificationsRead();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Marked ${res['markedCount'] ?? 0} notifications as read')),
                  );
                  _load();
                }
              },
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Mark all read'),
            ),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Wrap(
                    spacing: 6,
                    children: [
                      for (final f in const ['ALL', 'FOLLOW', 'ENGAGEMENT', 'CHAT'])
                        ChoiceChip(
                          label: Text(f[0] + f.substring(1).toLowerCase()),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: visible.isEmpty
                        ? ListView(children: const [SizedBox(height: 80), Center(child: Text('No notifications'))])
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: visible.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final n = visible[i];
                              return Card(
                                child: ListTile(
                                  leading: Icon(_iconFor(n['type']?.toString()), color: const Color(0xFFF43F5E)),
                                  title: Text(n['message']?.toString() ?? ''),
                                  subtitle: Text(n['createdAt']?.toString() ?? ''),
                                  onTap: () => _open(n),
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
