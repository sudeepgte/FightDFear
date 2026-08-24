import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/glow_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/glow_space_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import 'glow_booking_confirmation_screen.dart';

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
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _salon;
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _treatments = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _reviews = [];
  List<String> _slotsToday = [];
  List<String> _photos = [];
  bool _favorite = false;
  bool _canReview = false;
  String? _nextSlotLabel;
  String? _cancelPolicy;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = GlowSpaceService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) => _checkout.handleError(r),
    );
    _load();
  }

  @override
  void dispose() {
    _checkout.dispose();
    super.dispose();
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
        _reviews = _toList(res['reviews']);
        _slotsToday = (res['slotsToday'] is List)
            ? (res['slotsToday'] as List).map((e) => e.toString()).toList()
            : <String>[];
        _photos = (res['salon'] is Map && (res['salon'] as Map)['galleryPhotos'] is List)
            ? ((res['salon'] as Map)['galleryPhotos'] as List).map((e) => e.toString()).toList()
            : <String>[];
        _favorite = res['favorite'] == true || _salon?['favorite'] == true;
        _canReview = res['canReview'] == true;
        _nextSlotLabel = res['nextSlot'] is Map ? (res['nextSlot'] as Map)['label']?.toString() : null;
        if (res['noSlotsToday'] == true) _nextSlotLabel ??= 'No slots today';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? GlowCatalog.cancelPolicy;
      } else {
        _error = res['error']?.toString() ?? 'Could not load salon';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _startPayment({required int bookingId, required String title}) async {
    await _checkout.pay(
      context: context,
      description: 'Glow Space · $title',
      createOrderFn: () => PaymentService(context.read<AuthState>().api)
          .createGlowBookingOrder(bookingId),
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'GLOW_BOOKING',
        'bookingId': bookingId,
      },
      onSuccess: () async {
        if (!mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GlowBookingConfirmationScreen(bookingId: bookingId)),
        );
      },
    );
  }

  Future<void> _writeReview() async {
    int rating = 5;
    final comment = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Write a review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: rating,
                items: const [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e ★'))).toList(),
                onChanged: (v) => setLocal(() => rating = v ?? 5),
                decoration: const InputDecoration(labelText: 'Rating'),
              ),
              const SizedBox(height: 8),
              TextField(controller: comment, maxLines: 3, decoration: const InputDecoration(labelText: 'Comment')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Post')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.addReview(widget.salonId, rating: rating, comment: comment.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Review saved' : (res['error']?.toString() ?? 'Failed'))),
    );
    if (res['success'] == true) _load();
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
        DateTime pickedDate = date;
        String pickedTime = _slotsToday.isNotEmpty ? _slotsToday.first : '11:00';
        final addressCtrl = TextEditingController();
        final notesCtrl = TextEditingController();
        String type = 'ONLINE';
        List<String> slots = List<String>.from(_slotsToday);
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text('Book $title'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date'),
                    subtitle: Text('${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: pickedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (d == null) return;
                      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                      final slotRes = await _api.salonSlots(widget.salonId, date: key);
                      setLocal(() {
                        pickedDate = d;
                        slots = (slotRes['slots'] is List)
                            ? (slotRes['slots'] as List).map((e) => e.toString()).toList()
                            : <String>[];
                        if (slots.isNotEmpty) pickedTime = slots.first;
                      });
                    },
                  ),
                  if (slots.isEmpty)
                    const Text('No slots on this date', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                  else
                    DropdownButtonFormField<String>(
                      initialValue: slots.contains(pickedTime) ? pickedTime : slots.first,
                      items: slots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setLocal(() => pickedTime = v ?? pickedTime),
                      decoration: const InputDecoration(labelText: 'Time'),
                    ),
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
                  'bookingDate': '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}',
                  'preferredTime': pickedTime,
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
    if (res['success'] == true) {
      final paymentRequired = res['paymentRequired'] == true;
      final bookingId = res['bookingId'] is int ? res['bookingId'] as int : int.tryParse('${res['bookingId']}');
      if (paymentRequired && bookingId != null) {
        await _startPayment(bookingId: bookingId, title: title);
      } else if (bookingId != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => GlowBookingConfirmationScreen(bookingId: bookingId)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? 'Booking created')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Booking failed')),
      );
    }
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
        actions: [
          IconButton(
            icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border, color: GlowSpaceSalonDetailScreen.primary),
            onPressed: () async {
              final res = await _api.toggleFavorite(widget.salonId);
              if (!mounted) return;
              if (res['success'] == true) {
                setState(() => _favorite = res['favorite'] == true);
              }
            },
          ),
        ],
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (s?['rating'] != null) Chip(label: Text('★ ${s?['rating']}')),
                          if (s?['startingFee'] != null) Chip(label: Text('From ₹${s?['startingFee']}')),
                          if (_nextSlotLabel != null) Chip(label: Text(_nextSlotLabel!)),
                          if (s?['doorService'] == true) const Chip(label: Text('Door service')),
                          if (s?['femaleStaff'] == true) const Chip(label: Text('Female staff')),
                        ],
                      ),
                      if (_photos.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 90,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _photos.map((p) {
                              final url = _mediaUrl(p);
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: url.isEmpty
                                      ? Container(width: 90, color: const Color(0xFFFFE4E6))
                                      : Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      if (s?['bio'] != null && '${s!['bio']}'.isNotEmpty) Text('${s['bio']}'),
                      if (_cancelPolicy != null) ...[
                        const SizedBox(height: 8),
                        Text(_cancelPolicy!, style: const TextStyle(fontSize: 12, color: GlowSpaceSalonDetailScreen.textGray)),
                      ],
                      const SizedBox(height: 16),
                      const Text('Services by category', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_services.isEmpty)
                        const Text('No services listed', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                      else
                        ..._groupedServiceSections(),
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(child: Text('Reviews', style: TextStyle(fontWeight: FontWeight.w700))),
                          if (_canReview)
                            TextButton(onPressed: _writeReview, child: const Text('Write review')),
                        ],
                      ),
                      if (_reviews.isEmpty)
                        const Text('No reviews yet', style: TextStyle(color: GlowSpaceSalonDetailScreen.textGray))
                      else
                        ..._reviews.take(8).map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.star, color: Color(0xFFF59E0B)),
                              title: Text('${r['userName'] ?? 'Member'} · ${r['rating'] ?? ''}★'),
                              subtitle: Text(r['comment']?.toString() ?? ''),
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

  List<Widget> _groupedServiceSections() {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final x in _services) {
      final key = GlowCatalog.labelFor(x['category']?.toString());
      grouped.putIfAbsent(key, () => []).add(x);
    }
    final out = <Widget>[];
    for (final entry in grouped.entries) {
      out.add(Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          children: [
            Icon(GlowCatalog.iconFor(entry.value.first['category']?.toString()), size: 18, color: GlowSpaceSalonDetailScreen.primary),
            const SizedBox(width: 6),
            Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ));
      for (final x in entry.value) {
        out.add(_bookableRow(
          title: x['name']?.toString() ?? 'Service',
          subtitle: '₹${x['price'] ?? 0} · ${x['durationMinutes'] ?? 0} min',
          onTap: () => _book(
            itemType: 'SERVICE',
            itemId: (x['id'] is int) ? x['id'] as int : int.parse('${x['id']}'),
            title: x['name']?.toString() ?? 'Service',
          ),
        ));
      }
    }
    return out;
  }
}
