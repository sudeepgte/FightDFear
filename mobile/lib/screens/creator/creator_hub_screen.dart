import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import 'creator_notifications_screen.dart';
import 'creator_portal_login_screen.dart';
import 'creator_profile_screen.dart';
import 'creator_studio_screen.dart';
import 'creator_upload_screen.dart';

class CreatorHubScreen extends StatefulWidget {
  const CreatorHubScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<CreatorHubScreen> createState() => _CreatorHubScreenState();
}

class _CreatorHubScreenState extends State<CreatorHubScreen> {
  late final CreatorHubService _api;
  late final ModulePaymentCheckout _checkout;
  final _searchCtrl = TextEditingController();
  final _cityFilter = TextEditingController();
  bool _loading = true;
  String? _error;
  String _category = '';
  String _sort = 'newest';
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> _categories = [];
  int _unreadNotifs = 0;
  bool _canUpload = false;
  bool _isCreatorApplicant = false;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = CreatorHubService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
    _checkout.bind(
      onSuccess: (r) {
        if (!mounted) return;
        _checkout.handleSuccess(context, r);
      },
      onError: (r) {
        if (!mounted) return;
        _checkout.handleError(r);
      },
    );
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _cityFilter.dispose();
    _checkout.dispose();
    super.dispose();
  }

  String _url(String? path) {
    if (path == null || path.isEmpty) return '';
    final base = context.read<AuthState>().api.baseUrl;
    return ModuleTheme.mediaUrl(base, path);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.feed(
        search: _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim(),
        category: _category.isEmpty ? null : _category,
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        sort: _sort,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        _posts = ModuleTheme.toList(res['posts']);
        _stories = ModuleTheme.toList(res['stories']);
        final cats = res['categories'];
        _categories = cats is List ? cats.map((e) => {'name': e.toString()}).toList() : [];
        _unreadNotifs = res['unreadNotificationCount'] is num
            ? (res['unreadNotificationCount'] as num).toInt()
            : 0;
        _canUpload = res['canUpload'] == true;
        final status = res['creatorProfileStatus']?.toString();
        _isCreatorApplicant = status != null && status.isNotEmpty;
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _openProfile(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CreatorProfileScreen(creatorId: id)),
    ).then((_) => _load());
  }

  Future<void> _showComments(int postId) async {
    final res = await _api.comments(postId);
    final comments = res['success'] == true ? ModuleTheme.toList(res['comments']) : <Map<String, dynamic>>[];
    final ctrl = TextEditingController();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SafeArea(
          child: SizedBox(
            height: 420,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Comments', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(child: Text('No comments yet'))
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            return ListTile(
                              title: Text(c['username']?.toString() ?? 'User'),
                              subtitle: Text(c['text']?.toString() ?? ''),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: ctrl,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: CreatorHubScreen.primary),
                        onPressed: () async {
                          if (ctrl.text.trim().isEmpty) return;
                          await _api.comment(postId, ctrl.text.trim());
                          if (ctx.mounted) Navigator.pop(ctx);
                          _load();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ctrl.dispose();
  }

  Future<void> _handleUnlock(Map<String, dynamic> post) async {
    final creator = post['creator'];
    final creatorId = creator is Map ? creator['id'] : null;
    if (post['subscriberLocked'] == true && creatorId is num) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Subscribe to unlock'),
          content: const Text('Subscribe to this creator to view subscriber-only content.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Subscribe')),
          ],
        ),
      );
      if (ok == true) {
        final price = creator is Map && creator['subscriptionPrice'] is num
            ? (creator['subscriptionPrice'] as num).toDouble()
            : 99.0;
        await _pay(
          amount: price,
          description: 'Creator subscription',
          type: 'CREATOR_SUB',
          extra: {'creatorId': creatorId.toInt(), 'targetId': creatorId.toInt()},
        );
      }
      return;
    }
    if (post['paidLocked'] == true) {
      final price = (post['price'] is num) ? (post['price'] as num).toDouble() : 0.0;
      final id = post['id'];
      if (id is! num || price <= 0) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unlock content'),
          content: Text('Pay ₹${price.round()} to unlock this post? Tips and unlocks are not refundable.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Unlock')),
          ],
        ),
      );
      if (ok == true) {
        await _pay(
          amount: price,
          description: 'Unlock post',
          type: 'CREATOR_UNLOCK',
          extra: {'videoId': id.toInt(), 'targetId': id.toInt()},
        );
      }
    }
  }

  Future<void> _pay({
    required double amount,
    required String description,
    required String type,
    required Map<String, dynamic> extra,
  }) async {
    await _checkout.pay(
      context: context,
      amount: amount,
      description: description,
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': type,
        'amount': amount,
        ...extra,
      },
      onSuccess: () async => _load(),
      onError: _snack,
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFD),
      appBar: AppBar(
        title: const Text('Women Creator Hub'),
        backgroundColor: Colors.white,
        foregroundColor: CreatorHubScreen.navy,
        actions: [
          IconButton(
            tooltip: 'Saved',
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () async {
              final res = await _api.bookmarks();
              if (!mounted) return;
              final items = res['success'] == true ? ModuleTheme.toList(res['posts']) : [];
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Saved posts'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: items.isEmpty
                        ? const Text('No bookmarks yet')
                        : ListView(
                            shrinkWrap: true,
                            children: items.map((p) => ListTile(
                                  title: Text(p['title']?.toString() ?? 'Post'),
                                  onTap: () => Navigator.pop(ctx),
                                )).toList(),
                          ),
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                ),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const CreatorNotificationsScreen()))
                    .then((_) => _load()),
              ),
              if (_unreadNotifs > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: CreatorHubScreen.primary, shape: BoxShape.circle),
                    child: Text('$_unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            onPressed: () {
              final loggedIn = context.read<AuthState>().loggedIn;
              if (_canUpload || _isCreatorApplicant || loggedIn) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const CreatorStudioScreen()))
                    .then((_) => _load());
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreatorPortalLoginScreen(startRegister: true)),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CreatorHubScreen.primary,
        onPressed: () {
          final loggedIn = context.read<AuthState>().loggedIn;
          if (_canUpload) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CreatorUploadScreen()))
                .then((_) => _load());
          } else if (_isCreatorApplicant || loggedIn) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CreatorStudioScreen()))
                .then((_) => _load());
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreatorPortalLoginScreen(startRegister: true)),
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: InputDecoration(
                              hintText: 'Search posts or #hashtags',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _load),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onSubmitted: (_) => _load(),
                          ),
                        ),
                      ),
                      if (_stories.isNotEmpty)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 110,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(16),
                              itemCount: _stories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (_, i) {
                                final g = _stories[i];
                                return GestureDetector(
                                  onTap: () {
                                    final items = ModuleTheme.toList(g['items']);
                                    if (items.isEmpty) return;
                                    showDialog<void>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(g['userName']?.toString() ?? 'Story'),
                                        content: Text(items.first['caption']?.toString() ?? 'Story'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [CreatorHubScreen.primary, CreatorHubScreen.purple],
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            (g['userName']?.toString() ?? '?').substring(0, 1).toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 64,
                                        child: Text(
                                          g['userName']?.toString() ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 44,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            children: [
                              _CategoryChip(
                                label: 'All',
                                selected: _category.isEmpty,
                                onTap: () {
                                  setState(() => _category = '');
                                  _load();
                                },
                              ),
                              ..._categories.map((c) {
                                final name = c['name']?.toString() ?? '';
                                return _CategoryChip(
                                  label: name,
                                  selected: _category == name,
                                  onTap: () {
                                    setState(() => _category = name);
                                    _load();
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: TextField(
                            controller: _cityFilter,
                            decoration: InputDecoration(
                              hintText: 'City',
                              prefixIcon: const Icon(Icons.place_outlined, size: 18),
                              suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _load),
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onSubmitted: (_) => _load(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                          child: Wrap(
                            spacing: 6,
                            children: [
                              ChoiceChip(
                                label: const Text('Newest'),
                                selected: _sort == 'newest',
                                onSelected: (_) {
                                  setState(() => _sort = 'newest');
                                  _load();
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Top rated'),
                                selected: _sort == 'rating',
                                onSelected: (_) {
                                  setState(() => _sort = 'rating');
                                  _load();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_posts.isEmpty)
                        const SliverFillRemaining(
                          child: Center(child: Text('No posts yet. Tap + to create!')),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => _PostCard(
                              post: _posts[i],
                              mediaUrl: _url,
                              onProfile: _openProfile,
                              onLike: () async {
                                final id = _posts[i]['id'];
                                if (id is num) await _api.like(id.toInt());
                                _load();
                              },
                              onComment: () {
                                final id = _posts[i]['id'];
                                if (id is num) _showComments(id.toInt());
                              },
                              onBookmark: () async {
                                final id = _posts[i]['id'];
                                if (id is num) await _api.bookmark(id.toInt());
                                _load();
                              },
                              onUnlock: () => _handleUnlock(_posts[i]),
                              onView: () async {
                                final id = _posts[i]['id'];
                                if (id is num && _posts[i]['locked'] != true) {
                                  await _api.view(id.toInt());
                                }
                              },
                            ),
                            childCount: _posts.length,
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: CreatorHubScreen.primary.withValues(alpha: 0.15),
        checkmarkColor: CreatorHubScreen.primary,
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.post,
    required this.mediaUrl,
    required this.onProfile,
    required this.onLike,
    required this.onComment,
    required this.onBookmark,
    required this.onUnlock,
    required this.onView,
  });

  final Map<String, dynamic> post;
  final String Function(String?) mediaUrl;
  final void Function(int id) onProfile;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onBookmark;
  final VoidCallback onUnlock;
  final VoidCallback onView;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  VideoPlayerController? _videoCtrl;

  @override
  void initState() {
    super.initState();
    widget.onView();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.post['locked'] == true) return;
    if (widget.post['fileType']?.toString() != 'VIDEO') return;
    final url = widget.mediaUrl(widget.post['videoPath']?.toString());
    if (url.isEmpty) return;
    final ctrl = VideoPlayerController.networkUrl(Uri.parse(url));
    await ctrl.initialize();
    if (mounted) setState(() => _videoCtrl = ctrl);
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final creator = post['creator'];
    final creatorId = creator is Map ? creator['id'] : null;
    final creatorName = creator is Map ? creator['name']?.toString() ?? 'Creator' : 'Creator';
    final locked = post['locked'] == true;
    final badge = post['isReel'] == true ? 'REEL' : (post['fileType']?.toString() == 'IMAGE' ? 'IMAGE' : 'VIDEO');

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: CreatorHubScreen.primary.withValues(alpha: 0.1),
              child: Text(creatorName.substring(0, 1).toUpperCase()),
            ),
            title: Text(creatorName, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(post['category']?.toString() ?? ''),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: CreatorHubScreen.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(badge, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            onTap: creatorId is num ? () => widget.onProfile(creatorId.toInt()) : null,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              if (_videoCtrl != null && _videoCtrl!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _videoCtrl!.value.aspectRatio,
                  child: VideoPlayer(_videoCtrl!),
                )
              else
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: widget.mediaUrl(post['thumbnailPath']?.toString()).isNotEmpty
                      ? Image.network(
                          widget.mediaUrl(post['thumbnailPath']?.toString()),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _mediaPlaceholder(),
                        )
                      : _mediaPlaceholder(),
                ),
              if (locked)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock, color: Colors.white, size: 40),
                        const SizedBox(height: 8),
                        FilledButton(onPressed: widget.onUnlock, child: const Text('Unlock')),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post['title']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                if (post['description'] != null) ...[
                  const SizedBox(height: 4),
                  Text(post['description'].toString(), style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13)),
                ],
                if (post['hashtags'] != null) ...[
                  const SizedBox(height: 4),
                  Text(post['hashtags'].toString(), style: const TextStyle(color: CreatorHubScreen.primary, fontSize: 12)),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post['liked'] == true ? Icons.favorite : Icons.favorite_border,
                        color: CreatorHubScreen.primary,
                      ),
                      onPressed: locked ? null : widget.onLike,
                    ),
                    Text('${post['likeCount'] ?? 0}'),
                    IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: widget.onComment),
                    IconButton(
                      icon: Icon(
                        post['bookmarked'] == true ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: widget.onBookmark,
                    ),
                    const Spacer(),
                    Text('👁 ${post['viewCount'] ?? 0}', style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(child: Icon(Icons.play_circle_outline, size: 48, color: CreatorHubScreen.primary)),
    );
  }
}
