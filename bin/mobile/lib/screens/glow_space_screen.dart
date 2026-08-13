import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/glow_space_service.dart';
import 'glow_provider_signup_screen.dart';
import 'glow_space_salon_detail_screen.dart';

class GlowSpaceScreen extends StatefulWidget {
  const GlowSpaceScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<GlowSpaceScreen> createState() => _GlowSpaceScreenState();
}

class _GlowSpaceScreenState extends State<GlowSpaceScreen>
    with SingleTickerProviderStateMixin {
  late final GlowSpaceService _api;
  late final TabController _tabs;
  bool _loading = true;
  bool _loadingBookings = false;
  String? _error;
  List<Map<String, dynamic>> _salons = [];
  List<Map<String, dynamic>> _treatments = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _bookings = [];
  String _section = 'SALONS';

  @override
  void initState() {
    super.initState();
    _api = GlowSpaceService(context.read<AuthState>().api);
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadBookings();
    });
    _loadExplore();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _loadExplore() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final salonsRes = await _api.salons();
      final treatmentsRes = await _api.treatments();
      final offersRes = await _api.offers();
      if (!mounted) return;
      if (salonsRes['success'] == true) {
        _salons = _toList(salonsRes['salons']);
        _treatments = _toList(treatmentsRes['treatments']);
        _offers = _toList(offersRes['offers']);
      } else {
        _error = salonsRes['error']?.toString() ?? 'Could not load Glow Space';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final res = await _api.myBookings();
      if (!mounted) return;
      if (res['success'] == true) {
        _bookings = _toList(res['bookings']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
  }

  List<Map<String, dynamic>> _toList(dynamic raw) =>
      raw is List ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : <Map<String, dynamic>>[];

  Future<void> _bookItem({
    required String itemType,
    required int itemId,
    required String title,
  }) async {
    final dateCtrl = TextEditingController(text: DateTime.now().add(const Duration(days: 1)).toString().split(' ').first);
    final timeCtrl = TextEditingController(text: '11:00');
    final addressCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String bookingType = 'ONLINE';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Book $title'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: bookingType,
                  items: const [
                    DropdownMenuItem(value: 'ONLINE', child: Text('Online at salon')),
                    DropdownMenuItem(value: 'DOOR', child: Text('Door service')),
                  ],
                  onChanged: (v) => setLocal(() => bookingType = v ?? 'ONLINE'),
                  decoration: const InputDecoration(labelText: 'Booking type'),
                ),
                if (bookingType == 'DOOR') ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: addressCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                ],
                const SizedBox(height: 8),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Confirm')),
          ],
        ),
      ),
    );

    if (ok != true) return;
    final res = await _api.createBooking(
      itemType: itemType,
      itemId: itemId,
      bookingDate: dateCtrl.text.trim(),
      preferredTime: timeCtrl.text.trim(),
      bookingType: bookingType,
      address: addressCtrl.text.trim(),
      notes: notesCtrl.text.trim(),
    );
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created')),
      );
      _tabs.animateTo(1);
      await _loadBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Booking failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowSpaceScreen.navy,
        title: const Text('Glow Space', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GlowProviderSignupScreen()),
            ),
            icon: const Icon(Icons.store_mall_directory_outlined, size: 18),
            label: const Text('Provider Sign up'),
            style: TextButton.styleFrom(foregroundColor: GlowSpaceScreen.primary),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: GlowSpaceScreen.primary,
          unselectedLabelColor: GlowSpaceScreen.textGray,
          indicatorColor: GlowSpaceScreen.primary,
          tabs: const [
            Tab(text: 'Explore'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildExplore(),
          _buildBookings(),
        ],
      ),
    );
  }

  Widget _buildExplore() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Wrap(
            spacing: 8,
            children: [
              _chipFilter('SALONS', 'Salons'),
              _chipFilter('TREATMENTS', 'Treatments'),
              _chipFilter('OFFERS', 'Offers'),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadExplore,
            color: GlowSpaceScreen.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 20),
              children: _section == 'SALONS'
                  ? _salons.map(_salonTile).toList()
                  : _section == 'TREATMENTS'
                      ? _treatments.map(_treatmentTile).toList()
                      : _offers.map(_offerTile).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookings() {
    if (_loadingBookings) return const Center(child: CircularProgressIndicator());
    if (_bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadBookings,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text('No Glow bookings yet')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final b = _bookings[i];
          final salon = b['salon'] is Map ? Map<String, dynamic>.from(b['salon'] as Map) : <String, dynamic>{};
          final item = b['item'] is Map ? Map<String, dynamic>.from(b['item'] as Map) : <String, dynamic>{};
          final type = b['itemType']?.toString() ?? '';
          final itemTitle = item['name']?.toString() ?? item['serviceName']?.toString() ?? item['title']?.toString() ?? type;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  '${salon['name'] ?? ''} · ${b['bookingDate'] ?? ''} ${b['preferredTime'] ?? ''}',
                  style: const TextStyle(color: GlowSpaceScreen.textGray),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    _statusChip(b['status']?.toString() ?? 'PENDING'),
                    _statusChip(b['bookingType']?.toString() ?? 'ONLINE', color: Colors.indigo),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _salonTile(Map<String, dynamic> s) {
    final id = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
    final image = _mediaUrl(s['profileImageUrl']?.toString());
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.isEmpty
              ? Container(width: 48, height: 48, color: const Color(0xFFFFE4E6), child: const Icon(Icons.spa_outlined))
              : Image.network(image, width: 48, height: 48, fit: BoxFit.cover),
        ),
        title: Text(s['name']?.toString() ?? 'Salon'),
        subtitle: Text('${s['city'] ?? ''} ${s['state'] ?? ''}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: id == null
            ? null
            : () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GlowSpaceSalonDetailScreen(salonId: id)),
                );
                await _loadBookings();
              },
      ),
    );
  }

  Widget _treatmentTile(Map<String, dynamic> t) {
    final id = t['id'] is int ? t['id'] as int : int.tryParse('${t['id']}');
    return _itemCard(
      title: t['serviceName']?.toString() ?? 'Treatment',
      subtitle: '${t['salonName'] ?? ''} · ₹${t['price'] ?? 0}',
      onBook: id == null
          ? null
          : () => _bookItem(
                itemType: 'TREATMENT',
                itemId: id,
                title: t['serviceName']?.toString() ?? 'Treatment',
              ),
    );
  }

  Widget _offerTile(Map<String, dynamic> o) {
    final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    final discount = o['discountPercent'];
    return _itemCard(
      title: o['title']?.toString() ?? 'Offer',
      subtitle: '${o['salonName'] ?? ''} · ${discount ?? 0}% off · ₹${o['discountedPrice'] ?? o['offerPrice'] ?? 0}',
      onBook: id == null
          ? null
          : () => _bookItem(
                itemType: 'OFFER',
                itemId: id,
                title: o['title']?.toString() ?? 'Offer',
              ),
    );
  }

  Widget _itemCard({
    required String title,
    required String subtitle,
    VoidCallback? onBook,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: GlowSpaceScreen.textGray)),
              ],
            ),
          ),
          FilledButton(
            onPressed: onBook,
            style: FilledButton.styleFrom(backgroundColor: GlowSpaceScreen.primary),
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }

  Widget _chipFilter(String key, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _section == key,
      onSelected: (_) => setState(() => _section = key),
    );
  }

  Widget _statusChip(String label, {Color color = GlowSpaceScreen.primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
