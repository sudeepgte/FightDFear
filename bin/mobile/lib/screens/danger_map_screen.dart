import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../widgets/safety_map.dart';

/// Danger points on Google Maps + list below.
class DangerMapScreen extends StatefulWidget {
  const DangerMapScreen({super.key});

  @override
  State<DangerMapScreen> createState() => _DangerMapScreenState();
}

class _DangerMapScreenState extends State<DangerMapScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _points = [];
  double? _userLat;
  double? _userLng;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _loadUserLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      if (!await Geolocator.isLocationServiceEnabled()) return;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      _userLat = pos.latitude;
      _userLng = pos.longitude;
    } catch (_) {}
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _loadUserLocation();
      if (!mounted) return;
      final res = await context.read<AuthState>().api.get('/danger-points');
      if (!mounted) return;
      if (res['_status'] == 401) {
        setState(() {
          _error = 'Please sign in to view danger points';
          _loading = false;
        });
        return;
      }
      final raw = res['data'];
      final list = raw is List ? raw : <dynamic>[];
      final parsed = list
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList()
        ..sort((a, b) {
          final sa = a['severity'] is int
              ? a['severity'] as int
              : int.tryParse('${a['severity']}') ?? 0;
          final sb = b['severity'] is int
              ? b['severity'] as int
              : int.tryParse('${b['severity']}') ?? 0;
          return sb.compareTo(sa);
        });
      setState(() {
        _points = parsed;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  List<MapPin> _mapPins() {
    return _points.map((p) {
      final severity = p['severity'] is int
          ? p['severity'] as int
          : int.tryParse('${p['severity']}') ?? 1;
      final lat = (p['lat'] is num) ? (p['lat'] as num).toDouble() : double.tryParse('${p['lat']}') ?? 0;
      final lng = (p['lng'] is num) ? (p['lng'] as num).toDouble() : double.tryParse('${p['lng']}') ?? 0;
      return MapPin(
        id: '${p['id'] ?? '$lat,$lng'}',
        lat: lat,
        lng: lng,
        title: p['category']?.toString() ?? 'Danger',
        snippet: 'Severity $severity',
        severity: severity,
      );
    }).toList();
  }

  Color _severityColor(int severity) {
    if (severity >= 4) return const Color(0xFFDC2626);
    if (severity >= 3) return const Color(0xFFF43F5E);
    if (severity >= 2) return const Color(0xFFF59E0B);
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danger Map'),
        actions: [
          IconButton(onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh)),
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
                        const SizedBox(height: 16),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: SafetyMapView(
                          pins: _mapPins(),
                          userLat: _userLat,
                          userLng: _userLng,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: Row(
                        children: [
                          Text(
                            'Reported danger points (${_points.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                          const Spacer(),
                          _LegendDot(color: const Color(0xFFDC2626), label: 'High'),
                          const SizedBox(width: 8),
                          _LegendDot(color: const Color(0xFFF59E0B), label: 'Med'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RefreshIndicator(
                        onRefresh: _load,
                        child: _points.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 40),
                                  Center(
                                    child: Text(
                                      'No verified danger points on the map yet.',
                                      style: TextStyle(color: Color(0xFF64748B)),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: _points.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 8),
                                itemBuilder: (context, i) {
                                  final p = _points[i];
                                  final severity = p['severity'] is int
                                      ? p['severity'] as int
                                      : int.tryParse('${p['severity']}') ?? 1;
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: _severityColor(severity).withValues(alpha: 0.3),
                                      ),
                                    ),
                                    tileColor: Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          _severityColor(severity).withValues(alpha: 0.15),
                                      child: Text(
                                        '$severity',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: _severityColor(severity),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      p['category']?.toString() ?? 'general',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      'Lat ${p['lat']}, Lng ${p['lng']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }
}
