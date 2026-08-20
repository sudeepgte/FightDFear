import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/admin_service.dart';
import '../../services/auth_state.dart';

const Color _navy = Color(0xFF1E1B4B);
const Color _navyLight = Color(0xFF312E81);
const Color _coral = Color(0xFFF43F5E);
const Color _teal = Color(0xFF10B981);
const Color _amber = Color(0xFFF59E0B);
const Color _purple = Color(0xFF8B5CF6);

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late final AdminService _adminSvc;
  late final TabController _tabController;

  // Auth State
  bool _loggedIn = false;
  bool _checkingAuth = true;
  bool _loginBusy = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  String? _authError;

  // Dashboard Data State
  bool _loadingStats = false;
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _activities = [];

  // Approvals State
  String _selectedCategory = 'DOCTORS';
  String _selectedStatus = 'PENDING';
  final _searchCtrl = TextEditingController();
  bool _loadingApprovals = false;
  List<Map<String, dynamic>> _approvalItems = [];

  // SOS Alerts State
  bool _loadingSos = false;
  List<Map<String, dynamic>> _sosAlerts = [];

  // Reported Videos State
  bool _loadingReports = false;
  List<Map<String, dynamic>> _reportedVideos = [];

  // Broadcasts State
  final _broadcastTitleCtrl = TextEditingController();
  final _broadcastMsgCtrl = TextEditingController();
  String _broadcastAudience = 'ALL';
  bool _sendingBroadcast = false;

  // Contact Messages State
  bool _loadingMessages = false;
  List<Map<String, dynamic>> _contactMessages = [];

  final List<Map<String, dynamic>> _approvalCategories = [
    {'key': 'DOCTORS', 'label': 'Doctors', 'icon': Icons.medical_services_rounded},
    {'key': 'SALONS', 'label': 'Salons', 'icon': Icons.content_cut_rounded},
    {'key': 'STYLISTS', 'label': 'Stylists', 'icon': Icons.face_retouching_natural_rounded},
    {'key': 'CENTRES', 'label': 'Martial Arts', 'icon': Icons.sports_mma_rounded},
    {'key': 'TRAINERS', 'label': 'Fitness Trainers', 'icon': Icons.fitness_center_rounded},
    {'key': 'ENTREPRENEURS', 'label': 'Startups', 'icon': Icons.business_center_rounded},
    {'key': 'INVESTORS', 'label': 'Investors', 'icon': Icons.monetization_on_rounded},
    {'key': 'EVENTS', 'label': 'Events', 'icon': Icons.event_rounded},
    {'key': 'LAWYERS', 'label': 'Lawyers', 'icon': Icons.gavel_rounded},
    {'key': 'JOBS', 'label': 'Job Workers', 'icon': Icons.work_rounded},
    {'key': 'SELLERS', 'label': 'Product Sellers', 'icon': Icons.storefront_rounded},
    {'key': 'DELIVERY', 'label': 'Delivery Partners', 'icon': Icons.two_wheeler_rounded},
    {'key': 'USERS', 'label': 'Users Directory', 'icon': Icons.people_alt_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _adminSvc = AdminService(context.read<AuthState>().api);
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _loggedIn) {
        _onTabChanged(_tabController.index);
      }
    });
    _bootstrapAuth();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _searchCtrl.dispose();
    _broadcastTitleCtrl.dispose();
    _broadcastMsgCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrapAuth() async {
    setState(() => _checkingAuth = true);
    final isAuth = await _adminSvc.isLoggedIn();
    if (!mounted) return;
    setState(() {
      _loggedIn = isAuth;
      _checkingAuth = false;
    });
    if (isAuth) {
      _loadDashboardStats();
      _loadApprovals();
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _authError = 'Please enter both Email and Password.');
      return;
    }
    setState(() {
      _loginBusy = true;
      _authError = null;
    });
    try {
      final res = await _adminSvc.login(email: email, password: pass);
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _loggedIn = true;
          _loginBusy = false;
        });
        _loadDashboardStats();
        _loadApprovals();
      } else {
        setState(() {
          _loginBusy = false;
          _authError = res['error']?.toString() ?? 'Invalid admin credentials.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loginBusy = false;
          _authError = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await _adminSvc.logout();
    if (!mounted) return;
    setState(() {
      _loggedIn = false;
      _stats = {};
      _approvalItems = [];
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        _loadDashboardStats();
        break;
      case 1:
        _loadApprovals();
        break;
      case 2:
        _loadSos();
        break;
      case 3:
        _loadReports();
        break;
      case 4:
        _loadBroadcasts();
        break;
      case 5:
        _loadMessages();
        break;
    }
  }

  // --- API Loaders ---

  Future<void> _loadDashboardStats() async {
    setState(() => _loadingStats = true);
    try {
      final res = await _adminSvc.getDashboardStats();
      if (mounted && res['success'] == true) {
        setState(() {
          _stats = Map<String, dynamic>.from(res['stats'] as Map? ?? {});
          _activities = (res['activities'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingStats = false);
  }

  Future<void> _loadApprovals() async {
    setState(() => _loadingApprovals = true);
    try {
      final res = await _adminSvc.getApprovals(
        category: _selectedCategory,
        status: _selectedStatus,
        search: _searchCtrl.text.trim(),
      );
      if (mounted && res['success'] == true) {
        setState(() {
          _approvalItems = (res['items'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingApprovals = false);
  }

  Future<void> _loadSos() async {
    setState(() => _loadingSos = true);
    try {
      final res = await _adminSvc.getSosAlerts();
      if (mounted && res['success'] == true) {
        setState(() {
          _sosAlerts = (res['alerts'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingSos = false);
  }

  Future<void> _loadReports() async {
    setState(() => _loadingReports = true);
    try {
      final res = await _adminSvc.getReportedVideos();
      if (mounted && res['success'] == true) {
        setState(() {
          _reportedVideos = (res['reports'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingReports = false);
  }

  Future<void> _loadBroadcasts() async {
    // optional reload
  }

  Future<void> _loadMessages() async {
    setState(() => _loadingMessages = true);
    try {
      final res = await _adminSvc.getContactMessages();
      if (mounted && res['success'] == true) {
        setState(() {
          _contactMessages = (res['messages'] as List? ?? [])
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        });
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingMessages = false);
  }

  // --- Actions ---

  Future<void> _approveItem(String category, dynamic id) async {
    try {
      final res = await _adminSvc.approve(category: category, id: id);
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? '$category approved successfully!'), backgroundColor: Colors.green),
        );
        _loadApprovals();
        _loadDashboardStats();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Failed to approve'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _showRejectDialog(String category, dynamic id, String title) async {
    final reasonCtrl = TextEditingController(text: 'Profile does not meet verification requirements.');
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reject $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter rejection feedback or changes requested:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Provide specific reason...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final res = await _adminSvc.reject(
          category: category,
          id: id,
          reason: reasonCtrl.text.trim(),
        );
        if (!mounted) return;
        if (res['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message']?.toString() ?? '$category rejected.'), backgroundColor: Colors.orange),
          );
          _loadApprovals();
          _loadDashboardStats();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['error']?.toString() ?? 'Failed to reject'), backgroundColor: Colors.red),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
        }
      }
    }
  }

  Future<void> _resolveSos(dynamic id) async {
    try {
      final res = await _adminSvc.resolveSos(id);
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SOS emergency alert resolved.'), backgroundColor: Colors.green),
        );
        _loadSos();
        _loadDashboardStats();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _dismissReport(dynamic id) async {
    try {
      final res = await _adminSvc.dismissReport(id);
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report dismissed.'), backgroundColor: Colors.blueGrey),
        );
        _loadReports();
        _loadDashboardStats();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _sendBroadcast() async {
    final title = _broadcastTitleCtrl.text.trim();
    final msg = _broadcastMsgCtrl.text.trim();
    if (title.isEmpty || msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Title and Message')),
      );
      return;
    }
    setState(() => _sendingBroadcast = true);
    try {
      final res = await _adminSvc.sendBroadcast(
        title: title,
        message: msg,
        targetAudience: _broadcastAudience,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Broadcast alert sent successfully!'), backgroundColor: Colors.green),
        );
        _broadcastTitleCtrl.clear();
        _broadcastMsgCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Failed to send broadcast'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _sendingBroadcast = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _navy)),
      );
    }

    if (!_loggedIn) {
      return _buildLoginView();
    }

    final totalLiveSos = _stats['totalLiveSos'] ?? 0;
    final reportedVideos = _stats['reportedVideos'] ?? 0;
    final unreadMessages = _stats['unreadContactMessages'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _coral,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ADMIN',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Fight D Fear Admin',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (totalLiveSos > 0)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.white, size: 8),
                  const SizedBox(width: 4),
                  Text('SOS: $totalLiveSos', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          if (reportedVideos > 0)
            IconButton(
              icon: Badge(
                label: Text('$reportedVideos'),
                child: const Icon(Icons.flag_rounded, color: Colors.white),
              ),
              tooltip: 'Reported Content',
              onPressed: () => _tabController.animateTo(3),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh',
            onPressed: () {
              _loadDashboardStats();
              _onTabChanged(_tabController.index);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: _coral,
          indicatorWeight: 3,
          tabAlignment: TabAlignment.start,
          tabs: [
            const Tab(icon: Icon(Icons.dashboard_rounded, size: 20), text: 'Overview'),
            const Tab(icon: Icon(Icons.verified_user_rounded, size: 20), text: 'Approvals'),
            Tab(
              icon: Badge(
                isLabelVisible: totalLiveSos > 0,
                label: Text('$totalLiveSos'),
                child: const Icon(Icons.emergency_rounded, size: 20),
              ),
              text: 'SOS Live',
            ),
            Tab(
              icon: Badge(
                isLabelVisible: reportedVideos > 0,
                label: Text('$reportedVideos'),
                child: const Icon(Icons.report_problem_rounded, size: 20),
              ),
              text: 'Moderation',
            ),
            const Tab(icon: Icon(Icons.campaign_rounded, size: 20), text: 'Broadcast'),
            Tab(
              icon: Badge(
                isLabelVisible: unreadMessages > 0,
                label: Text('$unreadMessages'),
                child: const Icon(Icons.mail_rounded, size: 20),
              ),
              text: 'Messages',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildApprovalsTab(),
          _buildSosTab(),
          _buildModerationTab(),
          _buildBroadcastTab(),
          _buildMessagesTab(),
        ],
      ),
    );
  }

  // =========================================================
  // TAB 1: OVERVIEW & ANALYTICS (Matches adminDashboard.jsp)
  // =========================================================

  Widget _buildOverviewTab() {
    if (_loadingStats && _stats.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _navy));
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardStats,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_navy, _navyLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: _navy.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Command Center',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Full real-time system monitoring, partner approvals & safety operations.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. Safety & Emergency
          _sectionHeader('🚨 Safety & Emergency', Icons.emergency_rounded, Colors.red),
          Row(
            children: [
              Expanded(child: _kpiCard('Active SOS Alerts', '${_stats['totalLiveSos'] ?? 0}', Colors.red, Icons.warning_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _kpiCard('Verified Routes', '${_stats['verifiedRoutes'] ?? 0}', Colors.blue, Icons.alt_route_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 2. Verified Partners
          _sectionHeader('👨‍⚕️ Verified Partners & Care', Icons.handshake_rounded, _purple),
          Row(
            children: [
              Expanded(child: _kpiCard('Verified Doctors', '${_stats['verifiedDoctors'] ?? 0}', _purple, Icons.medical_services_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Verified Salons', '${_stats['verifiedSalons'] ?? 0}', Colors.pink, Icons.content_cut_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Stylists', '${_stats['verifiedStylists'] ?? 0}', Colors.purple, Icons.brush_rounded)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _kpiCard('Martial Arts Centres', '${_stats['approvedCentres'] ?? 0}', Colors.indigo, Icons.sports_mma_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Fitness Trainers', '${_stats['verifiedTrainers'] ?? 0}', _teal, Icons.fitness_center_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Fitness Bookings', '${_stats['fitnessBookings'] ?? 0}', _teal, Icons.event_available_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Platform Community
          _sectionHeader('👥 Platform Community', Icons.groups_rounded, Colors.blueGrey),
          Row(
            children: [
              Expanded(child: _kpiCard('Total Users', '${_stats['totalUsers'] ?? 0}', Colors.blueGrey, Icons.people_alt_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('New / Pending', '${_stats['pendingUsers'] ?? 0}', _amber, Icons.person_add_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Banned Accounts', '${_stats['bannedUsers'] ?? 0}', Colors.red, Icons.block_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 4. Entrepreneur & Investor Platform
          _sectionHeader('💼 Startup & Angel Platform', Icons.business_center_rounded, _amber),
          Row(
            children: [
              Expanded(child: _kpiCard('Entrepreneurs', '${_stats['totalEntrepreneurs'] ?? 0}', _amber, Icons.lightbulb_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Investors', '${_stats['totalInvestors'] ?? 0}', _amber, Icons.account_balance_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Pitches / Proposals', '${_stats['totalProposals'] ?? 0}', _amber, Icons.show_chart_rounded)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _kpiCard('Capital Requested', '₹${_formatNum(_stats['capitalRequested'])}', Colors.orange, Icons.request_quote_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Capital Funded', '₹${_formatNum(_stats['capitalInvested'])}', _teal, Icons.volunteer_activism_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Platform Revenue', '₹${_formatNum(_stats['platformRevenue'])}', _purple, Icons.diamond_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 5. Women Events Platform
          _sectionHeader('🌸 Women Events & Tickets', Icons.calendar_month_rounded, Colors.pink),
          Row(
            children: [
              Expanded(child: _kpiCard('Total Events', '${_stats['totalWomenEvents'] ?? 0}', Colors.pink, Icons.event_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Event Bookings', '${_stats['totalEventBookings'] ?? 0}', Colors.pink, Icons.confirmation_number_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Ticket Revenue', '₹${_formatNum(_stats['totalEventRevenue'])}', _teal, Icons.payments_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 6. Creator Hub & Reels
          _sectionHeader('🎥 Creator Hub & Reels', Icons.video_camera_back_rounded, Colors.deepOrange),
          Row(
            children: [
              Expanded(child: _kpiCard('Total Videos', '${_stats['totalVideos'] ?? 0}', Colors.deepOrange, Icons.play_circle_fill_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Pending Cashouts', '${_stats['pendingCashouts'] ?? 0}', _amber, Icons.price_change_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Brand Collabs', '${_stats['brandCollabs'] ?? 0}', Colors.blue, Icons.local_offer_rounded)),
            ],
          ),
          const SizedBox(height: 20),

          // 7. Financial Literacy & Legal / Jobs / Delivery
          _sectionHeader('📚 Marketplace, Jobs & Delivery', Icons.storefront_rounded, _teal),
          Row(
            children: [
              Expanded(child: _kpiCard('Women Lawyers', '${_stats['totalLawyers'] ?? 0}', Colors.indigo, Icons.gavel_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Job Applicants', '${_stats['pendingJobs'] ?? 0}', _teal, Icons.work_outline_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Product Sellers', '${_stats['totalSellers'] ?? 0}', _teal, Icons.shopping_bag_rounded)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _kpiCard('Delivery Partners', '${_stats['totalDelivery'] ?? 0}', Colors.deepOrange, Icons.two_wheeler_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Total Orders', '${_stats['totalOrders'] ?? 0}', _teal, Icons.local_shipping_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _kpiCard('Courses / Videos', '${_stats['totalCourses'] ?? 0}', _purple, Icons.school_rounded)),
            ],
          ),
          const SizedBox(height: 24),

          // Management Modules Quick Action Grid
          _sectionHeader('⚡ Management Modules Quick Access', Icons.apps_rounded, _navy),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: _approvalCategories.map((cat) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat['key'] as String;
                  });
                  _tabController.animateTo(1);
                  _loadApprovals();
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'] as IconData, color: _navy, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        cat['label'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _navy),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Recent Activity Stream
          if (_activities.isNotEmpty) ...[
            _sectionHeader('⚡ Live Platform Activity', Icons.flash_on_rounded, Colors.orange),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activities.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final act = _activities[idx];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.notifications_active_rounded, color: Colors.blue, size: 18),
                    ),
                    title: Text(act['title']?.toString() ?? 'Activity', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text(act['desc']?.toString() ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // TAB 2: APPROVALS & KYC QUEUE (Interactive Actions)
  // =========================================================

  Widget _buildApprovalsTab() {
    return Column(
      children: [
        // Category Horizontal Selector
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _approvalCategories.map((cat) {
                final isSelected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(cat['icon'] as IconData, size: 16, color: isSelected ? Colors.white : _navy),
                    label: Text(cat['label'] as String),
                    selected: isSelected,
                    selectedColor: _navy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => _selectedCategory = cat['key'] as String);
                        _loadApprovals();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Status & Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Column(
            children: [
              Row(
                children: [
                  _statusChip('PENDING', 'Pending'),
                  const SizedBox(width: 8),
                  _statusChip('VERIFIED', 'Verified / Approved'),
                  const SizedBox(width: 8),
                  _statusChip('REJECTED', 'Rejected'),
                  const SizedBox(width: 8),
                  _statusChip('ALL', 'All'),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, specialty, phone...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            _loadApprovals();
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  filled: true,
                  fillColor: const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _loadApprovals(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List View
        Expanded(
          child: _loadingApprovals
              ? const Center(child: CircularProgressIndicator(color: _navy))
              : _approvalItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_rounded, color: Colors.grey.shade400, size: 54),
                          const SizedBox(height: 12),
                          Text(
                            'No items in this queue (${_selectedStatus.toLowerCase()})',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadApprovals,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _approvalItems.length,
                        itemBuilder: (context, idx) {
                          final item = _approvalItems[idx];
                          return _buildApprovalCard(item);
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _statusChip(String key, String label) {
    final isSelected = _selectedStatus == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _selectedStatus = key);
          _loadApprovals();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? _coral : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalCard(Map<String, dynamic> item) {
    final title = item['title']?.toString() ?? 'Unnamed';
    final subtitle = item['subtitle']?.toString() ?? '';
    final email = item['email']?.toString() ?? '';
    final phone = item['phone']?.toString() ?? '';
    final location = item['location']?.toString() ?? '';
    final status = item['status']?.toString() ?? 'PENDING';
    final id = item['id'];
    final category = item['category']?.toString() ?? _selectedCategory;
    final isPending = status == 'PENDING';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isPending ? _amber.withOpacity(0.5) : Colors.grey.shade200,
          width: isPending ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isPending ? _amber.withOpacity(0.2) : _teal.withOpacity(0.2),
                  child: Text(
                    title.isNotEmpty ? title[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isPending ? Colors.orange.shade800 : Colors.green.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _navy)),
                      if (subtitle.isNotEmpty)
                        Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPending
                        ? Colors.amber.shade100
                        : (status == 'VERIFIED' || status == 'APPROVED' ? Colors.green.shade100 : Colors.red.shade100),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isPending
                          ? Colors.amber.shade900
                          : (status == 'VERIFIED' || status == 'APPROVED' ? Colors.green.shade900 : Colors.red.shade900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (email.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(email, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                if (phone.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(phone, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                if (location.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(location, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (isPending) ...[
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => _showRejectDialog(category, id, title),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _teal,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: () => _approveItem(category, id),
                      child: const Text('Approve'),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.info_outline_rounded, size: 16),
                      label: const Text('View Profile Data'),
                      onPressed: () {
                        _showDetailsSheet(item);
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsSheet(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['title']?.toString() ?? 'Profile Details', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 14),
              ...item.entries.map((e) {
                if (e.key == 'photoUrl' || e.value == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text('${e.key}:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      Expanded(
                        child: Text(e.value.toString(), style: const TextStyle(fontSize: 12, color: Colors.black87)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TAB 3: SOS REAL-TIME LIVE MONITOR
  // =========================================================

  Widget _buildSosTab() {
    if (_loadingSos && _sosAlerts.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.red));
    }

    return RefreshIndicator(
      onRefresh: _loadSos,
      child: _sosAlerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 64),
                  const SizedBox(height: 12),
                  const Text('All Clear — No Active SOS Emergencies', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Active emergency alarms will show here live.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sosAlerts.length,
              itemBuilder: (context, idx) {
                final alert = _sosAlerts[idx];
                final isResolved = alert['status'] == 'RESOLVED';
                final mapUrl = alert['mapUrl']?.toString();

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: isResolved ? Colors.grey.shade300 : Colors.red, width: isResolved ? 1 : 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isResolved ? Colors.grey.shade100 : Colors.red.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emergency_rounded,
                                color: isResolved ? Colors.grey : Colors.red,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alert['userName']?.toString() ?? 'Emergency Alert',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy),
                                  ),
                                  Text(
                                    'Phone: ${alert['userPhone'] ?? 'N/A'} • ${alert['time'] ?? ''}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isResolved ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                alert['status']?.toString() ?? 'ACTIVE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isResolved ? Colors.green.shade900 : Colors.red.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            if (mapUrl != null)
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.map_rounded, size: 18),
                                  label: const Text('Open Map GPS'),
                                  onPressed: () async {
                                    final uri = Uri.parse(mapUrl);
                                    if (await canLaunchUrl(uri)) launchUrl(uri);
                                  },
                                ),
                              ),
                            if (!isResolved) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  style: FilledButton.styleFrom(backgroundColor: _teal),
                                  icon: const Icon(Icons.check_rounded, size: 18),
                                  label: const Text('Mark Resolved'),
                                  onPressed: () => _resolveSos(alert['id']),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // =========================================================
  // TAB 4: MODERATION & REPORTED VIDEOS
  // =========================================================

  Widget _buildModerationTab() {
    if (_loadingReports && _reportedVideos.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _navy));
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: _reportedVideos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_rounded, color: Colors.green, size: 64),
                  const SizedBox(height: 12),
                  const Text('No Reported Content', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('All creator videos and community reels are clean.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reportedVideos.length,
              itemBuilder: (context, idx) {
                final report = _reportedVideos[idx];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.flag_rounded, color: Colors.red, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Reported Video: ${report['videoTitle'] ?? 'Untitled'}',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _navy),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Reason: ${report['reason'] ?? 'Violation of community guidelines'}',
                            style: const TextStyle(fontSize: 13, color: Colors.red)),
                        const SizedBox(height: 4),
                        Text('Reported By: ${report['reportedByName'] ?? 'Member'} • Creator: ${report['videoCreator'] ?? 'Unknown'}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _dismissReport(report['id']),
                                child: const Text('Dismiss Report'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // =========================================================
  // TAB 5: BROADCAST CENTER
  // =========================================================

  Widget _buildBroadcastTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Send Platform-Wide Broadcast Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 6),
              Text(
                'Broadcast messages are instantly delivered to all active app users and displayed in their notification center.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _broadcastTitleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Broadcast Title *',
                  hintText: 'e.g. Safety Alert: Emergency Weather Update',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _broadcastMsgCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Broadcast Message *',
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _broadcastAudience,
                decoration: const InputDecoration(
                  labelText: 'Target Audience',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'ALL', child: Text('All Users & Partners')),
                  DropdownMenuItem(value: 'USERS', child: Text('Members Only')),
                  DropdownMenuItem(value: 'DOCTORS', child: Text('Doctors Only')),
                  DropdownMenuItem(value: 'PARTNERS', child: Text('All Partners & Providers')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _broadcastAudience = val);
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: _coral,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _sendingBroadcast ? null : _sendBroadcast,
                  icon: _sendingBroadcast
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded),
                  label: const Text('Send Broadcast Alert'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // TAB 6: CONTACT MESSAGES
  // =========================================================

  Widget _buildMessagesTab() {
    if (_loadingMessages && _contactMessages.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _navy));
    }

    return RefreshIndicator(
      onRefresh: _loadMessages,
      child: _contactMessages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mark_email_read_rounded, color: Colors.green, size: 64),
                  const SizedBox(height: 12),
                  const Text('No Incoming Inquiries', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('All contact form messages have been reviewed.', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contactMessages.length,
              itemBuilder: (context, idx) {
                final msg = _contactMessages[idx];
                final isRead = msg['readByAdmin'] == true;

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: isRead ? Colors.grey.shade200 : _coral.withOpacity(0.5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isRead ? Colors.grey.shade200 : _coral.withOpacity(0.15),
                              child: Icon(Icons.mail_rounded, color: isRead ? Colors.grey : _coral, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['name']?.toString() ?? 'Anonymous',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _navy),
                                  ),
                                  Text(msg['email']?.toString() ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                            if (!isRead)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: _coral, borderRadius: BorderRadius.circular(4)),
                                child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          msg['subject']?.toString() ?? 'General Inquiry',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['message']?.toString() ?? '',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                        ),
                        if (!isRead) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton(
                              onPressed: () async {
                                await _adminSvc.markContactMessageRead(msg['id']);
                                _loadMessages();
                                _loadDashboardStats();
                              },
                              child: const Text('Mark as Read'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // =========================================================
  // LOGIN SCREEN (Fight D Fear Theme)
  // =========================================================

  Widget _buildLoginView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        title: const Text('Admin Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _navy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: _navy.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                  ],
                ),
                child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 54),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fight D Fear Admin',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _navy),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in with your master admin credentials',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),

              if (_authError != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_authError!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                      ),
                    ],
                  ),
                ),

              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Admin Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _navy,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _loginBusy ? null : _handleLogin,
                  child: _loginBusy
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign In as Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.key_rounded, size: 18),
                  label: const Text('Use Default Admin (admin@gmail.com)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _emailCtrl.text = 'admin@gmail.com';
                      _passCtrl.text = 'Admin@123';
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Default Credentials:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _navy),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: admin@gmail.com\nPassword: Admin@123',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_ethernet_rounded, size: 18),
                label: Text(
                  'Server: ${context.watch<AuthState>().apiBaseUrl}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                onPressed: _showServerConfigDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServerConfigDialog() {
    final auth = context.read<AuthState>();
    final controller = TextEditingController(text: auth.apiBaseUrl);
    bool testing = false;
    String? pingResult;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.dns_rounded, color: _navy),
                          SizedBox(width: 8),
                          Text('Backend Server Connection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Select or enter the Spring Boot backend address:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.laptop_chromebook_rounded, size: 16),
                        label: const Text('Laptop Wi-Fi (10.10.100.108:8084)'),
                        onPressed: () {
                          setModalState(() {
                            controller.text = 'http://10.10.100.108:8084';
                            pingResult = null;
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.cloud_done_rounded, size: 16),
                        label: const Text('Cloud (fightdfire.chethancodehub.com)'),
                        onPressed: () {
                          setModalState(() {
                            controller.text = 'https://fightdfire.chethancodehub.com';
                            pingResult = null;
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone_android_rounded, size: 16),
                        label: const Text('Emulator (10.0.2.2:8084)'),
                        onPressed: () {
                          setModalState(() {
                            controller.text = 'http://10.0.2.2:8084';
                            pingResult = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Server URL (with port)',
                      hintText: 'http://10.10.100.108:8084',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (pingResult != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: pingResult!.startsWith('✅') ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: pingResult!.startsWith('✅') ? Colors.green.shade200 : Colors.red.shade200,
                        ),
                      ),
                      child: Text(
                        pingResult!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: pingResult!.startsWith('✅') ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: testing
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.network_check_rounded),
                          label: const Text('Test Ping'),
                          onPressed: testing
                              ? null
                              : () async {
                                  setModalState(() {
                                    testing = true;
                                    pingResult = null;
                                  });
                                  final ok = await auth.pingServer(controller.text.trim());
                                  setModalState(() {
                                    testing = false;
                                    pingResult = ok
                                        ? '✅ Server is Online & Reachable!'
                                        : '❌ Cannot connect to server at this URL.';
                                  });
                                },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('Apply Server'),
                          style: FilledButton.styleFrom(backgroundColor: _navy),
                          onPressed: () async {
                            final target = controller.text.trim();
                            await auth.setServerUrl(target.isEmpty ? null : target);
                            if (mounted) {
                              setState(() {
                                _adminSvc = AdminService(auth.api);
                              });
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Connected to: ${auth.apiBaseUrl}')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Helpers ---

  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _navy, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color),
              ),
              Icon(icon, color: color.withOpacity(0.35), size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatNum(dynamic n) {
    if (n == null) return '0';
    if (n is num) {
      if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
      if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
      return n.toStringAsFixed(0);
    }
    return n.toString();
  }
}
