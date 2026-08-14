import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/event_host_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../landing/landing_screen.dart';
import 'event_host_profile_completion_screen.dart';

class EventHostDashboardScreen extends StatefulWidget {
  const EventHostDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color softBg = Color(0xFFFAF7F8);

  @override
  State<EventHostDashboardScreen> createState() => _EventHostDashboardScreenState();
}

class _EventHostDashboardScreenState extends State<EventHostDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _host = {};
  List<Map<String, dynamic>> _events = [];
  int _totalEvents = 0;
  int _totalRegistrations = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';

  int? _selectedEventId;
  List<Map<String, dynamic>> _selectedRegs = [];
  bool _loadingRegs = false;
  String? _regsError;
  final _ticketCode = TextEditingController();
  bool _checkingIn = false;

  EventHostAuthService get _svc => EventHostAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ticketCode.dispose();
    super.dispose();
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  String get _partnerStatus =>
      (_host['partnerProfileStatus']?.toString() ?? '').toUpperCase();

  String get _verificationStatus =>
      (_host['verificationStatus']?.toString() ?? '').toUpperCase();

  bool get _verified =>
      _verificationStatus == 'VERIFIED' || _partnerStatus == 'APPROVED';

  bool get _needsProfile {
    const incomplete = {
      'PROFILE_INCOMPLETE',
      'REGISTERED',
      'READY_FOR_VERIFICATION',
      'CHANGES_REQUESTED',
      'REJECTED',
    };
    return incomplete.contains(_partnerStatus);
  }

  String get _statusBadgeLabel {
    if (_verified || _partnerStatus == 'APPROVED') return 'Approved';
    if (_partnerStatus == 'REJECTED' || _verificationStatus == 'REJECTED') {
      return 'Rejected';
    }
    if (_partnerStatus == 'PENDING_ADMIN_APPROVAL' ||
        _partnerStatus == 'READY_FOR_VERIFICATION' ||
        _verificationStatus == 'PENDING') {
      return 'Pending';
    }
    return 'Incomplete';
  }

  Color get _statusBadgeBg {
    switch (_statusBadgeLabel) {
      case 'Approved':
        return const Color(0xFFDCFCE7);
      case 'Rejected':
        return const Color(0xFFFFE4E6);
      case 'Pending':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFE2E8F0);
    }
  }

  Color get _statusBadgeFg {
    switch (_statusBadgeLabel) {
      case 'Approved':
        return const Color(0xFF166534);
      case 'Rejected':
        return const Color(0xFFBE123C);
      case 'Pending':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF475569);
    }
  }

  String get _name => _host['fullName']?.toString() ?? 'Host';
  String get _org => _host['organizerName']?.toString() ?? 'Organization';
  String get _email => _host['email']?.toString() ?? '';
  String get _phone =>
      _host['phone']?.toString() ?? _host['hostContact']?.toString() ?? '';

  String get _city {
    final parts = [_host['city'], _host['state']]
        .where((e) => e != null && '$e'.isNotEmpty)
        .toList();
    return parts.isEmpty ? 'Location not set' : parts.join(', ');
  }

  int get _pending =>
      _events.where((e) => (e['status']?.toString() ?? '') == 'PENDING').length;
  int get _approved =>
      _events.where((e) => (e['status']?.toString() ?? '') == 'APPROVED').length;
  int get _rejected => _events
      .where((e) {
        final s = (e['status']?.toString() ?? '').toUpperCase();
        return s == 'REJECTED' || s == 'CANCELLED' || s == 'CANCELLED_BY_HOST';
      })
      .length;

  int get _expectedParticipants => _host['expectedParticipants'] is num
      ? (_host['expectedParticipants'] as num).toInt()
      : 0;

  Map<String, dynamic>? get _selectedEvent {
    if (_selectedEventId == null) return null;
    for (final e in _events) {
      if (_eventId(e) == _selectedEventId) return e;
    }
    return null;
  }

  int? _eventId(Map<String, dynamic> e) {
    final id = e['id'];
    if (id is int) return id;
    return int.tryParse('$id');
  }

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _host = Map<String, dynamic>.from(res['host'] ?? {});
        _events = ModuleTheme.toList(res['events']);
        _totalEvents = (res['totalEvents'] is num)
            ? (res['totalEvents'] as num).toInt()
            : _events.length;
        _totalRegistrations = (res['totalRegistrations'] is num)
            ? (res['totalRegistrations'] as num).toInt()
            : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_host['payoutBalance'] is num)
                ? (_host['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _host['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? WomenEventCatalog.cancelPolicy;

        if (_events.isNotEmpty) {
          final stillValid =
              _selectedEventId != null &&
              _events.any((e) => _eventId(e) == _selectedEventId);
          if (!stillValid) {
            _selectedEventId = _eventId(_events.first);
          }
        } else {
          _selectedEventId = null;
          _selectedRegs = [];
        }
      } else {
        _error = res['error']?.toString() ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);

    if (_selectedEventId != null && mounted) {
      await _loadRegistrations(_selectedEventId!);
    }
  }

  Future<void> _loadRegistrations(int eventId) async {
    setState(() {
      _loadingRegs = true;
      _regsError = null;
      _selectedEventId = eventId;
      _selectedRegs = [];
    });
    try {
      final res = await _svc.registrations(eventId);
      if (!mounted) return;
      if (res['success'] == true) {
        _selectedRegs = ModuleTheme.toList(res['registrations']);
      } else {
        _regsError = res['error']?.toString() ?? 'Failed to load registrations';
      }
    } catch (e) {
      _regsError = '$e';
    }
    if (mounted) setState(() => _loadingRegs = false);
  }

  Future<void> _requestPayout() async {
    final res = await _svc.requestPayout();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true
          ? (res['message']?.toString() ?? 'Requested')
          : (res['error']?.toString() ?? 'Payout failed')),
    ));
    if (res['success'] == true) _load();
  }

  Future<void> _editNotes(Map<String, dynamic> r) async {
    final eventId = _selectedEventId;
    final id = r['id'] is num ? (r['id'] as num).toInt() : int.tryParse('${r['id']}');
    if (eventId == null || id == null) return;
    final ctrl = TextEditingController(text: r['coachNotes']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Attendee notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Check-in notes, follow-up…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await _svc.updateRegistrationNotes(eventId, id, ctrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true ? 'Notes saved' : (res['error']?.toString() ?? 'Save failed')),
    ));
    if (res['success'] == true) _loadRegistrations(eventId);
  }

  Future<void> _openProfileCompletion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventHostProfileCompletionScreen(
          onFinished: (ctx) => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (mounted) _load();
  }

  Future<void> _logout() async {
    try {
      await _svc.logout();
    } catch (e) {
      if (mounted) {
        _toast('Logout issue: $e', error: true);
      }
    }
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : null,
      ),
    );
  }

  void _requireVerifiedOrToast() {
    _toast(
      'Your host account must be verified before creating events. '
      'Complete your profile and wait for admin approval.',
      error: true,
    );
  }

  Future<void> _onCreateEventPressed() async {
    if (!_verified) {
      _requireVerifiedOrToast();
      return;
    }
    await _showEventForm();
  }

  // ── Event form (create / edit) ────────────────────────────────────────────

  Future<void> _showEventForm({Map<String, dynamic>? existing}) async {
    final isEdit = existing != null;
    final name = TextEditingController(text: existing?['name']?.toString() ?? '');
    final desc =
        TextEditingController(text: existing?['description']?.toString() ?? '');
    final venue =
        TextEditingController(text: existing?['venue']?.toString() ?? '');
    final city = TextEditingController(
      text: existing?['city']?.toString() ?? _host['city']?.toString() ?? '',
    );
    final fee = TextEditingController(
      text: existing?['entryFee']?.toString() ?? '0',
    );
    final seats = TextEditingController(
      text: existing?['maxParticipants']?.toString() ??
          existing?['capacity']?.toString() ??
          '',
    );

    String categoryCode = WomenEventCatalog.codeFor(
          existing?['category']?.toString(),
        ) ??
        WomenEventCatalog.categories.first.code;

    DateTime? pickedDate;
    final rawDate = existing?['eventDate']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      pickedDate = DateTime.tryParse(rawDate);
    }

    TimeOfDay? pickedTime;
    final rawTime = existing?['eventTime']?.toString();
    if (rawTime != null && rawTime.isNotEmpty) {
      final parts = rawTime.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          pickedTime = TimeOfDay(hour: h, minute: m);
        }
      }
    }
    pickedTime ??= const TimeOfDay(hour: 10, minute: 0);

    String? formError;
    bool submitting = false;

    String fmtDate(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    String fmtTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    try {
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setLocal) {
            Future<void> submit() async {
              if (submitting) return;
              final n = name.text.trim();
              final v = venue.text.trim();
              final c = city.text.trim();
              if (n.isEmpty || v.isEmpty || c.isEmpty || pickedDate == null) {
                setLocal(() {
                  formError = 'Name, venue, city and date are required';
                });
                return;
              }
              final feeVal = double.tryParse(fee.text.trim());
              if (feeVal == null || feeVal < 0) {
                setLocal(() => formError = 'Entry fee must be 0 or greater');
                return;
              }
              final seatsRaw = seats.text.trim();
              int? seatsVal;
              if (seatsRaw.isNotEmpty) {
                seatsVal = int.tryParse(seatsRaw);
                if (seatsVal == null || seatsVal <= 0) {
                  setLocal(
                    () => formError = 'Max seats must be empty or greater than 0',
                  );
                  return;
                }
              }

              setLocal(() {
                submitting = true;
                formError = null;
              });

              final body = <String, dynamic>{
                'name': n,
                'category': categoryCode,
                'description': desc.text.trim(),
                'venue': v,
                'city': c,
                'eventDate': fmtDate(pickedDate!),
                'eventTime': fmtTime(pickedTime!),
                'entryFee': feeVal,
                'maxParticipants': ?seatsVal,
              };

              try {
                Map<String, dynamic> res;
                if (isEdit) {
                  final id = _eventId(existing);
                  if (id == null) {
                    setLocal(() {
                      submitting = false;
                      formError = 'Invalid event id';
                    });
                    return;
                  }
                  res = await _svc.updateEvent(id, body);
                } else {
                  res = await _svc.createEvent(body);
                }
                if (!ctx.mounted) return;
                if (res['success'] == true) {
                  Navigator.pop(ctx, true);
                } else {
                  final raw = res['error']?.toString() ??
                      (isEdit ? 'Update failed' : 'Create failed');
                  final friendly = raw.toLowerCase().contains('verified')
                      ? 'Your host account must be verified before creating events. Complete your profile and wait for admin approval.'
                      : raw;
                  setLocal(() {
                    submitting = false;
                    formError = friendly;
                  });
                }
              } catch (e) {
                if (!ctx.mounted) return;
                setLocal(() {
                  submitting = false;
                  formError = '$e';
                });
              }
            }

            return AlertDialog(
              title: Text(isEdit ? 'Edit Event' : 'Create Event'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Event name *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: categoryCode,
                        decoration: const InputDecoration(
                          labelText: 'Category *',
                          border: OutlineInputBorder(),
                        ),
                        items: WomenEventCatalog.categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.code,
                                child: Text(c.label),
                              ),
                            )
                            .toList(),
                        onChanged: submitting
                            ? null
                            : (v) => setLocal(
                                  () => categoryCode = v ?? categoryCode,
                                ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: desc,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: venue,
                        decoration: const InputDecoration(
                          labelText: 'Venue *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: city,
                        decoration: const InputDecoration(
                          labelText: 'City *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: submitting
                            ? null
                            : () async {
                                final d = await showDatePicker(
                                  context: ctx,
                                  initialDate: pickedDate ?? DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 1)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 2)),
                                );
                                if (d != null) {
                                  setLocal(() => pickedDate = d);
                                }
                              },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date *',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(
                            pickedDate == null
                                ? 'Select date'
                                : fmtDate(pickedDate!),
                            style: TextStyle(
                              color: pickedDate == null
                                  ? EventHostDashboardScreen.muted
                                  : EventHostDashboardScreen.navy,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: submitting
                            ? null
                            : () async {
                                final t = await showTimePicker(
                                  context: ctx,
                                  initialTime:
                                      pickedTime ?? const TimeOfDay(hour: 10, minute: 0),
                                );
                                if (t != null) {
                                  setLocal(() => pickedTime = t);
                                }
                              },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Time',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(
                            pickedTime == null
                                ? 'Select time'
                                : fmtTime(pickedTime!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: fee,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Entry fee (Rs)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: seats,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max participants (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (formError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          formError!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      submitting ? null : () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: EventHostDashboardScreen.primary,
                  ),
                  onPressed: submitting ? null : submit,
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEdit ? 'Save' : 'Create'),
                ),
              ],
            );
          },
        ),
      );

      if (ok == true && mounted) {
        _toast(
          isEdit
              ? 'Event updated'
              : 'Event submitted for admin approval',
        );
        if (!isEdit) setState(() => _tab = 1);
        await _load();
      }
    } finally {
      for (final c in [name, desc, venue, city, fee, seats]) {
        c.dispose();
      }
    }
  }

  Future<void> _cancelEvent(Map<String, dynamic> event) async {
    final id = _eventId(event);
    if (id == null) return;
    final status = (event['status']?.toString() ?? '').toUpperCase();
    if (status == 'CANCELLED' || status == 'CANCELLED_BY_HOST') {
      _toast('Event is already cancelled');
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel event?'),
        content: Text(
          'Cancel "${event['name'] ?? 'this event'}"? Attendees will no longer be able to register.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel event'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      final res = await _svc.cancelEvent(id);
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Event cancelled');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Could not cancel event', error: true);
      }
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    }
  }

  void _showEventDetails(Map<String, dynamic> e) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final fee = e['entryFee'] ?? 0;
        final seats = e['maxParticipants'] ?? e['capacity'] ?? '—';
        final regs = e['registrationCount'] ?? 0;
        final desc = e['description']?.toString();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['name']?.toString() ?? 'Event',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _pill((e['status']?.toString() ?? 'PENDING').toUpperCase()),
                    Chip(
                      label: Text(
                        WomenEventCatalog.labelFor(e['category']?.toString()),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _detailRow(Icons.place_outlined, '${e['venue'] ?? ''} · ${e['city'] ?? ''}'),
                _detailRow(
                  Icons.calendar_today_outlined,
                  '${e['eventDate'] ?? ''} ${e['eventTime'] ?? ''}'.trim(),
                ),
                _detailRow(Icons.currency_rupee, 'Fee: ₹$fee'),
                _detailRow(Icons.event_seat_outlined, 'Seats: $seats'),
                _detailRow(Icons.confirmation_number_outlined, 'Registrations: $regs'),
                if (desc != null && desc.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: EventHostDashboardScreen.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: EventHostDashboardScreen.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: EventHostDashboardScreen.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: EventHostDashboardScreen.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openRegistrations(Map<String, dynamic> event) async {
    final id = _eventId(event);
    if (id == null) return;
    setState(() => _tab = 2);
    await _loadRegistrations(id);
  }

  Future<void> _checkIn() async {
    if (_checkingIn) return;
    final eventId = _selectedEventId;
    if (eventId == null) {
      _toast('Select an event first', error: true);
      return;
    }
    final code = _ticketCode.text.trim();
    if (code.isEmpty) {
      _toast('Enter a ticket code', error: true);
      return;
    }
    setState(() => _checkingIn = true);
    try {
      final res = await _svc.checkIn(eventId, code);
      if (!mounted) return;
      if (res['success'] == true) {
        _ticketCode.clear();
        _toast(res['message']?.toString() ?? 'Checked in');
        await _loadRegistrations(eventId);
      } else {
        _toast(res['error']?.toString() ?? 'Check-in failed', error: true);
      }
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    }
    if (mounted) setState(() => _checkingIn = false);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventHostDashboardScreen.softBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: EventHostDashboardScreen.navy,
        title: const Text(
          'Event Host Dashboard',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _onCreateEventPressed,
            icon: Icon(
              Icons.add_circle_outline,
              color: _verified
                  ? EventHostDashboardScreen.primary
                  : EventHostDashboardScreen.muted,
            ),
          ),
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _verified
            ? EventHostDashboardScreen.primary
            : EventHostDashboardScreen.muted,
        onPressed: _onCreateEventPressed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 12,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _nav(0, Icons.home_outlined, Icons.home, 'Home'),
              _nav(1, Icons.event_outlined, Icons.event, 'Events'),
              const SizedBox(width: 56),
              _nav(
                2,
                Icons.confirmation_number_outlined,
                Icons.confirmation_number,
                'Attendees',
              ),
              _nav(3, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : SafeArea(
                  child: IndexedStack(
                    index: _tab,
                    children: [
                      _home(),
                      _eventsTab(),
                      _attendeesTab(),
                      _profileTab(),
                    ],
                  ),
                ),
    );
  }

  Widget _nav(int i, IconData o, IconData f, String label) {
    final active = _tab == i;
    final c = active
        ? EventHostDashboardScreen.primary
        : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? f : o, color: c, size: 22),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: c,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Home ──────────────────────────────────────────────────────────────────

  Widget _home() {
    return RefreshIndicator(
      color: EventHostDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _profileHeader(),
          const SizedBox(height: 14),
          if (_needsProfile || !_verified) ...[
            _statusBanner(),
            const SizedBox(height: 14),
          ],
          _kpiRow(),
          const SizedBox(height: 16),
          if (_events.isEmpty) _gettingStarted() else _eventsPreview(),
          const SizedBox(height: 16),
          _statusAndActivity(),
          const SizedBox(height: 16),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: EventHostDashboardScreen.navy,
            ),
          ),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 16),
          _footerBanner(),
        ],
      ),
    );
  }

  Widget _statusBanner() {
    String message;
    String cta = 'Complete profile';
    VoidCallback? onTap = _openProfileCompletion;

    if (_partnerStatus == 'REJECTED' || _verificationStatus == 'REJECTED') {
      final reason = _host['rejectionReason']?.toString();
      message = reason != null && reason.isNotEmpty
          ? 'Your profile was rejected: $reason'
          : 'Your profile was rejected. Update details and resubmit.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'CHANGES_REQUESTED') {
      final note = _host['changesRequestedNote']?.toString();
      message = note != null && note.isNotEmpty
          ? 'Changes requested: $note'
          : 'Admin requested profile changes before approval.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'PENDING_ADMIN_APPROVAL') {
      message =
          'Profile submitted. Waiting for admin verification before you can create events.';
      cta = 'View profile';
      onTap = () => setState(() => _tab = 3);
    } else if (_partnerStatus == 'READY_FOR_VERIFICATION') {
      message =
          'Your profile looks ready. Submit for verification to unlock event creation.';
      cta = 'Finish profile';
    } else {
      message =
          'Complete your host profile and get verified to create events.';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFBBF24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (_needsProfile) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: EventHostDashboardScreen.primary,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(cta),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _profileHeader() {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : 'H';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHostDashboardScreen.softPink,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: EventHostDashboardScreen.primary
                          .withValues(alpha: 0.15),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: EventHostDashboardScreen.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: EventHostDashboardScreen.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _statusBadgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _verified ? Icons.verified : Icons.hourglass_top,
                            size: 12,
                            color: _statusBadgeFg,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _statusBadgeLabel,
                            style: TextStyle(
                              color: _statusBadgeFg,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _org,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: EventHostDashboardScreen.navy,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: EventHostDashboardScreen.muted,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            _city,
                            style: const TextStyle(
                              fontSize: 12,
                              color: EventHostDashboardScreen.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_email.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: EventHostDashboardScreen.muted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: EventHostDashboardScreen.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (_phone.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: EventHostDashboardScreen.muted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _phone,
                            style: const TextStyle(
                              fontSize: 12,
                              color: EventHostDashboardScreen.muted,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _tab = 3),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: EventHostDashboardScreen.primary,
                side: const BorderSide(color: EventHostDashboardScreen.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiRow() {
    final items = [
      (Icons.event_outlined, 'Total Events', '$_totalEvents', 'Upcoming'),
      (
        Icons.confirmation_number_outlined,
        'Registrations',
        '$_totalRegistrations',
        'Across all events',
      ),
      (
        Icons.groups_outlined,
        'Participants',
        '$_expectedParticipants',
        'Expected',
      ),
      (Icons.pending_actions_outlined, 'Pending', '$_pending', 'Awaiting approval'),
      (Icons.check_circle_outline, 'Approved', '$_approved', 'Live events'),
    ];
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = items[i];
          return Container(
            width: 132,
            padding: const EdgeInsets.all(12),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(m.$1, color: EventHostDashboardScreen.primary, size: 20),
                const Spacer(),
                Text(
                  m.$2,
                  style: const TextStyle(
                    fontSize: 11,
                    color: EventHostDashboardScreen.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  m.$3,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                  ),
                ),
                Text(
                  m.$4,
                  style: const TextStyle(
                    fontSize: 10,
                    color: EventHostDashboardScreen.muted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _gettingStarted() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _card(),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: EventHostDashboardScreen.softPink,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.event_available,
              size: 32,
              color: EventHostDashboardScreen.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _verified
                ? "You haven't created any events yet. Create your first event and start making an impact!"
                : 'Get verified to create your first women event and reach attendees.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: EventHostDashboardScreen.muted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _verified ? _onCreateEventPressed : _openProfileCompletion,
            icon: Icon(_verified ? Icons.add : Icons.badge_outlined),
            label: Text(_verified ? 'Create Event' : 'Complete Profile'),
            style: FilledButton.styleFrom(
              backgroundColor: EventHostDashboardScreen.primary,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'My Events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: EventHostDashboardScreen.navy,
                ),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _tab = 1),
              child: const Text(
                'View all',
                style: TextStyle(
                  color: EventHostDashboardScreen.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        ..._events.take(3).map(_eventTile),
      ],
    );
  }

  Widget _statusAndActivity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Event Status Overview',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _totalEvents == 0
                              ? 0
                              : _approved / _totalEvents,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFF1F5F9),
                          color: EventHostDashboardScreen.primary,
                        ),
                        Text(
                          '$_totalEvents\nTotal',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: EventHostDashboardScreen.navy,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _legend('Pending / Draft', _pending, const Color(0xFF94A3B8)),
                _legend(
                  'Approved / Upcoming',
                  _approved,
                  const Color(0xFF16A34A),
                ),
                _legend(
                  'Rejected / Cancelled',
                  _rejected,
                  const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            height: 230,
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                if (_events.isEmpty && _totalRegistrations == 0)
                  const Center(
                    child: Column(
                      children: [
                        Icon(Icons.list_alt, size: 36, color: Color(0xFFCBD5E1)),
                        SizedBox(height: 8),
                        Text(
                          'No recent activity yet. Your recent actions will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: EventHostDashboardScreen.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  if (_events.isNotEmpty)
                    _activityRow(
                      Icons.event,
                      'Created ${_events.first['name']}',
                    ),
                  if (_totalRegistrations > 0)
                    _activityRow(
                      Icons.confirmation_number,
                      '$_totalRegistrations total registrations',
                    ),
                  if (_pending > 0)
                    _activityRow(
                      Icons.hourglass_bottom,
                      '$_pending event(s) pending approval',
                    ),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: EventHostDashboardScreen.muted,
              ),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: EventHostDashboardScreen.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: EventHostDashboardScreen.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    final actions = <(IconData, String, VoidCallback)>[
      (Icons.add_circle_outline, 'Create Event', _onCreateEventPressed),
      (Icons.event_note_outlined, 'My Events', () => setState(() => _tab = 1)),
      (
        Icons.confirmation_number_outlined,
        'Registrations',
        () => setState(() => _tab = 2),
      ),
      (
        Icons.qr_code_scanner,
        'Check-in',
        () => setState(() => _tab = 2),
      ),
      (
        Icons.account_balance_wallet_outlined,
        'Payouts',
        () => _toast('Payouts coming soon'),
      ),
      (
        Icons.campaign_outlined,
        'Marketing',
        () => _toast('Marketing coming soon'),
      ),
      (
        Icons.insights_outlined,
        'Analytics',
        () => _toast('Analytics coming soon'),
      ),
      (Icons.star_outline, 'Reviews', () => _toast('Reviews coming soon')),
      (
        Icons.handshake_outlined,
        'Sponsors',
        () => _toast('Sponsors coming soon'),
      ),
      (
        Icons.place_outlined,
        'Venue',
        () => _toast('Venue partners coming soon'),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) {
        final a = actions[i];
        return InkWell(
          onTap: a.$3,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: EventHostDashboardScreen.softPink,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  a.$1,
                  color: EventHostDashboardScreen.primary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                a.$2,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: EventHostDashboardScreen.navy,
                  height: 1.15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _footerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EventHostDashboardScreen.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.white, size: 36),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Empower Women. Create Impact. Thank you for being a part of the Women Safety Community.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Events tab ────────────────────────────────────────────────────────────

  Widget _eventsTab() {
    return RefreshIndicator(
      color: EventHostDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'My Events',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _onCreateEventPressed,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
                style: FilledButton.styleFrom(
                  backgroundColor: _verified
                      ? EventHostDashboardScreen.primary
                      : EventHostDashboardScreen.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_events.isEmpty)
            _gettingStarted()
          else
            ..._events.map(_eventTile),
        ],
      ),
    );
  }

  Widget _eventTile(Map<String, dynamic> e) {
    final status = (e['status']?.toString() ?? 'PENDING').toUpperCase();
    final cancelled =
        status == 'CANCELLED' || status == 'CANCELLED_BY_HOST';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  e['name']?.toString() ?? 'Event',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                  ),
                ),
              ),
              _pill(status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${e['categoryLabel'] ?? WomenEventCatalog.labelFor(e['category']?.toString())} · ${e['city'] ?? ''} · ${e['eventDate'] ?? ''}',
            style: const TextStyle(
              fontSize: 12,
              color: EventHostDashboardScreen.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Regs: ${e['registrationCount'] ?? 0} · Fee ₹${e['entryFee'] ?? 0}',
            style: const TextStyle(
              fontSize: 12,
              color: EventHostDashboardScreen.muted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _showEventDetails(e),
                style: OutlinedButton.styleFrom(
                  foregroundColor: EventHostDashboardScreen.primary,
                  side: const BorderSide(
                    color: EventHostDashboardScreen.primary,
                  ),
                ),
                child: const Text('Details'),
              ),
              OutlinedButton(
                onPressed: cancelled
                    ? null
                    : () {
                        if (!_verified) {
                          _requireVerifiedOrToast();
                          return;
                        }
                        _showEventForm(existing: e);
                      },
                child: const Text('Edit'),
              ),
              OutlinedButton(
                onPressed: cancelled ? null : () => _cancelEvent(e),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                ),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => _openRegistrations(e),
                style: FilledButton.styleFrom(
                  backgroundColor: EventHostDashboardScreen.primary,
                ),
                child: const Text('Registrations'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Attendees tab ─────────────────────────────────────────────────────────

  Widget _attendeesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text(
          'Attendees',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: EventHostDashboardScreen.navy,
          ),
        ),
        const SizedBox(height: 12),
        if (_events.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: _card(),
            child: const Text(
              'Create an event to manage attendees and check-ins.',
              style: TextStyle(color: EventHostDashboardScreen.muted),
            ),
          )
        else ...[
          DropdownButtonFormField<int>(
            key: ValueKey('event-$_selectedEventId'),
            initialValue: _selectedEventId,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Select event',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            items: _events
                .map((e) {
                  final id = _eventId(e);
                  if (id == null) return null;
                  return DropdownMenuItem<int>(
                    value: id,
                    child: Text(
                      e['name']?.toString() ?? 'Event',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                })
                .whereType<DropdownMenuItem<int>>()
                .toList(),
            onChanged: (id) {
              if (id != null) _loadRegistrations(id);
            },
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check-in',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: EventHostDashboardScreen.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ticketCode,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Ticket code',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onSubmitted: (_) => _checkIn(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _checkingIn ? null : _checkIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: EventHostDashboardScreen.primary,
                        minimumSize: const Size(96, 48),
                      ),
                      child: _checkingIn
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Check in'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_loadingRegs)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_regsError != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _card(),
              child: Column(
                children: [
                  Text(
                    _regsError!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _selectedEventId == null
                        ? null
                        : () => _loadRegistrations(_selectedEventId!),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (_selectedRegs.isEmpty)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: _card(),
              child: Text(
                _selectedEvent == null
                    ? 'Select an event to view registrations.'
                    : 'No registrations yet for this event.',
                style: const TextStyle(color: EventHostDashboardScreen.muted),
              ),
            )
          else
            ..._selectedRegs.map(_regTile),
        ],
      ],
    );
  }

  Widget _regTile(Map<String, dynamic> r) {
    final paid = r['paid'] == true;
    final checkedIn = r['checkedIn'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _card(),
      child: ListTile(
        title: Text(
          r['userName']?.toString() ?? 'Attendee',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: EventHostDashboardScreen.navy,
          ),
        ),
        subtitle: Text(
          '${r['userEmail'] ?? ''} · ${r['ticketCode'] ?? ''}',
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () => _editNotes(r),
        trailing: Wrap(
          spacing: 4,
          children: [
            Chip(
              label: Text(
                paid ? 'Paid' : 'Unpaid',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: paid ? const Color(0xFF166534) : const Color(0xFF9A3412),
                ),
              ),
              backgroundColor:
                  paid ? const Color(0xFFDCFCE7) : const Color(0xFFFFEDD5),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            Chip(
              label: Text(
                checkedIn ? 'Checked in' : 'Not in',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: checkedIn
                      ? const Color(0xFF1D4ED8)
                      : EventHostDashboardScreen.muted,
                ),
              ),
              backgroundColor:
                  checkedIn ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile tab ───────────────────────────────────────────────────────────

  Widget _profileTab() {
    final categoriesRaw = _host['eventCategories']?.toString() ?? '';
    final categoryLabels = WomenEventCatalog.splitCodes(categoriesRaw)
        .map(WomenEventCatalog.labelFor)
        .join(', ');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHeader(),
        const SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined,
                color: EventHostDashboardScreen.primary),
            title: const Text('Payout balance'),
            subtitle: Text(_upiId.isEmpty
                ? 'Add UPI in Complete Profile to withdraw'
                : 'UPI: $_upiId'),
            trailing: Text(
              '₹${_payoutBalance.round()}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _requestPayout,
          style: FilledButton.styleFrom(
            backgroundColor: EventHostDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(
          _cancelPolicy.isNotEmpty ? _cancelPolicy : WomenEventCatalog.cancelPolicy,
          style: const TextStyle(color: EventHostDashboardScreen.muted, fontSize: 12),
        ),
        const SizedBox(height: 14),
        if (_needsProfile)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FilledButton.icon(
              onPressed: _openProfileCompletion,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Complete / update profile'),
              style: FilledButton.styleFrom(
                backgroundColor: EventHostDashboardScreen.primary,
                minimumSize: const Size.fromHeight(46),
              ),
            ),
          ),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.business),
          title: const Text('Organization'),
          subtitle: Text(_org),
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.category),
          title: const Text('Type'),
          subtitle: Text(_host['organizerType']?.toString() ?? '—'),
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.interests),
          title: const Text('Categories'),
          subtitle: Text(
            categoryLabels.isEmpty
                ? (_host['eventCategories']?.toString() ?? '—')
                : categoryLabels,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: const Icon(Icons.verified_outlined),
          title: const Text('Status'),
          subtitle: Text(
            '${_host['partnerProfileStatusLabel'] ?? _statusBadgeLabel}'
            '${_host['profileCompletionPct'] != null ? ' · ${_host['profileCompletionPct']}% complete' : ''}',
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: EventHostDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: EventHostDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _pill(String status) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0369A1);
    if (status == 'APPROVED') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (status == 'REJECTED') {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFBE123C);
    } else if (status == 'CANCELLED' || status == 'CANCELLED_BY_HOST') {
      bg = const Color(0xFFF1F5F9);
      fg = const Color(0xFF475569);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
