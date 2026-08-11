import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/registration_form_kit.dart';
import 'investor_portal_login_screen.dart';

class InvestorDashboardScreen extends StatefulWidget {
  const InvestorDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softBg = Color(0xFFF7F8FA);

  @override
  State<InvestorDashboardScreen> createState() => _InvestorDashboardScreenState();
}

class _InvestorDashboardScreenState extends State<InvestorDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  String? _error;
  String _marketFilter = 'All';
  Map<String, dynamic> _investor = {};
  List<Map<String, dynamic>> _portfolio = [];
  List<Map<String, dynamic>> _marketplace = [];
  double _totalInvested = 0;

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
      final res = await InvestorAuthService(context.read<AuthState>().api).dashboard();
      if (res['success'] == true) {
        _investor = Map<String, dynamic>.from(res['investor'] ?? {});
        _portfolio = ModuleTheme.toList(res['portfolio'] ?? res['investments']);
        _marketplace = ModuleTheme.toList(res['marketplace']);
        _totalInvested = (res['totalInvested'] is num) ? (res['totalInvested'] as num).toDouble() : 0;
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
      MaterialPageRoute(builder: (_) => const InvestorPortalLoginScreen()),
      (_) => false,
    );
  }

  Future<void> _investIn(Map<String, dynamic> proposal) async {
    final id = proposal['id'];
    final pid = id is int ? id : int.tryParse('$id');
    if (pid == null) return;
    final amountCtrl = TextEditingController(text: '50000');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Invest in ${proposal['title'] ?? 'Proposal'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seeking ${_money(proposal['fundingNeeded'] ?? 0)} · Raised ${_money(proposal['amountRaised'] ?? 0)}',
              style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Investment amount (Rs)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Express Interest'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final res = await InvestorAuthService(context.read<AuthState>().api).invest({
      'proposalId': pid,
      'amount': double.tryParse(amountCtrl.text.trim()) ?? 0,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Investment interest submitted' : '${res['error']}'),
        backgroundColor: res['success'] == true ? Colors.teal : Colors.red.shade700,
      ),
    );
    if (res['success'] == true) _load();
  }

  String get _name => _investor['fullName']?.toString() ?? 'Investor';
  String get _firstName => _name.trim().split(RegExp(r'\s+')).first;
  String get _company => _investor['companyName']?.toString() ?? 'Independent Investor';
  String get _budget => _investor['budgetRange']?.toString() ?? '—';
  String get _location => _investor['preferredLocations']?.toString() ?? '—';
  String get _interests => _investor['preferredCategories']?.toString() ?? _investor['investmentInterests']?.toString() ?? '';

  int get _pendingDeals => _portfolio.where((i) => (i['status']?.toString() ?? '').toUpperCase() == 'PENDING').length;
  int get _activeDeals => _portfolio.where((i) {
        final s = (i['status']?.toString() ?? '').toUpperCase();
        return s == 'ACCEPTED' || s == 'RELEASED' || s == 'COMPLETED';
      }).length;

  List<Map<String, dynamic>> get _filteredMarket {
    if (_marketFilter == 'All') return _marketplace;
    return _marketplace.where((p) {
      final cat = (p['category']?.toString() ?? '').toLowerCase();
      return cat.contains(_marketFilter.toLowerCase());
    }).toList();
  }

  List<String> get _filters {
    final cats = <String>{'All', ...RegOptions.investmentInterests.take(6)};
    for (final p in _marketplace) {
      final c = p['category']?.toString();
      if (c != null && c.trim().isNotEmpty) cats.add(c);
    }
    return cats.toList();
  }

  String _money(Object? v) {
    final n = v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    if (n >= 10000000) return '₹${(n / 10000000).toStringAsFixed(1)} Cr';
    if (n >= 100000) return '₹${(n / 100000).toStringAsFixed(1)} L';
    if (n >= 1000) return '₹${(n / 1000).toStringAsFixed(1)}K';
    return '₹${n.toStringAsFixed(0)}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _toast(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  int _matchScore(Map<String, dynamic> p) {
    final interests = _interests.toLowerCase();
    final cat = (p['category']?.toString() ?? '').toLowerCase();
    if (interests.isEmpty || cat.isEmpty) return 70;
    if (interests.contains(cat) || cat.split(' ').any((w) => interests.contains(w))) return 92;
    return 74;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InvestorDashboardScreen.softBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: InvestorDashboardScreen.primary,
        elevation: 6,
        onPressed: () => setState(() => _tab = 1),
        child: const Icon(Icons.storefront, color: Colors.white),
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
              _nav(1, Icons.storefront_outlined, Icons.storefront, 'Market'),
              const SizedBox(width: 56),
              _nav(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Portfolio'),
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
                    children: [_homeTab(), _marketTab(), _portfolioTab(), _profileTab()],
                  ),
                ),
    );
  }

  Widget _nav(int i, IconData outline, IconData filled, String label) {
    final active = _tab == i;
    final c = active ? InvestorDashboardScreen.primary : const Color(0xFF94A3B8);
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
      color: InvestorDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _topBar(),
          const SizedBox(height: 14),
          _profileHero(),
          const SizedBox(height: 14),
          _metricsGrid(),
          const SizedBox(height: 16),
          _section('Open Marketplace', action: 'Browse all', onAction: () => setState(() => _tab = 1)),
          const SizedBox(height: 8),
          _filterChips(),
          const SizedBox(height: 10),
          if (_filteredMarket.isEmpty)
            _empty('No verified proposals yet. Check back after admin approves entrepreneur pitches.')
          else
            ..._filteredMarket.take(3).map(_marketCard),
          const SizedBox(height: 16),
          _section('Recommended For You'),
          const SizedBox(height: 10),
          _recommended(),
          const SizedBox(height: 16),
          _section('Portfolio Overview', action: 'Open', onAction: () => setState(() => _tab = 2)),
          const SizedBox(height: 10),
          _portfolioOverview(),
          const SizedBox(height: 16),
          _section('Recent Activity'),
          const SizedBox(height: 10),
          _activityTimeline(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _toast('Menu coming soon'),
          icon: const Icon(Icons.menu_rounded, color: InvestorDashboardScreen.navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $_firstName! 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy),
              ),
              const Text(
                'Discover startups and grow your portfolio.',
                style: TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _tab = 3),
          child: const Text('View Profile', style: TextStyle(color: InvestorDashboardScreen.primary, fontWeight: FontWeight.w700, fontSize: 12)),
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
        IconButton(onPressed: () => _toast('Coming soon'), icon: Icon(icon, color: InvestorDashboardScreen.navy)),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: InvestorDashboardScreen.primary, shape: BoxShape.circle),
            child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _profileHero() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'I';
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
          BoxShadow(color: InvestorDashboardScreen.primary.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
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
                const Text('INVESTOR', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
                Text(_name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text(_company, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Verified Investor', style: TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.place_outlined, size: 14, color: Colors.white70),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(_location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_money(_totalInvested), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              const Text('Invested', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(height: 8),
              Text('${_portfolio.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              const Text('Startups', style: TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(height: 8),
              Text('$_activeDeals', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              const Text('Active', style: TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricsGrid() {
    final items = [
      _Metric('Invested', _money(_totalInvested), Icons.account_balance_wallet_outlined, const Color(0xFFFCE7F3)),
      _Metric('Deals', '${_portfolio.length}', Icons.handshake_outlined, const Color(0xFFE0E7FF)),
      _Metric('Market', '${_marketplace.length}', Icons.storefront_outlined, const Color(0xFFDCFCE7)),
      _Metric('ROI Avg.', '—', Icons.trending_up, const Color(0xFFFEF3C7)),
      _Metric('Pending', '$_pendingDeals', Icons.hourglass_bottom, const Color(0xFFFFE4E6)),
      _Metric('Saved', '${_marketplace.take(3).length}', Icons.bookmark_border, const Color(0xFFE0F2FE)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, i) {
        final m = items[i];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: _cardDeco(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: m.bg, borderRadius: BorderRadius.circular(9)),
                child: Icon(m.icon, size: 16, color: InvestorDashboardScreen.navy),
              ),
              const Spacer(),
              Text(m.label, style: const TextStyle(fontSize: 10, color: InvestorDashboardScreen.muted, fontWeight: FontWeight.w600)),
              Text(m.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final active = _marketFilter == f;
          return ChoiceChip(
            label: Text(f),
            selected: active,
            onSelected: (_) => setState(() => _marketFilter = f),
            selectedColor: InvestorDashboardScreen.primary,
            labelStyle: TextStyle(
              color: active ? Colors.white : InvestorDashboardScreen.navy,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            backgroundColor: Colors.white,
            side: BorderSide(color: active ? InvestorDashboardScreen.primary : const Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        },
      ),
    );
  }

  Widget _marketTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          const Text('Investment Marketplace', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
          const SizedBox(height: 6),
          const Text('Verified entrepreneur proposals open for interest.', style: TextStyle(color: InvestorDashboardScreen.muted, fontSize: 13)),
          const SizedBox(height: 12),
          _filterChips(),
          const SizedBox(height: 12),
          if (_filteredMarket.isEmpty)
            _empty('No proposals in this category yet.')
          else
            ..._filteredMarket.map(_marketCard),
        ],
      ),
    );
  }

  Widget _marketCard(Map<String, dynamic> p) {
    final raised = (p['amountRaised'] is num) ? (p['amountRaised'] as num).toDouble() : 0.0;
    final needed = (p['fundingNeeded'] is num) ? (p['fundingNeeded'] as num).toDouble() : 0.0;
    final progress = needed <= 0 ? 0.0 : (raised / needed).clamp(0.0, 1.0);
    final name = p['businessName']?.toString() ?? p['title']?.toString() ?? 'Startup';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(initial, style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
                    Text(
                      '${p['category'] ?? 'Startup'} · ${p['location'] ?? ''}',
                      style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20)),
                child: Text('${_matchScore(p)}% Match', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
              ),
            ],
          ),
          if ((p['description']?.toString() ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              p['description'].toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Seeking ${_money(needed)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('Raised ${_money(raised)}', style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFFCE7F3),
              color: InvestorDashboardScreen.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDetails(p),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: InvestorDashboardScreen.navy,
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => _investIn(p),
                  style: FilledButton.styleFrom(
                    backgroundColor: InvestorDashboardScreen.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Express Interest'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetails(Map<String, dynamic> p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 14),
            Text(p['title']?.toString() ?? 'Proposal', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
            const SizedBox(height: 6),
            Text('${p['businessName'] ?? ''} · ${p['category'] ?? ''} · ${p['location'] ?? ''}', style: const TextStyle(color: InvestorDashboardScreen.muted)),
            const SizedBox(height: 12),
            Text(p['description']?.toString() ?? 'No description provided.', style: const TextStyle(height: 1.4)),
            const SizedBox(height: 12),
            Text('Funding: ${_money(p['fundingNeeded'])} · Raised: ${_money(p['amountRaised'])}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _investIn(p);
                },
                style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary, minimumSize: const Size.fromHeight(48)),
                child: const Text('Express Interest'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommended() {
    final list = _marketplace.take(4).toList();
    if (list.isEmpty) return _empty('Recommendations appear once verified startups are live.');
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final p = list[i];
          final name = p['businessName']?.toString() ?? p['title']?.toString() ?? 'Startup';
          final score = _matchScore(p);
          return InkWell(
            onTap: () => _showDetails(p),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(12),
              decoration: _cardDeco(),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFFFE4E6),
                    child: Text(name[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
                        Text(p['category']?.toString() ?? '', style: const TextStyle(fontSize: 11, color: InvestorDashboardScreen.muted)),
                        const SizedBox(height: 4),
                        Text('$score% Match', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _portfolioOverview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _miniStat('Total Invested', _money(_totalInvested))),
              Expanded(child: _miniStat('Deals', '${_portfolio.length}')),
              Expanded(child: _miniStat('Pending', '$_pendingDeals')),
            ],
          ),
          const SizedBox(height: 14),
          const Text('6-month trend', style: TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: CustomPaint(
              painter: _SparklinePainter(color: InvestorDashboardScreen.primary),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: InvestorDashboardScreen.muted)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
      ],
    );
  }

  Widget _activityTimeline() {
    final items = <(IconData, String, String, Color)>[];
    for (final i in _portfolio.take(4)) {
      items.add((
        Icons.check_circle_outline,
        'Interest on ${i['proposalTitle'] ?? 'proposal'}',
        i['createdAt']?.toString() ?? 'Recently',
        const Color(0xFF16A34A),
      ));
    }
    if (items.isEmpty) {
      items.addAll([
        (Icons.storefront_outlined, 'Browse marketplace for verified startups', 'Now', InvestorDashboardScreen.primary),
        (Icons.bookmark_border, 'Save startups that match your interests', 'Tip', const Color(0xFF8B5CF6)),
      ]);
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        children: items.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: e.$4.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(e.$1, color: e.$4, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(e.$2, style: const TextStyle(fontWeight: FontWeight.w700, color: InvestorDashboardScreen.navy, fontSize: 13)),
                ),
                Text(e.$3, style: const TextStyle(fontSize: 11, color: InvestorDashboardScreen.muted)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _portfolioTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          const Text('My Portfolio', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy)),
          const SizedBox(height: 6),
          Text('Total invested: ${_money(_totalInvested)}', style: const TextStyle(color: InvestorDashboardScreen.muted)),
          const SizedBox(height: 14),
          _portfolioOverview(),
          const SizedBox(height: 14),
          if (_portfolio.isEmpty)
            _empty('No investments yet. Browse the marketplace to express interest.')
          else
            ..._portfolio.map((i) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(i['proposalTitle']?.toString() ?? 'Investment'),
                    subtitle: Text('Status: ${i['status'] ?? 'PENDING'}'),
                    trailing: Text(_money(i['amount']), style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHero(),
        const SizedBox(height: 14),
        _infoTile(Icons.business_outlined, 'Company / Network', _company),
        _infoTile(Icons.currency_rupee, 'Budget range', _budget),
        _infoTile(Icons.place_outlined, 'Preferred locations', _location),
        _infoTile(Icons.interests_outlined, 'Interests', _investor['investmentInterests']?.toString() ?? '—'),
        _infoTile(Icons.category_outlined, 'Categories', _investor['preferredCategories']?.toString() ?? '—'),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: InvestorDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: InvestorDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: InvestorDashboardScreen.primary),
        title: Text(label, style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: InvestorDashboardScreen.navy)),
      ),
    );
  }

  Widget _section(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy))),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action, style: const TextStyle(color: InvestorDashboardScreen.primary, fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }

  Widget _empty(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: const TextStyle(color: InvestorDashboardScreen.muted)),
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

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.18, size.height * 0.55),
      Offset(size.width * 0.34, size.height * 0.62),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.66, size.height * 0.48),
      Offset(size.width * 0.82, size.height * 0.28),
      Offset(size.width, size.height * 0.22),
    ];
    final fill = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fill.lineTo(p.dx, p.dy);
    }
    fill
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = color.withValues(alpha: 0.12),
    );
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
