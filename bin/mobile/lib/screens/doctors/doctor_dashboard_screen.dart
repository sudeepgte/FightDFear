import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/doctor_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'doctor_chat_screen.dart';
import 'doctor_profile_completion_screen.dart';

/// Doctor portal dashboard with profile, stats, filters, and appointment actions.
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _doctor = {};
  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _notifications = [];
  Map<String, dynamic> _raw = {};
  int _navIndex = 0;
  String _filter = 'ALL';
  final _search = TextEditingController();
  bool _online = true;

  DoctorAuthService get _svc => DoctorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (res['success'] == true) {
        _raw = res;
        final d = res['doctor'];
        _doctor = d is Map ? Map<String, dynamic>.from(d) : {};
        _appointments = ModuleTheme.toList(res['appointments']);
        _notifications = ModuleTheme.toList(res['notifications']);
        _online = res['online'] == true;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    final res = await _svc.logout();
    await _svc.clearLocalSession();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Logged out successfully' : 'Logged out locally'),
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  num _num(dynamic v) => v is num ? v : num.tryParse('$v') ?? 0;

  DateTime? _parseTime(dynamic raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  String _money(dynamic v) {
    final n = _num(v);
    if (n == n.roundToDouble()) return n.toInt().toString();
    return n.toStringAsFixed(0);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String _modeLabel(String type) {
    switch (type.toUpperCase()) {
      case 'VIDEO':
        return 'Video Consultation';
      case 'ONLINE':
        return 'Online Consultation';
      case 'OFFLINE':
        return 'Home Visit';
      case 'CLINIC':
        return 'In Clinic';
      default:
        return type.isEmpty ? 'Consultation' : type;
    }
  }

  IconData _modeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'VIDEO':
      case 'ONLINE':
        return Icons.videocam_outlined;
      case 'OFFLINE':
        return Icons.home_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'CONFIRMED':
        return const Color(0xFF22C55E);
      case 'COMPLETED':
        return const Color(0xFF16A34A);
      case 'CANCELLED':
        return const Color(0xFFEF4444);
      default:
        return ModuleTheme.textGray;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _search.text.trim().toLowerCase();
    final now = DateTime.now();
    return _appointments.where((a) {
      final name = (a['clientName']?.toString() ?? '').toLowerCase();
      if (q.isNotEmpty && !name.contains(q)) return false;
      final status = (a['status']?.toString() ?? '').toUpperCase();
      final type = (a['consultationType']?.toString() ?? '').toUpperCase();
      final t = _parseTime(a['appointmentTime']);
      switch (_filter) {
        case 'PENDING':
          return status == 'PENDING';
        case 'COMPLETED':
          return status == 'COMPLETED';
        case 'TODAY':
          return t != null &&
              t.year == now.year &&
              t.month == now.month &&
              t.day == now.day;
        case 'VIDEO':
          return type == 'VIDEO' || type == 'ONLINE';
        case 'CLINIC':
          return type == 'CLINIC' || type == 'OFFLINE';
        default:
          return true;
      }
    }).toList();
  }

  List<Map<String, dynamic>> get _patients {
    final map = <int, Map<String, dynamic>>{};
    for (final a in _appointments) {
      final id = a['userId'] is num ? (a['userId'] as num).toInt() : int.tryParse('${a['userId']}');
      if (id == null) continue;
      map.putIfAbsent(id, () => a);
    }
    return map.values.toList();
  }

  Future<void> _setStatus(int id, String status) async {
    final res = await _svc.updateAppointmentStatus(id, status);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Updated to $status' : '${res['error']}')),
    );
    if (res['success'] == true) _reload();
  }

  Future<void> _savePrescription(int id, String existing) async {
    final med = TextEditingController();
    final dose = TextEditingController();
    final days = TextEditingController();
    final advice = TextEditingController(text: existing);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Prescription'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: med, decoration: const InputDecoration(labelText: 'Medicine *', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: dose, decoration: const InputDecoration(labelText: 'Dosage (e.g. 1-0-1)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: days, decoration: const InputDecoration(labelText: 'Days', border: OutlineInputBorder()), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: advice, maxLines: 3, decoration: const InputDecoration(labelText: 'Advice', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save & send')),
        ],
      ),
    );
    if (ok != true) return;
    final name = med.text.trim();
    if (name.isEmpty && advice.text.trim().isEmpty) return;
    final json = '{"meds":[{"name":"$name","dosage":"${dose.text.trim()}","days":"${days.text.trim()}"}],"advice":"${advice.text.trim()}"}';
    final text = [
      if (name.isNotEmpty) '$name  ${dose.text.trim()}  ${days.text.trim()} days',
      if (advice.text.trim().isNotEmpty) 'Advice: ${advice.text.trim()}',
    ].join('\n');
    final res = await _svc.savePrescription(id, text, prescriptionJson: json, doctorNotes: advice.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res['success'] == true ? 'Prescription sent' : (res['error']?.toString() ?? 'Failed'),
        ),
      ),
    );
    if (res['success'] == true) _reload();
  }

  Future<void> _openPatientFile(Map<String, dynamic> item) async {
    final userId = item['userId'] is num ? (item['userId'] as num).toInt() : int.tryParse('${item['userId']}');
    if (userId == null) return;
    final res = await _svc.patientFile(userId);
    if (!mounted) return;
    final visits = ModuleTheme.toList(res['visits']);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['clientName']?.toString() ?? 'Patient', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            if (visits.isEmpty) const Text('No visit history yet')
            else ...visits.map((v) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${v['appointmentTime'] ?? ''} · ${v['status'] ?? ''}'),
                subtitle: Text(
                  [
                    if (v['reason'] != null) v['reason'],
                    if (v['prescriptionText'] != null) 'Rx: ${v['prescriptionText']}',
                    if (v['doctorNotes'] != null) 'Notes: ${v['doctorNotes']}',
                  ].join('\n'),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openAppointmentPreview(Map<String, dynamic> item) {
    final status = item['status']?.toString() ?? 'PENDING';
    final type = item['consultationType']?.toString() ?? '';
    final when = _parseTime(item['appointmentTime']);
    final reason = item['reason']?.toString() ?? '';
    final payment = item['paymentStatus']?.toString() ?? '';
    final amount = item['amountPaid'];
    final notes = item['doctorNotes']?.toString() ?? '';
    final id = item['id'] is num ? (item['id'] as num).toInt() : int.tryParse('${item['id']}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['clientName']?.toString() ?? 'Patient',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Text('Appointment preview', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              const SizedBox(height: 16),
              _previewRow('Age', item['patientAge']?.toString() ?? 'Not provided'),
              _previewRow('Gender', item['patientGender']?.toString() ?? 'Not provided'),
              _previewRow('Phone', item['clientPhone']?.toString() ?? 'Not provided'),
              _previewRow('Patient ID', item['patientId']?.toString() ?? 'Not provided'),
              const Divider(height: 24),
              _previewRow('Date', when == null ? 'Not provided' : _formatDate(when)),
              _previewRow('Time', when == null ? 'Not provided' : _formatTime(when)),
              _previewRow('Consultation', _modeLabel(type)),
              _previewRow('Status', _statusLabel(status)),
              _previewRow('Reason', reason.isEmpty ? 'Not provided' : reason),
              _previewRow('Payment', amount != null ? '${payment.isEmpty ? 'Paid' : payment} · ₹${_money(amount)}' : (payment.isEmpty ? 'Payment pending' : payment)),
              _previewRow('Notes', notes.isEmpty ? 'No notes yet' : notes),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: ModuleTheme.primary),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openChat(item);
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Chat'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openPatientFile(item);
                    },
                    icon: const Icon(Icons.person_outline, size: 16),
                    label: const Text('Patient file'),
                  ),
                  if (id != null)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _savePrescription(id, item['prescriptionText']?.toString() ?? '');
                      },
                      icon: const Icon(Icons.description_outlined, size: 16),
                      label: const Text('Prescription'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(k, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(child: Text(v, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }

  Future<void> _rescheduleAsDoctor(Map<String, dynamic> item) async {
    final id = item['id'] is num ? (item['id'] as num).toInt() : int.tryParse('${item['id']}');
    if (id == null) return;
    final dates = DoctorCatalog.bookableDates(_doctor);
    if (dates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No open slots')));
      return;
    }
    var date = dates.first;
    var times = DoctorCatalog.timesForDate(_doctor, date);
    var time = times.isEmpty ? const TimeOfDay(hour: 10, minute: 0) : times.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Propose new time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 6,
                children: dates.map((d) => ChoiceChip(
                      label: Text('${DoctorCatalog.weekdayShort(d.weekday)} ${d.day}/${d.month}'),
                      selected: date.day == d.day && date.month == d.month,
                      onSelected: (_) => setLocal(() {
                        date = d;
                        times = DoctorCatalog.timesForDate(_doctor, d);
                        time = times.isEmpty ? time : times.first;
                      }),
                    )).toList(),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: times.map((t) => ChoiceChip(
                      label: Text(MaterialLocalizations.of(ctx).formatTimeOfDay(t)),
                      selected: time.hour == t.hour && time.minute == t.minute,
                      onSelected: (_) => setLocal(() => time = t),
                    )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final res = await _svc.reschedule(id, DoctorCatalog.formatAppt(when));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Rescheduled' : '${res['error']}')),
    );
    if (res['success'] == true) _reload();
  }

  void _openChat(Map<String, dynamic> item) {
    final doctorId = _doctor['id'] is num
        ? (_doctor['id'] as num).toInt()
        : int.tryParse('${_doctor['id']}');
    final userId = item['userId'] is num
        ? (item['userId'] as num).toInt()
        : int.tryParse('${item['userId']}');
    if (doctorId == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient chat unavailable for this appointment')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorChatScreen(
          api: context.read<AuthState>().api,
          doctorId: doctorId,
          userId: userId,
          asDoctor: true,
          title: 'Chat · ${item['clientName'] ?? 'Patient'}',
        ),
      ),
    );
  }

  Future<void> _showReviewsSheet() async {
    final res = await _svc.reviews();
    if (!mounted) return;
    final reviews = ModuleTheme.toList(res['reviews']);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Patient Reviews (${res['count'] ?? reviews.length}) · Rating ${res['rating'] ?? 0}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('No reviews yet'),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: reviews.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = reviews[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('${r['userName'] ?? 'Patient'} · ${r['rating'] ?? '-'}★'),
                        subtitle: Text(r['comment']?.toString() ?? ''),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAnalyticsSheet() async {
    final res = await _svc.analytics();
    if (!mounted) return;
    if (res['success'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Failed to load analytics')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Earnings & Reports', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              Text('Today: ₹${_money(res['todayEarnings'])}'),
              Text('This month: ₹${_money(res['monthEarnings'])}'),
              Text('All-time: ₹${_money(res['totalEarnings'])}'),
              const SizedBox(height: 8),
              Text('Appointments: ${res['totalAppointments'] ?? 0}'),
              Text('Completed: ${res['completedCount'] ?? 0} · Pending: ${res['pendingCount'] ?? 0}'),
              Text('Confirmed: ${res['confirmedCount'] ?? 0} · Cancelled: ${res['cancelledCount'] ?? 0}'),
              Text('Completion rate: ${res['completionRate'] ?? 0}%'),
              Text('Rating: ${res['rating'] ?? 0}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openInstantConsult() async {
    if (!_online) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Go Online first so patients can find you for instant consults.')),
      );
      return;
    }
    final pendingRes = await _svc.instantPending();
    if (!mounted) return;
    final requests = ModuleTheme.toList(pendingRes['requests']);
    if (requests.isNotEmpty) {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Instant consult requests', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 12),
                ...requests.map((r) {
                  final id = r['id'] is num ? (r['id'] as num).toInt() : int.tryParse('${r['id']}');
                  return Card(
                    child: ListTile(
                      title: Text('Request #${r['id']} · ${r['consultationType'] ?? 'VIDEO'}'),
                      subtitle: Text('${r['reason'] ?? 'No reason'} · expires ${r['expiresAt'] ?? ''}'),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          TextButton(
                            onPressed: id == null
                                ? null
                                : () async {
                                    Navigator.pop(ctx);
                                    final res = await _svc.declineInstant(id);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? 'Declined')),
                                    );
                                    _reload();
                                  },
                            child: const Text('Decline'),
                          ),
                          FilledButton(
                            onPressed: id == null
                                ? null
                                : () async {
                                    Navigator.pop(ctx);
                                    final res = await _svc.acceptInstant(id);
                                    if (!mounted) return;
                                    final msg = res['success'] == true
                                        ? (res['paymentRequired'] == true
                                            ? 'Accepted. Patient will complete payment for #${res['appointmentId']}.'
                                            : 'Accepted. Appointment #${res['appointmentId']} created.')
                                        : (res['error']?.toString() ?? 'Accept failed');
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                                    _reload();
                                  },
                            child: const Text('Accept'),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final ready = _appointments.where((a) {
      final status = (a['status']?.toString() ?? '').toUpperCase();
      final type = (a['consultationType']?.toString() ?? '').toUpperCase();
      return status == 'CONFIRMED' && (type == 'VIDEO' || type == 'ONLINE');
    }).toList();
    if (ready.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No instant requests right now. Keep Online + Emergency Available enabled for discovery.'),
        ),
      );
      return;
    }
    final first = ready.first;
    final id = first['id'] is num ? (first['id'] as num).toInt() : int.tryParse('${first['id']}');
    if (id == null) return;
    final res = await _svc.joinAppointment(id);
    if (!mounted) return;
    final finalUrl = res['jitsiUrl']?.toString();
    if (res['success'] == true && finalUrl != null && finalUrl.isNotEmpty) {
      final uri = Uri.tryParse(finalUrl);
      if (uri != null) {
        final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!ok && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Open this link: $finalUrl')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Unable to start instant consult')),
      );
    }
  }

  void _showNotifications() {
    _svc.markNotificationsRead();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              if (_notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No new notifications')),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final n = _notifications[i];
                      final body = (n['message'] ?? n['body'] ?? '').toString();
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE4E6),
                          child: Icon(Icons.notifications_outlined, color: ModuleTheme.primary),
                        ),
                        title: Text(n['title']?.toString() ?? 'Update', style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(body),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final c = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  bool _inJoinWindow(DateTime? when) {
    if (when == null) return false;
    final now = DateTime.now();
    return !now.isBefore(when.subtract(const Duration(minutes: 5))) &&
        !now.isAfter(when.add(const Duration(minutes: 45)));
  }

  Widget _joinHint(DateTime? when, bool canJoin) {
    if (!canJoin || when == null) return const SizedBox.shrink();
    final diff = when.difference(DateTime.now());
    if (diff.inMinutes <= 10 && diff.inMinutes >= -30) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('Ready to Join', style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w700)),
      );
    }
    if (diff.isNegative) return const SizedBox.shrink();
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    final label = h > 0 ? 'Starts in $h hour${h == 1 ? '' : 's'} $m minutes' : 'Starts in $m minutes';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _profileCard() {
    final name = _doctor['fullName']?.toString() ?? 'Doctor';
    final specialty = _doctor['specialization']?.toString() ?? '';
    final rating = _num(_doctor['rating']);
    final verified = (_doctor['verificationStatus']?.toString() ?? '') == 'VERIFIED';
    final photo = ModuleTheme.mediaUrl(
      context.read<AuthState>().api.baseUrl,
      _doctor['profilePhotoPath']?.toString(),
    );
    final todayAppts = _num(_raw['todayAppointments']);
    final pending = _num(_raw['pendingCount']);
    final todayEarn = _money(_raw['todayEarnings']);
    final monthEarn = _money(_raw['monthEarnings']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFFF43F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                    child: photo.isEmpty
                        ? Text(
                            name.trim().isEmpty ? 'D' : name.trim().characters.first.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: _online ? const Color(0xFF22C55E) : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name.startsWith('Dr') ? name : 'Dr. $name',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: Color(0xFF86EFAC), size: 18),
                        ],
                      ],
                    ),
                    if (specialty.isNotEmpty)
                      Text(specialty, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      _online ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: _online ? const Color(0xFF86EFAC) : Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _online,
                activeThumbColor: const Color(0xFF22C55E),
                onChanged: (v) async {
                  setState(() => _online = v);
                  final res = await _svc.setOnline(v);
                  if (!mounted) return;
                  if (res['success'] != true) {
                    setState(() => _online = !v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['error']?.toString() ?? 'Failed to update online status')),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _pill(Icons.star_rounded, '${rating.toStringAsFixed(1)} Rating', const Color(0xFFFBBF24)),
              _pill(Icons.today_outlined, "Today's Appointments: $todayAppts", Colors.white),
              _pill(Icons.hourglass_bottom_rounded, 'Pending: $pending', const Color(0xFFFDE68A)),
              _pill(Icons.payments_outlined, "Today's Earnings: ₹$todayEarn", const Color(0xFF86EFAC)),
              _pill(Icons.calendar_month_outlined, 'This Month: ₹$monthEarn', const Color(0xFFFECDD3)),
            ],
          ),
        ],
      ),
    );
  }

  String _profileStatusLabel(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'REGISTERED':
      case 'PROFILE_INCOMPLETE':
        return 'Profile Incomplete';
      case 'READY_FOR_VERIFICATION':
        return 'Ready for Verification';
      case 'PENDING_ADMIN_APPROVAL':
        return 'Pending Admin Approval';
      case 'CHANGES_REQUESTED':
        return 'Changes Requested';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'SUSPENDED':
        return 'Suspended';
      default:
        return status == null || status.isEmpty ? 'Profile Incomplete' : status;
    }
  }

  bool get _isVerified {
    final status = (_raw['doctorProfileStatus'] ?? _doctor['doctorProfileStatus'] ?? '').toString().toUpperCase();
    final vStatus = (_doctor['verificationStatus'] ?? '').toString().toUpperCase();
    return status == 'APPROVED' || vStatus == 'VERIFIED' || _doctor['approved'] == true;
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _verificationBanner() {
    final status = (_raw['doctorProfileStatus'] ?? _doctor['doctorProfileStatus'] ?? '').toString().toUpperCase();
    final changesNote = (_raw['changesRequestedNote'] ?? _raw['rejectionReason'] ?? '').toString();

    if (_isVerified) return const SizedBox.shrink();

    if (status == 'CHANGES_REQUESTED' || status == 'REJECTED') {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(color: Color(0xFFEF4444), width: 6),
            top: BorderSide(color: Color(0xFFFECACA)),
            right: BorderSide(color: Color(0xFFFECACA)),
            bottom: BorderSide(color: Color(0xFFFECACA)),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 24),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Changes Required Before Verification',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                ),
              ],
            ),
            if (changesNote.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Note: $changesNote',
                style: const TextStyle(fontSize: 13, color: Color(0xFF7F1D1D), fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DoctorProfileCompletionScreen(
                      onFinished: (ctx) => Navigator.of(ctx).pop(),
                    ),
                  ),
                );
                _reload();
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('Update Profile Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // PENDING_ADMIN_APPROVAL or unverified
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFFF59E0B), width: 6),
          top: BorderSide(color: Color(0xFFFDE68A)),
          right: BorderSide(color: Color(0xFFFDE68A)),
          bottom: BorderSide(color: Color(0xFFFDE68A)),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hourglass_top_rounded, color: Color(0xFFD97706), size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Verification in Progress — Wait for Verification to Add Services',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Your profile and medical credentials have been submitted and are currently awaiting review by the admin team. Clinical services, appointments, chats, and schedule configuration will unlock once your account is verified.',
            style: TextStyle(fontSize: 13, color: Color(0xFF78350F), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _lockedBanner(String feature) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_clock_outlined, size: 48, color: Color(0xFFD97706)),
          const SizedBox(height: 12),
          Text(
            '$feature Locked',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF92400E)),
          ),
          const SizedBox(height: 8),
          const Text(
            'This feature unlocks automatically once your doctor credentials have been approved by the Admin.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF78350F), height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _profileCompletionBanner() {
    final status = (_raw['doctorProfileStatus'] ?? _doctor['doctorProfileStatus'] ?? 'PROFILE_INCOMPLETE')
        .toString();
    final statusLabel = (_raw['doctorProfileStatusLabel'] ?? _profileStatusLabel(status)).toString();
    final pct = _num(_raw['profileCompletionPct'] ?? _doctor['profileCompletionPct']).clamp(0, 100).toDouble();
    final missing = ModuleTheme.toList(_raw['missingItems']);
    final missingText = missing.take(3).map((e) => e.toString()).join(', ');
    final canSubmit = _raw['canSubmitForVerification'] == true;
    final guidance = _raw['nextStepGuidance']?.toString();
    final hasPending = _raw['hasPendingReverification'] == true;
    if (status == 'APPROVED' && pct >= 100 && !hasPending) {
      return const SizedBox.shrink();
    }
    return ProfileCompletionCard(
      percent: pct,
      statusLabel: statusLabel,
      hint: ProfileCompletionCard.hintFromMissing(
        missing.map((e) => e.toString()).toList(),
        guidance: guidance,
      ),
      actionLabel: canSubmit ? 'Review & Submit' : 'Complete Profile',
      onAction: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DoctorProfileCompletionScreen(
              onFinished: (ctx) => Navigator.of(ctx).pop(),
            ),
          ),
        );
        if (mounted) _reload();
      },
      trailing: missingText.isNotEmpty
          ? Text(
              'Missing: $missingText${missing.length > 3 ? '...' : ''}',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
            )
          : null,
    );
  }

  Widget _pill(IconData icon, String text, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray)),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    final items = [
      (Icons.calendar_month_outlined, 'Schedule', () => setState(() => _navIndex = 5)),
      (Icons.groups_outlined, 'Patients', () => setState(() => _navIndex = 2)),
      (Icons.chat_bubble_outline, 'Messages', () => setState(() => _navIndex = 3)),
      (Icons.payments_outlined, 'Earnings', () => setState(() => _navIndex = 6)),
      (Icons.medical_services_outlined, 'Prescriptions', () => setState(() => _navIndex = 7)),
      (Icons.bar_chart_outlined, 'Reports', () => _showAnalyticsSheet()),
    ];
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final it = items[i];
          return InkWell(
            onTap: it.$3,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 86,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(it.$1, color: ModuleTheme.primary),
                  const SizedBox(height: 6),
                  Text(it.$2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appointmentCard(Map<String, dynamic> item) {
    final id = item['id'] is int ? item['id'] as int : int.tryParse('${item['id']}');
    final type = item['consultationType']?.toString() ?? '';
    final status = item['status']?.toString() ?? 'PENDING';
    final when = _parseTime(item['appointmentTime']);
    final canJoin = item['canJoin'] == true ||
        ((type == 'VIDEO' || type == 'ONLINE' || (item['meetingRoomId']?.toString().isNotEmpty == true)) &&
            _inJoinWindow(when));
    final hasRx = (item['prescriptionText']?.toString() ?? '').trim().isNotEmpty;
    final reason = item['reason']?.toString() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openAppointmentPreview(item),
        borderRadius: BorderRadius.circular(18),
        child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Patient: ${item['clientName'] ?? 'Unknown'}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                ),
              ),
              _statusBadge(status),
              if (id != null)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'RESCHEDULE') {
                      _rescheduleAsDoctor(item);
                    } else {
                      _setStatus(id, v);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'CONFIRMED', child: Text('Confirm')),
                    PopupMenuItem(value: 'COMPLETED', child: Text('Complete')),
                    PopupMenuItem(value: 'RESCHEDULE', child: Text('Reschedule')),
                    PopupMenuItem(value: 'CANCELLED', child: Text('Cancel')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (when != null) ...[
            Text('Date: ${_formatDate(when)}', style: const TextStyle(color: ModuleTheme.textGray)),
            Text('Time: ${_formatTime(when)}', style: const TextStyle(color: ModuleTheme.textGray)),
          ],
          Row(
            children: [
              Icon(_modeIcon(type), size: 16, color: ModuleTheme.primary),
              const SizedBox(width: 4),
              Text('Mode: ${_modeLabel(type)}', style: const TextStyle(color: ModuleTheme.textGray)),
            ],
          ),
          if (item['amountPaid'] != null)
            Text('Fee: ₹${_money(item['amountPaid'])}', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              if (item['patientAge'] != null) Text('Age: ${item['patientAge']}', style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
              if (item['patientGender'] != null) Text('Gender: ${item['patientGender']}', style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
              if (item['patientId'] != null) Text('Patient ID: ${item['patientId']}', style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
              if (id != null) Text('Appointment ID: #$id', style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
            ],
          ),
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text('Reason', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            Text(reason, style: const TextStyle(color: ModuleTheme.textGray, height: 1.35)),
          ],
          if (hasRx) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Prescription Sent\n${item['prescriptionText']}',
                style: const TextStyle(color: Color(0xFF166534), fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _joinHint(when, canJoin),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openChat(item),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Chat'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: id == null
                      ? null
                      : () => _savePrescription(id, item['prescriptionText']?.toString() ?? ''),
                  icon: Icon(hasRx ? Icons.check_circle_outline : Icons.description_outlined, size: 18),
                  label: Text(hasRx ? 'Update Rx' : 'Prescription'),
                ),
              ),
              if (canJoin && id != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: ModuleTheme.primary),
                    onPressed: () {
                      _svc.pingWaiting(id);
                      openDoctorJitsi(
                        context,
                        context.read<AuthState>().api,
                        id,
                        asDoctor: true,
                      );
                    },
                    icon: const Icon(Icons.videocam, size: 18),
                    label: const Text('Join'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _emptyAppointments({bool todayOnly = false}) {
    if (todayOnly) {
      return EmptyStateView(
        icon: Icons.event_available_outlined,
        title: 'No appointments today',
        message: "You're all caught up for today.\nNew bookings will appear here when patients schedule with you.",
        secondaryLabel: 'Browse Help',
        onSecondary: () => showDoctorSetupHelp(context),
      );
    }
    return EmptyStateView(
      icon: Icons.event_available_outlined,
      title: 'No appointments yet',
      message: 'Appointments booked by patients will appear here.',
      actionLabel: 'Browse Help',
      onAction: () => showDoctorSetupHelp(context),
    );
  }

  Widget _homeTab() {
    final list = _filtered;
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          _profileCard(),
          const SizedBox(height: 12),
          _verificationBanner(),
          _profileCompletionBanner(),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard("Today's Appts", '${_num(_raw['todayAppointments'])}', Icons.today_outlined, ModuleTheme.primary),
              const SizedBox(width: 8),
              _statCard('Pending', '${_num(_raw['pendingCount'])}', Icons.hourglass_empty, const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              _statCard('Completed', '${_num(_raw['completedCount'])}', Icons.check_circle_outline, const Color(0xFF16A34A)),
              const SizedBox(width: 8),
              _statCard("Today's ₹", _money(_raw['todayEarnings']), Icons.payments_outlined, const Color(0xFF22C55E)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Quick actions', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          _quickActions(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: Text('Appointments', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
              TextButton(onPressed: () => setState(() => _navIndex = 1), child: const Text('See all')),
            ],
          ),
          if (list.isEmpty) _emptyAppointments(todayOnly: true) else ...list.take(5).map(_appointmentCard),
        ],
      ),
    );
  }

  Widget _appointmentsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by patient name',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final f in const [
                ('ALL', 'All'),
                ('TODAY', 'Today'),
                ('PENDING', 'Pending'),
                ('COMPLETED', 'Completed'),
                ('VIDEO', 'Video'),
                ('CLINIC', 'In Clinic'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f.$2),
                    selected: _filter == f.$1,
                    onSelected: (_) => setState(() => _filter = f.$1),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _reload,
            child: _filtered.isEmpty
                ? ListView(children: [_emptyAppointments()])
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    children: _filtered.map(_appointmentCard).toList(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _patientsTab() {
    final patients = _patients;
    return RefreshIndicator(
      onRefresh: _reload,
      child: patients.isEmpty
          ? ListView(
              children: [
                EmptyStateView(
                  icon: Icons.people_outline,
                  title: 'No patients yet',
                  message: 'Patients will appear here after they book an appointment with you.',
                  secondaryLabel: 'Need help?',
                  onSecondary: () => showDoctorSetupHelp(context),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: patients.length,
              itemBuilder: (_, i) {
                final p = patients[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFE4E6),
                      child: Text(
                        (p['clientName']?.toString() ?? 'P').characters.first.toUpperCase(),
                        style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w800),
                      ),
                    ),
                    title: Text(p['clientName']?.toString() ?? 'Patient', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      [
                        if (p['patientId'] != null) '${p['patientId']}',
                        if (p['patientAge'] != null) 'Age ${p['patientAge']}',
                        if (p['patientGender'] != null) '${p['patientGender']}',
                        if (p['clientPhone'] != null) '${p['clientPhone']}',
                        if (p['reason'] != null) '${p['reason']}',
                      ].where((e) => e.toString().isNotEmpty).join(' · '),
                    ),
                    onTap: () => _openPatientFile(p),
                    trailing: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () => _openChat(p),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _messagesTab() {
    final chats = _patients;
    return RefreshIndicator(
      onRefresh: _reload,
      child: chats.isEmpty
          ? ListView(
              children: [
                EmptyStateView(
                  icon: Icons.chat_bubble_outline,
                  title: 'No conversations yet',
                  message: 'Chat with patients once they have an active appointment with you.',
                  secondaryLabel: 'Need help?',
                  onSecondary: () => showDoctorSetupHelp(context),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: chats.length,
              itemBuilder: (_, i) {
                final p = chats[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(p['clientName']?.toString() ?? 'Patient'),
                  subtitle: const Text('Tap to open chat'),
                  onTap: () => _openChat(p),
                );
              },
            ),
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _profileCard(),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Complete / Update Profile'),
                subtitle: const Text('Professional details, documents, and verification'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DoctorProfileCompletionScreen(
                        onFinished: (ctx) => Navigator.of(ctx).pop(),
                      ),
                    ),
                  );
                  if (mounted) _reload();
                },
              ),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(_doctor['email']?.toString() ?? '—'),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Phone'),
                subtitle: Text(_doctor['phone']?.toString() ?? '—'),
              ),
              ListTile(
                leading: const Icon(Icons.local_hospital_outlined),
                title: const Text('Hospital'),
                subtitle: Text(_doctor['hospitalName']?.toString() ?? '—'),
              ),
              ListTile(
                leading: const Icon(Icons.verified_outlined),
                title: const Text('Verification'),
                subtitle: Text(
                  (_raw['doctorProfileStatusLabel'] ??
                          _profileStatusLabel(_raw['doctorProfileStatus']?.toString() ?? _doctor['doctorProfileStatus']?.toString()))
                      .toString(),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rating & Reviews'),
                subtitle: Text('${_doctor['rating'] ?? _raw['rating'] ?? 0}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showReviewsSheet,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.emergency_outlined),
                title: const Text('Emergency / Instant available'),
                subtitle: const Text('Shown to patients for instant consult discovery'),
                value: _doctor['emergencyAvailable'] == true || _raw['emergencyAvailable'] == true,
                onChanged: (v) async {
                  final res = await _svc.updateProfile({'emergencyAvailable': v});
                  if (!mounted) return;
                  if (res['success'] == true) {
                    _reload();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['error']?.toString() ?? 'Update failed')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('Earnings'),
                subtitle: Text(
                  "Today ₹${_money(_raw['todayEarnings'])} · This month ₹${_money(_raw['monthEarnings'])} · All-time ₹${_money(_raw['totalEarnings'])}",
                ),
                onTap: _showAnalyticsSheet,
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('Request payout'),
                subtitle: Text(
                  (_doctor['upiId'] ?? _raw['upiId']) == null
                      ? 'Add UPI in Complete Profile first'
                      : 'UPI ${ _doctor['upiId'] ?? _raw['upiId'] }',
                ),
                onTap: () async {
                  final res = await _svc.requestPayout();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? 'Requested')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scheduleTab() {
    if (!_isVerified) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _lockedBanner('Schedule & Slots'),
        ],
      );
    }
    final rawSlots = DoctorCatalog.parseAvailabilitySlots(_doctor['availabilitySlots']);
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consultation Hours & Availability Slots', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Set up the regular time slots when patients can book clinic or video appointments.', style: TextStyle(color: ModuleTheme.textGray, fontSize: 13)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Active Slots (${rawSlots.length})', style: const TextStyle(fontWeight: FontWeight.w700)),
                      TextButton.icon(
                        onPressed: () => _openAddSlotDialog(rawSlots),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Slot'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (rawSlots.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: const Text('No availability slots configured.\nTap "Add Slot" to set your hours.', textAlign: TextAlign.center, style: TextStyle(color: ModuleTheme.textGray)),
                    )
                  else
                    ...rawSlots.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4E6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (s['day'] ?? '').length >= 3 ? (s['day'] ?? '').substring(0, 3).toUpperCase() : (s['day'] ?? ''),
                                style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w800, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${s['start']} - ${s['end']}',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () => _deleteSlot(rawSlots, i),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Consultation Modes & Settings', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _settingRow('Slot Duration', '${_doctor['slotDurationMinutes'] ?? 30} minutes'),
                  _settingRow('Buffer Time', '${_doctor['bufferMinutes'] ?? 0} minutes'),
                  _settingRow('Auto Confirm', _doctor['autoConfirm'] == true ? 'Enabled' : 'Disabled'),
                  _settingRow('Emergency Consultation', _doctor['emergencyAvailable'] == true ? 'Active' : 'Inactive'),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DoctorProfileCompletionScreen(
                            onFinished: (ctx) => Navigator.of(ctx).pop(),
                          ),
                        ),
                      );
                      _reload();
                    },
                    icon: const Icon(Icons.tune),
                    label: const Text('Edit Timing & Slot Parameters'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddSlotDialog(List<Map<String, String>> existingSlots) async {
    const days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
    var selectedDay = 'MONDAY';
    var start = const TimeOfDay(hour: 9, minute: 0);
    var end = const TimeOfDay(hour: 17, minute: 0);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Availability Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDay,
                decoration: const InputDecoration(labelText: 'Day of Week', border: OutlineInputBorder()),
                items: days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setDialogState(() => selectedDay = v ?? selectedDay),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: ctx, initialTime: start);
                        if (picked != null) setDialogState(() => start = picked);
                      },
                      child: Text('Start: ${_formatTimeOfDay(start)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: ctx, initialTime: end);
                        if (picked != null) setDialogState(() => end = picked);
                      },
                      child: Text('End: ${_formatTimeOfDay(end)}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save Slot')),
          ],
        ),
      ),
    );

    if (ok != true) return;
    final updated = List<Map<String, String>>.from(existingSlots)
      ..add({
        'day': selectedDay,
        'start': _formatTimeOfDay(start),
        'end': _formatTimeOfDay(end),
      });

    final res = await _svc.updateProfile({'availabilitySlots': updated});
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Availability slot added')));
      _reload();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error']?.toString() ?? 'Failed')));
    }
  }

  Future<void> _deleteSlot(List<Map<String, String>> existingSlots, int index) async {
    final updated = List<Map<String, String>>.from(existingSlots)..removeAt(index);
    final res = await _svc.updateProfile({'availabilitySlots': updated});
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot removed')));
      _reload();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error']?.toString() ?? 'Failed')));
    }
  }

  Widget _earningsTab() {
    if (!_isVerified) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _lockedBanner('Earnings & Payouts'),
        ],
      );
    }
    final todayEarn = _money(_raw['todayEarnings']);
    final monthEarn = _money(_raw['monthEarnings']);
    final totalEarn = _money(_raw['totalEarnings']);
    final completed = _raw['completedCount'] ?? 0;
    final upi = _doctor['upiId']?.toString() ?? '';

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFFF43F5E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Net Earnings', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('₹$totalEarn', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's Earnings", style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('₹$todayEarn', style: const TextStyle(color: Color(0xFF86EFAC), fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('This Month', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('₹$monthEarn', style: const TextStyle(color: Color(0xFFFECDD3), fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payout Request', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('Consultation earnings accumulate in your wallet and are transferred to your registered UPI ID.', style: TextStyle(color: ModuleTheme.textGray, fontSize: 13, height: 1.4)),
                  const Divider(height: 24),
                  _settingRow('Registered UPI', upi.isNotEmpty ? upi : 'Not configured (add in profile)'),
                  _settingRow('Completed Consultations', '$completed visits'),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: upi.isEmpty
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please add your UPI ID in Complete Profile before requesting a payout.')),
                              );
                            }
                          : () async {
                              final res = await _svc.requestPayout();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res['message']?.toString() ?? res['error']?.toString() ?? 'Payout requested'),
                                  backgroundColor: res['success'] == true ? const Color(0xFF16A34A) : Colors.red,
                                ),
                              );
                            },
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text('Request Payout to UPI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ModuleTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fee Structure', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _settingRow('Clinic Consultation Fee', '₹${_money(_doctor['consultationFee'])}'),
                  _settingRow('Video Consultation Fee', '₹${_money(_doctor['videoFee'] ?? _doctor['consultationFee'])}'),
                  _settingRow('Chat Consultation Fee', '₹${_money(_doctor['chatFee'] ?? 0)}'),
                  _settingRow('Home Visit Fee', '₹${_money(_doctor['callFee'] ?? _doctor['consultationFee'])}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _prescriptionsTab() {
    if (!_isVerified) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _lockedBanner('Prescriptions'),
        ],
      );
    }
    final rxAppts = _appointments.where((a) {
      final hasRx = (a['prescriptionText']?.toString() ?? '').trim().isNotEmpty;
      final status = (a['status']?.toString() ?? '').toUpperCase();
      return hasRx || status == 'COMPLETED' || status == 'CONFIRMED';
    }).toList();

    return RefreshIndicator(
      onRefresh: _reload,
      child: rxAppts.isEmpty
          ? ListView(
              children: [
                EmptyStateView(
                  icon: Icons.description_outlined,
                  title: 'No prescriptions yet',
                  message: 'When you write prescriptions during or after consultations, they will be archived here.',
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: rxAppts.length,
              itemBuilder: (_, i) {
                final a = rxAppts[i];
                final id = a['id'] is num ? (a['id'] as num).toInt() : int.tryParse('${a['id']}');
                final patientName = a['clientName']?.toString() ?? 'Patient';
                final hasRx = (a['prescriptionText']?.toString() ?? '').trim().isNotEmpty;
                final rxText = a['prescriptionText']?.toString() ?? '';
                final when = _parseTime(a['appointmentTime']);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFFFE4E6),
                              child: Icon(Icons.receipt_long_outlined, color: ModuleTheme.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(patientName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                  if (when != null)
                                    Text(_formatDate(when), style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
                                ],
                              ),
                            ),
                            _statusBadge(a['status']?.toString() ?? 'CONFIRMED'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (hasRx) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFBBF7D0)),
                            ),
                            child: Text(
                              rxText,
                              style: const TextStyle(color: Color(0xFF166534), fontSize: 13, height: 1.4),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ] else ...[
                          const Text('No prescription issued yet for this visit.', style: TextStyle(color: ModuleTheme.textGray, fontSize: 13)),
                          const SizedBox(height: 10),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: id == null ? null : () => _savePrescription(id, rxText),
                              icon: Icon(hasRx ? Icons.edit_outlined : Icons.add, size: 16),
                              label: Text(hasRx ? 'Edit Rx' : 'Write Rx'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _settingRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600)),
          Text(v, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Widget _drawerTile(int index, IconData icon, String title, {bool locked = false, String? badge}) {
    final selected = _navIndex == index;
    return ListTile(
      leading: Icon(icon, color: selected ? ModuleTheme.primary : (locked ? Colors.grey : const Color(0xFF334155))),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? ModuleTheme.primary : (locked ? Colors.grey : const Color(0xFF0F172A)),
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      trailing: locked
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, size: 12, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Locked', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w700)),
                ],
              ),
            )
          : (badge != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ModuleTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                )
              : null),
      onTap: () {
        Navigator.pop(context);
        if (locked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This section unlocks once your profile is verified by the admin.'),
              backgroundColor: Color(0xFF0F172A),
            ),
          );
          return;
        }
        setState(() => _navIndex = index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthState>();
    final pages = [
      _homeTab(),
      _appointmentsTab(),
      _patientsTab(),
      _messagesTab(),
      _profileTab(),
      _scheduleTab(),
      _earningsTab(),
      _prescriptionsTab(),
    ];

    final doctorName = _doctor['fullName']?.toString() ?? 'Doctor';
    final displayName = doctorName.startsWith('Dr') ? doctorName : 'Dr. $doctorName';
    final specialty = _doctor['specialization']?.toString() ?? 'Doctor Portal';
    final pendingCount = _raw['pendingCount'] is num ? (_raw['pendingCount'] as num).toInt() : 0;
    final pct = _num(_raw['profileCompletionPct'] ?? _doctor['profileCompletionPct']).clamp(0, 100).toInt();

    final titles = [
      'Doctor Dashboard',
      'Appointments',
      'Patients',
      'Chats & Messages',
      'My Profile',
      'Schedule & Slots',
      'Earnings & Fees',
      'Prescriptions',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _navIndex < titles.length ? titles[_navIndex] : 'Doctor Dashboard',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              '$displayName · $_greeting',
              style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: _showNotifications,
            icon: Badge(
              isLabelVisible: _notifications.isNotEmpty,
              label: Text('${_notifications.length}'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFFFFE4E6),
                child: Text(
                  doctorName.isNotEmpty ? doctorName.characters.first.toUpperCase() : 'D',
                  style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w800, fontSize: 24),
                ),
              ),
              accountName: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w800)),
              accountEmail: Text(
                '$specialty · ${_online ? "Online" : "Offline"}',
                style: TextStyle(color: _online ? const Color(0xFF86EFAC) : Colors.white70),
              ),
            ),
            _drawerTile(0, Icons.grid_view_outlined, 'Dashboard / Overview'),
            _drawerTile(1, Icons.calendar_month_outlined, 'Appointments', locked: !_isVerified, badge: pendingCount > 0 ? '$pendingCount' : null),
            _drawerTile(2, Icons.people_outline, 'Patients'),
            _drawerTile(3, Icons.chat_bubble_outline, 'Chats & Messages', locked: !_isVerified),
            _drawerTile(5, Icons.schedule_outlined, 'Schedule & Slots', locked: !_isVerified),
            _drawerTile(6, Icons.wallet_outlined, 'Earnings & Fees', locked: !_isVerified),
            _drawerTile(7, Icons.medical_services_outlined, 'Prescriptions', locked: !_isVerified),
            _drawerTile(4, Icons.person_outline, 'My Profile'),
            if (pct < 100 || !_isVerified)
              ListTile(
                leading: const Icon(Icons.person_pin_outlined, color: Color(0xFFEA580C)),
                title: const Text('Complete Profile', style: TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.w700)),
                trailing: Text('$pct%', style: const TextStyle(color: Color(0xFFEA580C), fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DoctorProfileCompletionScreen(
                        onFinished: (ctx) => Navigator.of(ctx).pop(),
                      ),
                    ),
                  ).then((_) => _reload());
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openInstantConsult,
        backgroundColor: ModuleTheme.primary,
        icon: const Icon(Icons.bolt_outlined),
        label: const Text('Instant Consult'),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _reload)
              : pages[_navIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex > 4 ? 0 : _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event_outlined), selectedIcon: Icon(Icons.event), label: 'Appointments'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Patients'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
