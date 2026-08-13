import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

enum CatalogKind { doctors, marketplace, lawyers, fitness }

class ProviderCatalogScreen extends StatefulWidget {
  const ProviderCatalogScreen({
    super.key,
    required this.title,
    required this.kind,
  });

  final String title;
  final CatalogKind kind;

  @override
  State<ProviderCatalogScreen> createState() => _ProviderCatalogScreenState();
}

class _ProviderCatalogScreenState extends State<ProviderCatalogScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  DoctorService? _doctors;
  MarketplaceService? _marketplace;
  FitnessService? _fitness;

  bool _loading = true;
  bool _loadingBookings = false;
  String? _error;
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _doctors = DoctorService(api);
    _marketplace = MarketplaceService(api);
    _fitness = FitnessService(api);
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadBookings();
    });
    _loadList();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String get _listKey => switch (widget.kind) {
        CatalogKind.doctors => 'doctors',
        CatalogKind.marketplace || CatalogKind.lawyers => 'providers',
        CatalogKind.fitness => 'trainers',
      };

  Future<void> _loadList() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.list();
        case CatalogKind.lawyers:
          res = await _marketplace!.providers(category: 'WOMEN_LAWYER');
        case CatalogKind.marketplace:
          res = await _marketplace!.providers();
        case CatalogKind.fitness:
          res = await _fitness!.trainers();
      }
      if (!mounted) return;
      if (res['success'] == true) {
        _items = ModuleTheme.toList(res[_listKey]);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.myAppointments();
          if (res['success'] == true) {
            _bookings = ModuleTheme.toList(res['appointments']);
          }
        case CatalogKind.marketplace:
        case CatalogKind.lawyers:
          res = await _marketplace!.myBookings();
          if (res['success'] == true) {
            _bookings = ModuleTheme.toList(res['bookings']);
          }
        case CatalogKind.fitness:
          res = await _fitness!.myBookings();
          if (res['success'] == true) {
            _bookings = ModuleTheme.toList(res['bookings']);
          }
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
  }

  String _itemTitle(Map<String, dynamic> item) =>
      item['fullName']?.toString() ?? item['name']?.toString() ?? 'Item';

  String _itemSubtitle(Map<String, dynamic> item) {
    switch (widget.kind) {
      case CatalogKind.doctors:
        return '${item['specialization'] ?? ''} · ${item['city'] ?? ''}'.trim();
      case CatalogKind.lawyers:
      case CatalogKind.marketplace:
        return '${item['category'] ?? ''} · ${item['locationText'] ?? ''}'.trim();
      case CatalogKind.fitness:
        return '${item['specializations'] ?? ''} · ₹${item['sessionFees'] ?? ''}'.trim();
    }
  }

  Future<void> _bookItem(Map<String, dynamic> item) async {
    final id = item['id'];
    if (id is! num) return;
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${_itemTitle(item)}'),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Request')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.book(id.toInt(), notes: noteCtrl.text);
        case CatalogKind.marketplace:
        case CatalogKind.lawyers:
          res = await _marketplace!.book(id.toInt(), note: noteCtrl.text);
        case CatalogKind.fitness:
          res = await _fitness!.book(id.toInt(), note: noteCtrl.text);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['success'] == true
                ? (res['message']?.toString() ?? 'Booking requested')
                : (res['error']?.toString() ?? 'Booking failed'),
          ),
        ),
      );
      if (res['success'] == true && _tabs.index == 1) _loadBookings();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        bottom: TabBar(
          controller: _tabs,
          labelColor: ModuleTheme.primary,
          unselectedLabelColor: ModuleTheme.textGray,
          tabs: const [
            Tab(text: 'Browse'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _loading
              ? ModuleTheme.loading()
              : _error != null
                  ? ModuleTheme.errorView(_error!, _loadList)
                  : RefreshIndicator(
                      onRefresh: _loadList,
                      child: _items.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 80),
                                Center(child: Text('Nothing listed yet.')),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final item = _items[i];
                                return _CatalogCard(
                                  title: _itemTitle(item),
                                  subtitle: _itemSubtitle(item),
                                  trailing: item['rating']?.toString(),
                                  onBook: () => _bookItem(item),
                                );
                              },
                            ),
                    ),
          _loadingBookings
              ? ModuleTheme.loading()
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: _bookings.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No bookings yet.')),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _bookings.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final b = _bookings[i];
                            final nested = b['doctor'] ?? b['provider'] ?? b['trainer'];
                            final name = nested is Map
                                ? (nested['fullName']?.toString() ?? 'Booking')
                                : 'Booking';
                            return Card(
                              child: ListTile(
                                title: Text(name),
                                subtitle: Text(
                                  '${b['status'] ?? ''}\n${b['appointmentTime'] ?? b['requestedTime'] ?? b['bookingDate'] ?? ''}',
                                ),
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

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onBook,
  });

  final String title;
  final String subtitle;
  final String? trailing;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12)),
                  ],
                  if (trailing != null) ...[
                    const SizedBox(height: 4),
                    Text('★ $trailing', style: const TextStyle(fontSize: 12)),
                  ],
                ],
              ),
            ),
            FilledButton(onPressed: onBook, child: const Text('Book')),
          ],
        ),
      ),
    );
  }
}
