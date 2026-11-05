import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/creator_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import 'creator_chat_screen.dart';
import 'creator_studio_screen.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key, required this.creatorId});

  final int creatorId;

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> with SingleTickerProviderStateMixin {
  late final CreatorHubService _api;
  late final ModulePaymentCheckout _checkout;
  late final TabController _tabs;
  bool _loading = true;
  Map<String, dynamic>? _creator;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> _followers = [];
  List<Map<String, dynamic>> _following = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = CreatorHubService(api);
    _tabs = TabController(length: 3, vsync: this);
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
    _tabs.dispose();
    _checkout.dispose();
    super.dispose();
  }

  String _url(String? path) => ModuleTheme.mediaUrl(context.read<AuthState>().api.baseUrl, path);

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.creatorProfile(widget.creatorId);
      if (res['success'] == true) {
        _creator = res['creator'] is Map ? Map<String, dynamic>.from(res['creator'] as Map) : null;
        _posts = ModuleTheme.toList(res['posts']);
        _stories = ModuleTheme.toList(res['stories']);
        _followers = ModuleTheme.toList(res['followers']);
        _following = ModuleTheme.toList(res['following']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _follow() async {
    final res = await _api.follow(widget.creatorId);
    _snack(res['status']?.toString() ?? res['error']?.toString() ?? '');
    _load();
  }

  Future<void> _block() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Block this creator?'),
        content: const Text('You will no longer see their posts or stories.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Block')),
        ],
      ),
    );
    if (ok == true) {
      final res = await _api.block(widget.creatorId);
      _snack(res['success'] == true ? 'Blocked' : res['error']?.toString() ?? 'Could not block');
      if (res['success'] == true && mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _tip() async {
    final amountCtrl = TextEditingController(text: '50');
    final msgCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Send tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (Rs)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: msgCtrl,
              decoration: const InputDecoration(labelText: 'Encouragement message', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send')),
        ],
      ),
    );
    if (ok == true) {
      final amount = double.tryParse(amountCtrl.text) ?? 0.0;
      if (amount <= 0) return;
      await _checkout.pay(
        context: context,
        amount: amount,
        description: 'Tip creator',
        verifyPayload: (response) => {
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
          'type': 'CREATOR_TIP',
          'creatorId': widget.creatorId,
          'targetId': widget.creatorId,
          'amount': amount,
          'message': msgCtrl.text.trim(),
        },
        onSuccess: () async {
          _snack('Tip sent!');
          _load();
        },
        onError: (msg) => _snack(msg),
      );
    }
    amountCtrl.dispose();
    msgCtrl.dispose();
  }

  Future<void> _subscribePay() async {
    final price = (_creator?['subscriptionPrice'] is num)
        ? (_creator!['subscriptionPrice'] as num).toDouble()
        : 0.0;
    if (price <= 0) return;
    await _checkout.pay(
      context: context,
      amount: price,
      description: 'Creator subscription',
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'CREATOR_SUB',
        'creatorId': widget.creatorId,
        'targetId': widget.creatorId,
        'amount': price,
      },
      onSuccess: () async {
        _snack('Subscribed!');
        _load();
      },
      onError: (msg) => _snack(msg),
    );
  }

  Future<void> _unlock(Map<String, dynamic> post) async {
    final id = post['id'];
    final price = (post['price'] is num) ? (post['price'] as num).toDouble() : 0.0;
    if (id is! num || price <= 0) return;
    await _checkout.pay(
      context: context,
      amount: price,
      description: 'Unlock course',
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'CREATOR_UNLOCK',
        'videoId': id.toInt(),
        'targetId': id.toInt(),
        'amount': price,
      },
      onSuccess: () async {
        _snack('Unlocked');
        _load();
      },
      onError: (msg) => _snack(msg),
    );
  }

  Future<void> _rate() async {
    int stars = 5;
    final review = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this creator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () => setLocal(() => stars = i + 1),
                    icon: Icon(i < stars ? Icons.star : Icons.star_border, color: Colors.amber),
                  ),
                ),
              ),
              TextField(
                controller: review,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Optional comment', border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.rateCreator(widget.creatorId, rating: stars, review: review.text.trim());
    _snack(res['success'] == true ? 'Thanks for your review' : res['error']?.toString() ?? 'Review failed');
    if (res['success'] == true) _load();
    review.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
            if (people.isEmpty) const Padding(padding: EdgeInsets.only(top: 12), child: Text('No one yet')),
            ...people.map((p) {
              final id = p['id'];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(((p['name'] ?? p['fullName'] ?? '?').toString()).substring(0, 1).toUpperCase()),
                ),
                title: Text(p['name']?.toString() ?? p['fullName']?.toString() ?? 'User'),
                onTap: id is num
                    ? () {
                        Navigator.pop(ctx);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => CreatorProfileScreen(creatorId: id.toInt())),
                        );
                      }
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _paid =>
      _posts.where((p) => p['isPaidContent'] == true).toList();

  @override
  Widget build(BuildContext context) {
    final c = _creator;
    final own = c?['isOwnProfile'] == true;
    final name = c?['name']?.toString() ?? c?['fullName']?.toString() ?? 'Creator';
    final handle = c?['handle']?.toString() ?? c?['creatorHandle']?.toString() ?? '';
    final bio = c?['bio']?.toString() ?? c?['creatorBio']?.toString() ?? '';
    final city = c?['city']?.toString() ?? c?['creatorCity']?.toString() ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          if (own)
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
                              backgroundImage: _url(c['profilePhoto']?.toString()).isEmpty
                                  ? null
                                  : NetworkImage(_url(c['profilePhoto']?.toString())),
                              child: _url(c['profilePhoto']?.toString()).isEmpty
                                  ? Text(name.substring(0, 1).toUpperCase())
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                                      if (c['verifiedCreator'] == true) ...[
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
                        Text(bio.isEmpty ? 'Helping women grow, share safety practices and creative skills.' : bio),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _stat('Followers', '${c['followersCount'] ?? 0}', () => _showPeople('Followers', _followers)),
                            _stat('Following', '${c['followingCount'] ?? 0}', () => _showPeople('Following', _following)),
                            _stat('Uploads', '${_posts.length}', () {}),
                          ],
                        ),
                        if (!own) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton(
                                onPressed: _follow,
                                child: Text(
                                  c['isFollowing'] == true
                                      ? 'Following'
                                      : c['isRequested'] == true
                                          ? 'Requested'
                                          : 'Follow',
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CreatorChatScreen(initialPeerId: widget.creatorId),
                                  ),
                                ),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Message'),
                              ),
                              OutlinedButton(onPressed: _tip, child: const Text('Tip')),
                              if (c['subscriptionPrice'] != null && (c['subscriptionPrice'] as num) > 0)
                                OutlinedButton(
                                  onPressed: c['isSubscribed'] == true
                                      ? () async {
                                          final res = await _api.unsubscribe(widget.creatorId);
                                          _snack(res['success'] == true
                                              ? 'Subscription cancelled'
                                              : res['error']?.toString() ?? '');
                                          _load();
                                        }
                                      : _subscribePay,
                                  child: Text(c['isSubscribed'] == true
                                      ? 'Cancel subscription'
                                      : 'Subscribe · ₹${c['subscriptionPrice']}'),
                                ),
                              OutlinedButton(onPressed: _block, child: const Text('Block')),
                              if (c['canReview'] == true)
                                OutlinedButton(onPressed: _rate, child: const Text('Leave a review')),
                            ],
                          ),
                          if ((c['rating'] is num) && (c['rating'] as num) > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Rating ${(c['rating'] as num).toStringAsFixed(1)} · ${c['reviewCount'] ?? 0} reviews'),
                            ),
                          const SizedBox(height: 8),
                          Text(CreatorCatalog.cancelPolicy, style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
                        ],
                        const SizedBox(height: 16),
                        TabBar(
                          controller: _tabs,
                          labelColor: const Color(0xFFF43F5E),
                          tabs: [
                            Tab(text: 'Uploads (${_posts.length})'),
                            Tab(text: 'Paid (${_paid.length})'),
                            Tab(text: 'Stories (${_stories.length})'),
                          ],
                        ),
                        SizedBox(
                          height: 360,
                          child: TabBarView(
                            controller: _tabs,
                            children: [
                              _postGrid(_posts),
                              _postGrid(_paid, paid: true),
                              _storyGrid(),
                            ],
                          ),
                        ),
                      ],
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

  Widget _postGrid(List<Map<String, dynamic>> items, {bool paid = false}) {
    if (items.isEmpty) {
      return Center(child: Text(paid ? 'No paid courses' : 'No uploads yet', style: const TextStyle(color: ModuleTheme.textGray)));
    }
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final p = items[i];
        final url = _url((p['thumbnailPath'] ?? p['videoPath'])?.toString());
        final locked = p['locked'] == true || p['paidLocked'] == true;
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: locked ? () => _unlock(p) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      url.isEmpty
                          ? Container(color: const Color(0xFFE2E8F0), child: const Icon(Icons.play_circle_outline))
                          : ModuleTheme.networkImage(url, fit: BoxFit.cover),
                      if (locked)
                        Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: Text(
                            'Unlock ₹${p['price'] ?? ''}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(p['title']?.toString() ?? 'Post', maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _storyGrid() {
    if (_stories.isEmpty) {
      return const Center(child: Text('No active stories', style: TextStyle(color: ModuleTheme.textGray)));
    }
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
      itemCount: _stories.length,
      itemBuilder: (_, i) {
        final s = _stories[i];
        final url = _url(s['mediaPath']?.toString());
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              url.isEmpty ? const ColoredBox(color: Color(0xFFE2E8F0)) : ModuleTheme.networkImage(url, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(6),
                  child: Text(s['caption']?.toString() ?? '', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
