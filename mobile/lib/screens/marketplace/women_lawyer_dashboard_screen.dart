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
        _earnings = (res['totalEarnings'] is num)
            ? (res['totalEarnings'] as num).toDouble()
            : 0;
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out from your Lawyer portal?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: WomenLawyerDashboardScreen.primary),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    await _svc.logout();
    if (!mounted) return;
    await context.read<AuthState>().api.clearWomenLawyerToken();
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
        title: const Text('Consultation / Case Notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Client case notes, documents requested, advice & next steps…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: WomenLawyerDashboardScreen.primary),
            child: const Text('Save'),
          ),
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

  String get _name => _provider['fullName']?.toString() ?? 'Advocate';
  String get _firstName {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'Advocate' : parts.first;
  }

  String get _phone => _provider['phone']?.toString() ?? '';
  String get _email => _provider['email']?.toString() ?? '';
  String get _location => _provider['locationText']?.toString() ?? 'Location not set';
  String get _areas => _provider['practiceAreas']?.toString() ?? 'Practice areas not set';
  String get _barCouncilId => _provider['barCouncilId']?.toString() ?? 'Not registered';
  String get _experience => '${_provider['experienceYears'] ?? 0} Years Experience';
  String get _designation => _provider['designation']?.toString() ?? 'Legal Consultant';
  double get _consultationFee =>
      (_provider['consultationFee'] is num) ? (_provider['consultationFee'] as num).toDouble() : 0.0;
  String get _openDays => _provider['openDays']?.toString() ?? 'Mon - Sat';
  String get _timing => '${_provider['openTime'] ?? '09:00'} - ${_provider['closeTime'] ?? '18:00'}';
  String get _consultationMode => _provider['consultationMode']?.toString() ?? 'ONLINE_OFFLINE';
  int get _duration => (_provider['durationMinutes'] is num) ? (_provider['durationMinutes'] as num).toInt() : 45;

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

  void _showClientsDialog() {
    final Map<String, Map<String, dynamic>> uniqueClients = {};
    for (final b in _bookings) {
      final name = b['clientName']?.toString() ?? 'Anonymous Client';
      if (!uniqueClients.containsKey(name)) {
        uniqueClients[name] = {
          'name': name,
          'phone': b['clientPhone']?.toString() ?? '',
          'email': b['clientEmail']?.toString() ?? '',
          'count': 1,
          'lastBooking': b['requestedTime']?.toString() ?? '',
        };
      } else {
        uniqueClients[name]!['count'] = (uniqueClients[name]!['count'] as int) + 1;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Clients Directory',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: WomenLawyerDashboardScreen.navy)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${uniqueClients.length} registered clients have booked consultations',
                  style: const TextStyle(fontSize: 13, color: WomenLawyerDashboardScreen.muted)),
              const Divider(height: 24),
              Expanded(
                child: uniqueClients.isEmpty
                    ? const Center(child: Text('No clients yet. Bookings will show clients here.'))
                    : ListView(
                        controller: scrollCtrl,
                        children: uniqueClients.values.map((c) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFFFE4E6),
                                  child: Text(
                                    (c['name'] as String).isNotEmpty
                                        ? (c['name'] as String)[0].toUpperCase()
                                        : 'C',
                                    style: const TextStyle(
                                        color: WomenLawyerDashboardScreen.primary,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['name'] as String,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: WomenLawyerDashboardScreen.navy)),
                                      if ((c['phone'] as String).isNotEmpty)
                                        Text('📞 ${c['phone']}',
                                            style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
                                      Text('${c['count']} consultation(s)',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: WomenLawyerDashboardScreen.primary)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReviewsDialog() {
    final rating = (_provider['rating'] is num) ? (_provider['rating'] as num).toDouble() : 5.0;
    final totalReviews = _provider['totalReviews'] ?? 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Client Reviews & Ratings',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenLawyerDashboardScreen.navy)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF59E0B), size: 36),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${rating.toStringAsFixed(1)} / 5.0',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF92400E))),
                      Text('$totalReviews verified client review(s)',
                          style: const TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ratings and client testimonials appear on your public advocate profile after completed consultations.',
              style: TextStyle(fontSize: 13, color: WomenLawyerDashboardScreen.muted),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDocumentsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Legal Documents & Verification',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenLawyerDashboardScreen.navy)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: const Text('Bar Council Enrollment ID'),
              subtitle: Text(_barCouncilId),
              tileColor: const Color(0xFFF0FDF4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                _approved ? Icons.check_circle : Icons.pending,
                color: _approved ? Colors.green : Colors.amber.shade700,
              ),
              title: const Text('Verification Status'),
              subtitle: Text(_statusLabel),
              tileColor: const Color(0xFFF8FAFC),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(ctx);
                _openProfile();
              },
              child: const Text('Update Documents / Certificates'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAvailabilityDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Consultation Hours & Availability',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: WomenLawyerDashboardScreen.navy)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow('Open Days', _openDays),
            _infoRow('Consultation Hours', _timing),
            _infoRow('Consultation Mode', _consultationMode),
            _infoRow('Session Duration', '$_duration Minutes'),
            _infoRow('Consultation Fee', '₹${_consultationFee.round()}'),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pop(ctx);
                _openProfile();
              },
              child: const Text('Edit Availability & Timing'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: WomenLawyerDashboardScreen.muted, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: WomenLawyerDashboardScreen.navy, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: WomenLawyerDashboardScreen.navy,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFFFE4E6),
                  child: Text(
                    _name.isNotEmpty ? _name[0].toUpperCase() : 'A',
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: WomenLawyerDashboardScreen.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                Text(
                  _designation,
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _approved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _statusLabel.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard Overview',
                  active: _tab == 0,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tab = 0);
                  },
                ),
                _drawerItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile();
                  },
                ),
                _drawerItem(
                  icon: Icons.event_outlined,
                  title: 'Appointments',
                  badge: _pending.length,
                  active: _tab == 1,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tab = 1);
                  },
                ),
                _drawerItem(
                  icon: Icons.chat_outlined,
                  title: 'Consultations & Chat',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tab = 1);
                  },
                ),
                _drawerItem(
                  icon: Icons.people_outline,
                  title: 'My Clients',
                  onTap: () {
                    Navigator.pop(context);
                    _showClientsDialog();
                  },
                ),
                _drawerItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Earnings & Payouts',
                  active: _tab == 2,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tab = 2);
                  },
                ),
                _drawerItem(
                  icon: Icons.star_outline,
                  title: 'Reviews & Ratings',
                  onTap: () {
                    Navigator.pop(context);
                    _showReviewsDialog();
                  },
                ),
                _drawerItem(
                  icon: Icons.description_outlined,
                  title: 'Documents & Verification',
                  onTap: () {
                    Navigator.pop(context);
                    _showDocumentsDialog();
                  },
                ),
                _drawerItem(
                  icon: Icons.access_time_outlined,
                  title: 'Availability & Hours',
                  onTap: () {
                    Navigator.pop(context);
                    _showAvailabilityDialog();
                  },
                ),
                _drawerItem(
                  icon: Icons.photo_library_outlined,
                  title: 'Chamber Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile();
                  },
                ),
                _drawerItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Bank & Payments',
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _tab = 2);
                  },
                ),
                const Divider(),
                _drawerItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  color: const Color(0xFFEF4444),
                  onTap: () {
                    Navigator.pop(context);
                    _logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool active = false,
    int badge = 0,
    Color? color,
  }) {
    final itemColor = color ?? (active ? WomenLawyerDashboardScreen.primary : const Color(0xFF334155));
    return ListTile(
      leading: Icon(icon, color: itemColor, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          color: itemColor,
        ),
      ),
      trailing: badge > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: WomenLawyerDashboardScreen.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$badge',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            )
          : null,
      onTap: onTap,
    );
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
        drawer: _buildDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: WomenLawyerDashboardScreen.navy),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Text(
            _tab == 0
                ? 'Lawyer Dashboard'
                : _tab == 1
                    ? 'Consultations'
                    : _tab == 2
                        ? 'Earnings & Payout'
                        : 'Profile Settings',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: WomenLawyerDashboardScreen.navy,
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: WomenLawyerDashboardScreen.navy),
                  onPressed: () => setState(() => _tab = 1),
                ),
                if (_pending.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: WomenLawyerDashboardScreen.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_pending.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incoming consults',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
              if (_bookings.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _tab = 1),
                  child: const Text('View all'),
                ),
            ],
          ),
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
                        color: WomenLawyerDashboardScreen.primary,
                        letterSpacing: 0.6)),
                Text(_name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
                const SizedBox(height: 2),
                Text('$_experience • $_designation',
                    style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
                Text('Areas: $_areas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: WomenLawyerDashboardScreen.muted)),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600, color: WomenLawyerDashboardScreen.navy)),
          ],
        ),
      ),
    );
  }

  Widget _bookingsTab() {
    return RefreshIndicator(
      color: WomenLawyerDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text('Consultation Requests',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
          const SizedBox(height: 4),
          const Text('Accept, complete, manage notes, or chat with clients.',
              style: TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
          const SizedBox(height: 14),
          if (_bookings.isEmpty)
            _empty('No bookings found.')
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
        const Text('Earnings & Payouts',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: WomenLawyerDashboardScreen.navy)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available Payout Balance',
                  style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('₹${_payoutBalance.round()}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Revenue: ₹${_earnings.round()}',
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 13, fontWeight: FontWeight.w600)),
                  if (_upiId.isNotEmpty)
                    Text('UPI: $_upiId',
                        style: const TextStyle(color: Color(0xFF93C5FD), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _payoutBalance > 0 ? _requestPayout : null,
          style: FilledButton.styleFrom(
            backgroundColor: WomenLawyerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 16),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: pending
                      ? const Color(0xFFFEF3C7)
                      : confirmed
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: pending
                        ? const Color(0xFFD97706)
                        : confirmed
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          if (note.isNotEmpty && when.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Request Note: $note', style: const TextStyle(fontSize: 12, color: WomenLawyerDashboardScreen.muted)),
          ],
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Case Notes: $notes', style: const TextStyle(fontSize: 12, color: Color(0xFF4338CA))),
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
