import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/funding_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../funding/entrepreneur_funding_screen.dart';
import '../funding/funding_chat_threads_screen.dart';
import '../funding/funding_meetings_screen.dart';
import '../funding/funding_menu_sheet.dart';
import '../funding/funding_notifications_screen.dart';
import '../funding/funding_pitch_deck_screen.dart';
import '../landing/landing_screen.dart';
import 'entrepreneur_profile_completion_screen.dart';

class EntrepreneurDashboardScreen extends StatefulWidget {
  const EntrepreneurDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softBg = Color(0xFFF7F8FA);

  @override
  State<EntrepreneurDashboardScreen> createState() => _EntrepreneurDashboardScreenState();
}

class _EntrepreneurDashboardScreenState extends State<EntrepreneurDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _entrepreneur = {};
  List<Map<String, dynamic>> _proposals = [];
  List<Map<String, dynamic>> _interests = [];
  Map<String, dynamic> _funding = {};
  bool _canCreate = false;
  bool _creating = false;
  bool _cancelling = false;

  EntrepreneurAuthService get _svc => EntrepreneurAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ── Status helpers ────────────────────────────────────────────────────────

  String get _partnerStatus =>
      (_entrepreneur['partnerProfileStatus']?.toString() ?? '').toUpperCase();

  String get _verificationStatus =>
      (_entrepreneur['verificationStatus']?.toString() ?? '').toUpperCase();

  bool get _verified => _partnerStatus == 'APPROVED';

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
    if (_partnerStatus == 'CHANGES_REQUESTED') return 'Changes Requested';
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
      case 'Changes Requested':
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
      case 'Changes Requested':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF475569);
    }
  }

  String get _name => _entrepreneur['fullName']?.toString() ?? 'Entrepreneur';
  String get _firstName => _name.trim().split(RegExp(r'\s+')).first;
  String get _business => _entrepreneur['businessName']?.toString() ?? 'Business';
  String get _category => _entrepreneur['businessCategory']?.toString() ?? 'Startup';
  String get _location => _entrepreneur['businessLocation']?.toString() ?? 'Location not set';
  int get _experience => (_entrepreneur['businessExperience'] is num)
      ? (_entrepreneur['businessExperience'] as num).toInt()
      : 0;

  int get _profileCompletionPct {
    final raw = _entrepreneur['profileCompletionPct'];
    if (raw is num) return raw.toInt().clamp(0, 100);
    return (int.tryParse('$raw') ?? 0).clamp(0, 100);
  }

  double get _requested {
    final fromFunding =
        (_funding['totalRequested'] is num) ? (_funding['totalRequested'] as num).toDouble() : 0.0;
    if (fromFunding > 0) return fromFunding;
    final needed = (_entrepreneur['investmentNeeded'] is num)
        ? (_entrepreneur['investmentNeeded'] as num).toDouble()
        : 0.0;
    return needed;
  }

  double get _raised =>
      (_funding['totalRaised'] is num) ? (_funding['totalRaised'] as num).toDouble() : 0;
  double get _remaining => (_requested - _raised).clamp(0, double.infinity);
  double get _progress => _requested <= 0 ? 0 : (_raised / _requested).clamp(0.0, 1.0);

  int get _investorsInterested {
    final fromFunding = _funding['pendingInterestCount'];
    if (fromFunding is num) return fromFunding.toInt();
    return _interests
        .where((i) => (i['status']?.toString() ?? '').toUpperCase() == 'PENDING')
        .length;
  }

  int get _activeProposals => _proposals
      .where((p) => (p['status']?.toString() ?? '').toUpperCase() != 'CANCELLED')
      .length;

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
        _entrepreneur = Map<String, dynamic>.from(res['entrepreneur'] ?? {});
        if (res['payoutBalance'] != null) _entrepreneur['payoutBalance'] = res['payoutBalance'];
        _proposals = ModuleTheme.toList(res['proposals']);
        _interests = ModuleTheme.toList(res['interests']);
        _funding = Map<String, dynamic>.from(res['funding'] ?? {});
        final canCreateRaw = res['canCreateProposal'];
        _canCreate = canCreateRaw == true ||
            _partnerStatus == 'APPROVED' ||
            _entrepreneur['canCreateProposal'] == true;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openProfileCompletion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EntrepreneurProfileCompletionScreen(
          onFinished: (ctx) => Navigator.of(ctx).pop(true),
        ),
      ),
    );
    if (mounted) _load();
  }

  Future<void> _logout() async {
    try {
      await _svc.logout();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  String _money(num v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(1)} Cr';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)} L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : null,
      ),
    );
  }

  void _requireVerifiedOrToast({bool openProfile = true}) {
    _toast(
      'Your entrepreneur account must be verified before creating proposals. '
      'Complete your profile and wait for admin approval.',
      error: true,
    );
    if (openProfile && _needsProfile) {
      _openProfileCompletion();
    }
  }

  Future<void> _onCreateProposalPressed() async {
    if (!_verified && !_canCreate) {
      _requireVerifiedOrToast();
      return;
    }
    await _createProposal();
  }

  int? _proposalId(Map<String, dynamic> p) {
    final id = p['id'];
    if (id is int) return id;
    return int.tryParse('$id');
  }

  // ── Create / edit proposal ────────────────────────────────────────────────

  Future<void> _createProposal({Map<String, dynamic>? existing}) async {
    if (_creating) return;
    setState(() => _creating = true);

    final isEdit = existing != null;
    final title = TextEditingController(text: existing?['title']?.toString() ?? '');
    final desc = TextEditingController(text: existing?['description']?.toString() ?? '');
    final funding = TextEditingController(
      text: existing?['fundingNeeded']?.toString() ?? '100000',
    );
    final income = TextEditingController(
      text: existing?['expectedMonthlyIncome']?.toString() ?? '0',
    );

    final existingCat = FundingCatalog.normalize(existing?['category']?.toString()) ??
        FundingCatalog.normalize(_entrepreneur['businessCategory']?.toString());
    String category = (existingCat != null && FundingCatalog.categories.contains(existingCat))
        ? existingCat
        : FundingCatalog.categories.first;

    String? formError;
    bool submitting = false;

    try {
      final ok = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setLocal) {
            Future<void> submit() async {
              if (submitting) return;
              final t = title.text.trim();
              final fundingVal = double.tryParse(funding.text.trim());
              final incomeVal = double.tryParse(income.text.trim().isEmpty ? '0' : income.text.trim());

              if (t.isEmpty) {
                setLocal(() => formError = 'Title is required');
                return;
              }
              if (fundingVal == null || fundingVal <= 0) {
                setLocal(() => formError = 'Funding needed must be greater than 0');
                return;
              }
              if (incomeVal == null || incomeVal < 0) {
                setLocal(() => formError = 'Expected monthly income must be 0 or greater');
                return;
              }

              setLocal(() {
                submitting = true;
                formError = null;
              });

              final body = {
                'title': t,
                'category': category,
                'description': desc.text.trim(),
                'location': existing?['location'] ?? _entrepreneur['businessLocation'],
                'fundingNeeded': fundingVal,
                'expectedMonthlyIncome': incomeVal,
              };

              Map<String, dynamic> res;
              try {
                if (isEdit) {
                  final id = _proposalId(existing);
                  if (id == null) {
                    setLocal(() {
                      submitting = false;
                      formError = 'Invalid proposal';
                    });
                    return;
                  }
                  res = await _svc.updateProposal(id, body);
                } else {
                  res = await _svc.createProposal(body);
                }
              } catch (e) {
                if (!ctx.mounted) return;
                setLocal(() {
                  submitting = false;
                  formError = '$e';
                });
                return;
              }

              if (!ctx.mounted) return;
              if (res['success'] == true) {
                Navigator.pop(ctx, true);
                return;
              }

              final err = res['error']?.toString() ?? 'Request failed';
              final friendly = err.toLowerCase().contains('verified')
                  ? 'Your account must be verified before creating or editing proposals.'
                  : err;
              setLocal(() {
                submitting = false;
                formError = friendly;
              });
            }

            return AlertDialog(
              title: Text(isEdit ? 'Edit Funding Proposal' : 'New Funding Proposal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: title,
                      enabled: !submitting,
                      decoration: const InputDecoration(
                        labelText: 'Proposal title *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: FundingCatalog.categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: submitting
                          ? null
                          : (v) => setLocal(() => category = v ?? category),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: desc,
                      enabled: !submitting,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: funding,
                      enabled: !submitting,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Funding needed (Rs) *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: income,
                      enabled: !submitting,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Expected monthly income (Rs)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (formError != null) ...[
                      const SizedBox(height: 10),
                      Text(formError!, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting ? null : () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: EntrepreneurDashboardScreen.primary),
                  onPressed: submitting ? null : submit,
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Save' : 'Submit'),
                ),
              ],
            );
          },
        ),
      );

      if (ok == true && mounted) {
        _toast(isEdit ? 'Proposal updated' : 'Proposal submitted for admin approval');
        await _load();
      }
    } finally {
      title.dispose();
      desc.dispose();
      funding.dispose();
      income.dispose();
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _cancelProposal(Map<String, dynamic> p) async {
    if (_cancelling) return;
    final id = _proposalId(p);
    if (id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel proposal?'),
        content: Text(
          'Cancel "${p['title'] ?? 'this proposal'}"? Investors will no longer see it.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel proposal'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _cancelling = true);
    try {
      final res = await _svc.cancelProposal(id);
      if (!mounted) return;
      if (res['success'] == true) {
        _toast('Proposal cancelled');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Cancel failed', error: true);
      }
    } catch (e) {
      if (mounted) _toast('$e', error: true);
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  void _showProposalDetails(Map<String, dynamic> p) {
    final status = (p['status']?.toString() ?? 'PENDING').toUpperCase();
    final raised = (p['amountRaised'] is num) ? (p['amountRaised'] as num).toDouble() : 0.0;
    final needed = (p['fundingNeeded'] is num) ? (p['fundingNeeded'] as num).toDouble() : 0.0;
    final pendingInterest = (p['pendingInterestCount'] is num)
        ? (p['pendingInterestCount'] as num).toInt()
        : 0;
    final canEdit = p['canEdit'] == true && status != 'CANCELLED';
    final canCancel = p['canCancel'] == true && status != 'CANCELLED';
    final desc = p['description']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + MediaQuery.of(ctx).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      p['title']?.toString() ?? 'Proposal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: EntrepreneurDashboardScreen.navy,
                      ),
                    ),
                  ),
                  _statusPill(status),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${p['category'] ?? ''} · ${p['location'] ?? ''}',
                style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted),
              ),
              const SizedBox(height: 14),
              _kv('Funding needed', _money(needed)),
              const SizedBox(height: 8),
              _kv('Raised', _money(raised)),
              const SizedBox(height: 8),
              _kv('Pending interest', '$pendingInterest'),
              if (desc.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w700, color: EntrepreneurDashboardScreen.navy),
                ),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: EntrepreneurDashboardScreen.muted, height: 1.35)),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  if (canEdit)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _createProposal(existing: p);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit'),
                      ),
                    ),
                  if (canEdit && canCancel) const SizedBox(width: 10),
                  if (canCancel)
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
                        onPressed: _cancelling
                            ? null
                            : () {
                                Navigator.pop(ctx);
                                _cancelProposal(p);
                              },
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Cancel'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EntrepreneurDashboardScreen.softBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: EntrepreneurDashboardScreen.primary,
        elevation: 6,
        onPressed: _onCreateProposalPressed,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 14,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _nav(0, Icons.home_outlined, Icons.home, 'Home'),
              _nav(1, Icons.description_outlined, Icons.description, 'Proposals'),
              const SizedBox(width: 56),
              _nav(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Funding'),
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
                    children: [_homeTab(), _proposalsTab(), _fundingTab(), _profileTab()],
                  ),
                ),
    );
  }

  Widget _nav(int i, IconData outline, IconData filled, String label) {
    final active = _tab == i;
    final c = active ? EntrepreneurDashboardScreen.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? filled : outline, color: c, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }

  Widget _homeTab() {
    return RefreshIndicator(
      color: EntrepreneurDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          _topBar(),
          const SizedBox(height: 14),
          if (!_verified) ...[
            _statusBanner(),
            const SizedBox(height: 14),
          ],
          _profileHero(),
          const SizedBox(height: 14),
          _metricsGrid(),
          const SizedBox(height: 14),
          _fundingProgressCard(),
          const SizedBox(height: 16),
          _section('Quick Actions'),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 16),
          _section('Investor Activity'),
          const SizedBox(height: 10),
          _activityCard(),
          const SizedBox(height: 16),
          _section('Startup Metrics'),
          const SizedBox(height: 10),
          _startupMetrics(),
          const SizedBox(height: 16),
          _section('Upcoming Meetings'),
          const SizedBox(height: 10),
          _meetingsCard(),
          const SizedBox(height: 16),
          _section('Your Proposals', action: 'View all', onAction: () => setState(() => _tab = 1)),
          const SizedBox(height: 10),
          if (_proposals.isEmpty)
            _empty('No proposals yet. Tap + to create your first funding proposal.')
          else
            ..._proposals.take(3).map(_proposalCard),
        ],
      ),
    );
  }

  Widget _statusBanner() {
    String message;
    String cta = 'Complete profile';
    VoidCallback? onTap = _openProfileCompletion;

    if (_partnerStatus == 'REJECTED' || _verificationStatus == 'REJECTED') {
      final reason = _entrepreneur['rejectionReason']?.toString();
      message = reason != null && reason.isNotEmpty
          ? 'Your profile was rejected: $reason'
          : 'Your profile was rejected. Update details and resubmit.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'CHANGES_REQUESTED') {
      final note = _entrepreneur['changesRequestedNote']?.toString();
      message = note != null && note.isNotEmpty
          ? 'Changes requested: $note'
          : 'Admin requested profile changes before approval.';
      cta = 'Update profile';
    } else if (_partnerStatus == 'PENDING_ADMIN_APPROVAL') {
      message =
          'Profile submitted. Waiting for admin verification before you can create proposals.';
      cta = 'View profile';
      onTap = () => setState(() => _tab = 3);
    } else if (_partnerStatus == 'READY_FOR_VERIFICATION') {
      message =
          'Your profile looks ready. Submit for verification to unlock proposal creation.';
      cta = 'Finish profile';
    } else {
      message = 'Complete your entrepreneur profile and get verified to create funding proposals.';
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
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: EntrepreneurDashboardScreen.primary,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(cta),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => showFundingMenuSheet(
            context,
            isEntrepreneur: true,
            proposals: _proposals,
            onProfile: () => setState(() => _tab = 3),
          ),
          icon: const Icon(Icons.menu_rounded, color: EntrepreneurDashboardScreen.navy),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $_firstName!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: EntrepreneurDashboardScreen.navy,
                ),
              ),
              const Text(
                "Here's what's happening with your startup today.",
                style: TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _tab = 3),
          child: const Text(
            'View Profile',
            style: TextStyle(
              color: EntrepreneurDashboardScreen.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FundingNotificationsScreen(isEntrepreneur: true),
              ),
            );
          },
          icon: const Icon(Icons.notifications_none_rounded, color: EntrepreneurDashboardScreen.navy),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const FundingChatThreadsScreen(isEntrepreneur: true),
              ),
            );
          },
          icon: const Icon(Icons.chat_bubble_outline_rounded, color: EntrepreneurDashboardScreen.navy),
        ),
      ],
    );
  }

  Widget _profileHero() {
    final initial = _business.isNotEmpty ? _business[0].toUpperCase() : 'E';
    final pct = _profileCompletionPct;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E1C59), Color(0xFFD93662)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: EntrepreneurDashboardScreen.primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              initial,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    _category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _business,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(_name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: Colors.white70),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        _location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _statusBadgeBg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: _statusBadgeFg),
                      const SizedBox(width: 6),
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
              ],
            ),
          ),
          const SizedBox(width: 8),
          _completionRing(pct),
        ],
      ),
    );
  }

  Widget _completionRing(int pct) {
    return Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: pct / 100,
                strokeWidth: 6,
                backgroundColor: Colors.white24,
                color: Colors.white,
              ),
              Text('$pct%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Profile',
          style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w600),
        ),
        Text(
          pct >= 100 ? 'Complete' : 'In progress',
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _metricsGrid() {
    final items = [
      _Metric('Funding Goal', _money(_requested), Icons.flag_outlined, const Color(0xFFFCE7F3)),
      _Metric(
        'Raised',
        '${_money(_raised)}\n${(_progress * 100).toStringAsFixed(0)}% of Goal',
        Icons.trending_up,
        const Color(0xFFDCFCE7),
      ),
      _Metric(
        'Investors\nInterested',
        '$_investorsInterested',
        Icons.groups_outlined,
        const Color(0xFFE0E7FF),
      ),
      _Metric(
        'Active\nProposals',
        '$_activeProposals',
        Icons.description_outlined,
        const Color(0xFFFEF3C7),
      ),
      _Metric('Profile\nViews', '—', Icons.visibility_outlined, const Color(0xFFE0F2FE)),
    ];
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = items[i];
          return Container(
            width: 128,
            padding: const EdgeInsets.all(12),
            decoration: _cardDeco(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: m.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(m.icon, size: 18, color: EntrepreneurDashboardScreen.navy),
                ),
                const Spacer(),
                Text(
                  m.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: EntrepreneurDashboardScreen.muted,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  m.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: EntrepreneurDashboardScreen.navy,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _fundingProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Funding Progress',
                  style: TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy),
                ),
              ),
              Text(
                '${(_progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFFCE7F3),
              color: EntrepreneurDashboardScreen.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${_money(_raised)} raised',
                style: const TextStyle(
                  fontSize: 12,
                  color: EntrepreneurDashboardScreen.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${_money(_remaining)} remaining',
                style: const TextStyle(
                  fontSize: 12,
                  color: EntrepreneurDashboardScreen.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      (Icons.add_circle_outline, 'Create Proposal', EntrepreneurDashboardScreen.primary, _onCreateProposalPressed),
      (
        Icons.picture_as_pdf_outlined,
        'Pitch Deck',
        const Color(0xFF8B5CF6),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FundingPitchDeckScreen(proposals: _proposals),
            ),
          );
        },
      ),
      (
        Icons.event_available_outlined,
        'Meetings',
        const Color(0xFF16A34A),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const FundingMeetingsScreen(isEntrepreneur: true),
            ),
          );
        },
      ),
      (
        Icons.chat_bubble_outline,
        'Investor Chat',
        const Color(0xFF3B82F6),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const FundingChatThreadsScreen(isEntrepreneur: true),
            ),
          );
        },
      ),
      (Icons.insights_outlined, 'Analytics', const Color(0xFFF97316), () => setState(() => _tab = 2)),
      (
        Icons.account_balance_wallet_outlined,
        'Withdraw',
        const Color(0xFFEF4444),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EntrepreneurFundingScreen()),
          );
        },
      ),
    ];
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final a = actions[i];
          return InkWell(
            onTap: a.$4,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 86,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: _cardDeco(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: a.$3.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a.$1, color: a.$3, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: EntrepreneurDashboardScreen.navy,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _activityCard() {
    if (_interests.isEmpty) {
      return _empty('No investor interest yet. Create a proposal to start attracting investors.');
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco(),
      child: Column(
        children: _interests.take(8).map((e) {
          final name = e['investorName']?.toString() ?? 'Investor';
          final amount = (e['amount'] is num) ? (e['amount'] as num).toDouble() : 0.0;
          final status = (e['status']?.toString() ?? 'PENDING').toUpperCase();
          final proposalTitle = e['proposalTitle']?.toString() ?? 'Proposal';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFFFE4E6),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'I',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: EntrepreneurDashboardScreen.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: EntrepreneurDashboardScreen.navy,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${_money(amount)} · $proposalTitle',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted),
                      ),
                    ],
                  ),
                ),
                _statusPill(status),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _startupMetrics() {
    final income = (_entrepreneur['expectedMonthlyIncome'] is num)
        ? (_entrepreneur['expectedMonthlyIncome'] as num).toDouble()
        : 0.0;
    final metrics = [
      ('Monthly Revenue', income > 0 ? _money(income) : '—', Icons.payments_outlined, const Color(0xFFDCFCE7)),
      ('Customers', '—', Icons.people_outline, const Color(0xFFE0E7FF)),
      ('Employees', _parseEmployees(), Icons.badge_outlined, const Color(0xFFFEF3C7)),
      ('Experience', '$_experience yrs', Icons.work_history_outlined, const Color(0xFFFCE7F3)),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) {
        final m = metrics[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: _cardDeco(),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: m.$4, borderRadius: BorderRadius.circular(10)),
                child: Icon(m.$3, size: 18, color: EntrepreneurDashboardScreen.navy),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m.$1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: EntrepreneurDashboardScreen.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      m.$2,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: EntrepreneurDashboardScreen.navy,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _parseEmployees() {
    final desc = _entrepreneur['businessDescription']?.toString() ?? '';
    final m = RegExp(r'Employees:\s*(\d+)').firstMatch(desc);
    return m?.group(1) ?? '—';
  }

  Widget _meetingsCard() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const FundingMeetingsScreen(isEntrepreneur: true),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDeco(),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.videocam_outlined, color: Color(0xFF0369A1)),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investor meetings',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: EntrepreneurDashboardScreen.navy,
                    ),
                  ),
                  Text(
                    'Accept or reject meeting requests from investors.',
                    style: TextStyle(
                      fontSize: 12,
                      color: EntrepreneurDashboardScreen.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: EntrepreneurDashboardScreen.muted),
          ],
        ),
      ),
    );
  }

  Widget _proposalsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Proposals',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: EntrepreneurDashboardScreen.navy,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _onCreateProposalPressed,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
                style: FilledButton.styleFrom(backgroundColor: EntrepreneurDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_proposals.isEmpty) _empty('No proposals yet.') else ..._proposals.map(_proposalCard),
        ],
      ),
    );
  }

  Widget _fundingTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text(
          'Funding Overview',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy),
        ),
        const SizedBox(height: 14),
        _fundingProgressCard(),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDeco(),
          child: Column(
            children: [
              _kv('Total requested', _money(_requested)),
              const Divider(height: 22),
              _kv('Total raised', _money(_raised)),
              const Divider(height: 22),
              _kv('Remaining', _money(_remaining)),
              const Divider(height: 22),
              _kv('Pending interest', '$_investorsInterested'),
              const Divider(height: 22),
              _kv('Payout balance', _money(_entrepreneur['payoutBalance'] is num ? _entrepreneur['payoutBalance'] as num : 0)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () async {
            final res = await _svc.requestPayout();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res['success'] == true
                  ? (res['message']?.toString() ?? 'Payout requested')
                  : res['error']?.toString() ?? 'Payout failed'),
            ));
            if (res['success'] == true) _load();
          },
          style: FilledButton.styleFrom(
            backgroundColor: EntrepreneurDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(FundingCatalog.cancelPolicy, style: const TextStyle(color: EntrepreneurDashboardScreen.muted, fontSize: 12)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2E1C59), Color(0xFFD93662)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need more capital?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create another proposal for admin review and investor interest.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _onCreateProposalPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: EntrepreneurDashboardScreen.primary,
                ),
                child: const Text('Create Proposal'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileTab() {
    final statusLabel =
        _entrepreneur['partnerProfileStatusLabel']?.toString() ?? _statusBadgeLabel;
    final rejection = _entrepreneur['rejectionReason']?.toString();
    final changesNote = _entrepreneur['changesRequestedNote']?.toString();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        _profileHero(),
        const SizedBox(height: 14),
        if (!_verified) ...[
          _statusBanner(),
          const SizedBox(height: 14),
        ],
        _infoTile(Icons.person_outline, 'Founder', _name),
        _infoTile(Icons.business_outlined, 'Business', _business),
        _infoTile(Icons.category_outlined, 'Category', _category),
        _infoTile(Icons.place_outlined, 'Location', _location),
        _infoTile(Icons.work_history_outlined, 'Experience', '$_experience years'),
        _infoTile(
          Icons.currency_rupee,
          'Investment needed',
          _money(_entrepreneur['investmentNeeded'] is num ? _entrepreneur['investmentNeeded'] as num : 0),
        ),
        _infoTile(Icons.verified_outlined, 'Partner status', statusLabel),
        if (rejection != null && rejection.isNotEmpty)
          _infoTile(Icons.report_gmailerrorred_outlined, 'Rejection reason', rejection),
        if (changesNote != null && changesNote.isNotEmpty)
          _infoTile(Icons.edit_note_outlined, 'Changes requested', changesNote),
        _infoTile(Icons.percent, 'Profile completion', '$_profileCompletionPct%'),
        const SizedBox(height: 8),
        if (_needsProfile)
          FilledButton.icon(
            onPressed: _openProfileCompletion,
            icon: const Icon(Icons.badge_outlined),
            label: const Text('Complete / update profile'),
            style: FilledButton.styleFrom(
              backgroundColor: EntrepreneurDashboardScreen.primary,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: EntrepreneurDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: EntrepreneurDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _proposalCard(Map<String, dynamic> p) {
    final status = (p['status']?.toString() ?? 'PENDING').toUpperCase();
    final raised = (p['amountRaised'] is num) ? (p['amountRaised'] as num).toDouble() : 0.0;
    final needed = (p['fundingNeeded'] is num) ? (p['fundingNeeded'] as num).toDouble() : 0.0;
    final prog = needed <= 0 ? 0.0 : (raised / needed).clamp(0.0, 1.0);
    return InkWell(
      onTap: () => _showProposalDetails(p),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: _cardDeco(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    p['title']?.toString() ?? 'Proposal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: EntrepreneurDashboardScreen.navy,
                    ),
                  ),
                ),
                _statusPill(status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${p['category'] ?? ''} · ${p['location'] ?? ''}',
              style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: prog,
                minHeight: 6,
                backgroundColor: const Color(0xFFFCE7F3),
                color: EntrepreneurDashboardScreen.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_money(raised)} raised of ${_money(needed)}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0369A1);
    final s = status.toUpperCase();
    if (s == 'VERIFIED' || s == 'APPROVED' || s == 'ACCEPTED') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (s == 'REJECTED' || s == 'CANCELLED') {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFBE123C);
    } else if (s == 'PENDING') {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFB45309);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(s, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: EntrepreneurDashboardScreen.primary),
        title: Text(label, style: const TextStyle(fontSize: 12, color: EntrepreneurDashboardScreen.muted)),
        subtitle: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700, color: EntrepreneurDashboardScreen.navy),
        ),
      ),
    );
  }

  Widget _section(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: EntrepreneurDashboardScreen.navy,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              action,
              style: const TextStyle(
                color: EntrepreneurDashboardScreen.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(child: Text(k, style: const TextStyle(color: EntrepreneurDashboardScreen.muted))),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800, color: EntrepreneurDashboardScreen.navy)),
      ],
    );
  }

  Widget _empty(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: const TextStyle(color: EntrepreneurDashboardScreen.muted)),
    );
  }

  BoxDecoration _cardDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.bg);
  final String label;
  final String value;
  final IconData icon;
  final Color bg;
}
