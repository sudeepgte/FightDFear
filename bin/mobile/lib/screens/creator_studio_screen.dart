import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/creator_hub_service.dart';
import '../widgets/module_theme.dart';

class CreatorStudioScreen extends StatefulWidget {
  const CreatorStudioScreen({super.key});

  @override
  State<CreatorStudioScreen> createState() => _CreatorStudioScreenState();
}

class _CreatorStudioScreenState extends State<CreatorStudioScreen> with SingleTickerProviderStateMixin {
  late final CreatorHubService _api;
  late final TabController _tabs;
  bool _loading = true;
  Map<String, dynamic>? _data;

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

  @override
  Widget build(BuildContext context) {
    final user = _data?['user'] is Map ? Map<String, dynamic>.from(_data!['user'] as Map) : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Studio'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Content'),
            Tab(text: 'Monetize'),
            Tab(text: 'Safety'),
          ],
        ),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : TabBarView(
              controller: _tabs,
              children: [
                _contentTab(),
                _monetizeTab(user),
                _safetyTab(user),
              ],
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
          _statRow('Total views', '${_data?['totalViews'] ?? 0}'),
          _statRow('Total likes', '${_data?['totalLikes'] ?? 0}'),
          _statRow('Subscribers', '${_data?['subscriberCount'] ?? 0}'),
          const SizedBox(height: 16),
          const Text('Drafts', style: TextStyle(fontWeight: FontWeight.w700)),
          ...drafts.map((d) => _contentTile(d, isDraft: true)),
          const SizedBox(height: 16),
          const Text('Published', style: TextStyle(fontWeight: FontWeight.w700)),
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
                onPressed: () async {
                  await _api.publishDraft(id.toInt());
                  _snack('Published');
                  _load();
                },
              ),
            if (id is num)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () async {
                  await _api.deleteUpload(id.toInt());
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
        _statRow('Reward points', '${user?['rewardPoints'] ?? 0}'),
        _statRow('Wallet balance', '₹${user?['walletBalance'] ?? 0}'),
        _statRow('Est. ad revenue', '₹${_data?['estAdRevenue'] ?? 0}'),
        _statRow('Tips received', '₹${_data?['totalTipsAmount'] ?? 0}'),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () async {
            final res = await _api.claimAdRevenue();
            _snack(res['success'] == true ? 'Ad revenue claimed' : res['error']?.toString() ?? '');
            _load();
          },
          child: const Text('Claim ad revenue'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () async {
            final res = await _api.cashout(100);
            _snack(res['success'] == true ? 'Cashout requested' : res['error']?.toString() ?? '');
            _load();
          },
          child: const Text('Redeem 100 points'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Monthly subscription price (Rs)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () async {
            final p = double.tryParse(priceCtrl.text) ?? 0;
            final res = await _api.setSubscriptionPrice(p);
            _snack(res['success'] == true ? 'Price updated' : res['error']?.toString() ?? '');
          },
          child: const Text('Save subscription price'),
        ),
        const SizedBox(height: 24),
        const Text('Brand campaigns', style: TextStyle(fontWeight: FontWeight.w700)),
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
        const SizedBox(height: 16),
        const Text('Blocked users', style: TextStyle(fontWeight: FontWeight.w700)),
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
