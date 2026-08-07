import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

class DoctorProfileCompletionScreen extends StatefulWidget {
  const DoctorProfileCompletionScreen({super.key});

  @override
  State<DoctorProfileCompletionScreen> createState() => _DoctorProfileCompletionScreenState();
}

class _AvailabilitySlot {
  String day;
  TimeOfDay start;
  TimeOfDay end;

  _AvailabilitySlot({
    required this.day,
    required this.start,
    required this.end,
  });
}

class _DoctorProfileCompletionScreenState extends State<DoctorProfileCompletionScreen> {
  static const _days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'];
  static const _modes = [
    ('CLINIC', 'Clinic'),
    ('VIDEO', 'Video'),
    ('ONLINE', 'Online'),
    ('OFFLINE', 'Home visit'),
  ];
  static const _maxUploadBytes = 5 * 1024 * 1024;
  static const _allowedExt = {'.jpg', '.jpeg', '.png', '.pdf'};

  final _fullName = TextEditingController();
  final _specialization = TextEditingController();
  final _qualification = TextEditingController();
  final _medicalReg = TextEditingController();
  final _experience = TextEditingController();
  final _hospital = TextEditingController();
  final _clinicAddress = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pincode = TextEditingController();
  final _languages = TextEditingController();
  final _services = TextEditingController();
  final _bio = TextEditingController();
  final _consultationFee = TextEditingController();
  final _chatFee = TextEditingController();
  final _callFee = TextEditingController();
  final _videoFee = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _profile = {};
  final Set<String> _selectedModes = {};
  final List<_AvailabilitySlot> _slots = [];
  bool _emergency = false;
  String? _uploadingType;
  double _uploadProgress = 0;

  DoctorAuthService get _svc => DoctorAuthService(context.read<AuthState>().api);
  String get _baseUrl => context.read<AuthState>().api.baseUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _specialization.dispose();
    _qualification.dispose();
    _medicalReg.dispose();
    _experience.dispose();
    _hospital.dispose();
    _clinicAddress.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    _languages.dispose();
    _services.dispose();
    _bio.dispose();
    _consultationFee.dispose();
    _chatFee.dispose();
    _callFee.dispose();
    _videoFee.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _svc.profile();
    if (!mounted) return;
    if (res['success'] == true && res['profile'] is Map) {
      _applyProfile(Map<String, dynamic>.from(res['profile'] as Map));
      setState(() => _loading = false);
    } else {
      setState(() {
        _loading = false;
        _error = res['error']?.toString() ?? 'Failed to load profile';
      });
    }
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    _fullName.text = p['fullName']?.toString() ?? '';
    _specialization.text = p['specialization']?.toString() ?? '';
    _qualification.text = p['qualification']?.toString() ?? '';
    _medicalReg.text = p['medicalRegNumber']?.toString() ?? '';
    _experience.text = p['experienceYears']?.toString() ?? '';
    _hospital.text = p['hospitalName']?.toString() ?? '';
    _clinicAddress.text = p['clinicAddress']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state.text = p['state']?.toString() ?? '';
    _pincode.text = p['pincode']?.toString() ?? '';
    _languages.text = _listOrCsv(p['languages']);
    _services.text = _listOrCsv(p['services']);
    _bio.text = p['bio']?.toString() ?? '';
    _consultationFee.text = _numText(p['consultationFee']);
    _chatFee.text = _numText(p['chatFee']);
    _callFee.text = _numText(p['callFee']);
    _videoFee.text = _numText(p['videoFee']);
    _emergency = p['emergencyAvailable'] == true;

    _selectedModes
      ..clear()
      ..addAll(_asStringList(p['consultationModes']));
    if (_selectedModes.isEmpty && p['consultationType'] != null) {
      final t = p['consultationType'].toString().toUpperCase();
      if (t == 'BOTH') {
        _selectedModes.addAll(['CLINIC', 'VIDEO']);
      } else if (t.isNotEmpty) {
        _selectedModes.add(t);
      }
    }

    _slots.clear();
    final rawSlots = p['availabilitySlots'];
    if (rawSlots is List && rawSlots.isNotEmpty) {
      for (final item in rawSlots) {
        if (item is! Map) continue;
        final day = item['day']?.toString().toUpperCase() ?? 'MONDAY';
        final start = _parseTime(item['start']?.toString()) ?? const TimeOfDay(hour: 9, minute: 0);
        final end = _parseTime(item['end']?.toString()) ?? const TimeOfDay(hour: 17, minute: 0);
        _slots.add(_AvailabilitySlot(day: day, start: start, end: end));
      }
    } else if ((p['availableDays']?.toString() ?? '').isNotEmpty) {
      final days = p['availableDays'].toString().split(',').map((e) => e.trim().toUpperCase()).where((e) => e.isNotEmpty);
      final start = _parseTime(p['startTime']?.toString()) ?? const TimeOfDay(hour: 9, minute: 0);
      final end = _parseTime(p['endTime']?.toString()) ?? const TimeOfDay(hour: 17, minute: 0);
      for (final day in days) {
        _slots.add(_AvailabilitySlot(day: day, start: start, end: end));
      }
    }
  }

  String _listOrCsv(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).join(', ');
    }
    return value?.toString() ?? '';
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString().toUpperCase()).where((e) => e.isNotEmpty).toList();
    }
    if (value == null) return [];
    return value
        .toString()
        .split(',')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String _numText(dynamic value) {
    if (value == null) return '';
    if (value is num) {
      return value == value.roundToDouble() ? value.toInt().toString() : value.toString();
    }
    return value.toString();
  }

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parts = raw.trim().split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String? _docUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '$_baseUrl$path';
  }

  bool _isImage(String? path) {
    final lower = (path ?? '').toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  Future<void> _saveProfile() async {
    setState(() => _error = null);
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Saving…',
        doneLabel: 'Saved',
        action: () async {
          setState(() => _saving = true);
          final body = <String, dynamic>{
            'fullName': _fullName.text.trim(),
            'specialization': _specialization.text.trim(),
            'qualification': _qualification.text.trim(),
            'medicalRegNumber': _medicalReg.text.trim(),
            'experienceYears': int.tryParse(_experience.text.trim()),
            'hospitalName': _hospital.text.trim(),
            'clinicAddress': _clinicAddress.text.trim(),
            'city': _city.text.trim(),
            'state': _state.text.trim(),
            'pincode': _pincode.text.trim(),
            'languages': _languages.text.trim(),
            'services': _services.text.trim(),
            'bio': _bio.text.trim(),
            'consultationFee': double.tryParse(_consultationFee.text.trim()),
            'chatFee': double.tryParse(_chatFee.text.trim()),
            'callFee': double.tryParse(_callFee.text.trim()),
            'videoFee': double.tryParse(_videoFee.text.trim()),
            'consultationModes': _selectedModes.toList(),
            'emergencyAvailable': _emergency,
            'availabilitySlots': _slots
                .map((s) => {
                      'day': s.day,
                      'start': _formatTime(s.start),
                      'end': _formatTime(s.end),
                    })
                .toList(),
          };
          final res = await _svc.updateProfile(body);
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Failed to save profile');
          }
          if (res['profile'] is Map) {
            _applyProfile(Map<String, dynamic>.from(res['profile'] as Map));
          }
        },
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Submitting…',
        doneLabel: 'Submitted',
        action: () async {
          final saveRes = await _svc.updateProfile({
            'fullName': _fullName.text.trim(),
            'specialization': _specialization.text.trim(),
            'qualification': _qualification.text.trim(),
            'medicalRegNumber': _medicalReg.text.trim(),
            'experienceYears': int.tryParse(_experience.text.trim()),
            'hospitalName': _hospital.text.trim(),
            'clinicAddress': _clinicAddress.text.trim(),
            'city': _city.text.trim(),
            'state': _state.text.trim(),
            'pincode': _pincode.text.trim(),
            'languages': _languages.text.trim(),
            'services': _services.text.trim(),
            'bio': _bio.text.trim(),
            'consultationFee': double.tryParse(_consultationFee.text.trim()),
            'chatFee': double.tryParse(_chatFee.text.trim()),
            'callFee': double.tryParse(_callFee.text.trim()),
            'videoFee': double.tryParse(_videoFee.text.trim()),
            'consultationModes': _selectedModes.toList(),
            'emergencyAvailable': _emergency,
            'availabilitySlots': _slots
                .map((s) => {
                      'day': s.day,
                      'start': _formatTime(s.start),
                      'end': _formatTime(s.end),
                    })
                .toList(),
          });
          if (saveRes['success'] == true && saveRes['profile'] is Map) {
            _applyProfile(Map<String, dynamic>.from(saveRes['profile'] as Map));
          }
          if (_profile['canSubmitForVerification'] != true) {
            throw Exception('Complete all mandatory fields and required documents before submitting');
          }
          final res = await _svc.submitVerification();
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Submit failed');
          }
          await _load();
        },
      );
      if (!mounted) return;
      await showVerificationSubmittedSheet(context);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<File?> _pickDocument({required bool imagesOnly}) async {
    if (imagesOnly) {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return null;
      return File(picked.path);
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: false,
    );
    if (result == null || result.files.isEmpty || result.files.single.path == null) return null;
    return File(result.files.single.path!);
  }

  Future<void> _uploadDoc(String type, {bool imagesOnly = false}) async {
    final file = await _pickDocument(imagesOnly: imagesOnly);
    if (file == null) return;

    final name = file.path.toLowerCase();
    final ext = name.contains('.') ? name.substring(name.lastIndexOf('.')) : '';
    if (!_allowedExt.contains(ext)) {
      setState(() => _error = 'Only JPG, PNG, or PDF files are allowed');
      return;
    }
    final size = await file.length();
    if (size > _maxUploadBytes) {
      setState(() => _error = 'File must be 5 MB or smaller');
      return;
    }

    if (!mounted) return;

    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Uploading…',
        doneLabel: 'Uploaded',
        action: () async {
          setState(() {
            _uploadingType = type;
            _uploadProgress = 0;
            _error = null;
          });
          final res = await _svc.uploadDocument(
            type: type,
            file: file,
            onProgress: (p) {
              if (mounted) setState(() => _uploadProgress = p);
            },
          );
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Upload failed');
          }
          await _load();
        },
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _uploadingType = null;
          _uploadProgress = 0;
        });
      }
    }
  }

  Future<void> _deleteDoc(String type) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove document?'),
        content: const Text('This will remove the uploaded file from your profile.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirm != true) return;
    final res = await _svc.deleteDocument(type);
    if (!mounted) return;
    if (res['success'] == true) {
      await _load();
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Delete failed');
    }
  }

  Future<void> _preview(String? path) async {
    final url = _docUrl(path);
    if (url == null) return;
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document preview')),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  String _statusLabel(String? status) {
    switch ((status ?? '').toUpperCase()) {
      case 'REGISTERED':
      case 'PROFILE_INCOMPLETE':
        return 'Profile Incomplete';
      case 'READY_FOR_VERIFICATION':
        return 'Ready for Verification';
      case 'PENDING_ADMIN_APPROVAL':
        return 'Pending Admin Approval';
      case 'CHANGES_REQUESTED':
        return 'Changes Requested';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'SUSPENDED':
        return 'Suspended';
      default:
        return status ?? 'Profile Incomplete';
    }
  }

  Widget _statusHeader() {
    final pct = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toDouble()
        : double.tryParse('${_profile['profileCompletionPct']}') ?? 0;
    final status = _profile['doctorProfileStatus']?.toString() ?? 'PROFILE_INCOMPLETE';
    final statusLabel = (_profile['doctorProfileStatusLabel'] ?? _statusLabel(status)).toString();
    final missing = ModuleTheme.toList(_profile['missingItems']).map((e) => e.toString()).toList();
    final canSubmit = _profile['canSubmitForVerification'] == true;
    final guidance = _profile['nextStepGuidance']?.toString() ?? '';
    final rejection = _profile['rejectionReason']?.toString();
    final changes = _profile['changesRequestedNote']?.toString();
    final hasPending = _profile['hasPendingReverification'] == true;
    final draft = _profile['pendingDraft'];
    final draftStatus = draft is Map ? draft['status']?.toString() : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileCompletionCard(
          percent: pct,
          statusLabel: statusLabel,
          hint: ProfileCompletionCard.hintFromMissing(missing, guidance: guidance),
          actionLabel: '',
          onAction: () {},
          showActionButton: false,
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPending) ...[
                Text(
                  draftStatus == 'PENDING_REVIEW'
                      ? 'Your edits are pending admin approval. Approved live data is unchanged.'
                      : 'You have unpublished profile changes. Submit them for re-verification when ready.',
                  style: const TextStyle(color: Color(0xFFB45309), fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
              if (rejection != null && rejection.isNotEmpty)
                Text('Rejection reason: $rejection', style: const TextStyle(color: Colors.red, fontSize: 12)),
              if (changes != null && changes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text('Changes requested: $changes', style: const TextStyle(color: Color(0xFFB45309), fontSize: 12)),
              ],
              if (missing.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text('Missing required items:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: missing
                      .map((m) => Chip(
                            label: Text(m, style: const TextStyle(fontSize: 12)),
                            backgroundColor: const Color(0xFFFFF7ED),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: (_submitting || !canSubmit) ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  status == 'APPROVED'
                      ? 'Submit Changes for Re-verification'
                      : (canSubmit ? 'Submit for Verification' : 'Complete required items to submit'),
                ),
        ),
      ],
    );
  }

  Widget _documentTile({
    required String title,
    required String type,
    required String? path,
    required bool requiredDoc,
    bool imagesOnly = false,
  }) {
    final uploaded = path != null && path.trim().isNotEmpty && !path.startsWith('mobile');
    final uploading = _uploadingType == type;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$title${requiredDoc ? ' *' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Icon(
                uploaded ? Icons.check_circle : Icons.radio_button_unchecked,
                color: uploaded ? const Color(0xFF22C55E) : ModuleTheme.textGray,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            uploaded ? 'Uploaded' : 'JPG, PNG, or PDF · max 5 MB',
            style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
          ),
          if (uploaded && _isImage(path)) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _docUrl(path)!,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 80,
                  child: Center(child: Text('Preview unavailable')),
                ),
              ),
            ),
          ],
          if (uploading) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _uploadProgress <= 0 ? null : _uploadProgress),
            const SizedBox(height: 4),
            Text('Uploading ${(_uploadProgress * 100).round()}%'),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: uploading ? null : () => _uploadDoc(type, imagesOnly: imagesOnly),
                icon: Icon(uploaded ? Icons.swap_horiz : Icons.upload_file),
                label: Text(uploaded ? 'Replace' : 'Upload'),
              ),
              if (uploaded)
                OutlinedButton.icon(
                  onPressed: uploading ? null : () => _preview(path),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview'),
                ),
              if (uploaded)
                OutlinedButton.icon(
                  onPressed: uploading ? null : () => _deleteDoc(type),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _availabilitySection() {
    return _section('Availability', [
      ..._slots.asMap().entries.map((entry) {
        final i = entry.key;
        final slot = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Day', border: OutlineInputBorder()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: slot.day,
                          isExpanded: true,
                          items: _days
                              .map((d) => DropdownMenuItem(value: d, child: Text(d.substring(0, 3))))
                              .toList(),
                          onChanged: (v) => setState(() => slot.day = v ?? slot.day),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _slots.removeAt(i)),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: context, initialTime: slot.start);
                        if (picked != null) setState(() => slot.start = picked);
                      },
                      child: Text('Start ${_formatTime(slot.start)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: context, initialTime: slot.end);
                        if (picked != null) setState(() => slot.end = picked);
                      },
                      child: Text('End ${_formatTime(slot.end)}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      OutlinedButton.icon(
        onPressed: () => setState(() {
          _slots.add(_AvailabilitySlot(
            day: 'MONDAY',
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 17, minute: 0),
          ));
        }),
        icon: const Icon(Icons.add),
        label: const Text('Add time slot'),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Emergency available'),
        value: _emergency,
        onChanged: (v) => setState(() => _emergency = v),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Complete Doctor Profile'),
        actions: [
          TextButton(
            onPressed: (_loading || _saving) ? null : _saveProfile,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                _statusHeader(),
                _section('Professional Information', [
                  _field(_fullName, 'Full name'),
                  _field(_specialization, 'Specialization'),
                  _field(_qualification, 'Qualification'),
                  _field(_medicalReg, 'Medical registration number'),
                  _field(_experience, 'Years of experience', keyboardType: TextInputType.number),
                ]),
                _section('Clinic / Hospital Information', [
                  _field(_hospital, 'Hospital / clinic name'),
                  _field(_clinicAddress, 'Clinic address', maxLines: 2),
                  _field(_city, 'City'),
                  _field(_state, 'State'),
                  _field(_pincode, 'Pincode', keyboardType: TextInputType.number),
                ]),
                _section('Consultation Modes', [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _modes.map((m) {
                      final selected = _selectedModes.contains(m.$1);
                      return FilterChip(
                        label: Text(m.$2),
                        selected: selected,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _selectedModes.add(m.$1);
                          } else {
                            _selectedModes.remove(m.$1);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ]),
                _availabilitySection(),
                _section('Languages', [
                  _field(_languages, 'Languages', hint: 'e.g. English, Hindi, Kannada'),
                ]),
                _section('Services', [
                  _field(_services, 'Services offered', hint: 'e.g. General consultation, Follow-up', maxLines: 2),
                ]),
                _section('Fees', [
                  _field(_consultationFee, 'Consultation fee (₹)', keyboardType: TextInputType.number),
                  _field(_chatFee, 'Chat fee (₹)', keyboardType: TextInputType.number),
                  _field(_callFee, 'Call fee (₹)', keyboardType: TextInputType.number),
                  _field(_videoFee, 'Video fee (₹)', keyboardType: TextInputType.number),
                ]),
                _section('Bio', [
                  _field(_bio, 'About you', maxLines: 4, hint: 'Short professional bio for patients'),
                ]),
                _section('Documents', [
                  _documentTile(
                    title: 'Profile Photo',
                    type: 'PROFILE_PHOTO',
                    path: _profile['profilePhotoPath']?.toString(),
                    requiredDoc: true,
                    imagesOnly: true,
                  ),
                  _documentTile(
                    title: 'Government ID',
                    type: 'GOVERNMENT_ID',
                    path: (_profile['idProofPath'] ?? _profile['identityDocumentPath'])?.toString(),
                    requiredDoc: true,
                  ),
                  _documentTile(
                    title: 'Medical Registration Certificate',
                    type: 'MEDICAL_REGISTRATION',
                    path: _profile['degreeCertificatePath']?.toString(),
                    requiredDoc: true,
                  ),
                  _documentTile(
                    title: 'Medical License',
                    type: 'MEDICAL_LICENSE',
                    path: _profile['medicalLicensePath']?.toString(),
                    requiredDoc: true,
                  ),
                  _documentTile(
                    title: 'Additional Certificates',
                    type: 'ADDITIONAL_CERTIFICATE',
                    path: _profile['additionalCertificatePath']?.toString(),
                    requiredDoc: false,
                  ),
                ]),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ],
            ),
    );
  }
}
