import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/entrepreneur_auth_service.dart';
import '../widgets/module_theme.dart';
import '../widgets/registration_form_kit.dart';
import 'entrepreneur_portal_login_screen.dart';

class EntrepreneurDashboardScreen extends StatefulWidget {
  const EntrepreneurDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softBg = Color(0xFFF7F8FA);

  @override
  State<EntrepreneurDashboardScreen> createState() => _EntrepreneurDashboardScreenState();
}

class _EntrepreneurDashboardScreenState extends State<EntrepreneurDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _entrepreneur = {};
  List<Map<String, dynamic>> _proposals = [];
  Map<String, dynamic> _funding = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await EntrepreneurAuthService(context.read<AuthState>().api).dashboard();
      if (res['success'] == true) {
        _entrepreneur = Map<String, dynamic>.from(res['entrepreneur'] ?? {});
        _proposals = ModuleTheme.toList(res['proposals']);
        _funding = Map<String, dynamic>.from(res['funding'] ?? {});
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await context.read<AuthState>().api.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const EntrepreneurPortalLoginScreen()),
      (_) => false,
    );
  }

  Future<void> _createProposal() async {
    final title = TextEditingController();
    final desc = TextEditingController();
    final funding = TextEditingController(text: '100000');
    final income = TextEditingController(text: '0');
    String category = RegOptions.businessCategories.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('New Funding Proposal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: title, decoration: const InputDecoration(labelText: 'Proposal title *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: RegOptions.businessCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setLocal(() => category = v ?? category),
                ),
                const SizedBox(height: 10),
                TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: funding, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Funding needed (Rs) *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: income, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected monthly income (Rs)', border: OutlineInputBorder())),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: EntrepreneurDashboardScreen.primary),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final res = await EntrepreneurAuthService(context.read<AuthState>().api).createProposal({
      'title': title.text.trim(),
      'category': category,
      'description': desc.text.trim(),
      'location': _entrepreneur['businessLocation'],
      'fundingNeeded': double.tryParse(funding.text.trim()) ?? 0,
      'expectedMonthlyIncome': double.tryParse(income.text.trim()) ?? 0,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Proposal submitted for admin approval' : '${res['error']}'),
        backgroundColor: res['success'] == true ? Colors.teal : Colors.red.shade700,
      ),
    );
    if (res['success'] == true) _load();
  }

  String get _name => _entrepreneur['fullName']?.toString() ?? 'Entrepreneur';
  String get _firstName => _name.trim().split(RegExp(r'\s+')).first;
  String get _business => _entrepreneur['businessName']?.toString() ?? 'Business';
  String get _category => _entrepreneur['businessCategory']?.toString() ?? 'Startup';
  String get _location => _entrepreneur['businessLocation']?.toString() ?? 'Location not set';
  int get _experience => (_entrepreneur['businessExperience'] is num) ? (_entrepreneur['businessExperience'] as num).toInt() : 0;

  double get _requested {
    final fromFunding = (_funding['totalRequested'] is num) ? (_funding['totalRequested'] as num).toDouble() : 0.0;
    if (fromFunding > 0) return fromFunding;
    final needed = (_entrepreneur['investmentNeeded'] is num) ? (_entrepreneur['investmentNeeded'] as num).toDouble() : 0.0;
    return needed;
  }

  double get _raised => (_funding['totalRaised'] is num) ? (_funding['totalRaised'] as num).toDouble() : 0;
  double get _remaining => (_requested - _raised).clamp(0, double.infinity);
  double get _progress => _requested <= 0 ? 0 : (_raised / _requested).clamp(0.0, 1.0);
  int get _startupScore => (55 + (_proposals.length * 8) + (_progress * 25).round() + (_experience.clamp(0, 10))).clamp(0, 99);

  String _money(num v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)} Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)} L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EntrepreneurDashboardScreen.softBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: EntrepreneurDashboardScreen.primary,
        elevation: 6,
        onPressed: _createProposal,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 14,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _nav(0, Icons.home_outlined, Icons.home, 'Home'),
              _nav(1, Icons.description_outlined, Icons.description, 'Proposals'),
              const SizedBox(width: 56),
              _nav(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Funding'),
              _nav(3, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : SafeArea(
                  child: IndexedStack(
                    index: _tab,
                    children: [_homeTab(), _proposalsTab(), _fundingTab(), _profileTab()],
                  ),
                ),
    );
  }

  Widget _nav(int i, IconData outline, IconData filled, String label) {
    final active = _tab == i;
    final c = active ? EntrepreneurDashboardScreen.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? filled : outline, color: c, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }

  Widget _homeTab() {
    return RefreshIndicator(
      color: EntrepreneurDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _topBar(),
          const SizedBox(height: 14),
          _profileHero(),
          const SizedBox(height: 14),
          _metricsGrid(),
          const SizedBox(height: 14),
          _fundingProgressCard(),
          const SizedBox(height: 16),
          _section('Quick Actions'),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 16),
          _section('Investor Activity'),
          const SizedBox(height: 10),
          _activityCard(),
          const SizedBox(height: 16),
          _section('Startup Metrics'),
          const SizedBox(height: 10),
          _startupMetrics(),
          const SizedBox(height: 16),
          _section('Upcoming Meetings'),
          const SizedBox(height: 10),
          _meetingsCard(),
          const SizedBox(height: 16),
          _section('Your Proposals', action: 'View all', onAction: () => setState(() => _tab = 1)),
          const SizedBox(height: 10),
          if (_proposals.isEmpty)
            _empty('No proposals yet. Tap + to create your first funding proposal.')
          else
            ..._proposals.take(3).map(_proposalCard),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _toast('Menu coming soon'),
          icon: const Icon(Icons.menu_rounded, color: EntrepreneurDashboardScreen.navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $_firstName! 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy),
              ),
              const Text(
                "Here's what's happening with your startup today.",
                style: TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _tab = 3),
          child: const Text('View Profile', style: TextStyle(color: EntrepreneurDashboardScreen.primary, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
        _iconBadge(Icons.notifications_none_rounded, 3),
        _iconBadge(Icons.chat_bubble_outline_rounded, 2),
      ],
    );
  }

  Widget _iconBadge(IconData icon, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(onPressed: () => _toast('Coming soon'), icon: Icon(icon, color: EntrepreneurDashboardScreen.navy)),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: EntrepreneurDashboardScreen.primary, shape: BoxShape.circle),
              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _profileHero() {
    final initial = _business.isNotEmpty ? _business[0].toUpperCase() : 'E';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E1C59), Color(0xFFD93662)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: EntrepreneurDashboardScreen.primary.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(initial, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                  child: Text(_category.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ),
                const SizedBox(height: 6),
                Text(_business, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text(_name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: Colors.white70),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(_location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: Color(0xFF16A34A)),
                      SizedBox(width: 6),
                      Text('Fundraising Active', style: TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _scoreRing(_startupScore),
        ],
      ),
    );
  }

  Widget _scoreRing(int score) {
    return Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 6,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
              Text('$score%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text('Startup Score', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600)),
        Text(score >= 80 ? 'Excellent' : score >= 60 ? 'Good' : 'Building', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _metricsGrid() {
    final items = [
      _Metric('Funding Goal', _money(_requested), Icons.flag_outlined, const Color(0xFFFCE7F3)),
      _Metric('Raised', '${_money(_raised)}\n${(_progress * 100).toStringAsFixed(0)}% of Goal', Icons.trending_up, const Color(0xFFDCFCE7)),
      _Metric('Investors\nInterested', '${_proposals.where((p) => (p['amountRaised'] ?? 0) != 0).length + (_raised > 0 ? 1 : 0)}', Icons.groups_outlined, const Color(0xFFE0E7FF)),
      _Metric('Active\nProposals', '${_proposals.length}', Icons.description_outlined, const Color(0xFFFEF3C7)),
      _Metric('Profile\nViews', '—', Icons.visibility_outlined, const Color(0xFFE0F2FE)),
    ];
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = items[i];
          return Container(
            width: 128,
            padding: const EdgeInsets.all(12),
            decoration: _cardDeco(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: m.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(m.icon, size: 18, color: EntrepreneurDashboardScreen.navy),
                ),
                const Spacer(),
                Text(m.label, style: const TextStyle(fontSize: 10, color: EntrepreneurDashboardScreen.muted, fontWeight: FontWeight.w600, height: 1.15)),
                const SizedBox(height: 2),
                Text(m.value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy, height: 1.15)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fundingProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Funding Progress', style: TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy))),
              Text('${(_progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.primary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFFCE7F3),
              color: EntrepreneurDashboardScreen.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${_money(_raised)} raised', style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${_money(_remaining)} remaining', style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      (Icons.add_circle_outline, 'Create Proposal', EntrepreneurDashboardScreen.primary, _createProposal),
      (Icons.picture_as_pdf_outlined, 'Pitch Deck', const Color(0xFF8B5CF6), () => _toast('Upload pitch deck from profile soon')),
      (Icons.event_available_outlined, 'Meetings', const Color(0xFF16A34A), () => _toast('Meetings coming soon')),
      (Icons.chat_bubble_outline, 'Investor Chat', const Color(0xFF3B82F6), () => _toast('Chat coming soon')),
      (Icons.insights_outlined, 'Analytics', const Color(0xFFF97316), () => setState(() => _tab = 2)),
      (Icons.account_balance_wallet_outlined, 'Withdraw', const Color(0xFFEF4444), () => _toast('Withdrawals coming soon')),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final a = actions[i];
          return InkWell(
            onTap: a.$4,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 86,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: _cardDeco(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: a.$3.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: Icon(a.$1, color: a.$3, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(a.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EntrepreneurDashboardScreen.navy, height: 1.15)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _activityCard() {
    final items = _raised > 0
        ? [
            ('Investor', 'Expressed interest in your startup', 'Recently'),
            ('Admin', 'Proposal verification in progress', 'Today'),
          ]
        : [
            ('System', 'Complete your proposal to attract investors', 'Now'),
            ('Tip', 'Add funding amount and pitch details', 'Today'),
          ];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        children: items.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFFFE4E6),
                  child: Text(e.$1[0], style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.primary)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy, fontSize: 13)),
                      Text(e.$2, style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted)),
                    ],
                  ),
                ),
                Text(e.$3, style: const TextStyle(fontSize: 11, color: EntrepreneurDashboardScreen.muted)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _startupMetrics() {
    final income = (_entrepreneur['expectedMonthlyIncome'] is num) ? (_entrepreneur['expectedMonthlyIncome'] as num).toDouble() : 0.0;
    final metrics = [
      ('Monthly Revenue', income > 0 ? _money(income) : '—', Icons.payments_outlined, const Color(0xFFDCFCE7)),
      ('Customers', '—', Icons.people_outline, const Color(0xFFE0E7FF)),
      ('Employees', _parseEmployees(), Icons.badge_outlined, const Color(0xFFFEF3C7)),
      ('Experience', '$_experience yrs', Icons.work_history_outlined, const Color(0xFFFCE7F3)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) {
        final m = metrics[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: _cardDeco(),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: m.$4, borderRadius: BorderRadius.circular(10)),
                child: Icon(m.$3, size: 18, color: EntrepreneurDashboardScreen.navy),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.$1, style: const TextStyle(fontSize: 11, color: EntrepreneurDashboardScreen.muted, fontWeight: FontWeight.w600)),
                    Text(m.$2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _parseEmployees() {
    final desc = _entrepreneur['businessDescription']?.toString() ?? '';
    final m = RegExp(r'Employees:\s*(\d+)').firstMatch(desc);
    return m?.group(1) ?? '—';
  }

  Widget _meetingsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.videocam_outlined, color: Color(0xFF0369A1)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No meetings scheduled', style: TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy)),
                Text('Investor meetings will appear here once booked.', style: TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
            child: const Text('Pending', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EntrepreneurDashboardScreen.muted)),
          ),
        ],
      ),
    );
  }

  Widget _proposalsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              const Expanded(child: Text('Proposals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy))),
              FilledButton.icon(
                onPressed: _createProposal,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
                style: FilledButton.styleFrom(backgroundColor: EntrepreneurDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_proposals.isEmpty) _empty('No proposals yet.') else ..._proposals.map(_proposalCard),
        ],
      ),
    );
  }

  Widget _fundingTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text('Funding Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy)),
        const SizedBox(height: 14),
        _fundingProgressCard(),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(),
          child: Column(
            children: [
              _kv('Total requested', _money(_requested)),
              const Divider(height: 22),
              _kv('Total raised', _money(_raised)),
              const Divider(height: 22),
              _kv('Remaining', _money(_remaining)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2E1C59), Color(0xFFD93662)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Need more capital?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Create another proposal for admin review and investor interest.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _createProposal,
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: EntrepreneurDashboardScreen.primary),
                child: const Text('Create Proposal'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHero(),
        const SizedBox(height: 14),
        _infoTile(Icons.person_outline, 'Founder', _name),
        _infoTile(Icons.business_outlined, 'Business', _business),
        _infoTile(Icons.category_outlined, 'Category', _category),
        _infoTile(Icons.place_outlined, 'Location', _location),
        _infoTile(Icons.work_history_outlined, 'Experience', '$_experience years'),
        _infoTile(Icons.currency_rupee, 'Investment needed', _money(_entrepreneur['investmentNeeded'] is num ? _entrepreneur['investmentNeeded'] as num : 0)),
        _infoTile(Icons.verified_outlined, 'Status', _entrepreneur['verificationStatus']?.toString() ?? '—'),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: EntrepreneurDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: EntrepreneurDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _proposalCard(Map<String, dynamic> p) {
    final status = (p['status']?.toString() ?? 'PENDING').toUpperCase();
    final raised = (p['amountRaised'] is num) ? (p['amountRaised'] as num).toDouble() : 0.0;
    final needed = (p['fundingNeeded'] is num) ? (p['fundingNeeded'] as num).toDouble() : 0.0;
    final prog = needed <= 0 ? 0.0 : (raised / needed).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(p['title']?.toString() ?? 'Proposal', style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy))),
              _statusPill(status),
            ],
          ),
          const SizedBox(height: 4),
          Text('${p['category'] ?? ''} · ${p['location'] ?? ''}', style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: prog, minHeight: 6, backgroundColor: const Color(0xFFFCE7F3), color: EntrepreneurDashboardScreen.primary),
          ),
          const SizedBox(height: 6),
          Text('${_money(raised)} raised of ${_money(needed)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0369A1);
    if (status == 'VERIFIED') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (status == 'REJECTED') {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFBE123C);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: EntrepreneurDashboardScreen.primary),
        title: Text(label, style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: EntrepreneurDashboardScreen.navy)),
      ),
    );
  }

  Widget _section(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy))),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action, style: const TextStyle(color: EntrepreneurDashboardScreen.primary, fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(child: Text(k, style: const TextStyle(color: EntrepreneurDashboardScreen.muted))),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy)),
      ],
    );
  }

  Widget _empty(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: const TextStyle(color: EntrepreneurDashboardScreen.muted)),
    );
  }

  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.045), blurRadius: 12, offset: const Offset(0, 4))],
      );
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.bg);
  final String label;
  final String value;
  final IconData icon;
  final Color bg;
}
