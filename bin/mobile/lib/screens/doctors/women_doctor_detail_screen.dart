import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/doctor_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';
import 'women_doctor_booking_screen.dart';

class WomenDoctorDetailScreen extends StatefulWidget {
  const WomenDoctorDetailScreen({
    super.key,
    required this.doctorId,
    this.initialSummary,
  });

  final int doctorId;
  final Map<String, dynamic>? initialSummary;

  @override
  State<WomenDoctorDetailScreen> createState() => _WomenDoctorDetailScreenState();
}

class _WomenDoctorDetailScreenState extends State<WomenDoctorDetailScreen> {
  late final DoctorService _svc;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _doctor = {};

  @override
  void initState() {
    super.initState();
    _svc = DoctorService(context.read<AuthState>().api);
    if (widget.initialSummary != null) {
      _doctor = Map<String, dynamic>.from(widget.initialSummary!);
    }
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.detail(widget.doctorId);
      if (!mounted) return;
      if (res['success'] == true && res['doctor'] is Map) {
        _doctor = Map<String, dynamic>.from(res['doctor'] as Map);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load doctor';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _book() async {
    final booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => WomenDoctorBookingScreen(
          doctorId: widget.doctorId,
          doctorSummary: _doctor,
        ),
      ),
    );
    if (booked == true && mounted) Navigator.of(context).pop(true);
  }

  Future<void> _openMaps() async {
    final raw = _doctor['googleMapLocation']?.toString().trim() ?? '';
    if (raw.isEmpty) return;
    final uri = Uri.tryParse(raw);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final name = _doctor['fullName']?.toString() ?? 'Doctor';
    final display = name.startsWith('Dr') ? name : 'Dr. $name';
    final spec = _doctor['specialization']?.toString() ?? '';
    final rating = (_doctor['rating'] is num)
        ? (_doctor['rating'] as num).toDouble()
        : double.tryParse('${_doctor['rating']}') ?? 0;
    final fee = (_doctor['consultationFee'] is num)
        ? (_doctor['consultationFee'] as num).toDouble()
        : double.tryParse('${_doctor['consultationFee']}') ?? 0;
    final photo = ModuleTheme.mediaUrl(
      context.read<AuthState>().api.baseUrl,
      _doctor['profilePhotoPath']?.toString(),
    );
    final modes = DoctorCatalog.consultationModesOf(_doctor);
    final slots = DoctorCatalog.parseAvailabilitySlots(_doctor['availabilitySlots']);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        actions: [
          IconButton(
            tooltip: _doctor['favourite'] == true ? 'Saved' : 'Save doctor',
            onPressed: () async {
              final fav = _doctor['favourite'] == true;
              final res = fav
                  ? await _svc.removeFavorite(widget.doctorId)
                  : await _svc.addFavorite(widget.doctorId);
              if (!mounted) return;
              if (res['success'] == true || res['favourite'] != null) {
                setState(() => _doctor['favourite'] = !fav);
              }
            },
            icon: Icon(_doctor['favourite'] == true ? Icons.favorite : Icons.favorite_border, color: ModuleTheme.primary),
          ),
        ],
      ),
      body: _loading && _doctor.isEmpty
          ? ModuleTheme.loading()
          : _error != null && _doctor.isEmpty
              ? ModuleTheme.errorView(_error!, _load)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFFFFE4E6),
                            backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                            child: photo.isEmpty
                                ? Text(
                                    display.isNotEmpty ? display.characters.first : 'D',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: ModuleTheme.primary,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(display, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                if (spec.isNotEmpty)
                                  Text(spec, style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w600)),
                                if ((_doctor['city']?.toString() ?? '').isNotEmpty)
                                  Text(
                                    [
                                      _doctor['city'],
                                      _doctor['state'],
                                    ].where((e) => e != null && e.toString().isNotEmpty).join(', '),
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 4),
                                    Text(rating > 0 ? rating.toStringAsFixed(1) : 'New',
                                        style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 12),
                                    Text(
                                      fee > 0 ? 'From ₹${fee.toStringAsFixed(0)}' : 'Fee on request',
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: ModuleTheme.primary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if ((_doctor['qualification']?.toString() ?? '').isNotEmpty ||
                        _doctor['experienceYears'] != null)
                      _card(
                        title: 'Professional',
                        child: Text(
                          [
                            if ((_doctor['qualification']?.toString() ?? '').isNotEmpty)
                              _doctor['qualification'].toString(),
                            if (_doctor['experienceYears'] != null)
                              '${_doctor['experienceYears']} years experience',
                            if ((_doctor['hospitalName']?.toString() ?? '').isNotEmpty)
                              _doctor['hospitalName'].toString(),
                          ].join('\n'),
                        ),
                      ),
                    if ((_doctor['bio']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _card(title: 'About', child: Text(_doctor['bio'].toString())),
                    ],
                    const SizedBox(height: 12),
                    _card(
                      title: 'Consultation modes',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: modes
                            .map((m) => Chip(label: Text(DoctorCatalog.modeLabel(m))))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      title: 'Availability',
                      child: slots.isEmpty
                          ? Text(
                              [
                                _doctor['availableDays'] ?? 'Days not set',
                                if (_doctor['startTime'] != null) '${_doctor['startTime']} – ${_doctor['endTime'] ?? ''}',
                              ].join('\n'),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: slots
                                  .map((s) => Text('${s['day']}: ${s['start']} – ${s['end']}'))
                                  .toList(),
                            ),
                    ),
                    if ((_doctor['languages']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _card(title: 'Languages', child: Text(_doctor['languages'].toString())),
                    ],
                    if ((_doctor['services']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _card(title: 'Services', child: Text(_doctor['services'].toString())),
                    ],
                    if ((_doctor['clinicAddress']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _card(
                        title: 'Clinic',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_doctor['clinicAddress'].toString()),
                            if ((_doctor['googleMapLocation']?.toString() ?? '').isNotEmpty)
                              TextButton.icon(
                                onPressed: _openMaps,
                                icon: const Icon(Icons.map_outlined),
                                label: const Text('Open in Google Maps'),
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _card(
                      title: 'Reviews',
                      child: Builder(
                        builder: (_) {
                          final reviews = ModuleTheme.toList(_doctor['reviews']);
                          if (reviews.isEmpty) {
                            return const Text('No reviews yet');
                          }
                          return Column(
                            children: reviews.take(8).map((r) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text('${r['userName'] ?? 'Patient'} · ${r['rating'] ?? '-'}★'),
                                subtitle: Text(r['comment']?.toString() ?? ''),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                    Builder(
                      builder: (_) {
                        final photos = _doctor['clinicPhotos'];
                        final list = photos is List
                            ? photos.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
                            : DoctorCatalog.splitCsv(photos?.toString());
                        if (list.isEmpty) return const SizedBox.shrink();
                        return Column(
                          children: [
                            const SizedBox(height: 12),
                            _card(
                              title: 'Clinic photos',
                              child: SizedBox(
                                height: 110,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: list.length,
                                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                                  itemBuilder: (_, i) {
                                    final url = ModuleTheme.mediaUrl(
                                      context.read<AuthState>().api.baseUrl,
                                      list[i],
                                    );
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(url, width: 140, height: 110, fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Container(
                                                width: 140,
                                                color: Colors.grey.shade200,
                                                child: const Icon(Icons.storefront_outlined),
                                              )),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (DoctorCatalog.bookableDates(_doctor).isEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'No slots this week. Check back later or try Instant Consult from the list.',
                        style: TextStyle(color: Color(0xFFB45309)),
                      ),
                    ],
                  ],
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _book,
            icon: const Icon(Icons.event_available),
            label: const Text('Book appointment'),
            style: FilledButton.styleFrom(
              backgroundColor: ModuleTheme.primary,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
