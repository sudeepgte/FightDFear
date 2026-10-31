import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/safety_map.dart';

/// Danger points on Google Maps + list below.
class DangerMapScreen extends StatefulWidget {
  const DangerMapScreen({super.key});

  @override
  State<DangerMapScreen> createState() => _DangerMapScreenState();
}

class _DangerMapScreenState extends State<DangerMapScreen> {
  static const Color _primary = Color(0xFFF43F5E);

  bool _loading = true;
  bool _reporting = false;
  String? _error;
  List<Map<String, dynamic>> _points = [];
  double? _userLat;
  double? _userLng;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Position?> _currentPosition({bool showErrors = false}) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (showErrors && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                permission == LocationPermission.deniedForever
                    ? 'Location permanently denied — enable it in Settings'
                    : 'Location permission is required',
              ),
            ),
          );
        }
        return null;
      }
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (showErrors && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Turn on GPS / Location services')),
          );
        }
        return null;
      }
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (_) {
      if (showErrors && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get GPS location')),
        );
      }
      return null;
    }
  }

  Future<void> _loadUserLocation() async {
    final pos = await _currentPosition();
    if (pos != null) {
      _userLat = pos.latitude;
      _userLng = pos.longitude;
    }
  }

  List<Map<String, dynamic>> _parsePoints(Map<String, dynamic> res) {
    dynamic raw = res['data'];
    if (raw is! List && res['points'] is List) raw = res['points'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
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
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _loadUserLocation();
      if (!mounted) return;
      // List endpoint is public; still send token when available.
      final res = await context.read<AuthState>().api.get(
            '/danger-points',
            auth: true,
            timeout: const Duration(seconds: 20),
          );
      if (!mounted) return;
      if (res['_status'] == 401) {
        setState(() {
          _error = 'Please sign in to view danger points';
          _loading = false;
        });
        return;
      }
      if (res['_status'] != null && (res['_status'] as int) >= 400) {
        setState(() {
          _error = res['error']?.toString() ?? 'Could not load danger points';
          _loading = false;
        });
        return;
      }
      setState(() {
        _points = _parsePoints(res);
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

  Future<void> _reportHere() async {
    if (_reporting) return;
    final auth = context.read<AuthState>();
    if (!auth.loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to report a danger point')),
      );
      return;
    }

    final categoryCtrl = TextEditingController(text: 'general');
    final noteCtrl = TextEditingController();
    int severity = 3;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Report danger here'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Uses your current GPS location. Reports appear on the map after admin verification.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'harassment, poorly lit, …',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Severity: $severity', style: const TextStyle(fontWeight: FontWeight.w600)),
                Slider(
                  value: severity.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$severity',
                  activeColor: _primary,
                  onChanged: (v) => setLocal(() => severity = v.round()),
                ),
                TextField(
                  controller: noteCtrl,
                  maxLength: 200,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _primary),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );

    final category = categoryCtrl.text.trim();
    final note = noteCtrl.text.trim();
    categoryCtrl.dispose();
    noteCtrl.dispose();
    if (confirmed != true || !mounted) return;

    setState(() => _reporting = true);
    final pos = await _currentPosition(showErrors: true);
    if (!mounted) return;
    if (pos == null) {
      setState(() => _reporting = false);
      return;
    }

    try {
      final fields = <String, String>{
        'lat': pos.latitude.toString(),
        'lng': pos.longitude.toString(),
        'severity': '$severity',
        'category': category.isEmpty ? 'general' : category,
      };
      if (note.isNotEmpty) fields['note'] = note;

      final res = await auth.api.postForm('/danger-points', fields: fields);
      if (!mounted) return;
      final ok = res['ok'] == true || res['success'] == true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? (res['message']?.toString() ??
                    'Report submitted — visible after admin approval')
                : (res['error']?.toString() ??
                    res['message']?.toString() ??
                    'Could not submit report'),
          ),
        ),
      );
      if (ok) await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report failed: $e')),
        );
      }
    }
    if (mounted) setState(() => _reporting = false);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _reporting ? null : _reportHere,
        backgroundColor: _primary,
        icon: _reporting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.add_location_alt_outlined),
        label: Text(_reporting ? 'Reporting…' : 'Report here'),
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
                            'Verified points (${_points.length})',
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(
                                        'No verified danger points on the map yet.\nUse “Report here” to submit one (needs admin approval).',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Color(0xFF64748B)),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
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
