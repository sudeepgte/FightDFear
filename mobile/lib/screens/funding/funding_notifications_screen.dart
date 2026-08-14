import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'funding_chat_screen.dart';
import 'funding_meetings_screen.dart';

/// Role-aware funding notifications with deep links to chat / meetings.
class FundingNotificationsScreen extends StatefulWidget {
  const FundingNotificationsScreen({
    super.key,
    required this.isEntrepreneur,
  });

  final bool isEntrepreneur;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FundingNotificationsScreen> createState() =>
      _FundingNotificationsScreenState();
}

class _FundingNotificationsScreenState
    extends State<FundingNotificationsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = [];

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
      final res = widget.isEntrepreneur
          ? await _entSvc.notifications()
          : await _invSvc.notifications();
      if (!mounted) return;
      if (res['success'] == true) {
        _items = ModuleTheme.toList(res['notifications']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load notifications';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v');
  }

  String _typeOf(Map<String, dynamic> n) {
    return (n['type'] ?? n['kind'] ?? '').toString().toLowerCase();
  }

  IconData _iconFor(String type) {
    return switch (type) {
      'chat' => Icons.chat_bubble_outline,
      'meeting' => Icons.event_available_outlined,
      'interest' => Icons.favorite_border,
      'investment' => Icons.payments_outlined,
      _ => Icons.notifications_outlined,
    };
  }

  void _onTap(Map<String, dynamic> n) {
    final type = _typeOf(n);
    if (type == 'chat') {
      final proposalId = _asInt(n['proposalId']);
      if (proposalId == null) return;
      final investorId = _asInt(n['investorId']);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FundingChatScreen(
            isEntrepreneur: widget.isEntrepreneur,
            proposalId: proposalId,
            investorId: widget.isEntrepreneur ? investorId : null,
          ),
        ),
      );
      return;
    }
    if (type == 'meeting') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FundingMeetingsScreen(
            isEntrepreneur: widget.isEntrepreneur,
          ),
        ),
      );
      return;
    }
    // Other types: detail already visible on the tile.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: FundingNotificationsScreen.navy,
        elevation: 0.5,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _items.isEmpty
                      ? ListView(
                          children: const [
                            EmptyStateView(
                              icon: Icons.notifications_none_rounded,
                              title: 'All caught up',
                              message:
                                  'Meeting, chat, and funding alerts will appear here.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _items.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final n = _items[i];
                            final type = _typeOf(n);
                            final tappable =
                                type == 'chat' || type == 'meeting';
                            return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: tappable ? () => _onTap(n) : null,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFE4E6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          _iconFor(type),
                                          color:
                                              FundingNotificationsScreen.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              n['title']?.toString() ??
                                                  'Notification',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color:
                                                    FundingNotificationsScreen
                                                        .navy,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              n['body']?.toString() ??
                                                  n['message']?.toString() ??
                                                  '',
                                              style: const TextStyle(
                                                color:
                                                    FundingNotificationsScreen
                                                        .muted,
                                                height: 1.35,
                                              ),
                                            ),
                                            if ((n['at']?.toString() ?? '')
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(
                                                n['at'].toString(),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      FundingNotificationsScreen
                                                          .muted,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (tappable)
                                        const Icon(
                                          Icons.chevron_right,
                                          color:
                                              FundingNotificationsScreen.muted,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
