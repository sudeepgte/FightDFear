import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/marketplace_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../landing/landing_screen.dart';
import 'marketplace_booking_chat_screen.dart';
import 'marketplace_provider_profile_completion_screen.dart';

class MarketplaceProviderDashboardScreen extends StatefulWidget {
  const MarketplaceProviderDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color softBg = Color(0xFFF7F8FA);
  static const Color muted = Color(0xFF64748B);

  @override
  State<MarketplaceProviderDashboardScreen> createState() =>
      _MarketplaceProviderDashboardScreenState();
}

class _MarketplaceProviderDashboardScreenState
    extends State<MarketplaceProviderDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  bool _busy = false;
  int? _busyBookingId;
  String? _error;
  Map<String, dynamic> _provider = {};
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _enrollments = [];
  double _earnings = 0;
  bool _canCreateClass = false;

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
      final api = MarketplaceProviderAuthService(context.read<AuthState>().api);
      final res = await api.dashboard();
      if (res['success'] == true) {
        _provider = Map<String, dynamic>.from(res['provider'] ?? {});
        _bookings = ModuleTheme.toList(res['bookings']);
        _classes = ModuleTheme.toList(res['classes']);
        _enrollments = ModuleTheme.toList(res['enrollments']);
        _earnings = (res['totalEarnings'] is num)
            ? (res['totalEarnings'] as num).toDouble()
            : 0;
        _canCreateClass = res['canCreateClass'] == true ||
            _provider['canCreateClass'] == true ||
            (_provider['partnerProfileStatus']?.toString() == 'APPROVED');
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

  Future<void> _updateBookingStatus(int id, String status) async {
    if (_busyBookingId != null) return;
    setState(() => _busyBookingId = id);
    final api = MarketplaceProviderAuthService(context.read<AuthState>().api);
    final res = await api.updateBookingStatus(id, status);
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

  bool get _approved {
    final s = _provider['partnerProfileStatus']?.toString() ?? '';
    return _canCreateClass || s == 'APPROVED';
  }

  String get _statusLabel =>
      _provider['partnerProfileStatusLabel']?.toString() ??
      (_approved ? 'Approved' : 'Pending verification');

  int get _profilePct {
    final v = _provider['profileCompletionPct'];
    if (v is num) return v.round();
    return int.tryParse('$v') ?? 0;
  }

  Future<void> _addClass() async {
    if (!_approved) {
      _toast('Add Class is available after admin approval.');
      return;
    }
    if (_busy) return;

    final name = TextEditingController();
    final desc = TextEditingController();
    final duration = TextEditingController(text: '60 min');
    final price = TextEditingController(text: '0');
    final seats = TextEditingController(text: '20');
    final link = TextEditingController();
    DateTime? pickedDate;
    TimeOfDay? pickedTime;
    var mode = 'Live';
    String? formError;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: const Text('Add Class / Service'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (formError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(formError!, style: const TextStyle(color: Colors.red)),
                    ),
                  TextField(controller: name, decoration: const InputDecoration(labelText: 'Class name *')),
                  TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
                  TextField(controller: duration, decoration: const InputDecoration(labelText: 'Duration')),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: pickedDate ?? DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (d != null) setLocal(() => pickedDate = d);
                          },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date *', suffixIcon: Icon(Icons.calendar_today_outlined)),
                      child: Text(pickedDate == null
                          ? 'Select date'
                          : '${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                            final t = await showTimePicker(
                              context: ctx,
                              initialTime: pickedTime ?? const TimeOfDay(hour: 10, minute: 0),
                            );
                            if (t != null) setLocal(() => pickedTime = t);
                          },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Time *', suffixIcon: Icon(Icons.schedule)),
                      child: Text(pickedTime == null ? 'Select time' : pickedTime!.format(ctx)),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: mode,
                    decoration: const InputDecoration(labelText: 'Mode'),
                    items: const [
                      DropdownMenuItem(value: 'Live', child: Text('Live')),
                      DropdownMenuItem(value: 'Online', child: Text('Online')),
                      DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                    ],
                    onChanged: (v) => setLocal(() => mode = v ?? mode),
                  ),
                  TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (₹) *'),
                  ),
                  TextField(
                    controller: seats,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Seats *'),
                  ),
                  TextField(controller: link, decoration: const InputDecoration(labelText: 'Meeting link')),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: MarketplaceProviderDashboardScreen.primary),
                onPressed: () {
                        if (name.text.trim().isEmpty) {
                          setLocal(() => formError = 'Enter a class name.');
                          return;
                        }
                        if (pickedDate == null || pickedTime == null) {
                          setLocal(() => formError = 'Pick a date and time.');
                          return;
                        }
                        final p = double.tryParse(price.text.trim());
                        if (p == null || p < 0) {
                          setLocal(() => formError = 'Enter a valid price (0 or more).');
                          return;
                        }
                        final s = int.tryParse(seats.text.trim());
                        if (s == null || s <= 0) {
                          setLocal(() => formError = 'Seats must be greater than zero.');
                          return;
                        }
                        final dt = DateTime(
                          pickedDate!.year,
                          pickedDate!.month,
                          pickedDate!.day,
                          pickedTime!.hour,
                          pickedTime!.minute,
                        );
                        if (dt.isBefore(DateTime.now())) {
                          setLocal(() => formError = 'Date/time cannot be in the past.');
                          return;
                        }
                        Navigator.pop(ctx, true);
                      },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}T${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    final payloadOk = ok == true && pickedDate != null && pickedTime != null;
    final dateTime = payloadOk
        ? DateTime(pickedDate!.year, pickedDate!.month, pickedDate!.day, pickedTime!.hour, pickedTime!.minute)
        : null;
    final className = name.text.trim();
    final description = desc.text.trim();
    final durationText = duration.text.trim();
    final priceVal = double.tryParse(price.text.trim()) ?? 0.0;
    final seatsVal = int.tryParse(seats.text.trim()) ?? 0;
    final meetingLink = link.text.trim();
    final modeVal = mode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in [name, desc, duration, price, seats, link]) {
        c.dispose();
      }
    });

    if (!payloadOk || dateTime == null || !mounted) return;
    setState(() => _busy = true);
    final api = MarketplaceProviderAuthService(context.read<AuthState>().api);
    final res = await api.addClass({
      'className': className,
      'description': description,
      'duration': durationText,
      'dateTime': fmt(dateTime),
      'mode': modeVal,
      'price': priceVal,
      'availableSeats': seatsVal,
      'meetingLink': meetingLink,
    });
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Class added'
            : (res['error']?.toString() ?? 'Could not add class')),
      ),
    );
    if (res['success'] == true) _load();
  }

  String get _name => _provider['fullName']?.toString() ?? 'Partner';
  String get _firstName {
    final parts = _name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? 'Partner' : parts.first;
  }

  String get _category => MarketplaceCatalog.labelFor(_provider['category']?.toString());
  String get _location => _provider['locationText']?.toString() ?? 'Location not set';
  String get _phone => _provider['phone']?.toString() ?? '';
  double get _rating => (_provider['rating'] is num) ? (_provider['rating'] as num).toDouble() : 0;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  List<Map<String, dynamic>> get _pendingBookings => _bookings
      .where((b) {
        final s = (b['status']?.toString() ?? 'PENDING').toUpperCase();
        return s == 'PENDING' || s == 'REQUESTED';
      })
      .toList();

  List<Map<String, dynamic>> get _upcomingBookings => _bookings.take(5).toList();

  int get _completedJobs => _bookings
      .where((b) => (b['status']?.toString() ?? '').toUpperCase() == 'COMPLETED')
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MarketplaceProviderDashboardScreen.softBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _approved
            ? MarketplaceProviderDashboardScreen.primary
            : const Color(0xFF94A3B8),
        elevation: 6,
        onPressed: _addClass,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 12,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
              _navItem(1, Icons.event_note_outlined, Icons.event_note, 'Bookings'),
              const SizedBox(width: 56),
              _navItem(2, Icons.chat_bubble_outline, Icons.chat_bubble, 'Messages', badge: 0),
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
                      _messagesTab(),
                      _profileTab(),
                    ],
                  ),
                ),
    );
  }

  Widget _navItem(int index, IconData outline, IconData filled, String label, {int badge = 0}) {
    final active = _tab == index;
    final color = active
        ? MarketplaceProviderDashboardScreen.primary
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
                        color: MarketplaceProviderDashboardScreen.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
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
      color: MarketplaceProviderDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          _topBar(),
          const SizedBox(height: 14),
          _profileHeroCard(),
          const SizedBox(height: 14),
          _statsGrid(),
          const SizedBox(height: 16),
          _sectionTitle('Quick Actions'),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 18),
          _sectionTitle('Upcoming Bookings', action: 'View all', onAction: () => setState(() => _tab = 1)),
          const SizedBox(height: 10),
          if (_upcomingBookings.isEmpty)
            _emptyCard('No bookings yet. New client requests will appear here.')
          else
            ..._upcomingBookings.map(_bookingCard),
          const SizedBox(height: 16),
          _sectionTitle("Today's Schedule"),
          const SizedBox(height: 10),
          _scheduleCard(),
          const SizedBox(height: 16),
          _earningsAndWalletRow(),
          const SizedBox(height: 16),
          _sectionTitle('New Requests'),
          const SizedBox(height: 10),
          _requestsCard(),
          const SizedBox(height: 16),
          _referBanner(),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Menu coming soon')),
          ),
          icon: const Icon(Icons.menu_rounded, color: MarketplaceProviderDashboardScreen.navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $_firstName! 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: MarketplaceProviderDashboardScreen.navy,
                ),
              ),
              const Text(
                "Here's what's happening with your business today.",
                style: TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted),
              ),
            ],
          ),
        ),
        _iconBadge(Icons.notifications_none_rounded, 0),
        const SizedBox(width: 4),
        _iconBadge(Icons.chat_bubble_outline_rounded, 0),
      ],
    );
  }

  Widget _iconBadge(IconData icon, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => setState(() => _tab = 2),
          icon: Icon(icon, color: MarketplaceProviderDashboardScreen.navy),
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: MarketplaceProviderDashboardScreen.primary,
                shape: BoxShape.circle,
              ),
              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  Widget _profileHeroCard() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'P';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: MarketplaceProviderDashboardScreen.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: MarketplaceProviderDashboardScreen.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: MarketplaceProviderDashboardScreen.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 2),
                        Text(
                          _rating > 0 ? _rating.toStringAsFixed(1) : 'New',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: MarketplaceProviderDashboardScreen.muted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            _location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!_approved)
                Expanded(
                  child: Text(
                    'Complete your profile and wait for admin approval before adding classes.',
                    style: TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted),
                  ),
                )
              else
                const Spacer(),
              Text(
                '${_classes.length} services',
                style: const TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _metaStat('Category', _category),
              _metaStat('Status', _approved ? 'Live' : 'Review'),
              _metaStat('Profile', '$_profilePct%'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_profilePct.clamp(0, 100)) / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFFCE7F3),
              color: MarketplaceProviderDashboardScreen.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: MarketplaceProviderDashboardScreen.muted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    final items = [
      _StatItem(Icons.account_balance_wallet_outlined, 'Paid earnings', '₹${_earnings.toStringAsFixed(0)}', const Color(0xFFFCE7F3)),
      _StatItem(Icons.calendar_today_outlined, 'Bookings', '${_bookings.length}', const Color(0xFFE0E7FF)),
      _StatItem(Icons.star_outline_rounded, 'Rating', _rating > 0 ? _rating.toStringAsFixed(1) : 'New', const Color(0xFFFEF3C7)),
      _StatItem(Icons.groups_outlined, 'Clients', '${_bookings.map((b) => b['clientName']).toSet().length}', const Color(0xFFDCFCE7)),
      _StatItem(Icons.check_circle_outline, 'Completed', '$_completedJobs', const Color(0xFFE0F2FE)),
      _StatItem(Icons.school_outlined, 'Classes', '${_classes.length}', const Color(0xFFE0F2FE)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (_, i) {
        final s = items[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(12)),
                child: Icon(s.icon, color: MarketplaceProviderDashboardScreen.navy, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: MarketplaceProviderDashboardScreen.muted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.value,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy),
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
      (icon: Icons.add_circle_outline, label: 'Add Service', color: MarketplaceProviderDashboardScreen.primary, onTap: _addClass),
      (icon: Icons.edit_outlined, label: 'Profile', color: const Color(0xFF8B5CF6), onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const MarketplaceProviderProfileCompletionScreen(),
        )).then((_) => _load());
      }),
      (icon: Icons.chat_bubble_outline, label: 'Messages', color: const Color(0xFF3B82F6), onTap: () => setState(() => _tab = 2)),
      (icon: Icons.bar_chart_rounded, label: 'Reports', color: const Color(0xFFEF4444), onTap: () => _toast('Reports coming soon')),
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
              width: 78,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: MarketplaceProviderDashboardScreen.navy),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bookingCard(Map<String, dynamic> b) {
    final id = b['id'];
    final status = (b['status']?.toString() ?? 'PENDING').toUpperCase();
    final client = b['clientName']?.toString() ?? 'Client';
    final time = b['requestedTime']?.toString() ?? '';
    final note = b['note']?.toString() ?? '';
    final initial = client.isNotEmpty ? client[0].toUpperCase() : 'C';

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
                radius: 18,
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(initial, style: const TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.primary)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client, style: const TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
                    Text(
                      time.isEmpty ? note : time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted),
                    ),
                  ],
                ),
              ),
              _statusPill(status),
            ],
          ),
          if (note.isNotEmpty && time.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(note, style: const TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted)),
          ],
          const SizedBox(height: 10),
          Builder(builder: (_) {
            final bid = id is int ? id : int.tryParse('$id');
            final pending = status == 'PENDING' || status == 'REQUESTED';
            final confirmed = status == 'CONFIRMED';
            final busy = bid != null && _busyBookingId == bid;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (pending) ...[
                  OutlinedButton(
                    onPressed: busy || bid == null ? null : () => _updateBookingStatus(bid, 'CONFIRMED'),
                    child: Text(busy ? 'Updating…' : 'Accept'),
                  ),
                  FilledButton(
                    onPressed: busy || bid == null ? null : () => _updateBookingStatus(bid, 'CANCELLED'),
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFBE123C)),
                    child: const Text('Reject'),
                  ),
                ],
                if (confirmed) ...[
                  FilledButton(
                    onPressed: busy || bid == null ? null : () => _updateBookingStatus(bid, 'COMPLETED'),
                    style: FilledButton.styleFrom(backgroundColor: MarketplaceProviderDashboardScreen.primary),
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
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'ACCEPTED':
      case 'CONFIRMED':
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        break;
      case 'COMPLETED':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF3730A3);
        break;
      case 'REJECTED':
      case 'CANCELLED':
        bg = const Color(0xFFFFE4E6);
        fg = const Color(0xFFBE123C);
        break;
      default:
        bg = const Color(0xFFE0F2FE);
        fg = const Color(0xFF0369A1);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _scheduleCard() {
    if (_classes.isEmpty && _upcomingBookings.isEmpty) {
      return _emptyCard('No schedule items for today.');
    }
    final items = <Widget>[];
    for (final c in _classes.take(4)) {
      items.add(_timelineRow(
        c['dateTime']?.toString() ?? '—',
        c['className']?.toString() ?? 'Class',
        c['mode']?.toString() ?? 'Live',
        'Upcoming',
      ));
    }
    for (final b in _upcomingBookings.take(3)) {
      items.add(_timelineRow(
        b['requestedTime']?.toString() ?? '—',
        b['clientName']?.toString() ?? 'Client',
        b['note']?.toString() ?? 'Booking',
        b['status']?.toString() ?? 'PENDING',
      ));
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _timelineRow(String time, String title, String subtitle, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              time.length > 12 ? time.substring(0, 12) : time,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MarketplaceProviderDashboardScreen.muted),
            ),
          ),
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4, right: 10),
            decoration: const BoxDecoration(
              color: MarketplaceProviderDashboardScreen.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
                Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: MarketplaceProviderDashboardScreen.muted)),
              ],
            ),
          ),
          _statusPill(status.toUpperCase()),
        ],
      ),
    );
  }

  Widget _earningsAndWalletRow() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
              const Text('Earnings Overview', style: TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _earnCol('Paid total', '₹${_earnings.toStringAsFixed(0)}'),
                  _earnCol('Bookings', '${_bookings.length}'),
                  _earnCol('Classes', '${_classes.length}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E1C59), Color(0xFFD93662)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Wallet Balance', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                '₹${_earnings.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _toast('Withdraw coming soon'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: MarketplaceProviderDashboardScreen.primary,
                      ),
                      child: const Text('Withdraw'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _toast('Transactions coming soon'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                      ),
                      child: const Text('Transactions'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _earnCol(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: MarketplaceProviderDashboardScreen.muted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
          const Text('+0%', style: TextStyle(fontSize: 10, color: Color(0xFF16A34A), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _requestsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _requestRow('New Bookings', '${_pendingBookings.length}', Icons.fiber_new_rounded),
          const Divider(height: 18),
          _requestRow('Classes', '${_classes.length}', Icons.school_outlined),
          const Divider(height: 18),
          _requestRow('Enrollments', '${_enrollments.length}', Icons.how_to_reg_outlined),
        ],
      ),
    );
  }

  Widget _requestRow(String label, String count, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: MarketplaceProviderDashboardScreen.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: MarketplaceProviderDashboardScreen.navy))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4E6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(count, style: const TextStyle(fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.primary)),
        ),
      ],
    );
  }

  Widget _referBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6D28D9), Color(0xFFDB2777)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Refer & Earn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 4),
                Text('Invite partners and earn rewards.', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => _toast('Referral coming soon'),
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF6D28D9)),
            child: const Text('Refer Now'),
          ),
        ],
      ),
    );
  }

  Widget _bookingsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          const Text('Client Bookings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
          const SizedBox(height: 12),
          if (_bookings.isEmpty)
            _emptyCard('No bookings yet.')
          else
            ..._bookings.map(_bookingCard),
          const SizedBox(height: 16),
          const Text('Classes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
          const SizedBox(height: 8),
          ..._classes.map(
            (c) => Card(
              child: ListTile(
                title: Text('${c['className'] ?? ''}'),
                subtitle: Text('${c['dateTime'] ?? ''} · ₹${c['price'] ?? 0}'),
                trailing: Text('Seats: ${c['availableSeats'] ?? 0}'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Enrollments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy)),
          const SizedBox(height: 8),
          ..._enrollments.map(
            (e) => Card(
              child: ListTile(
                title: Text('${e['className'] ?? 'Class'} · ${e['paymentStatus'] ?? ''}'),
                subtitle: Text('Student: ${e['userName'] ?? '-'}'),
                trailing: Text('₹${e['amountPaid'] ?? 0}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messagesTab() {
    final chats = _bookings.where((b) {
      final s = (b['status']?.toString() ?? '').toUpperCase();
      return s == 'CONFIRMED';
    }).toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: chats.isEmpty
          ? ListView(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
              children: const [
                Icon(Icons.chat_bubble_outline, size: 56, color: Color(0xFFCBD5E1)),
                SizedBox(height: 12),
                Text(
                  'No chats yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy),
                ),
                SizedBox(height: 6),
                Text(
                  'Accept a booking to open chat with that client. Messaging is only available for confirmed bookings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MarketplaceProviderDashboardScreen.muted),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: chats.length,
              itemBuilder: (_, i) {
                final b = chats[i];
                final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                final client = b['clientName']?.toString() ?? 'Client';
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFE4E6),
                      child: Text(client.isNotEmpty ? client[0].toUpperCase() : 'C'),
                    ),
                    title: Text(client),
                    subtitle: Text(b['requestedTime']?.toString() ?? 'Confirmed booking'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: id == null
                        ? null
                        : () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MarketplaceBookingChatScreen(
                                bookingId: id,
                                asProvider: true,
                                peerName: client,
                              ),
                            ));
                          },
                  ),
                );
              },
            ),
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _profileHeroCard(),
        const SizedBox(height: 16),
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
          leading: const Icon(Icons.category_outlined),
          title: const Text('Category'),
          subtitle: Text(_category),
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
        FilledButton.tonal(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const MarketplaceProviderProfileCompletionScreen(),
            )).then((_) => _load());
          },
          child: const Text('Edit profile'),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: MarketplaceProviderDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: MarketplaceProviderDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: MarketplaceProviderDashboardScreen.navy),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action, style: const TextStyle(color: MarketplaceProviderDashboardScreen.primary, fontWeight: FontWeight.w700)),
          ),
      ],
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
      child: Text(text, style: const TextStyle(color: MarketplaceProviderDashboardScreen.muted)),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _StatItem {
  const _StatItem(this.icon, this.label, this.value, this.bg);
  final IconData icon;
  final String label;
  final String value;
  final Color bg;
}
