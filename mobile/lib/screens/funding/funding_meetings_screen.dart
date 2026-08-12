import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

/// Role-aware investment meetings list (accept/reject or request).
class FundingMeetingsScreen extends StatefulWidget {
  const FundingMeetingsScreen({
    super.key,
    required this.isEntrepreneur,
    this.proposalId,
  });

  final bool isEntrepreneur;

  /// Investor: optional proposal to prefill when requesting a meeting.
  final int? proposalId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FundingMeetingsScreen> createState() => _FundingMeetingsScreenState();
}

class _FundingMeetingsScreenState extends State<FundingMeetingsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _meetings = [];
  final Set<int> _busyIds = {};

  EntrepreneurAuthService get _entSvc =>
      EntrepreneurAuthService(context.read<AuthState>().api);
  InvestorAuthService get _invSvc =>
      InvestorAuthService(context.read<AuthState>().api);

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
      final res =
          widget.isEntrepreneur ? await _entSvc.meetings() : await _invSvc.meetings();
      if (!mounted) return;
      if (res['success'] == true) {
        _meetings = ModuleTheme.toList(res['meetings']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load meetings';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : null,
      ),
    );
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v');
  }

  Future<void> _accept(int id) async {
    if (_busyIds.contains(id)) return;
    setState(() => _busyIds.add(id));
    try {
      final res = await _entSvc.acceptMeeting(id);
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Meeting accepted');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Accept failed', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _busyIds.remove(id));
  }

  Future<void> _reject(int id) async {
    if (_busyIds.contains(id)) return;
    setState(() => _busyIds.add(id));
    try {
      final res = await _entSvc.rejectMeeting(id);
      if (!mounted) return;
      if (res['success'] == true) {
        _toast(res['message']?.toString() ?? 'Meeting rejected');
        await _load();
      } else {
        _toast(res['error']?.toString() ?? 'Reject failed', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _busyIds.remove(id));
  }

  Future<void> _requestMeeting() async {
    final proposalCtrl = TextEditingController(
      text: widget.proposalId?.toString() ?? '',
    );
    final locationCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        var submitting = false;
        String? localError;
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: const Text('Request meeting'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: proposalCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Proposal ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      pickedDate == null
                          ? 'Pick date'
                          : '${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null) setLocal(() => pickedDate = d);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      pickedTime == null
                          ? 'Pick time'
                          : pickedTime!.format(ctx),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: ctx,
                        initialTime: const TimeOfDay(hour: 11, minute: 0),
                      );
                      if (t != null) setLocal(() => pickedTime = t);
                    },
                  ),
                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 8),
                    Text(localError!, style: TextStyle(color: Colors.red.shade700)),
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
                onPressed: submitting
                    ? null
                    : () async {
                        final pid = int.tryParse(proposalCtrl.text.trim());
                        if (pid == null) {
                          setLocal(() => localError = 'Enter a valid proposal ID');
                          return;
                        }
                        if (pickedDate == null || pickedTime == null) {
                          setLocal(() => localError = 'Pick date and time');
                          return;
                        }
                        final dt = DateTime(
                          pickedDate!.year,
                          pickedDate!.month,
                          pickedDate!.day,
                          pickedTime!.hour,
                          pickedTime!.minute,
                        );
                        final iso =
                            '${dt.year.toString().padLeft(4, '0')}-'
                            '${dt.month.toString().padLeft(2, '0')}-'
                            '${dt.day.toString().padLeft(2, '0')}T'
                            '${dt.hour.toString().padLeft(2, '0')}:'
                            '${dt.minute.toString().padLeft(2, '0')}';
                        final messenger = ScaffoldMessenger.of(context);
                        setLocal(() {
                          submitting = true;
                          localError = null;
                        });
                        try {
                          final res = await _invSvc.requestMeeting(
                            proposalId: pid,
                            meetingTime: iso,
                            location: locationCtrl.text.trim(),
                            notes: notesCtrl.text.trim(),
                          );
                          if (!ctx.mounted) return;
                          if (res['success'] == true) {
                            Navigator.pop(ctx, true);
                          } else {
                            final err = res['error']?.toString() ??
                                'Could not request meeting';
                            final lower = err.toLowerCase();
                            if (lower.contains('subscri') ||
                                lower.contains('verif') ||
                                lower.contains('premium')) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(err),
                                  backgroundColor: Colors.red.shade700,
                                ),
                              );
                            }
                            setLocal(() {
                              submitting = false;
                              localError = err;
                            });
                          }
                        } catch (e) {
                          setLocal(() {
                            submitting = false;
                            localError = '$e';
                          });
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: FundingMeetingsScreen.primary,
                ),
                child: submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Request'),
              ),
            ],
          ),
        );
      },
    );

    proposalCtrl.dispose();
    locationCtrl.dispose();
    notesCtrl.dispose();

    if (ok == true) {
      _toast('Meeting requested');
      await _load();
    } else if (ok == false) {
      // cancelled
    }
  }

  Color _statusBg(String status) {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return const Color(0xFFDCFCE7);
      case 'REJECTED':
        return const Color(0xFFFFE4E6);
      default:
        return const Color(0xFFFEF3C7);
    }
  }

  Color _statusFg(String status) {
    switch (status.toUpperCase()) {
      case 'ACCEPTED':
        return const Color(0xFF166534);
      case 'REJECTED':
        return const Color(0xFFBE123C);
      default:
        return const Color(0xFFB45309);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: Colors.white,
        foregroundColor: FundingMeetingsScreen.navy,
        elevation: 0.5,
        actions: [
          if (!widget.isEntrepreneur)
            IconButton(
              tooltip: 'Request meeting',
              onPressed: _requestMeeting,
              icon: const Icon(Icons.add_circle_outline),
            ),
        ],
      ),
      floatingActionButton: widget.isEntrepreneur
          ? null
          : FloatingActionButton.extended(
              onPressed: _requestMeeting,
              backgroundColor: FundingMeetingsScreen.primary,
              icon: const Icon(Icons.event_available),
              label: const Text('Request'),
            ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _meetings.isEmpty
                      ? ListView(
                          children: const [
                            EmptyStateView(
                              icon: Icons.event_busy_outlined,
                              title: 'No meetings yet',
                              message:
                                  'Meeting requests with investors will show up here.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _meetings.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final m = _meetings[i];
                            final id = _asInt(m['id']);
                            final status =
                                (m['status']?.toString() ?? 'PENDING').toUpperCase();
                            final pending = status == 'PENDING';
                            final busy = id != null && _busyIds.contains(id);
                            final title = m['proposalTitle']?.toString() ??
                                'Proposal #${m['proposalId'] ?? ''}';
                            final peer = widget.isEntrepreneur
                                ? (m['investorName']?.toString() ?? 'Investor')
                                : (m['entrepreneurName']?.toString() ??
                                    'Entrepreneur');

                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: FundingMeetingsScreen.navy,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusBg(status),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: _statusFg(status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    peer,
                                    style: const TextStyle(
                                      color: FundingMeetingsScreen.muted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'When: ${m['meetingTime'] ?? '—'}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  if ((m['location']?.toString() ?? '').isNotEmpty)
                                    Text(
                                      'Where: ${m['location']}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  if ((m['notes']?.toString() ?? '').isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        m['notes'].toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: FundingMeetingsScreen.muted,
                                        ),
                                      ),
                                    ),
                                  if (widget.isEntrepreneur &&
                                      pending &&
                                      id != null) ...[
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                busy ? null : () => _reject(id),
                                            child: busy
                                                ? const SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : const Text('Reject'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: FilledButton(
                                            onPressed:
                                                busy ? null : () => _accept(id),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  FundingMeetingsScreen.primary,
                                            ),
                                            child: const Text('Accept'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
