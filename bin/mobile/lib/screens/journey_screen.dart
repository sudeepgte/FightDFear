import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_state.dart';
import '../services/journey_service.dart';
import 'contacts_screen.dart';

/// Journey Safety Tracker — start a check-in timer; contacts alerted if overdue.
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  late final JourneyService _journey;
  final _fromCtrl = TextEditingController();
  final _destCtrl = TextEditingController();

  bool _loading = true;
  bool _busy = false;
  String? _error;
  String? _banner;

  Map<String, dynamic>? _session;
  Timer? _pollTimer;
  Timer? _tickTimer;
  Duration _remaining = Duration.zero;

  DateTime? _pickedEta;

  @override
  void initState() {
    super.initState();
    _journey = JourneyService(context.read<AuthState>().api);
    _bootstrap();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _tickTimer?.cancel();
    _fromCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  bool get _isActive {
    final status = _session?['status']?.toString().toUpperCase();
    return status == 'ACTIVE' || status == 'ALERTED';
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _journey.getActive();
      if (!mounted) return;
      if (res['success'] == true && res['active'] == true) {
        _applySession(res);
        _startTimers();
      } else {
        _session = null;
      }
    } catch (e) {
      if (mounted) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _applySession(Map<String, dynamic> res) {
    _session = res;
    _updateRemaining();
  }

  void _updateRemaining() {
    final epoch = _session?['expectedArrivalEpochMs'];
    int? ms;
    if (epoch is int) {
      ms = epoch;
    } else if (epoch != null) {
      ms = int.tryParse('$epoch');
    }
    if (ms == null) {
      _remaining = Duration.zero;
      return;
    }
    final end = DateTime.fromMillisecondsSinceEpoch(ms);
    final diff = end.difference(DateTime.now());
    _remaining = diff.isNegative ? Duration.zero : diff;
  }

  void _startTimers() {
    _pollTimer?.cancel();
    _tickTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refreshActive());
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_isActive) return;
      setState(_updateRemaining);
    });
  }

  void _stopTimers() {
    _pollTimer?.cancel();
    _tickTimer?.cancel();
    _pollTimer = null;
    _tickTimer = null;
  }

  Future<void> _refreshActive() async {
    try {
      final res = await _journey.getActive();
      if (!mounted) return;
      if (res['success'] == true && res['active'] == true) {
        setState(() => _applySession(res));
      } else {
        _stopTimers();
        setState(() {
          _session = null;
          _banner = res['message']?.toString() ?? 'Journey ended';
        });
      }
    } catch (_) {}
  }

  Future<void> _pickEta() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(minutes: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 7)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30))),
    );
    if (time == null || !mounted) return;
    setState(() {
      _pickedEta = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _startJourney() async {
    final from = _fromCtrl.text.trim();
    final dest = _destCtrl.text.trim();
    if (from.isEmpty || dest.isEmpty) {
      _showSnack('Enter starting point and destination');
      return;
    }
    if (_pickedEta == null) {
      _showSnack('Pick expected arrival time');
      return;
    }
    if (!_pickedEta!.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      _showSnack('Expected arrival must be at least 1 minute from now');
      return;
    }

    setState(() {
      _busy = true;
      _banner = 'Contacting server…';
    });

    // Never block start on GPS — start timer first; location is optional.
    try {
      final res = await _journey.start(
        destination: dest,
        startFrom: from,
        expectedArrivalEpochMs: _pickedEta!.millisecondsSinceEpoch,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _applySession(res);
          _busy = false;
          _banner = res['message']?.toString() ?? 'Journey timer started';
        });
        _startTimers();
      } else {
        setState(() {
          _busy = false;
          _banner = res['error']?.toString() ??
              'Could not start journey. Is the backend running on :8084?';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _banner =
            'Cannot reach server. Start Spring Boot on port 8084, then try again.\n($e)';
      });
    }
  }

  Future<void> _markSafe() async {
    setState(() => _busy = true);
    try {
      final res = await _journey.markSafe();
      if (!mounted) return;
      _stopTimers();
      setState(() {
        _busy = false;
        _session = null;
        _banner = res['message']?.toString() ?? 'Marked safe';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _banner = 'Failed: $e';
      });
    }
  }

  Future<void> _cancelJourney() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel journey?'),
        content: const Text('This stops the safety timer. Contacts will not be notified.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep active')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cancel timer')),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final res = await _journey.cancel();
      if (!mounted) return;
      _stopTimers();
      setState(() {
        _busy = false;
        _session = null;
        _banner = res['message']?.toString() ?? 'Journey cancelled';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _banner = 'Failed: $e';
      });
    }
  }

  Future<void> _openMap() async {
    final lat = _session?['startLat'];
    final lng = _session?['startLng'];
    if (lat == null || lng == null) {
      _showSnack('No start location captured');
      return;
    }
    final uri = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatRemaining(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatEta(DateTime? dt) {
    if (dt == null) return 'Pick date & time';
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final status = _session?['status']?.toString().toUpperCase();
    final overdue = status == 'ALERTED' || (_isActive && _remaining == Duration.zero);

    return Scaffold(
      backgroundColor: overdue ? const Color(0xFFFFF1F2) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Journey Safety Tracker'),
        backgroundColor: overdue ? JourneyScreen.primary : Colors.white,
        foregroundColor: overdue ? Colors.white : JourneyScreen.navy,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Trusted contacts',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ContactsScreen()),
            ),
            icon: const Icon(Icons.contacts_outlined),
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
                        const SizedBox(height: 16),
                        FilledButton(onPressed: _bootstrap, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _bootstrap,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_banner != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(_banner!),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_isActive)
                        _ActiveCard(
                          session: _session!,
                          remaining: _remaining,
                          overdue: overdue,
                          formatRemaining: _formatRemaining,
                          busy: _busy,
                          onSafe: _markSafe,
                          onCancel: _cancelJourney,
                          onMap: _openMap,
                        )
                      else
                        _StartForm(
                          fromCtrl: _fromCtrl,
                          destCtrl: _destCtrl,
                          etaLabel: _formatEta(_pickedEta),
                          busy: _busy,
                          onPickEta: _pickEta,
                          onStart: _startJourney,
                        ),
                      const SizedBox(height: 20),
                      const _HowItWorks(),
                    ],
                  ),
                ),
    );
  }
}

class _StartForm extends StatelessWidget {
  const _StartForm({
    required this.fromCtrl,
    required this.destCtrl,
    required this.etaLabel,
    required this.busy,
    required this.onPickEta,
    required this.onStart,
  });

  final TextEditingController fromCtrl;
  final TextEditingController destCtrl;
  final String etaLabel;
  final bool busy;
  final VoidCallback onPickEta;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Start a journey timer',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: JourneyScreen.navy,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'If you don’t check in by your ETA, trusted & emergency contacts get an email alert.',
          style: TextStyle(color: JourneyScreen.textGray, height: 1.4),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: fromCtrl,
          decoration: const InputDecoration(
            labelText: 'Starting from',
            hintText: 'e.g. Office, College',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.my_location_outlined),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: destCtrl,
          decoration: const InputDecoration(
            labelText: 'Destination',
            hintText: 'e.g. Home',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.flag_outlined),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: busy ? null : onPickEta,
          icon: const Icon(Icons.schedule),
          label: Text(etaLabel),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.centerLeft,
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: busy ? null : onStart,
          style: FilledButton.styleFrom(
            backgroundColor: JourneyScreen.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.timer_outlined),
          label: Text(busy ? 'Starting…' : 'Start timer'),
        ),
      ],
    );
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard({
    required this.session,
    required this.remaining,
    required this.overdue,
    required this.formatRemaining,
    required this.busy,
    required this.onSafe,
    required this.onCancel,
    required this.onMap,
  });

  final Map<String, dynamic> session;
  final Duration remaining;
  final bool overdue;
  final String Function(Duration) formatRemaining;
  final bool busy;
  final VoidCallback onSafe;
  final VoidCallback onCancel;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    final status = session['status']?.toString() ?? 'ACTIVE';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: overdue ? JourneyScreen.primary : JourneyScreen.navy,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                overdue ? 'CHECK-IN OVERDUE' : 'JOURNEY ACTIVE',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                overdue ? '00:00' : formatRemaining(remaining),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                overdue
                    ? 'Contacts may have been alerted'
                    : 'Time left until expected arrival',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                'Status: $status',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoRow(
          icon: Icons.my_location_outlined,
          label: 'From',
          value: session['startFromText']?.toString() ?? '—',
        ),
        _InfoRow(
          icon: Icons.flag_outlined,
          label: 'To',
          value: session['destinationText']?.toString() ?? '—',
        ),
        if (session['startLat'] != null && session['startLng'] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextButton.icon(
              onPressed: onMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open start location on map'),
            ),
          ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: busy ? null : onSafe,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text("I'm safe"),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: busy ? null : onCancel,
          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
          label: const Text('Cancel timer', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: JourneyScreen.primary, size: 20),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(color: JourneyScreen.textGray)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: JourneyScreen.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How it works',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: JourneyScreen.navy,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. Enter from, destination, and expected arrival\n'
            '2. Start the timer (optional GPS on start)\n'
            '3. Tap “I’m safe” when you arrive\n'
            '4. If you miss the ETA, contacts get an email alert',
            style: TextStyle(color: JourneyScreen.textGray, height: 1.5),
          ),
        ],
      ),
    );
  }
}
