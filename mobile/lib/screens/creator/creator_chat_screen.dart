import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../widgets/module_theme.dart';
import 'creator_profile_screen.dart';

class CreatorChatScreen extends StatefulWidget {
  const CreatorChatScreen({super.key, this.embedded = false, this.initialPeerId});

  final bool embedded;
  final int? initialPeerId;

  @override
  State<CreatorChatScreen> createState() => _CreatorChatScreenState();
}

class _CreatorChatScreenState extends State<CreatorChatScreen> with SingleTickerProviderStateMixin {
  late final CreatorHubService _api;
  late final TabController _tabs;
  final _search = TextEditingController();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _tabs = TabController(length: 2, vsync: this);
    _load().then((_) {
      if (widget.initialPeerId != null && mounted) {
        _openPeer(widget.initialPeerId!);
      }
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.chatInbox();
      if (!mounted) return;
      if (res['success'] == true) {
        _chats = ModuleTheme.toList(res['chatUsers']);
        _requests = ModuleTheme.toList(res['messageRequests']);
      } else {
        _error = res['error']?.toString() ?? 'Could not load chats';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _openPeer(int peerId, {String? name}) {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => CreatorChatThreadScreen(peerId: peerId, title: name ?? 'Chat'),
        ))
        .then((_) => _load());
  }

  List<Map<String, dynamic>> _filtered(List<Map<String, dynamic>> raw) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return raw;
    return raw.where((u) {
      final name = (u['fullName'] ?? u['name'] ?? '').toString().toLowerCase();
      final handle = (u['handle'] ?? '').toString().toLowerCase();
      return name.contains(q) || handle.contains(q);
    }).toList();
  }

  Widget _list(List<Map<String, dynamic>> people) {
    final items = _filtered(people);
    if (items.isEmpty) {
      return ListView(children: const [
        SizedBox(height: 80),
        Center(child: Text('No conversations', style: TextStyle(color: ModuleTheme.textGray))),
      ]);
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final u = items[i];
        final id = u['id'];
        final unread = u['unreadCount'] is num ? (u['unreadCount'] as num).toInt() : 0;
        return ListTile(
          leading: CircleAvatar(
            child: Text(((u['fullName'] ?? u['name'] ?? '?').toString()).substring(0, 1).toUpperCase()),
          ),
          title: Text(u['fullName']?.toString() ?? u['name']?.toString() ?? 'User'),
          subtitle: Text(u['handle']?.toString().isNotEmpty == true ? '@${u['handle']}' : 'Tap to message'),
          trailing: unread > 0
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: const Color(0xFFF43F5E),
                  child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 11)),
                )
              : null,
          onTap: id is num ? () => _openPeer(id.toInt(), name: u['fullName']?.toString() ?? u['name']?.toString()) : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.embedded
          ? AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Chat'),
              bottom: TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: 'Chats (${_chats.length})'),
                  Tab(text: 'Requests (${_requests.length})'),
                ],
              ),
            )
          : AppBar(
              title: const Text('Creator Chat'),
              bottom: TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: 'Chats (${_chats.length})'),
                  Tab(text: 'Requests (${_requests.length})'),
                ],
              ),
            ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: TextField(
                        controller: _search,
                        decoration: const InputDecoration(
                          hintText: 'Search people',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabs,
                        children: [
                          RefreshIndicator(onRefresh: _load, child: _list(_chats)),
                          RefreshIndicator(onRefresh: _load, child: _list(_requests)),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class CreatorChatThreadScreen extends StatefulWidget {
  const CreatorChatThreadScreen({super.key, required this.peerId, this.title = 'Chat'});

  final int peerId;
  final String title;

  @override
  State<CreatorChatThreadScreen> createState() => _CreatorChatThreadScreenState();
}

class _CreatorChatThreadScreenState extends State<CreatorChatThreadScreen> {
  late final CreatorHubService _api;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _sending = false;
  String? _error;
  Timer? _poll;
  int? _myId;

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _myId = context.read<AuthState>().userId;
    _load(initial: true);
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _load());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({bool initial = false}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final res = await _api.chatMessages(widget.peerId);
      if (!mounted) return;
      if (res['success'] == true) {
        _messages = ModuleTheme.toList(res['messages']);
        _error = null;
      } else if (initial) {
        _error = res['error']?.toString();
      }
    } catch (e) {
      if (initial) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _send({String? override}) async {
    final text = (override ?? _input.text).trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final res = await _api.sendChat(peerId: widget.peerId, message: text);
      if (res['success'] == true) {
        _input.clear();
        await _load();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Send failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _sending = true);
    try {
      final up = await _api.uploadChatFile(File(picked.path));
      final url = up['url']?.toString();
      if (up['success'] == true && url != null && url.isNotEmpty) {
        await _send(override: url);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(up['error']?.toString() ?? 'File upload failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _follow() async {
    final res = await _api.follow(widget.peerId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['status']?.toString() ?? res['error']?.toString() ?? '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CreatorProfileScreen(creatorId: widget.peerId)),
            ),
          ),
          IconButton(tooltip: 'Follow', onPressed: _follow, icon: const Icon(Icons.person_add_alt)),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, () => _load(initial: true))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i];
                          final mine = m['senderId'] == _myId;
                          return Align(
                            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              constraints: const BoxConstraints(maxWidth: 280),
                              decoration: BoxDecoration(
                                color: mine ? const Color(0xFFF43F5E) : const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                m['message']?.toString() ?? '',
                                style: TextStyle(color: mine ? Colors.white : const Color(0xFF0F172A)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        child: Row(
                          children: [
                            IconButton(onPressed: _sending ? null : _sendFile, icon: const Icon(Icons.attach_file)),
                            Expanded(
                              child: TextField(
                                controller: _input,
                                decoration: const InputDecoration(
                                  hintText: 'Message',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onSubmitted: (_) => _send(),
                              ),
                            ),
                            IconButton(
                              onPressed: _sending ? null : _send,
                              icon: const Icon(Icons.send, color: Color(0xFFF43F5E)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
