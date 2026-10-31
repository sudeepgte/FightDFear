import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';

/// Booking chat backed by existing `MarketplaceMessage` rows.
class MarketplaceBookingChatScreen extends StatefulWidget {
  const MarketplaceBookingChatScreen({
    super.key,
    required this.bookingId,
    required this.asProvider,
    this.peerName,
  });

  final int bookingId;
  final bool asProvider;
  final String? peerName;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MarketplaceBookingChatScreen> createState() =>
      _MarketplaceBookingChatScreenState();
}

class _MarketplaceBookingChatScreenState
    extends State<MarketplaceBookingChatScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _loading = true;
  bool _sending = false;
  String? _error;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetch() {
    final api = context.read<AuthState>().api;
    if (widget.asProvider) {
      return MarketplaceProviderAuthService(api).bookingMessages(widget.bookingId);
    }
    return MarketplaceService(api).bookingMessages(widget.bookingId);
  }

  Future<Map<String, dynamic>> _send(String content) {
    final api = context.read<AuthState>().api;
    if (widget.asProvider) {
      return MarketplaceProviderAuthService(api)
          .sendBookingMessage(widget.bookingId, content);
    }
    return MarketplaceService(api).sendBookingMessage(widget.bookingId, content);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _fetch();
      if (!mounted) return;
      if (res['success'] == true) {
        _messages = ModuleTheme.toList(res['messages']);
      } else {
        _error = res['error']?.toString() ?? 'Unable to load messages';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _submit() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final res = await _send(text);
      if (!mounted) return;
      if (res['success'] == true) {
        _messageCtrl.clear();
        await _load();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Send failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  bool _mine(Map<String, dynamic> m) {
    final role = (m['senderRole']?.toString() ?? '').toUpperCase();
    return widget.asProvider ? role == 'PROVIDER' : role == 'USER';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.peerName?.isNotEmpty == true
            ? widget.peerName!
            : 'Booking chat'),
        backgroundColor: Colors.white,
        foregroundColor: MarketplaceBookingChatScreen.navy,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? ModuleTheme.loading()
                : _error != null
                    ? ModuleTheme.errorView(_error!, _load)
                    : _messages.isEmpty
                        ? const Center(
                            child: Text(
                              'No messages yet. Say hello once this booking is confirmed.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollCtrl,
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                            itemCount: _messages.length,
                            itemBuilder: (_, i) {
                              final m = _messages[i];
                              final mine = _mine(m);
                              return Align(
                                alignment: mine
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.75,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mine
                                        ? MarketplaceBookingChatScreen.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: mine
                                        ? null
                                        : Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Text(
                                    m['content']?.toString() ?? '',
                                    style: TextStyle(
                                      color: mine ? Colors.white : MarketplaceBookingChatScreen.navy,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      enabled: !_sending,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _submit,
                    style: IconButton.styleFrom(
                      backgroundColor: MarketplaceBookingChatScreen.primary,
                    ),
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send),
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
