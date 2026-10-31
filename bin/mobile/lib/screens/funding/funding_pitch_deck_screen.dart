import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

/// Entrepreneur: upload pitch deck PDF/docs (and optionally video) for a proposal.
class FundingPitchDeckScreen extends StatefulWidget {
  const FundingPitchDeckScreen({
    super.key,
    this.proposals,
    this.initialProposalId,
  });

  /// Optional preloaded proposals. When null, loads from entrepreneur dashboard.
  final List<Map<String, dynamic>>? proposals;
  final int? initialProposalId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<FundingPitchDeckScreen> createState() => _FundingPitchDeckScreenState();
}

class _FundingPitchDeckScreenState extends State<FundingPitchDeckScreen> {
  bool _loading = true;
  bool _uploading = false;
  String? _error;
  List<Map<String, dynamic>> _proposals = [];
  int? _selectedProposalId;
  String? _documentsPath;
  String? _videoPitchPath;
  String? _pickedDocPath;
  String? _pickedDocName;
  String? _pickedVideoPath;
  String? _pickedVideoName;

  EntrepreneurAuthService get _svc =>
      EntrepreneurAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _selectedProposalId = widget.initialProposalId;
    if (widget.proposals != null) {
      _proposals = widget.proposals!
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      _applyProposalPaths();
      _loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (!mounted) return;
      if (res['success'] == true) {
        _proposals = ModuleTheme.toList(res['proposals']);
        final ent = Map<String, dynamic>.from(res['entrepreneur'] ?? {});
        _documentsPath = ent['documentsPath']?.toString();
        _videoPitchPath = ent['videoPitchPath']?.toString();
        _selectedProposalId ??= _proposals.isEmpty
            ? null
            : _asInt(_proposals.first['id']);
        _applyProposalPaths();
      } else {
        _error = res['error']?.toString() ?? 'Failed to load proposals';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _applyProposalPaths() {
    if (_selectedProposalId == null) return;
    Map<String, dynamic>? match;
    for (final p in _proposals) {
      if (_asInt(p['id']) == _selectedProposalId) {
        match = p;
        break;
      }
    }
    if (match == null) return;
    final docs = match['documents']?.toString();
    final video = match['videoPitch']?.toString();
    if (docs != null && docs.isNotEmpty) _documentsPath = docs;
    if (video != null && video.isNotEmpty) _videoPitchPath = video;
  }

  int? _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse('$v');
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

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    if (result == null || result.files.isEmpty) return;
    final f = result.files.first;
    if (f.path == null) {
      _toast('Could not read selected file', error: true);
      return;
    }
    setState(() {
      _pickedDocPath = f.path;
      _pickedDocName = f.name;
    });
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp4', 'mov', 'webm', 'mkv'],
    );
    if (result == null || result.files.isEmpty) return;
    final f = result.files.first;
    if (f.path == null) {
      _toast('Could not read selected file', error: true);
      return;
    }
    setState(() {
      _pickedVideoPath = f.path;
      _pickedVideoName = f.name;
    });
  }

  Future<void> _upload() async {
    if (_uploading) return;
    if (_pickedDocPath == null && _pickedVideoPath == null) {
      _toast('Select a pitch deck document or video first', error: true);
      return;
    }

    setState(() {
      _uploading = true;
      _error = null;
    });

    try {
      http.MultipartFile? document;
      http.MultipartFile? videoPitch;
      if (_pickedDocPath != null) {
        document = await http.MultipartFile.fromPath(
          'document',
          _pickedDocPath!,
          filename: _pickedDocName,
        );
      }
      if (_pickedVideoPath != null) {
        videoPitch = await http.MultipartFile.fromPath(
          'videoPitch',
          _pickedVideoPath!,
          filename: _pickedVideoName,
        );
      }

      final Map<String, dynamic> res;
      if (_selectedProposalId != null) {
        res = await _svc.uploadProposalPitch(
          proposalId: _selectedProposalId!,
          document: document,
          videoPitch: videoPitch,
        );
      } else {
        res = await _svc.uploadPitch(
          document: document,
          videoPitch: videoPitch,
        );
      }

      if (!mounted) return;
      if (res['success'] == true) {
        _documentsPath = res['documentsPath']?.toString() ?? _documentsPath;
        _videoPitchPath = res['videoPitchPath']?.toString() ?? _videoPitchPath;
        final proposal = res['proposal'];
        if (proposal is Map) {
          final docs = proposal['documents']?.toString();
          final video = proposal['videoPitch']?.toString();
          if (docs != null && docs.isNotEmpty) _documentsPath = docs;
          if (video != null && video.isNotEmpty) _videoPitchPath = video;
        }
        _pickedDocPath = null;
        _pickedDocName = null;
        _pickedVideoPath = null;
        _pickedVideoName = null;
        _toast(res['message']?.toString() ?? 'Pitch materials uploaded');
      } else {
        _error = res['error']?.toString() ?? 'Upload failed';
        _toast(_error!, error: true);
      }
    } catch (e) {
      _error = '$e';
      _toast(_error!, error: true);
    }

    if (mounted) setState(() => _uploading = false);
  }

  String _fileLabel(String? path) {
    if (path == null || path.isEmpty) return 'Not uploaded';
    final parts = path.split(RegExp(r'[\\/]'));
    return parts.isEmpty ? path : parts.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Pitch Deck'),
        backgroundColor: Colors.white,
        foregroundColor: FundingPitchDeckScreen.navy,
        elevation: 0.5,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null && _proposals.isEmpty
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_proposals.isEmpty)
                        const EmptyStateView(
                          icon: Icons.description_outlined,
                          title: 'No proposals yet',
                          message:
                              'Create a funding proposal first, then upload your pitch deck.',
                        )
                      else ...[
                        const Text(
                          'Proposal',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: FundingPitchDeckScreen.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: _selectedProposalId,
                              items: _proposals
                                  .map((p) {
                                    final id = _asInt(p['id']);
                                    if (id == null) return null;
                                    return DropdownMenuItem(
                                      value: id,
                                      child: Text(
                                        p['title']?.toString() ??
                                            'Proposal #$id',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  })
                                  .whereType<DropdownMenuItem<int>>()
                                  .toList(),
                              onChanged: _uploading
                                  ? null
                                  : (v) {
                                      setState(() {
                                        _selectedProposalId = v;
                                        _applyProposalPaths();
                                      });
                                    },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      _pathCard(
                        'Current document',
                        Icons.picture_as_pdf_outlined,
                        _fileLabel(_documentsPath),
                      ),
                      const SizedBox(height: 10),
                      _pathCard(
                        'Current video pitch',
                        Icons.videocam_outlined,
                        _fileLabel(_videoPitchPath),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _uploading ? null : _pickDocument,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          _pickedDocName == null
                              ? 'Pick PDF / DOC'
                              : 'Doc: $_pickedDocName',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: FundingPitchDeckScreen.primary,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: _uploading ? null : _pickVideo,
                        icon: const Icon(Icons.video_file_outlined),
                        label: Text(
                          _pickedVideoName == null
                              ? 'Pick video (optional)'
                              : 'Video: $_pickedVideoName',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: FundingPitchDeckScreen.navy,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _uploading ? null : _upload,
                        style: FilledButton.styleFrom(
                          backgroundColor: FundingPitchDeckScreen.navy,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: _uploading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Upload pitch materials'),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _pathCard(String title, IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: FundingPitchDeckScreen.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: FundingPitchDeckScreen.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: FundingPitchDeckScreen.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
