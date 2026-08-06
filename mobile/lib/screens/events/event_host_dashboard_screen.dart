import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/event_host_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/registration_form_kit.dart';
import 'event_host_portal_login_screen.dart';

class EventHostDashboardScreen extends StatefulWidget {
  const EventHostDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color softBg = Color(0xFFFAF7F8);

  @override
  State<EventHostDashboardScreen> createState() => _EventHostDashboardScreenState();
}

class _EventHostDashboardScreenState extends State<EventHostDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _host = {};
  List<Map<String, dynamic>> _events = [];
  int _totalEvents = 0;
  int _totalRegistrations = 0;
  List<Map<String, dynamic>> _selectedRegs = [];
  String? _selectedEventName;
  bool _loadingRegs = false;

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
      final res = await EventHostAuthService(context.read<AuthState>().api).dashboard();
      if (res['success'] == true) {
        _host = Map<String, dynamic>.from(res['host'] ?? {});
        _events = ModuleTheme.toList(res['events']);
        _totalEvents = (res['totalEvents'] is num) ? (res['totalEvents'] as num).toInt() : _events.length;
        _totalRegistrations =
            (res['totalRegistrations'] is num) ? (res['totalRegistrations'] as num).toInt() : 0;
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
      MaterialPageRoute(builder: (_) => const EventHostPortalLoginScreen()),
      (_) => false,
    );
  }

  Future<void> _createEvent() async {
    final name = TextEditingController();
    final desc = TextEditingController();
    final venue = TextEditingController();
    final city = TextEditingController(text: _host['city']?.toString() ?? '');
    final date = TextEditingController();
    final time = TextEditingController(text: '10:00');
    final fee = TextEditingController(text: '0');
    final seats = TextEditingController(text: '100');
    String category = RegOptions.eventCategories.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Create Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Event name *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category *', border: OutlineInputBorder()),
                  items: RegOptions.eventCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setLocal(() => category = v ?? category),
                ),
                const SizedBox(height: 10),
                TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: venue, decoration: const InputDecoration(labelText: 'Venue *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: city, decoration: const InputDecoration(labelText: 'City *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: date, decoration: const InputDecoration(labelText: 'Date yyyy-MM-dd *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: time, decoration: const InputDecoration(labelText: 'Time HH:mm', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: fee, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Entry fee (Rs)', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: seats, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max participants', border: OutlineInputBorder())),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: EventHostDashboardScreen.primary),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;

    final apiCategory = category.toUpperCase().replaceAll(' & ', '_').replaceAll(' ', '_');
    final res = await EventHostAuthService(context.read<AuthState>().api).createEvent({
      'name': name.text.trim(),
      'category': apiCategory,
      'description': desc.text.trim(),
      'venue': venue.text.trim(),
      'city': city.text.trim(),
      'eventDate': date.text.trim(),
      'eventTime': time.text.trim(),
      'entryFee': double.tryParse(fee.text.trim()) ?? 0,
      'maxParticipants': int.tryParse(seats.text.trim()) ?? 0,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Event submitted for admin approval' : '${res['error']}'),
        backgroundColor: res['success'] == true ? Colors.teal : Colors.red.shade700,
      ),
    );
    if (res['success'] == true) {
      setState(() => _tab = 1);
      _load();
    }
  }

  Future<void> _openRegistrations(Map<String, dynamic> event) async {
    final id = event['id'];
    final eid = id is int ? id : int.tryParse('$id');
    if (eid == null) return;
    setState(() {
      _tab = 2;
      _loadingRegs = true;
      _selectedEventName = event['name']?.toString();
      _selectedRegs = [];
    });
    try {
      final res = await EventHostAuthService(context.read<AuthState>().api).registrations(eid);
      if (res['success'] == true) {
        _selectedRegs = ModuleTheme.toList(res['registrations']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingRegs = false);
  }

  String get _name => _host['fullName']?.toString() ?? 'Host';
  String get _org => _host['organizerName']?.toString() ?? 'Organization';
  String get _email => _host['email']?.toString() ?? '';
  String get _phone => _host['phone']?.toString() ?? _host['hostContact']?.toString() ?? '';
  String get _city {
    final parts = [_host['city'], _host['state']].where((e) => e != null && '$e'.isNotEmpty).toList();
    return parts.isEmpty ? 'Location not set' : parts.join(', ');
  }

  int get _pending => _events.where((e) => (e['status']?.toString() ?? '') == 'PENDING').length;
  int get _approved => _events.where((e) => (e['status']?.toString() ?? '') == 'APPROVED').length;
  int get _rejected => _events.where((e) => (e['status']?.toString() ?? '') == 'REJECTED').length;
  int get _expectedParticipants => _host['expectedParticipants'] is num
      ? (_host['expectedParticipants'] as num).toInt()
      : 0;

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHostDashboardScreen.softBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: EventHostDashboardScreen.navy,
        title: const Text('Event Host Dashboard', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: _createEvent, icon: const Icon(Icons.add_circle_outline, color: EventHostDashboardScreen.primary)),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: EventHostDashboardScreen.primary,
        onPressed: _createEvent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 12,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _nav(0, Icons.home_outlined, Icons.home, 'Home'),
              _nav(1, Icons.event_outlined, Icons.event, 'Events'),
              const SizedBox(width: 56),
              _nav(2, Icons.confirmation_number_outlined, Icons.confirmation_number, 'Attendees'),
              _nav(3, Icons.person_outline, Icons.person, 'Profile'),
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
                    children: [_home(), _eventsTab(), _attendeesTab(), _profileTab()],
                  ),
                ),
    );
  }

  Widget _nav(int i, IconData o, IconData f, String label) {
    final active = _tab == i;
    final c = active ? EventHostDashboardScreen.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? f : o, color: c, size: 22),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    return RefreshIndicator(
      color: EventHostDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _profileHeader(),
          const SizedBox(height: 14),
          _kpiRow(),
          const SizedBox(height: 16),
          if (_events.isEmpty) _gettingStarted() else _eventsPreview(),
          const SizedBox(height: 16),
          _statusAndActivity(),
          const SizedBox(height: 16),
          const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy)),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 16),
          _footerBanner(),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'H';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHostDashboardScreen.softPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: EventHostDashboardScreen.primary.withValues(alpha: 0.15), blurRadius: 12)],
                ),
                child: Center(
                  child: Text(initial, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.primary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: EventHostDashboardScreen.primary, borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Verified Host', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(_org, style: const TextStyle(fontWeight: FontWeight.w700, color: EventHostDashboardScreen.navy)),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 14, color: EventHostDashboardScreen.muted),
                        const SizedBox(width: 2),
                        Expanded(child: Text(_city, style: const TextStyle(fontSize: 12, color: EventHostDashboardScreen.muted))),
                      ],
                    ),
                    if (_email.isNotEmpty)
                      Row(children: [
                        const Icon(Icons.email_outlined, size: 14, color: EventHostDashboardScreen.muted),
                        const SizedBox(width: 4),
                        Expanded(child: Text(_email, style: const TextStyle(fontSize: 12, color: EventHostDashboardScreen.muted))),
                      ]),
                    if (_phone.isNotEmpty)
                      Row(children: [
                        const Icon(Icons.phone_outlined, size: 14, color: EventHostDashboardScreen.muted),
                        const SizedBox(width: 4),
                        Text(_phone, style: const TextStyle(fontSize: 12, color: EventHostDashboardScreen.muted)),
                      ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _tab = 3),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: EventHostDashboardScreen.primary,
                side: const BorderSide(color: EventHostDashboardScreen.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiRow() {
    final items = [
      (Icons.event_outlined, 'Total Events', '$_totalEvents', 'Upcoming'),
      (Icons.confirmation_number_outlined, 'Registrations', '$_totalRegistrations', 'Across all events'),
      (Icons.groups_outlined, 'Participants', '$_expectedParticipants', 'Expected'),
      (Icons.visibility_outlined, 'Profile Views', '—', 'This Month'),
      (Icons.currency_rupee, 'Earnings', '₹0', 'All Time'),
    ];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = items[i];
          return Container(
            width: 132,
            padding: const EdgeInsets.all(12),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(m.$1, color: EventHostDashboardScreen.primary, size: 20),
                const Spacer(),
                Text(m.$2, style: const TextStyle(fontSize: 11, color: EventHostDashboardScreen.muted, fontWeight: FontWeight.w600)),
                Text(m.$3, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy)),
                Text(m.$4, style: const TextStyle(fontSize: 10, color: EventHostDashboardScreen.muted)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _gettingStarted() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _card(),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: EventHostDashboardScreen.softPink, borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.event_available, size: 32, color: EventHostDashboardScreen.primary),
          ),
          const SizedBox(height: 12),
          const Text(
            "You haven't created any events yet. Create your first event and start making an impact!",
            textAlign: TextAlign.center,
            style: TextStyle(color: EventHostDashboardScreen.muted, height: 1.4),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _createEvent,
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
            style: FilledButton.styleFrom(
              backgroundColor: EventHostDashboardScreen.primary,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('My Events', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy))),
            TextButton(
              onPressed: () => setState(() => _tab = 1),
              child: const Text('View all', style: TextStyle(color: EventHostDashboardScreen.primary, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        ..._events.take(3).map(_eventTile),
      ],
    );
  }

  Widget _statusAndActivity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Event Status Overview', style: TextStyle(fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy, fontSize: 13)),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _totalEvents == 0 ? 0 : _approved / (_totalEvents == 0 ? 1 : _totalEvents),
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFF1F5F9),
                          color: EventHostDashboardScreen.primary,
                        ),
                        Text('$_totalEvents\nTotal', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy, height: 1.15)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _legend('Pending / Draft', _pending, const Color(0xFF94A3B8)),
                _legend('Approved / Upcoming', _approved, const Color(0xFF16A34A)),
                _legend('Rejected / Cancelled', _rejected, const Color(0xFFEF4444)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            height: 230,
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy, fontSize: 13)),
                const Spacer(),
                if (_events.isEmpty && _totalRegistrations == 0)
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.list_alt, size: 36, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 8),
                        Text('No recent activity yet. Your recent actions will appear here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: EventHostDashboardScreen.muted)),
                      ],
                    ),
                  )
                else ...[
                  if (_events.isNotEmpty) _activityRow(Icons.event, 'Created ${_events.first['name']}', 'Recently'),
                  if (_totalRegistrations > 0) _activityRow(Icons.confirmation_number, '$_totalRegistrations total registrations', 'Live'),
                  if (_pending > 0) _activityRow(Icons.hourglass_bottom, '$_pending event(s) pending approval', 'Admin'),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: EventHostDashboardScreen.muted))),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String text, String when) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: EventHostDashboardScreen.primary),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: EventHostDashboardScreen.navy))),
        ],
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      (Icons.add_circle_outline, 'Create Event', _createEvent),
      (Icons.event_note_outlined, 'My Events', () => setState(() => _tab = 1)),
      (Icons.confirmation_number_outlined, 'Registrations', () => setState(() => _tab = 2)),
      (Icons.account_balance_wallet_outlined, 'Payouts', () => _toast('Payouts coming soon')),
      (Icons.campaign_outlined, 'Marketing Tools', () => _toast('Marketing coming soon')),
      (Icons.insights_outlined, 'Analytics', () => _toast('Analytics coming soon')),
      (Icons.star_outline, 'Reviews', () => _toast('Reviews coming soon')),
      (Icons.handshake_outlined, 'Sponsors', () => _toast('Sponsors coming soon')),
      (Icons.place_outlined, 'Venue Partners', () => _toast('Venue partners coming soon')),
      (Icons.help_outline, 'Help & Support', () => _toast('Contact Fight D Fear support')),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) {
        final a = actions[i];
        return InkWell(
          onTap: a.$3,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: EventHostDashboardScreen.softPink, shape: BoxShape.circle),
                child: Icon(a.$1, color: EventHostDashboardScreen.primary, size: 20),
              ),
              const SizedBox(height: 6),
              Text(a.$2, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: EventHostDashboardScreen.navy, height: 1.15)),
            ],
          ),
        );
      },
    );
  }

  Widget _footerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHostDashboardScreen.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.white, size: 36),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Empower Women. Create Impact. Thank you for being a part of the Women Safety Community.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, height: 1.35),
            ),
          ),
          TextButton(
            onPressed: () => _toast('Learn more on Fight D Fear'),
            child: const Row(
              children: [
                Text('Learn More', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              const Expanded(child: Text('My Events', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy))),
              FilledButton.icon(
                onPressed: _createEvent,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
                style: FilledButton.styleFrom(backgroundColor: EventHostDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_events.isEmpty) _gettingStarted() else ..._events.map(_eventTile),
        ],
      ),
    );
  }

  Widget _eventTile(Map<String, dynamic> e) {
    final status = (e['status']?.toString() ?? 'PENDING').toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(e['name']?.toString() ?? 'Event', style: const TextStyle(fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy))),
              _pill(status),
            ],
          ),
          const SizedBox(height: 4),
          Text('${e['categoryLabel'] ?? e['category'] ?? ''} · ${e['city'] ?? ''} · ${e['eventDate'] ?? ''}', style: const TextStyle(fontSize: 12, color: EventHostDashboardScreen.muted)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openRegistrations(e),
                  style: OutlinedButton.styleFrom(foregroundColor: EventHostDashboardScreen.primary, side: const BorderSide(color: EventHostDashboardScreen.primary)),
                  child: const Text('Registrations'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () => _toast('${e['venue'] ?? ''} · Fee Rs ${e['entryFee'] ?? 0}'),
                  style: FilledButton.styleFrom(backgroundColor: EventHostDashboardScreen.primary),
                  child: const Text('Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendeesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text('Registrations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EventHostDashboardScreen.navy)),
        const SizedBox(height: 8),
        if (_events.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _events.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final e = _events[i];
                final selected = _selectedEventName == e['name']?.toString();
                return ChoiceChip(
                  label: Text(e['name']?.toString() ?? 'Event'),
                  selected: selected,
                  onSelected: (_) => _openRegistrations(e),
                  selectedColor: EventHostDashboardScreen.primary,
                  labelStyle: TextStyle(color: selected ? Colors.white : EventHostDashboardScreen.navy, fontWeight: FontWeight.w700, fontSize: 12),
                );
              },
            ),
          ),
        const SizedBox(height: 14),
        if (_loadingRegs)
          const Center(child: CircularProgressIndicator())
        else if (_selectedRegs.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _card(),
            child: Text(
              _selectedEventName == null ? 'Select an event to view registrations.' : 'No registrations yet.',
              style: const TextStyle(color: EventHostDashboardScreen.muted),
            ),
          )
        else
          ..._selectedRegs.map((r) => Card(
                child: ListTile(
                  title: Text(r['userName']?.toString() ?? 'Attendee'),
                  subtitle: Text('${r['userEmail'] ?? ''} · ${r['ticketCode'] ?? ''}'),
                  trailing: Text((r['status'] ?? '').toString()),
                ),
              )),
      ],
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHeader(),
        const SizedBox(height: 14),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.business), title: const Text('Organization'), subtitle: Text(_org)),
        const SizedBox(height: 8),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.category), title: const Text('Type'), subtitle: Text(_host['organizerType']?.toString() ?? '—')),
        const SizedBox(height: 8),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.interests), title: const Text('Categories'), subtitle: Text(_host['eventCategories']?.toString() ?? '—')),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(foregroundColor: EventHostDashboardScreen.primary, minimumSize: const Size.fromHeight(48), side: const BorderSide(color: EventHostDashboardScreen.primary)),
        ),
      ],
    );
  }

  Widget _pill(String status) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0369A1);
    if (status == 'APPROVED') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (status == 'REJECTED') {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFBE123C);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      );
}
