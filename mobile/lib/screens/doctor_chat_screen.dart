import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api_client.dart';
import '../services/doctor_auth_service.dart';
import '../services/module_services.dart';
import '../widgets/module_theme.dart';

/// Polling chat between a member and a doctor.
class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({
    super.key,
    required this.api,
    required this.doctorId,
    required this.title,
    this.userId,
    this.asDoctor = false,
  });

  final ApiClient api;
  final int doctorId;
  final String title;
  final int? userId;
  final bool asDoctor;

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> res;
      if (widget.asDoctor) {
        if (widget.userId == null) {
          setState(() {
            _error = 'Missing patient id';
            _loading = false;
          });
          return;
        }
        res = await DoctorAuthService(widget.api).chatHistory(
          widget.doctorId,
          userId: widget.userId!,
        );
      } else {
        res = await DoctorService(widget.api).chatHistory(widget.doctorId);
      }
      if (res['success'] == true) {
        _messages = ModuleTheme.toList(res['messages']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load chat';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) {
      setState(() => _loading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    try {
      final Map<String, dynamic> res;
      if (widget.asDoctor) {
        res = await DoctorAuthService(widget.api).sendChat(
          widget.doctorId,
          userId: widget.userId!,
          message: text,
        );
      } else {
        res = await DoctorService(widget.api).sendChat(widget.doctorId, message: text);
      }
      if (res['success'] != true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Send failed')),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? ModuleTheme.loading()
                : _error != null
                    ? ModuleTheme.errorView(_error!, _load)
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.all(12),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final m = _messages[i];
                          final mine = widget.asDoctor
                              ? m['senderType']?.toString() == 'DOCTOR'
                              : m['senderType']?.toString() == 'USER';
                          return Align(
                            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: mine ? ModuleTheme.primary.withValues(alpha: 0.15) : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m['message']?.toString() ?? ''),
                                  const SizedBox(height: 2),
                                  Text(
                                    m['timestamp']?.toString() ?? '',
                                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(
                        hintText: 'Type a message…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
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

Future<void> openDoctorJitsi(BuildContext context, ApiClient api, int appointmentId, {bool audioOnly = false}) async {
  try {
    final res = await DoctorService(api).joinAppointment(appointmentId, audioOnly: audioOnly);
    if (res['success'] != true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Unable to join call')),
        );
      }
      return;
    }
    final url = res['jitsiUrl']?.toString();
    if (url == null || url.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No meeting room available')),
        );
      }
      return;
    }
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Open this link: $url')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

Future<void> showDoctorReviewDialog(
  BuildContext context, {
  required DoctorService service,
  required int doctorId,
  required VoidCallback onDone,
}) async {
  int rating = 5;
  final comment = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) => AlertDialog(
        title: const Text('Rate doctor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final n = i + 1;
                return IconButton(
                  onPressed: () => setLocal(() => rating = n),
                  icon: Icon(n <= rating ? Icons.star : Icons.star_border, color: Colors.amber),
                );
              }),
            ),
            TextField(
              controller: comment,
              decoration: const InputDecoration(labelText: 'Comment (optional)'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final res = await service.addReview(doctorId, rating: rating, comment: comment.text.trim());
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        res['success'] == true
            ? (res['message']?.toString() ?? 'Review submitted')
            : (res['error']?.toString() ?? 'Failed'),
      ),
    ),
  );
  if (res['success'] == true) onDone();
}
