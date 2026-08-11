import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';

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
  String _section = 'videos';

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

  List<Map<String, dynamic>> get _activeItems => switch (_section) {
        'live' => _liveSessions,
        'workshops' => _workshops,
        _ => _videos,
      };

  Widget _itemCard(Map<String, dynamic> item) {
    final title = item['title']?.toString() ?? item['name']?.toString() ?? 'Item';
    final host = item['host']?.toString() ?? item['instructor']?.toString();
    final desc = item['description']?.toString();
    return DetailListingCard(
      title: title,
      eyebrow: _section == 'live'
          ? 'Live Session'
          : _section == 'workshops'
              ? 'Workshop'
              : 'Video',
      location: host ?? item['scheduledAt']?.toString() ?? item['date']?.toString(),
      showMediaActions: false,
      tags: [
        if (item['duration'] != null) DetailTag(label: '${item['duration']}', icon: Icons.timer_outlined),
        if (item['level'] != null) DetailTag(label: '${item['level']}', icon: Icons.school_outlined),
        if (item['free'] == true)
          const DetailTag(
            label: 'Free',
            icon: Icons.verified,
            background: Color(0xFFDCFCE7),
            foreground: Color(0xFF166534),
          ),
        if (desc != null && desc.isNotEmpty)
          DetailTag(
            label: desc.length > 28 ? '${desc.substring(0, 28)}…' : desc,
            icon: Icons.info_outline,
          ),
      ],
      primaryLabel: 'View details',
      onPrimary: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(desc ?? title)));
      },
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
                  child: empty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Content will appear when admins add videos, live sessions, and workshops on the web hub.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: ModuleTheme.textGray),
                              ),
                            ),
                          ],
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 24),
                          children: [
                            const SizedBox(height: 10),
                            CategoryPillBar(
                              options: const [
                                (value: 'videos', label: 'Videos', icon: Icons.play_circle_outline),
                                (value: 'live', label: 'Live', icon: Icons.live_tv_outlined),
                                (value: 'workshops', label: 'Workshops', icon: Icons.groups_outlined),
                              ],
                              selected: _section,
                              onSelected: (v) => setState(() => _section = v),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                              child: Text(
                                'Showing ${_activeItems.length} $_section',
                                style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                              ),
                            ),
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
