import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/glow_space_service.dart';

class GlowSpaceSalonDetailScreen extends StatefulWidget {
  const GlowSpaceSalonDetailScreen({super.key, required this.salonId});

  final int salonId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<GlowSpaceSalonDetailScreen> createState() => _GlowSpaceSalonDetailScreenState();
}

class _GlowSpaceSalonDetailScreenState extends State<GlowSpaceSalonDetailScreen> {
  late final GlowSpaceService _api;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _salon;
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _treatments = [];
  List<Map<String, dynamic>> _offers = [];

  @override
  void initState() {
    super.initState();
    _api = GlowSpaceService(context.read<AuthState>().api);
    _load();
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  List<Map<String, dynamic>> _toList(dynamic raw) =>
      raw is List ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : <Map<String, dynamic>>[];

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.salonDetail(widget.salonId);
      if (!mounted) return;
      if (res['success'] == true && res['salon'] is Map) {
        _salon = Map<String, dynamic>.from(res['salon'] as Map);
        _services = _toList(res['services']);
        _treatments = _toList(res['treatments']);
        _offers = _toList(res['offers']);
      } else {
        _error = res['error']?.toString() ?? 'Could not load salon';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _book({
    required String itemType,
    required int itemId,
    required String title,
  }) async {
    final date = DateTime.now().add(const Duration(days: 1));
    final payload = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        final dateCtrl = TextEditingController(text: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}');
        final timeCtrl = TextEditingController(text: '11:00');
        final addressCtrl = TextEditingController();
        final notesCtrl = TextEditingController();
        String type = 'ONLINE';
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text('Book $title'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
                  const SizedBox(height: 8),
                  TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Time (HH:mm)')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    items: const [
                      DropdownMenuItem(value: 'ONLINE', child: Text('Online at salon')),
                      DropdownMenuItem(value: 'DOOR', child: Text('Door service')),
                    ],
                    onChanged: (v) => setLocal(() => type = v ?? 'ONLINE'),
                    decoration: const InputDecoration(labelText: 'Booking type'),
                  ),
                  if (type == 'DOOR') ...[
                    const SizedBox(height: 8),
                    TextField(controller: addressCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Address')),
                  ],
                  const SizedBox(height: 8),
                  TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop({
                  'bookingDate': dateCtrl.text.trim(),
                  'preferredTime': timeCtrl.text.trim(),
                  'bookingType': type,
                  'address': addressCtrl.text.trim(),
                  'notes': notesCtrl.text.trim(),
                }),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
    if (payload == null) return;

    final res = await _api.createBooking(
      itemType: itemType,
      itemId: itemId,
      bookingDate: payload['bookingDate'] ?? '',
      preferredTime: payload['preferredTime'] ?? '',
      bookingType: payload['bookingType'] ?? 'ONLINE',
      address: payload['address'],
      notes: payload['notes'],
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Booking created' : (res['error']?.toString() ?? 'Booking failed'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _salon;
    final image = _mediaUrl(s?['profileImageUrl']?.toString());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowSpaceSalonDetailScreen.navy,
        title: Text(s?['name']?.toString() ?? 'Salon'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: image.isEmpty
                            ? Container(height: 180, color: const Color(0xFFFFE4E6), child: const Icon(Icons.spa_outlined, size: 44))
                            : Image.network(image, height: 180, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                      Text(s?['name']?.toString() ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      Text('${s?['city'] ?? ''} ${s?['state'] ?? ''}', style: const TextStyle(color: GlowSpaceSalonDetailScreen.textGray)),
                      const SizedBox(height: 12),
                      if (s?['bio'] != null && '${s!['bio']}'.isNotEmpty) Text('${s['bio']}'),
                      const SizedBox(height: 16),
                      const Text('Services', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_services.isEmpty)
                        const Text('No services listed', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                      else
                        ..._services.map((x) => _bookableRow(
                              title: x['name']?.toString() ?? 'Service',
                              subtitle: '${x['category'] ?? ''} · ₹${x['price'] ?? 0}',
                              onTap: () => _book(
                                itemType: 'SERVICE',
                                itemId: (x['id'] is int) ? x['id'] as int : int.parse('${x['id']}'),
                                title: x['name']?.toString() ?? 'Service',
                              ),
                            )),
                      const SizedBox(height: 14),
                      const Text('Treatments', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_treatments.isEmpty)
                        const Text('No treatments listed', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                      else
                        ..._treatments.map((x) => _bookableRow(
                              title: x['serviceName']?.toString() ?? 'Treatment',
                              subtitle: '${x['category'] ?? ''} · ₹${x['price'] ?? 0}',
                              onTap: () => _book(
                                itemType: 'TREATMENT',
                                itemId: (x['id'] is int) ? x['id'] as int : int.parse('${x['id']}'),
                                title: x['serviceName']?.toString() ?? 'Treatment',
                              ),
                            )),
                      const SizedBox(height: 14),
                      const Text('Offers', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_offers.isEmpty)
                        const Text('No active offers', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                      else
                        ..._offers.map((x) => _bookableRow(
                              title: x['title']?.toString() ?? 'Offer',
                              subtitle: '${x['discountPercent'] ?? 0}% off · ₹${x['discountedPrice'] ?? x['offerPrice'] ?? 0}',
                              onTap: () => _book(
                                itemType: 'OFFER',
                                itemId: (x['id'] is int) ? x['id'] as int : int.parse('${x['id']}'),
                                title: x['title']?.toString() ?? 'Offer',
                              ),
                            )),
                    ],
                  ),
                ),
    );
  }

  Widget _bookableRow({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: GlowSpaceSalonDetailScreen.textGray)),
            ]),
          ),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(backgroundColor: GlowSpaceSalonDetailScreen.primary),
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }
}
