import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/creator_hub_service.dart';
import '../widgets/module_theme.dart';
import 'creator_studio_screen.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key, required this.creatorId});

  final int creatorId;

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  late final CreatorHubService _api;
  bool _loading = true;
  Map<String, dynamic>? _creator;
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.creatorProfile(widget.creatorId);
      if (res['success'] == true) {
        _creator = res['creator'] is Map ? Map<String, dynamic>.from(res['creator'] as Map) : null;
        _posts = ModuleTheme.toList(res['posts']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _follow() async {
    final res = await _api.follow(widget.creatorId);
    _snack(res['status']?.toString() ?? res['error']?.toString() ?? '');
    _load();
  }

  Future<void> _tip() async {
    final ctrl = TextEditingController(text: '50');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send tip'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount (Rs)', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send')),
        ],
      ),
    );
    if (ok == true) {
      final amount = double.tryParse(ctrl.text) ?? 0;
      final res = await _api.tip(creatorId: widget.creatorId, amount: amount);
      _snack(res['success'] == true ? 'Tip sent!' : res['error']?.toString() ?? 'Failed');
    }
    ctrl.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final c = _creator;
    return Scaffold(
      appBar: AppBar(
        title: Text(c?['name']?.toString() ?? 'Creator'),
        actions: [
          if (c?['isOwnProfile'] == true)
            IconButton(
              icon: const Icon(Icons.dashboard_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatorStudioScreen()),
              ),
            ),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : c == null
              ? const Center(child: Text('Creator not found'))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (c['blocked'] == true)
                        const Text('This profile is blocked.')
                      else ...[
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              child: Text((c['name']?.toString() ?? '?').substring(0, 1).toUpperCase()),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                                  if (c['verifiedCreator'] == true)
                                    const Text('Verified Creator', style: TextStyle(color: Color(0xFFF43F5E), fontSize: 12)),
                                  Text('${c['followersCount'] ?? 0} followers · ${c['followingCount'] ?? 0} following'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (c['isOwnProfile'] != true) ...[
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: _follow,
                                  child: Text(
                                    c['isFollowing'] == true
                                        ? 'Following'
                                        : c['isRequested'] == true
                                            ? 'Requested'
                                            : 'Follow',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(onPressed: _tip, child: const Text('Tip')),
                            ],
                          ),
                          if (c['subscriptionPrice'] != null && (c['subscriptionPrice'] as num) > 0) ...[
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () async {
                                final res = await _api.subscribe(widget.creatorId);
                                _snack(res['success'] == true ? 'Subscribed!' : res['error']?.toString() ?? '');
                                _load();
                              },
                              child: Text('Subscribe · ₹${c['subscriptionPrice']}'),
                            ),
                          ],
                        ],
                        const SizedBox(height: 24),
                        Text('Posts (${_posts.length})', style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ..._posts.map((p) => Card(
                              child: ListTile(
                                title: Text(p['title']?.toString() ?? 'Post'),
                                subtitle: Text('👁 ${p['viewCount'] ?? 0} · ❤ ${p['likeCount'] ?? 0}'),
                                trailing: p['locked'] == true ? const Icon(Icons.lock) : null,
                              ),
                            )),
                      ],
                    ],
                  ),
                ),
    );
  }
}
