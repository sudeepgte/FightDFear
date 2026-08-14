import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/landing_service.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';
import '../safety/contacts_screen.dart';
import '../creator/creator_hub_screen.dart';
import '../creator/creator_portal_login_screen.dart';
import '../safety/danger_map_screen.dart';
import '../doctors/doctor_portal_login_screen.dart';
import '../entrepreneur/entrepreneur_portal_login_screen.dart';
import '../events/event_host_portal_login_screen.dart';
import '../financial/financial_educator_portal_login_screen.dart';
import '../financial/financial_literacy_screen.dart';
import '../fitness/fitness_trainer_portal_login_screen.dart';
import '../fitness/fitness_wellness_screen.dart';
import '../glow/glow_provider_login_screen.dart';
import '../glow/glow_space_screen.dart';
import '../safety/home_screen.dart';
import '../investor/investor_portal_login_screen.dart';
import '../marketplace/job_bookings_screen.dart';
import 'landing_notifications_screen.dart';
import '../auth/login_screen.dart';
import '../martial_arts/martial_arts_admin_screen.dart';
import '../martial_arts/martial_arts_centre_login_screen.dart';
import '../martial_arts/martial_arts_screen.dart';
import '../doctors/women_doctors_screen.dart';
import '../marketplace/provider_catalog_screen.dart';
import '../auth/register_screen.dart';
import '../user/user_dashboard_screen.dart';
import '../events/women_events_screen.dart';
import '../marketplace/women_jobs_portal_login_screen.dart';
import '../marketplace/women_lawyer_portal_login_screen.dart';
import '../marketplace/women_marketplace_screen.dart';
import '../products/delivery_portal_login_screen.dart';
import '../products/women_products_screen.dart';
import '../products/women_products_seller_login_screen.dart';

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

  final _communityKey = GlobalKey();
  final _offersKey = GlobalKey();

  late final LandingService _landingApi;
  bool _feedLoading = true;
  String? _feedError;
  int _unreadNotifications = 0;
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _whatsNew = [];
  List<Map<String, dynamic>> _nearby = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _community = [];
  final _modulesKey = GlobalKey();

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

  /// Drop empty / obvious placeholder titles. Real published junk still surfaces via empty states.
  List<Map<String, dynamic>> _published(List<Map<String, dynamic>> items, {String titleKey = 'title'}) {
    return items.where((e) {
      final title = (e[titleKey] ?? e['name'] ?? '').toString().trim();
      if (title.length < 3) return false;
      if (RegExp(r'^(test|dummy|asdf|qwerty|xxx+|lorem)\b', caseSensitive: false).hasMatch(title)) {
        return false;
      }
      final lettersOnly = title.replaceAll(RegExp(r'[^a-zA-Z]'), '');
      if (!title.contains(' ') &&
          lettersOnly.length >= 8 &&
          lettersOnly.length <= 14 &&
          !RegExp(r'[aeiouAEIOU]').hasMatch(lettersOnly)) {
        return false;
      }
      return true;
    }).take(6).toList();
  }

  Future<void> _loadLandingData({bool showSpinner = true}) async {
    if (showSpinner && mounted) {
      setState(() {
        _feedLoading = true;
        _feedError = null;
      });
    }
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
        _whatsNew = _published(_asMapList(feed['whatsNew']));
        _nearby = _published(_asMapList(feed['nearby']));
        _offers = _published(_asMapList(feed['offers']));
        _community = _published(_asMapList(feed['community']), titleKey: 'description');
        if (_community.isEmpty) {
          _community = _published(_asMapList(feed['community']));
        }
        _feedError = null;
      } else {
        _feedError = feed['error']?.toString() ?? 'Could not load landing content';
      }
      if (notif['success'] == true) {
        _unreadNotifications = (notif['unreadCount'] is num)
            ? (notif['unreadCount'] as num).toInt()
            : int.tryParse('${notif['unreadCount']}') ?? 0;
      }
    } catch (e) {
      _feedError = e.toString();
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
        _scrollTo(_modulesKey);
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
          MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen(startRegister: true)),
        );
        return;
      case 'salon':
      case 'glow':
      case 'stylist':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const GlowProviderLoginScreen(startRegister: true)),
        );
        return;
      case 'service_partner':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WomenJobsPortalLoginScreen(startRegister: true),
          ),
        );
        return;
      case 'women_lawyer':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WomenLawyerPortalLoginScreen(startRegister: true),
          ),
        );
        return;
      case 'marketplace_seller':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen(startRegister: true)),
        );
        return;
      case 'women_jobs':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const WomenJobsPortalLoginScreen(startRegister: true),
          ),
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
      case 'delivery':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DeliveryPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'creator':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreatorPortalLoginScreen(startRegister: true)),
        );
        return;
      case 'financial':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FinancialEducatorPortalLoginScreen(startRegister: true)),
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
      'women_lawyer' => 'Women Lawyer',
      'marketplace_seller' => 'Product Seller',
      'women_jobs' => 'Women Jobs',
      'entrepreneur' => 'Entrepreneur',
      'investor' => 'Investor',
      'event_host' => 'Event Host',
      'fitness_trainer' => 'Fitness Trainer',
      'delivery' => 'Delivery Guy',
      'creator' => 'Creator Hub',
      'financial' => 'Financial Educator',
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
          MaterialPageRoute(builder: (_) => const WomenJobsPortalLoginScreen()),
        );
        return;
      case 'women_lawyer':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenLawyerPortalLoginScreen()),
        );
        return;
      case 'women_jobs':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenJobsPortalLoginScreen()),
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
      case 'delivery':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DeliveryPortalLoginScreen()),
        );
        return;
      case 'creator':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CreatorPortalLoginScreen()),
        );
        return;
      case 'financial':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FinancialEducatorPortalLoginScreen()),
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
      'women_lawyer' => 'Women Lawyer Login',
      'women_jobs' => 'Women Jobs Login',
      'marketplace_seller' => 'Product Seller Login',
      'entrepreneur' => 'Entrepreneur Login',
      'investor' => 'Investor Login',
      'event_host' => 'Event Host Login',
      'fitness_trainer' => 'Fitness Trainer Login',
      'delivery' => 'Delivery Guy Login',
      'creator' => 'Creator Hub Login',
      'financial' => 'Financial Educator Login',
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
          MaterialPageRoute(builder: (_) => const WomenDoctorsScreen()),
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
        _openJobsAfterLogin();
      });

  Future<void> _openJobsAfterLogin() async {
    try {
      final res = await MarketplaceService(context.read<AuthState>().api).myJobApplication();
      if (!mounted) return;
      if (res['isVerifiedWorker'] == true) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const JobBookingsScreen(workerView: true)),
        );
        return;
      }
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WomenMarketplaceScreen()),
    );
  }

  void _openFinancial() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialLiteracyScreen()));
      });

  void _openFitness() => _requireLoginThen(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FitnessWellnessScreen()));
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

  void _showAllModules() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final items = <(IconData, String, VoidCallback)>[
          (Icons.monitor_heart_outlined, 'Doctors', _openDoctors),
          (Icons.work_outline, 'Jobs', _openJobs),
          (Icons.event_outlined, 'Events', _openWomenEvents),
          (Icons.menu_book_outlined, 'Education', _openFinancial),
          (Icons.storefront_outlined, 'Marketplace', _openWomenMarketplace),
          (Icons.fitness_center_outlined, 'Fitness', _openFitness),
          (Icons.spa_outlined, 'Glow Space', _openGlowSpace),
          (Icons.sports_martial_arts_outlined, 'Self Defence', _openMartialArts),
          (Icons.gavel_outlined, 'Legal Help', _openLegal),
          (Icons.map_outlined, 'Danger Map', _openDangerMap),
          (Icons.shopping_bag_outlined, 'Women Products', () {
            _requireLoginThen(() {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WomenProductsScreen()),
              );
            });
          }),
          (Icons.video_camera_front_outlined, 'Creator Hub', () => _openFeedRoute('community')),
          (Icons.headset_mic_outlined, 'Trusted Contacts', _openContacts),
        ];
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
                  leading: Icon(m.$1, color: LandingScreen.primary),
                  title: Text(m.$2),
                  onTap: () {
                    Navigator.pop(ctx);
                    m.$3();
                  },
                ),
            ],
          ),
        );
      },
    );
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
        _scrollTo(_modulesKey);
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
      _scrollTo(_modulesKey);
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
            SliverToBoxAdapter(
              child: _HeroBanner(
                ctaLabel: auth.loggedIn ? 'Open my dashboard' : 'Explore',
                onExplore: () {
                  if (auth.loggedIn) {
                    _openDashboard();
                  } else {
                    _scrollTo(_modulesKey);
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _SosBanner(
                onSendSos: _openSos,
                onContacts: _openContacts,
              ),
            ),
            if (_feedError != null)
              SliverToBoxAdapter(
                child: _FeedErrorBanner(onRetry: () => _loadLandingData()),
              ),
            SliverToBoxAdapter(
              child: _StatsStrip(stats: _stats, loading: _feedLoading, error: _feedError != null),
            ),
            SliverToBoxAdapter(
              child: _WhatsNewSection(
                items: _whatsNew,
                loading: _feedLoading,
                error: _feedError != null,
                onOpen: _openFeedRoute,
                onViewAll: _openWomenEvents,
                onRetry: () => _loadLandingData(),
              ),
            ),
            SliverToBoxAdapter(
              child: _NearbySection(
                items: _nearby,
                loading: _feedLoading,
                error: _feedError != null,
                onOpen: _openFeedRoute,
                onViewAll: _openDoctors,
                onRetry: () => _loadLandingData(),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _offersKey,
                child: _OffersSection(
                  items: _offers,
                  loading: _feedLoading,
                  error: _feedError != null,
                  onGlow: _openGlowSpace,
                  onRetry: () => _loadLandingData(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _modulesKey,
                child: _PopularCategories(
                  onDoctors: _openDoctors,
                  onJobs: _openJobs,
                  onEvents: _openWomenEvents,
                  onFinancial: _openFinancial,
                  onMarketplace: _openWomenMarketplace,
                  onFitness: _openFitness,
                  onViewAll: _showAllModules,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _communityKey,
                child: _CommunitySection(
                  items: _community,
                  loading: _feedLoading,
                  error: _feedError != null,
                  onOpenCommunity: () => _openFeedRoute('community'),
                  onRetry: () => _loadLandingData(),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: _SafetyTipCard()),
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
                borderRadius: BorderRadius.circular(10),
                child: ColoredBox(
                  color: Colors.white,
                  child: Image.asset(
                    'assets/images/fightdfear-logo.jpg',
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Container(
                      height: 40,
                      width: 40,
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
                    Text('FightDFear',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: LandingScreen.navy)),
                    Text('Safety · Community · Opportunity',
                        style: TextStyle(fontSize: 11, color: LandingScreen.textGray, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (loggedIn)
                IconButton(
                  tooltip: 'My Dashboard',
                  onPressed: onDashboard,
                  icon: const Icon(Icons.person_outline, color: LandingScreen.navy),
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
              hintText: 'Search doctors, events, jobs…',
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
  const _HeroBanner({required this.onExplore, required this.ctaLabel});

  final VoidCallback onExplore;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/fighthero.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFFFE4E6),
                  alignment: Alignment.center,
                  child: const Icon(Icons.groups_rounded, size: 56, color: LandingScreen.primary),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Color(0xBB000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover FightDFear',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Safety · Empowerment · Community · Services',
                      style: TextStyle(color: Color(0xFFFFE4E6), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: onExplore,
                      style: FilledButton.styleFrom(
                        backgroundColor: LandingScreen.primary,
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text(ctaLabel, style: const TextStyle(fontWeight: FontWeight.w800)),
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

class _FeedErrorBanner extends StatelessWidget {
  const _FeedErrorBanner({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LandingScreen.primary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded, color: LandingScreen.primary),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Could not load latest content.',
                style: TextStyle(fontWeight: FontWeight.w600, color: LandingScreen.navy, fontSize: 13),
              ),
            ),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.subtitle, this.actionLabel, this.onAction, this.padEnd = true});
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool padEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: padEnd ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: LandingScreen.navy),
                ),
              ),
              if (actionLabel != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel!, style: const TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          if (subtitle != null)
            Text(subtitle!, style: const TextStyle(fontSize: 12, color: LandingScreen.textGray, height: 1.3)),
        ],
      ),
    );
  }
}

class _InlineState extends StatelessWidget {
  const _InlineState({
    required this.loading,
    required this.error,
    required this.empty,
    required this.emptyMessage,
    this.onRetry,
    this.actionLabel,
    this.onAction,
    this.height = 96,
  });

  final bool loading;
  final bool error;
  final bool empty;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (!loading && !error && !empty) return const SizedBox.shrink();
    return Container(
      constraints: BoxConstraints(minHeight: height),
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      alignment: Alignment.centerLeft,
      child: loading
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error ? 'Could not load this section.' : emptyMessage,
                  style: const TextStyle(color: LandingScreen.textGray, fontSize: 13),
                ),
                if (error && onRetry != null)
                  TextButton(onPressed: onRetry, child: const Text('Retry'))
                else if (!error && actionLabel != null)
                  TextButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Stats
// ═══════════════════════════════════════════════════════════════════════════

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.stats, required this.loading, required this.error});

  final Map<String, dynamic> stats;
  final bool loading;
  final bool error;

  String _n(String key) {
    final v = stats[key];
    if (v is num) return '${v.toInt()}';
    if (v != null && '$v'.trim().isNotEmpty) return '$v';
    return '0';
  }

  @override
  Widget build(BuildContext context) {
    if (error && stats.isEmpty) {
      return const SizedBox.shrink();
    }
    final statsRows = [
      (Icons.event_available_outlined, _n('events'), 'Events'),
      (Icons.monitor_heart_outlined, _n('doctors'), 'Doctors'),
      (Icons.sports_martial_arts_outlined, _n('centres'), 'Centres'),
      (Icons.spa_outlined, _n('salons'), 'Glow salons'),
      (Icons.storefront_outlined, _n('providers'), 'Providers'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
      child: SizedBox(
        height: 78,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: 16),
          itemCount: statsRows.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final s = statsRows[i];
            return Container(
              width: 118,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(s.$1, size: 16, color: LandingScreen.primary),
                  const Spacer(),
                  Text(
                    loading && stats.isEmpty ? '—' : s.$2,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: LandingScreen.navy),
                  ),
                  Text(s.$3, style: const TextStyle(fontSize: 11, color: LandingScreen.textGray, fontWeight: FontWeight.w600)),
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
    required this.loading,
    required this.error,
    required this.onOpen,
    required this.onViewAll,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> items;
  final bool loading;
  final bool error;
  final ValueChanged<String?> onOpen;
  final VoidCallback onViewAll;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader("What's new", actionLabel: 'View all', onAction: onViewAll),
          const SizedBox(height: 8),
          if (loading || error || items.isEmpty)
            _InlineState(
              loading: loading && items.isEmpty,
              error: error && items.isEmpty,
              empty: !loading && !error && items.isEmpty,
              emptyMessage: 'No published updates right now.',
              onRetry: onRetry,
              actionLabel: 'Browse events',
              onAction: onViewAll,
            )
          else
            SizedBox(
              height: 196,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final e = items[i];
                  final route = e['route']?.toString();
                  return _FeedCard(
                    badge: e['badge']?.toString() ?? e['kind']?.toString() ?? 'New',
                    title: e['title']?.toString() ?? 'Update',
                    subtitle: e['subtitle']?.toString() ?? '',
                    cta: e['cta']?.toString() ?? 'Open',
                    imageUrl: (e['image'] ?? e['imageUrl'] ?? e['photoUrl'])?.toString(),
                    icon: switch (route) {
                      'glow' => Icons.spa_outlined,
                      'martial_arts' => Icons.sports_martial_arts_outlined,
                      'events' => Icons.event_outlined,
                      'doctors' => Icons.monitor_heart_outlined,
                      'marketplace' => Icons.storefront_outlined,
                      _ => Icons.auto_awesome_outlined,
                    },
                    onTap: () => onOpen(route),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  const _FeedCard({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.onTap,
    this.imageUrl,
  });

  final String badge;
  final String title;
  final String subtitle;
  final String cta;
  final IconData icon;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 196,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 88,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: LandingScreen.primary.withValues(alpha: 0.08),
                    child: url.isEmpty
                        ? Icon(icon, size: 32, color: LandingScreen.primary)
                        : ModuleTheme.networkImage(url, fit: BoxFit.cover, error: Icon(icon, color: LandingScreen.primary)),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: LandingScreen.navy.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: LandingScreen.navy)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                  const SizedBox(height: 8),
                  Text(cta, style: const TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
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
    required this.loading,
    required this.error,
    required this.onOpen,
    required this.onViewAll,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> items;
  final bool loading;
  final bool error;
  final ValueChanged<String?> onOpen;
  final VoidCallback onViewAll;
  final VoidCallback onRetry;

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            'Nearby & verified',
            subtitle: 'Curated verified listings. GPS nearby is not available yet.',
            actionLabel: 'View all',
            onAction: onViewAll,
          ),
          const SizedBox(height: 8),
          if (loading || error || items.isEmpty)
            _InlineState(
              loading: loading && items.isEmpty,
              error: error && items.isEmpty,
              empty: !loading && !error && items.isEmpty,
              emptyMessage: 'No nearby listings available right now.',
              onRetry: onRetry,
              actionLabel: 'Find a doctor',
              onAction: onViewAll,
              height: 110,
            )
          else
            SizedBox(
              height: 138,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final item = items[i];
                  return InkWell(
                    onTap: () => onOpen(item['route']?.toString()),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 156,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(_icon(item['icon']?.toString()), color: LandingScreen.primary),
                          const Spacer(),
                          Text(
                            item['title']?.toString() ?? 'Listing',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: LandingScreen.navy),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['kind']?.toString() ?? item['subtitle']?.toString() ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, color: LandingScreen.textGray),
                                ),
                              ),
                              if (item['rating'] != null) ...[
                                const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)),
                                Text(' ${item['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Community
// ═══════════════════════════════════════════════════════════════════════════

class _CommunitySection extends StatelessWidget {
  const _CommunitySection({
    required this.items,
    required this.loading,
    required this.error,
    required this.onOpenCommunity,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> items;
  final bool loading;
  final bool error;
  final VoidCallback onOpenCommunity;
  final VoidCallback onRetry;

  String _when(String? raw) {
    final dt = DateTime.tryParse((raw ?? '').replaceFirst(' ', 'T'));
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader('From the community', actionLabel: 'View all', onAction: onOpenCommunity, padEnd: false),
          const SizedBox(height: 8),
          if (loading || error || items.isEmpty)
            _InlineState(
              loading: loading && items.isEmpty,
              error: error && items.isEmpty,
              empty: !loading && !error && items.isEmpty,
              emptyMessage: 'No community posts yet.',
              onRetry: onRetry,
              actionLabel: 'Open Creator Hub',
              onAction: onOpenCommunity,
            )
          else
            for (final p in items.take(4))
              InkWell(
                onTap: onOpenCommunity,
                borderRadius: BorderRadius.circular(14),
                child: Container(
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
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: LandingScreen.primary.withValues(alpha: 0.12),
                            child: Text(
                              () {
                                final a = (p['author'] ?? p['title'] ?? 'F').toString().trim();
                                return a.isEmpty ? 'F' : a[0].toUpperCase();
                              }(),
                              style: const TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              p['author']?.toString() ?? p['title']?.toString() ?? 'Community',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w800, color: LandingScreen.navy),
                            ),
                          ),
                          if ((p['category']?.toString() ?? '').isNotEmpty)
                            Text(p['category'].toString(), style: const TextStyle(fontSize: 11, color: LandingScreen.textGray)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p['description']?.toString() ?? p['title']?.toString() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: LandingScreen.navy, height: 1.35, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border, size: 16, color: LandingScreen.textGray),
                          Text(' ${p['likes'] ?? 0}', style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                          const SizedBox(width: 14),
                          const Icon(Icons.chat_bubble_outline, size: 16, color: LandingScreen.textGray),
                          Text(' ${p['comments'] ?? 0}', style: const TextStyle(fontSize: 12, color: LandingScreen.textGray)),
                          const Spacer(),
                          Text(_when(p['createdAt']?.toString()), style: const TextStyle(fontSize: 11, color: LandingScreen.textGray)),
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

class _PopularCategories extends StatelessWidget {
  const _PopularCategories({
    required this.onDoctors,
    required this.onJobs,
    required this.onEvents,
    required this.onFinancial,
    required this.onMarketplace,
    required this.onFitness,
    required this.onViewAll,
  });

  final VoidCallback onDoctors;
  final VoidCallback onJobs;
  final VoidCallback onEvents;
  final VoidCallback onFinancial;
  final VoidCallback onMarketplace;
  final VoidCallback onFitness;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final cats = [
      (Icons.monitor_heart_outlined, 'Doctors', onDoctors),
      (Icons.work_outline, 'Jobs', onJobs),
      (Icons.event_outlined, 'Events', onEvents),
      (Icons.menu_book_outlined, 'Education', onFinancial),
      (Icons.storefront_outlined, 'Marketplace', onMarketplace),
      (Icons.fitness_center_outlined, 'Fitness', onFitness),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader('Popular categories', actionLabel: 'View all', onAction: onViewAll, padEnd: false),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.35,
            children: [
              for (final c in cats)
                InkWell(
                  onTap: c.$3,
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
                        Icon(c.$1, color: LandingScreen.primary),
                        const SizedBox(height: 6),
                        Text(c.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: LandingScreen.navy)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SafetyTipCard extends StatelessWidget {
  const _SafetyTipCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined, color: LandingScreen.primary),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Safety tip', style: TextStyle(fontWeight: FontWeight.w800, color: LandingScreen.navy)),
                  SizedBox(height: 4),
                  Text(
                    'Share your live location with a trusted contact while travelling alone.',
                    style: TextStyle(color: LandingScreen.textGray, height: 1.35, fontSize: 13),
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

// ═══════════════════════════════════════════════════════════════════════════
// Offers
// ═══════════════════════════════════════════════════════════════════════════

class _OffersSection extends StatelessWidget {
  const _OffersSection({
    required this.items,
    required this.loading,
    required this.error,
    required this.onGlow,
    required this.onRetry,
  });

  final List<Map<String, dynamic>> items;
  final bool loading;
  final bool error;
  final VoidCallback onGlow;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader('Offers', actionLabel: items.isEmpty ? null : 'View all', onAction: items.isEmpty ? null : onGlow),
          const SizedBox(height: 8),
          if (loading || error || items.isEmpty)
            _InlineState(
              loading: loading && items.isEmpty,
              error: error && items.isEmpty,
              empty: !loading && !error && items.isEmpty,
              emptyMessage: 'No offers available right now.',
              onRetry: onRetry,
              height: 88,
            )
          else
            SizedBox(
              height: 108,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final o = items[i];
                  final discount = o['discountLabel']?.toString() ?? '';
                  return InkWell(
                    onTap: onGlow,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 168,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (discount.isNotEmpty)
                            Text(discount, style: const TextStyle(color: LandingScreen.primary, fontWeight: FontWeight.w900)),
                          Text(
                            o['title']?.toString() ?? 'Offer',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: LandingScreen.navy),
                          ),
                          const Spacer(),
                          Text(
                            o['salonName']?.toString() ?? 'Glow Space',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: LandingScreen.textGray),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
    _LoginOption(value: 'women_lawyer', label: 'Women Lawyer Login', icon: Icons.gavel_outlined, available: true),
    _LoginOption(value: 'women_jobs', label: 'Women Jobs Login', icon: Icons.work_outline, available: true),
    _LoginOption(value: 'marketplace_seller', label: 'Product Seller Login', icon: Icons.storefront_outlined, available: true),
    _LoginOption(value: 'entrepreneur', label: 'Entrepreneur Login', icon: Icons.lightbulb_outline, available: true),
    _LoginOption(value: 'investor', label: 'Investor Login', icon: Icons.trending_up, available: true),
    _LoginOption(value: 'event_host', label: 'Event Host Login', icon: Icons.event_available_outlined, available: true),
    _LoginOption(value: 'fitness_trainer', label: 'Fitness Trainer Login', icon: Icons.fitness_center_outlined, available: true),
    _LoginOption(value: 'delivery', label: 'Delivery Guy Login', icon: Icons.delivery_dining_outlined, available: true),
    _LoginOption(value: 'creator', label: 'Creator Hub Login', icon: Icons.video_camera_front_outlined, available: true),
    _LoginOption(value: 'financial', label: 'Financial Educator Login', icon: Icons.menu_book_outlined, available: true),
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
    this.subtitle,
    this.available = false,
  });

  final String value;
  final String label;
  final IconData icon;
  final String? subtitle;
  final bool available;
}

class _JoinUsDropdown {
  static const options = [
    _JoinUsOption(value: 'member', label: 'Join as Member', icon: Icons.person_outline, available: true),
    _JoinUsOption(value: 'doctor', label: 'Women Doctor', icon: Icons.monitor_heart_outlined, available: true),
    _JoinUsOption(value: 'martial_arts', label: 'Self-Defense Trainer', subtitle: 'Karate, Taekwondo & martial arts centres', icon: Icons.sports_martial_arts_outlined, available: true),
    _JoinUsOption(value: 'glow', label: 'Glow Space', icon: Icons.spa_outlined, available: true),
    _JoinUsOption(value: 'women_lawyer', label: 'Women Lawyer', subtitle: 'Dedicated lawyer registration — consultations & advocacy', icon: Icons.gavel_outlined, available: true),
    _JoinUsOption(value: 'marketplace_seller', label: 'Product Seller', subtitle: 'List products, photos, stock & orders', icon: Icons.storefront_outlined, available: true),
    _JoinUsOption(value: 'delivery', label: 'Delivery Guy', subtitle: 'Pick up and deliver Women Products orders', icon: Icons.delivery_dining_outlined, available: true),
    _JoinUsOption(value: 'women_jobs', label: 'Women Jobs', icon: Icons.work_outline, available: true),
    _JoinUsOption(value: 'entrepreneur', label: 'Entrepreneur', icon: Icons.lightbulb_outline, available: true),
    _JoinUsOption(value: 'investor', label: 'Investor', icon: Icons.trending_up, available: true),
    _JoinUsOption(value: 'event_host', label: 'Event Host', icon: Icons.event_available_outlined, available: true),
    _JoinUsOption(value: 'fitness_trainer', label: 'Fitness Trainer', subtitle: 'Gym, Zumba, Yoga & wellness coaching', icon: Icons.fitness_center_outlined, available: true),
    _JoinUsOption(value: 'creator', label: 'Creator Hub', subtitle: 'Publish videos, reels & stories after admin approval', icon: Icons.video_camera_front_outlined, available: true),
    _JoinUsOption(value: 'financial', label: 'Financial Educator', subtitle: 'Publish videos, live sessions & workshops after admin approval', icon: Icons.menu_book_outlined, available: true),
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
                subtitle: o.subtitle == null ? null : Text(o.subtitle!, style: const TextStyle(fontSize: 12)),
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
