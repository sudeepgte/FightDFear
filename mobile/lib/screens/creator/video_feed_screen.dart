import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';

enum VideoFeedMode { videos, reels, creatorHub }

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({
    super.key,
    required this.title,
    required this.mode,
  });

  final String title;
  final VideoFeedMode mode;

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  late final VideoService _api;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _api = VideoService(context.read<AuthState>().api);
    _load();
  }

  String get _listKey => switch (widget.mode) {
        VideoFeedMode.videos => 'videos',
        VideoFeedMode.reels => 'reels',
        VideoFeedMode.creatorHub => 'items',
      };

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> res;
      switch (widget.mode) {
        case VideoFeedMode.videos:
          res = await _api.videos();
        case VideoFeedMode.reels:
          res = await _api.reels();
        case VideoFeedMode.creatorHub:
          res = await _api.creatorFeed();
      }
      if (!mounted) return;
      if (res['success'] == true) {
        _items = ModuleTheme.toList(res[_listKey]);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  String _mediaUrl(String? path) {
    final base = context.read<AuthState>().api.baseUrl;
    return ModuleTheme.mediaUrl(base, path);
  }

  Future<void> _openVideo(Map<String, dynamic> item) async {
    final path = item['videoPath']?.toString();
    if (path == null || path.isEmpty) return;
    final url = Uri.parse(_mediaUrl(path));
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _items.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No content yet.')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final item = _items[i];
                            final thumb = _mediaUrl(item['thumbnailPath']?.toString());
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _openVideo(item),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (thumb.isNotEmpty)
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          thumb,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            color: const Color(0xFFE2E8F0),
                                            child: const Icon(Icons.play_circle_outline, size: 48),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 120,
                                        color: const Color(0xFFE2E8F0),
                                        child: const Center(
                                          child: Icon(Icons.play_circle_outline, size: 48),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title']?.toString() ?? 'Video',
                                            style: const TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                          if (item['description'] != null) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              item['description'].toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: ModuleTheme.textGray,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 4),
                                          Text(
                                            '👁 ${item['viewCount'] ?? 0} · ❤ ${item['likeCount'] ?? 0}',
                                            style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
