import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/fitness_trainer_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'fitness_trainer_portal_login_screen.dart';
import 'fitness_trainer_profile_completion_screen.dart';

/// Fitness trainer home — screenshot layout + martial-arts Quick Actions.
class FitnessTrainerDashboardScreen extends StatefulWidget {
  const FitnessTrainerDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FitnessTrainerDashboardScreen> createState() => _FitnessTrainerDashboardScreenState();
}

class _FitnessTrainerDashboardScreenState extends State<FitnessTrainerDashboardScreen> {
  late final FitnessTrainerAuthService _svc;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _raw = {};
  Map<String, dynamic> _trainer = {};
  List<Map<String, dynamic>> _bookings = [];
  String _bookingTab = 'UPCOMING';
  String _overviewPeriod = 'This Month';
  int _navIndex = 0;
  bool _online = true;
  List<Map<String, dynamic>> _clients = [];

  @override
  void initState() {
    super.initState();
    _svc = FitnessTrainerAuthService(context.read<AuthState>().api);
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _raw = res;
        final t = res['trainer'];
        _trainer = t is Map ? Map<String, dynamic>.from(t) : <String, dynamic>{};
        _bookings = ModuleTheme.toList(res['bookings']);
        _clients = ModuleTheme.toList(res['clients']);
        _online = res['onlineAvailable'] != false;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openProfileCompletion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FitnessTrainerProfileCompletionScreen(
          onFinished: (ctx) => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (mounted) _reload();
  }

  Future<void> _logout() async {
    await _svc.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const FitnessTrainerPortalLoginScreen()),
      (_) => false,
    );
  }

  num _num(dynamic v) {
    if (v is num) return v;
    return num.tryParse('$v') ?? 0;
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'REGISTERED':
        return 'Registered';
      case 'PROFILE_INCOMPLETE':
        return 'Profile Incomplete';
      case 'READY_FOR_VERIFICATION':
        return 'Ready to Submit';
      case 'PENDING_ADMIN_APPROVAL':
        return 'Pending Approval';
      case 'CHANGES_REQUESTED':
        return 'Changes Requested';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'SUSPENDED':
        return 'Suspended';
      case 'VERIFIED':
        return 'Verified';
      default:
        return status == null || status.isEmpty ? 'Profile Incomplete' : status;
    }
  }

  bool get _verified {
    final status = (_raw['partnerProfileStatus'] ?? _trainer['partnerProfileStatus'] ?? '').toString();
    return status == 'APPROVED' || _trainer['verificationStatus']?.toString() == 'VERIFIED';
  }

  String get _firstName {
    final name = _trainer['fullName']?.toString() ?? 'Trainer';
    return name.split(RegExp(r'\s+')).first;
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((b) {
      final s = (b['status']?.toString() ?? '').toUpperCase();
      return switch (_bookingTab) {
        'PENDING' => s == 'PENDING',
        'COMPLETED' => s == 'COMPLETED',
        'CANCELLED' => s == 'CANCELLED' || s == 'REJECTED',
        _ => s == 'APPROVED' || s == 'PENDING',
      };
    }).toList();
  }

  List<Map<String, dynamic>> get _todayBookings {
    final today = DateTime.now();
    final key =
        '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return _bookings.where((b) {
      final date = b['bookingDate']?.toString() ?? '';
      final status = (b['status']?.toString() ?? '').toUpperCase();
      return date.startsWith(key) && (status == 'APPROVED' || status == 'PENDING');
    }).toList();
  }

  Future<void> _toggleOnline() async {
    final next = !_online;
    setState(() => _online = next);
    final res = await _svc.updateOnlineStatus(next);
    if (!mounted) return;
    if (res['success'] != true) {
      setState(() => _online = !next);
      _snack(res['error']?.toString() ?? 'Could not update online status');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _requestPayout() async {
    try {
      final res = await _svc.requestPayout();
      if (!mounted) return;
      _snack(res['success'] == true
          ? (res['message']?.toString() ?? 'Payout requested')
          : (res['error']?.toString() ?? 'Payout failed'));
      if (res['success'] == true) _reload();
    } catch (e) {
      if (mounted) _snack('$e');
    }
  }

  void _showNotifications() {
    final pending = _num(_raw['pendingCount']).toInt();
    final items = <String>[
      if (pending > 0) '$pending booking request${pending == 1 ? '' : 's'} waiting for review',
      if (_raw['needsProfileCompletion'] == true) 'Complete your trainer profile to get verified',
      if ((_raw['partnerProfileStatus'] ?? '').toString() == 'PENDING_ADMIN_APPROVAL')
        'Your verification is pending admin approval',
      if ((_raw['changesRequestedNote']?.toString() ?? '').isNotEmpty)
        'Admin notes: ${_raw['changesRequestedNote']}',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No new notifications', style: TextStyle(color: FitnessTrainerDashboardScreen.muted))),
                )
              else
                ...items.map(
                  (n) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFFFE4E6),
                      child: Icon(Icons.notifications_outlined, color: FitnessTrainerDashboardScreen.primary),
                    ),
                    title: Text(n, style: const TextStyle(fontSize: 14)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: FitnessTrainerDashboardScreen.navy,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _snack('Menu coming soon'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Trainer Dashboard', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text(
              '${_greeting()}, $_firstName',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
          ],
        ),
        toolbarHeight: 64,
        actions: [
          IconButton(
            onPressed: _showNotifications,
            icon: Badge(
              isLabelVisible: _num(_raw['pendingCount']).toInt() > 0 || _raw['needsProfileCompletion'] == true,
              label: Text('${(_num(_raw['pendingCount']).toInt() + (_raw['needsProfileCompletion'] == true ? 1 : 0)).clamp(1, 9)}'),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _reload)
              : IndexedStack(
                  index: _navIndex,
                  children: [
                    _homeTab(),
                    _bookingsTab(),
                    _availabilityTab(),
                    _earningsTab(),
                    _profileTab(),
                  ],
                ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Availability'),
          NavigationDestination(icon: Icon(Icons.payments_outlined), selectedIcon: Icon(Icons.payments), label: 'Earnings'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _homeTab() {
    final name = _trainer['fullName']?.toString() ?? 'Trainer';
    final email = _trainer['email']?.toString() ?? '';
    final status = (_raw['partnerProfileStatus'] ?? _trainer['partnerProfileStatus'] ?? '').toString();
    final statusLabel =
        (_raw['partnerProfileStatusLabel'] ?? _trainer['partnerProfileStatusLabel'] ?? _statusLabel(status))
            .toString();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'T';

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          _profileCompletionBanner(),
          const SizedBox(height: 12),
          // Profile hero (matches reference screenshot)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFFFFE4E6),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: FitnessTrainerDashboardScreen.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18, color: FitnessTrainerDashboardScreen.navy)),
                      const SizedBox(height: 2),
                      Text(email, style: const TextStyle(color: FitnessTrainerDashboardScreen.muted, fontSize: 13)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _statusChip(
                            _verified ? Icons.verified : Icons.hourglass_top,
                            _verified ? 'Verified Trainer' : statusLabel,
                            _verified ? FitnessTrainerDashboardScreen.primary : const Color(0xFFD97706),
                            _verified ? const Color(0xFFFFE4E6) : const Color(0xFFFEF3C7),
                          ),
                          GestureDetector(
                            onTap: _toggleOnline,
                            child: _statusChip(
                              Icons.circle,
                              _online ? 'Online' : 'Offline',
                              _online ? const Color(0xFF166534) : FitnessTrainerDashboardScreen.muted,
                              _online ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              dot: true,
                              dotColor: _online ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _financeRow(),
          const SizedBox(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text('Overview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              PopupMenuButton<String>(
                initialValue: _overviewPeriod,
                onSelected: (v) => setState(() => _overviewPeriod = v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'This Week', child: Text('This Week')),
                  PopupMenuItem(value: 'This Month', child: Text('This Month')),
                  PopupMenuItem(value: 'All Time', child: Text('All Time')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_overviewPeriod,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FitnessTrainerDashboardScreen.navy)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: FitnessTrainerDashboardScreen.muted),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _overviewTile(Icons.event_note_outlined, '${_num(_raw['bookingCount']).toInt()}', 'Total Bookings',
                    const Color(0xFFFFE4E6), FitnessTrainerDashboardScreen.primary),
                _overviewTile(Icons.check_circle_outline, '${_num(_raw['completedCount']).toInt()}', 'Completed',
                    const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                _overviewTile(Icons.schedule, '${_num(_raw['upcomingCount'] ?? _raw['approvedCount']).toInt()}', 'Upcoming',
                    const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
                _overviewTile(Icons.star_outline, _num(_trainer['rating']).toStringAsFixed(1), 'Avg. Rating',
                    const Color(0xFFFEF3C7), const Color(0xFFD97706)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Quick Actions (martial-arts style)
          Row(
            children: [
              const Expanded(
                child: Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              TextButton.icon(
                onPressed: () => _snack('Customize quick actions coming soon'),
                icon: const Icon(Icons.settings_outlined, size: 16),
                label: const Text('Customize'),
                style: TextButton.styleFrom(foregroundColor: FitnessTrainerDashboardScreen.muted),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CircleAction('Complete Profile', Icons.assignment_outlined, FitnessTrainerDashboardScreen.primary,
                    _openProfileCompletion),
                _CircleAction('Packages', Icons.tag, const Color(0xFFE11D48),
                    _openPackagesSheet),
                _CircleAction('Attendance', Icons.fact_check_outlined, const Color(0xFF16A34A),
                    _openAttendanceRosterSheet),
                _CircleAction('Availability', Icons.calendar_month, const Color(0xFF2563EB),
                    () => setState(() => _navIndex = 2)),
                _CircleAction('Bookings', Icons.event_note, const Color(0xFF16A34A),
                    () => setState(() => _navIndex = 1)),
                _CircleAction('Earnings', Icons.payments_outlined, const Color(0xFFEA580C),
                    () => setState(() => _navIndex = 3)),
                _CircleAction('Reviews', Icons.star_outline, const Color(0xFFD97706),
                    () => _snack('Reviews from clients will appear here')),
                _CircleAction('Announce', Icons.campaign_outlined, const Color(0xFF0F766E),
                    () => _snack('Announcements coming soon')),

              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: "Today's Sessions",
            trailing: TextButton(
              onPressed: () => setState(() => _navIndex = 1),
              child: const Text('View all'),
            ),
            child: _todayBookings.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No sessions scheduled for today',
                        style: TextStyle(color: FitnessTrainerDashboardScreen.muted)),
                  )
                : Column(
                    children: _todayBookings.take(3).map((b) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE4E6),
                          child: Icon(Icons.fitness_center, color: FitnessTrainerDashboardScreen.primary, size: 18),
                        ),
                        title: Text(
                          b['clientName']?.toString() ?? b['className']?.toString() ?? 'Session',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        subtitle: Text(
                          [b['bookingTime'], b['sessionType'], b['status']].where((e) => e != null && '$e'.isNotEmpty).join(' · '),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Bookings',
            trailing: TextButton(
              onPressed: () => setState(() => _navIndex = 1),
              child: const Text('View All'),
            ),
            child: Column(
              children: [
                _bookingChips(),
                const SizedBox(height: 12),
                _bookingsList(limit: 4),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => setState(() => _navIndex = 2),
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Manage Availability'),
                    style: FilledButton.styleFrom(backgroundColor: FitnessTrainerDashboardScreen.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Clients',
            trailing: Text('${_clients.length} total'),
            child: _clients.isEmpty
                ? const Text('Clients appear here once you receive bookings.',
                    style: TextStyle(color: FitnessTrainerDashboardScreen.muted, fontSize: 13))
                : Column(
                    children: _clients.take(5).map((c) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFE4E6),
                          child: Text(
                            (c['fullName']?.toString().isNotEmpty == true)
                                ? c['fullName'].toString()[0].toUpperCase()
                                : 'C',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: FitnessTrainerDashboardScreen.primary,
                            ),
                          ),
                        ),
                        title: Text(c['fullName']?.toString() ?? 'Client',
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(
                          [
                            if (c['phone'] != null) c['phone'],
                            if (c['bookingCount'] != null) '${c['bookingCount']} booking(s)',
                          ].join(' · '),
                        ),
                        trailing: Text(c['lastStatus']?.toString() ?? '',
                            style: const TextStyle(fontSize: 11, color: FitnessTrainerDashboardScreen.muted)),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 12),
          _sectionCard(
            title: 'Recent Activity',
            child: _recentActivity(),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    final recent = [..._bookings]
      ..sort((a, b) => '${b['bookingDate']}'.compareTo('${a['bookingDate']}'));
    if (recent.isEmpty) {
      return const Text('No recent activity yet. New bookings and updates will show here.',
          style: TextStyle(color: FitnessTrainerDashboardScreen.muted, fontSize: 13));
    }
    return Column(
      children: recent.take(5).map((b) {
        final status = (b['status']?.toString() ?? 'UPDATE').toUpperCase();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                  color: FitnessTrainerDashboardScreen.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$status · ${b['clientName'] ?? b['className'] ?? 'Booking'}'
                  '${b['bookingDate'] != null ? ' · ${b['bookingDate']}' : ''}',
                  style: const TextStyle(fontSize: 13, color: FitnessTrainerDashboardScreen.navy),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _overviewTile(IconData icon, String value, String label, Color bg, Color fg) {
    return Container(
      width: 132,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: fg),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          Text(label, style: const TextStyle(fontSize: 11, color: FitnessTrainerDashboardScreen.muted)),
        ],
      ),
    );
  }

  Widget _statusChip(
    IconData icon,
    String text,
    Color fg,
    Color bg, {
    bool dot = false,
    Color? dotColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(color: dotColor ?? fg, shape: BoxShape.circle),
            )
          else ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 5),
          ],
          Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _bookingsTab() {
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text('All Bookings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 12),
          _bookingChips(),
          const SizedBox(height: 12),
          _bookingsList(),
        ],
      ),
    );
  }

  Widget _availabilityTab() {
    final timings = (_trainer['availableTimings']?.toString() ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const Text('Availability', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          'Set the slots clients can book. Required before submitting for verification.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _sectionCard(
          title: 'Current slots',
          trailing: TextButton(onPressed: _openProfileCompletion, child: const Text('Edit')),
          child: timings.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No availability set yet.', style: TextStyle(color: FitnessTrainerDashboardScreen.muted)),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: timings
                      .map((t) => Chip(
                            label: Text(t),
                            backgroundColor: const Color(0xFFFFE4E6),
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _openProfileCompletion,
            icon: const Icon(Icons.edit_calendar_outlined),
            label: const Text('Update availability'),
            style: FilledButton.styleFrom(backgroundColor: FitnessTrainerDashboardScreen.primary),
          ),
        ),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'Service details',
          child: Column(
            children: [
              _detailRow('Service type', _trainer['serviceType']?.toString()),
              _detailRow(
                'Session fees',
                _trainer['sessionFees'] == null ? null : '₹${_trainer['sessionFees']}',
                required: true,
              ),
              _detailRow('City', _trainer['city']?.toString(), required: true),
              _detailRow('Specializations', _trainer['specializations']?.toString(), required: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _earningsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        const Text('Earnings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 12),
        _financeRow(),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.45,
          children: [
            _metricCard(Icons.payments_outlined, '₹${_num(_raw['totalEarnings'])}', 'Total Earnings',
                const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
            _metricCard(Icons.hourglass_bottom, '${_num(_raw['pendingCount']).toInt()}', 'Pending payouts',
                const Color(0xFFFFEDD5), const Color(0xFFEA580C)),
            _metricCard(Icons.check_circle_outline, '${_num(_raw['completedCount']).toInt()}', 'Paid sessions',
                const Color(0xFFDBEAFE), const Color(0xFF2563EB)),
            _metricCard(Icons.account_balance_wallet_outlined, '₹${_num(_raw['totalEarnings'])}', 'Wallet',
                const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Wallet ₹${_num(_raw['payoutBalance'] ?? _trainer['payoutBalance'])} · UPI ${_trainer['upiId'] ?? _raw['upiId'] ?? 'not set'}',
          style: const TextStyle(color: FitnessTrainerDashboardScreen.muted, fontSize: 13),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: _requestPayout,
          child: const Text('Request payout (min ₹100)'),
        ),
      ],
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('My Profile', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ),
            TextButton(onPressed: _openProfileCompletion, child: const Text('Edit')),
          ],
        ),
        const SizedBox(height: 8),
        _profileCompletionBanner(),
        const SizedBox(height: 12),
        _sectionCard(
          title: 'Required details',
          child: Column(
            children: [
              _detailRow('Full name', _trainer['fullName']?.toString(), required: true),
              _detailRow('Phone', _trainer['phone']?.toString()),
              _detailRow('Email', _trainer['email']?.toString()),
              _detailRow('Specializations', _trainer['specializations']?.toString(), required: true),
              _detailRow('City', _trainer['city']?.toString(), required: true),
              _detailRow(
                'Experience',
                _trainer['experience'] == null ? null : '${_trainer['experience']} years',
                required: true,
              ),
              _detailRow(
                'Session fees',
                _trainer['sessionFees'] == null ? null : '₹${_trainer['sessionFees']}',
                required: true,
              ),
              _detailRow('Service type', _trainer['serviceType']?.toString()),
              _detailRow('Availability', _trainer['availableTimings']?.toString(), required: true),
              _detailRow('Bio', _trainer['bio']?.toString()),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openProfileCompletion,
                  icon: const Icon(Icons.assignment_outlined),
                  label: Text(
                    (_raw['canSubmitForVerification'] == true)
                        ? 'Review & Submit for Verification'
                        : 'Complete required profile details',
                  ),
                  style: FilledButton.styleFrom(backgroundColor: FitnessTrainerDashboardScreen.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }

  Widget _financeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('₹${_num(_raw['totalEarnings'])}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const Text('Total Earnings',
                    style: TextStyle(fontSize: 11, color: FitnessTrainerDashboardScreen.muted)),
              ],
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFFE2E8F0)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_num(_raw['pendingCount']).toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  const Text('Pending Payouts',
                      style: TextStyle(fontSize: 11, color: FitnessTrainerDashboardScreen.muted)),
                ],
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => setState(() => _navIndex = 3),
            icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
            label: const Text('Wallet'),
            style: FilledButton.styleFrom(
              backgroundColor: FitnessTrainerDashboardScreen.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBanner({
    required String title,
    required String message,
    required Color color,
    required Color fg,
    String? action,
    VoidCallback? onAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: fg)),
          const SizedBox(height: 4),
          Text(message, style: TextStyle(color: fg, fontSize: 13)),
          if (action != null && onAction != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onAction, child: Text(action)),
          ],
        ],
      ),
    );
  }

  Widget _profileCompletionBanner() {
    final status = (_raw['partnerProfileStatus'] ?? _trainer['partnerProfileStatus'] ?? 'PROFILE_INCOMPLETE')
        .toString();
    final statusLabel =
        (_raw['partnerProfileStatusLabel'] ?? _trainer['partnerProfileStatusLabel'] ?? _statusLabel(status))
            .toString();
    final pct = _num(_raw['profileCompletionPct'] ?? _trainer['profileCompletionPct']).clamp(0, 100).toDouble();
    final missing = ModuleTheme.toList(_raw['missingItems']);
    final missingText = missing.take(3).map((e) => e.toString()).join(', ');
    final canSubmit = _raw['canSubmitForVerification'] == true;
    final guidance = _raw['nextStepGuidance']?.toString();
    if (status == 'APPROVED' && pct >= 100) {
      return const SizedBox.shrink();
    }
    if (status == 'PENDING_ADMIN_APPROVAL') {
      return _statusBanner(
        title: 'Pending admin approval',
        message: guidance ?? 'Your profile is under review. Members will see you after approval.',
        color: const Color(0xFFDBEAFE),
        fg: const Color(0xFF1D4ED8),
      );
    }
    if (status == 'CHANGES_REQUESTED') {
      final note = _raw['changesRequestedNote']?.toString();
      return _statusBanner(
        title: 'Changes requested',
        message: note?.isNotEmpty == true ? note! : (guidance ?? 'Update your profile and resubmit.'),
        color: const Color(0xFFFFEDD5),
        fg: const Color(0xFFEA580C),
        action: 'Edit profile',
        onAction: _openProfileCompletion,
      );
    }
    if (status == 'REJECTED') {
      final reason = _raw['rejectionReason']?.toString();
      return _statusBanner(
        title: 'Verification rejected',
        message: reason?.isNotEmpty == true ? reason! : 'Update your profile and submit again.',
        color: const Color(0xFFFEE2E2),
        fg: const Color(0xFFDC2626),
        action: 'Edit profile',
        onAction: _openProfileCompletion,
      );
    }
    return ProfileCompletionCard(
      percent: pct,
      statusLabel: statusLabel,
      hint: ProfileCompletionCard.hintFromMissing(
        missing.map((e) => e.toString()).toList(),
        guidance: guidance,
      ),
      actionLabel: canSubmit ? 'Review & Submit' : 'Complete Profile',
      onAction: _openProfileCompletion,
      trailing: missingText.isNotEmpty
          ? Text(
              'Missing: $missingText${missing.length > 3 ? '...' : ''}',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
            )
          : null,
    );
  }

  Widget _bookingChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in const ['UPCOMING', 'PENDING', 'COMPLETED', 'CANCELLED'])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(tab[0] + tab.substring(1).toLowerCase()),
                selected: _bookingTab == tab,
                onSelected: (_) => setState(() => _bookingTab = tab),
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  color: _bookingTab == tab
                      ? FitnessTrainerDashboardScreen.primary
                      : FitnessTrainerDashboardScreen.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bookingsList({int? limit}) {
    final list = limit == null ? _filteredBookings : _filteredBookings.take(limit).toList();
    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.fitness_center, size: 40, color: Color(0xFFCBD5E1)),
            SizedBox(height: 8),
            Text('No Bookings Yet', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text(
              "You don't have any bookings in this tab. New bookings will appear here.",
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return Column(
      children: list.map((b) {
        final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              b['clientName']?.toString() ?? b['className']?.toString() ?? 'Booking #${b['id'] ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              [
                if (b['status'] != null) '${b['status']}',
                if (b['bookingDate'] != null) '${b['bookingDate']}',
                if (b['bookingTime'] != null) '${b['bookingTime']}',
                if (b['sessionType'] != null) '${b['sessionType']}',
              ].join(' · '),
            ),
            trailing: id == null
                ? null
                : PopupMenuButton<String>(
                    onSelected: (status) async {
                      await _svc.updateBookingStatus(id, status);
                      await _reload();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'APPROVED', child: Text('Approve')),
                      PopupMenuItem(value: 'REJECTED', child: Text('Reject')),
                      PopupMenuItem(value: 'COMPLETED', child: Text('Complete')),
                      PopupMenuItem(value: 'CANCELLED', child: Text('Cancel')),
                    ],
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _metricCard(IconData icon, String value, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: fg),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          Text(label, style: const TextStyle(fontSize: 11, color: FitnessTrainerDashboardScreen.muted)),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value, {bool required = false}) {
    final filled = value != null && value.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            filled ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: filled ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(required ? '$label *' : label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  filled ? value.trim() : 'Not set — tap Complete Profile',
                  style: TextStyle(
                    color: filled ? FitnessTrainerDashboardScreen.navy : const Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openPackagesSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollCtrl) {
            return FutureBuilder<Map<String, dynamic>>(
              future: _svc.getPackages(),
              builder: (c, snap) {
                final list = snap.hasData && snap.data!['packages'] is List
                    ? (snap.data!['packages'] as List).cast<Map<String, dynamic>>()
                    : <Map<String, dynamic>>[];
                return ListView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Packages & Passes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        FilledButton.icon(
                          onPressed: () => _createPackageDialog(ctx),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('New Pass'),
                          style: FilledButton.styleFrom(
                            backgroundColor: FitnessTrainerDashboardScreen.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (snap.connectionState == ConnectionState.waiting)
                      const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                    else if (list.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No custom packages created yet. Tap "New Pass" to create one.')),
                      )
                    else
                      ...list.map((pkg) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            title: Text(pkg['packageName']?.toString() ?? 'Pass', style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text('${pkg['sessionCount'] == 0 ? "Unlimited" : "${pkg['sessionCount']} Sessions"} · ${pkg['durationDays']} Days · ₹${pkg['price']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () async {
                                final id = int.tryParse('${pkg['id']}');
                                if (id != null) {
                                  await _svc.deletePackage(id);
                                  Navigator.pop(ctx);
                                  _openPackagesSheet();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _createPackageDialog(BuildContext sheetCtx) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '1999');
    final sessionsCtrl = TextEditingController(text: '10');
    final daysCtrl = TextEditingController(text: '30');
    showDialog(
      context: context,
      builder: (dCtx) {
        return AlertDialog(
          title: const Text('Create Membership Pass'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Pass Name *', hintText: 'e.g. 10-Class Yoga Pass')),
                TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (₹) *')),
                TextField(controller: sessionsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sessions (0 = Unlimited)')),
                TextField(controller: daysCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Validity (Days)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                await _svc.savePackage({
                  'packageName': nameCtrl.text.trim(),
                  'price': double.tryParse(priceCtrl.text) ?? 999.0,
                  'sessionCount': int.tryParse(sessionsCtrl.text) ?? 10,
                  'durationDays': int.tryParse(daysCtrl.text) ?? 30,
                  'category': _trainer['specializations']?.toString().split(',').first.trim() ?? 'FITNESS',
                  'sessionType': 'OFFLINE',
                });
                Navigator.pop(dCtx);
                Navigator.pop(sheetCtx);
                _openPackagesSheet();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _openAttendanceRosterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollCtrl) {
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Client Attendance Check-In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                if (_bookings.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No active client bookings found to mark attendance.')),
                  )
                else
                  ..._bookings.map((b) {
                    final id = int.tryParse('${b['id']}');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        title: Text(b['clientName']?.toString() ?? 'Client', style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${b['bookingDate']} @ ${b['bookingTime']} · ${b['status']}'),
                        trailing: FilledButton.tonal(
                          onPressed: () => _markAttendanceDialog(id, b['clientName']?.toString() ?? 'Client'),
                          child: const Text('Check In'),
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        );
      },
    );
  }

  void _markAttendanceDialog(int? bookingId, String clientName) {
    if (bookingId == null) return;
    String status = 'PRESENT';
    final notesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (context, setDState) {
            return AlertDialog(
              title: Text('Check In: $clientName'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'PRESENT', child: Text('Present (Deduct session)')),
                      DropdownMenuItem(value: 'LATE', child: Text('Late (Deduct session)')),
                      DropdownMenuItem(value: 'ABSENT', child: Text('Absent (No deduction)')),
                    ],
                    onChanged: (v) => setDState(() => status = v ?? 'PRESENT'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: 'Coach Workout Notes (optional)'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () async {
                    await _svc.markAttendance(
                      bookingId: bookingId,
                      status: status,
                      notes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
                    );
                    Navigator.pop(dCtx);
                    _snack('Attendance marked for $clientName');
                    _reload();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _sectionCard({required String title, required Widget child, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
              ?trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}


class _CircleAction extends StatelessWidget {
  const _CircleAction(this.label, this.icon, this.color, this.onTap);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 76,
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
