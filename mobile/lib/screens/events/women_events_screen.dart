import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';

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
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: _events.length + 1,
                              itemBuilder: (_, i) {
                                if (i == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Showing ${_events.length} women events',
                                      style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                                    ),
                                  );
                                }
                                final e = _events[i - 1];
                                final id = e['id'];
                                final loc = [
                                  e['venue'],
                                  e['city'],
                                ].where((x) => x != null && x.toString().trim().isNotEmpty).join(', ');
                                final image = e['imagePath']?.toString() ??
                                    e['bannerUrl']?.toString() ??
                                    e['bannerImage']?.toString();
                                return DetailListingCard(
                                  title: e['name']?.toString() ?? 'Event',
                                  eyebrow: e['category']?.toString() ?? 'Women Event',
                                  location: loc.isEmpty ? e['eventDate']?.toString() : '$loc · ${e['eventDate'] ?? ''}',
                                  photoUrl: (image == null || image.isEmpty) ? null : image,
                                  showMediaActions: false,
                                  tags: [
                                    DetailTag(
                                      label: e['free'] == true ? 'Free' : '₹${e['entryFee'] ?? 0}',
                                      icon: Icons.currency_rupee,
                                      background: const Color(0xFFE0E7FF),
                                      foreground: const Color(0xFF3730A3),
                                    ),
                                    if (e['eventDate'] != null)
                                      DetailTag(label: '${e['eventDate']}', icon: Icons.event),
                                    if (e['capacity'] != null || e['maxParticipants'] != null)
                                      DetailTag(
                                        label: '${e['capacity'] ?? e['maxParticipants']} seats',
                                        icon: Icons.groups_outlined,
                                      ),
                                  ],
                                  primaryLabel: 'View & Register',
                                  onPrimary: id is num ? () => _register(id.toInt()) : null,
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
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: _registrations.length,
                          itemBuilder: (_, i) {
                            final r = _registrations[i];
                            final event = r['event'] is Map
                                ? Map<String, dynamic>.from(r['event'] as Map)
                                : <String, dynamic>{};
                            final name = event['name']?.toString() ?? 'Event';
                            return DetailListingCard(
                              title: name,
                              eyebrow: 'Ticket',
                              location: event['venue']?.toString() ?? event['city']?.toString(),
                              showMediaActions: false,
                              tags: [
                                DetailTag(
                                  label: r['ticketCode']?.toString() ?? '—',
                                  icon: Icons.confirmation_number_outlined,
                                  background: const Color(0xFFFEF3C7),
                                  foreground: const Color(0xFFB45309),
                                ),
                                if (r['registeredAt'] != null)
                                  DetailTag(label: '${r['registeredAt']}', icon: Icons.schedule),
                                if (r['status'] != null)
                                  DetailTag(label: '${r['status']}', icon: Icons.info_outline),
                              ],
                              primaryLabel: 'Ticket details',
                              onPrimary: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ticket ${r['ticketCode'] ?? ''}')),
                                );
                              },
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
