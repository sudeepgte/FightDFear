import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../safety/buddy_mode_screen.dart';
import '../safety/contacts_screen.dart';
import '../safety/danger_map_screen.dart';
import '../financial/financial_literacy_screen.dart';
import '../glow/glow_space_screen.dart';
import '../safety/home_screen.dart';
import '../marketplace/job_bookings_screen.dart';
import '../safety/journey_screen.dart';
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
import '../marketplace/women_marketplace_screen.dart';
import '../products/women_products_screen.dart';

/// Post-login user dashboard — mobile safety hub modeled on web userDashboard.jsp.
class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

enum _ModuleStatus { available, comingSoon }

class _DashboardModule {
  const _DashboardModule({
    required this.title,
    required this.icon,
    required this.status,
    this.subtitle,
    this.workerOnly = false,
    this.emergency = false,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final _ModuleStatus status;
  final bool workerOnly;
  final bool emergency;
  final VoidCallback? onTap;
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

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
      final res = await context.read<AuthState>().api.get('/api/me/dashboard');
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _data = res;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res['error']?.toString() ?? 'Failed to load dashboard';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  void _comingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon on mobile')),
    );
  }

  Future<void> _signOut() async {
    await context.read<AuthState>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  List<_DashboardModule> _safetyModules() {
    void push(Widget screen) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

    return [
      _DashboardModule(
        title: 'SOS Emergency',
        icon: Icons.warning_amber_rounded,
        subtitle: 'Instant help alert',
        status: _ModuleStatus.available,
        emergency: true,
        onTap: () => push(const HomeScreen()),
      ),
      _DashboardModule(
        title: 'Trusted Contacts',
        icon: Icons.contacts_outlined,
        subtitle: 'People notified during SOS',
        status: _ModuleStatus.available,
        onTap: () => push(const ContactsScreen()),
      ),
      _DashboardModule(
        title: 'Danger Map',
        icon: Icons.map_outlined,
        subtitle: 'Reported danger points',
        status: _ModuleStatus.available,
        onTap: () => push(const DangerMapScreen()),
      ),
      _DashboardModule(
        title: 'Journey Safety Tracker',
        icon: Icons.pin_drop_outlined,
        subtitle: 'Check-in timer with contact alerts',
        status: _ModuleStatus.available,
        onTap: () => push(const JourneyScreen()),
      ),
      _DashboardModule(
        title: 'Buddy Mode',
        icon: Icons.directions_walk_outlined,
        subtitle: 'Walk with a verified buddy',
        status: _ModuleStatus.available,
        onTap: () => push(const BuddyModeScreen()),
      ),
      _DashboardModule(
        title: 'Routine Reminders',
        icon: Icons.alarm_outlined,
        subtitle: 'Daily safety check-ins',
        status: _ModuleStatus.available,
        onTap: () => push(const RemindersScreen()),
      ),
    ];
  }

  /// Mirrors web userDashboard.jsp sidebar order (excluding active Dashboard link).
  List<_DashboardModule> _sidebarModules() {
    return [
      _DashboardModule(
        title: 'Creator Hub',
        icon: Icons.video_camera_front_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const CreatorHubScreen()),
      ),
      _DashboardModule(
        title: 'Job Bookings',
        icon: Icons.work_outline,
        subtitle: 'Verified worker bookings',
        status: _ModuleStatus.available,
        workerOnly: true,
        onTap: () => _pushScreen(const JobBookingsScreen()),
      ),
      _DashboardModule(
        title: 'Your Profile',
        icon: Icons.person_outline,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProfileScreen()),
      ),
      _DashboardModule(
        title: 'Martial Arts Centres',
        icon: Icons.sports_martial_arts_outlined,
        subtitle: 'Browse centres & enroll',
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const MartialArtsScreen()),
      ),
      _DashboardModule(
        title: 'View Videos',
        icon: Icons.play_circle_outline,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const VideoFeedScreen(
          title: 'View Videos',
          mode: VideoFeedMode.videos,
        )),
      ),
      _DashboardModule(
        title: 'Glow Space',
        icon: Icons.auto_awesome_outlined,
        subtitle: 'Salons, treatments & offers',
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const GlowSpaceScreen()),
      ),
      _DashboardModule(
        title: 'Reels',
        icon: Icons.movie_creation_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const VideoFeedScreen(
          title: 'Reels',
          mode: VideoFeedMode.reels,
        )),
      ),
      _DashboardModule(
        title: 'My Wallet',
        icon: Icons.account_balance_wallet_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WalletScreen()),
      ),
      _DashboardModule(
        title: 'Women Doctors',
        icon: Icons.monitor_heart_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProviderCatalogScreen(
          title: 'Women Doctors',
          kind: CatalogKind.doctors,
        )),
      ),
      _DashboardModule(
        title: 'Women Marketplace',
        icon: Icons.storefront_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WomenMarketplaceScreen()),
      ),
      _DashboardModule(
        title: 'Financial Literacy Hub',
        icon: Icons.menu_book_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const FinancialLiteracyScreen()),
      ),
      _DashboardModule(
        title: 'Women Lawyers',
        icon: Icons.gavel_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProviderCatalogScreen(
          title: 'Women Lawyers',
          kind: CatalogKind.lawyers,
        )),
      ),
      _DashboardModule(
        title: 'Fitness & Wellness',
        icon: Icons.fitness_center_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const FitnessWellnessScreen()),
      ),
      _DashboardModule(
        title: 'Women Events',
        icon: Icons.event_outlined,
        subtitle: 'Community events & tickets',
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WomenEventsScreen()),
      ),
      _DashboardModule(
        title: 'Women Products',
        icon: Icons.shopping_bag_outlined,
        subtitle: 'Shop essentials safely',
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WomenProductsScreen()),
      ),
    ];
  }

  List<_DashboardModule> _visibleSidebarModules(bool isWorker) {
    return _sidebarModules()
        .where((m) => !m.workerOnly || isWorker)
        .map((m) {
          if (m.status == _ModuleStatus.comingSoon && m.onTap == null) {
            return _DashboardModule(
              title: m.title,
              icon: m.icon,
              subtitle: m.subtitle,
              status: m.status,
              workerOnly: m.workerOnly,
              onTap: () => _comingSoon(m.title),
            );
          }
          return m;
        })
        .toList();
  }

  void _closeDrawerIfOpen() {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  void _pushScreen(Widget screen) {
    _closeDrawerIfOpen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Full sidebar nav — matches web userDashboard.jsp order.
  List<_SidebarNavItem> _sidebarNavItems(bool isWorker) {
    return [
      _SidebarNavItem(
        title: 'Dashboard',
        icon: Icons.home_outlined,
        active: true,
        onTap: _closeDrawerIfOpen,
      ),
      _SidebarNavItem(
        title: 'Creator Hub',
        icon: Icons.video_camera_front_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const CreatorHubScreen()),
      ),
      if (isWorker)
        _SidebarNavItem(
          title: 'Job Bookings',
          icon: Icons.work_outline,
          iconColor: const Color(0xFF22C55E),
          status: _ModuleStatus.available,
          onTap: () => _pushScreen(const JobBookingsScreen()),
        ),
      _SidebarNavItem(
        title: 'SOS Emergency',
        icon: Icons.warning_amber_rounded,
        iconColor: UserDashboardScreen.primary,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const HomeScreen()),
      ),
      _SidebarNavItem(
        title: 'Trusted Contacts',
        icon: Icons.contacts_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ContactsScreen()),
      ),
      _SidebarNavItem(
        title: 'Danger Map',
        icon: Icons.map_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const DangerMapScreen()),
      ),
      _SidebarNavItem(
        title: 'Your Profile',
        icon: Icons.person_outline,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProfileScreen()),
      ),
      _SidebarNavItem(
        title: 'Martial Arts Centres',
        icon: Icons.sports_martial_arts_outlined,
        onTap: () => _pushScreen(const MartialArtsScreen()),
      ),
      _SidebarNavItem(
        title: 'View Videos',
        icon: Icons.play_circle_outline,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const VideoFeedScreen(
          title: 'View Videos',
          mode: VideoFeedMode.videos,
        )),
      ),
      _SidebarNavItem(
        title: 'Glow Space',
        icon: Icons.auto_awesome_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const GlowSpaceScreen()),
      ),
      _SidebarNavItem(
        title: 'Reels',
        icon: Icons.movie_creation_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const VideoFeedScreen(
          title: 'Reels',
          mode: VideoFeedMode.reels,
        )),
      ),
      _SidebarNavItem(
        title: 'My Wallet',
        icon: Icons.account_balance_wallet_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WalletScreen()),
      ),
      _SidebarNavItem(
        title: 'Buddy Mode',
        icon: Icons.directions_walk_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const BuddyModeScreen()),
      ),
      _SidebarNavItem(
        title: 'Women Doctors',
        icon: Icons.monitor_heart_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProviderCatalogScreen(
          title: 'Women Doctors',
          kind: CatalogKind.doctors,
        )),
      ),
      _SidebarNavItem(
        title: 'Women Marketplace',
        icon: Icons.storefront_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WomenMarketplaceScreen()),
      ),
      _SidebarNavItem(
        title: 'Financial Literacy Hub',
        icon: Icons.menu_book_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const FinancialLiteracyScreen()),
      ),
      _SidebarNavItem(
        title: 'Women Lawyers',
        icon: Icons.gavel_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const ProviderCatalogScreen(
          title: 'Women Lawyers',
          kind: CatalogKind.lawyers,
        )),
      ),
      _SidebarNavItem(
        title: 'Fitness & Wellness',
        icon: Icons.fitness_center_outlined,
        iconColor: const Color(0xFF22C55E),
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const FitnessWellnessScreen()),
      ),
      _SidebarNavItem(
        title: 'Women Events',
        icon: Icons.event_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const WomenEventsScreen()),
      ),
      _SidebarNavItem(
        title: 'Women Products',
        icon: Icons.shopping_bag_outlined,
        onTap: () => _pushScreen(const WomenProductsScreen()),
      ),
      _SidebarNavItem(
        title: 'Journey Safety Tracker',
        icon: Icons.pin_drop_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const JourneyScreen()),
      ),
      _SidebarNavItem(
        title: 'Routine Reminders',
        icon: Icons.alarm_outlined,
        status: _ModuleStatus.available,
        onTap: () => _pushScreen(const RemindersScreen()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final name = _data?['name']?.toString() ?? auth.name ?? 'User';
    final isWorker = _data?['isWorker'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: _DashboardDrawer(
        name: name,
        email: auth.email ?? '',
        isWorker: isWorker,
        items: _sidebarNavItems(isWorker),
        onSignOut: () {
          _closeDrawerIfOpen();
          _signOut();
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (ctx) => IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('My Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: UserDashboardScreen.navy,
        elevation: 0,
        actions: [
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
                  onRefresh: _load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        'Welcome back, $name',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: UserDashboardScreen.navy,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        auth.email ?? '',
                        style: const TextStyle(color: UserDashboardScreen.textGray),
                      ),
                      if (isWorker) ...[
                        const SizedBox(height: 8),
                        Chip(
                          label: const Text('Verified Worker'),
                          backgroundColor: UserDashboardScreen.primary.withValues(alpha: 0.1),
                          labelStyle: const TextStyle(
                            color: UserDashboardScreen.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Safety Alerts',
                              value: '${_data?['unreadBroadcastCount'] ?? 0}',
                              subtitle: 'unread',
                              icon: Icons.notifications_active_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Self-Defense',
                              value: '${_data?['approvedCentreCount'] ?? 0}',
                              subtitle: 'centres',
                              icon: Icons.sports_martial_arts_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Requests',
                              value: '${_data?['pendingRequestCount'] ?? 0}',
                              subtitle: 'pending',
                              icon: Icons.people_outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Recent Safety Alerts',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: UserDashboardScreen.navy,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _AlertsSection(broadcasts: _data?['recentBroadcasts']),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: 'Safety & Emergency',
                        subtitle: 'Priority — tap to open working tools',
                      ),
                      const SizedBox(height: 8),
                      _ModuleList(modules: _safetyModules()),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: 'All Modules',
                        subtitle: 'Same as web dashboard sidebar',
                      ),
                      const SizedBox(height: 8),
                      _ModuleList(modules: _visibleSidebarModules(isWorker)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }
}

class _SidebarNavItem {
  const _SidebarNavItem({
    required this.title,
    required this.icon,
    required this.onTap,
    this.active = false,
    this.status = _ModuleStatus.comingSoon,
    this.iconColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final _ModuleStatus status;
  final Color? iconColor;
}

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({
    required this.name,
    required this.email,
    required this.isWorker,
    required this.items,
    required this.onSignOut,
  });

  static const Color sidebarPurple = Color(0xFF1E1B4B);
  static const Color sidebarText = Color(0xB3FFFFFF);

  final String name;
  final String email;
  final bool isWorker;
  final List<_SidebarNavItem> items;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: sidebarPurple,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.layers_outlined, color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(text: 'Rubick '),
                            TextSpan(
                              text: 'FightDFire',
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: const TextStyle(color: sidebarText, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (isWorker) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: UserDashboardScreen.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Verified Worker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(color: Color(0x33FFFFFF), height: 1, indent: 20, endIndent: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _SidebarTile(item: items[index]);
                },
              ),
            ),
            const Divider(color: Color(0x33FFFFFF), height: 1, indent: 20, endIndent: 20),
            ListTile(
              leading: const Icon(Icons.logout, color: sidebarText, size: 22),
              title: const Text(
                'Sign out',
                style: TextStyle(color: sidebarText, fontWeight: FontWeight.w500),
              ),
              onTap: onSignOut,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({required this.item});

  final _SidebarNavItem item;

  @override
  Widget build(BuildContext context) {
    final active = item.active;
    final available = item.status == _ModuleStatus.available;
    final textColor = active ? Colors.white : _DashboardDrawer.sidebarText;
    final iconColor = item.iconColor ?? (active ? Colors.white : _DashboardDrawer.sidebarText);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Stack(
          children: [
            if (active)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: UserDashboardScreen.primary,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              child: Row(
                children: [
                  Icon(item.icon, size: 20, color: iconColor),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (available && !active)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: UserDashboardScreen.navy,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 12,
              color: UserDashboardScreen.textGray,
            ),
          ),
        ],
      ],
    );
  }
}

class _ModuleList extends StatelessWidget {
  const _ModuleList({required this.modules});

  final List<_DashboardModule> modules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: modules.map((m) => _ModuleTile(module: m)).toList(),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});

  final _DashboardModule module;

  @override
  Widget build(BuildContext context) {
    final available = module.status == _ModuleStatus.available;
    final bg = module.emergency
        ? UserDashboardScreen.primary
        : Colors.white;
    final fg = module.emergency ? Colors.white : UserDashboardScreen.navy;
    final iconColor = module.emergency ? Colors.white : UserDashboardScreen.primary;
    final subtitleColor =
        module.emergency ? Colors.white70 : UserDashboardScreen.textGray;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        elevation: module.emergency ? 0 : 0,
        child: InkWell(
          onTap: module.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: module.emergency
                  ? null
                  : Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: module.emergency
                  ? const [
                      BoxShadow(
                        color: Color(0x33F43F5E),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: module.emergency
                        ? Colors.white.withValues(alpha: 0.2)
                        : UserDashboardScreen.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(module.icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: fg,
                        ),
                      ),
                      if (module.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          module.subtitle!,
                          style: TextStyle(fontSize: 11, color: subtitleColor),
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusChip(
                  available: available,
                  onDark: module.emergency,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: module.emergency ? Colors.white70 : UserDashboardScreen.textGray,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.available, required this.onDark});

  final bool available;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final label = available ? 'Open' : 'Soon';
    final bg = available
        ? (onDark ? Colors.white.withValues(alpha: 0.25) : const Color(0xFFDCFCE7))
        : (onDark ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFF1F5F9));
    final fg = available
        ? (onDark ? Colors.white : const Color(0xFF166534))
        : (onDark ? Colors.white70 : UserDashboardScreen.textGray);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: UserDashboardScreen.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: UserDashboardScreen.navy,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: UserDashboardScreen.navy,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: UserDashboardScreen.textGray),
          ),
        ],
      ),
    );
  }
}

class _AlertsSection extends StatelessWidget {
  const _AlertsSection({this.broadcasts});

  final dynamic broadcasts;

  @override
  Widget build(BuildContext context) {
    final list = broadcasts is List ? broadcasts as List : <dynamic>[];
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'No safety alerts yet. Check back for community updates.',
          style: TextStyle(color: UserDashboardScreen.textGray),
        ),
      );
    }
    return Column(
      children: list.map((raw) {
        final b = Map<String, dynamic>.from(raw as Map);
        final type = b['type']?.toString() ?? 'INFO';
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: type == 'ALERT' || type == 'WARNING'
                  ? UserDashboardScreen.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      b['title']?.toString() ?? 'Alert',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: UserDashboardScreen.navy,
                      ),
                    ),
                  ),
                  if (type.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: UserDashboardScreen.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: UserDashboardScreen.primary,
                        ),
                      ),
                    ),
                ],
              ),
              if (b['message'] != null) ...[
                const SizedBox(height: 6),
                Text(
                  b['message'].toString(),
                  style: const TextStyle(
                    color: UserDashboardScreen.textGray,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
              if (b['sentAt'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  b['sentAt'].toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    color: UserDashboardScreen.textGray,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
