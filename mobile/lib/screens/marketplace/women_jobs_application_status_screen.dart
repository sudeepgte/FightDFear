import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';
import 'job_bookings_screen.dart';
import 'women_jobs_profile_completion_screen.dart';
import 'women_marketplace_screen.dart';

/// Worker sees PENDING / VERIFIED / REJECTED after applying.
class WomenJobsApplicationStatusScreen extends StatefulWidget {
  const WomenJobsApplicationStatusScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<WomenJobsApplicationStatusScreen> createState() =>
      _WomenJobsApplicationStatusScreenState();
}

class _WomenJobsApplicationStatusScreenState
    extends State<WomenJobsApplicationStatusScreen> {
  late final MarketplaceService _api;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _application;
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    _api = MarketplaceService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.myJobApplication();
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['application'];
        _application = raw is Map ? Map<String, dynamic>.from(raw) : null;
        _verified = res['isVerifiedWorker'] == true;
      } else {
        _error = res['error']?.toString() ?? 'Unable to load application';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Color _statusColor(String status) {
    return switch (status) {
      'VERIFIED' => const Color(0xFF166534),
      'REJECTED' => const Color(0xFFBE123C),
      _ => const Color(0xFFB45309),
    };
  }

  Color _statusBg(String status) {
    return switch (status) {
      'VERIFIED' => const Color(0xFFDCFCE7),
      'REJECTED' => const Color(0xFFFFE4E6),
      _ => const Color(0xFFFEF3C7),
    };
  }

  String _statusCopy(String status) {
    return switch (status) {
      'VERIFIED' =>
        'You are a verified worker. Incoming bookings will appear in Job Bookings.',
      'REJECTED' =>
        'Your application was not approved. You can submit a new application.',
      _ =>
        'Your application is under admin review. You will appear on the Workers tab after approval.',
    };
  }

  @override
  Widget build(BuildContext context) {
    final status = (_application?['status']?.toString() ?? 'PENDING').toUpperCase();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Application status'),
        backgroundColor: Colors.white,
        foregroundColor: WomenJobsApplicationStatusScreen.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: [
                      if (_application == null) ...[
                        const SizedBox(height: 40),
                        const Icon(Icons.work_outline, size: 56, color: Colors.black26),
                        const SizedBox(height: 12),
                        const Text(
                          'You have not applied yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Submit an application to appear as a verified worker after admin approval.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ModuleTheme.textGray),
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WomenJobsProfileCompletionScreen(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: WomenJobsApplicationStatusScreen.primary,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Apply now'),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusBg(status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: _statusColor(status),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _statusCopy(status),
                                style: const TextStyle(color: ModuleTheme.textGray),
                              ),
                              const SizedBox(height: 16),
                              _row('Category', _application!['jobCategory']),
                              _row('Role', _application!['jobSubCategory']),
                              _row('Hourly rate', '₹${_application!['hourlyRate'] ?? 0}'),
                              _row('Applied', _application!['appliedAt']),
                              if ((_application!['note']?.toString() ?? '').isNotEmpty)
                                _row('Note', _application!['note']),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_verified)
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const JobBookingsScreen(workerView: true),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: WomenJobsApplicationStatusScreen.primary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text('Open Job Bookings'),
                          )
                        else if (status == 'REJECTED')
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const WomenJobsProfileCompletionScreen(),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: WomenJobsApplicationStatusScreen.primary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text('Apply again'),
                          ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const WomenMarketplaceScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Browse marketplace'),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _row(String label, Object? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray)),
          Text(
            value?.toString() ?? '—',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
