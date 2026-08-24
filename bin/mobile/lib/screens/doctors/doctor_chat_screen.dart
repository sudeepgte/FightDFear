import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/api_client.dart';
import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';

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
  Timer? _poll;
  int _lastCount = 0;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load(initial: true);
    _poll = Timer.periodic(const Duration(seconds: 4), (_) => _load());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({bool initial = false}) async {
    if (initial) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final Map<String, dynamic> res;
      if (widget.asDoctor) {
        if (widget.userId == null) {
          if (mounted) {
            setState(() {
              _error = 'Missing patient id';
              _loading = false;
            });
          }
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
      } else if (initial) {
        _error = res['error']?.toString() ?? 'Failed to load chat';
      }
    } catch (e) {
      if (initial) _error = '$e';
    }
    if (!mounted) return;
    final grew = _messages.length > _lastCount;
    _lastCount = _messages.length;
    setState(() => _loading = false);
    if (grew || initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    }
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    _input.clear();
    setState(() => _sending = true);
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
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _attach() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_outlined),
              title: const Text('Photo'),
              onTap: () => Navigator.pop(ctx, 'photo'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('File / report'),
              onTap: () => Navigator.pop(ctx, 'file'),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    String? path;
    if (choice == 'photo') {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
      path = picked?.path;
    } else {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
      );
      path = picked?.files.single.path;
    }
    if (path == null || path.isEmpty) return;
    setState(() => _sending = true);
    try {
      final Map<String, dynamic> res;
      if (widget.asDoctor) {
        res = await DoctorAuthService(widget.api).uploadChatFile(
          widget.doctorId,
          userId: widget.userId!,
          filePath: path,
        );
      } else {
        res = await DoctorService(widget.api).uploadChatFile(widget.doctorId, filePath: path);
      }
      if (res['success'] != true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Upload failed')),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _bubble(Map<String, dynamic> m, bool mine) {
    final attachment = m['attachmentPath']?.toString() ?? '';
    final url = attachment.isEmpty
        ? null
        : ModuleTheme.mediaUrl(context.read<AuthState>().api.baseUrl, attachment);
    final isImage = attachment.toLowerCase().endsWith('.jpg') ||
        attachment.toLowerCase().endsWith('.jpeg') ||
        attachment.toLowerCase().endsWith('.png');
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: mine ? ModuleTheme.primary.withValues(alpha: 0.15) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (url != null && isImage)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url, height: 140, fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined)),
                ),
              )
            else if (url != null)
              TextButton.icon(
                onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Open attachment'),
              ),
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
                          return _bubble(m, mine);
                        },
                      ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _sending ? null : _attach,
                    icon: const Icon(Icons.attach_file),
                    tooltip: 'Attach photo or report',
                  ),
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
                    onPressed: _sending ? null : _send,
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
