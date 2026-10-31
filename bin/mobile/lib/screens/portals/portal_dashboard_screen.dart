import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/module_theme.dart';

/// Lightweight portal dashboard: profile header + item list with optional status actions.
class PortalDashboardScreen extends StatefulWidget {
  const PortalDashboardScreen({
    super.key,
    required this.title,
    required this.load,
    required this.profileKey,
    required this.listKey,
    this.listTitle = 'Items',
    this.statusActions = const ['ACCEPTED', 'REJECTED', 'COMPLETED'],
    this.onStatus,
    this.onAdd,
    this.addLabel,
  });

  final String title;
  final Future<Map<String, dynamic>> Function() load;
  final String profileKey;
  final String listKey;
  final String listTitle;
  final List<String> statusActions;
  final Future<Map<String, dynamic>> Function(int id, String status)? onStatus;
  final Future<void> Function()? onAdd;
  final String? addLabel;

  @override
  State<PortalDashboardScreen> createState() => _PortalDashboardScreenState();
}

class _PortalDashboardScreenState extends State<PortalDashboardScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _profile = {};
  List<Map<String, dynamic>> _items = [];
  Map<String, dynamic> _raw = {};

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await widget.load();
      if (res['success'] == true) {
        _raw = res;
        final p = res[widget.profileKey];
        _profile = p is Map ? Map<String, dynamic>.from(p) : <String, dynamic>{};
        _items = ModuleTheme.toList(res[widget.listKey]);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  String _titleOf(Map<String, dynamic> item) {
    return item['fullName']?.toString() ??
        item['clientName']?.toString() ??
        item['buyerName']?.toString() ??
        item['userName']?.toString() ??
        item['className']?.toString() ??
        item['productName']?.toString() ??
        item['name']?.toString() ??
        item['title']?.toString() ??
        item['eventName']?.toString() ??
        'Item #${item['id'] ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthState>();
    final name = _profile['fullName']?.toString() ??
        _profile['name']?.toString() ??
        _profile['businessName']?.toString() ??
        widget.title;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.onAdd != null)
            IconButton(
              onPressed: () async {
                await widget.onAdd!();
                await _reload();
              },
              icon: const Icon(Icons.add_circle_outline),
              tooltip: widget.addLabel ?? 'Add',
            ),
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _reload)
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(
                            [
                              if (_profile['email'] != null) '${_profile['email']}',
                              if (_profile['specialization'] != null) '${_profile['specialization']}',
                              if (_raw['totalEarnings'] != null) 'Earnings: ₹${_raw['totalEarnings']}',
                              if (_raw['pendingCount'] != null) 'Pending: ${_raw['pendingCount']}',
                            ].where((e) => e.isNotEmpty).join(' · '),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(widget.listTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      if (_items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(child: Text('Nothing here yet.')),
                        )
                      else
                        ..._items.map((item) {
                          final id = item['id'] is int ? item['id'] as int : int.tryParse('${item['id']}');
                          return Card(
                            child: ListTile(
                              title: Text(_titleOf(item)),
                              subtitle: Text(
                                [
                                  if (item['status'] != null) '${item['status']}',
                                  if (item['appointmentTime'] != null) '${item['appointmentTime']}',
                                  if (item['bookingDate'] != null) '${item['bookingDate']}',
                                  if (item['requestedTime'] != null) '${item['requestedTime']}',
                                  if (item['price'] != null) '₹${item['price']}',
                                  if (item['amount'] != null) '₹${item['amount']}',
                                  if (item['note'] != null) '${item['note']}',
                                ].where((e) => e.isNotEmpty).join(' · '),
                              ),
                              isThreeLine: true,
                              trailing: widget.onStatus == null || id == null
                                  ? null
                                  : PopupMenuButton<String>(
                                      onSelected: (v) async {
                                        final res = await widget.onStatus!(id, v);
                                        if (!mounted) return;
                                        final messenger = ScaffoldMessenger.of(context);
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              res['success'] == true
                                                  ? 'Updated'
                                                  : '${res['error']}',
                                            ),
                                          ),
                                        );
                                        if (res['success'] == true) _reload();
                                      },
                                      itemBuilder: (_) => widget.statusActions
                                          .map((s) => PopupMenuItem(value: s, child: Text(s)))
                                          .toList(),
                                    ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}
