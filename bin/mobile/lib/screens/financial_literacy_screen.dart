import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

class FinancialLiteracyScreen extends StatefulWidget {
  const FinancialLiteracyScreen({super.key});

  @override
  State<FinancialLiteracyScreen> createState() => _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState extends State<FinancialLiteracyScreen> {
  late final FinancialLiteracyService _api;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _videos = [];
  List<Map<String, dynamic>> _liveSessions = [];
  List<Map<String, dynamic>> _workshops = [];

  @override
  void initState() {
    super.initState();
    _api = FinancialLiteracyService(context.read<AuthState>().api);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.home();
      if (!mounted) return;
      if (res['success'] == true) {
        _videos = ModuleTheme.toList(res['videos']);
        _liveSessions = ModuleTheme.toList(res['liveSessions']);
        _workshops = ModuleTheme.toList(res['workshops']);
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Widget _section(String title, List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        ...items.map((item) => Card(
              child: ListTile(
                title: Text(item['title']?.toString() ?? item['name']?.toString() ?? 'Item'),
                subtitle: Text(item['description']?.toString() ?? item['host']?.toString() ?? ''),
              ),
            )),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final empty = _videos.isEmpty && _liveSessions.isEmpty && _workshops.isEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Financial Literacy Hub'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (empty)
                        const Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: Center(
                            child: Text(
                              'Content will appear when admins add videos, live sessions, and workshops on the web hub.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: ModuleTheme.textGray),
                            ),
                          ),
                        )
                      else ...[
                        _section('Videos', _videos),
                        _section('Live sessions', _liveSessions),
                        _section('Workshops', _workshops),
                      ],
                    ],
                  ),
                ),
    );
  }
}
