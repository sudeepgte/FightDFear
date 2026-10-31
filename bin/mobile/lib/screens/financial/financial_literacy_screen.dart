import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/financial_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';
import 'financial_session_detail_screen.dart';

class FinancialLiteracyScreen extends StatefulWidget {
  const FinancialLiteracyScreen({super.key});

  @override
  State<FinancialLiteracyScreen> createState() => _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState extends State<FinancialLiteracyScreen> {
  late final FinancialLiteracyService _api;
  bool _loading = true;
  bool _acting = false;
  String? _error;
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _liveSessions = [];
  List<Map<String, dynamic>> _workshops = [];
  List<Map<String, dynamic>> _enrollments = [];
  List<Map<String, dynamic>> _loans = [];
  String _section = 'videos';
  String _category = '';
  String _sort = 'newest';
  final _cityFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    _api = FinancialLiteracyService(context.read<AuthState>().api);
    _load();
  }

  @override
  void dispose() {
    _cityFilter.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.home(
        category: _category.isEmpty ? null : _category,
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        sort: _sort,
      );
      final mine = await _api.myEnrollments();
      final loans = await _api.loans();
      if (!mounted) return;
      if (res['success'] == true) {
        _videos = ModuleTheme.toList(res['videos']);
        _liveSessions = ModuleTheme.toList(res['liveSessions']);
        _workshops = ModuleTheme.toList(res['workshops']);
      } else {
        _error = res['error']?.toString();
      }
      if (mine['success'] == true) _enrollments = ModuleTheme.toList(mine['enrollments']);
      if (loans['success'] == true) _loans = ModuleTheme.toList(loans['loans']);
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  int? _nid(Map<String, dynamic> item) {
    final v = item['numericId'] ?? item['id'];
    if (v is num) return v.toInt();
    return int.tryParse('$v');
  }

  void _open(String kind, Map<String, dynamic> item) {
    final id = _nid(item);
    if (id == null) return;
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (_) => FinancialSessionDetailScreen(kind: kind, id: id, summary: item),
        ))
        .then((_) => _load());
  }

  Future<void> _applyLoan() async {
    final amount = TextEditingController();
    final purpose = TextEditingController();
    String type = FinancialCatalog.loanTypes.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apply for a loan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                items: FinancialCatalog.loanTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => type = v ?? type,
                decoration: const InputDecoration(labelText: 'Loan type *'),
              ),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount (Rs) *'),
              ),
              TextField(
                controller: purpose,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Purpose'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
        ],
      ),
    );
    if (ok != true) return;
    if (!mounted) return;
    final amt = double.tryParse(amount.text.trim());
    if (amt == null || amt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }
    if (_acting) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _acting = true);
    final res = await _api.applyLoan({'loanType': type, 'loanAmount': amt, 'purpose': purpose.text.trim()});
    if (!mounted) return;
    setState(() => _acting = false);
    messenger.showSnackBar(SnackBar(
      content: Text(res['success'] == true
          ? (res['message']?.toString() ?? 'Submitted')
          : res['error']?.toString() ?? 'Failed'),
    ));
    _load();
  }

  List<Map<String, dynamic>> get _activeItems => switch (_section) {
        'live' => _liveSessions,
        'workshops' => _workshops,
        'mine' => _enrollments,
        'loans' => _loans,
        _ => _videos,
      };

  Widget _itemCard(Map<String, dynamic> item) {
    if (_section == 'mine') {
      return Card(
        child: ListTile(
          title: Text(item['title']?.toString() ?? item['kind']?.toString() ?? 'Registration'),
          subtitle: Text('${item['status']} · ${item['kind'] ?? ''}${item['needsPayment'] == true ? ' · Pay due' : ''}'),
          trailing: item['canCancel'] == true
              ? TextButton(
                  onPressed: _acting
                      ? null
                      : () async {
                          final id = _nid(item);
                          if (id == null) return;
                          setState(() => _acting = true);
                          await _api.cancelEnrollment(id);
                          if (mounted) setState(() => _acting = false);
                          _load();
                        },
                  child: const Text('Cancel'),
                )
              : (item['needsPayment'] == true || item['canReview'] == true
                  ? TextButton(
                      onPressed: () {
                        final kind = item['kind']?.toString() == 'WORKSHOP' ? 'workshop' : 'live';
                        final sid = item['sessionId'] ?? item['workshopId'];
                        final mapped = Map<String, dynamic>.from(item);
                        mapped['id'] = sid ?? item['id'];
                        mapped['numericId'] = int.tryParse('${sid ?? item['numericId'] ?? ''}');
                        _open(kind, mapped);
                      },
                      child: Text(item['needsPayment'] == true ? 'Pay' : 'Review'),
                    )
                  : null),
        ),
      );
    }
    if (_section == 'loans') {
      return Card(
        child: ListTile(
          title: Text('${item['loanType'] ?? 'Loan'} · ₹${item['loanAmount'] ?? 0}'),
          subtitle: Text(item['status']?.toString() ?? ''),
        ),
      );
    }
    final kind = _section == 'live' ? 'live' : _section == 'workshops' ? 'workshop' : 'video';
    final title = item['title']?.toString() ?? item['name']?.toString() ?? 'Item';
    final host = item['host']?.toString() ?? item['speaker']?.toString();
    final desc = item['description']?.toString();
    return DetailListingCard(
      title: title,
      eyebrow: kind == 'live' ? 'Live Session' : kind == 'workshop' ? 'Workshop' : 'Video',
      location: host ?? item['date']?.toString() ?? item['city']?.toString(),
      showMediaActions: false,
      tags: [
        if (item['duration'] != null) DetailTag(label: '${item['duration']}', icon: Icons.timer_outlined),
        if (item['level'] != null) DetailTag(label: '${item['level']}', icon: Icons.school_outlined),
        if (item['seatsLeft'] != null) DetailTag(label: '${item['seatsLeft']} seats', icon: Icons.event_seat_outlined),
        if (item['fee'] is num && (item['fee'] as num) > 0)
          DetailTag(label: '₹${(item['fee'] as num).round()}', icon: Icons.currency_rupee),
        if (desc != null && desc.isNotEmpty)
          DetailTag(label: desc.length > 28 ? '${desc.substring(0, 28)}…' : desc, icon: Icons.info_outline),
      ],
      primaryLabel: 'View details',
      onPrimary: () => _open(kind, item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Financial Literacy Hub'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      floatingActionButton: _section == 'loans'
          ? FloatingActionButton.extended(
              onPressed: _acting ? null : _applyLoan,
              label: const Text('Apply'),
              icon: const Icon(Icons.add),
            )
          : null,
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      const SizedBox(height: 10),
                      CategoryPillBar(
                        options: const [
                          (value: 'videos', label: 'Videos', icon: Icons.play_circle_outline),
                          (value: 'live', label: 'Live', icon: Icons.live_tv_outlined),
                          (value: 'workshops', label: 'Workshops', icon: Icons.groups_outlined),
                          (value: 'mine', label: 'My bookings', icon: Icons.confirmation_number_outlined),
                          (value: 'loans', label: 'Loans', icon: Icons.account_balance_outlined),
                        ],
                        selected: _section,
                        onSelected: (v) => setState(() => _section = v),
                      ),
                      if (_section == 'videos' || _section == 'live' || _section == 'workshops') ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: TextField(
                            controller: _cityFilter,
                            decoration: InputDecoration(
                              hintText: 'City',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _load),
                              isDense: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onSubmitted: (_) => _load(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                          child: Wrap(
                            spacing: 6,
                            children: [
                              ...FinancialCatalog.expertise.map((c) => ChoiceChip(
                                    label: Text(c),
                                    selected: _category == c,
                                    onSelected: (_) {
                                      setState(() => _category = _category == c ? '' : c);
                                      _load();
                                    },
                                  )),
                              ChoiceChip(
                                label: const Text('Top rated'),
                                selected: _sort == 'rating',
                                onSelected: (_) {
                                  setState(() => _sort = 'rating');
                                  _load();
                                },
                              ),
                              ChoiceChip(
                                label: const Text('Fee'),
                                selected: _sort == 'fee',
                                onSelected: (_) {
                                  setState(() => _sort = 'fee');
                                  _load();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Text(
                          'Showing ${_activeItems.length} $_section',
                          style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                        ),
                      ),
                      if (_activeItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Nothing here yet. Educators and admin publish videos, live sessions and workshops after approval.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ModuleTheme.textGray),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(children: _activeItems.map(_itemCard).toList()),
                        ),
                    ],
                  ),
                ),
    );
  }
}
