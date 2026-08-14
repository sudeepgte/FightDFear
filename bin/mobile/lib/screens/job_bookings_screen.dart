import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.workerView ? 'Job Bookings (Worker)' : 'Job Bookings'),
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
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No job bookings yet.')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _bookings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final b = _bookings[i];
                            final other = b['clientName'] ?? b['workerName'] ?? 'Booking';
                            return Card(
                              child: ListTile(
                                title: Text(other.toString()),
                                subtitle: Text(
                                  '${b['status'] ?? ''}\n${b['bookingDate'] ?? ''}\n${b['note'] ?? ''}',
                                ),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
