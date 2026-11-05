import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../widgets/module_theme.dart';
import 'creator_profile_screen.dart';

Future<bool> showCreatorProfileEditDialog(
  BuildContext context,
  CreatorHubService api, {
  String? fullName,
  String? handle,
  String? bio,
  String? city,
}) async {
  final nameCtrl = TextEditingController(text: fullName ?? '');
  final handleCtrl = TextEditingController(text: handle ?? '');
  final bioCtrl = TextEditingController(text: bio ?? '');
  final cityCtrl = TextEditingController(text: city ?? '');
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: handleCtrl,
              decoration: const InputDecoration(labelText: 'Handle', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bioCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Bio', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: cityCtrl,
              decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
      ],
    ),
  );
  var saved = false;
  if (ok == true) {
    final res = await api.editProfile(
      fullName: nameCtrl.text.trim(),
      creatorHandle: handleCtrl.text.trim(),
      creatorBio: bioCtrl.text.trim(),
      creatorCity: cityCtrl.text.trim(),
    );
    saved = res['success'] == true;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(saved ? 'Profile updated' : res['error']?.toString() ?? 'Could not save')),
      );
    }
  }
  nameCtrl.dispose();
  handleCtrl.dispose();
  bioCtrl.dispose();
  cityCtrl.dispose();
  return saved;
}

class CreatorMyProfileScreen extends StatefulWidget {
  const CreatorMyProfileScreen({super.key, this.onOpenStudio});

  final VoidCallback? onOpenStudio;

  @override
  State<CreatorMyProfileScreen> createState() => _CreatorMyProfileScreenState();
}

class _CreatorMyProfileScreenState extends State<CreatorMyProfileScreen> with SingleTickerProviderStateMixin {
  late final CreatorHubService _api;
  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _creator;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _reels = [];
  List<Map<String, dynamic>> _saved = [];
  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> _followers = [];
  List<Map<String, dynamic>> _following = [];
  List<Map<String, dynamic>> _suggested = [];

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _tabs = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String _url(String? path) {
    if (path == null || path.isEmpty) return '';
    return ModuleTheme.mediaUrl(context.read<AuthState>().api.baseUrl, path);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.me();
      if (!mounted) return;
      if (res['success'] == true) {
        _creator = res['creator'] is Map ? Map<String, dynamic>.from(res['creator'] as Map) : null;
        _posts = ModuleTheme.toList(res['posts']);
        _reels = ModuleTheme.toList(res['reels']);
        _saved = ModuleTheme.toList(res['saved']);
        _stories = ModuleTheme.toList(res['stories']);
        _followers = ModuleTheme.toList(res['followers']);
        _following = ModuleTheme.toList(res['following']);
        _suggested = ModuleTheme.toList(res['suggestedUsers']);
      } else {
        _error = res['error']?.toString() ?? 'Could not load profile';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _edit() async {
    final c = _creator;
    final saved = await showCreatorProfileEditDialog(
      context,
      _api,
      fullName: c?['fullName']?.toString() ?? c?['name']?.toString(),
      handle: c?['handle']?.toString() ?? c?['creatorHandle']?.toString(),
      bio: c?['bio']?.toString() ?? c?['creatorBio']?.toString(),
      city: c?['city']?.toString() ?? c?['creatorCity']?.toString(),
    );
    if (saved) _load();
  }

  Future<void> _uploadPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final res = await _api.uploadPhoto(File(picked.path));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Photo updated' : res['error']?.toString() ?? 'Upload failed')),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _addStory() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final caption = TextEditingController();
    if (!mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Story'),
        content: TextField(
          controller: caption,
          decoration: const InputDecoration(labelText: 'Caption', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Share')),
        ],
      ),
    );
    if (ok == true) {
      final res = await _api.uploadStory(file: File(picked.path), caption: caption.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['success'] == true ? 'Story posted' : res['error']?.toString() ?? 'Failed')),
        );
        if (res['success'] == true) _load();
      }
    }
    caption.dispose();
  }

  Future<void> _follow(int id) async {
    await _api.follow(id);
    _load();
  }

  void _openUser(int id) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CreatorProfileScreen(creatorId: id)))
        .then((_) => _load());
  }

  void _showPeople(String title, List<Map<String, dynamic>> people) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            if (people.isEmpty) const Text('No one yet', style: TextStyle(color: ModuleTheme.textGray)),
            ...people.map((p) {
              final id = p['id'];
              return ListTile(
                leading: _avatar(p['profilePhoto']?.toString(), p['name']?.toString() ?? p['fullName']?.toString()),
                title: Text(p['name']?.toString() ?? p['fullName']?.toString() ?? 'User'),
                subtitle: Text(p['handle']?.toString() ?? ''),
                onTap: id is num
                    ? () {
                        Navigator.pop(ctx);
                        _openUser(id.toInt());
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String? path, String? name, {double radius = 20}) {
    final url = _url(path);
    final letter = (name == null || name.isEmpty) ? '?' : name.substring(0, 1).toUpperCase();
    if (url.isEmpty) return CircleAvatar(radius: radius, child: Text(letter));
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
      onBackgroundImageError: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _creator;
    final name = c?['name']?.toString() ?? c?['fullName']?.toString() ?? 'My profile';
    final handle = c?['handle']?.toString() ?? c?['creatorHandle']?.toString() ?? '';
    final bio = c?['bio']?.toString() ?? c?['creatorBio']?.toString() ?? '';
    final city = c?['city']?.toString() ?? c?['creatorCity']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Creator Hub'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(tooltip: 'Studio', onPressed: widget.onOpenStudio, icon: const Icon(Icons.dashboard_outlined)),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _uploadPhoto,
                            child: Stack(
                              children: [
                                _avatar(c?['profilePhoto']?.toString(), name, radius: 36),
                                const Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(0xFFF43F5E),
                                    child: Icon(Icons.camera_alt, size: 12, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                                    if (c?['verifiedCreator'] == true) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified, color: Color(0xFFF43F5E), size: 18),
                                    ],
                                  ],
                                ),
                                if (handle.isNotEmpty) Text('@$handle', style: const TextStyle(color: ModuleTheme.textGray)),
                                if (city.isNotEmpty) Text(city, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(bio.isEmpty ? 'Dreamer | Creator | Explorer' : bio),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _stat('Posts', '${c?['postsCount'] ?? _posts.length}', () {}),
                          _stat('Followers', '${c?['followersCount'] ?? _followers.length}', () => _showPeople('Followers', _followers)),
                          _stat('Following', '${c?['followingCount'] ?? _following.length}', () => _showPeople('Following', _following)),
                          _stat('Saved', '${c?['savedCount'] ?? _saved.length}', () => _tabs.animateTo(2)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: FilledButton(onPressed: _edit, child: const Text('Edit Profile'))),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(onPressed: _addStory, icon: const Icon(Icons.add), label: const Text('Story')),
                        ],
                      ),
                      if (_stories.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Your stories', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 88,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _stories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final s = _stories[i];
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: _url(s['mediaPath']?.toString()).isEmpty
                                        ? null
                                        : NetworkImage(_url(s['mediaPath']?.toString())),
                                    child: _url(s['mediaPath']?.toString()).isEmpty ? const Icon(Icons.auto_stories) : null,
                                  ),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      s['caption']?.toString() ?? 'Story',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      TabBar(
                        controller: _tabs,
                        labelColor: const Color(0xFFF43F5E),
                        tabs: [
                          Tab(text: 'Posts (${_posts.length})'),
                          Tab(text: 'Reels (${_reels.length})'),
                          Tab(text: 'Saved (${_saved.length})'),
                        ],
                      ),
                      SizedBox(
                        height: 280,
                        child: TabBarView(
                          controller: _tabs,
                          children: [
                            _mediaGrid(_posts),
                            _mediaGrid(_reels),
                            _mediaGrid(_saved),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('People you may know', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_suggested.isEmpty)
                        const Text('No suggestions right now', style: TextStyle(color: ModuleTheme.textGray)),
                      ..._suggested.map((u) {
                        final id = u['id'];
                        return Card(
                          child: ListTile(
                            leading: _avatar(u['profilePhoto']?.toString(), u['name']?.toString()),
                            title: Text(u['name']?.toString() ?? 'User'),
                            subtitle: Text(u['handle']?.toString() ?? u['city']?.toString() ?? ''),
                            trailing: id is num
                                ? TextButton(onPressed: () => _follow(id.toInt()), child: const Text('Follow'))
                                : null,
                            onTap: id is num ? () => _openUser(id.toInt()) : null,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
    );
  }

  Widget _stat(String label, String value, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text(label, style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray)),
          ],
        ),
      ),
    );
  }

  Widget _mediaGrid(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return const Center(child: Text('Nothing here yet', style: TextStyle(color: ModuleTheme.textGray)));
    }
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final p = items[i];
        final url = _url((p['thumbnailPath'] ?? p['videoPath'])?.toString());
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: url.isEmpty
              ? Container(
                  color: const Color(0xFFE2E8F0),
                  alignment: Alignment.center,
                  child: Text(p['title']?.toString() ?? '', textAlign: TextAlign.center, maxLines: 2),
                )
              : ModuleTheme.networkImage(url, fit: BoxFit.cover),
        );
      },
    );
  }
}
