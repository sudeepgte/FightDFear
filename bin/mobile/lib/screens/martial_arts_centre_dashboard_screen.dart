import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_state.dart';
import '../services/centre_auth_service.dart';
import 'martial_arts_centre_login_screen.dart';

class MartialArtsCentreDashboardScreen extends StatefulWidget {
  const MartialArtsCentreDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentreDashboardScreen> createState() =>
      _MartialArtsCentreDashboardScreenState();
}

class _MartialArtsCentreDashboardScreenState extends State<MartialArtsCentreDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final CentreAuthService _auth;
  late final TabController _tabs;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _auth = CentreAuthService(context.read<AuthState>().api);
    _tabs = TabController(length: 6, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _auth.dashboardMeta();
      if (!mounted) return;
      if (res['success'] == true) {
        _data = res;
      } else {
        _error = res['error']?.toString() ?? 'Could not load dashboard';
      }
    } catch (e) {
      if (mounted) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
      (_) => false,
    );
  }

  List<Map<String, dynamic>> _list(String key) {
    final raw = _data?[key];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Map<String, dynamic>? get _centre =>
      _data?['centre'] is Map ? Map<String, dynamic>.from(_data!['centre'] as Map) : null;

  Map<String, dynamic>? get _meta =>
      _data?['meta'] is Map ? Map<String, dynamic>.from(_data!['meta'] as Map) : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreDashboardScreen.navy,
        title: const Text('Centre Hub', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: MartialArtsCentreDashboardScreen.primary,
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: MartialArtsCentreDashboardScreen.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Batches'),
            Tab(text: 'Students'),
            Tab(text: 'Attendance'),
            Tab(text: 'Live'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!),
                      TextButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabs,
                  children: [
                    _OverviewTab(centre: _centre, meta: _meta),
                    _BatchesTab(auth: _auth, batches: _list('batches'), onChanged: _load),
                    _StudentsTab(auth: _auth, students: _list('enrollments'), onChanged: _load),
                    _AttendanceTab(auth: _auth, batches: _list('batches')),
                    _LiveClassesTab(auth: _auth, classes: _list('onlineClasses'), batches: _list('batches'), onChanged: _load),
                    _SettingsTab(auth: _auth, centre: _centre, onSaved: _load),
                  ],
                ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({this.centre, this.meta});
  final Map<String, dynamic>? centre;
  final Map<String, dynamic>? meta;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          centre?['name']?.toString() ?? 'Your centre',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: MartialArtsCentreDashboardScreen.navy),
        ),
        Text(centre?['location']?.toString() ?? '', style: const TextStyle(color: Color(0xFF64748B))),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard('Enrollments', '${meta?['totalEnrollments'] ?? 0}'),
            _StatCard('Active batches', '${meta?['activeBatches'] ?? 0}'),
            _StatCard('Earnings', '₹${(meta?['totalEarnings'] is num ? (meta!['totalEarnings'] as num).toStringAsFixed(0) : '0')}'),
            _StatCard('Avg attendance', '${meta?['avgAttendance'] ?? 0}%'),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        ],
      ),
    );
  }
}

class _BatchesTab extends StatefulWidget {
  const _BatchesTab({required this.auth, required this.batches, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> batches;
  final VoidCallback onChanged;

  @override
  State<_BatchesTab> createState() => _BatchesTabState();
}

class _BatchesTabState extends State<_BatchesTab> {
  Future<void> _showBatchForm([Map<String, dynamic>? existing]) async {
    final nameCtrl = TextEditingController(text: existing?['name']?.toString() ?? '');
    final styleCtrl = TextEditingController(text: existing?['style']?.toString() ?? '');
    final instructorCtrl = TextEditingController(text: existing?['instructor']?.toString() ?? '');
    final daysCtrl = TextEditingController(text: existing?['availableDays']?.toString() ?? 'MON,TUE,WED,THU,FRI');
    final slotCtrl = TextEditingController(text: existing?['timeSlot']?.toString() ?? '');
    final feeCtrl = TextEditingController(text: '${existing?['fee'] ?? 0}');
    final capacityCtrl = TextEditingController(text: '${existing?['capacity'] ?? 20}');
    String batchType = existing?['batchType']?.toString() ?? 'Offline';
    String status = existing?['status']?.toString() ?? 'Active';
    final id = existing?['id'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(existing == null ? 'Create batch' : 'Edit batch', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: styleCtrl, decoration: const InputDecoration(labelText: 'Style', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: instructorCtrl, decoration: const InputDecoration(labelText: 'Instructor', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: daysCtrl, decoration: const InputDecoration(labelText: 'Days (MON,TUE,...)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: slotCtrl, decoration: const InputDecoration(labelText: 'Time slot', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: feeCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fee (₹)', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: capacityCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Capacity', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: batchType,
                decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                  DropdownMenuItem(value: 'Online', child: Text('Online')),
                ],
                onChanged: (v) => batchType = v ?? batchType,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Upcoming', child: Text('Upcoming')),
                  DropdownMenuItem(value: 'Full', child: Text('Full')),
                  DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                ],
                onChanged: (v) => status = v ?? status,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final body = <String, dynamic>{
                    if (id != null) 'id': id,
                    'name': nameCtrl.text.trim(),
                    'style': styleCtrl.text.trim(),
                    'instructor': instructorCtrl.text.trim(),
                    'availableDays': daysCtrl.text.trim(),
                    'timeSlot': slotCtrl.text.trim(),
                    'fee': double.tryParse(feeCtrl.text.trim()) ?? 0,
                    'capacity': int.tryParse(capacityCtrl.text.trim()) ?? 20,
                    'batchType': batchType,
                    'status': status,
                  };
                  final res = await widget.auth.saveBatch(body);
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message']?.toString() ?? (res['success'] == true ? 'Saved' : 'Failed'))),
                  );
                  if (res['success'] == true) widget.onChanged();
                },
                style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
                child: const Text('Save batch'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final batches = widget.batches.where((b) => b['isBatch'] != false).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showBatchForm(),
              icon: const Icon(Icons.add),
              label: const Text('Create batch'),
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
            ),
          ),
        ),
        Expanded(
          child: batches.isEmpty
              ? const Center(child: Text('No batches yet'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: batches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final b = batches[i];
                    final bid = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                    return Card(
                      child: ListTile(
                        title: Text(b['name']?.toString() ?? 'Batch'),
                        subtitle: Text('${b['style'] ?? ''} · ${b['status'] ?? ''} · ₹${b['fee'] ?? 0}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (v == 'edit') {
                              await _showBatchForm(b);
                            } else if (v == 'delete' && bid != null) {
                              final res = await widget.auth.deleteBatch(bid);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(res['message']?.toString() ?? 'Done')),
                                );
                                if (res['success'] == true) widget.onChanged();
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab({required this.auth, required this.students, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> students;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) return const Center(child: Text('No students yet'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final s = students[i];
        final eid = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
        final status = s['enrollmentStatus']?.toString() ?? 'PENDING';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['traineeName']?.toString() ?? 'Student', style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${s['batchName'] ?? ''} · $status · ${s['paymentStatus'] ?? ''}'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['APPROVED', 'IN_PROGRESS', 'COMPLETED', 'REJECTED'].map((st) {
                    return ActionChip(
                      label: Text(st),
                      onPressed: eid == null
                          ? null
                          : () async {
                              final res = await auth.updateStudentStatus(eid, st);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(res['message']?.toString() ?? 'Updated')),
                                );
                                if (res['success'] == true) onChanged();
                              }
                            },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AttendanceTab extends StatefulWidget {
  const _AttendanceTab({required this.auth, required this.batches});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> batches;

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  String _date = DateTime.now().toIso8601String().substring(0, 10);
  List<Map<String, dynamic>> _sessions = [];
  Map<String, dynamic>? _selected;
  List<Map<String, dynamic>> _trainees = [];
  bool _busy = false;

  Future<void> _loadSessions() async {
    setState(() => _busy = true);
    final res = await widget.auth.attendanceSessions(date: _date);
    if (!mounted) return;
    final batches = (res['batches'] is List) ? res['batches'] as List : [];
    final classes = (res['classes'] is List) ? res['classes'] as List : [];
    _sessions = [
      ...batches.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      ...classes.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
    ];
    setState(() => _busy = false);
  }

  Future<void> _loadTrainees() async {
    if (_selected == null) return;
    setState(() => _busy = true);
    final id = _selected!['id'] is int ? _selected!['id'] as int : int.tryParse('${_selected!['id']}');
    if (id == null) return;
    final res = await widget.auth.attendanceTrainees(
      type: _selected!['type']?.toString() ?? 'BATCH',
      id: id,
      date: _date,
    );
    if (!mounted) return;
    _trainees = (res['trainees'] is List)
        ? (res['trainees'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : [];
    setState(() => _busy = false);
  }

  Future<void> _save() async {
    if (_selected == null) return;
    final id = _selected!['id'] is int ? _selected!['id'] as int : int.tryParse('${_selected!['id']}');
    if (id == null) return;
    final res = await widget.auth.saveAttendance({
      'type': _selected!['type']?.toString() ?? 'BATCH',
      'id': id,
      'date': _date,
      'trainees': _trainees.map((t) => {
            'userId': t['userId'],
            'status': t['status'] ?? 'PRESENT',
            'notes': t['notes'] ?? '',
          }).toList(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', border: OutlineInputBorder()),
                  controller: TextEditingController(text: _date),
                  onSubmitted: (v) {
                    _date = v.trim();
                    _loadSessions();
                  },
                ),
              ),
              IconButton(onPressed: _loadSessions, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        if (_busy) const LinearProgressIndicator(),
        Expanded(
          flex: 2,
          child: ListView(
            children: _sessions.map((s) {
              return ListTile(
                selected: _selected?['id'] == s['id'],
                title: Text(s['name']?.toString() ?? ''),
                subtitle: Text('${s['time'] ?? ''} · ${s['type'] ?? ''}'),
                onTap: () {
                  setState(() => _selected = s);
                  _loadTrainees();
                },
              );
            }).toList(),
          ),
        ),
        if (_trainees.isNotEmpty) ...[
          const Divider(),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: _trainees.length,
              itemBuilder: (_, i) {
                final t = _trainees[i];
                return ListTile(
                  title: Text(t['name']?.toString() ?? ''),
                  subtitle: DropdownButton<String>(
                    value: (t['status']?.toString() ?? 'PENDING').replaceAll(' ', '_'),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                      DropdownMenuItem(value: 'PRESENT', child: Text('Present')),
                      DropdownMenuItem(value: 'ABSENT', child: Text('Absent')),
                      DropdownMenuItem(value: 'LATE', child: Text('Late')),
                    ],
                    onChanged: (v) => setState(() => _trainees[i]['status'] = v),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
              child: const Text('Save attendance'),
            ),
          ),
        ],
      ],
    );
  }
}

class _LiveClassesTab extends StatefulWidget {
  const _LiveClassesTab({required this.auth, required this.classes, required this.batches, required this.onChanged});
  final CentreAuthService auth;
  final List<Map<String, dynamic>> classes;
  final List<Map<String, dynamic>> batches;
  final VoidCallback onChanged;

  @override
  State<_LiveClassesTab> createState() => _LiveClassesTabState();
}

class _LiveClassesTabState extends State<_LiveClassesTab> {
  Future<void> _createClass() async {
    final titleCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    final startCtrl = TextEditingController(text: '10:00');
    final endCtrl = TextEditingController(text: '11:00');
    final linkCtrl = TextEditingController();
    int? batchId = widget.batches.isNotEmpty
        ? (widget.batches.first['id'] is int
            ? widget.batches.first['id'] as int
            : int.tryParse('${widget.batches.first['id']}'))
        : null;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Schedule live class'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date')),
              TextField(controller: startCtrl, decoration: const InputDecoration(labelText: 'Start time')),
              TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'End time')),
              TextField(controller: linkCtrl, decoration: const InputDecoration(labelText: 'Meeting link')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (batchId == null) return;
              final res = await widget.auth.createOnlineClass({
                'title': titleCtrl.text.trim(),
                'martialArtType': 'Martial Arts',
                'date': dateCtrl.text.trim(),
                'startTime': startCtrl.text.trim(),
                'endTime': endCtrl.text.trim(),
                'meetingLink': linkCtrl.text.trim(),
                'maxStudents': 30,
                'description': '',
                'sessionType': 'Group Session',
                'notes': '',
                'batchId': batchId,
              });
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(res['message']?.toString() ?? 'Done')),
              );
              if (res['success'] == true) widget.onChanged();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _createClass,
              icon: const Icon(Icons.video_call),
              label: const Text('Schedule class'),
              style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
            ),
          ),
        ),
        Expanded(
          child: widget.classes.isEmpty
              ? const Center(child: Text('No live classes'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.classes.length,
                  itemBuilder: (_, i) {
                    final c = widget.classes[i];
                    final cid = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
                    return Card(
                      child: ListTile(
                        title: Text(c['title']?.toString() ?? c['name']?.toString() ?? 'Class'),
                        subtitle: Text('${c['date'] ?? ''} · ${c['status'] ?? ''}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) async {
                            if (cid == null) return;
                            Map<String, dynamic> res;
                            if (v == 'start') {
                              res = await widget.auth.startOnlineClass(cid);
                              final link = res['meetingLink']?.toString();
                              if (link != null && link.isNotEmpty) {
                                await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                              }
                            } else if (v == 'end') {
                              res = await widget.auth.endOnlineClass(cid);
                            } else {
                              res = await widget.auth.deleteOnlineClass(cid);
                            }
                            if (context.mounted && res['success'] == true) widget.onChanged();
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'start', child: Text('Start')),
                            PopupMenuItem(value: 'end', child: Text('End')),
                            PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatefulWidget {
  const _SettingsTab({required this.auth, this.centre, required this.onSaved});
  final CentreAuthService auth;
  final Map<String, dynamic>? centre;
  final VoidCallback onSaved;

  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _aboutCtrl;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.centre?['name']?.toString() ?? '');
    _emailCtrl = TextEditingController(text: widget.centre?['email']?.toString() ?? '');
    _phoneCtrl = TextEditingController(text: widget.centre?['phoneNumber']?.toString() ?? '');
    _locationCtrl = TextEditingController(text: widget.centre?['location']?.toString() ?? '');
    _aboutCtrl = TextEditingController(text: widget.centre?['about']?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  Future<void> _save({XFile? profile, List<XFile> gallery = const []}) async {
    setState(() => _busy = true);
    final files = <http.MultipartFile>[];
    if (profile != null) {
      files.add(await http.MultipartFile.fromPath('profileImage', profile.path));
    }
    for (final g in gallery) {
      files.add(await http.MultipartFile.fromPath('galleryPhotos', g.path));
    }
    final res = await widget.auth.updateSettings(
      fields: {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phoneNumber': _phoneCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'about': _aboutCtrl.text.trim(),
      },
      files: files,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Saved')),
    );
    if (res['success'] == true) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _locationCtrl, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder())),
        const SizedBox(height: 8),
        TextField(controller: _aboutCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'About', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final img = await picker.pickImage(source: ImageSource.gallery);
            if (img != null) await _save(profile: img);
          },
          icon: const Icon(Icons.photo),
          label: const Text('Update profile photo'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final imgs = await picker.pickMultiImage();
            if (imgs.isNotEmpty) await _save(gallery: imgs);
          },
          icon: const Icon(Icons.collections),
          label: const Text('Add gallery photos'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : () => _save(),
          style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreDashboardScreen.primary),
          child: _busy ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save settings'),
        ),
      ],
    );
  }
}
