import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/creator_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/creator_auth_service.dart';
import '../../services/creator_hub_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import '../landing/landing_screen.dart';
import 'creator_hub_screen.dart';
import 'creator_profile_completion_screen.dart';
import 'creator_upload_screen.dart';

class CreatorStudioScreen extends StatefulWidget {
  const CreatorStudioScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<CreatorStudioScreen> createState() => _CreatorStudioScreenState();
}

class _CreatorStudioScreenState extends State<CreatorStudioScreen> with SingleTickerProviderStateMixin {
  late final CreatorHubService _api;
  late final TabController _tabs;
  bool _loading = true;
  bool _acting = false;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _api = CreatorHubService(context.read<AuthState>().api);
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get _user =>
      _data?['user'] is Map ? Map<String, dynamic>.from(_data!['user'] as Map) : null;

  bool get _approved =>
      _data?['approved'] == true ||
      _user?['approved'] == true ||
      _user?['partnerProfileStatus']?.toString() == 'APPROVED' ||
      _user?['verifiedCreator'] == true;

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.dashboard();
      if (res['success'] == true) _data = res;
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _logout() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CreatorProfileCompletionScreen()))
        .then((_) => _load());
  }

  Future<void> _openUpload() async {
    if (!_approved) {
      _openProfile();
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreatorUploadScreen()),
    );
    _load();
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get _name => _user?['fullName']?.toString() ?? 'Creator';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tabs.index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tabs.index != 0) _tabs.animateTo(0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          foregroundColor: CreatorStudioScreen.navy,
          titleSpacing: 8,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Creator Studio', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              Text(
                '${_greeting()}, $_name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
            ],
          ),
          toolbarHeight: 64,
          actions: [
            IconButton(
              tooltip: 'Open feed',
              icon: const Icon(Icons.dynamic_feed_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatorHubScreen()),
              ),
            ),
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
          bottom: TabBar(
            controller: _tabs,
            labelColor: CreatorStudioScreen.primary,
            unselectedLabelColor: const Color(0xFF64748B),
            indicatorColor: CreatorStudioScreen.primary,
            tabs: const [
              Tab(text: 'Content'),
              Tab(text: 'Monetize'),
              Tab(text: 'Safety'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CreatorStudioScreen.primary,
          onPressed: _openUpload,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: _loading
            ? ModuleTheme.loading()
            : TabBarView(
                controller: _tabs,
                children: [
                  _contentTab(),
                  _monetizeTab(_user),
                  _safetyTab(_user),
                ],
              ),
      ),
    );
  }

  Widget _gateCard() {
    if (_approved) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ProfileCompletionCard(
        percent: (_user?['profileCompletionPct'] is num)
            ? (_user!['profileCompletionPct'] as num).toDouble()
            : 0,
        statusLabel: _user?['partnerProfileStatusLabel']?.toString() ?? 'Pending',
        hint: _user?['nextStepGuidance']?.toString() ??
            'Complete your profile and wait for admin approval before publishing.',
        actionLabel: 'Complete profile',
        onAction: _openProfile,
      ),
    );
  }

  Widget _contentTab() {
    final drafts = ModuleTheme.toList(_data?['drafts']);
    final published = ModuleTheme.toList(_data?['published']);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gateCard(),
          _statRow('Total views', '${_data?['totalViews'] ?? 0}'),
          _statRow('Total likes', '${_data?['totalLikes'] ?? 0}'),
          _statRow('Subscribers', '${_data?['subscriberCount'] ?? 0}'),
          const SizedBox(height: 16),
          const Text('Drafts', style: TextStyle(fontWeight: FontWeight.w700)),
          if (drafts.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('No drafts yet', style: TextStyle(color: ModuleTheme.textGray))),
          ...drafts.map((d) => _contentTile(d, isDraft: true)),
          const SizedBox(height: 16),
          const Text('Published', style: TextStyle(fontWeight: FontWeight.w700)),
          if (published.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('No published posts yet', style: TextStyle(color: ModuleTheme.textGray))),
          ...published.map((d) => _contentTile(d, isDraft: false)),
        ],
      ),
    );
  }

  Widget _contentTile(Map<String, dynamic> d, {required bool isDraft}) {
    final id = d['id'];
    return Card(
      child: ListTile(
        title: Text(d['title']?.toString() ?? 'Post'),
        subtitle: Text('👁 ${d['viewCount'] ?? 0} · ❤ ${d['likeCount'] ?? 0}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDraft && id is num)
              IconButton(
                icon: const Icon(Icons.publish, color: Colors.green),
                onPressed: _acting
                    ? null
                    : () async {
                        if (!_approved) {
                          _snack('Wait for admin approval before publishing.');
                          return;
                        }
                        setState(() => _acting = true);
                        final res = await _api.publishDraft(id.toInt());
                        if (mounted) setState(() => _acting = false);
                        _snack(res['success'] == true ? 'Published' : res['error']?.toString() ?? 'Could not publish');
                        _load();
                      },
              ),
            if (id is num)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: _acting
                    ? null
                    : () async {
                        setState(() => _acting = true);
                        await _api.deleteUpload(id.toInt());
                        if (mounted) setState(() => _acting = false);
                        _snack('Deleted');
                        _load();
                      },
              ),
          ],
        ),
      ),
    );
  }

  Widget _monetizeTab(Map<String, dynamic>? user) {
    final campaigns = ModuleTheme.toList(_data?['brandCampaigns']);
    final priceCtrl = TextEditingController(text: '${user?['subscriptionPrice'] ?? 0}');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _gateCard(),
        _statRow('Reward points', '${user?['rewardPoints'] ?? 0}'),
        _statRow('Wallet balance', '₹${user?['walletBalance'] ?? 0}'),
        _statRow('Est. ad revenue', '₹${_data?['estAdRevenue'] ?? 0}'),
        _statRow('Tips received', '₹${_data?['totalTipsAmount'] ?? 0}'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: CreatorStudioScreen.primary),
            title: const Text('Payout balance'),
            subtitle: Text((_data?['upiId'] ?? user?['upiId'] ?? '').toString().isEmpty
                ? 'Add UPI in Complete Profile to withdraw'
                : 'UPI: ${_data?['upiId'] ?? user?['upiId']}'),
            trailing: Text(
              '₹${((_data?['payoutBalance'] ?? user?['payoutBalance'] ?? 0) is num) ? ((_data?['payoutBalance'] ?? user?['payoutBalance']) as num).round() : 0}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () async {
            final res = await CreatorAuthService(context.read<AuthState>().api).requestPayout();
            _snack(res['success'] == true
                ? (res['message']?.toString() ?? 'Requested')
                : (res['error']?.toString() ?? 'Payout failed'));
            if (res['success'] == true) _load();
          },
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(CreatorCatalog.cancelPolicy, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: !_approved
              ? null
              : () async {
                  final res = await _api.claimAdRevenue();
                  _snack(res['success'] == true ? 'Ad revenue claimed' : res['error']?.toString() ?? '');
                  _load();
                },
          child: const Text('Claim ad revenue'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: !_approved
              ? null
              : () async {
                  final res = await _api.cashout(100);
                  _snack(res['success'] == true ? 'Cashout requested' : res['error']?.toString() ?? '');
                  _load();
                },
          child: const Text('Redeem 100 points'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceCtrl,
          enabled: _approved,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Monthly subscription price (Rs)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: !_approved
              ? null
              : () async {
                  final p = double.tryParse(priceCtrl.text) ?? 0;
                  final res = await _api.setSubscriptionPrice(p);
                  _snack(res['success'] == true ? 'Price updated' : res['error']?.toString() ?? '');
                },
          child: const Text('Save subscription price'),
        ),
        const SizedBox(height: 24),
        const Text('Brand campaigns', style: TextStyle(fontWeight: FontWeight.w700)),
        if (!_approved)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Available after admin approval.', style: TextStyle(color: ModuleTheme.textGray)),
          )
        else
          ...campaigns.map((c) {
            final id = c['id'];
            return Card(
              child: ListTile(
                title: Text(c['title']?.toString() ?? 'Campaign'),
                subtitle: Text('${c['description'] ?? ''}\nBudget: ₹${c['budget'] ?? 0}'),
                isThreeLine: true,
                trailing: id is num
                    ? IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final res = await _api.applyCollab(campaignId: id.toInt(), pitch: 'Interested from mobile');
                          _snack(res['success'] == true ? 'Applied' : res['error']?.toString() ?? '');
                        },
                      )
                    : null,
              ),
            );
          }),
      ],
    );
  }

  Widget _safetyTab(Map<String, dynamic>? user) {
    final blocked = ModuleTheme.toList(_data?['blockedUsers']);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _gateCard(),
        SwitchListTile(
          title: const Text('Private profile'),
          subtitle: const Text('Require follow approval'),
          value: user?['isPrivate'] == true,
          onChanged: (_) async {
            await _api.togglePrivacy();
            _snack('Privacy updated');
            _load();
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Edit creator profile'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _openProfile,
        ),
        const SizedBox(height: 16),
        const Text('Blocked users', style: TextStyle(fontWeight: FontWeight.w700)),
        if (blocked.isEmpty) const Padding(padding: EdgeInsets.only(top: 8), child: Text('None', style: TextStyle(color: ModuleTheme.textGray))),
        ...blocked.map((b) {
          final id = b['id'];
          return ListTile(
            title: Text(b['name']?.toString() ?? 'User'),
            trailing: id is num
                ? TextButton(
                    onPressed: () async {
                      await _api.unblock(id.toInt());
                      _load();
                    },
                    child: const Text('Unblock'),
                  )
                : null,
          );
        }),
      ],
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ModuleTheme.textGray)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
