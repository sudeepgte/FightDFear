import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';
import 'fitness_booking_screen.dart';

/// Member: full trainer profile before booking.
class FitnessTrainerDetailScreen extends StatefulWidget {
  const FitnessTrainerDetailScreen({
    super.key,
    required this.trainerId,
    this.initialSummary,
  });

  final int trainerId;
  final Map<String, dynamic>? initialSummary;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<FitnessTrainerDetailScreen> createState() => _FitnessTrainerDetailScreenState();
}

class _FitnessTrainerDetailScreenState extends State<FitnessTrainerDetailScreen> {
  late final FitnessService _svc;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _trainer = {};

  @override
  void initState() {
    super.initState();
    _svc = FitnessService(context.read<AuthState>().api);
    if (widget.initialSummary != null) {
      _trainer = Map<String, dynamic>.from(widget.initialSummary!);
    }
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.trainerDetail(widget.trainerId);
      if (!mounted) return;
      if (res['success'] == true) {
        final t = res['trainer'];
        _trainer = t is Map ? Map<String, dynamic>.from(t) : _trainer;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load trainer';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openBooking() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FitnessBookingScreen(
          trainerId: widget.trainerId,
          trainerSummary: _trainer,
        ),
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final name = _trainer['fullName']?.toString() ?? 'Trainer';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'T';
    final rating = (_trainer['rating'] is num)
        ? (_trainer['rating'] as num).toDouble()
        : double.tryParse('${_trainer['rating']}') ?? 0;
    final fees = (_trainer['sessionFees'] is num)
        ? (_trainer['sessionFees'] as num).toDouble()
        : double.tryParse('${_trainer['sessionFees']}') ?? 0;
    final online = _trainer['onlineAvailable'] != false;
    final baseUrl = context.read<AuthState>().api.baseUrl;
    final photo = _trainer['profilePhotoPath']?.toString();
    final photoUrl = photo != null && photo.isNotEmpty
        ? (photo.startsWith('http') ? photo : '$baseUrl$photo')
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Trainer Profile'),
        backgroundColor: Colors.white,
        foregroundColor: FitnessTrainerDetailScreen.navy,
      ),
      body: _loading && _trainer.isEmpty
          ? ModuleTheme.loading()
          : _error != null && _trainer.isEmpty
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
                            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                            child: photoUrl == null
                                ? Text(initial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: FitnessTrainerDetailScreen.primary))
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                                if ((_trainer['city']?.toString() ?? '').isNotEmpty)
                                  Text(_trainer['city'].toString(),
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                                    const SizedBox(width: 4),
                                    Text(rating > 0 ? rating.toStringAsFixed(1) : 'New',
                                        style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: online ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        online ? 'Available' : 'Unavailable',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: online ? const Color(0xFF166534) : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('From ₹${fees.toStringAsFixed(0)} / session',
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: FitnessTrainerDetailScreen.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if ((_trainer['specializations']?.toString() ?? '').isNotEmpty) ...[
                      _card(
                        title: 'Specializations',
                        child: Text(_trainer['specializations'].toString()),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if ((_trainer['bio']?.toString() ?? '').isNotEmpty) ...[
                      _card(title: 'About', child: Text(_trainer['bio'].toString())),
                      const SizedBox(height: 12),
                    ],
                    _card(
                      title: 'Experience & availability',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_trainer['experienceYears'] != null)
                            Text('${_trainer['experienceYears']} years experience'),
                          if ((_trainer['availableTimings']?.toString() ?? '').isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text('Slots: ${_trainer['availableTimings']}'),
                          ],
                          if ((_trainer['serviceType']?.toString() ?? '').isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text('Service: ${_trainer['serviceType']}'),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      title: 'Packages',
                      child: Column(
                        children: ModuleTheme.toList(_trainer['packages']).map((p) {
                          final m = Map<String, dynamic>.from(p as Map);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(m['label']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: Text('₹${m['fees']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: online ? _openBooking : null,
            icon: const Icon(Icons.event_available),
            label: Text(online ? 'Book a session' : 'Trainer unavailable'),
            style: FilledButton.styleFrom(
              backgroundColor: FitnessTrainerDetailScreen.primary,
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
