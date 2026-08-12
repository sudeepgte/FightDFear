import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/financial_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/financial_educator_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import '../landing/landing_screen.dart';
import 'financial_educator_profile_completion_screen.dart';

class FinancialEducatorDashboardScreen extends StatefulWidget {
  const FinancialEducatorDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<FinancialEducatorDashboardScreen> createState() =>
      _FinancialEducatorDashboardScreenState();
}

class _FinancialEducatorDashboardScreenState extends State<FinancialEducatorDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  bool _acting = false;
  String? _error;
  Map<String, dynamic> _educator = {};
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _live = [];
  List<Map<String, dynamic>> _workshops = [];
  List<Map<String, dynamic>> _enrollments = [];
  double _earnings = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';

  FinancialEducatorAuthService get _svc =>
      FinancialEducatorAuthService(context.read<AuthState>().api);

  bool get _approved =>
      _educator['approved'] == true || _educator['partnerProfileStatus']?.toString() == 'APPROVED';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (res['success'] == true) {
        _educator = Map<String, dynamic>.from(res['educator'] ?? {});
        _videos = ModuleTheme.toList(res['videos']);
        _live = ModuleTheme.toList(res['liveSessions']);
        _workshops = ModuleTheme.toList(res['workshops']);
        _enrollments = ModuleTheme.toList(res['enrollments']);
        _earnings = (res['totalEarnings'] is num) ? (res['totalEarnings'] as num).toDouble() : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_educator['payoutBalance'] is num)
                ? (_educator['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _educator['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? FinancialCatalog.cancelPolicy;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await context.read<AuthState>().api.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const FinancialEducatorProfileCompletionScreen()))
        .then((_) => _load());
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _requestPayout() async {
    final res = await _svc.requestPayout();
    if (!mounted) return;
    _snack(res['success'] == true
        ? (res['message']?.toString() ?? 'Requested')
        : (res['error']?.toString() ?? 'Payout failed'));
    if (res['success'] == true) _load();
  }

  Future<void> _editNotes(Map<String, dynamic> e) async {
    final id = _nid(e);
    if (id == null) return;
    final ctrl = TextEditingController(text: e['coachNotes']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Session notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Prep notes, follow-up, materials…',
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
    final res = await _svc.updateEnrollmentNotes(id, ctrl.text.trim());
    if (!mounted) return;
    _snack(res['success'] == true ? 'Notes saved' : (res['error']?.toString() ?? 'Could not save notes'));
    if (res['success'] == true) _load();
  }

  int? _nid(Map<String, dynamic> m) {
    final v = m['numericId'] ?? m['id'];
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  Future<void> _addContent(String kind) async {
    if (!_approved) {
      _openProfile();
      return;
    }
    final title = TextEditingController();
    final extra = TextEditingController();
    final url = TextEditingController();
    final date = TextEditingController();
    final time = TextEditingController();
    final seats = TextEditingController(text: '20');
    final fee = TextEditingController(text: '0');
    final desc = TextEditingController();
    String category = FinancialCatalog.expertise.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(kind == 'video' ? 'Add video' : kind == 'live' ? 'Add live session' : 'Add workshop'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: title, decoration: const InputDecoration(labelText: 'Title *')),
              if (kind == 'video') ...[
                DropdownButtonFormField<String>(
                  initialValue: category,
                  items: FinancialCatalog.expertise
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category = v ?? category,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(controller: url, decoration: const InputDecoration(labelText: 'YouTube URL *')),
              ],
              if (kind == 'live') ...[
                TextField(controller: extra, decoration: const InputDecoration(labelText: 'Speaker')),
                TextField(controller: date, decoration: const InputDecoration(labelText: 'Date')),
                TextField(controller: time, decoration: const InputDecoration(labelText: 'Time')),
                TextField(controller: url, decoration: const InputDecoration(labelText: 'Meeting URL')),
                TextField(controller: seats, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Seats')),
                TextField(controller: fee, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fee (₹, 0 = free)')),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  items: FinancialCatalog.expertise
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category = v ?? category,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
              if (kind == 'workshop') ...[
                TextField(controller: extra, decoration: const InputDecoration(labelText: 'Venue')),
                TextField(controller: date, decoration: const InputDecoration(labelText: 'Date')),
                TextField(controller: time, decoration: const InputDecoration(labelText: 'Time')),
                TextField(controller: url, decoration: const InputDecoration(labelText: 'City')),
                TextField(controller: seats, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Seats')),
                TextField(controller: fee, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fee (₹, 0 = free)')),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  items: FinancialCatalog.expertise
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => category = v ?? category,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
              TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Publish')),
        ],
      ),
    );
    if (ok != true) return;
    if (title.text.trim().isEmpty) {
      _snack('Title is required');
      return;
    }
    if (_acting) return;
    setState(() => _acting = true);
    Map<String, dynamic> res;
    if (kind == 'video') {
      res = await _svc.addVideo({
        'title': title.text.trim(),
        'category': category,
        'videoUrl': url.text.trim(),
        'description': desc.text.trim(),
      });
    } else if (kind == 'live') {
      res = await _svc.addLive({
        'title': title.text.trim(),
        'speaker': extra.text.trim(),
        'date': date.text.trim(),
        'time': time.text.trim(),
        'meetingUrl': url.text.trim(),
        'seats': int.tryParse(seats.text.trim()) ?? 20,
        'fee': double.tryParse(fee.text.trim()) ?? 0,
        'category': category,
        'description': desc.text.trim(),
      });
    } else {
      res = await _svc.addWorkshop({
        'title': title.text.trim(),
        'venue': extra.text.trim(),
        'date': date.text.trim(),
        'time': time.text.trim(),
        'city': url.text.trim(),
        'seats': int.tryParse(seats.text.trim()) ?? 20,
        'fee': double.tryParse(fee.text.trim()) ?? 0,
        'category': category,
        'description': desc.text.trim(),
      });
    }
    if (mounted) setState(() => _acting = false);
    _snack(res['success'] == true ? (res['message']?.toString() ?? 'Saved') : res['error']?.toString() ?? 'Failed');
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final name = _educator['fullName']?.toString() ?? 'Educator';
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: FinancialEducatorDashboardScreen.navy,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Educator Studio', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: FinancialEducatorDashboardScreen.primary,
          onPressed: () {
            if (!_approved) {
              _openProfile();
              return;
            }
            showModalBottomSheet<void>(
              context: context,
              builder: (ctx) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(leading: const Icon(Icons.play_circle_outline), title: const Text('Add video'), onTap: () {
                      Navigator.pop(ctx);
                      _addContent('video');
                    }),
                    ListTile(leading: const Icon(Icons.live_tv_outlined), title: const Text('Add live session'), onTap: () {
                      Navigator.pop(ctx);
                      _addContent('live');
                    }),
                    ListTile(leading: const Icon(Icons.groups_outlined), title: const Text('Add workshop'), onTap: () {
                      Navigator.pop(ctx);
                      _addContent('workshop');
                    }),
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.library_books_outlined), label: 'Content'),
            NavigationDestination(icon: Icon(Icons.how_to_reg_outlined), label: 'Signups'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Finance'),
          ],
        ),
        body: _loading
            ? ModuleTheme.loading()
            : _error != null
                ? ModuleTheme.errorView(_error!, _load)
                : switch (_tab) {
                    1 => _contentTab(),
                    2 => _signupsTab(),
                    3 => _profileTab(),
                    _ => _homeTab(),
                  },
      ),
    );
  }

  Widget _gate() {
    if (_approved) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ProfileCompletionCard(
        percent: (_educator['profileCompletionPct'] is num)
            ? (_educator['profileCompletionPct'] as num).toDouble()
            : 0,
        statusLabel: _educator['partnerProfileStatusLabel']?.toString() ?? 'Pending',
        hint: _educator['nextStepGuidance']?.toString() ??
            'Complete your profile and wait for admin approval before publishing.',
        actionLabel: 'Complete profile',
        onAction: _openProfile,
      ),
    );
  }

  Widget _homeTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gate(),
          _stat('Videos', '${_videos.length}'),
          _stat('Live sessions', '${_live.length}'),
          _stat('Workshops', '${_workshops.length}'),
          _stat('Signups', '${_enrollments.length}'),
        ],
      ),
    );
  }

  Widget _contentTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gate(),
          const Text('Videos', style: TextStyle(fontWeight: FontWeight.w700)),
          ..._videos.map((v) => _tile(v['title']?.toString() ?? 'Video', v['category']?.toString(), () async {
            final id = _nid(v);
            if (id == null) return;
            await _svc.deleteVideo(id);
            _load();
          })),
          const SizedBox(height: 16),
          const Text('Live sessions', style: TextStyle(fontWeight: FontWeight.w700)),
          ..._live.map((v) => _tile(v['title']?.toString() ?? 'Session', '${v['date'] ?? ''} ${v['time'] ?? ''}', () async {
            final id = _nid(v);
            if (id == null) return;
            await _svc.deleteLive(id);
            _load();
          })),
          const SizedBox(height: 16),
          const Text('Workshops', style: TextStyle(fontWeight: FontWeight.w700)),
          ..._workshops.map((v) => _tile(v['title']?.toString() ?? 'Workshop', v['city']?.toString(), () async {
            final id = _nid(v);
            if (id == null) return;
            await _svc.deleteWorkshop(id);
            _load();
          })),
        ],
      ),
    );
  }

  Widget _signupsTab() {
    final pending = _enrollments.where((e) => e['status']?.toString() == 'pending').toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _gate(),
          if (_enrollments.isEmpty) const Text('No registrations yet', style: TextStyle(color: ModuleTheme.textGray)),
          ..._enrollments.map((e) {
            final id = _nid(e);
            final st = e['status']?.toString() ?? '';
            final pendingItem = st == 'pending' || st == 'paid';
            final canComplete = st == 'approved' || st == 'paid';
            return Card(
              child: ListTile(
                title: Text(e['fullName']?.toString() ?? 'Learner'),
                subtitle: Text('${e['title'] ?? e['kind']} · $st${(e['coachNotes']?.toString() ?? '').isNotEmpty ? '\n${e['coachNotes']}' : ''}'),
                isThreeLine: (e['coachNotes']?.toString() ?? '').isNotEmpty,
                trailing: id == null || !_approved
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.notes_outlined), onPressed: () => _editNotes(e)),
                          if (pendingItem)
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: _acting
                                  ? null
                                  : () async {
                                      setState(() => _acting = true);
                                      await _svc.setEnrollmentStatus(id, 'approved');
                                      if (mounted) setState(() => _acting = false);
                                      _load();
                                    },
                            ),
                          if (pendingItem)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: _acting
                                  ? null
                                  : () async {
                                      setState(() => _acting = true);
                                      await _svc.setEnrollmentStatus(id, 'rejected');
                                      if (mounted) setState(() => _acting = false);
                                      _load();
                                    },
                            ),
                          if (canComplete)
                            IconButton(
                              icon: const Icon(Icons.done_all, color: Color(0xFF1D4ED8)),
                              onPressed: _acting
                                  ? null
                                  : () async {
                                      setState(() => _acting = true);
                                      await _svc.setEnrollmentStatus(id, 'completed');
                                      if (mounted) setState(() => _acting = false);
                                      _load();
                                    },
                            ),
                        ],
                      ),
              ),
            );
          }),
          if (pending.isEmpty) const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _gate(),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: FinancialEducatorDashboardScreen.primary),
            title: const Text('Payout balance'),
            subtitle: Text(_upiId.isEmpty ? 'Add UPI in Complete Profile to withdraw' : 'UPI: $_upiId'),
            trailing: Text('₹${_payoutBalance.round()}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Confirmed earnings'),
            trailing: Text('₹${_earnings.round()}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _requestPayout,
          style: FilledButton.styleFrom(
            backgroundColor: FinancialEducatorDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(
          _cancelPolicy.isNotEmpty ? _cancelPolicy : FinancialCatalog.cancelPolicy,
          style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Edit educator profile'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _openProfile,
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: _logout,
        ),
      ],
    );
  }

  Widget _tile(String title, String? sub, VoidCallback onDelete) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: sub == null || sub.trim().isEmpty ? null : Text(sub),
        trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: onDelete),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ModuleTheme.textGray)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
