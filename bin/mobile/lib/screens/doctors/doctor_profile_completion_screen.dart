import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../config/doctor_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';

class DoctorProfileCompletionScreen extends StatefulWidget {
  const DoctorProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

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
  final _specializationOther = TextEditingController();
  final _qualificationCustom = TextEditingController();
  final _medicalReg = TextEditingController();
  final _experience = TextEditingController();
  final _hospital = TextEditingController();
  final _clinicAddress = TextEditingController();
  final _city = TextEditingController();
  final _stateOther = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  final _bio = TextEditingController();
  final _consultationFee = TextEditingController();
  final _chatFee = TextEditingController();
  final _callFee = TextEditingController();
  final _videoFee = TextEditingController();

  String? _specialization;
  String? _state;
  final Set<String> _qualifications = {};
  final Set<String> _languages = {};
  final Set<String> _servicesOffered = {};

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _profile = {};
  final Set<String> _selectedModes = {};
  final List<_AvailabilitySlot> _slots = [];
  bool _emergency = false;
  bool _autoConfirm = false;
  int _slotDuration = 30;
  int _bufferMinutes = 0;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;
  final Set<String> _blockedDates = {};
  double? _clinicLat;
  double? _clinicLng;
  final _upi = TextEditingController();
  final _bank = TextEditingController();
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
    _specializationOther.dispose();
    _qualificationCustom.dispose();
    _medicalReg.dispose();
    _experience.dispose();
    _hospital.dispose();
    _clinicAddress.dispose();
    _city.dispose();
    _stateOther.dispose();
    _pincode.dispose();
    _mapLocation.dispose();
    _bio.dispose();
    _consultationFee.dispose();
    _chatFee.dispose();
    _callFee.dispose();
    _videoFee.dispose();
    _upi.dispose();
    _bank.dispose();
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

  String _pickOrOther(String raw, List<String> options, TextEditingController other) {
    final v = raw.trim();
    if (v.isEmpty) {
      other.clear();
      return '';
    }
    if (options.contains(v)) {
      other.clear();
      return v;
    }
    other.text = v;
    return 'Other';
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    _fullName.text = p['fullName']?.toString() ?? '';
    _specialization = _pickOrOther(p['specialization']?.toString() ?? '', DoctorCatalog.specializations, _specializationOther);
    if ((_specialization ?? '').isEmpty) _specialization = null;
    _qualifications
      ..clear()
      ..addAll(DoctorCatalog.splitCsv(p['qualification']).where((e) => e.isNotEmpty && e.toLowerCase() != 'other'));
    _medicalReg.text = p['medicalRegNumber']?.toString() ?? '';
    _experience.text = p['experienceYears']?.toString() ?? '';
    _hospital.text = p['hospitalName']?.toString() ?? '';
    _clinicAddress.text = p['clinicAddress']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state = _pickOrOther(p['state']?.toString() ?? '', DoctorCatalog.indianStates, _stateOther);
    if ((_state ?? '').isEmpty) _state = null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _mapLocation.text = p['googleMapLocation']?.toString() ?? '';
    _clinicLat = p['clinicLat'] is num ? (p['clinicLat'] as num).toDouble() : double.tryParse('${p['clinicLat'] ?? ''}');
    _clinicLng = p['clinicLng'] is num ? (p['clinicLng'] as num).toDouble() : double.tryParse('${p['clinicLng'] ?? ''}');
    _languages
      ..clear()
      ..addAll(DoctorCatalog.splitCsv(p['languages']));
    _servicesOffered
      ..clear()
      ..addAll(DoctorCatalog.splitCsv(p['services']));
    _bio.text = p['bio']?.toString() ?? '';
    _consultationFee.text = _numText(p['consultationFee']);
    _chatFee.text = _numText(p['chatFee']);
    _callFee.text = _numText(p['callFee']);
    _videoFee.text = _numText(p['videoFee']);
    _emergency = p['emergencyAvailable'] == true;
    _autoConfirm = p['autoConfirm'] == true;
    _slotDuration = p['slotDurationMinutes'] is num
        ? (p['slotDurationMinutes'] as num).toInt()
        : int.tryParse('${p['slotDurationMinutes']}') ?? 30;
    _bufferMinutes = p['bufferMinutes'] is num
        ? (p['bufferMinutes'] as num).toInt()
        : int.tryParse('${p['bufferMinutes']}') ?? 0;
    _breakStart = _parseTime(p['breakStart']?.toString());
    _breakEnd = _parseTime(p['breakEnd']?.toString());
    _blockedDates
      ..clear()
      ..addAll(DoctorCatalog.splitCsv(p['blockedDates']));
    _upi.text = p['upiId']?.toString() ?? '';
    _bank.text = p['bankDetails']?.toString() ?? '';

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
    if (_slots.isEmpty) {
      _slots.add(_AvailabilitySlot(
        day: 'MONDAY',
        start: const TimeOfDay(hour: 9, minute: 0),
        end: const TimeOfDay(hour: 17, minute: 0),
      ));
    }
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

  String get _resolvedSpecialization =>
      _specialization == 'Other' ? _specializationOther.text.trim() : (_specialization ?? '').trim();
  String get _resolvedQualification => _qualifications.join(', ');
  String get _resolvedState =>
      _state == 'Other' ? _stateOther.text.trim() : (_state ?? '').trim();

  Map<String, dynamic> _profileBody() => {
        'fullName': _fullName.text.trim(),
        'specialization': _resolvedSpecialization,
        'qualification': _resolvedQualification,
        'medicalRegNumber': _medicalReg.text.trim(),
        'experienceYears': int.tryParse(_experience.text.trim()),
        'hospitalName': _hospital.text.trim(),
        'clinicAddress': _clinicAddress.text.trim(),
        'city': _city.text.trim(),
        'state': _resolvedState,
        'pincode': _pincode.text.trim(),
        'googleMapLocation': _mapLocation.text.trim(),
        if (_clinicLat != null) 'clinicLat': _clinicLat,
        if (_clinicLng != null) 'clinicLng': _clinicLng,
        'languages': _languages.join(', '),
        'services': _servicesOffered.join(', '),
        'bio': _bio.text.trim(),
        'consultationFee': double.tryParse(_consultationFee.text.trim()),
        'chatFee': double.tryParse(_chatFee.text.trim()),
        'callFee': double.tryParse(_callFee.text.trim()),
        'videoFee': double.tryParse(_videoFee.text.trim()),
        'consultationModes': _selectedModes.toList(),
        'emergencyAvailable': _emergency,
        'autoConfirm': _autoConfirm,
        'slotDurationMinutes': _slotDuration,
        'bufferMinutes': _bufferMinutes,
        'breakStart': _breakStart == null ? '' : _formatTime(_breakStart!),
        'breakEnd': _breakEnd == null ? '' : _formatTime(_breakEnd!),
        'blockedDates': _blockedDates.join(','),
        'upiId': _upi.text.trim(),
        'bankDetails': _bank.text.trim(),
        'availabilitySlots': _slots
            .map((s) => {
                  'day': s.day,
                  'start': _formatTime(s.start),
                  'end': _formatTime(s.end),
                })
            .toList(),
      };

  String? _validate({bool forSubmit = false}) {
    if (_fullName.text.trim().isEmpty) return '1.1 Doctor name is required';

    final expStr = _experience.text.trim();
    if (expStr.isNotEmpty) {
      final exp = int.tryParse(expStr);
      if (exp == null || exp < 0 || exp > 50) return '1.5 Years of experience must be between 0 and 50';
    }

    final pin = _pincode.text.trim();
    if (pin.isNotEmpty && !RegExp(r'^\d{6}$').hasMatch(pin)) {
      return '2.5 Pincode must be exactly 6 digits';
    }

    for (final slot in _slots) {
      final start = slot.start.hour * 60 + slot.start.minute;
      final end = slot.end.hour * 60 + slot.end.minute;
      if (end <= start) return '4. Each slot end time must be after start time';
    }

    final feeStr = _consultationFee.text.trim();
    if (feeStr.isNotEmpty) {
      final fee = double.tryParse(feeStr);
      if (fee == null || fee < 0) return '7.1 Consultation fee cannot be negative';
    }
    final chatFeeStr = _chatFee.text.trim();
    if (chatFeeStr.isNotEmpty) {
      final cf = double.tryParse(chatFeeStr);
      if (cf == null || cf < 0) return '7.2 Chat fee cannot be negative';
    }
    final callFeeStr = _callFee.text.trim();
    if (callFeeStr.isNotEmpty) {
      final clf = double.tryParse(callFeeStr);
      if (clf == null || clf < 0) return '7.3 Call fee cannot be negative';
    }
    final videoFeeStr = _videoFee.text.trim();
    if (videoFeeStr.isNotEmpty) {
      final vf = double.tryParse(videoFeeStr);
      if (vf == null || vf < 0) return '7.4 Video fee cannot be negative';
    }

    if (!forSubmit) return null;

    // Strict completeness checks for submission
    if (_resolvedSpecialization.isEmpty) return '1.2 Specialization is required';
    if (_resolvedQualification.isEmpty) return '1.3 Qualification is required';
    if (_medicalReg.text.trim().isEmpty) return '1.4 Medical registration number is required';
    if (expStr.isEmpty) return '1.5 Years of experience is required';
    if (_hospital.text.trim().isEmpty) return '2.1 Hospital / clinic name is required';
    if (_clinicAddress.text.trim().isEmpty) return '2.2 Clinic address is required';
    if (_city.text.trim().isEmpty) return '2.3 City is required';
    if (_resolvedState.isEmpty) return '2.4 State is required';
    if (pin.isEmpty || !RegExp(r'^\d{6}$').hasMatch(pin)) return '2.5 Pincode must be exactly 6 digits';
    if (_selectedModes.isEmpty) return '3. Select at least one consultation mode';
    if (_slots.isEmpty) return '4. Add at least one availability slot';
    if (_languages.isEmpty) return '5. Select at least one language';

    final fee = double.tryParse(feeStr);
    if (fee == null || fee < 0) return '7.1 Consultation fee is required';

    if (_selectedModes.contains('VIDEO') &&
        double.tryParse(videoFeeStr) == null &&
        fee <= 0) {
      return '7.4 Video fee is required when Video mode is selected';
    }
    if (_selectedModes.contains('ONLINE') &&
        double.tryParse(chatFeeStr) == null &&
        fee <= 0) {
      return '7.2 Chat fee is required when Online/Chat mode is selected';
    }

    return null;
  }

  void _leave() {
    final onFinished = widget.onFinished;
    if (onFinished != null) {
      onFinished(context);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveProfile() async {
    final err = _validate(forSubmit: false);
    if (err != null) {
      setState(() => _error = err);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red),
        );
      }
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Saving…',
        doneLabel: 'Saved',
        action: () async {
          final body = _profileBody();
          final res = await _svc.updateProfile(body);
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Failed to save profile');
          }
          if (res['profile'] is Map) {
            _applyProfile(Map<String, dynamic>.from(res['profile'] as Map));
          }
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        setState(() => _error = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    final err = _validate(forSubmit: true);
    if (err != null) {
      setState(() => _error = err);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err), backgroundColor: Colors.red),
        );
      }
      return;
    }
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
          final saveRes = await _svc.updateProfile(_profileBody());
          if (saveRes['success'] != true) {
            throw Exception(saveRes['error']?.toString() ?? 'Failed to save profile before submission');
          }
          if (saveRes['profile'] is Map) {
            _applyProfile(Map<String, dynamic>.from(saveRes['profile'] as Map));
          }
          if (_profile['canSubmitForVerification'] != true) {
            final missingList = ModuleTheme.toList(_profile['missingItems']);
            final missingText = missingList.isNotEmpty ? ': ${missingList.join(", ")}' : '';
            throw Exception('Complete all mandatory fields before submitting$missingText');
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
      if (mounted) _leave();
    } catch (e) {
      if (mounted) {
        final msg = e.toString().replaceFirst('Exception: ', '');
        setState(() => _error = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
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

  Widget _section(String number, String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$number. $title', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String number,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    bool required = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          hintText: hint,
          counterText: maxLength != null ? '' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String number,
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    final items = [...options];
    if (value != null && value.isNotEmpty && !items.contains(value)) {
      items.insert(items.length - (items.contains('Other') ? 1 : 0), value);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value != null && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _addCustomQualification() {
    final value = _qualificationCustom.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _qualifications.add(value);
      _qualificationCustom.clear();
    });
  }

  Widget _qualificationPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1.3 Qualifications *',
            style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select every degree you hold. You can also type a custom qualification.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 8),
          _chipGroup(
            options: DoctorCatalog.qualifications,
            selected: _qualifications,
            onChanged: (v, on) => setState(() {
              if (on) {
                _qualifications.add(v);
              } else {
                _qualifications.remove(v);
              }
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qualificationCustom,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addCustomQualification(),
                  decoration: InputDecoration(
                    labelText: 'Add another degree',
                    hintText: 'e.g. MRCOG, Fellowship',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.tonal(
                onPressed: _addCustomQualification,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipGroup({
    required List<String> options,
    required Set<String> selected,
    required void Function(String value, bool on) onChanged,
  }) {
    final extras = selected.where((s) => !options.contains(s)).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...options,
        ...extras,
      ].map((item) {
        final on = selected.contains(item);
        return FilterChip(
          label: Text(item),
          selected: on,
          onSelected: (v) => onChanged(item, v),
        );
      }).toList(),
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
    return _section('4', 'Availability', [
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
                      decoration: const InputDecoration(labelText: '4.1 Day', border: OutlineInputBorder()),
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
                      child: Text('4.2 Start ${_formatTime(slot.start)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(context: context, initialTime: slot.end);
                        if (picked != null) setState(() => slot.end = picked);
                      },
                      child: Text('4.3 End ${_formatTime(slot.end)}'),
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
        title: const Text('4.4 Emergency / instant available'),
        value: _emergency,
        onChanged: (v) => setState(() => _emergency = v),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('4.5 Auto-confirm bookings'),
        subtitle: const Text('Off = you accept each request. On = confirmed instantly after pay.'),
        value: _autoConfirm,
        onChanged: (v) => setState(() => _autoConfirm = v),
      ),
      const SizedBox(height: 8),
      const Text('4.6 Consult length', style: TextStyle(fontWeight: FontWeight.w700)),
      Wrap(
        spacing: 8,
        children: [15, 20, 30, 45, 60].map((m) {
          return ChoiceChip(
            label: Text('$m min'),
            selected: _slotDuration == m,
            onSelected: (_) => setState(() => _slotDuration = m),
          );
        }).toList(),
      ),
      const SizedBox(height: 8),
      const Text('4.7 Buffer between patients', style: TextStyle(fontWeight: FontWeight.w700)),
      Wrap(
        spacing: 8,
        children: [0, 5, 10, 15].map((m) {
          return ChoiceChip(
            label: Text('$m min'),
            selected: _bufferMinutes == m,
            onSelected: (_) => setState(() => _bufferMinutes = m),
          );
        }).toList(),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _breakStart ?? const TimeOfDay(hour: 13, minute: 0),
                );
                if (picked != null) setState(() => _breakStart = picked);
              },
              child: Text('4.8 Break start ${_breakStart == null ? '—' : _formatTime(_breakStart!)}'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _breakEnd ?? const TimeOfDay(hour: 14, minute: 0),
                );
                if (picked != null) setState(() => _breakEnd = picked);
              },
              child: Text('End ${_breakEnd == null ? '—' : _formatTime(_breakEnd!)}'),
            ),
          ),
        ],
      ),
      TextButton(
        onPressed: () => setState(() {
          _breakStart = null;
          _breakEnd = null;
        }),
        child: const Text('Clear break'),
      ),
      const Text('4.9 Leave / blocked dates', style: TextStyle(fontWeight: FontWeight.w700)),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ..._blockedDates.map((d) => InputChip(
                label: Text(d),
                onDeleted: () => setState(() => _blockedDates.remove(d)),
              )),
          ActionChip(
            label: const Text('Add date'),
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: now.add(const Duration(days: 180)),
              );
              if (picked == null) return;
              final key =
                  '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              setState(() => _blockedDates.add(key));
            },
          ),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Complete Doctor Profile', maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: ProfileCompletionActions.appBar(
          onSkip: _loading ? null : _leave,
          onSave: (_loading || _saving) ? null : _saveProfile,
          saving: _saving,
        ),
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
                _section('1', 'Professional Information', [
                  _field(_fullName, '1.1', 'Doctor name', required: true),
                  _dropdown(
                    number: '1.2',
                    label: 'Specialization',
                    value: _specialization,
                    options: DoctorCatalog.specializations,
                    required: true,
                    onChanged: (v) => setState(() => _specialization = v),
                  ),
                  if (_specialization == 'Other')
                    _field(_specializationOther, '1.2', 'Enter specialization', required: true),
                  _qualificationPicker(),
                  _field(_medicalReg, '1.4', 'Medical registration number', required: true),
                  _field(
                    _experience,
                    '1.5',
                    'Years of experience',
                    required: true,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ]),
                _section('2', 'Clinic / Hospital Information', [
                  _field(_hospital, '2.1', 'Hospital / clinic name', required: true),
                  _field(_clinicAddress, '2.2', 'Clinic address', required: true, maxLines: 2),
                  _field(_city, '2.3', 'City', required: true),
                  _dropdown(
                    number: '2.4',
                    label: 'State',
                    value: _state,
                    options: DoctorCatalog.indianStates,
                    required: true,
                    onChanged: (v) => setState(() => _state = v),
                  ),
                  if (_state == 'Other') _field(_stateOther, '2.4', 'Enter state', required: true),
                  _field(
                    _pincode,
                    '2.5',
                    'Pincode',
                    required: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    _mapLocation,
                    '2.6',
                    'Google Maps location',
                    hint: 'Paste Google Maps link (optional)',
                  ),
                  const SizedBox(height: 8),
                  ProfileLocationPicker(
                    lat: _clinicLat,
                    lng: _clinicLng,
                    mapLinkController: _mapLocation,
                    pinLabel: '2.7 Pin clinic on map',
                    onPinned: (lat, lng) => setState(() {
                      _clinicLat = lat;
                      _clinicLng = lng;
                    }),
                    onError: (msg) => setState(() => _error = msg),
                  ),
                ]),
                _section('3', 'Consultation Modes', [
                  Text('3.1 Select the ways patients can consult you *',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 8),
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
                _section('5', 'Languages', [
                  Text('5.1 Languages you consult in *',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 8),
                  _chipGroup(
                    options: DoctorCatalog.languages,
                    selected: _languages,
                    onChanged: (v, on) => setState(() {
                      if (on) {
                        _languages.add(v);
                      } else {
                        _languages.remove(v);
                      }
                    }),
                  ),
                ]),
                _section('6', 'Services offered', [
                  Text('6.1 Select services patients can book',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 8),
                  _chipGroup(
                    options: DoctorCatalog.services,
                    selected: _servicesOffered,
                    onChanged: (v, on) => setState(() {
                      if (on) {
                        _servicesOffered.add(v);
                      } else {
                        _servicesOffered.remove(v);
                      }
                    }),
                  ),
                ]),
                _section('7', 'Fees', [
                  _field(
                    _consultationFee,
                    '7.1',
                    'Consultation fee (₹)',
                    required: true,
                    keyboardType: TextInputType.number,
                  ),
                  _field(
                    _chatFee,
                    '7.2',
                    'Chat fee (₹)${_selectedModes.contains('ONLINE') ? ' *' : ''}',
                    keyboardType: TextInputType.number,
                  ),
                  _field(_callFee, '7.3', 'Call fee (₹)', keyboardType: TextInputType.number),
                  _field(
                    _videoFee,
                    '7.4',
                    'Video fee (₹)${_selectedModes.contains('VIDEO') ? ' *' : ''}',
                    keyboardType: TextInputType.number,
                  ),
                ]),
                _section('8', 'About you', [
                  _field(_bio, '8.1', 'Bio', maxLines: 4, hint: 'Short professional bio for patients'),
                ]),
                _section('9', 'Payout', [
                  _field(_upi, '9.1', 'UPI ID', hint: 'name@upi'),
                  _field(_bank, '9.2', 'Bank details', hint: 'Account name, number, IFSC', maxLines: 2),
                  Text(
                    'Earnings stay in your wallet until you request a withdraw from the dashboard.',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ]),
                _section('10', 'Documents (optional)', [
                  const Text(
                    'Uploads are optional for now. You can add them later from this screen.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  _documentTile(
                    title: '10.1 Profile Photo',
                    type: 'PROFILE_PHOTO',
                    path: _profile['profilePhotoPath']?.toString(),
                    requiredDoc: false,
                    imagesOnly: true,
                  ),
                  _documentTile(
                    title: '10.2 Government ID',
                    type: 'GOVERNMENT_ID',
                    path: (_profile['idProofPath'] ?? _profile['identityDocumentPath'])?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.3 Medical Registration Certificate',
                    type: 'MEDICAL_REGISTRATION',
                    path: _profile['degreeCertificatePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.4 Medical License',
                    type: 'MEDICAL_LICENSE',
                    path: _profile['medicalLicensePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.5 Extra certificates',
                    type: 'ADDITIONAL_CERTIFICATE',
                    path: _profile['additionalCertificatePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.6 Clinic photos (waiting room / signage)',
                    type: 'CLINIC_PHOTO',
                    path: (_profile['clinicPhotos'] is List && (_profile['clinicPhotos'] as List).isNotEmpty)
                        ? (_profile['clinicPhotos'] as List).last.toString()
                        : _profile['clinicPhotos']?.toString(),
                    requiredDoc: false,
                    imagesOnly: true,
                  ),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (_saving || _submitting) ? null : _saveProfile,
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Profile'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: (_saving || _submitting || !(_profile['canSubmitForVerification'] == true)) ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                (_profile['doctorProfileStatus']?.toString() == 'APPROVED')
                                    ? 'Submit Changes'
                                    : ((_profile['canSubmitForVerification'] == true) ? 'Submit for Verification' : 'Submit (Incomplete)'),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
