import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import '../landing/landing_screen.dart';
import 'marketplace_booking_chat_screen.dart';
import 'women_lawyer_profile_completion_screen.dart';

class WomenLawyerDashboardScreen extends StatefulWidget {
  const WomenLawyerDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softBg = Color(0xFFF7F8FA);

  @override
  State<WomenLawyerDashboardScreen> createState() =>
      _WomenLawyerDashboardScreenState();
}

class _WomenLawyerDashboardScreenState extends State<WomenLawyerDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  int? _busyBookingId;
  String? _error;
  Map<String, dynamic> _provider = {};
  List<Map<String, dynamic>> _bookings = [];
  double _earnings = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';

  MarketplaceProviderAuthService get _svc =>
      MarketplaceProviderAuthService(context.read<AuthState>().api);

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
      final res = await _svc.dashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _provider = Map<String, dynamic>.from(res['provider'] ?? {});
        _bookings = ModuleTheme.toList(res['bookings']);
        _earnings = (res['totalEarnings'] is num) ? (res['totalEarnings'] as num).toDouble() : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_provider['payoutBalance'] is num)
                ? (_provider['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _provider['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? '';
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
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  Future<void> _requestPayout() async {
    final res = await _svc.requestPayout();
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
        title: const Text('Consult notes / file'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Case notes, documents requested, follow-up…',
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
    final res = await _svc.updateBookingNotes(bid, ctrl.text.trim());
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

  Future<void> _updateStatus(int id, String status) async {
    if (_busyBookingId != null) return;
    setState(() => _busyBookingId = id);
    final res = await _svc.updateBookingStatus(id, status);
    if (!mounted) return;
    setState(() => _busyBookingId = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Updated to $status'
            : (res['error']?.toString() ?? 'Update failed')),
      ),
    );
    if (res['success'] == true) _load();
  }

  String get _name => _provider['fullName']?.toString() ?? 'Lawyer';
  String get _firstName {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'Lawyer' : parts.first;
  }

  String get _phone => _provider['phone']?.toString() ?? '';
  String get _email => _provider['email']?.toString() ?? '';
  String get _location => _provider['locationText']?.toString() ?? 'Location not set';
  String get _areas => _provider['practiceAreas']?.toString() ?? 'Practice areas not set';
  bool get _approved =>
      _provider['partnerProfileStatus']?.toString() == 'APPROVED' ||
      _provider['canCreateClass'] == true;

  String get _statusLabel =>
      _provider['partnerProfileStatusLabel']?.toString() ??
      (_approved ? 'Approved' : 'Pending verification');

  List<Map<String, dynamic>> get _pending => _bookings
      .where((b) => (b['status']?.toString() ?? 'PENDING').toUpperCase() == 'PENDING')
      .toList();

  int get _confirmed => _bookings
      .where((b) {
        final s = (b['status']?.toString() ?? '').toUpperCase();
        return s == 'CONFIRMED' || s == 'ACCEPTED' || s == 'PAID';
      })
      .length;

  int get _completed => _bookings
      .where((b) => (b['status']?.toString() ?? '').toUpperCase() == 'COMPLETED')
      .length;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => const WomenLawyerProfileCompletionScreen(),
        ))
        .then((_) => _load());
  }

  List<String> get _missing {
    final raw = _provider['missingItems'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return [];
  }

  double get _pct {
    final v = _provider['profileCompletionPct'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        backgroundColor: WomenLawyerDashboardScreen.softBg,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          elevation: 12,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _navItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Home'),
                _navItem(1, Icons.event_note_outlined, Icons.event_note, 'Consults',
                    badge: _pending.length),
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
      ),
    );
  }

  Widget _navItem(int index, IconData outline, IconData filled, String label,
      {int badge = 0}) {
    final active = _tab == index;
    final color =
        active ? WomenLawyerDashboardScreen.primary : const Color(0xFF94A3B8);
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
                        color: WomenLawyerDashboardScreen.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$badge',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
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
      color: WomenLawyerDashboardScreen.primary,
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
                      '${_greeting()}, $_firstName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenLawyerDashboardScreen.navy,
                      ),
                    ),
                    const Text(
                      'Manage consultations from your lawyer dashboard.',
                      style: TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
            ],
          ),
          const SizedBox(height: 14),
          _hero(),
          if (!_approved) ...[
            const SizedBox(height: 12),
            ProfileCompletionCard(
              percent: _pct,
              statusLabel: _statusLabel,
              hint: ProfileCompletionCard.hintFromMissing(
                _missing,
                guidance: _provider['nextStepGuidance']?.toString() ??
                    'Complete your profile and wait for admin approval. Clients can book you only after verification.',
              ),
              actionLabel: 'Complete profile',
              onAction: _openProfile,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              _stat('New', '${_pending.length}', const Color(0xFFFEF3C7)),
              const SizedBox(width: 10),
              _stat('Confirmed', '$_confirmed', const Color(0xFFDCFCE7)),
              const SizedBox(width: 10),
              _stat('Done', '$_completed', const Color(0xFFE0E7FF)),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Incoming consults',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
          const SizedBox(height: 10),
          if (!_approved)
            _empty('Consult requests appear here after admin approval.')
          else if (_bookings.isEmpty)
            _empty('No consultation requests yet.')
          else
            ..._bookings.take(5).map(_bookingCard),
        ],
      ),
    );
  }

  Widget _hero() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'L';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFFFE4E6),
            child: Text(initial,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('WOMEN LAWYER',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: WomenLawyerDashboardScreen.primary)),
                Text(_name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _approved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _approved ? const Color(0xFF166534) : const Color(0xFFB45309),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_areas,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, color: WomenLawyerDashboardScreen.muted)),
          ],
        ),
      ),
    );
  }

  Widget _bookingsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          const Text('Consultations',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
          const SizedBox(height: 12),
          if (!_approved)
            _empty('Available after admin verification.')
          else if (_bookings.isEmpty)
            _empty('No consultations yet.')
          else
            ..._bookings.map(_bookingCard),
        ],
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
                color: WomenLawyerDashboardScreen.primary),
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
            backgroundColor: WomenLawyerDashboardScreen.primary,
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
        _hero(),
        const SizedBox(height: 16),
        if (_email.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(_email),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        const SizedBox(height: 8),
        if (_phone.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Phone'),
            subtitle: Text(_phone),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: const Text('Location'),
          subtitle: Text(_location),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(onPressed: _openProfile, child: const Text('Edit lawyer profile')),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: WomenLawyerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: WomenLawyerDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _bookingCard(Map<String, dynamic> b) {
    final id = b['id'];
    final status = (b['status']?.toString() ?? 'PENDING').toUpperCase();
    final client = b['clientName']?.toString() ?? 'Client';
    final when = b['requestedTime']?.toString() ?? '';
    final note = b['note']?.toString() ?? '';
    final bid = id is int ? id : int.tryParse('$id');
    final busy = bid != null && _busyBookingId == bid;
    final pending = status == 'PENDING';
    final confirmed = status == 'CONFIRMED' || status == 'ACCEPTED' || status == 'PAID';
    final notes = b['coachNotes']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(client.isNotEmpty ? client[0].toUpperCase() : 'C',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.primary)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
                    Text(when.isEmpty ? note : when,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
                  ],
                ),
              ),
              Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
            ],
          ),
          if (note.isNotEmpty && when.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(note, style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
          ],
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('File: $notes', style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              if (pending) ...[
                OutlinedButton(
                  onPressed: busy || bid == null ? null : () => _updateStatus(bid, 'CONFIRMED'),
                  child: Text(busy ? 'Updating…' : 'Accept'),
                ),
                FilledButton(
                  onPressed: busy || bid == null ? null : () => _updateStatus(bid, 'CANCELLED'),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFBE123C)),
                  child: const Text('Reject'),
                ),
              ],
              if (confirmed) ...[
                FilledButton(
                  onPressed: busy || bid == null ? null : () => _updateStatus(bid, 'COMPLETED'),
                  style: FilledButton.styleFrom(backgroundColor: WomenLawyerDashboardScreen.primary),
                  child: const Text('Complete'),
                ),
                OutlinedButton(
                  onPressed: bid == null
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MarketplaceBookingChatScreen(
                              bookingId: bid,
                              asProvider: true,
                              peerName: client,
                            ),
                          ));
                        },
                  child: const Text('Chat'),
                ),
              ],
              OutlinedButton(
                onPressed: bid == null ? null : () => _editNotes(b),
                child: const Text('Notes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _empty(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: const TextStyle(color: WomenLawyerDashboardScreen.muted)),
    );
  }
}
