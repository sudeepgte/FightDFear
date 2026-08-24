import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/creator_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/creator_hub_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import 'creator_studio_screen.dart';

class CreatorProfileScreen extends StatefulWidget {
  const CreatorProfileScreen({super.key, required this.creatorId});

  final int creatorId;

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  late final CreatorHubService _api;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  Map<String, dynamic>? _creator;
  List<Map<String, dynamic>> _posts = [];

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
    _checkout.dispose();
    super.dispose();
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
      final amount = double.tryParse(ctrl.text) ?? 0.0;
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
        },
        onSuccess: () async {
          _snack('Tip sent!');
          _load();
        },
        onError: (msg) => _snack(msg),
      );
    }
    ctrl.dispose();
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
                          ],
                          if (c['canReview'] == true) ...[
                            const SizedBox(height: 8),
                            OutlinedButton(onPressed: _rate, child: const Text('Leave a review')),
                          ],
                          if ((c['rating'] is num) && (c['rating'] as num) > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Rating ${(c['rating'] as num).toStringAsFixed(1)} · ${c['reviewCount'] ?? 0} reviews'),
                            ),
                          const SizedBox(height: 8),
                          Text(CreatorCatalog.cancelPolicy, style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
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
