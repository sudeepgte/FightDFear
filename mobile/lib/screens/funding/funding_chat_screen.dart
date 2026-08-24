import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

/// One-to-one funding chat for a proposal thread.
class FundingChatScreen extends StatefulWidget {
  const FundingChatScreen({
    super.key,
    required this.isEntrepreneur,
    required this.proposalId,
    this.investorId,
    this.title,
    this.peerName,
  });

  final bool isEntrepreneur;
  final int proposalId;

  /// Required when [isEntrepreneur] is true.
  final int? investorId;
  final String? title;
  final String? peerName;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FundingChatScreen> createState() => _FundingChatScreenState();
}

class _FundingChatScreenState extends State<FundingChatScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _loading = true;
  bool _sending = false;
  String? _error;
  String? _headerTitle;
  String? _peerName;
  List<Map<String, dynamic>> _messages = [];

  EntrepreneurAuthService get _entSvc =>
      EntrepreneurAuthService(context.read<AuthState>().api);
  InvestorAuthService get _invSvc =>
      InvestorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _headerTitle = widget.title;
    _peerName = widget.peerName;
    _load();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.isEntrepreneur && widget.investorId == null) {
      setState(() {
        _loading = false;
        _error = 'investorId is required for entrepreneur chat';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> res;
      if (widget.isEntrepreneur) {
        res = await _entSvc.chatMessages(
          proposalId: widget.proposalId,
          investorId: widget.investorId!,
        );
      } else {
        res = await _invSvc.chatMessages(proposalId: widget.proposalId);
      }
      if (!mounted) return;
      if (res['success'] == true) {
        _messages = ModuleTheme.toList(res['messages']);
        _headerTitle ??= res['proposalTitle']?.toString();
        _peerName ??= widget.isEntrepreneur
            ? res['investorName']?.toString()
            : res['entrepreneurName']?.toString();
      } else {
        _error = res['error']?.toString() ?? 'Failed to load messages';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) {
      setState(() => _loading = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red.shade700 : null,
      ),
    );
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    if (widget.isEntrepreneur && widget.investorId == null) {
      _toast('Missing investorId', error: true);
      return;
    }

    setState(() => _sending = true);
    try {
      final Map<String, dynamic> res;
      if (widget.isEntrepreneur) {
        res = await _entSvc.sendChat(
          proposalId: widget.proposalId,
          investorId: widget.investorId!,
          message: text,
        );
      } else {
        res = await _invSvc.sendChat(
          proposalId: widget.proposalId,
          message: text,
        );
      }
      if (!mounted) return;
      if (res['success'] == true) {
        _messageCtrl.clear();
        final chat = res['chat'];
        if (chat is Map) {
          setState(() {
            _messages = [
              ..._messages,
              Map<String, dynamic>.from(chat),
            ];
          });
          _scrollToEnd();
        } else {
          await _load();
        }
      } else {
        _toast(res['error']?.toString() ?? 'Send failed', error: true);
      }
    } catch (e) {
      _toast('$e', error: true);
    }
    if (mounted) setState(() => _sending = false);
  }

  bool _isMine(Map<String, dynamic> m) {
    final role = (m['senderRole']?.toString() ?? '').toUpperCase();
    if (widget.isEntrepreneur) return role == 'ENTREPRENEUR';
    return role == 'INVESTOR';
  }

  @override
  Widget build(BuildContext context) {
    final title = _peerName?.isNotEmpty == true
        ? _peerName!
        : (_headerTitle ?? 'Chat');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            if (_headerTitle != null && _peerName != null)
              Text(
                _headerTitle!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: FundingChatScreen.muted,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: FundingChatScreen.navy,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? ModuleTheme.loading()
                : _error != null
                    ? ModuleTheme.errorView(_error!, _load)
                    : RefreshIndicator(
                        onRefresh: _load,
                        child: _messages.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  EmptyStateView(
                                    icon: Icons.forum_outlined,
                                    title: 'Start the conversation',
                                    message:
                                        'Send a message to begin chatting about this proposal.',
                                  ),
                                ],
                              )
                            : ListView.builder(
                                controller: _scrollCtrl,
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                itemCount: _messages.length,
                                itemBuilder: (_, i) {
                                  final m = _messages[i];
                                  final mine = _isMine(m);
                                  return Align(
                                    alignment: mine
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.78,
                                      ),
                                      decoration: BoxDecoration(
                                        color: mine
                                            ? FundingChatScreen.primary
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        border: mine
                                            ? null
                                            : Border.all(
                                                color: const Color(0xFFE2E8F0),
                                              ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m['message']?.toString() ?? '',
                                            style: TextStyle(
                                              color: mine
                                                  ? Colors.white
                                                  : FundingChatScreen.navy,
                                              height: 1.35,
                                            ),
                                          ),
                                          if ((m['timestamp']?.toString() ?? '')
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              m['timestamp'].toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: mine
                                                    ? Colors.white70
                                                    : FundingChatScreen.muted,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message…',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    style: IconButton.styleFrom(
                      backgroundColor: FundingChatScreen.primary,
                    ),
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
