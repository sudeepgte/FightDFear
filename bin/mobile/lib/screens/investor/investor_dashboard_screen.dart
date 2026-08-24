import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/funding_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../funding/funding_chat_screen.dart';
import '../funding/funding_chat_threads_screen.dart';
import '../funding/funding_meetings_screen.dart';
import '../funding/funding_menu_sheet.dart';
import '../funding/funding_notifications_screen.dart';
import '../landing/landing_screen.dart';
import 'investor_profile_completion_screen.dart';

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
  bool _canInvest = false;
  bool _investBusy = false;
  bool _withdrawBusy = false;
  String? _error;
  String _marketFilter = 'All';
  String _sort = 'newest';
  final _cityFilter = TextEditingController();
  Map<String, dynamic> _investor = {};
  List<Map<String, dynamic>> _portfolio = [];
  List<Map<String, dynamic>> _marketplace = [];
  double _totalInvested = 0;

  InvestorAuthService get _svc => InvestorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _cityFilter.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (res['success'] == true) {
        _investor = Map<String, dynamic>.from(res['investor'] ?? {});
        _portfolio = ModuleTheme.toList(res['portfolio'] ?? res['investments']);
        _marketplace = ModuleTheme.toList(res['marketplace']);
        _totalInvested = (res['totalInvested'] is num) ? (res['totalInvested'] as num).toDouble() : 0;
        final market = await _svc.marketplace(
          category: _marketFilter == 'All' ? null : _marketFilter,
          city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
          sort: _sort,
        );
        if (market['success'] == true) {
          _marketplace = ModuleTheme.toList(market['marketplace']);
        }
        final apiCan = res['canInvest'] == true || _investor['canInvest'] == true;
        final status = (_investor['partnerProfileStatus']?.toString() ?? '').toUpperCase();
        _canInvest = apiCan || status == 'APPROVED';
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  String get _partnerStatus =>
      (_investor['partnerProfileStatus']?.toString() ?? '').toUpperCase();

  String get _verificationStatus =>
      (_investor['verificationStatus']?.toString() ?? '').toUpperCase();

  bool get _verified =>
      _canInvest || _partnerStatus == 'APPROVED' || _verificationStatus == 'VERIFIED';

  bool get _subscribed => _investor['subscribed'] == true;

  bool get _needsProfile {
    const incomplete = {
      'PROFILE_INCOMPLETE',
      'REGISTERED',
      'READY_FOR_VERIFICATION',
      'CHANGES_REQUESTED',
      'REJECTED',
    };
    return incomplete.contains(_partnerStatus);
  }

  String get _statusBadgeLabel {
    if (_verified || _partnerStatus == 'APPROVED') return 'Approved';
    if (_partnerStatus == 'REJECTED' || _verificationStatus == 'REJECTED') {
      return 'Rejected';
    }
    if (_partnerStatus == 'CHANGES_REQUESTED') return 'Changes Requested';
    if (_partnerStatus == 'PENDING_ADMIN_APPROVAL' ||
        _partnerStatus == 'READY_FOR_VERIFICATION' ||
        _verificationStatus == 'PENDING') {
      return 'Pending';
    }
    return 'Incomplete';
  }

  Color get _statusBadgeBg {
    switch (_statusBadgeLabel) {
      case 'Approved':
        return const Color(0xFFDCFCE7);
      case 'Rejected':
        return const Color(0xFFFFE4E6);
      case 'Pending':
      case 'Changes Requested':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFE2E8F0);
    }
  }

  Color get _statusBadgeFg {
    switch (_statusBadgeLabel) {
      case 'Approved':
        return const Color(0xFF166534);
      case 'Rejected':
        return const Color(0xFFBE123C);
      case 'Pending':
      case 'Changes Requested':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF475569);
    }
  }

  Future<void> _openProfileCompletion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvestorProfileCompletionScreen(
          onFinished: (ctx) => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (mounted) _load();
  }

  Future<void> _logout() async {
    try {
      await _svc.logout();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  Future<void> _investIn(Map<String, dynamic> proposal) async {
    if (!_verified) {
      _toast(
        'Your investor account must be verified before expressing interest. '
        'Complete your profile and wait for admin approval.',
        error: true,
      );
      return;
    }
    if (!_subscribed) {
      _toast('Premium subscription is required to express interest.', error: true);
      await _subscribe();
      return;
    }
    if (_investBusy) return;

    final id = proposal['id'];
    final pid = id is int ? id : int.tryParse('$id');
    if (pid == null) return;

    final openRemaining = _num(proposal['openRemaining']);
    final alreadyPending = proposal['alreadyInterested'] == true &&
        (proposal['myStatus']?.toString() ?? '').toUpperCase() == 'PENDING';
    final existingAmount = _num(proposal['myAmount']);
    // When updating pending interest, own amount is already counted in pending,
    // so max allowed is openRemaining + existingAmount.
    final maxAmount = alreadyPending ? openRemaining + existingAmount : openRemaining;
    final amountCtrl = TextEditingController(
      text: alreadyPending && existingAmount > 0
          ? existingAmount.toStringAsFixed(0)
          : '',
    );

    double? submittedAmount;
    try {
      submittedAmount = await showDialog<double>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          String? localError;
          return StatefulBuilder(
            builder: (ctx, setLocal) => AlertDialog(
              title: Text(
                alreadyPending
                    ? 'Update interest'
                    : 'Invest in ${proposal['title'] ?? 'Proposal'}',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seeking ${_money(proposal['fundingNeeded'] ?? 0)} · '
                    'Raised ${_money(proposal['amountRaised'] ?? 0)}',
                    style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Open remaining: ${_money(maxAmount)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: InvestorDashboardScreen.navy,
                    ),
                  ),
                  if (alreadyPending) ...[
                    const SizedBox(height: 6),
                    Text(
                      'You already have pending interest. You can update the amount.',
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Investment amount (Rs)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 8),
                    Text(localError!, style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary),
                  onPressed: () {
                    final amount = double.tryParse(amountCtrl.text.trim()) ?? 0;
                    if (amount <= 0) {
                      setLocal(() => localError = 'Amount must be greater than 0');
                      return;
                    }
                    if (amount > maxAmount + 0.0001) {
                      setLocal(() => localError =
                          'Amount cannot exceed open remaining (${_money(maxAmount)})');
                      return;
                    }
                    // Pop with the amount — do not setState right before dispose.
                    Navigator.pop(ctx, amount);
                  },
                  child: Text(alreadyPending ? 'Update Amount' : 'Express Interest'),
                ),
              ],
            ),
          );
        },
      );
    } finally {
      // Dispose after the dialog route has finished tearing down its TextField.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        amountCtrl.dispose();
      });
    }

    if (submittedAmount == null || !mounted) return;
    final amount = submittedAmount;
    if (amount <= 0 || amount > maxAmount + 0.0001) return;

    setState(() => _investBusy = true);
    try {
      final res = await _svc.invest({
        'proposalId': pid,
        'amount': amount,
      });
      if (!mounted) return;
      final success = res['success'] == true;
      _toast(
        success
            ? (res['message']?.toString() ??
                (alreadyPending ? 'Interest amount updated' : 'Investment interest submitted'))
            : '${res['error'] ?? 'Failed to submit interest'}',
        error: !success,
      );
      if (success) await _load();
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    } finally {
      if (mounted) setState(() => _investBusy = false);
    }
  }

  Future<void> _withdrawInterest(Map<String, dynamic> item) async {
    if (_withdrawBusy) return;
    final idRaw = item['id'] ?? item['investmentId'];
    final id = idRaw is int ? idRaw : int.tryParse('$idRaw');
    if (id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Withdraw interest?'),
        content: Text(
          'Withdraw your pending interest in "${item['proposalTitle'] ?? 'this proposal'}"?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _withdrawBusy = true);
    try {
      final res = await _svc.withdrawInterest(id);
      if (!mounted) return;
      final success = res['success'] == true;
      _toast(
        success
            ? (res['message']?.toString() ?? 'Interest withdrawn')
            : '${res['error'] ?? 'Failed to withdraw'}',
        error: !success,
      );
      if (success) await _load();
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    } finally {
      if (mounted) setState(() => _withdrawBusy = false);
    }
  }

  Future<void> _writeReview(Map<String, dynamic> item) async {
    final idRaw = item['id'] ?? item['investmentId'];
    final id = idRaw is int ? idRaw : int.tryParse('$idRaw');
    if (id == null) return;
    int rating = 5;
    final comment = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this raise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: rating,
                decoration: const InputDecoration(labelText: 'Rating', border: OutlineInputBorder()),
                items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}'))),
                onChanged: (v) => setLocal(() => rating = v ?? 5),
              ),
              const SizedBox(height: 10),
              TextField(controller: comment, maxLines: 3, decoration: const InputDecoration(hintText: 'How was the collaboration?', border: OutlineInputBorder())),
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
    final res = await _svc.rateInvestment(id, rating: rating, review: comment.text.trim());
    if (!mounted) return;
    _toast(res['success'] == true ? 'Thanks for the review' : '${res['error'] ?? 'Failed'}', error: res['success'] != true);
    if (res['success'] == true) _load();
  }

  String get _name => _investor['fullName']?.toString() ?? 'Investor';
  String get _firstName => _name.trim().split(RegExp(r'\s+')).first;
  String get _company => _investor['companyName']?.toString() ?? 'Independent Investor';
  String get _budget => _investor['budgetRange']?.toString() ?? '—';
  String get _location => _investor['preferredLocations']?.toString() ?? '—';
  String get _interests =>
      _investor['preferredCategories']?.toString() ??
      _investor['investmentInterests']?.toString() ??
      '';

  int get _activeDeals =>
      _portfolio.where((i) => (i['status']?.toString() ?? '').toUpperCase() == 'PENDING').length;

  int get _completedDeals =>
      _portfolio.where((i) => (i['status']?.toString() ?? '').toUpperCase() == 'COMPLETED').length;

  List<String> get _filters => ['All', ...FundingCatalog.categories];

  List<Map<String, dynamic>> get _filteredMarket {
    if (_marketFilter == 'All') return _marketplace;
    return _marketplace.where((p) {
      final cat = FundingCatalog.labelFor(p['category']?.toString());
      return cat.toLowerCase() == _marketFilter.toLowerCase();
    }).toList();
  }

  double _num(Object? v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  String _money(Object? v) {
    final n = _num(v);
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

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : Colors.teal,
      ),
    );
  }

  bool _matchesInterest(Map<String, dynamic> p) {
    final interests = _interests.toLowerCase();
    final cat = FundingCatalog.labelFor(p['category']?.toString()).toLowerCase();
    if (interests.isEmpty || cat.isEmpty || cat == 'startup') return false;
    return interests.contains(cat) || cat.split(' ').any((w) => w.isNotEmpty && interests.contains(w));
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
          if (!_verified) ...[
            const SizedBox(height: 14),
            _statusBanner(),
          ],
          if (_verified && !_subscribed) ...[
            const SizedBox(height: 14),
            _subscribeBanner(),
          ],
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

  Widget _statusBanner() {
    String message;
    String cta = 'Complete profile';

    if (_partnerStatus == 'REJECTED' || _verificationStatus == 'REJECTED') {
      final reason = _investor['rejectionReason']?.toString();
      message = reason != null && reason.isNotEmpty
          ? 'Your profile was rejected: $reason'
          : 'Your profile was rejected. Update details and resubmit.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'CHANGES_REQUESTED') {
      final note = _investor['changesRequestedNote']?.toString();
      message = note != null && note.isNotEmpty
          ? 'Changes requested: $note'
          : 'Admin requested profile changes before approval.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'PENDING_ADMIN_APPROVAL') {
      message =
          'Profile submitted. Waiting for admin verification before you can invest.';
      cta = 'View profile';
    } else if (_partnerStatus == 'READY_FOR_VERIFICATION') {
      message =
          'Your profile looks ready. Submit for verification to unlock investing.';
      cta = 'Finish profile';
    } else {
      message =
          'Complete your investor profile and get verified to express interest in startups.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFBBF24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _openProfileCompletion,
              style: FilledButton.styleFrom(
                backgroundColor: InvestorDashboardScreen.primary,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(cta),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribe() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Premium Investor'),
        content: const Text(
          'Unlock investments and meeting requests with a Premium subscription (Rs 1999, mock payment).',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      final res = await _svc.subscribe();
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Subscribed');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Subscribe failed', error: true);
      }
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    }
  }

  Widget _subscribeBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA5B4FC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium required to invest and request meetings.',
            style: TextStyle(
              color: Color(0xFF312E81),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _subscribe,
              style: FilledButton.styleFrom(
                backgroundColor: InvestorDashboardScreen.primary,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Subscribe · Rs 1999'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => showFundingMenuSheet(
            context,
            isEntrepreneur: false,
            showSubscribe: !_subscribed,
            onProfile: () => setState(() => _tab = 3),
          ),
          icon: const Icon(Icons.menu_rounded, color: InvestorDashboardScreen.navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $_firstName!',
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
          child: const Text(
            'View Profile',
            style: TextStyle(
              color: InvestorDashboardScreen.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FundingNotificationsScreen(isEntrepreneur: false),
              ),
            );
          },
          icon: const Icon(Icons.notifications_none_rounded, color: InvestorDashboardScreen.navy),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FundingChatThreadsScreen(isEntrepreneur: false),
              ),
            );
          },
          icon: const Icon(Icons.chat_bubble_outline_rounded, color: InvestorDashboardScreen.navy),
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
                      decoration: BoxDecoration(color: _statusBadgeBg, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _verified ? Icons.verified : Icons.hourglass_top,
                            size: 12,
                            color: _statusBadgeFg,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _statusBadgeLabel,
                            style: TextStyle(color: _statusBadgeFg, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.place_outlined, size: 14, color: Colors.white70),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        _location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
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
              const Text('Deals', style: TextStyle(color: Colors.white70, fontSize: 10)),
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
      _Metric('Active', '$_activeDeals', Icons.hourglass_bottom, const Color(0xFFFFE4E6)),
      _Metric('Completed', '$_completedDeals', Icons.check_circle_outline, const Color(0xFFDCFCE7)),
      _Metric('Open', '${_marketplace.length}', Icons.explore_outlined, const Color(0xFFE0F2FE)),
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
              Text(
                m.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy),
              ),
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
            onSelected: (_) {
              setState(() => _marketFilter = f);
              _load();
            },
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
          const SizedBox(height: 8),
          TextField(
            controller: _cityFilter,
            decoration: InputDecoration(
              hintText: 'City',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _load),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _load(),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              ChoiceChip(
                label: const Text('Top rated'),
                selected: _sort == 'rating',
                onSelected: (_) {
                  setState(() => _sort = 'rating');
                  _load();
                },
              ),
              ChoiceChip(
                label: const Text('Funding'),
                selected: _sort == 'funding',
                onSelected: (_) {
                  setState(() => _sort = 'funding');
                  _load();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(FundingCatalog.cancelPolicy, style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted)),
          const SizedBox(height: 12),
          if (_filteredMarket.isEmpty)
            _empty(
              _marketplace.isEmpty
                  ? 'No verified proposals yet. Check back after admin approves entrepreneur pitches.'
                  : 'No proposals in this category yet.',
            )
          else
            ..._filteredMarket.map(_marketCard),
        ],
      ),
    );
  }

  Widget _marketCard(Map<String, dynamic> p) {
    final raised = _num(p['amountRaised']);
    final needed = _num(p['fundingNeeded']);
    final openRemaining = _num(p['openRemaining']);
    final progress = needed <= 0 ? 0.0 : (raised / needed).clamp(0.0, 1.0);
    final name = p['businessName']?.toString() ?? p['title']?.toString() ?? 'Startup';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    final category = FundingCatalog.labelFor(p['category']?.toString());
    final matched = _matchesInterest(p);
    final alreadyPending = p['alreadyInterested'] == true &&
        (p['myStatus']?.toString() ?? '').toUpperCase() == 'PENDING';

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
                      '$category · ${p['location'] ?? ''}',
                      style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              if (matched)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFCE7F3), borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Interest match',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary),
                  ),
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
              Text('Open ${_money(openRemaining)}', style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted, fontWeight: FontWeight.w600)),
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
                  onPressed: () => _showProposalDetails(p),
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
                  onPressed: _investBusy ? null : () => _investIn(p),
                  style: FilledButton.styleFrom(
                    backgroundColor: InvestorDashboardScreen.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(alreadyPending ? 'Update Interest' : 'Express Interest'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProposalDetails(Map<String, dynamic> p) {
    final category = FundingCatalog.labelFor(p['category']?.toString());
    final alreadyPending = p['alreadyInterested'] == true &&
        (p['myStatus']?.toString() ?? '').toUpperCase() == 'PENDING';
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
            Text(
              '${p['businessName'] ?? ''} · $category · ${p['location'] ?? ''}',
              style: const TextStyle(color: InvestorDashboardScreen.muted),
            ),
            const SizedBox(height: 12),
            Text(p['description']?.toString() ?? 'No description provided.', style: const TextStyle(height: 1.4)),
            const SizedBox(height: 12),
            Text(
              'Funding: ${_money(p['fundingNeeded'])} · Raised: ${_money(p['amountRaised'])} · Open: ${_money(p['openRemaining'])}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _investBusy
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        _investIn(p);
                      },
                style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary, minimumSize: const Size.fromHeight(48)),
                child: Text(alreadyPending ? 'Update Interest' : 'Express Interest'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FundingMeetingsScreen(
                            isEntrepreneur: false,
                            proposalId: id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.event_available_outlined, size: 18),
                    label: const Text('Meeting'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
                      if (id == null) return;
                      Navigator.pop(ctx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FundingChatScreen(
                            isEntrepreneur: false,
                            proposalId: id,
                            title: p['title']?.toString(),
                            peerName: p['entrepreneurName']?.toString() ??
                                p['businessName']?.toString(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('Chat'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommended() {
    final preferred = _marketplace.where(_matchesInterest).toList();
    final list = (preferred.isNotEmpty ? preferred : _marketplace).take(4).toList();
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
          final category = FundingCatalog.labelFor(p['category']?.toString());
          return InkWell(
            onTap: () => _showProposalDetails(p),
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
                        Text(category, style: const TextStyle(fontSize: 11, color: InvestorDashboardScreen.muted)),
                        if (_matchesInterest(p)) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Interest match',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary),
                          ),
                        ],
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
      child: Row(
        children: [
          Expanded(child: _miniStat('Total Invested', _money(_totalInvested))),
          Expanded(child: _miniStat('Active', '$_activeDeals')),
          Expanded(child: _miniStat('Completed', '$_completedDeals')),
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
      final status = (i['status']?.toString() ?? 'PENDING').toUpperCase();
      items.add((
        status == 'COMPLETED' ? Icons.check_circle_outline : Icons.hourglass_bottom,
        '${status == 'COMPLETED' ? 'Completed' : 'Pending'} interest on ${i['proposalTitle'] ?? 'proposal'}',
        i['createdAt']?.toString() ?? 'Recently',
        status == 'COMPLETED' ? const Color(0xFF16A34A) : InvestorDashboardScreen.primary,
      ));
    }
    if (items.isEmpty) {
      return _empty(
        _verified
            ? 'No activity yet. Browse the marketplace to express interest.'
            : 'Complete verification to start investing and see activity here.',
      );
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
          Text(
            'Total invested: ${_money(_totalInvested)} · Active: $_activeDeals · Completed: $_completedDeals',
            style: const TextStyle(color: InvestorDashboardScreen.muted),
          ),
          const SizedBox(height: 14),
          _portfolioOverview(),
          const SizedBox(height: 14),
          if (_portfolio.isEmpty)
            _empty('No investments yet. Browse the marketplace to express interest.')
          else
            ..._portfolio.map(_portfolioCard),
        ],
      ),
    );
  }

  Widget _portfolioCard(Map<String, dynamic> i) {
    final status = (i['status']?.toString() ?? 'PENDING').toUpperCase();
    final canWithdraw = i['canWithdraw'] == true || status == 'PENDING';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: _cardDeco(),
      child: ListTile(
        onTap: () => _showPortfolioDetails(i),
        title: Text(
          i['proposalTitle']?.toString() ?? 'Investment',
          style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy),
        ),
        subtitle: Text('Status: $status'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_money(i['amount']), style: const TextStyle(fontWeight: FontWeight.w800, color: InvestorDashboardScreen.primary)),
            if (canWithdraw)
              Text(
                'Withdraw available',
                style: TextStyle(fontSize: 10, color: Colors.orange.shade800, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }

  void _showPortfolioDetails(Map<String, dynamic> i) {
    final status = (i['status']?.toString() ?? 'PENDING').toUpperCase();
    final canWithdraw = i['canWithdraw'] == true || status == 'PENDING';
    final proposal = i['proposal'] is Map
        ? Map<String, dynamic>.from(i['proposal'] as Map)
        : <String, dynamic>{};

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
            Text(
              i['proposalTitle']?.toString() ?? proposal['title']?.toString() ?? 'Investment',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: InvestorDashboardScreen.navy),
            ),
            const SizedBox(height: 8),
            Text('Status: $status', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Amount: ${_money(i['amount'])}', style: const TextStyle(fontWeight: FontWeight.w700)),
            if ((i['createdAt']?.toString() ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Created: ${i['createdAt']}', style: const TextStyle(color: InvestorDashboardScreen.muted, fontSize: 12)),
            ],
            if (proposal.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '${FundingCatalog.labelFor(proposal['category']?.toString())} · ${proposal['location'] ?? ''}',
                style: const TextStyle(color: InvestorDashboardScreen.muted),
              ),
              if ((proposal['description']?.toString() ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(proposal['description'].toString(), style: const TextStyle(height: 1.4)),
              ],
            ],
            const SizedBox(height: 16),
            if (canWithdraw)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _withdrawBusy
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          _withdrawInterest(i);
                        },
                  icon: const Icon(Icons.undo),
                  label: const Text('Withdraw Interest'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            if (i['canReview'] == true) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _writeReview(i);
                  },
                  style: FilledButton.styleFrom(backgroundColor: InvestorDashboardScreen.primary),
                  child: const Text('Write a review'),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(FundingCatalog.cancelPolicy, style: const TextStyle(fontSize: 12, color: InvestorDashboardScreen.muted)),
          ],
        ),
      ),
    );
  }

  Widget _profileTab() {
    final rejection = _investor['rejectionReason']?.toString();
    final changesNote = _investor['changesRequestedNote']?.toString();
    final statusLabel = _investor['partnerProfileStatusLabel']?.toString() ?? _statusBadgeLabel;
    final pct = _investor['profileCompletionPct'];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHero(),
        const SizedBox(height: 14),
        if (_needsProfile)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FilledButton.icon(
              onPressed: _openProfileCompletion,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Complete / update profile'),
              style: FilledButton.styleFrom(
                backgroundColor: InvestorDashboardScreen.primary,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ),
        _infoTile(
          Icons.verified_outlined,
          'Status',
          '$statusLabel${pct != null ? ' · $pct% complete' : ''}',
        ),
        if (rejection != null && rejection.isNotEmpty)
          _infoTile(Icons.report_outlined, 'Rejection reason', rejection),
        if (changesNote != null && changesNote.isNotEmpty)
          _infoTile(Icons.edit_note_outlined, 'Changes requested', changesNote),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
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
