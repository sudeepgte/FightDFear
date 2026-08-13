import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';

class JobBookingsScreen extends StatefulWidget {
  const JobBookingsScreen({super.key, this.workerView = true});

  /// When true, shows worker incoming bookings; otherwise client bookings.
  final bool workerView;

  @override
  State<JobBookingsScreen> createState() => _JobBookingsScreenState();
}

class _JobBookingsScreenState extends State<JobBookingsScreen> {
  late final JobBookingsService _api;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _api = JobBookingsService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = widget.workerView
          ? await _api.workerBookings()
          : await _api.clientBookings();
      if (!mounted) return;
      if (res['success'] == true) {
        _bookings = ModuleTheme.toList(res['bookings']);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _updateStatus(int id, String status) async {
    if (_busy) return;
    setState(() => _busy = true);
    final res = await _api.updateStatus(id, status);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Status updated to $status'
            : (res['error']?.toString() ?? 'Update failed')),
      ),
    );
    if (res['success'] == true) _load();
  }

  List<String> _actionsFor(String status) {
    if (!widget.workerView) return const [];
    return switch (status) {
      'PENDING' => const ['ACCEPTED', 'REJECTED'],
      'ACCEPTED' => const ['COMPLETED'],
      _ => const [],
    };
  }

  void _openDetail(Map<String, dynamic> b) {
    final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
    final status = (b['status']?.toString() ?? 'PENDING').toUpperCase();
    final actions = _actionsFor(status);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workerView
                    ? (b['clientName']?.toString() ?? 'Booking')
                    : (b['workerName']?.toString() ?? 'Booking'),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Status: $status'),
              Text('When: ${b['bookingDate'] ?? '—'}'),
              if (b['serviceType'] != null) Text('Service: ${b['serviceType']}'),
              if (b['totalAmount'] != null) Text('Amount: ₹${b['totalAmount']}'),
              if ((b['note']?.toString() ?? '').isNotEmpty) Text('Note: ${b['note']}'),
              const SizedBox(height: 12),
              if (actions.isEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                )
              else
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in actions)
                      FilledButton(
                        onPressed: id == null || _busy
                            ? null
                            : () {
                                Navigator.pop(ctx);
                                _updateStatus(id, s);
                              },
                        child: Text(s),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.workerView ? 'Job Bookings (Worker)' : 'My job bookings'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _bookings.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Text(
                                widget.workerView
                                    ? 'No incoming job bookings yet.'
                                    : 'No job bookings yet.',
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: _bookings.length + 1,
                          itemBuilder: (_, i) {
                            if (i == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Showing ${_bookings.length} job bookings',
                                  style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                                ),
                              );
                            }
                            final b = _bookings[i - 1];
                            final other = b['clientName'] ?? b['workerName'] ?? 'Booking';
                            return DetailListingCard(
                              title: other.toString(),
                              eyebrow: b['serviceType']?.toString() ?? 'Job booking',
                              location: b['location']?.toString() ?? b['bookingDate']?.toString(),
                              showMediaActions: true,
                              phone: b['phone']?.toString() ?? b['clientPhone']?.toString(),
                              tags: [
                                DetailTag(
                                  label: b['status']?.toString() ?? 'PENDING',
                                  icon: Icons.info_outline,
                                  background: const Color(0xFFE0E7FF),
                                  foreground: const Color(0xFF3730A3),
                                ),
                                if (b['bookingDate'] != null)
                                  DetailTag(label: '${b['bookingDate']}', icon: Icons.event),
                                if (b['note'] != null && '${b['note']}'.isNotEmpty)
                                  DetailTag(label: '${b['note']}', icon: Icons.notes),
                              ],
                              primaryLabel: widget.workerView ? 'Manage' : 'Details',
                              onPrimary: () => _openDetail(b),
                            );
                          },
                        ),
                ),
    );
  }
}
