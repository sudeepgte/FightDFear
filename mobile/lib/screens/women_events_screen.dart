import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

class WomenEventsScreen extends StatefulWidget {
  const WomenEventsScreen({super.key});

  @override
  State<WomenEventsScreen> createState() => _WomenEventsScreenState();
}

class _WomenEventsScreenState extends State<WomenEventsScreen>
    with SingleTickerProviderStateMixin {
  late final WomenEventsService _api;
  late final TabController _tabs;
  bool _loading = true;
  bool _loadingRegs = false;
  String? _error;
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _registrations = [];

  @override
  void initState() {
    super.initState();
    _api = WomenEventsService(context.read<AuthState>().api);
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadRegistrations();
    });
    _loadEvents();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.list();
      if (!mounted) return;
      if (res['success'] == true) {
        _events = ModuleTheme.toList(res['events']);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadRegistrations() async {
    setState(() => _loadingRegs = true);
    try {
      final res = await _api.myRegistrations();
      if (res['success'] == true) {
        _registrations = ModuleTheme.toList(res['registrations']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingRegs = false);
  }

  Future<void> _register(int id) async {
    final res = await _api.register(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res['success'] == true
              ? 'Registered · Ticket: ${res['ticketCode'] ?? ''}'
              : '${res['error']}',
        ),
      ),
    );
    if (res['success'] == true && _tabs.index == 1) _loadRegistrations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Women Events'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        bottom: TabBar(
          controller: _tabs,
          labelColor: ModuleTheme.primary,
          tabs: const [
            Tab(text: 'Events'),
            Tab(text: 'My Tickets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _loading
              ? ModuleTheme.loading()
              : _error != null
                  ? ModuleTheme.errorView(_error!, _loadEvents)
                  : RefreshIndicator(
                      onRefresh: _loadEvents,
                      child: _events.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 80),
                                Center(child: Text('No events listed yet.')),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _events.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final e = _events[i];
                                final id = e['id'];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e['name']?.toString() ?? 'Event',
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${e['eventDate'] ?? ''} · ${e['venue'] ?? ''}, ${e['city'] ?? ''}',
                                          style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
                                        ),
                                        if (e['description'] != null) ...[
                                          const SizedBox(height: 6),
                                          Text(e['description'].toString(), maxLines: 3, overflow: TextOverflow.ellipsis),
                                        ],
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              e['free'] == true ? 'Free' : '₹${e['entryFee'] ?? 0}',
                                              style: const TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                            const Spacer(),
                                            if (id is num)
                                              FilledButton(
                                                onPressed: () => _register(id.toInt()),
                                                child: const Text('Register'),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
          _loadingRegs
              ? ModuleTheme.loading()
              : RefreshIndicator(
                  onRefresh: _loadRegistrations,
                  child: _registrations.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No registrations yet.')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _registrations.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final r = _registrations[i];
                            final event = r['event'];
                            final name = event is Map ? event['name']?.toString() : 'Event';
                            return Card(
                              child: ListTile(
                                title: Text(name ?? 'Event'),
                                subtitle: Text('Ticket: ${r['ticketCode'] ?? ''}\n${r['registeredAt'] ?? ''}'),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
