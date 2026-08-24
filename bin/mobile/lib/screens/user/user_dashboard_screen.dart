import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/journey_service.dart';
import '../../services/module_services.dart';
import '../../services/sos_service.dart';
import '../safety/buddy_mode_screen.dart';
import '../safety/contacts_screen.dart';
import '../safety/danger_map_screen.dart';
import '../financial/financial_literacy_screen.dart';
import '../glow/glow_space_screen.dart';
import '../safety/home_screen.dart';
import '../marketplace/job_bookings_screen.dart';
import '../safety/journey_screen.dart';
import '../landing/landing_notifications_screen.dart';
import '../landing/landing_screen.dart';
import '../martial_arts/martial_arts_screen.dart';
import 'profile_screen.dart';
import '../marketplace/provider_catalog_screen.dart';
import '../fitness/fitness_wellness_screen.dart';
import '../safety/reminders_screen.dart';
import '../creator/creator_hub_screen.dart';
import '../creator/video_feed_screen.dart';
import '../wallet/wallet_screen.dart';
import '../events/women_events_screen.dart';
import '../doctors/women_doctors_screen.dart';
import '../marketplace/women_marketplace_screen.dart';
import '../products/women_products_screen.dart';

/// Personal post-login hub — what is happening with this user's Fight D Fear account.
class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  bool _loading = true;
  String? _error;

  Map<String, dynamic>? _dashboard;
  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> _broadcasts = [];
  bool _sosActive = false;
  bool _journeyActive = false;
  int _unread = 0;
  bool _isWorker = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = context.read<AuthState>();
    if (!auth.loggedIn) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (_) => false,
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final api = auth.api;
    try {
      final results = await Future.wait([
        api.get('/api/me/dashboard'),
        DoctorService(api).myAppointments(),
        api.get('/api/me/trusted-contacts'),
        SosService(api).getActive(),
        JourneyService(api).getActive(),
      ]);
      if (!mounted) return;

      final dash = results[0];
      if (dash['success'] != true) {
        setState(() {
          _error = dash['error']?.toString() ?? 'Failed to load dashboard';
          _loading = false;
        });
        return;
      }

      _dashboard = dash;
      _isWorker = dash['isWorker'] == true;
      _unread = _asInt(dash['unreadBroadcastCount']);
      _broadcasts = _asMaps(dash['recentBroadcasts']);

      final appts = results[1];
      _appointments = appts['success'] == true ? _asMaps(appts['appointments']) : [];

      final contacts = results[2];
      _contacts = contacts['success'] == true ? _asMaps(contacts['contacts']) : [];

      final sos = results[3];
      _sosActive = sos['success'] == true && sos['active'] == true;

      final journey = results[4];
      _journeyActive = journey['success'] == true && journey['active'] == true;

      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  static int _asInt(dynamic v) {
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  static List<Map<String, dynamic>> _asMaps(dynamic raw) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static DateTime? _parseDt(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw.trim().replaceFirst(' ', 'T'));
  }

  List<Map<String, dynamic>> get _recentActivity {
    final now = DateTime.now();
    final items = _appointments.where((a) {
      final st = (a['status']?.toString() ?? '').toUpperCase();
      if (st == 'CANCELLED' || st == 'COMPLETED') return true;
      final t = _parseDt(a['appointmentTime']?.toString());
      return t != null && t.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final ta = _parseDt(a['appointmentTime']?.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
        final tb = _parseDt(b['appointmentTime']?.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
        return tb.compareTo(ta);
      });
    return items.take(3).toList();
  }

  Map<String, dynamic>? get _nextAppointment {
    final now = DateTime.now().subtract(const Duration(hours: 1));
    final upcoming = _appointments.where((a) {
      final st = (a['status']?.toString() ?? '').toUpperCase();
      if (st == 'CANCELLED' || st == 'COMPLETED') return false;
      final t = _parseDt(a['appointmentTime']?.toString());
      return t != null && !t.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final ta = _parseDt(a['appointmentTime']?.toString()) ?? DateTime.now();
        final tb = _parseDt(b['appointmentTime']?.toString()) ?? DateTime.now();
        return ta.compareTo(tb);
      });
    return upcoming.isEmpty ? null : upcoming.first;
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _contextLine(String name) {
    if (_sosActive) return 'An SOS is active. Open Safety Centre if you need to update it.';
    if (_journeyActive) return 'A safety journey is in progress.';
    if (_nextAppointment != null) return 'You have an upcoming appointment.';
    if (_unread > 0) return 'You have $_unread unread update${_unread == 1 ? '' : 's'}.';
    return 'Your safety hub is ready, $name.';
  }

  String _firstName(String full) {
    final parts = full.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'there' : parts.first;
  }

  Future<void> _signOut() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  void _push(Widget screen) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LandingNotificationsScreen(
          onOpenRoute: (route) {
            switch (route) {
              case 'sos':
                _push(const HomeScreen());
              case 'events':
                _push(const WomenEventsScreen());
              case 'community':
                _push(const CreatorHubScreen());
              case 'glow':
                _push(const GlowSpaceScreen());
              case 'martial_arts':
                _push(const MartialArtsScreen());
              case 'marketplace':
                _push(const WomenMarketplaceScreen());
              case 'doctors':
                _push(const WomenDoctorsScreen());
              case 'login':
                break;
            }
          },
        ),
      ),
    ).then((_) {
      if (mounted) _load();
    });
  }

  void _showAllModules() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final items = _allModules();
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text('All modules', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              for (final m in items)
                ListTile(
                  leading: Icon(m.icon, color: UserDashboardScreen.primary),
                  title: Text(m.title),
                  subtitle: m.subtitle == null ? null : Text(m.subtitle!),
                  onTap: () {
                    Navigator.pop(ctx);
                    m.onTap();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<_DashLink> _allModules() {
    return [
      _DashLink('Women Doctors', Icons.monitor_heart_outlined, () => _push(const WomenDoctorsScreen())),
      _DashLink('Jobs', Icons.work_outline, () => _push(_isWorker ? const JobBookingsScreen(workerView: true) : const WomenMarketplaceScreen()), subtitle: _isWorker ? 'Your job bookings' : 'Find work & services'),
      _DashLink('Women Events', Icons.event_outlined, () => _push(const WomenEventsScreen())),
      _DashLink('Glow Space', Icons.spa_outlined, () => _push(const GlowSpaceScreen())),
      _DashLink('Fitness & Wellness', Icons.fitness_center_outlined, () => _push(const FitnessWellnessScreen())),
      _DashLink('Marketplace', Icons.storefront_outlined, () => _push(const WomenMarketplaceScreen())),
      _DashLink('Self Defence', Icons.sports_martial_arts_outlined, () => _push(const MartialArtsScreen())),
      _DashLink('Women Lawyers', Icons.gavel_outlined, () => _push(const ProviderCatalogScreen(title: 'Women Lawyers', kind: CatalogKind.lawyers))),
      _DashLink('Women Products', Icons.shopping_bag_outlined, () => _push(const WomenProductsScreen())),
      _DashLink('Financial Literacy', Icons.menu_book_outlined, () => _push(const FinancialLiteracyScreen())),
      _DashLink('Creator Hub', Icons.video_camera_front_outlined, () => _push(const CreatorHubScreen())),
      _DashLink('Videos', Icons.play_circle_outline, () => _push(const VideoFeedScreen(title: 'View Videos', mode: VideoFeedMode.videos))),
      _DashLink('Reels', Icons.movie_creation_outlined, () => _push(const VideoFeedScreen(title: 'Reels', mode: VideoFeedMode.reels))),
      _DashLink('Wallet', Icons.account_balance_wallet_outlined, () => _push(const WalletScreen())),
      _DashLink('Reminders', Icons.alarm_outlined, () => _push(const RemindersScreen())),
      _DashLink('Profile', Icons.person_outline, () => _push(const ProfileScreen())),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final fullName = _dashboard?['name']?.toString() ?? auth.name ?? 'there';
    final first = _firstName(fullName);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _DashboardDrawer(
        name: fullName,
        isWorker: _isWorker,
        items: _allModules(),
        onSignOut: () {
          final scaffold = Scaffold.maybeOf(context);
          if (scaffold?.isDrawerOpen ?? false) Navigator.of(context).pop();
          _signOut();
        },
      ),
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: UserDashboardScreen.navy,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: _openNotifications,
            icon: Badge(
              isLabelVisible: _unread > 0,
              label: Text(_unread > 99 ? '99+' : '$_unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: UserDashboardScreen.primary,
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    children: [
                      Text(
                        '${_greeting()}, $first',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: UserDashboardScreen.navy,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _contextLine(first),
                        style: const TextStyle(color: UserDashboardScreen.textGray, height: 1.35),
                      ),
                      if (_isWorker) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            label: const Text('Verified Worker'),
                            backgroundColor: UserDashboardScreen.primary.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(
                              color: UserDashboardScreen.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _StatusRow(
                        unread: _unread,
                        contacts: _contacts.length,
                        pending: _asInt(_dashboard?['pendingRequestCount']),
                      ),
                      const SizedBox(height: 16),
                      _AppointmentCard(
                        appointment: _nextAppointment,
                        onView: () => _push(const WomenDoctorsScreen()),
                        onFind: () => _push(const WomenDoctorsScreen()),
                      ),
                      const SizedBox(height: 12),
                      _SafetyCard(
                        sosActive: _sosActive,
                        journeyActive: _journeyActive,
                        contactCount: _contacts.length,
                        alertCount: _unread,
                        onOpenSafety: () => _push(const HomeScreen()),
                        onContacts: () => _push(const ContactsScreen()),
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('Safety actions'),
                      const SizedBox(height: 10),
                      _SafetyActions(
                        onSos: () => _push(const HomeScreen()),
                        onContacts: () => _push(const ContactsScreen()),
                        onMap: () => _push(const DangerMapScreen()),
                        onJourney: () => _push(const JourneyScreen()),
                        onBuddy: () => _push(const BuddyModeScreen()),
                      ),
                      const SizedBox(height: 22),
                      _SectionTitle('Explore', actionLabel: 'View all', onAction: _showAllModules),
                      const SizedBox(height: 10),
                      _ExploreGrid(
                        isWorker: _isWorker,
                        onDoctors: () => _push(const WomenDoctorsScreen()),
                        onJobs: () => _push(_isWorker ? const JobBookingsScreen(workerView: true) : const WomenMarketplaceScreen()),
                        onEvents: () => _push(const WomenEventsScreen()),
                        onGlow: () => _push(const GlowSpaceScreen()),
                        onFitness: () => _push(const FitnessWellnessScreen()),
                        onMarketplace: () => _push(const WomenMarketplaceScreen()),
                      ),
                      const SizedBox(height: 22),
                      _SectionTitle('Notifications', actionLabel: 'View all', onAction: _openNotifications),
                      const SizedBox(height: 10),
                      _NotificationsPreview(
                        items: _broadcasts,
                        unread: _unread,
                        onOpen: _openNotifications,
                      ),
                      const SizedBox(height: 22),
                      _SectionTitle('Recent activity', actionLabel: 'Doctors', onAction: () => _push(const WomenDoctorsScreen())),
                      const SizedBox(height: 10),
                      _RecentActivity(
                        items: _recentActivity,
                        onOpen: () => _push(const WomenDoctorsScreen()),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _DashLink {
  const _DashLink(this.title, this.icon, this.onTap, {this.subtitle});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: UserDashboardScreen.navy,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.unread, required this.contacts, required this.pending});
  final int unread;
  final int contacts;
  final int pending;

  @override
  Widget build(BuildContext context) {
    Widget cell(String value, String label, IconData icon) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: UserDashboardScreen.primary),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: UserDashboardScreen.navy)),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: UserDashboardScreen.textGray)),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        cell('$unread', 'Unread', Icons.notifications_active_outlined),
        const SizedBox(width: 8),
        cell('$contacts', 'Contacts', Icons.contacts_outlined),
        const SizedBox(width: 8),
        cell('$pending', 'Requests', Icons.people_outline),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment, required this.onView, required this.onFind});
  final Map<String, dynamic>? appointment;
  final VoidCallback onView;
  final VoidCallback onFind;

  static String _mode(String? raw) {
    return switch ((raw ?? '').toUpperCase()) {
      'VIDEO' => 'Video consultation',
      'ONLINE' => 'Online / chat',
      'OFFLINE' => 'Home visit',
      'CLINIC' => 'In clinic',
      _ => raw == null || raw.isEmpty ? 'Consultation' : raw,
    };
  }

  static String _when(String? raw) {
    final dt = DateTime.tryParse((raw ?? '').replaceFirst(' ', 'T'));
    if (dt == null) return 'Scheduled';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final label = day == today
        ? 'Today'
        : day == today.add(const Duration(days: 1))
            ? 'Tomorrow'
            : '${dt.day}/${dt.month}/${dt.year}';
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '$label · $h:$m $ap';
  }

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    if (a == null) {
      return _EmptyCard(
        title: 'Upcoming appointment',
        message: 'No upcoming appointments',
        action: 'Find a Doctor',
        onTap: onFind,
      );
    }
    final doctor = a['doctor'] is Map ? Map<String, dynamic>.from(a['doctor'] as Map) : <String, dynamic>{};
    final name = doctor['fullName']?.toString() ?? 'Doctor';
    final spec = doctor['specialization']?.toString() ?? '';
    final status = a['status']?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming appointment', style: TextStyle(fontWeight: FontWeight.w800, color: UserDashboardScreen.navy)),
          const SizedBox(height: 10),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: UserDashboardScreen.navy)),
          if (spec.isNotEmpty) Text(spec, style: const TextStyle(color: UserDashboardScreen.textGray, fontSize: 13)),
          const SizedBox(height: 8),
          Text(_when(a['appointmentTime']?.toString()), style: const TextStyle(fontWeight: FontWeight.w600, color: UserDashboardScreen.navy)),
          Text(_mode(a['consultationType']?.toString()), style: const TextStyle(color: UserDashboardScreen.textGray, fontSize: 13)),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 8),
            Chip(
              visualDensity: VisualDensity.compact,
              label: Text(status),
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: UserDashboardScreen.primary),
              backgroundColor: UserDashboardScreen.primary.withValues(alpha: 0.08),
            ),
          ],
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onView,
              style: FilledButton.styleFrom(backgroundColor: UserDashboardScreen.primary),
              child: const Text('View appointment'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyCard extends StatelessWidget {
  const _SafetyCard({
    required this.sosActive,
    required this.journeyActive,
    required this.contactCount,
    required this.alertCount,
    required this.onOpenSafety,
    required this.onContacts,
  });

  final bool sosActive;
  final bool journeyActive;
  final int contactCount;
  final int alertCount;
  final VoidCallback onOpenSafety;
  final VoidCallback onContacts;

  @override
  Widget build(BuildContext context) {
    final status = sosActive
        ? 'SOS active'
        : journeyActive
            ? 'Journey in progress'
            : alertCount > 0
                ? 'Updates available'
                : "You're all clear";
    final detail = sosActive
        ? 'Open Safety Centre to manage your alert.'
        : journeyActive
            ? 'Check in from Journey Tracker when you arrive safely.'
            : contactCount == 0
                ? 'Add trusted contacts so SOS can reach help fast.'
                : '$contactCount trusted contact${contactCount == 1 ? '' : 's'} ready.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sosActive ? const Color(0xFFFFF1F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sosActive ? UserDashboardScreen.primary.withValues(alpha: 0.35) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sosActive ? Icons.warning_amber_rounded : Icons.shield_outlined, color: UserDashboardScreen.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Safety status', style: TextStyle(fontWeight: FontWeight.w800, color: UserDashboardScreen.navy)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(status, style: const TextStyle(fontWeight: FontWeight.w700, color: UserDashboardScreen.navy)),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(color: UserDashboardScreen.textGray, fontSize: 13, height: 1.35)),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton(
                onPressed: onOpenSafety,
                style: FilledButton.styleFrom(backgroundColor: UserDashboardScreen.primary),
                child: const Text('Safety Centre'),
              ),
              const SizedBox(width: 8),
              TextButton(onPressed: onContacts, child: const Text('Contacts')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SafetyActions extends StatelessWidget {
  const _SafetyActions({
    required this.onSos,
    required this.onContacts,
    required this.onMap,
    required this.onJourney,
    required this.onBuddy,
  });

  final VoidCallback onSos;
  final VoidCallback onContacts;
  final VoidCallback onMap;
  final VoidCallback onJourney;
  final VoidCallback onBuddy;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.sos, 'SOS', onSos, true),
      (Icons.contacts_outlined, 'Contacts', onContacts, false),
      (Icons.map_outlined, 'Map', onMap, false),
      (Icons.pin_drop_outlined, 'Journey', onJourney, false),
      (Icons.directions_walk_outlined, 'Buddy', onBuddy, false),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: items[i].$3,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: items[i].$4 ? UserDashboardScreen.primary : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: items[i].$4 ? null : Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Icon(items[i].$1, color: items[i].$4 ? Colors.white : UserDashboardScreen.primary, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      items[i].$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: items[i].$4 ? Colors.white : UserDashboardScreen.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  const _ExploreGrid({
    required this.isWorker,
    required this.onDoctors,
    required this.onJobs,
    required this.onEvents,
    required this.onGlow,
    required this.onFitness,
    required this.onMarketplace,
  });

  final bool isWorker;
  final VoidCallback onDoctors;
  final VoidCallback onJobs;
  final VoidCallback onEvents;
  final VoidCallback onGlow;
  final VoidCallback onFitness;
  final VoidCallback onMarketplace;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.monitor_heart_outlined, 'Doctors', onDoctors),
      (Icons.work_outline, isWorker ? 'My Jobs' : 'Jobs', onJobs),
      (Icons.event_outlined, 'Events', onEvents),
      (Icons.spa_outlined, 'Glow', onGlow),
      (Icons.fitness_center_outlined, 'Fitness', onFitness),
      (Icons.storefront_outlined, 'Market', onMarketplace),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.15,
      children: [
        for (final i in items)
          InkWell(
            onTap: i.$3,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(i.$1, color: UserDashboardScreen.primary),
                  const SizedBox(height: 6),
                  Text(i.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: UserDashboardScreen.navy)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NotificationsPreview extends StatelessWidget {
  const _NotificationsPreview({required this.items, required this.unread, required this.onOpen});
  final List<Map<String, dynamic>> items;
  final int unread;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyCard(
        title: null,
        message: unread == 0 ? "You're all caught up." : 'No notification details yet.',
        action: 'Open inbox',
        onTap: onOpen,
      );
    }
    return Column(
      children: [
        for (final n in items.take(3))
          InkWell(
            onTap: onOpen,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n['title']?.toString() ?? 'Update',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: UserDashboardScreen.navy),
                  ),
                  if ((n['message']?.toString() ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      n['message'].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: UserDashboardScreen.textGray, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({required this.items, required this.onOpen});
  final List<Map<String, dynamic>> items;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyCard(
        message: 'Your activity will appear here',
        action: 'Find a Doctor',
        onTap: onOpen,
      );
    }
    return Column(
      children: [
        for (final a in items)
          InkWell(
            onTap: onOpen,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available_outlined, color: UserDashboardScreen.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          () {
                            final doctor = a['doctor'] is Map ? Map<String, dynamic>.from(a['doctor'] as Map) : <String, dynamic>{};
                            final name = doctor['fullName']?.toString() ?? 'Doctor';
                            return 'Doctor booking · $name';
                          }(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, color: UserDashboardScreen.navy),
                        ),
                        Text(
                          a['status']?.toString() ?? 'Booking',
                          style: const TextStyle(fontSize: 12, color: UserDashboardScreen.textGray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({this.title, required this.message, required this.action, required this.onTap});
  final String? title;
  final String message;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: const TextStyle(fontWeight: FontWeight.w800, color: UserDashboardScreen.navy)),
            const SizedBox(height: 8),
          ],
          Text(message, style: const TextStyle(color: UserDashboardScreen.textGray)),
          const SizedBox(height: 8),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    );
  }
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({
    required this.name,
    required this.isWorker,
    required this.items,
    required this.onSignOut,
  });

  final String name;
  final bool isWorker;
  final List<_DashLink> items;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fight D Fear', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: UserDashboardScreen.navy)),
                  const SizedBox(height: 8),
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: UserDashboardScreen.navy)),
                  if (isWorker) ...[
                    const SizedBox(height: 6),
                    const Text('Verified Worker', style: TextStyle(color: UserDashboardScreen.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                children: [
                  for (final m in items)
                    ListTile(
                      leading: Icon(m.icon, color: UserDashboardScreen.primary),
                      title: Text(m.title),
                      onTap: m.onTap,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: UserDashboardScreen.textGray),
              title: const Text('Sign out'),
              onTap: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
