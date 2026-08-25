import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_state.dart';
import '../../services/martial_arts_service.dart';
import 'martial_arts_enroll_screen.dart';

class MartialArtsCentreScreen extends StatefulWidget {
  const MartialArtsCentreScreen({super.key, required this.centreId});

  final int centreId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<MartialArtsCentreScreen> createState() => _MartialArtsCentreScreenState();
}

class _MartialArtsCentreScreenState extends State<MartialArtsCentreScreen> {
  late final MartialArtsService _api;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _centre;

  @override
  void initState() {
    super.initState();
    _api = MartialArtsService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.centreDetail(widget.centreId);
      if (!mounted) return;
      if (res['success'] == true && res['centre'] is Map) {
        _centre = Map<String, dynamic>.from(res['centre'] as Map);
      } else {
        _error = res['error']?.toString() ?? 'Centre not found';
      }
    } catch (e) {
      if (mounted) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _call(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final uri = Uri.parse('tel:${phone.trim()}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _enroll(Map<String, dynamic> batch) async {
    final id = batch['id'] is int ? batch['id'] as int : int.tryParse('${batch['id']}');
    if (id == null || _centre == null) return;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => MartialArtsEnrollScreen(
          centre: _centre!,
          batch: batch,
        ),
      ),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment submitted')),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _centre;
    final photo = _mediaUrl(c?['profilePhoto']?.toString());
    final batches = (c?['batches'] is List)
        ? (c!['batches'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreScreen.navy,
        elevation: 0.5,
        title: Text(
          c?['name']?.toString() ?? 'Centre',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(c?['favorite'] == true ? Icons.favorite : Icons.favorite_border, color: MartialArtsCentreScreen.primary),
            onPressed: () async {
              final id = widget.centreId;
              final res = c?['favorite'] == true
                  ? await _api.removeFavorite(id)
                  : await _api.addFavorite(id);
              if (res['success'] == true) _load();
            },
          ),
          if (c?['phoneNumber'] != null)
            IconButton(
              icon: const Icon(Icons.phone_outlined),
              onPressed: () => _call(c!['phoneNumber']?.toString()),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        TextButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: MartialArtsCentreScreen.primary,
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                    children: [
                      if (photo.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              photo,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFFFE4E6),
                                child: const Icon(Icons.sports_martial_arts, size: 48),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      Text(
                        c?['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: MartialArtsCentreScreen.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [c?['city'], c?['state'], c?['pincode'], c?['location']]
                            .where((e) => e != null && '$e'.trim().isNotEmpty)
                            .join(', '),
                        style: const TextStyle(color: MartialArtsCentreScreen.textGray),
                      ),
                      if (c?['availabilityLabel'] != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${c!['availabilityLabel']}',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: MartialArtsCentreScreen.primary),
                        ),
                      ],
                      if (c?['trialAvailable'] == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text('Trial class available', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      if ((c?['rating'] is num) && (c!['rating'] as num) > 0)
                        Text(
                          '${c['rating']}★ · ${(c['count'] ?? ((c['reviews'] is List) ? (c['reviews'] as List).length : 0))} reviews',
                        ),
                      if (c?['about'] != null && '${c!['about']}'.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'About',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${c['about']}',
                          style: const TextStyle(height: 1.4, color: MartialArtsCentreScreen.textGray),
                        ),
                      ],
                      if (c?['whatWeOffer'] != null && '${c!['whatWeOffer']}'.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'What we offer',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${c['whatWeOffer']}',
                          style: const TextStyle(height: 1.4, color: MartialArtsCentreScreen.textGray),
                        ),
                      ],
                      if (c?['galleryPhotos'] is List && (c!['galleryPhotos'] as List).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('Photos', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: (c['galleryPhotos'] as List)
                                .map((p) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _mediaUrl(p.toString()),
                                          width: 140,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => const SizedBox(width: 140),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _ReviewsBlock(centre: c!, api: _api, onChanged: _load),
                      const SizedBox(height: 20),
                      const Text(
                        'Batches',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      if (batches.isEmpty)
                        const Text(
                          'No open batches right now.',
                          style: TextStyle(color: MartialArtsCentreScreen.textGray),
                        )
                      else
                        ...batches.map((b) => _BatchCard(batch: b, onEnroll: () => _enroll(b))),
                    ],
                  ),
                ),
    );
  }
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({required this.batch, required this.onEnroll});

  final Map<String, dynamic> batch;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    final free = batch['free'] == true;
    final fee = batch['fee'];
    final feeText = free
        ? 'Free'
        : fee == null
            ? 'Fee on request'
            : '₹${(fee is num ? fee.toDouble() : double.tryParse('$fee') ?? 0).toStringAsFixed(0)}';
    final full = (batch['status']?.toString().toLowerCase() == 'full') ||
        (batch['seatsLeft'] is num && (batch['seatsLeft'] as num) <= 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  batch['name']?.toString() ?? 'Batch',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: MartialArtsCentreScreen.navy,
                  ),
                ),
              ),
              Text(
                feeText,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: free ? Colors.green.shade700 : MartialArtsCentreScreen.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            [
              batch['style'],
              batch['batchType'],
              batch['skillLevel'],
              batch['timeSlot'],
            ].where((e) => e != null && '$e'.isNotEmpty).join(' · '),
            style: const TextStyle(color: MartialArtsCentreScreen.textGray, fontSize: 13),
          ),
          if (batch['instructor'] != null) ...[
            const SizedBox(height: 4),
            Text('Instructor: ${batch['instructor']}', style: const TextStyle(fontSize: 13)),
          ],
          if (batch['availableDays'] != null) ...[
            const SizedBox(height: 4),
            Text('Days: ${batch['availableDays']}', style: const TextStyle(fontSize: 13)),
          ],
          if (batch['seatsLeft'] != null) ...[
            const SizedBox(height: 4),
            Text(
              (batch['seatsLeft'] is num && (batch['seatsLeft'] as num) <= 0)
                  ? 'No seats this week'
                  : 'Seats left: ${batch['seatsLeft']}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
          if (batch['batchToday'] == true)
            const Text('Batch today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A34A))),
          if (batch['trialType'] != null && batch['trialType'].toString() != 'None')
            Text('Trial: ${batch['trialType']}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: full ? null : onEnroll,
              style: FilledButton.styleFrom(
                backgroundColor: MartialArtsCentreScreen.primary,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(full ? 'No seats this week' : 'Enroll'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsBlock extends StatefulWidget {
  const _ReviewsBlock({required this.centre, required this.api, required this.onChanged});
  final Map<String, dynamic> centre;
  final MartialArtsService api;
  final VoidCallback onChanged;

  @override
  State<_ReviewsBlock> createState() => _ReviewsBlockState();
}

class _ReviewsBlockState extends State<_ReviewsBlock> {
  int _rating = 5;
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = (widget.centre['reviews'] is List)
        ? (widget.centre['reviews'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : <Map<String, dynamic>>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Reviews & ratings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 8),
        if (reviews.isEmpty) const Text('No reviews yet', style: TextStyle(color: MartialArtsCentreScreen.textGray)),
        ...reviews.take(5).map((r) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${r['userName'] ?? 'Member'} · ${r['rating'] ?? ''}★'),
              subtitle: Text(r['comment']?.toString() ?? ''),
            )),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            5,
            (i) => IconButton(
              onPressed: () => setState(() => _rating = i + 1),
              icon: Icon(i < _rating ? Icons.star : Icons.star_border, color: Colors.amber),
            ),
          ),
        ),
        TextField(
          controller: _comment,
          decoration: const InputDecoration(labelText: 'Your review', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _busy
              ? null
              : () async {
                  final id = widget.centre['id'] is int
                      ? widget.centre['id'] as int
                      : int.tryParse('${widget.centre['id']}');
                  if (id == null) return;
                  setState(() => _busy = true);
                  final res = await widget.api.addReview(id, rating: _rating, comment: _comment.text.trim());
                  if (!mounted) return;
                  setState(() => _busy = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? 'Done')),
                  );
                  if (res['success'] == true) widget.onChanged();
                },
          child: const Text('Submit review'),
        ),
      ],
    );
  }
}
