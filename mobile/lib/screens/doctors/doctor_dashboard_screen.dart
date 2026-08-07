import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../widgets/module_theme.dart';
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
        return const Color(0xFF3B82F6);
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
    final ctrl = TextEditingController(text: existing);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Prescription'),
        content: TextField(
          controller: ctrl,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: 'Medicines, dosage, advice…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save & send')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await _svc.savePrescription(id, ctrl.text.trim());
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
    final ready = _appointments.where((a) {
      final status = (a['status']?.toString() ?? '').toUpperCase();
      final type = (a['consultationType']?.toString() ?? '').toUpperCase();
      return status == 'CONFIRMED' && (type == 'VIDEO' || type == 'ONLINE');
    }).toList();
    if (ready.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No confirmed video appointments yet. Enable Emergency Available in profile for instant discovery.'),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Join room ready: $finalUrl')));
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
          colors: [Color(0xFF1E1B4B), Color(0xFF4C1D95)],
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
                          const Icon(Icons.verified, color: Color(0xFF67E8F9), size: 18),
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
              _pill(Icons.calendar_month_outlined, 'This Month: ₹$monthEarn', const Color(0xFFA5B4FC)),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: ModuleTheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Profile Completion ${pct.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(statusLabel, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              color: pct >= 100 ? const Color(0xFF22C55E) : ModuleTheme.primary,
            ),
          ),
          if (guidance != null && guidance.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(guidance, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
          ],
          if (missingText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Missing: $missingText${missing.length > 3 ? '...' : ''}',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DoctorProfileCompletionScreen()),
                    );
                    if (mounted) _reload();
                  },
                  child: Text(canSubmit ? 'Review & Submit' : 'Complete Profile'),
                ),
              ),
            ],
          ),
        ],
      ),
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
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: ModuleTheme.navy)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray)),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    final items = [
      (Icons.calendar_month_outlined, 'Schedule', () => setState(() { _navIndex = 1; _filter = 'TODAY'; })),
      (Icons.groups_outlined, 'Patients', () => setState(() => _navIndex = 2)),
      (Icons.chat_bubble_outline, 'Messages', () => setState(() => _navIndex = 3)),
      (Icons.payments_outlined, 'Earnings', () => _showAnalyticsSheet()),
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
    final canJoin = type == 'VIDEO' || type == 'ONLINE' || (item['meetingRoomId']?.toString().isNotEmpty == true);
    final hasRx = (item['prescriptionText']?.toString() ?? '').trim().isNotEmpty;
    final reason = item['reason']?.toString() ?? '';

    return Container(
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
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: ModuleTheme.navy),
                ),
              ),
              _statusBadge(status),
              if (id != null)
                PopupMenuButton<String>(
                  onSelected: (v) => _setStatus(id, v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'CONFIRMED', child: Text('Confirm')),
                    PopupMenuItem(value: 'COMPLETED', child: Text('Complete')),
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
                    onPressed: () => openDoctorJitsi(context, context.read<AuthState>().api, id),
                    icon: const Icon(Icons.videocam, size: 18),
                    label: const Text('Join'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyAppointments() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(color: Color(0xFFFFE4E6), shape: BoxShape.circle),
            child: const Icon(Icons.event_available_outlined, size: 42, color: ModuleTheme.primary),
          ),
          const SizedBox(height: 16),
          const Text('No appointments today', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 6),
          const Text('Relax! You\'re all caught up.', style: TextStyle(color: ModuleTheme.textGray)),
        ],
      ),
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
          _profileCompletionBanner(),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard("Today's Appts", '${_num(_raw['todayAppointments'])}', Icons.today_outlined, ModuleTheme.primary),
              const SizedBox(width: 8),
              _statCard('Pending', '${_num(_raw['pendingCount'])}', Icons.hourglass_empty, const Color(0xFFF59E0B)),
              const SizedBox(width: 8),
              _statCard('Completed', '${_num(_raw['completedCount'])}', Icons.check_circle_outline, const Color(0xFF3B82F6)),
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
          if (list.isEmpty) _emptyAppointments() else ...list.take(5).map(_appointmentCard),
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
              children: const [
                SizedBox(height: 80),
                Center(child: Text('No patients yet')),
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
                      ].where((e) => e.toString().isNotEmpty).join(' · '),
                    ),
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
              children: const [
                SizedBox(height: 80),
                Center(child: Text('No conversations yet')),
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
                    MaterialPageRoute(builder: (_) => const DoctorProfileCompletionScreen()),
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
            ],
          ),
        ),
      ],
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
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
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
        selectedIndex: _navIndex,
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
