import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/glow_catalog.dart';
import '../services/auth_state.dart';
import '../services/glow_provider_auth_service.dart';
import 'glow_provider_login_screen.dart';

class GlowSalonDashboardScreen extends StatefulWidget {
  const GlowSalonDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<GlowSalonDashboardScreen> createState() => _GlowSalonDashboardScreenState();
}

class _GlowSalonDashboardScreenState extends State<GlowSalonDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final GlowProviderAuthService _auth;
  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _auth = GlowProviderAuthService(context.read<AuthState>().api);
    _tabs = TabController(length: 4, vsync: this);
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
      final res = await _auth.salonDashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _data = res;
      } else {
        _error = res['error']?.toString() ?? 'Could not load dashboard';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await _auth.logoutSalon();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GlowProviderLoginScreen()),
      (_) => false,
    );
  }

  List<Map<String, dynamic>> _list(String key) {
    final raw = _data?[key];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Map<String, dynamic>? get _salon =>
      _data?['salon'] is Map ? Map<String, dynamic>.from(_data!['salon'] as Map) : null;

  Map<String, dynamic>? get _meta =>
      _data?['meta'] is Map ? Map<String, dynamic>.from(_data!['meta'] as Map) : null;

  String get _salonName => _salon?['name']?.toString() ?? 'Glow Space';

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final pending = (_meta?['pendingCount'] is num) ? (_meta!['pendingCount'] as num).toInt() : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: GlowSalonDashboardScreen.navy,
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Glow Space Hub', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text(
              '${_greeting()}, $_salonName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ],
        ),
        toolbarHeight: 64,
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: GlowSalonDashboardScreen.primary,
        elevation: 6,
        onPressed: () {
          _tabs.animateTo(2);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add services from the Services tab')),
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
              _navItem(
                1,
                Icons.event_note_outlined,
                Icons.event_note,
                'Bookings',
                1,
                badge: pending > 0 ? '${pending.clamp(1, 9)}' : null,
              ),
              const SizedBox(width: 56),
              _navItem(2, Icons.spa_outlined, Icons.spa, 'Services', 2),
              _navItem(3, Icons.person_outline, Icons.person, 'Profile', 3),
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
                      child: _SalonProfileCard(salon: _salon, meta: _meta),
                    ),
                    Material(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabs,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: GlowSalonDashboardScreen.primary,
                        unselectedLabelColor: const Color(0xFF94A3B8),
                        indicatorColor: GlowSalonDashboardScreen.primary,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Bookings'),
                          Tab(text: 'Services'),
                          Tab(text: 'Settings'),
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
                            bookings: _list('bookings'),
                            services: _list('services'),
                            onGoBookings: () => _tabs.animateTo(1),
                            onGoServices: () => _tabs.animateTo(2),
                            onGoSettings: () => _tabs.animateTo(3),
                          ),
                          _BookingsTab(auth: _auth, bookings: _list('bookings'), onChanged: _load),
                          _ServicesTab(auth: _auth, services: _list('services'), onChanged: _load),
                          _SettingsTab(auth: _auth, salon: _salon, onSaved: _load),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _navItem(int visualIndex, IconData icon, IconData activeIcon, String label, int tabIndex, {String? badge}) {
    final isSelected = _tabs.index == tabIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          _tabs.animateTo(tabIndex);
          setState(() {});
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: badge != null,
              label: badge == null ? null : Text(badge),
              child: Icon(isSelected ? activeIcon : icon, size: 22, color: isSelected ? GlowSalonDashboardScreen.primary : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? GlowSalonDashboardScreen.primary : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalonProfileCard extends StatelessWidget {
  const _SalonProfileCard({required this.salon, required this.meta});
  final Map<String, dynamic>? salon;
  final Map<String, dynamic>? meta;

  @override
  Widget build(BuildContext context) {
    final approved = salon?['approved'] == true;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: GlowSalonDashboardScreen.primary.withValues(alpha: 0.12),
            child: const Icon(Icons.spa, color: GlowSalonDashboardScreen.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(salon?['name']?.toString() ?? 'Glow Space', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                Text(
                  '${salon?['city'] ?? ''} · ${salon?['availabilityHours'] ?? 'Hours not set'}',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  children: [
                    _chip(approved ? 'Approved' : 'Pending', approved ? Colors.green : Colors.orange),
                    _chip('${meta?['serviceCount'] ?? 0} services', GlowSalonDashboardScreen.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.meta,
    required this.bookings,
    required this.services,
    required this.onGoBookings,
    required this.onGoServices,
    required this.onGoSettings,
  });

  final Map<String, dynamic>? meta;
  final List<Map<String, dynamic>> bookings;
  final List<Map<String, dynamic>> services;
  final VoidCallback onGoBookings;
  final VoidCallback onGoServices;
  final VoidCallback onGoSettings;

  @override
  Widget build(BuildContext context) {
    final earnings = meta?['earnings'] is num ? (meta!['earnings'] as num).toStringAsFixed(0) : '0';
    final recent = bookings.take(5).toList();
    final byCategory = <String, int>{};
    for (final s in services) {
      final label = GlowCatalog.labelFor(s['category']?.toString());
      byCategory[label] = (byCategory[label] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _stat(context, 'Bookings', '${meta?['bookingCount'] ?? 0}', Icons.event_note_outlined, onGoBookings),
            _stat(context, 'Pending', '${meta?['pendingCount'] ?? 0}', Icons.hourglass_empty, onGoBookings),
            _stat(context, 'Services', '${meta?['serviceCount'] ?? 0}', Icons.spa_outlined, onGoServices),
            _stat(context, 'Earnings', '₹$earnings', Icons.payments_outlined, onGoBookings),
          ],
        ),
        const SizedBox(height: 18),
        const Text('Quick actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(avatar: const Icon(Icons.add, size: 18), label: const Text('Add service'), onPressed: onGoServices),
            ActionChip(avatar: const Icon(Icons.event_note, size: 18), label: const Text('Manage bookings'), onPressed: onGoBookings),
            ActionChip(avatar: const Icon(Icons.settings, size: 18), label: const Text('Edit profile'), onPressed: onGoSettings),
          ],
        ),
        if (byCategory.isNotEmpty) ...[
          const SizedBox(height: 18),
          const Text('Catalogue by category', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          ...byCategory.entries.map((e) {
            final match = GlowCatalog.categories.where((c) => c.label == e.key);
            final code = match.isEmpty ? null : match.first.code;
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(GlowCatalog.iconFor(code), color: GlowSalonDashboardScreen.primary),
              title: Text(e.key),
              trailing: Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.w700)),
            );
          }),
        ],
        const SizedBox(height: 12),
        const Text('Recent bookings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          const Text('No bookings yet', style: TextStyle(color: Color(0xFF64748B)))
        else
          ...recent.map((b) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(b['itemName']?.toString() ?? 'Booking #${b['id']}'),
                  subtitle: Text('${b['customerName'] ?? ''} · ${b['status'] ?? ''}'),
                  trailing: Text('₹${b['price'] ?? 0}'),
                  onTap: onGoBookings,
                ),
              )),
      ],
    );
  }

  Widget _stat(BuildContext context, String label, String value, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: GlowSalonDashboardScreen.primary),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingsTab extends StatelessWidget {
  const _BookingsTab({required this.auth, required this.bookings, required this.onChanged});
  final GlowProviderAuthService auth;
  final List<Map<String, dynamic>> bookings;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const Center(child: Text('No bookings yet'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final b = bookings[i];
        final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
        return Card(
          child: ListTile(
            title: Text(b['itemName']?.toString() ?? 'Booking #${b['id']}'),
            subtitle: Text(
              '${b['customerName'] ?? ''} · ${b['bookingDate'] ?? ''} ${b['preferredTime'] ?? ''}\n'
              '${b['status'] ?? ''} · ₹${b['price'] ?? 0}',
            ),
            isThreeLine: true,
            trailing: PopupMenuButton<String>(
              onSelected: (status) async {
                if (id == null) return;
                final res = await auth.updateBookingStatus(id, status);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message']?.toString() ?? 'Updated')),
                  );
                  if (res['success'] == true) onChanged();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'CONFIRMED', child: Text('Confirm')),
                PopupMenuItem(value: 'COMPLETED', child: Text('Complete')),
                PopupMenuItem(value: 'CANCELLED', child: Text('Cancel')),
                PopupMenuItem(value: 'REJECTED', child: Text('Reject')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ServicesTab extends StatefulWidget {
  const _ServicesTab({required this.auth, required this.services, required this.onChanged});
  final GlowProviderAuthService auth;
  final List<Map<String, dynamic>> services;
  final VoidCallback onChanged;

  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  String? _filterCategory;

  Future<void> _edit([Map<String, dynamic>? existing]) async {
    final nameCtrl = TextEditingController(text: existing?['name']?.toString() ?? '');
    final priceCtrl = TextEditingController(text: '${existing?['price'] ?? GlowCatalog.defaultPrice('HAIR')}');
    final durationCtrl = TextEditingController(text: '${existing?['durationMinutes'] ?? 30}');
    String category = existing?['category']?.toString() ?? GlowCatalog.categories.first.code;
    if (GlowCatalog.byCode(category) == null) category = GlowCatalog.categories.first.code;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: StatefulBuilder(
          builder: (ctx, setLocal) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(existing == null ? 'Add Glow service' : 'Edit service',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: GlowCatalog.categories
                      .map((c) => DropdownMenuItem(value: c.code, child: Text(c.label)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setLocal(() {
                      category = v;
                      if (nameCtrl.text.trim().isEmpty) {
                        // keep empty for free typing
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Pick from catalogue (optional)', border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(value: '', child: Text('Custom name…')),
                    ...GlowCatalog.byCode(category)!.services.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                  ],
                  onChanged: (v) {
                    if (v == null || v.isEmpty) return;
                    setLocal(() => nameCtrl.text = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Service name', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (₹)', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                TextField(controller: durationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (min)', border: OutlineInputBorder())),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    final body = <String, dynamic>{
                      if (existing?['id'] != null) 'id': existing!['id'],
                      'name': nameCtrl.text.trim(),
                      'category': category,
                      'price': double.tryParse(priceCtrl.text.trim()) ?? GlowCatalog.defaultPrice(category),
                      'durationMinutes': int.tryParse(durationCtrl.text.trim()) ?? GlowCatalog.defaultDuration(category),
                    };
                    if (body['name'].toString().isEmpty) return;
                    final res = await widget.auth.saveService(body);
                    if (!ctx.mounted) return;
                    Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
                      );
                    }
                    if (res['success'] == true) widget.onChanged();
                  },
                  style: FilledButton.styleFrom(backgroundColor: GlowSalonDashboardScreen.primary),
                  child: const Text('Save service'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterCategory == null
        ? widget.services
        : widget.services.where((s) => GlowCatalog.byCode(s['category']?.toString())?.code == _filterCategory).toList();

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final s in filtered) {
      final key = GlowCatalog.labelFor(s['category']?.toString());
      grouped.putIfAbsent(key, () => []).add(s);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _edit(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add service'),
                  style: FilledButton.styleFrom(backgroundColor: GlowSalonDashboardScreen.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: _filterCategory == null,
                  onSelected: (_) => setState(() => _filterCategory = null),
                ),
              ),
              ...GlowCatalog.categories.map((c) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(c.label),
                      selected: _filterCategory == c.code,
                      onSelected: (_) => setState(() => _filterCategory = c.code),
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No services yet — add your Glow catalogue'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    for (final entry in grouped.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 6),
                        child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      ),
                      ...entry.value.map((s) {
                        final id = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(GlowCatalog.iconFor(s['category']?.toString()), color: GlowSalonDashboardScreen.primary),
                            title: Text(s['name']?.toString() ?? 'Service'),
                            subtitle: Text('₹${s['price'] ?? 0} · ${s['durationMinutes'] ?? 0} min'),
                            trailing: PopupMenuButton<String>(
                              onSelected: (v) async {
                                if (v == 'edit') {
                                  await _edit(s);
                                } else if (v == 'delete' && id != null) {
                                  final res = await widget.auth.deleteService(id);
                                  if (context.mounted && res['success'] == true) widget.onChanged();
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(value: 'delete', child: Text('Delete')),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatefulWidget {
  const _SettingsTab({required this.auth, this.salon, required this.onSaved});
  final GlowProviderAuthService auth;
  final Map<String, dynamic>? salon;
  final VoidCallback onSaved;

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  late final TextEditingController _address;
  late final TextEditingController _bio;
  late final TextEditingController _hours;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.salon?['name']?.toString() ?? '');
    _phone = TextEditingController(text: widget.salon?['phone']?.toString() ?? '');
    _city = TextEditingController(text: widget.salon?['city']?.toString() ?? '');
    _address = TextEditingController(text: widget.salon?['address']?.toString() ?? '');
    _bio = TextEditingController(text: widget.salon?['bio']?.toString() ?? '');
    _hours = TextEditingController(text: widget.salon?['availabilityHours']?.toString() ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _city.dispose();
    _address.dispose();
    _bio.dispose();
    _hours.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final res = await widget.auth.updateSettings({
      'name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'city': _city.text.trim(),
      'address': _address.text.trim(),
      'bio': _bio.text.trim(),
      'availabilityHours': _hours.text.trim(),
    });
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
    );
    if (res['success'] == true) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Glow Space profile', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 12),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _city, decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _address, decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _hours, decoration: const InputDecoration(labelText: 'Hours', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _bio, maxLines: 3, decoration: const InputDecoration(labelText: 'Bio', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: GlowSalonDashboardScreen.primary, minimumSize: const Size.fromHeight(48)),
          child: _busy
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Save settings'),
        ),
      ],
    );
  }
}
