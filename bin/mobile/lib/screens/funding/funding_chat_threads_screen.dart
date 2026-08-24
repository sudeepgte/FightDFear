import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'funding_chat_screen.dart';

/// Lists chat threads for entrepreneur or investor.
class FundingChatThreadsScreen extends StatefulWidget {
  const FundingChatThreadsScreen({
    super.key,
    required this.isEntrepreneur,
  });

  final bool isEntrepreneur;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FundingChatThreadsScreen> createState() =>
      _FundingChatThreadsScreenState();
}

class _FundingChatThreadsScreenState extends State<FundingChatThreadsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _threads = [];

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
          ? await _entSvc.chatThreads()
          : await _invSvc.chatThreads();
      if (!mounted) return;
      if (res['success'] == true) {
        _threads = ModuleTheme.toList(res['threads']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load chats';
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

  void _openThread(Map<String, dynamic> t) {
    final proposalId = _asInt(t['proposalId']);
    if (proposalId == null) return;
    final investorId = _asInt(t['investorId']);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FundingChatScreen(
          isEntrepreneur: widget.isEntrepreneur,
          proposalId: proposalId,
          investorId: widget.isEntrepreneur ? investorId : null,
          title: t['proposalTitle']?.toString(),
          peerName: widget.isEntrepreneur
              ? t['investorName']?.toString()
              : t['entrepreneurName']?.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(widget.isEntrepreneur ? 'Investor Chat' : 'Entrepreneur Chat'),
        backgroundColor: Colors.white,
        foregroundColor: FundingChatThreadsScreen.navy,
        elevation: 0.5,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _threads.isEmpty
                      ? ListView(
                          children: const [
                            EmptyStateView(
                              icon: Icons.chat_bubble_outline,
                              title: 'No conversations',
                              message:
                                  'Chats appear after investment interest or meeting requests.',
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _threads.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final t = _threads[i];
                            final peer = widget.isEntrepreneur
                                ? (t['investorName']?.toString() ?? 'Investor')
                                : (t['entrepreneurName']?.toString() ??
                                    t['businessName']?.toString() ??
                                    'Entrepreneur');
                            final last = t['lastMessage']?.toString();
                            return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _openThread(t),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFFFE4E6),
                                        child: Text(
                                          peer.isEmpty
                                              ? '?'
                                              : peer[0].toUpperCase(),
                                          style: const TextStyle(
                                            color:
                                                FundingChatThreadsScreen.primary,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              peer,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color:
                                                    FundingChatThreadsScreen.navy,
                                              ),
                                            ),
                                            Text(
                                              t['proposalTitle']?.toString() ??
                                                  'Proposal',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color:
                                                    FundingChatThreadsScreen.muted,
                                              ),
                                            ),
                                            if (last != null &&
                                                last.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                last,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: FundingChatThreadsScreen.muted,
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
