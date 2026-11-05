import 'package:flutter/material.dart';

import 'creator_chat_screen.dart';
import 'creator_hub_screen.dart';
import 'creator_my_profile_screen.dart';
import 'creator_notifications_screen.dart';
import 'creator_studio_screen.dart';
import 'creator_upload_screen.dart';

/// Shared Creator Hub chrome: Profile / Feed / Create / Alerts / Chat.
class CreatorHubShell extends StatefulWidget {
  const CreatorHubShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<CreatorHubShell> createState() => _CreatorHubShellState();
}

class _CreatorHubShellState extends State<CreatorHubShell> {
  late int _index;
  int _refreshTick = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 3);
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreatorUploadScreen()),
    );
    if (created == true && mounted) {
      setState(() => _refreshTick++);
    }
  }

  void _openStudio() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CreatorStudioScreen()))
        .then((_) {
      if (mounted) setState(() => _refreshTick++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          CreatorMyProfileScreen(key: ValueKey('me-$_refreshTick'), onOpenStudio: _openStudio),
          CreatorHubScreen(key: ValueKey('feed-$_refreshTick'), embedded: true),
          CreatorNotificationsScreen(key: ValueKey('n-$_refreshTick'), embedded: true),
          CreatorChatScreen(key: ValueKey('c-$_refreshTick'), embedded: true),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index < 2 ? _index : _index + 1,
        backgroundColor: Colors.white,
        indicatorColor: CreatorHubShell.primary.withValues(alpha: 0.12),
        onDestinationSelected: (i) {
          if (i == 2) {
            _openCreate();
            return;
          }
          setState(() => _index = i < 2 ? i : i - 1);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.dynamic_feed_outlined), selectedIcon: Icon(Icons.dynamic_feed), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Create'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
        ],
      ),
    );
  }
}
