import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_state.dart';
import '../services/sos_service.dart';
import '../widgets/safety_map.dart';
import 'contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _sosRed = Color(0xFFB71C1C);
  static const Color _navy = Color(0xFF1E1B4B);

  bool _bootstrapping = true;
  bool _triggering = false;
  bool _countdownActive = false;
  int _countdown = 15;
  Timer? _countdownTimer;
  Timer? _pollTimer;

  int? _activeSosId;
  Map<String, dynamic>? _status;
  String? _banner;
  String? _autoCallPhone;
  String? _mapsLink;
  int _contactCount = 0;

  late SosService _sos;

  @override
  void initState() {
    super.initState();
    _sos = SosService(context.read<AuthState>().api);
    _bootstrap();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() => _bootstrapping = true);
    try {
      await _loadContactCount();
      final active = await _sos.getActive();
      if (!mounted) return;
      if (active['success'] == true && active['active'] == true) {
        final id = _asInt(active['sosId']);
        if (id != null) {
          _activeSosId = id;
          _autoCallPhone = active['autoCallPhone']?.toString();
          _mapsLink = active['mapsLink']?.toString();
          await _refreshStatus();
          _startPolling();
        }
      }
    } catch (e) {
      if (mounted) _banner = 'Could not reach server: $e';
    }
    if (mounted) setState(() => _bootstrapping = false);
  }

  Future<void> _loadContactCount() async {
    try {
      final res = await context.read<AuthState>().api.get('/api/me/trusted-contacts');
      if (res['success'] == true && res['contacts'] is List) {
        _contactCount = (res['contacts'] as List).length;
      }
    } catch (_) {}
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _refreshStatus());
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> _refreshStatus() async {
    final id = _activeSosId;
    if (id == null) return;
    try {
      final res = await _sos.getStatus(id);
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _status = res;
          _autoCallPhone = res['autoCallPhone']?.toString() ?? _autoCallPhone;
          _mapsLink = res['mapsLink']?.toString() ?? _mapsLink;
        });
        final status = res['status']?.toString().toUpperCase();
        if (status == 'CANCELLED' || status == 'RESOLVED') {
          _stopPolling();
          setState(() {
            _activeSosId = null;
            _status = null;
            _banner = 'SOS ended ($status)';
          });
        }
      }
    } catch (_) {}
  }

  void _beginCountdown() {
    if (_activeSosId != null || _triggering || _countdownActive) return;
    if (_contactCount == 0) {
      _confirmSosWithoutTrustedContacts();
      return;
    }
    _startCountdown();
  }

  void _startCountdown() {
    HapticFeedback.heavyImpact();
    setState(() {
      _countdownActive = true;
      _countdown = 15;
      _banner = null;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdownActive = false);
        _executeSos();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  Future<void> _confirmSosWithoutTrustedContacts() async {
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('No trusted contacts'),
        content: const Text(
          'You have not added trusted contacts yet. SOS works best when contacts can be notified.\n\n'
          'If you added an emergency number at registration, that may still be used.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, 'add'), child: const Text('Add contacts')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _sosRed),
            onPressed: () => Navigator.pop(ctx, 'continue'),
            child: const Text('Send SOS anyway'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (choice == 'add') {
      await _openContactsAndRefresh();
    } else if (choice == 'continue') {
      _startCountdown();
    }
  }

  Future<void> _openContactsAndRefresh() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ContactsScreen()),
    );
    if (!mounted) return;
    await _loadContactCount();
    setState(() {});
  }

  Future<Position?> _currentPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _banner = permission == LocationPermission.deniedForever
              ? 'Location permanently denied — enable it in phone Settings for SOS'
              : 'Location permission is required for SOS';
        });
      }
      return null;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        setState(() => _banner = 'Turn on GPS / Location services to send SOS');
      }
      return null;
    }
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _banner = 'Could not get GPS location. Try again outdoors.');
      }
      return null;
    }
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownActive = false;
      _countdown = 15;
      _banner = 'SOS cancelled — false alarm';
    });
  }

  Future<void> _executeSos() async {
    setState(() {
      _triggering = true;
      _banner = 'Getting your location…';
    });

    final pos = await _currentPosition();
    if (!mounted) return;
    if (pos == null) {
      setState(() {
        _triggering = false;
        _banner ??= 'Location permission / GPS required for SOS';
      });
      return;
    }

    setState(() => _banner = 'Sending emergency alerts…');
    try {
      final res = await _sos.trigger(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        final id = _asInt(res['sosId']);
        setState(() {
          _activeSosId = id;
          _autoCallPhone = res['autoCallPhone']?.toString();
          _mapsLink = res['mapsLink']?.toString();
          _triggering = false;
          _banner = res['message']?.toString() ??
              'SOS activated · ${res['contactsNotified'] ?? 0} contacts notified';
        });
        if (id != null) {
          await _refreshStatus();
          _startPolling();
          await _promptAutoCall();
        }
      } else {
        setState(() {
          _triggering = false;
          _banner = res['error']?.toString() ?? 'SOS failed';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _triggering = false;
        _banner = 'Network error: $e';
      });
    }
  }

  Future<void> _promptAutoCall() async {
    final phone = _autoCallPhone;
    if (phone == null || phone.isEmpty || phone == 'null') return;
    final call = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Call for help?'),
        content: Text('Dial your emergency contact now?\n\n$phone'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _sosRed),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Call now'),
          ),
        ],
      ),
    );
    if (call == true) await _callEmergency();
  }

  Future<void> _callEmergency() async {
    final phone = _autoCallPhone;
    if (phone == null || phone.isEmpty) {
      _showSnack('No emergency phone number available');
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showSnack('Cannot open phone dialer');
    }
  }

  Future<void> _openMaps() async {
    final link = _mapsLink ?? _status?['mapsLink']?.toString();
    if (link == null || link.isEmpty) {
      _showSnack('No location link available');
      return;
    }
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnack('Cannot open maps');
    }
  }

  Future<void> _cancelActiveSos() async {
    final id = _activeSosId;
    if (id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel SOS?'),
        content: const Text('This will stop the active emergency alert.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep active')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel SOS'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    try {
      final res = await _sos.cancel(id);
      if (!mounted) return;
      _stopPolling();
      setState(() {
        _activeSosId = null;
        _status = null;
        _banner = res['message']?.toString() ?? 'SOS cancelled';
      });
    } catch (e) {
      _showSnack('Cancel failed: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v');
  }

  bool get _isActive => _activeSosId != null;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: _isActive ? const Color(0xFFFFF1F2) : null,
      appBar: AppBar(
        title: Text(_isActive ? 'SOS Active' : 'SOS Emergency'),
        backgroundColor: _isActive ? _sosRed : null,
        foregroundColor: _isActive ? Colors.white : null,
        actions: [
          IconButton(
            tooltip: 'Trusted contacts',
            onPressed: _openContactsAndRefresh,
            icon: const Icon(Icons.contacts_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_bootstrapping)
            const Center(child: CircularProgressIndicator())
          else if (_isActive)
            _ActiveSosBody(
              status: _status,
              sosId: _activeSosId!,
              autoCallPhone: _autoCallPhone,
              onCall: _callEmergency,
              onMaps: _openMaps,
              onCancel: _cancelActiveSos,
              onRefresh: _refreshStatus,
            )
          else
            _IdleSosBody(
              name: auth.name ?? 'there',
              email: auth.email ?? '',
              contactCount: _contactCount,
              triggering: _triggering,
              banner: _banner,
              onSosTap: _beginCountdown,
              onManageContacts: _openContactsAndRefresh,
            ),
          if (_countdownActive)
            Positioned.fill(
              child: _CountdownOverlay(
                value: _countdown,
                total: 15,
                onCancel: _cancelCountdown,
              ),
            ),
        ],
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({
    required this.value,
    required this.total,
    required this.onCancel,
  });

  final int value;
  final int total;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final progress = (total - value) / total;

    return Material(
      color: Colors.black.withValues(alpha: 0.92),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 48),
            const SizedBox(height: 16),
            const Text(
              'SOS COUNTDOWN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  Text(
                    '$value',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              value == 1 ? 'Sending SOS now…' : 'seconds until SOS is sent',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Tap cancel if this was pressed by accident.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 36),
            FilledButton.icon(
              onPressed: onCancel,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFB71C1C),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              icon: const Icon(Icons.close),
              label: const Text('Cancel SOS', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleSosBody extends StatelessWidget {
  const _IdleSosBody({
    required this.name,
    required this.email,
    required this.contactCount,
    required this.triggering,
    required this.onSosTap,
    required this.onManageContacts,
    this.banner,
  });

  final String name;
  final String email;
  final int contactCount;
  final bool triggering;
  final String? banner;
  final VoidCallback onSosTap;
  final VoidCallback onManageContacts;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Hi $name', style: Theme.of(context).textTheme.titleLarge),
            Text(email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
            if (contactCount == 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Add trusted contacts first so SOS can notify them.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            Center(
              child: Semantics(
                button: true,
                label: 'Start SOS countdown',
                child: Material(
                  color: const Color(0xFFB71C1C),
                  shape: const CircleBorder(),
                  elevation: 8,
                  shadowColor: const Color(0x66B71C1C),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: triggering ? null : onSosTap,
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Center(
                        child: triggering
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'SOS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tap to start',
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '15-second countdown before alert is sent',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
            if (banner != null) ...[
              const SizedBox(height: 12),
              Text(banner!, textAlign: TextAlign.center),
            ],
            const Spacer(),
            OutlinedButton.icon(
              onPressed: onManageContacts,
              icon: const Icon(Icons.people_outline),
              label: Text('Trusted contacts ($contactCount)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSosBody extends StatelessWidget {
  const _ActiveSosBody({
    required this.status,
    required this.sosId,
    required this.onCall,
    required this.onMaps,
    required this.onCancel,
    required this.onRefresh,
    this.autoCallPhone,
  });

  final Map<String, dynamic>? status;
  final int sosId;
  final String? autoCallPhone;
  final VoidCallback onCall;
  final VoidCallback onMaps;
  final VoidCallback onCancel;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final contacts = status?['contacts'] is List ? status!['contacts'] as List : <dynamic>[];
    final volunteers = status?['volunteers'] is List ? status!['volunteers'] as List : <dynamic>[];
    final accepted = status?['contactsAccepted'] ?? 0;
    final pending = status?['contactsPending'] ?? 0;
    final volAccepted = status?['volunteersAccepted'] ?? 0;
    final lat = status?['latitude'];
    final lng = status?['longitude'];
    final userLat = lat is num ? lat.toDouble() : double.tryParse('$lat');
    final userLng = lng is num ? lng.toDouble() : double.tryParse('$lng');

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.emergency, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'EMERGENCY SOS ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Alert #$sosId · ${status?['status'] ?? 'ACTIVE'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatPill(label: 'Accepted', value: '$accepted'),
                    const SizedBox(width: 8),
                    _StatPill(label: 'Pending', value: '$pending'),
                    const SizedBox(width: 8),
                    _StatPill(label: 'Volunteers', value: '$volAccepted'),
                  ],
                ),
              ],
            ),
          ),
          if (userLat != null && userLng != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Your location',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _HomeScreenState._navy),
            ),
            const SizedBox(height: 8),
            SafetyMapView(
              height: 200,
              userLat: userLat,
              userLng: userLng,
              pins: [
                MapPin(
                  id: 'sos_$sosId',
                  lat: userLat,
                  lng: userLng,
                  title: 'SOS Alert #$sosId',
                  snippet: 'Emergency location',
                  isUser: true,
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onCall,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.phone),
                  label: Text(autoCallPhone ?? 'Call help'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMaps,
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Open map'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Contact responses',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _HomeScreenState._navy),
          ),
          const SizedBox(height: 8),
          if (contacts.isEmpty)
            const _EmptyCard(text: 'Waiting for contact responses…')
          else
            ...contacts.map((c) => _ResponseTile(data: Map<String, dynamic>.from(c as Map))),
          const SizedBox(height: 20),
          const Text(
            'Nearby volunteers',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: _HomeScreenState._navy),
          ),
          const SizedBox(height: 8),
          if (volunteers.isEmpty)
            const _EmptyCard(text: 'No volunteer responses yet')
          else
            ...volunteers.map((v) => _ResponseTile(data: Map<String, dynamic>.from(v as Map), isVolunteer: true)),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            label: const Text('Cancel SOS', style: TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black54)),
    );
  }
}

class _ResponseTile extends StatelessWidget {
  const _ResponseTile({required this.data, this.isVolunteer = false});

  final Map<String, dynamic> data;
  final bool isVolunteer;

  Color _statusColor(String? status) {
    final s = (status ?? 'PENDING').toUpperCase();
    if (s.contains('ACCEPT')) return const Color(0xFF16A34A);
    if (s.contains('REJECT') || s.contains('DECLIN')) return const Color(0xFFDC2626);
    return const Color(0xFFF59E0B);
  }

  @override
  Widget build(BuildContext context) {
    final name = data['name']?.toString() ?? 'Unknown';
    final status = data['status']?.toString() ?? 'PENDING';
    final subtitle = isVolunteer
        ? data['phone']?.toString()
        : '${data['relation'] ?? ''} ${data['phone'] ?? ''}'.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _statusColor(status).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _statusColor(status).withValues(alpha: 0.15),
            child: Icon(
              isVolunteer ? Icons.volunteer_activism : Icons.person,
              color: _statusColor(status),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                if (subtitle != null && subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _statusColor(status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
