import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/landing_service.dart';
import 'contacts_screen.dart';
import 'creator_hub_screen.dart';
import 'danger_map_screen.dart';
import 'doctor_portal_login_screen.dart';
import 'entrepreneur_portal_login_screen.dart';
import 'event_host_portal_login_screen.dart';
import 'financial_literacy_screen.dart';
import 'fitness_trainer_portal_login_screen.dart';
import 'glow_provider_login_screen.dart';
import 'glow_provider_signup_screen.dart';
import 'glow_space_screen.dart';
import 'home_screen.dart';
import 'investor_portal_login_screen.dart';
import 'job_bookings_screen.dart';
import 'landing_notifications_screen.dart';
import 'login_screen.dart';
import 'marketplace_provider_login_screen.dart';
import 'martial_arts_admin_screen.dart';
import 'martial_arts_centre_login_screen.dart';
import 'martial_arts_centre_register_screen.dart';
import 'martial_arts_screen.dart';
import 'provider_catalog_screen.dart';
import 'register_screen.dart';
import 'user_dashboard_screen.dart';
import 'women_events_screen.dart';
import 'women_jobs_apply_screen.dart';
import 'women_marketplace_screen.dart';
import 'women_products_screen.dart';
import 'women_products_seller_login_screen.dart';

/// Fight D Fear landing — mockup layout with all current portals & modules.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);
  static const Color softBg = Color(0xFFFFFBFC);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  int _navIndex = 0;

  final _quickKey = GlobalKey();
  final _communityKey = GlobalKey();
  final _offersKey = GlobalKey();

  late final LandingService _landingApi;
  bool _feedLoading = true;
  int _unreadNotifications = 0;
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _whatsNew = [];
  List<Map<String, dynamic>> _nearby = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _community = [];

  @override
  void initState() {
    super.initState();
    _landingApi = LandingService(context.read<AuthState>().api);
    _loadLandingData();
  }

  List<Map<String, dynamic>> _asMapList(dynamic raw) {
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _loadLandingData({bool showSpinner = true}) async {
    if (showSpinner && mounted) setState(() => _feedLoading = true);
    try {
      final results = await Future.wait([
        _landingApi.feed(),
        _landingApi.notifications(),
      ]);
      if (!mounted) return;
      final feed = results[0];
      final notif = results[1];
      if (feed['success'] == true) {
        _stats = feed['stats'] is Map ? Map<String, dynamic>.from(feed['stats'] as Map) : {};
        _whatsNew = _asMapList(feed['whatsNew']);
        _nearby = _asMapList(feed['nearby']);
        _offers = _asMapList(feed['offers']);
        _community = _asMapList(feed['community']);
      }
      if (notif['success'] == true) {
        _unreadNotifications = (notif['unreadCount'] is num)
            ? (notif['unreadCount'] as num).toInt()
            : int.tryParse('${notif['unreadCount']}') ?? 0;
      }
    } catch (_) {
      // Keep empty/fallback UI if backend is offline.
    }
    if (mounted) setState(() => _feedLoading = false);
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LandingNotificationsScreen(
          onOpenRoute: (route) {
            if (route == null) return;
            switch (route) {
              case 'sos':
                _openSos();
              case 'events':
                _openWomenEvents();
              case 'community':
                _requireLoginThen(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreatorHubScreen()),
                  );
                });
              case 'glow':
                _openGlowSpace();
              case 'martial_arts':
                _openMartialArts();
              case 'marketplace':
                _openWomenMarketplace();
              case 'doctors':
                _openDoctors();
              case 'login':
                _showLoginSheet();
            }
          },
        ),
      ),
    );
    if (!mounted) return;
    await _loadLandingData(showSpinner: false);
    // Guests can't persist read-state — clear badge after opening the inbox.
    if (mounted && !context.read<AuthState>().loggedIn) {
      setState(() => _unreadNotifications = 0);
    }
  }

  void _openFeedRoute(String? route) {
    switch (route) {
      case 'events':
        _openWomenEvents();
      case 'glow':
        _openGlowSpace();
      case 'martial_arts':
        _openMartialArts();
      case 'marketplace':
        _openWomenMarketplace();
      case 'doctors':
        _openDoctors();
      case 'products':
        _requireLoginThen(() {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WomenProductsScreen()),
          );
        });
      case 'community':
        _requireLoginThen(() {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreatorHubScreen()),
          );
        });
      default:
        _scrollTo(_quickKey);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  // —— auth / join handlers (unchanged behavior) ——

  static void _handleJoinUsSelection(BuildContext context, String value) {
    switch (value) {
      case 'member':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
        return;
      case 'doctor':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DoctorPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'martial_arts':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsCentreRegisterScreen()),
        );
        return;
      case 'salon':
      case 'glow':
      case 'stylist':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GlowProviderSignupScreen()),
        );
        return;
      case 'service_partner':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MarketplaceProviderLoginScreen(startRegister: true)),
        );
        return;
      case 'marketplace_seller':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen(startRegister: true)),
        );
        return;
      case 'women_jobs':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenJobsApplyScreen()),
        );
        return;
      case 'entrepreneur':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EntrepreneurPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'investor':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const InvestorPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'event_host':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EventHostPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'fitness_trainer':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FitnessTrainerPortalLoginScreen(startRegister: true)),
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_joinUsLabel(value)} — coming soon on mobile')),
        );
    }
  }

  static String _joinUsLabel(String value) {
    return switch (value) {
      'member' => 'Join as Member',
      'doctor' => 'Women Doctor',
      'martial_arts' => 'Self-Defense Trainer',
      'salon' || 'glow' => 'Glow Space',
      'stylist' => 'Glow Space',
      'service_partner' => 'Service Partner',
      'marketplace_seller' => 'Product Seller',
      'women_jobs' => 'Women Jobs',
      'entrepreneur' => 'Entrepreneur',
      'investor' => 'Investor',
      'event_host' => 'Event Host',
      'fitness_trainer' => 'Fitness Trainer',
      _ => 'Registration',
    };
  }

  static void _handleLoginSelection(BuildContext context, String value) {
    switch (value) {
      case 'user':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        return;
      case 'doctor':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DoctorPortalLoginScreen()),
        );
        return;
      case 'martial_arts':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
        );
        return;
      case 'salon':
      case 'glow':
      case 'stylist':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GlowProviderLoginScreen()),
        );
        return;
      case 'service_partner':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MarketplaceProviderLoginScreen()),
        );
        return;
      case 'marketplace_seller':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen()),
        );
        return;
      case 'entrepreneur':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EntrepreneurPortalLoginScreen()),
        );
        return;
      case 'investor':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const InvestorPortalLoginScreen()),
        );
        return;
      case 'event_host':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EventHostPortalLoginScreen()),
        );
        return;
      case 'fitness_trainer':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FitnessTrainerPortalLoginScreen()),
        );
        return;
      case 'admin':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const MartialArtsAdminScreen()),
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_loginLabel(value)} — sign in coming soon on mobile')),
        );
    }
  }

  static String _loginLabel(String value) {
    return switch (value) {
      'user' => 'User Login',
      'doctor' => 'Women Doctor Login',
      'martial_arts' => 'Self-Defense Center Login',
      'salon' || 'glow' => 'Glow Space Login',
      'stylist' => 'Glow Space Login',
      'service_partner' => 'Service Partner Login',
      'marketplace_seller' => 'Product Seller Login',
      'entrepreneur' => 'Entrepreneur Login',
      'investor' => 'Investor Login',
      'event_host' => 'Event Host Login',
      'fitness_trainer' => 'Fitness Trainer Login',
      'admin' => 'Admin Login',
      _ => 'Login',
    };
  }

  Future<void> _requireLoginThen(VoidCallback action) async {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      action();
      return;
    }
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const LoginScreen(popOnSuccess: true)),
    );
    if (!mounted) return;
    if (ok == true && context.read<AuthState>().loggedIn) {
      action();
    }
  }

  void _openDangerMap() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DangerMapScreen()));
      });

  void _openWomenEvents() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WomenEventsScreen()));
      });

  void _openMartialArts() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MartialArtsScreen()));
      });

  void _openGlowSpace() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GlowSpaceScreen()));
      });

  void _openWomenMarketplace() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WomenMarketplaceScreen()));
      });

  void _openDoctors() => _requireLoginThen(() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ProviderCatalogScreen(
              title: 'Women Doctors',
              kind: CatalogKind.doctors,
            ),
          ),
        );
      });

  void _openLegal() => _requireLoginThen(() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ProviderCatalogScreen(
              title: 'Women Lawyers',
              kind: CatalogKind.lawyers,
            ),
          ),
        );
      });

  void _openJobs() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JobBookingsScreen()));
      });

  void _openFinancial() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialLiteracyScreen()));
      });

  void _openContacts() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactsScreen()));
      });

  void _openDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
    );
  }

  void _openSos() {
    final auth = context.read<AuthState>();
    if (auth.loggedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen(redirectToSos: true)),
      );
    }
  }

  void _showLoginSheet() {
    _LoginDropdown.showSheet(context, (v) => _handleLoginSelection(context, v));
  }

  void _showJoinSheet() {
    _JoinUsDropdown.showSheet(context, (v) => _handleJoinUsSelection(context, v));
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        _scroll.animateTo(0, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      case 1:
        _scrollTo(_quickKey);
      case 2:
        _openSos();
      case 3:
        _scrollTo(_communityKey);
      case 4:
        final auth = context.read<AuthState>();
        if (auth.loggedIn) {
          _openDashboard();
        } else {
          _showLoginSheet();
        }
    }
  }

  void _onSearch(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return;
    if (query.contains('sos') || query.contains('emergency')) {
      _openSos();
    } else if (query.contains('map') || query.contains('safe')) {
      _openDangerMap();
    } else if (query.contains('doctor')) {
      _openDoctors();
    } else if (query.contains('glow') || query.contains('salon') || query.contains('beauty')) {
      _openGlowSpace();
    } else if (query.contains('event')) {
      _openWomenEvents();
    } else if (query.contains('job')) {
      _openJobs();
    } else if (query.contains('market') || query.contains('shop')) {
      _openWomenMarketplace();
    } else if (query.contains('legal') || query.contains('lawyer')) {
      _openLegal();
    } else if (query.contains('defence') || query.contains('defense') || query.contains('martial')) {
      _openMartialArts();
    } else if (query.contains('help')) {
      _openContacts();
    } else {
      _scrollTo(_quickKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Showing modules for “$q”')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: LandingScreen.softBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: LandingScreen.primary,
          onRefresh: () => _loadLandingData(showSpinner: false),
          child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header
              SliverToBoxAdapter(
                child: _Header(
                  loggedIn: auth.loggedIn,
                  searchController: _search,
                  onSearch: _onSearch,
                  onLogin: _showLoginSheet,
                  onJoin: _showJoinSheet,
                  onDashboard: _openDashboard,
                  unreadNotifications: _unreadNotifications,
                  onNotifications: _openNotifications,
                ),
              ),
            // Hero
            SliverToBoxAdapter(
              child: _HeroBanner(
                onExplore: () {
                  if (auth.loggedIn) {
                    _openDashboard();
                  } else {
                    _scrollTo(_quickKey);
                  }
                },
              ),
            ),
            // SOS
            SliverToBoxAdapter(
              child: _SosBanner(
                onSendSos: _openSos,
                onContacts: _openContacts,
              ),
            ),
            // Quick access
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _quickKey,
                child: _QuickAccessGrid(
                  onSos: _openSos,
                  onMap: _openDangerMap,
                  onDoctors: _openDoctors,
                  onMarketplace: _openWomenMarketplace,
                  onGlow: _openGlowSpace,
                  onDefense: _openMartialArts,
                  onEvents: _openWomenEvents,
                  onJobs: _openJobs,
                  onLegal: _openLegal,
                  onHelpline: _openContacts,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 4)),
            if (_feedLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(child: SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))),
                ),
              ),
            SliverToBoxAdapter(child: _StatsStrip(stats: _stats)),
            SliverToBoxAdapter(
              child: _WhatsNewSection(
                items: _whatsNew,
                onOpen: _openFeedRoute,
                onDefense: _openMartialArts,
                onGlow: _openGlowSpace,
                onEvents: _openWomenEvents,
              ),
            ),
            SliverToBoxAdapter(
              child: _NearbySection(
                items: _nearby,
                onOpen: _openFeedRoute,
                onDoctors: _openDoctors,
                onGlow: _openGlowSpace,
                onDefense: _openMartialArts,
                onLegal: _openLegal,
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _communityKey,
                child: _CommunitySection(
                  items: _community,
                  onOpenCommunity: () => _openFeedRoute('community'),
                ),
              ),
            ),
            // Tips section stays as-is below
            SliverToBoxAdapter(
              child: _TipsAndCategories(
                onFinancial: _openFinancial,
                onDefense: _openMartialArts,
                onDoctors: _openDoctors,
                onJobs: _openJobs,
                onLegal: _openLegal,
                onEvents: _openWomenEvents,
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _offersKey,
                child: _OffersSection(
                  items: _offers,
                  onGlow: _openGlowSpace,
                  onDefense: _openMartialArts,
                  onMarketplace: _openWomenMarketplace,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        index: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Header
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({
    required this.loggedIn,
    required this.searchController,
    required this.onSearch,
    required this.onLogin,
    required this.onJoin,
    required this.onDashboard,
    required this.unreadNotifications,
    required this.onNotifications,
  });

  final bool loggedIn;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onLogin;
  final VoidCallback onJoin;
  final VoidCallback onDashboard;
  final int unreadNotifications;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/fightdfear-logo.jpg',
                    height: 52,
                    width: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      height: 52,
                      width: 52,
                      color: LandingScreen.primary,
                      alignment: Alignment.center,
                      child: const Text('FD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fight D Fear',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: LandingScreen.navy)),
                    Text('Your Safety is Our Priority',
                        style: TextStyle(fontSize: 11, color: LandingScreen.textGray, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (loggedIn)
                FilledButton.tonal(
                  onPressed: onDashboard,
                  style: FilledButton.styleFrom(foregroundColor: LandingScreen.primary),
                  child: const Text('My Dashboard'),
                )
              else ...[
                OutlinedButton(
                  onPressed: onLogin,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LandingScreen.primary,
                    side: const BorderSide(color: LandingScreen.primary, width: 1.4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                const SizedBox(width: 6),
                FilledButton(
                  onPressed: onJoin,
                  style: FilledButton.styleFrom(
                    backgroundColor: LandingScreen.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Join As', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ],
              const SizedBox(width: 4),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: onNotifications,
                    icon: const Icon(Icons.notifications_outlined, color: LandingScreen.navy),
                  ),
                  if (unreadNotifications > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: LandingScreen.primary,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          unreadNotifications > 99 ? '99+' : '$unreadNotifications',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: searchController,
            onSubmitted: onSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search doctors, events, jobs, shops & more...',
              hintStyle: const TextStyle(fontSize: 13, color: LandingScreen.textGray),
              prefixIcon: const Icon(Icons.search, color: LandingScreen.textGray),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: LandingScreen.primary, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Hero
// ═══════════════════════════════════════════════════════════════════════════

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 16 / 11,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/fighthero.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFFFE4E6),
                  alignment: Alignment.center,
                  child: const Icon(Icons.groups_rounded, size: 64, color: LandingScreen.primary),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x22000000), Color(0xCC000000)],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Together, We Stay Safe.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Emergency support, verified professionals, community and wellness – all in one place.',
                      style: TextStyle(color: Color(0xFFFFE4E6), fontSize: 13, height: 1.35),
                    ),
                    const SizedBox(height: 14),
                    FilledButton.icon(
                      onPressed: onExplore,
                      style: FilledButton.styleFrom(
                        backgroundColor: LandingScreen.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Explore Now', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SOS banner
// ═══════════════════════════════════════════════════════════════════════════

class _SosBanner extends StatelessWidget {
  const _SosBanner({required this.onSendSos, required this.onContacts});

  final VoidCallback onSendSos;
  final VoidCallback onContacts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [LandingScreen.primary, LandingScreen.primaryHover],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: LandingScreen.primary.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
              ),
              alignment: Alignment.center,
              child: const Text(
                'SOS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Emergency SOS',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  const Text('Need immediate help? We are here for you.',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onContacts,
                    child: const Text(
                      'Emergency Contacts →',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onSendSos,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: LandingScreen.primary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('SEND SOS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Quick access
// ═══════════════════════════════════════════════════════════════════════════

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({
    required this.onSos,
    required this.onMap,
    required this.onDoctors,
    required this.onMarketplace,
    required this.onGlow,
    required this.onDefense,
    required this.onEvents,
    required this.onJobs,
    required this.onLegal,
    required this.onHelpline,
  });

  final VoidCallback onSos;
  final VoidCallback onMap;
  final VoidCallback onDoctors;
  final VoidCallback onMarketplace;
  final VoidCallback onGlow;
  final VoidCallback onDefense;
  final VoidCallback onEvents;
  final VoidCallback onJobs;
  final VoidCallback onLegal;
  final VoidCallback onHelpline;

  @override
  Widget build(BuildContext context) {
    final items = <_QuickTileData>[
      _QuickTileData('SOS', Icons.warning_amber_rounded, const Color(0xFFEF4444), onSos),
      _QuickTileData('Safe Map', Icons.map_outlined, const Color(0xFF8B5CF6), onMap),
      _QuickTileData('Doctors', Icons.monitor_heart_outlined, const Color(0xFF22C55E), onDoctors),
      _QuickTileData('Marketplace', Icons.storefront_outlined, const Color(0xFFF97316), onMarketplace),
      _QuickTileData('Glow Space', Icons.spa_outlined, const Color(0xFFEC4899), onGlow),
      _QuickTileData('Self Defence', Icons.sports_martial_arts_outlined, const Color(0xFF3B82F6), onDefense),
      _QuickTileData('Women Events', Icons.event_outlined, const Color(0xFFF43F5E), onEvents),
      _QuickTileData('Jobs', Icons.work_outline, const Color(0xFF16A34A), onJobs),
      _QuickTileData('Legal Help', Icons.gavel_outlined, const Color(0xFF7C3AED), onLegal),
      _QuickTileData('Helpline', Icons.headset_mic_outlined, const Color(0xFF0D9488), onHelpline),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Quick Access',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: LandingScreen.navy)),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All', style: TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) {
              final t = items[i];
              return InkWell(
                onTap: t.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: t.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(t.icon, color: t.color, size: 24),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: LandingScreen.navy,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickTileData {
  const _QuickTileData(this.label, this.icon, this.color, this.onTap);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

// ═══════════════════════════════════════════════════════════════════════════
// Stats
// ═══════════════════════════════════════════════════════════════════════════

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.stats});

  final Map<String, dynamic> stats;

  String _n(String key, String fallback) {
    final v = stats[key];
    if (v is num) return '${v.toInt()}+';
    if (v != null && '$v'.isNotEmpty) return '$v+';
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final statsRows = [
      (Icons.event_available_outlined, _n('events', '800'), 'Events Organized'),
      (Icons.monitor_heart_outlined, _n('doctors', '450'), 'Verified Doctors'),
      (Icons.sports_martial_arts_outlined, _n('centres', '120'), 'Training Centres'),
      (Icons.spa_outlined, _n('salons', '200'), 'Glow Salons'),
      (Icons.storefront_outlined, _n('providers', '5K'), 'Marketplace Sellers'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SizedBox(
        height: 84,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: statsRows.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final s = statsRows[i];
            return Container(
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCE7F3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(s.$1, size: 18, color: LandingScreen.primary),
                  const Spacer(),
                  Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: LandingScreen.navy)),
                  Text(s.$3, style: const TextStyle(fontSize: 10, color: LandingScreen.textGray, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// What's New
// ═══════════════════════════════════════════════════════════════════════════

class _WhatsNewSection extends StatelessWidget {
  const _WhatsNewSection({
    required this.items,
    required this.onOpen,
    required this.onDefense,
    required this.onGlow,
    required this.onEvents,
  });

  final List<Map<String, dynamic>> items;
  final ValueChanged<String?> onOpen;
  final VoidCallback onDefense;
  final VoidCallback onGlow;
  final VoidCallback onEvents;

  @override
  Widget build(BuildContext context) {
    final cards = items.isNotEmpty
        ? items.map((e) {
            final route = e['route']?.toString();
            return _PromoCardData(
              badge: e['badge']?.toString() ?? 'New',
              title: e['title']?.toString() ?? 'Update',
              subtitle: e['subtitle']?.toString() ?? '',
              cta: e['cta']?.toString() ?? 'Open',
              color: switch (route) {
                'glow' => const Color(0xFFEC4899),
                'martial_arts' => const Color(0xFF3B82F6),
                'events' => const Color(0xFFF43F5E),
                _ => LandingScreen.primary,
              },
              icon: switch (route) {
                'glow' => Icons.spa,
                'martial_arts' => Icons.sports_martial_arts,
                'events' => Icons.event,
                _ => Icons.auto_awesome,
              },
              onTap: () => onOpen(route),
            );
          }).toList()
        : [
            _PromoCardData(
              badge: 'Explore',
              title: 'Self Defence Centres',
              subtitle: 'Find verified academies',
              cta: 'Book Now',
              color: const Color(0xFF3B82F6),
              icon: Icons.sports_martial_arts,
              onTap: onDefense,
            ),
            _PromoCardData(
              badge: 'Glow',
              title: 'Glow Space',
              subtitle: 'Salon & wellness offers',
              cta: 'Grab Now',
              color: const Color(0xFFEC4899),
              icon: Icons.spa,
              onTap: onGlow,
            ),
            _PromoCardData(
              badge: 'Events',
              title: 'Women Events',
              subtitle: 'Upcoming community events',
              cta: 'Register Now',
              color: const Color(0xFFF43F5E),
              icon: Icons.directions_run,
              onTap: onEvents,
            ),
          ];

    return _HorizontalSection(
      title: "What's New",
      children: [for (final c in cards) _PromoCard(data: c)],
    );
  }
}

class _PromoCardData {
  const _PromoCardData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String badge;
  final String title;
  final String subtitle;
  final String cta;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.data});
  final _PromoCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFCE7F3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            color: data.color.withValues(alpha: 0.15),
            child: Stack(
              children: [
                Center(child: Icon(data.icon, size: 42, color: data.color)),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.color,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(data.badge,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: LandingScreen.navy)),
                Text(data.subtitle, style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: data.onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: LandingScreen.primary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(data.cta, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Nearby
// ═══════════════════════════════════════════════════════════════════════════

class _NearbySection extends StatelessWidget {
  const _NearbySection({
    required this.items,
    required this.onOpen,
    required this.onDoctors,
    required this.onGlow,
    required this.onDefense,
    required this.onLegal,
  });

  final List<Map<String, dynamic>> items;
  final ValueChanged<String?> onOpen;
  final VoidCallback onDoctors;
  final VoidCallback onGlow;
  final VoidCallback onDefense;
  final VoidCallback onLegal;

  IconData _icon(String? name) {
    return switch (name) {
      'spa' => Icons.spa_outlined,
      'sports_martial_arts' => Icons.sports_martial_arts_outlined,
      'storefront' => Icons.storefront_outlined,
      'gavel' => Icons.gavel_outlined,
      _ => Icons.local_hospital_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final list = items.isNotEmpty
        ? items
        : [
            {'title': 'Women Doctors', 'subtitle': 'Verified care', 'rating': '4.8', 'route': 'doctors', 'icon': 'local_hospital'},
            {'title': 'Glow Salons', 'subtitle': 'Beauty & spa', 'rating': '4.7', 'route': 'glow', 'icon': 'spa'},
            {'title': 'Self Defence', 'subtitle': 'Training centres', 'rating': '4.6', 'route': 'martial_arts', 'icon': 'sports_martial_arts'},
            {'title': 'Legal Help', 'subtitle': 'Women lawyers', 'rating': '4.9', 'route': 'legal', 'icon': 'gavel'},
          ];

    return _HorizontalSection(
      title: 'Nearby Services',
      height: 150,
      children: [
        for (final i in list)
          InkWell(
            onTap: () {
              final route = i['route']?.toString();
              if (route == 'legal') {
                onLegal();
              } else if (route != null) {
                onOpen(route);
              } else {
                onDoctors();
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCE7F3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: LandingScreen.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_icon(i['icon']?.toString()), color: LandingScreen.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    i['title']?.toString() ?? 'Service',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: LandingScreen.navy),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          i['subtitle']?.toString() ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: LandingScreen.textGray),
                        ),
                      ),
                      if (i['rating'] != null) ...[
                        const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                        Text(' ${i['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Community
// ═══════════════════════════════════════════════════════════════════════════

class _CommunitySection extends StatelessWidget {
  const _CommunitySection({required this.items, required this.onOpenCommunity});

  final List<Map<String, dynamic>> items;
  final VoidCallback onOpenCommunity;

  @override
  Widget build(BuildContext context) {
    final posts = items.isNotEmpty
        ? items
        : [
            {
              'author': 'Fight D Fear',
              'description': 'Share your safety journey and join Creator Hub discussions.',
              'likes': 0,
              'comments': 0,
            },
          ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('From the Community',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: LandingScreen.navy)),
              ),
              TextButton(
                onPressed: onOpenCommunity,
                child: const Text('Open Hub', style: TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in posts.take(5))
            InkWell(
              onTap: onOpenCommunity,
              borderRadius: BorderRadius.circular(16),
              child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFCE7F3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: LandingScreen.primary.withValues(alpha: 0.12),
                        child: Text(
                          () {
                            final a = (p['author'] ?? p['title'] ?? 'F').toString();
                            return a.isEmpty ? 'F' : a[0].toUpperCase();
                          }(),
                          style: const TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p['author']?.toString() ?? p['title']?.toString() ?? 'Community',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: LandingScreen.navy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p['description']?.toString() ?? p['title']?.toString() ?? '',
                    style: const TextStyle(color: LandingScreen.navy, height: 1.35),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 16, color: LandingScreen.textGray),
                      Text(' ${p['likes'] ?? 0}', style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                      const SizedBox(width: 14),
                      const Icon(Icons.chat_bubble_outline, size: 16, color: LandingScreen.textGray),
                      Text(' ${p['comments'] ?? 0}', style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                    ],
                  ),
                ],
              ),
            ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Tips + categories
// ═══════════════════════════════════════════════════════════════════════════

class _TipsAndCategories extends StatelessWidget {
  const _TipsAndCategories({
    required this.onFinancial,
    required this.onDefense,
    required this.onDoctors,
    required this.onJobs,
    required this.onLegal,
    required this.onEvents,
  });

  final VoidCallback onFinancial;
  final VoidCallback onDefense;
  final VoidCallback onDoctors;
  final VoidCallback onJobs;
  final VoidCallback onLegal;
  final VoidCallback onEvents;

  @override
  Widget build(BuildContext context) {
    final cats = [
      ('Mental Wellness', Icons.psychology_outlined, onDoctors),
      ('Fitness', Icons.fitness_center_outlined, onDefense),
      ('Women Health', Icons.favorite_outline, onDoctors),
      ('Career Growth', Icons.work_outline, onJobs),
      ('Legal Awareness', Icons.gavel_outlined, onLegal),
      ('Entrepreneurship', Icons.lightbulb_outline, onEvents),
      ('Financial Literacy', Icons.menu_book_outlined, onFinancial),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFCE7F3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: LandingScreen.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_outlined, color: LandingScreen.primary),
                    ),
                    const SizedBox(width: 10),
                    const Text('Safety Tip of the Day',
                        style: TextStyle(fontWeight: FontWeight.w900, color: LandingScreen.navy)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Share your live location with a trusted person while traveling alone.',
                  style: TextStyle(color: LandingScreen.textGray, height: 1.4),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onDefense,
                  child: const Text('View More Tips',
                      style: TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Popular Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: LandingScreen.navy)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in cats)
                ActionChip(
                  avatar: Icon(c.$2, size: 16, color: LandingScreen.primary),
                  label: Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  onPressed: c.$3,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFFCE7F3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Offers
// ═══════════════════════════════════════════════════════════════════════════

class _OffersSection extends StatelessWidget {
  const _OffersSection({
    required this.items,
    required this.onGlow,
    required this.onDefense,
    required this.onMarketplace,
  });

  final List<Map<String, dynamic>> items;
  final VoidCallback onGlow;
  final VoidCallback onDefense;
  final VoidCallback onMarketplace;

  @override
  Widget build(BuildContext context) {
    final offers = items.isNotEmpty
        ? items
            .map((o) => (
                  o['title']?.toString() ?? 'Offer',
                  o['discountLabel']?.toString() ?? 'Special',
                  onGlow,
                  const Color(0xFFEC4899),
                ))
            .toList()
        : [
            ('Glow Space', 'Offers', onGlow, const Color(0xFFEC4899)),
            ('Self Defence', 'Training', onDefense, const Color(0xFF3B82F6)),
            ('Marketplace', 'Services', onMarketplace, const Color(0xFFF97316)),
          ];

    return _HorizontalSection(
      title: 'Offers & Discounts',
      height: 110,
      children: [
        for (final o in offers)
          InkWell(
            onTap: o.$3,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [o.$4, o.$4.withValues(alpha: 0.75)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.$1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text(o.$2,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    required this.title,
    required this.children,
    this.height = 230,
  });

  final String title;
  final List<Widget> children;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: LandingScreen.navy)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: height,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Bottom nav
// ═══════════════════════════════════════════════════════════════════════════

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.home_rounded, 'Home'),
              _navItem(1, Icons.explore_outlined, 'Explore'),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => onTap(2),
                    child: Container(
                      width: 58,
                      height: 58,
                      transform: Matrix4.translationValues(0, -12, 0),
                      decoration: BoxDecoration(
                        color: LandingScreen.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: LandingScreen.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('SOS',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                    ),
                  ),
                ),
              ),
              _navItem(3, Icons.groups_outlined, 'Community'),
              _navItem(4, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = index == i;
    final color = active ? LandingScreen.primary : LandingScreen.textGray;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Login / Join sheets (full current option lists)
// ═══════════════════════════════════════════════════════════════════════════

class _LoginOption {
  const _LoginOption({
    required this.value,
    required this.label,
    required this.icon,
    this.available = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool available;
}

class _LoginDropdown {
  static const options = [
    _LoginOption(value: 'user', label: 'User Login', icon: Icons.person_outline, available: true),
    _LoginOption(value: 'doctor', label: 'Women Doctor Login', icon: Icons.monitor_heart_outlined, available: true),
    _LoginOption(value: 'martial_arts', label: 'Self-Defense Center Login', icon: Icons.sports_martial_arts_outlined, available: true),
    _LoginOption(value: 'glow', label: 'Glow Space Login', icon: Icons.spa_outlined, available: true),
    _LoginOption(value: 'service_partner', label: 'Service Partner Login', icon: Icons.handshake_outlined, available: true),
    _LoginOption(value: 'marketplace_seller', label: 'Product Seller Login', icon: Icons.storefront_outlined, available: true),
    _LoginOption(value: 'entrepreneur', label: 'Entrepreneur Login', icon: Icons.lightbulb_outline, available: true),
    _LoginOption(value: 'investor', label: 'Investor Login', icon: Icons.trending_up, available: true),
    _LoginOption(value: 'event_host', label: 'Event Host Login', icon: Icons.event_available_outlined, available: true),
    _LoginOption(value: 'fitness_trainer', label: 'Fitness Trainer Login', icon: Icons.fitness_center_outlined, available: true),
    _LoginOption(value: 'admin', label: 'Admin Login', icon: Icons.admin_panel_settings_outlined, available: true),
  ];

  static Future<void> showSheet(BuildContext context, ValueChanged<String> onSelected) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text('Login as', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            ...options.map(
              (o) => ListTile(
                leading: Icon(o.icon, color: LandingScreen.primary),
                title: Text(o.label),
                trailing: o.available
                    ? const Text('Open', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700))
                    : null,
                onTap: () => Navigator.pop(ctx, o.value),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) onSelected(selected);
  }
}

class _JoinUsOption {
  const _JoinUsOption({
    required this.value,
    required this.label,
    required this.icon,
    this.available = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final bool available;
}

class _JoinUsDropdown {
  static const options = [
    _JoinUsOption(value: 'member', label: 'Join as Member', icon: Icons.person_outline, available: true),
    _JoinUsOption(value: 'doctor', label: 'Women Doctor', icon: Icons.monitor_heart_outlined, available: true),
    _JoinUsOption(value: 'martial_arts', label: 'Self-Defense Trainer', icon: Icons.sports_martial_arts_outlined, available: true),
    _JoinUsOption(value: 'glow', label: 'Glow Space', icon: Icons.spa_outlined, available: true),
    _JoinUsOption(value: 'service_partner', label: 'Service Partner', icon: Icons.handshake_outlined, available: true),
    _JoinUsOption(value: 'marketplace_seller', label: 'Product Seller', icon: Icons.storefront_outlined, available: true),
    _JoinUsOption(value: 'women_jobs', label: 'Women Jobs', icon: Icons.work_outline, available: true),
    _JoinUsOption(value: 'entrepreneur', label: 'Entrepreneur', icon: Icons.lightbulb_outline, available: true),
    _JoinUsOption(value: 'investor', label: 'Investor', icon: Icons.trending_up, available: true),
    _JoinUsOption(value: 'event_host', label: 'Event Host', icon: Icons.event_available_outlined, available: true),
    _JoinUsOption(value: 'fitness_trainer', label: 'Fitness Trainer', icon: Icons.fitness_center_outlined, available: true),
  ];

  static Future<void> showSheet(BuildContext context, ValueChanged<String> onSelected) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text('Join as', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            ...options.map(
              (o) => ListTile(
                leading: Icon(o.icon, color: LandingScreen.primary),
                title: Text(o.label),
                trailing: o.available
                    ? const Text('Open', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700))
                    : null,
                onTap: () => Navigator.pop(ctx, o.value),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) onSelected(selected);
  }
}
