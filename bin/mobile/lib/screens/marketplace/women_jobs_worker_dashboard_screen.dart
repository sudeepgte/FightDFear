import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/women_jobs_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../landing/landing_screen.dart';
import 'women_jobs_profile_completion_screen.dart';
import 'women_marketplace_screen.dart';

class WomenJobsWorkerDashboardScreen extends StatefulWidget {
  const WomenJobsWorkerDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softBg = Color(0xFFF7F8FA);

  @override
  State<WomenJobsWorkerDashboardScreen> createState() =>
      _WomenJobsWorkerDashboardScreenState();
}

class _WomenJobsWorkerDashboardScreenState
    extends State<WomenJobsWorkerDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  int? _busyBookingId;
  String? _error;
  Map<String, dynamic> _user = {};
  Map<String, dynamic>? _application;
  List<Map<String, dynamic>> _bookings = [];
  bool _verified = false;
  bool _needsProfile = false;
  double _earnings = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';

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
      final auth = context.read<AuthState>();
      final res = await WomenJobsAuthService(auth.api, auth).dashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _user = Map<String, dynamic>.from(res['user'] ?? {});
        final raw = res['application'];
        _application = raw is Map ? Map<String, dynamic>.from(raw) : null;
        _bookings = ModuleTheme.toList(res['bookings']);
        _verified = res['isVerifiedWorker'] == true;
        _needsProfile = res['needsProfileCompletion'] == true;
        _earnings = (res['totalEarnings'] is num)
            ? (res['totalEarnings'] as num).toDouble()
            : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : 0;
        _upiId = res['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? '';
      } else {
        _error = res['error']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  Future<void> _updateBookingStatus(int id, String status) async {
    if (_busyBookingId != null) return;
    setState(() => _busyBookingId = id);
    final res = await JobBookingsService(context.read<AuthState>().api)
        .updateStatus(id, status);
    if (!mounted) return;
    setState(() => _busyBookingId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Status updated to $status'
            : (res['error']?.toString() ?? 'Update failed')),
      ),
    );
    if (res['success'] == true) _load();
  }

  String get _name =>
      _user['name']?.toString() ??
      context.read<AuthState>().name ??
      'Worker';

  String get _firstName {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'Worker' : parts.first;
  }

  String get _phone => _user['phone']?.toString() ?? '';
  String get _email => _user['email']?.toString() ?? '';
  String get _category => _application?['jobCategory']?.toString() ?? 'Not set';
  String get _role => _application?['jobSubCategory']?.toString() ?? '—';
  String get _status =>
      (_application?['status']?.toString() ?? (_needsProfile ? 'INCOMPLETE' : 'PENDING'))
          .toUpperCase();

  bool get _approved => _verified || _status == 'VERIFIED';

  String get _statusLabel {
    if (_approved) return 'Verified';
    if (_status == 'REJECTED') return 'Rejected';
    if (_application == null) return 'Incomplete';
    return 'Pending review';
  }

  Color get _statusBg {
    if (_approved) return const Color(0xFFDCFCE7);
    if (_status == 'REJECTED') return const Color(0xFFFFE4E6);
    if (_application == null) return const Color(0xFFE2E8F0);
    return const Color(0xFFFEF3C7);
  }

  Color get _statusFg {
    if (_approved) return const Color(0xFF166534);
    if (_status == 'REJECTED') return const Color(0xFFBE123C);
    if (_application == null) return const Color(0xFF475569);
    return const Color(0xFFB45309);
  }

  List<Map<String, dynamic>> get _pendingBookings => _bookings
      .where((b) => (b['status']?.toString() ?? 'PENDING').toUpperCase() == 'PENDING')
      .toList();

  int get _completedCount => _bookings
      .where((b) => (b['status']?.toString() ?? '').toUpperCase() == 'COMPLETED')
      .length;

  int get _acceptedCount => _bookings
      .where((b) => (b['status']?.toString() ?? '').toUpperCase() == 'ACCEPTED')
      .length;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _openProfileForm() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => WomenJobsProfileCompletionScreen(
            onFinished: (ctx) => Navigator.of(ctx).pop(),
          ),
        ))
        .then((_) => _load());
  }

  Future<void> _requestPayout() async {
    final res = await WomenJobsAuthService(context.read<AuthState>().api, context.read<AuthState>())
        .requestPayout();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? (res['message']?.toString() ?? 'Requested')
            : (res['error']?.toString() ?? 'Payout failed')),
      ),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _editNotes(Map<String, dynamic> b) async {
    final bid = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
    if (bid == null) return;
    final ctrl = TextEditingController(text: b['coachNotes']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Visit notes / file'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Client notes, address tips, follow-up…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await JobBookingsService(context.read<AuthState>().api)
        .updateNotes(bid, ctrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Notes saved'
            : (res['error']?.toString() ?? 'Could not save notes')),
      ),
    );
    if (res['success'] == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WomenJobsWorkerDashboardScreen.softBg,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
              _navItem(
                1,
                Icons.event_note_outlined,
                Icons.event_note,
                'Bookings',
                badge: _pendingBookings.length,
              ),
              _navItem(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Finance'),
              _navItem(3, Icons.person_outline, Icons.person, 'Profile'),
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
                    children: [
                      _homeTab(),
                      _bookingsTab(),
                      _financeTab(),
                      _profileTab(),
                    ],
                  ),
                ),
    );
  }

  Widget _navItem(int index, IconData outline, IconData filled, String label,
      {int badge = 0}) {
    final active = _tab == index;
    final color = active
        ? WomenJobsWorkerDashboardScreen.primary
        : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(active ? filled : outline, color: color, size: 22),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: WomenJobsWorkerDashboardScreen.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeTab() {
    return RefreshIndicator(
      color: WomenJobsWorkerDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting()}, $_firstName!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenJobsWorkerDashboardScreen.navy,
                      ),
                    ),
                    const Text(
                      "Here's what's happening with your jobs today.",
                      style: TextStyle(
                          fontSize: 12, color: WomenJobsWorkerDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: WomenJobsWorkerDashboardScreen.navy),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _profileHeroCard(),
          if (!_approved) ...[
            const SizedBox(height: 12),
            _banner(
              _application == null
                  ? 'Complete your worker profile so admin can verify you.'
                  : _status == 'REJECTED'
                      ? 'Your application was not approved. Update your profile and submit again.'
                      : 'Your profile is under admin review. Clients can book you after approval.',
            ),
          ],
          const SizedBox(height: 14),
          _statsGrid(),
          const SizedBox(height: 16),
          _sectionTitle('Quick Actions'),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 18),
          _sectionTitle(
            'Incoming Bookings',
            action: 'View all',
            onAction: () => setState(() => _tab = 1),
          ),
          const SizedBox(height: 10),
          if (!_approved)
            _emptyCard('Bookings unlock after admin verification.')
          else if (_bookings.isEmpty)
            _emptyCard('No job bookings yet. New client requests will appear here.')
          else
            ..._bookings.take(4).map(_bookingCard),
        ],
      ),
    );
  }

  Widget _profileHeroCard() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'W';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: WomenJobsWorkerDashboardScreen.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WOMEN JOBS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: WomenJobsWorkerDashboardScreen.primary,
                      ),
                    ),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenJobsWorkerDashboardScreen.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _statusFg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metaStat('Category', _category),
              _metaStat('Role', _role),
              _metaStat(
                'Rate',
                _application?['hourlyRate'] == null
                    ? '—'
                    : 'Rs ${_application!['hourlyRate']}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: WomenJobsWorkerDashboardScreen.muted)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: WomenJobsWorkerDashboardScreen.navy,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    final items = [
      _DashStat(Icons.account_balance_wallet_outlined, 'Earnings',
          'Rs ${_earnings.toStringAsFixed(0)}', const Color(0xFFFCE7F3)),
      _DashStat(Icons.inbox_outlined, 'New requests', '${_pendingBookings.length}',
          const Color(0xFFFEF3C7)),
      _DashStat(Icons.check_circle_outline, 'Accepted', '$_acceptedCount',
          const Color(0xFFDCFCE7)),
      _DashStat(Icons.task_alt_outlined, 'Completed', '$_completedCount',
          const Color(0xFFE0E7FF)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) {
        final s = items[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(12)),
                child: Icon(s.icon, color: WomenJobsWorkerDashboardScreen.navy, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: WomenJobsWorkerDashboardScreen.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      s.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: WomenJobsWorkerDashboardScreen.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickActions() {
    final actions = <({IconData icon, String label, Color color, VoidCallback onTap})>[
      (
        icon: Icons.edit_outlined,
        label: 'Profile',
        color: const Color(0xFF8B5CF6),
        onTap: _openProfileForm,
      ),
      (
        icon: Icons.event_note_outlined,
        label: 'Bookings',
        color: const Color(0xFF3B82F6),
        onTap: () => setState(() => _tab = 1),
      ),
      (
        icon: Icons.storefront_outlined,
        label: 'Marketplace',
        color: WomenJobsWorkerDashboardScreen.primary,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WomenMarketplaceScreen()),
          );
        },
      ),
    ];
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final a = actions[i];
          return InkWell(
            onTap: a.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 88,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a.icon, color: a.color, size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: WomenJobsWorkerDashboardScreen.navy,
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

  Widget _bookingsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          const Text(
            'Job Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: WomenJobsWorkerDashboardScreen.navy,
            ),
          ),
          const SizedBox(height: 12),
          if (!_approved)
            _emptyCard('Incoming bookings appear here after admin verifies your profile.')
          else if (_bookings.isEmpty)
            _emptyCard('No bookings yet.')
          else
            ..._bookings.map(_bookingCard),
        ],
      ),
    );
  }

  Widget _bookingCard(Map<String, dynamic> b) {
    final id = b['id'];
    final status = (b['status']?.toString() ?? 'PENDING').toUpperCase();
    final client = b['clientName']?.toString() ?? 'Client';
    final when = b['bookingDate']?.toString() ?? '';
    final note = b['note']?.toString() ?? '';
    final phone = b['clientPhone']?.toString() ?? '';
    final initial = client.isNotEmpty ? client[0].toUpperCase() : 'C';
    final bid = id is int ? id : int.tryParse('$id');
    final busy = bid != null && _busyBookingId == bid;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: WomenJobsWorkerDashboardScreen.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: WomenJobsWorkerDashboardScreen.navy)),
                    Text(
                      when.isEmpty ? (note.isEmpty ? 'Job booking' : note) : when,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: WomenJobsWorkerDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              _statusPill(status),
            ],
          ),
          if (b['totalAmount'] != null) ...[
            const SizedBox(height: 6),
            Text(
              'Rs ${b['totalAmount']}${b['hours'] != null ? ' · ${b['hours']} hrs' : ''}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: WomenJobsWorkerDashboardScreen.navy),
            ),
          ],
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(phone, style: const TextStyle(fontSize: 12, color: WomenJobsWorkerDashboardScreen.muted)),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (status == 'PENDING') ...[
                OutlinedButton(
                  onPressed: busy || bid == null
                      ? null
                      : () => _updateBookingStatus(bid, 'ACCEPTED'),
                  child: Text(busy ? 'Updating…' : 'Accept'),
                ),
                FilledButton(
                  onPressed: busy || bid == null
                      ? null
                      : () => _updateBookingStatus(bid, 'REJECTED'),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFBE123C)),
                  child: const Text('Reject'),
                ),
              ],
              if (status == 'ACCEPTED')
                FilledButton(
                  onPressed: busy || bid == null
                      ? null
                      : () => _updateBookingStatus(bid, 'COMPLETED'),
                  style: FilledButton.styleFrom(
                      backgroundColor: WomenJobsWorkerDashboardScreen.primary),
                  child: const Text('Complete'),
                ),
              OutlinedButton(
                onPressed: () => _editNotes(b),
                child: const Text('Notes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'ACCEPTED':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'COMPLETED':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF3730A3);
        break;
      case 'REJECTED':
        bg = const Color(0xFFFFE4E6);
        fg = const Color(0xFFBE123C);
        break;
      default:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  Widget _financeTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined,
                color: WomenJobsWorkerDashboardScreen.primary),
            title: const Text('Payout balance'),
            subtitle: Text(_upiId.isEmpty
                ? 'Add UPI in Complete Profile to withdraw'
                : 'UPI: $_upiId'),
            trailing: Text(
              '₹${_payoutBalance.round()}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Confirmed earnings'),
            trailing: Text(
              '₹${_earnings.round()}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _requestPayout,
          style: FilledButton.styleFrom(
            backgroundColor: WomenJobsWorkerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 12),
        if (_cancelPolicy.isNotEmpty)
          Text(_cancelPolicy, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
      ],
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _profileHeroCard(),
        const SizedBox(height: 16),
        if (_email.isNotEmpty)
          _infoTile(Icons.email_outlined, 'Email', _email),
        if (_phone.isNotEmpty) ...[
          const SizedBox(height: 8),
          _infoTile(Icons.phone_outlined, 'Phone', _phone),
        ],
        const SizedBox(height: 8),
        _infoTile(Icons.category_outlined, 'Category', '$_category · $_role'),
        if ((_application?['note']?.toString() ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          _infoTile(Icons.notes_outlined, 'Profile details', _application!['note'].toString()),
        ],
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: _openProfileForm,
          child: Text(_application == null || _status == 'REJECTED'
              ? 'Complete worker profile'
              : 'Update profile'),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: WomenJobsWorkerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: WomenJobsWorkerDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _sectionTitle(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: WomenJobsWorkerDashboardScreen.navy,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: WomenJobsWorkerDashboardScreen.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _banner(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _statusBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusFg),
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: const TextStyle(color: WomenJobsWorkerDashboardScreen.muted)),
    );
  }
}

class _DashStat {
  const _DashStat(this.icon, this.label, this.value, this.bg);
  final IconData icon;
  final String label;
  final String value;
  final Color bg;
}
