import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/job_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';

class WomenJobsWorkerDetailScreen extends StatefulWidget {
  const WomenJobsWorkerDetailScreen({super.key, required this.workerId});

  final int workerId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<WomenJobsWorkerDetailScreen> createState() =>
      _WomenJobsWorkerDetailScreenState();
}

class _WomenJobsWorkerDetailScreenState extends State<WomenJobsWorkerDetailScreen> {
  late final MarketplaceService _api;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _worker;
  List<Map<String, dynamic>> _reviews = [];
  List<String> _slotsToday = [];
  List<String> _photos = [];
  bool _favorite = false;
  String? _nextSlotLabel;
  String? _cancelPolicy;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = MarketplaceService(api);
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
      final res = await _api.workerDetail(widget.workerId);
      if (!mounted) return;
      if (res['success'] == true && res['worker'] is Map) {
        _worker = Map<String, dynamic>.from(res['worker'] as Map);
        _reviews = _toList(res['reviews']);
        _slotsToday = (res['slotsToday'] is List)
            ? (res['slotsToday'] as List).map((e) => e.toString()).toList()
            : <String>[];
        final gallery = _worker?['galleryPhotos'];
        _photos = JobCatalog.splitCsv(gallery);
        _favorite = res['favorite'] == true || _worker?['favorite'] == true;
        _nextSlotLabel = res['nextSlot'] is Map ? (res['nextSlot'] as Map)['label']?.toString() : null;
        if (res['noSlotsToday'] == true) _nextSlotLabel ??= 'No slots today';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? JobCatalog.cancelPolicy;
      } else {
        _error = res['error']?.toString() ?? 'Could not load worker';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
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
    final res = await _api.addWorkerReview(widget.workerId, rating: rating, comment: comment.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Review saved' : (res['error']?.toString() ?? 'Failed'))),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _book() async {
    final w = _worker;
    if (w == null) return;
    final rate = (w['hourlyRate'] is num) ? (w['hourlyRate'] as num).toDouble() : 0.0;
    final hoursCtrl = TextEditingController(text: '1');
    final noteCtrl = TextEditingController();
    DateTime pickedDate = DateTime.now();
    String pickedTime = _slotsToday.isNotEmpty ? _slotsToday.first : '10:00';
    List<String> slots = List<String>.from(_slotsToday);
    final payload = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Book ${w['workerName'] ?? 'Worker'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_cancelPolicy ?? JobCatalog.cancelPolicy,
                    style: const TextStyle(fontSize: 12, color: WomenJobsWorkerDetailScreen.textGray)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(
                      '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: pickedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (d == null) return;
                    final key =
                        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                    final slotRes = await _api.workerSlots(widget.workerId, date: key);
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
                  const Text('No slots on this date',
                      style: TextStyle(color: WomenJobsWorkerDetailScreen.textGray))
                else
                  DropdownButtonFormField<String>(
                    initialValue: slots.contains(pickedTime) ? pickedTime : slots.first,
                    items: slots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setLocal(() => pickedTime = v ?? pickedTime),
                    decoration: const InputDecoration(labelText: 'Time'),
                  ),
                TextField(
                  controller: hoursCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Hours'),
                ),
                TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: slots.isEmpty
                  ? null
                  : () => Navigator.pop(ctx, {
                        'date':
                            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}',
                        'time': pickedTime,
                        'hours': hoursCtrl.text.trim(),
                        'note': noteCtrl.text.trim(),
                      }),
              child: const Text('Request'),
            ),
          ],
        ),
      ),
    );
    if (payload == null) return;
    final hours = int.tryParse(payload['hours'] ?? '1') ?? 1;
    final amount = rate * hours;
    final bookingDate = '${payload['date']}T${payload['time']}';
    final res = await _api.bookWorker(
      widget.workerId,
      bookingDate: bookingDate,
      totalAmount: amount,
      hours: hours,
      note: payload['note'] ?? '',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? (res['message']?.toString() ?? 'Booking requested')
            : (res['error']?.toString() ?? 'Booking failed')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = _worker;
    final image = _mediaUrl(w?['profileImageUrl']?.toString());
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WomenJobsWorkerDetailScreen.navy,
        title: Text(w?['workerName']?.toString() ?? 'Worker'),
        actions: [
          IconButton(
            icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border,
                color: WomenJobsWorkerDetailScreen.primary),
            onPressed: () async {
              final res = await _api.toggleWorkerFavorite(widget.workerId);
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
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: image.isEmpty
                            ? Container(
                                height: 180,
                                color: const Color(0xFFFFE4E6),
                                child: const Icon(Icons.work_outline, size: 44),
                              )
                            : Image.network(image, height: 180, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                      Text(w?['workerName']?.toString() ?? '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      Text('${w?['city'] ?? ''} ${w?['location'] ?? ''}',
                          style: const TextStyle(color: WomenJobsWorkerDetailScreen.textGray)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Chip(label: Text(JobCatalog.labelFor(w?['jobCategory']?.toString()))),
                          if (w?['jobSubCategory'] != null) Chip(label: Text('${w?['jobSubCategory']}')),
                          if (w?['hourlyRate'] != null) Chip(label: Text('₹${w?['hourlyRate']}/hr')),
                          if (w?['rating'] != null) Chip(label: Text('★ ${w?['rating']}')),
                          if (_nextSlotLabel != null) Chip(label: Text(_nextSlotLabel!)),
                          if (w?['doorService'] == true) const Chip(label: Text('Door service')),
                          if (w?['availableToday'] == true) const Chip(label: Text('Available today')),
                        ],
                      ),
                      if ((w?['bio']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(w!['bio'].toString()),
                      ],
                      if (_photos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 88,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _photos.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final url = _mediaUrl(_photos[i]);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: url.isEmpty
                                    ? Container(width: 88, color: const Color(0xFFE2E8F0))
                                    : Image.network(url, width: 88, height: 88, fit: BoxFit.cover),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _book,
                        style: FilledButton.styleFrom(
                          backgroundColor: WomenJobsWorkerDetailScreen.primary,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text('Book visit'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(onPressed: _writeReview, child: const Text('Write a review')),
                      if ((_cancelPolicy ?? '').isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(_cancelPolicy!,
                            style: const TextStyle(fontSize: 12, color: WomenJobsWorkerDetailScreen.textGray)),
                      ],
                      const SizedBox(height: 16),
                      const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 8),
                      if (_reviews.isEmpty)
                        const Text('No reviews yet', style: TextStyle(color: ModuleTheme.textGray))
                      else
                        ..._reviews.map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(r['userName']?.toString() ?? 'Member'),
                              subtitle: Text(r['comment']?.toString() ?? ''),
                              trailing: Text('★ ${r['rating'] ?? ''}'),
                            )),
                    ],
                  ),
                ),
    );
  }
}
