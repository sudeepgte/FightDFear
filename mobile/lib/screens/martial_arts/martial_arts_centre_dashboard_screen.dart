import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import 'martial_arts_centre_login_screen.dart';

class MartialArtsCentreDashboardScreen extends StatefulWidget {
  const MartialArtsCentreDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentreDashboardScreen> createState() =>
      _MartialArtsCentreDashboardScreenState();
}

class _MartialArtsCentreDashboardScreenState extends State<MartialArtsCentreDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final CentreAuthService _auth;
  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _auth = CentreAuthService(context.read<AuthState>().api);
    _tabs = TabController(length: 6, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _auth.dashboardMeta();
      if (!mounted) return;
      if (res['success'] == true) {
        _data = res;
      } else {
        _error = res['error']?.toString() ?? 'Could not load dashboard';
      }
    } catch (e) {
      if (mounted) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
      (_) => false,
    );
  }

  List<Map<String, dynamic>> _list(String key) {
    final raw = _data?[key];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Map<String, dynamic>? get _centre =>
      _data?['centre'] is Map ? Map<String, dynamic>.from(_data!['centre'] as Map) : null;

  Map<String, dynamic>? get _meta =>
      _data?['meta'] is Map ? Map<String, dynamic>.from(_data!['meta'] as Map) : null;

  String get _managerName => _centre?['managerName']?.toString() ?? 'Centre Manager';

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final notifications = () {
      final m = _meta;
      if (m == null) return <Map<String, dynamic>>[];
      final raw = m['notifications'];
      if (raw is! List) return <Map<String, dynamic>>[];
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }();
    final baseUrl = context.read<AuthState>().api.baseUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: MartialArtsCentreDashboardScreen.navy,
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Centre Hub', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text(
              '${_greeting()}, $_managerName 👋',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ],
        ),
        toolbarHeight: 64,
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showNotifications(notifications),
            icon: Badge(
              isLabelVisible: notifications.isNotEmpty,
              label: Text('${notifications.length > 9 ? '9+' : notifications.length}'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MartialArtsCentreDashboardScreen.primary,
        elevation: 6,
        onPressed: () {
          _tabs.animateTo(1);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create a batch from the Batches tab')),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.home_outlined, Icons.home, 'Home', 0),
              _navItem(1, Icons.groups_outlined, Icons.groups, 'Students', 2),
              _navItem(2, Icons.fitness_center_outlined, Icons.fitness_center, 'Batches', 1),
              const SizedBox(width: 56),
              _navItem(4, Icons.payments_outlined, Icons.payments, 'Finance', 4),
              _navItem(
                3,
                Icons.chat_bubble_outline,
                Icons.chat_bubble,
                'Messages',
                2,
                badge: notifications.isNotEmpty ? '${notifications.length.clamp(1, 9)}' : null,
              ),
              _navItem(5, Icons.person_outline, Icons.person, 'Profile', 5),
            ],
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: _CentreProfileCard(centre: _centre, meta: _meta, baseUrl: baseUrl),
                    ),
                    Material(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabs,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: MartialArtsCentreDashboardScreen.primary,
                        unselectedLabelColor: const Color(0xFF94A3B8),
                        indicatorColor: MartialArtsCentreDashboardScreen.primary,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Batches'),
                          Tab(text: 'Students'),
                          Tab(text: 'Attendance'),
                          Tab(text: 'Finance'),
                          Tab(text: 'More'),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: TabBarView(
                        controller: _tabs,
                        children: [
                          _OverviewTab(
                            meta: _meta,
                            enrollments: _list('enrollments'),
                            batches: _list('batches'),
                            onGoBatches: () => _tabs.animateTo(1),
                            onGoStudents: () => _tabs.animateTo(2),
                            onGoAttendance: () => _tabs.animateTo(3),
                            onGoLive: () => _tabs.animateTo(4),
                            onGoSettings: () => _tabs.animateTo(5),
                          ),
                          _BatchesTab(auth: _auth, batches: _list('batches'), onChanged: _load),
                          _StudentsTab(auth: _auth, students: _list('enrollments'), onChanged: _load),
                          _AttendanceTab(auth: _auth, batches: _list('batches')),
                          _LiveClassesTab(auth: _auth, classes: _list('onlineClasses'), batches: _list('batches'), onChanged: _load),
                          _SettingsTab(auth: _auth, centre: _centre, onSaved: _load),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _navItem(int visualIndex, IconData icon, IconData activeIcon, String label, int tabIndex, {String? badge}) {
    final isSelected = switch (visualIndex) {
      0 => _tabs.index == 0 || _tabs.index == 3,
      1 => _tabs.index == 2,
      2 => _tabs.index == 1,
      4 => _tabs.index == 4,
      3 => false,
      5 => _tabs.index == 5,
      _ => false,
    };
    return Expanded(
      child: InkWell(
        onTap: () {
          if (visualIndex == 3) {
            _tabs.animateTo(2);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Open a student to start messaging')),
            );
          } else {
            _tabs.animateTo(tabIndex);
          }
          setState(() {});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: badge != null,
              label: badge == null ? null : Text(badge),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected ? MartialArtsCentreDashboardScreen.primary : const Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? MartialArtsCentreDashboardScreen.primary : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No notifications yet')),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final n = items[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE4E6),
                          child: Icon(Icons.notifications_outlined, color: MartialArtsCentreDashboardScreen.primary),
                        ),
                        title: Text(n['title']?.toString() ?? 'Update', style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(n['body']?.toString() ?? ''),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

num _metaNum(dynamic v) => v is num ? v : num.tryParse('$v') ?? 0;

String _inr(dynamic v) {
  final n = _metaNum(v).round();
  final s = n.toString();
  if (s.length <= 3) return s;
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
}

List<Map<String, dynamic>> _asMaps(dynamic raw) {
  if (raw is! List) return [];
  return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
}

class _CentreProfileCard extends StatelessWidget {
  const _CentreProfileCard({this.centre, this.meta, required this.baseUrl});
  final Map<String, dynamic>? centre;
  final Map<String, dynamic>? meta;
  final String baseUrl;

  Future<void> _openMaps(BuildContext context) async {
    final url = centre?['mapsUrl']?.toString();
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location not set yet')));
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final name = centre?['name']?.toString() ?? 'Your centre';
    final manager = centre?['managerName']?.toString() ?? 'Centre Manager';
    final phone = centre?['phoneNumber']?.toString() ?? '';
    final locationLabel = centre?['locationLabel']?.toString() ?? centre?['location']?.toString() ?? '';
    final approved = centre?['approved'] == true;
    final photo = centre?['profilePhoto']?.toString() ?? '';
    final photoUrl = photo.isEmpty
        ? ''
        : (photo.startsWith('http') ? photo : '$baseUrl${photo.startsWith('/') ? '' : '/'}$photo');
    final rating = meta?['rating'] ?? 4.8;
    final reviews = _metaNum(meta?['reviewCount'] ?? 128).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: photoUrl.isNotEmpty
                ? Image.network(photoUrl, width: 88, height: 88, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _photoPlaceholder(name))
                : _photoPlaceholder(name),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (approved)
                      _pill(Icons.verified, 'Verified Centre', const Color(0xFF166534), const Color(0xFFDCFCE7)),
                    _pill(Icons.circle, 'Active', const Color(0xFF166534), const Color(0xFFDCFCE7),
                        iconSize: 8),
                  ],
                ),
                const SizedBox(height: 6),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: MartialArtsCentreDashboardScreen.navy)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        locationLabel.isEmpty ? 'Add location' : locationLabel,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _openMaps(context),
                      child: const Text('View on Map',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: MartialArtsCentreDashboardScreen.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Manager: $manager', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                if (phone.isNotEmpty)
                  Text(phone, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 4),
                    Text('$rating', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    Text(' ($reviews reviews)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MartialArtsCentreDashboardScreen.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(String name) {
    return Container(
      width: 88,
      height: 88,
      color: const Color(0xFFFFE4E6),
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? 'C' : name.characters.first.toUpperCase(),
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: MartialArtsCentreDashboardScreen.primary),
      ),
    );
  }

  Widget _pill(IconData icon, String text, Color fg, Color bg, {double iconSize = 12}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: fg),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    this.meta,
    this.enrollments = const [],
    this.batches = const [],
    required this.onGoBatches,
    required this.onGoStudents,
    required this.onGoAttendance,
    required this.onGoLive,
    required this.onGoSettings,
  });

  final Map<String, dynamic>? meta;
  final List<Map<String, dynamic>> enrollments;
  final List<Map<String, dynamic>> batches;
  final VoidCallback onGoBatches;
  final VoidCallback onGoStudents;
  final VoidCallback onGoAttendance;
  final VoidCallback onGoLive;
  final VoidCallback onGoSettings;

  @override
  Widget build(BuildContext context) {
    final todayClasses = _asMaps(meta?['todayClassList']);
    final activities = _asMaps(meta?['recentActivities']);
    final events = _asMaps(meta?['events']);
    final revenue = _asMaps(meta?['revenueSeries']);
    final attendancePct = _metaNum(meta?['attendanceWeek'] ?? meta?['avgAttendance']).toDouble().clamp(0, 100);
    final completion = _metaNum(meta?['profileCompletion']).toDouble().clamp(0, 100);
    final topPrograms = _topPrograms();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.45,
          children: [
            _MetricTile(
              icon: Icons.groups_outlined,
              iconBg: const Color(0xFFFFE4E6),
              iconColor: MartialArtsCentreDashboardScreen.primary,
              value: '${_metaNum(meta?['totalEnrollments']).toInt()}',
              label: 'Students',
              trend: '+${(_metaNum(meta?['totalEnrollments']) * 0.1).round().clamp(1, 99)} this week',
              trendPositive: true,
            ),
            _MetricTile(
              icon: Icons.fitness_center_outlined,
              iconBg: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF9333EA),
              value: '${_metaNum(meta?['activeBatches']).toInt()}',
              label: 'Active Batches',
              trend: '+${_metaNum(meta?['activeBatches']).toInt().clamp(0, 5)} this month',
              trendPositive: true,
            ),
            _MetricTile(
              icon: Icons.sports_martial_arts_outlined,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF2563EB),
              value: '${_metaNum(meta?['trainerCount']).toInt()}',
              label: 'Trainers',
              trend: '+1 this month',
              trendPositive: true,
            ),
            _MetricTile(
              icon: Icons.today_outlined,
              iconBg: const Color(0xFFFFEDD5),
              iconColor: const Color(0xFFEA580C),
              value: '${_metaNum(meta?['todayClasses']).toInt()}',
              label: "Today's Classes",
              linkLabel: 'View schedule',
              onLink: onGoLive,
            ),
            _MetricTile(
              icon: Icons.payments_outlined,
              iconBg: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF16A34A),
              value: '₹${_inr(meta?['monthEarnings'])}',
              label: 'Monthly Earnings',
              trend: '+15% vs last month',
              trendPositive: true,
            ),
            _MetricTile(
              icon: Icons.fact_check_outlined,
              iconBg: const Color(0xFFE0E7FF),
              iconColor: const Color(0xFF4F46E5),
              value: '${attendancePct.round()}%',
              label: 'Attendance (This Week)',
              trend: '+4% vs last week',
              trendPositive: true,
            ),
            _MetricTile(
              icon: Icons.star_outline,
              iconBg: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              value: '${meta?['rating'] ?? 4.8}',
              label: 'Centre Rating',
              linkLabel: '${_metaNum(meta?['reviewCount'] ?? 128).toInt()} reviews',
              onLink: () {},
            ),
            _MetricTile(
              icon: Icons.hourglass_bottom,
              iconBg: const Color(0xFFFFE4E6),
              iconColor: MartialArtsCentreDashboardScreen.primary,
              value: '${_metaNum(meta?['pendingAdmissions']).toInt()}',
              label: 'Pending Admissions',
              linkLabel: 'View details',
              onLink: onGoStudents,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Customize quick actions coming soon')),
                );
              },
              icon: const Icon(Icons.settings_outlined, size: 16),
              label: const Text('Customize'),
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 96,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _CircleAction('Create Batch', Icons.add, MartialArtsCentreDashboardScreen.primary, onGoBatches),
              _CircleAction('Add Trainer', Icons.person_add_alt_1, const Color(0xFF9333EA), onGoSettings),
              _CircleAction('Add Student', Icons.group_add, const Color(0xFF2563EB), onGoStudents),
              _CircleAction('Schedule Class', Icons.event, const Color(0xFF16A34A), onGoLive),
              _CircleAction('Payments', Icons.currency_rupee, const Color(0xFFEA580C), onGoStudents),
              _CircleAction('Announcements', Icons.campaign, MartialArtsCentreDashboardScreen.primary, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Announcements coming soon')),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _whiteCard(
          title: "Today's Classes",
          child: Column(
            children: [
              if (todayClasses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No classes scheduled for today', style: TextStyle(color: Color(0xFF64748B))),
                )
              else
                ...todayClasses.take(4).map((c) => _todayClassRow(c)),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onGoLive,
                style: OutlinedButton.styleFrom(
                  foregroundColor: MartialArtsCentreDashboardScreen.primary,
                  side: const BorderSide(color: MartialArtsCentreDashboardScreen.primary),
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text('View Full Schedule'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Monthly Earnings',
          trailing: Text('₹${_inr(meta?['monthEarnings'])}',
              style: const TextStyle(fontWeight: FontWeight.w800, color: MartialArtsCentreDashboardScreen.primary)),
          child: SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _LineChartPainter(
                values: revenue.map((e) => _metaNum(e['value']).toDouble()).toList(),
                labels: revenue.map((e) => e['label']?.toString() ?? '').toList(),
                color: MartialArtsCentreDashboardScreen.primary,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Recent Activities',
          child: activities.isEmpty
              ? const Text('No recent activity', style: TextStyle(color: Color(0xFF64748B)))
              : Column(
                  children: activities.take(5).map((a) {
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
                              color: MartialArtsCentreDashboardScreen.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['title']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                                Text('${a['body'] ?? ''}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Text(a['time']?.toString() ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Top Programs',
          child: topPrograms.isEmpty
              ? const Text('Create batches to see top programs', style: TextStyle(color: Color(0xFF64748B)))
              : Column(
                  children: topPrograms.map((p) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 44,
                              height: 44,
                              color: const Color(0xFFFFE4E6),
                              child: const Icon(Icons.sports_martial_arts, color: MartialArtsCentreDashboardScreen.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Text('${p['count']} Enrollments',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Attendance Summary',
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: CustomPaint(
                  painter: _DonutPainter(percent: attendancePct / 100, color: MartialArtsCentreDashboardScreen.primary),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${attendancePct.round()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                        const Text('Attendance', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend(const Color(0xFF22C55E), 'Present', '${attendancePct.round()}%'),
                    _legend(const Color(0xFFEF4444), 'Absent', '${(100 - attendancePct).clamp(0, 100).round() ~/ 2}%'),
                    _legend(const Color(0xFFFBBF24), 'Leave', '${(100 - attendancePct).clamp(0, 100).round() ~/ 2}%'),
                    TextButton(onPressed: onGoAttendance, child: const Text('Open attendance')),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Upcoming Events',
          child: events.isEmpty
              ? const Text('Schedule live classes to show upcoming events', style: TextStyle(color: Color(0xFF64748B)))
              : Column(
                  children: events.take(4).map((e) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.event, color: MartialArtsCentreDashboardScreen.primary),
                      ),
                      title: Text(e['title']?.toString() ?? 'Event', style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${e['date'] ?? ''} · ${e['time'] ?? ''}'),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Pending Approvals',
          child: Column(
            children: [
              _approvalRow(Icons.person_outline, '${_metaNum(meta?['trainerCount']) == 0 ? 0 : 0} Trainers', onGoSettings),
              _approvalRow(Icons.school_outlined, '${_metaNum(meta?['pendingAdmissions']).toInt()} Students', onGoStudents),
              _approvalRow(Icons.workspace_premium_outlined, '1 Certificate', onGoStudents),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _whiteCard(
          title: 'Centre Profile Completion',
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: CustomPaint(
                  painter: _DonutPainter(percent: completion / 100, color: MartialArtsCentreDashboardScreen.primary, stroke: 10),
                  child: Center(
                    child: Text('${completion.round()}%', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _checkItem('Basic Details', true),
                    _checkItem('Programs', meta?['hasPrograms'] == true),
                    _checkItem('Gallery', meta?['hasGallery'] == true),
                    _checkItem('Documents', meta?['hasDetails'] == true),
                    _checkItem('Add More Photos', meta?['hasGallery'] == true, muted: meta?['hasGallery'] != true),
                    TextButton(onPressed: onGoSettings, child: const Text('Complete profile')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> _topPrograms() {
    final counts = <String, int>{};
    for (final e in enrollments) {
      final name = e['batchName']?.toString() ?? e['style']?.toString() ?? 'Program';
      counts[name] = (counts[name] ?? 0) + 1;
    }
    if (counts.isEmpty) {
      for (final b in batches) {
        final name = b['name']?.toString() ?? b['style']?.toString() ?? 'Program';
        counts[name] = (counts[name] ?? 0) + _metaNum(b['enrolledCount']).toInt().clamp(0, 999);
      }
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => {'name': e.key, 'count': '${e.value}'}).toList();
  }

  Widget _todayClassRow(Map<String, dynamic> c) {
    final status = (c['status']?.toString() ?? 'UPCOMING').toUpperCase();
    final ongoing = status.contains('LIVE') || status.contains('ONGOING');
    final enrolled = _metaNum(c['studentCount'] ?? c['enrolled']).toInt();
    final capacity = _metaNum(c['capacity'] ?? 30).toInt();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        c['name']?.toString() ?? c['title']?.toString() ?? 'Class',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ongoing ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        ongoing ? 'Ongoing' : 'Upcoming',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: ongoing ? const Color(0xFF166534) : const Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    c['timeSlot'] ?? '${c['startTime'] ?? ''}–${c['endTime'] ?? ''}',
                    if (c['instructor'] != null) 'Trainer: ${c['instructor']}',
                  ].where((e) => e.toString().trim().isNotEmpty).join(' · '),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Text('$enrolled/$capacity Students', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _whiteCard({required String title, Widget? trailing, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _legend(Color c, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _approvalRow(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFFFFE4E6),
        child: Icon(icon, size: 16, color: MartialArtsCentreDashboardScreen.primary),
      ),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _checkItem(String label, bool done, {bool muted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16, color: done ? const Color(0xFF22C55E) : const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: muted ? MartialArtsCentreDashboardScreen.primary : const Color(0xFF475569),
                fontWeight: muted ? FontWeight.w700 : FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    this.trend,
    this.trendPositive = false,
    this.linkLabel,
    this.onLink,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;
  final String? trend;
  final bool trendPositive;
  final String? linkLabel;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: MartialArtsCentreDashboardScreen.navy)),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          if (trend != null)
            Text(trend!,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: trendPositive ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                )),
          if (linkLabel != null)
            GestureDetector(
              onTap: onLink,
              child: Text(linkLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: MartialArtsCentreDashboardScreen.primary,
                  )),
            ),
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
              Text(label, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values, required this.labels, required this.color});
  final List<double> values;
  final List<String> labels;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);
    final chartH = size.height - 24;
    final chartW = size.width;
    final pts = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1 ? chartW / 2 : chartW * i / (values.length - 1);
      final y = chartH - (values[i] / maxV) * (chartH - 8);
      pts.add(Offset(x, y));
    }
    final fillPath = Path()..moveTo(pts.first.dx, chartH);
    for (final p in pts) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath
      ..lineTo(pts.last.dx, chartH)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.02)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      line.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(line, Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round);
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < labels.length; i++) {
      tp.text = TextSpan(text: labels[i], style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)));
      tp.layout();
      final x = values.length == 1 ? chartW / 2 : chartW * i / (values.length - 1);
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 14));
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.percent, required this.color, this.stroke = 12});
  final double percent;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = (size.shortestSide - stroke) / 2;
    final bg = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, bg);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -1.5708, 6.2832 * percent.clamp(0, 1), false, fg);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}

class _BatchesTab extends StatefulWidget {
  const _BatchesTab({required this.auth, required this.batches, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> batches;
  final VoidCallback onChanged;

  @override
  State<_BatchesTab> createState() => _BatchesTabState();
}

class _BatchesTabState extends State<_BatchesTab> {
  static const _dayChips = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _programs = ['Karate', 'Yoga', 'Fitness', 'Self-Defence', 'Taekwondo', 'Other'];

  Future<void> _pickTime(TextEditingController ctrl) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked != null) {
      ctrl.text = picked.format(context);
    }
  }

  Future<void> _showBatchForm([Map<String, dynamic>? existing]) async {
    final nameCtrl = TextEditingController(text: existing?['name']?.toString() ?? '');
    final instructorCtrl = TextEditingController(text: existing?['instructor']?.toString() ?? '');
    final startTimeCtrl = TextEditingController(
      text: (existing?['timeSlot']?.toString() ?? '6:00 PM').split('-').first.trim(),
    );
    final endTimeCtrl = TextEditingController(
      text: (existing?['timeSlot']?.toString() ?? '6:00 PM-7:00 PM').contains('-')
          ? existing!['timeSlot'].toString().split('-').last.trim()
          : '7:00 PM',
    );
    final feeCtrl = TextEditingController(text: '${existing?['fee'] ?? 0}');
    final capacityCtrl = TextEditingController(text: '${existing?['capacity'] ?? 20}');
    final notesCtrl = TextEditingController(text: existing?['notes']?.toString() ?? '');
    final startDateCtrl = TextEditingController(text: existing?['startDate']?.toString() ?? '');
    final endDateCtrl = TextEditingController(text: existing?['endDate']?.toString() ?? '');
    final batchCode = existing?['batchCode']?.toString() ??
        'BAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    String program = existing?['style']?.toString() ?? _programs.first;
    if (!_programs.contains(program)) program = 'Other';
    String batchType = existing?['batchType']?.toString() ?? 'Offline';
    String status = existing?['status']?.toString() ?? 'Active';
    final selectedDays = <String>{
      ...(existing?['availableDays']?.toString() ?? 'Mon,Tue,Wed,Thu,Fri')
          .split(RegExp(r'[,/ ]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) {
            final u = e.toUpperCase();
            if (u.startsWith('MON')) return 'Mon';
            if (u.startsWith('TUE')) return 'Tue';
            if (u.startsWith('WED')) return 'Wed';
            if (u.startsWith('THU')) return 'Thu';
            if (u.startsWith('FRI')) return 'Fri';
            if (u.startsWith('SAT')) return 'Sat';
            if (u.startsWith('SUN')) return 'Sun';
            return e;
          }),
    };
    final id = existing?['id'];
    String? formError;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          final canSave = nameCtrl.text.trim().isNotEmpty &&
              selectedDays.isNotEmpty &&
              startTimeCtrl.text.trim().isNotEmpty &&
              endTimeCtrl.text.trim().isNotEmpty &&
              (int.tryParse(capacityCtrl.text.trim()) ?? 0) >= 5 &&
              (int.tryParse(capacityCtrl.text.trim()) ?? 0) <= 100 &&
              (double.tryParse(feeCtrl.text.trim()) ?? -1) >= 0;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    existing == null ? 'Create batch' : 'Edit batch',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Batch name *', border: OutlineInputBorder()),
                    onChanged: (_) => setLocal(() {}),
                  ),
                  const SizedBox(height: 8),
                  InputDecorator(
                    decoration: const InputDecoration(labelText: 'Batch code', border: OutlineInputBorder()),
                    child: Text(batchCode, style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: program,
                    decoration: const InputDecoration(labelText: 'Program *', border: OutlineInputBorder()),
                    items: _programs.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setLocal(() => program = v ?? program),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: instructorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Instructor',
                      hintText: 'Select / type trainer name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Days *', style: TextStyle(fontWeight: FontWeight.w600)),
                  Wrap(
                    spacing: 6,
                    children: _dayChips.map((d) {
                      final on = selectedDays.contains(d);
                      return FilterChip(
                        label: Text(d),
                        selected: on,
                        onSelected: (v) => setLocal(() {
                          if (v) {
                            selectedDays.add(d);
                          } else {
                            selectedDays.remove(d);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startTimeCtrl,
                          readOnly: true,
                          onTap: () async {
                            await _pickTime(startTimeCtrl);
                            setLocal(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: 'Start time *',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.schedule),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: endTimeCtrl,
                          readOnly: true,
                          onTap: () async {
                            await _pickTime(endTimeCtrl);
                            setLocal(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: 'End time *',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.schedule),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startDateCtrl,
                          readOnly: true,
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            if (d != null) {
                              startDateCtrl.text =
                                  '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                              setLocal(() {});
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Start date',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: endDateCtrl,
                          readOnly: true,
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                            );
                            if (d != null) {
                              endDateCtrl.text =
                                  '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                              setLocal(() {});
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'End date',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: feeCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setLocal(() {}),
                    decoration: const InputDecoration(labelText: 'Fee (₹) *', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: capacityCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setLocal(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Maximum capacity (5–100) *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InputDecorator(
                    decoration: InputDecoration(labelText: 'Current enrollment', border: OutlineInputBorder()),
                    child: Text('0 (read-only)'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: batchType,
                    decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                      DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
                    ],
                    onChanged: (v) => setLocal(() => batchType = v ?? batchType),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(value: 'Upcoming', child: Text('Upcoming')),
                      DropdownMenuItem(value: 'Full', child: Text('Full')),
                      DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                    ],
                    onChanged: (v) => setLocal(() => status = v ?? status),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description / notes', border: OutlineInputBorder()),
                  ),
                  if (formError != null) ...[
                    const SizedBox(height: 8),
                    Text(formError!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: !canSave
                        ? null
                        : () async {
                            final capacity = int.tryParse(capacityCtrl.text.trim()) ?? 0;
                            final fee = double.tryParse(feeCtrl.text.trim()) ?? -1;
                            if (capacity < 5 || capacity > 100) {
                              setLocal(() => formError = 'Capacity must be between 5 and 100.');
                              return;
                            }
                            if (fee < 0) {
                              setLocal(() => formError = 'Fee must be 0 or greater.');
                              return;
                            }
                            final body = <String, dynamic>{
                              if (id != null) 'id': id,
                              'name': nameCtrl.text.trim(),
                              'style': program,
                              'instructor': instructorCtrl.text.trim(),
                              'availableDays': selectedDays.join(','),
                              'timeSlot': '${startTimeCtrl.text.trim()}-${endTimeCtrl.text.trim()}',
                              'fee': fee,
                              'capacity': capacity,
                              'batchType': batchType,
                              'status': status,
                              'batchCode': batchCode,
                              'startDate': startDateCtrl.text.trim(),
                              'endDate': endDateCtrl.text.trim(),
                              'notes': notesCtrl.text.trim(),
                              'currentEnrollment': existing?['currentEnrollment'] ?? 0,
                            };
                            final res = await widget.auth.saveBatch(body);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['success'] == true
                                      ? 'Batch created successfully.'
                                      : (res['message']?.toString() ?? 'Failed'),
                                ),
                              ),
                            );
                            if (res['success'] == true) widget.onChanged();
                          },
                    style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
                    child: const Text('Save batch'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batches = widget.batches.where((b) => b['isBatch'] != false).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showBatchForm(),
              icon: const Icon(Icons.add),
              label: const Text('Create batch'),
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
            ),
          ),
        ),
        Expanded(
          child: batches.isEmpty
              ? const Center(child: Text('No batches yet'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: batches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final b = batches[i];
                    final bid = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                    return Card(
                      child: ListTile(
                        title: Text(b['name']?.toString() ?? 'Batch'),
                        subtitle: Text('${b['style'] ?? ''} · ${b['status'] ?? ''} · ₹${b['fee'] ?? 0}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (v == 'edit') {
                              await _showBatchForm(b);
                            } else if (v == 'delete' && bid != null) {
                              final res = await widget.auth.deleteBatch(bid);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(res['message']?.toString() ?? 'Done')),
                                );
                                if (res['success'] == true) widget.onChanged();
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _StudentsTab extends StatefulWidget {
  const _StudentsTab({required this.auth, required this.students, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> students;
  final VoidCallback onChanged;

  @override
  State<_StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<_StudentsTab> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final students = widget.students.where((s) {
      if (q.isEmpty) return true;
      final name = (s['traineeName']?.toString() ?? '').toLowerCase();
      final batch = (s['batchName']?.toString() ?? '').toLowerCase();
      return name.contains(q) || batch.contains(q);
    }).toList();

    if (widget.students.isEmpty) {
      return const Center(child: Text('No students yet'));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search students or batch',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: students.isEmpty
              ? const Center(child: Text('No matches'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final s = students[i];
                    final eid = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
                    final status = s['enrollmentStatus']?.toString() ?? 'PENDING';
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['traineeName']?.toString() ?? 'Student', style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('${s['batchName'] ?? ''} · $status · ${s['paymentStatus'] ?? ''}'),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: ['APPROVED', 'IN_PROGRESS', 'COMPLETED', 'REJECTED'].map((st) {
                                return ActionChip(
                                  label: Text(st),
                                  onPressed: eid == null
                                      ? null
                                      : () async {
                                          final res = await widget.auth.updateStudentStatus(eid, st);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(res['message']?.toString() ?? 'Updated')),
                                            );
                                            if (res['success'] == true) widget.onChanged();
                                          }
                                        },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _AttendanceTab extends StatefulWidget {
  const _AttendanceTab({required this.auth, required this.batches});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> batches;

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  String _date = DateTime.now().toIso8601String().substring(0, 10);
  List<Map<String, dynamic>> _sessions = [];
  Map<String, dynamic>? _selected;
  List<Map<String, dynamic>> _trainees = [];
  bool _busy = false;

  Future<void> _loadSessions() async {
    setState(() => _busy = true);
    final res = await widget.auth.attendanceSessions(date: _date);
    if (!mounted) return;
    final batches = (res['batches'] is List) ? res['batches'] as List : [];
    final classes = (res['classes'] is List) ? res['classes'] as List : [];
    _sessions = [
      ...batches.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      ...classes.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
    ];
    setState(() => _busy = false);
  }

  Future<void> _loadTrainees() async {
    if (_selected == null) return;
    setState(() => _busy = true);
    final id = _selected!['id'] is int ? _selected!['id'] as int : int.tryParse('${_selected!['id']}');
    if (id == null) return;
    final res = await widget.auth.attendanceTrainees(
      type: _selected!['type']?.toString() ?? 'BATCH',
      id: id,
      date: _date,
    );
    if (!mounted) return;
    _trainees = (res['trainees'] is List)
        ? (res['trainees'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
    setState(() => _busy = false);
  }

  Future<void> _save() async {
    if (_selected == null) return;
    final id = _selected!['id'] is int ? _selected!['id'] as int : int.tryParse('${_selected!['id']}');
    if (id == null) return;
    final res = await widget.auth.saveAttendance({
      'type': _selected!['type']?.toString() ?? 'BATCH',
      'id': id,
      'date': _date,
      'trainees': _trainees.map((t) => {
            'userId': t['userId'],
            'status': t['status'] ?? 'PRESENT',
            'notes': t['notes'] ?? '',
          }).toList(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', border: OutlineInputBorder()),
                  controller: TextEditingController(text: _date),
                  onSubmitted: (v) {
                    _date = v.trim();
                    _loadSessions();
                  },
                ),
              ),
              IconButton(onPressed: _loadSessions, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        if (_busy) const LinearProgressIndicator(),
        Expanded(
          flex: 2,
          child: ListView(
            children: _sessions.map((s) {
              return ListTile(
                selected: _selected?['id'] == s['id'],
                title: Text(s['name']?.toString() ?? ''),
                subtitle: Text('${s['time'] ?? ''} · ${s['type'] ?? ''}'),
                onTap: () {
                  setState(() => _selected = s);
                  _loadTrainees();
                },
              );
            }).toList(),
          ),
        ),
        if (_trainees.isNotEmpty) ...[
          const Divider(),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _trainees.length,
              itemBuilder: (_, i) {
                final t = _trainees[i];
                return ListTile(
                  title: Text(t['name']?.toString() ?? ''),
                  subtitle: DropdownButton<String>(
                    value: (t['status']?.toString() ?? 'PENDING').replaceAll(' ', '_'),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                      DropdownMenuItem(value: 'PRESENT', child: Text('Present')),
                      DropdownMenuItem(value: 'ABSENT', child: Text('Absent')),
                      DropdownMenuItem(value: 'LATE', child: Text('Late')),
                    ],
                    onChanged: (v) => setState(() => _trainees[i]['status'] = v),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
              child: const Text('Save attendance'),
            ),
          ),
        ],
      ],
    );
  }
}

class _LiveClassesTab extends StatefulWidget {
  const _LiveClassesTab({required this.auth, required this.classes, required this.batches, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> classes;
  final List<Map<String, dynamic>> batches;
  final VoidCallback onChanged;

  @override
  State<_LiveClassesTab> createState() => _LiveClassesTabState();
}

class _LiveClassesTabState extends State<_LiveClassesTab> {
  Future<void> _createClass() async {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final startCtrl = TextEditingController(text: '10:00');
    final endCtrl = TextEditingController(text: '11:00');
    final linkCtrl = TextEditingController();
    int? batchId = widget.batches.isNotEmpty
        ? (widget.batches.first['id'] is int
            ? widget.batches.first['id'] as int
            : int.tryParse('${widget.batches.first['id']}'))
        : null;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schedule live class'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date')),
              TextField(controller: startCtrl, decoration: const InputDecoration(labelText: 'Start time')),
              TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'End time')),
              TextField(controller: linkCtrl, decoration: const InputDecoration(labelText: 'Meeting link')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (batchId == null) return;
              final res = await widget.auth.createOnlineClass({
                'title': titleCtrl.text.trim(),
                'martialArtType': 'Martial Arts',
                'date': dateCtrl.text.trim(),
                'startTime': startCtrl.text.trim(),
                'endTime': endCtrl.text.trim(),
                'meetingLink': linkCtrl.text.trim(),
                'maxStudents': 30,
                'description': '',
                'sessionType': 'Group Session',
                'notes': '',
                'batchId': batchId,
              });
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(res['message']?.toString() ?? 'Done')),
              );
              if (res['success'] == true) widget.onChanged();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _createClass,
              icon: const Icon(Icons.video_call),
              label: const Text('Schedule class'),
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
            ),
          ),
        ),
        Expanded(
          child: widget.classes.isEmpty
              ? const Center(child: Text('No live classes'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.classes.length,
                  itemBuilder: (_, i) {
                    final c = widget.classes[i];
                    final cid = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
                    return Card(
                      child: ListTile(
                        title: Text(c['title']?.toString() ?? c['name']?.toString() ?? 'Class'),
                        subtitle: Text('${c['date'] ?? ''} · ${c['status'] ?? ''}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (cid == null) return;
                            Map<String, dynamic> res;
                            if (v == 'start') {
                              res = await widget.auth.startOnlineClass(cid);
                              final link = res['meetingLink']?.toString();
                              if (link != null && link.isNotEmpty) {
                                await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                              }
                            } else if (v == 'end') {
                              res = await widget.auth.endOnlineClass(cid);
                            } else {
                              res = await widget.auth.deleteOnlineClass(cid);
                            }
                            if (context.mounted && res['success'] == true) widget.onChanged();
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'start', child: Text('Start')),
                            PopupMenuItem(value: 'end', child: Text('End')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatefulWidget {
  const _SettingsTab({required this.auth, this.centre, required this.onSaved});
  final CentreAuthService auth;
  final Map<String, dynamic>? centre;
  final VoidCallback onSaved;

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _aboutCtrl;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.centre?['name']?.toString() ?? '');
    _emailCtrl = TextEditingController(text: widget.centre?['email']?.toString() ?? '');
    _phoneCtrl = TextEditingController(text: widget.centre?['phoneNumber']?.toString() ?? '');
    _locationCtrl = TextEditingController(text: widget.centre?['location']?.toString() ?? '');
    _aboutCtrl = TextEditingController(text: widget.centre?['about']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _save({XFile? profile, List<XFile> gallery = const []}) async {
    setState(() => _busy = true);
    final files = <http.MultipartFile>[];
    if (profile != null) {
      files.add(await http.MultipartFile.fromPath('profileImage', profile.path));
    }
    for (final g in gallery) {
      files.add(await http.MultipartFile.fromPath('galleryPhotos', g.path));
    }
    final res = await widget.auth.updateSettings(
      fields: {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phoneNumber': _phoneCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'about': _aboutCtrl.text.trim(),
      },
      files: files,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
    );
    if (res['success'] == true) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _locationCtrl, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _aboutCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'About', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final img = await picker.pickImage(source: ImageSource.gallery);
            if (img != null) await _save(profile: img);
          },
          icon: const Icon(Icons.photo),
          label: const Text('Update profile photo'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final imgs = await picker.pickMultiImage();
            if (imgs.isNotEmpty) await _save(gallery: imgs);
          },
          icon: const Icon(Icons.collections),
          label: const Text('Add gallery photos'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : () => _save(),
          style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
          child: _busy ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save settings'),
        ),
      ],
    );
  }
}
