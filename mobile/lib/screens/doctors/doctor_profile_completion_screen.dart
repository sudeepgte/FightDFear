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
import '../../widgets/bank_details_form.dart';
import '../../widgets/dynamic_location_hierarchy_picker.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';
import 'doctor_dashboard_screen.dart';
import 'doctor_pending_approval_screen.dart';

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
  final _accountHolder = TextEditingController();
  final _accountNumber = TextEditingController();
  final _confirmAccountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();
  final _branchName = TextEditingController();
  String _accountType = 'Savings';
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
    _accountHolder.dispose();
    _accountNumber.dispose();
    _confirmAccountNumber.dispose();
    _ifsc.dispose();
    _bankName.dispose();
    _branchName.dispose();
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
    BankDetailsSection.populateFromProfile(
      profile: p,
      accountHolderController: _accountHolder,
      accountNumberController: _accountNumber,
      confirmAccountNumberController: _confirmAccountNumber,
      ifscController: _ifsc,
      bankNameController: _bankName,
      branchNameController: _branchName,
      upiController: _upi,
      setAccountType: (t) => setState(() => _accountType = t),
    );

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
        ...BankDetailsSection.buildPayload(
          accountHolder: _accountHolder.text,
          accountNumber: _accountNumber.text,
          ifsc: _ifsc.text,
          bankName: _bankName.text,
          branch: _branchName.text,
          accountType: _accountType,
          upiId: _upi.text,
        ),
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

    final bankErr = BankDetailsSection.validateBankDetails(
      accountHolderController: _accountHolder,
      accountNumberController: _accountNumber,
      confirmAccountNumberController: _confirmAccountNumber,
      ifscController: _ifsc,
      bankNameController: _bankName,
      branchNameController: _branchName,
      upiController: _upi,
    );
    if (bankErr != null) return '8. $bankErr';
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
    if (_clinicAddress.text.trim().isEmpty) return '2.2 Full address is required';
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
    final status = (_profile['doctorProfileStatus'] ?? '').toString().toUpperCase();
    final verificationStatus = (_profile['verificationStatus'] ?? '').toString().toUpperCase();
    final isApproved = status == 'APPROVED' || verificationStatus == 'VERIFIED';
    if (isApproved) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
      );
      return;
    }
    if (status == 'PENDING_ADMIN_APPROVAL') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DoctorPendingApprovalScreen(initialProfile: _profile),
        ),
      );
      return;
    }
    final onFinished = widget.onFinished;
    if (onFinished != null) {
      onFinished(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
      );
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
        _leave();
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

  List<String> _clinicPhotoPaths() {
    final raw = _profile['clinicPhotos'];
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    }
    if (raw == null) return const [];
    return raw
        .toString()
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _mergeDocumentState(Map<String, dynamic> res, {String? type, dynamic path}) {
    final profile = res['profile'] is Map ? Map<String, dynamic>.from(res['profile'] as Map) : null;
    const keys = [
      'profilePhotoPath',
      'idProofPath',
      'identityDocumentPath',
      'degreeCertificatePath',
      'medicalLicensePath',
      'additionalCertificatePath',
      'clinicPhotos',
      'profileCompletionPct',
      'missingItems',
      'canSubmitForVerification',
      'doctorProfileStatus',
      'doctorProfileStatusLabel',
      'nextStepGuidance',
    ];
    setState(() {
      if (profile != null) {
        for (final key in keys) {
          if (profile.containsKey(key)) {
            _profile[key] = profile[key];
          }
        }
      } else {
        if (res.containsKey('profileCompletionPct')) {
          _profile['profileCompletionPct'] = res['profileCompletionPct'];
        }
        if (res.containsKey('missingItems')) {
          _profile['missingItems'] = res['missingItems'];
        }
        if (res.containsKey('canSubmitForVerification')) {
          _profile['canSubmitForVerification'] = res['canSubmitForVerification'];
        }
        if (res.containsKey('doctorProfileStatus')) {
          _profile['doctorProfileStatus'] = res['doctorProfileStatus'];
        }
      }
      if (type != null) {
        final keepClinicList = type == 'CLINIC_PHOTO'
            && path != null
            && profile != null
            && profile.containsKey('clinicPhotos');
        if (!keepClinicList) {
          _applyLocalDocPath(type, path);
        }
      }
    });
  }

  void _applyLocalDocPath(String type, dynamic path) {
    switch (type) {
      case 'PROFILE_PHOTO':
        _profile['profilePhotoPath'] = path;
        break;
      case 'GOVERNMENT_ID':
        _profile['idProofPath'] = path;
        _profile['identityDocumentPath'] = path;
        break;
      case 'MEDICAL_REGISTRATION':
        _profile['degreeCertificatePath'] = path;
        break;
      case 'MEDICAL_LICENSE':
        _profile['medicalLicensePath'] = path;
        break;
      case 'ADDITIONAL_CERTIFICATE':
        _profile['additionalCertificatePath'] = path;
        break;
      case 'CLINIC_PHOTO':
        _profile['clinicPhotos'] = path;
        break;
    }
  }

  Future<bool> _uploadFileForType(String type, File file) async {
    final name = file.path.toLowerCase();
    final ext = name.contains('.') ? name.substring(name.lastIndexOf('.')) : '';
    if (!_allowedExt.contains(ext)) {
      throw Exception('Only JPG, PNG, or PDF files are allowed');
    }
    final size = await file.length();
    if (size > _maxUploadBytes) {
      throw Exception('File must be 5 MB or smaller');
    }
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
    if (mounted) {
      _mergeDocumentState(res, type: type, path: res['path']);
    }
    return true;
  }

  Future<void> _uploadDoc(String type, {bool imagesOnly = false}) async {
    final file = await _pickDocument(imagesOnly: imagesOnly);
    if (file == null) return;
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
          await _uploadFileForType(type, file);
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

  Future<void> _uploadClinicPhotos() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return;
    final files = result.files
        .where((f) => f.path != null && f.path!.trim().isNotEmpty)
        .map((f) => File(f.path!))
        .toList();
    if (files.isEmpty) return;
    if (!mounted) return;

    try {
      await ActionFeedback.run(
        context,
        loadingLabel: files.length == 1 ? 'Uploading…' : 'Uploading ${files.length} photos…',
        doneLabel: 'Uploaded',
        action: () async {
          setState(() {
            _uploadingType = 'CLINIC_PHOTO';
            _uploadProgress = 0;
            _error = null;
          });
          for (final file in files) {
            await _uploadFileForType('CLINIC_PHOTO', file);
          }
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
      _mergeDocumentState(res, type: type, path: null);
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Delete failed');
    }
  }

  Future<void> _preview(String? path) async {
    final url = _docUrl(path);
    if (url == null || !mounted) return;
    final isImage = _isImage(path);
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.82,
              maxWidth: 520,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Document preview',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: isImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InteractiveViewer(
                              child: Image.network(
                                url,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => const Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Text('Preview unavailable'),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.picture_as_pdf, size: 64, color: Color(0xFFDC2626)),
                              const SizedBox(height: 12),
                              Text(
                                path!.split(RegExp(r'[\\/]')).last,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () async {
                                  final uri = Uri.parse(url);
                                  try {
                                    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                    if (!ok) {
                                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                                    }
                                  } catch (_) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                },
                                icon: const Icon(Icons.open_in_new),
                                label: const Text('Open document'),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  static String _helperForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('name')) return 'Enter your full name as it appears on your official documents.';
    if (l.contains('reg') || l.contains('license')) return 'Enter your official registration/license number.';
    if (l.contains('experience')) return 'Enter your total years of professional clinical experience (0-50).';
    if (l.contains('hospital') || l.contains('clinic name')) return 'Enter primary hospital, clinic or centre name.';
    if (l.contains('address')) return 'Enter street address, building or suite.';
    if (l.contains('city')) return 'Enter or select your city or locality.';
    if (l.contains('state')) return 'Select your State or Union Territory.';
    if (l.contains('pincode') || l.contains('zip')) return 'Enter your 6-digit postal PIN code.';
    if (l.contains('fee') || l.contains('price') || l.contains('rate')) return 'Enter consultation/service fee in INR (₹).';
    if (l.contains('bio') || l.contains('about')) return 'Short professional bio for patients.';
    if (l.contains('map')) return 'Paste a Google Maps link or use the pin button below.';
    return 'Enter $label.';
  }

  Widget _field(
    TextEditingController controller,
    String number,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    String? helper,
    String? errorText,
    bool required = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final resolvedHelper = helper ?? _helperForLabel(label);
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
          helperText: resolvedHelper,
          helperMaxLines: 2,
          errorText: errorText,
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
    String? helper,
    String? errorText,
  }) {
    final items = [...options];
    if (value != null && value.isNotEmpty && !items.contains(value)) {
      items.insert(items.length - (items.contains('Other') ? 1 : 0), value);
    }
    final resolvedHelper = helper ?? 'Select $label from the list.';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value != null && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          helperText: resolvedHelper,
          helperMaxLines: 2,
          errorText: errorText,
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
            style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
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

  Widget _profilePhotoCard() {
    final photoPath = _profile['profilePhotoPath']?.toString();
    final imgUrl = _docUrl(photoPath);
    final initial = _fullName.text.trim().isNotEmpty ? _fullName.text.trim()[0].toUpperCase() : 'D';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: ModuleTheme.primary.withValues(alpha: 0.1),
            backgroundImage: (imgUrl != null && imgUrl.isNotEmpty) ? NetworkImage(imgUrl) : null,
            child: (imgUrl == null || imgUrl.isEmpty)
                ? Text(initial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ModuleTheme.primary))
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1.0 Profile Photo',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Upload a clear headshot photo (JPG or PNG up to 5MB)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: ModuleTheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => _uploadDoc('PROFILE_PHOTO', imagesOnly: true),
                      icon: const Icon(Icons.camera_alt_outlined, size: 14),
                      label: Text(photoPath != null ? 'Change Photo' : 'Upload Photo', style: const TextStyle(fontSize: 12)),
                    ),
                    if (photoPath != null) ...[
                      const SizedBox(width: 8),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _deleteDoc('PROFILE_PHOTO'),
                        child: const Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusHeader() {
    final pctInt = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toInt()
        : (int.tryParse('${_profile['profileCompletionPct']}') ?? _calculateClientProgress());
    final rejection = _profile['rejectionReason']?.toString();
    final changes = _profile['changesRequestedNote']?.toString();
    final hasPending = _profile['hasPendingReverification'] == true;
    final draft = _profile['pendingDraft'];
    final draftStatus = draft is Map ? draft['status']?.toString() : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.assignment_turned_in_outlined, color: ModuleTheme.primary, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Profile Completion',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pctInt >= 100 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pctInt%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: pctInt >= 100 ? const Color(0xFF166534) : const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (pctInt / 100.0).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                pctInt >= 100 ? const Color(0xFF10B981) : ModuleTheme.primary,
              ),
            ),
          ),
          if (hasPending) ...[
            const SizedBox(height: 10),
            Text(
              draftStatus == 'PENDING_REVIEW'
                  ? 'Your edits are pending admin approval. Approved live data is unchanged.'
                  : 'You have unpublished profile changes. Submit them for re-verification when ready.',
              style: const TextStyle(color: Color(0xFFB45309), fontSize: 12),
            ),
          ],
          if (rejection != null && rejection.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Rejection reason: $rejection', style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
          if (changes != null && changes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Changes requested: $changes', style: const TextStyle(color: Color(0xFFB45309), fontSize: 12, fontWeight: FontWeight.w600)),
          ],

          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _showReviewProfileBottomSheet,
            icon: const Icon(Icons.assignment_ind_outlined, size: 18),
            label: const Text('Review Profile Details'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              side: const BorderSide(color: ModuleTheme.primary, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              foregroundColor: ModuleTheme.primary,
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  bool _isChecklistItemMissing(_ChecklistItemDef def, List<String> missingBackend) {
    if (missingBackend.isNotEmpty) {
      return missingBackend.any((m) => m.contains(def.code) || m.contains(def.matchKey));
    }
    switch (def.code) {
      case '1.0':
        final photo = _profile['profilePhotoPath']?.toString();
        return photo == null || photo.trim().isEmpty;
      case '1.2':
        return _resolvedSpecialization.isEmpty;
      case '1.3':
        return _resolvedQualification.isEmpty;
      case '1.4':
        final reg = _medicalReg.text.trim();
        return reg.isEmpty || reg.length < 3 || reg.length > 60;
      case '1.5':
        final exp = int.tryParse(_experience.text.trim());
        return exp == null || exp < 0 || exp > 50;
      case '2.1':
        return _hospital.text.trim().isEmpty;
      case '2.2':
        return _clinicAddress.text.trim().isEmpty || _city.text.trim().isEmpty;
      case '2.4':
        return _resolvedState.isEmpty;
      case '2.5':
        return !RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim());
      case '3.':
        return _selectedModes.isEmpty;
      case '4.':
        return _slots.isEmpty;
      case '5.':
        return _languages.isEmpty;
      case '7.1':
        final fee = double.tryParse(_consultationFee.text.trim());
        return fee == null || fee < 0;
      default:
        return false;
    }
  }

  int _calculateClientProgress() {
    int filled = 0;
    for (final def in _allChecklistDefs) {
      if (!_isChecklistItemMissing(def, [])) filled++;
    }
    return ((100.0 * filled) / _allChecklistDefs.length).round();
  }

  void _showReviewProfileBottomSheet() {
    final spec = _resolvedSpecialization;
    final qual = _resolvedQualification;
    final reg = _medicalReg.text.trim();
    final exp = _experience.text.trim();
    final hosp = _hospital.text.trim();
    final addr = _clinicAddress.text.trim();
    final city = _city.text.trim();
    final state = _resolvedState;
    final pin = _pincode.text.trim();
    final mapLoc = _mapLocation.text.trim();
    final fee = _consultationFee.text.trim();
    final chatFee = _chatFee.text.trim();
    final callFee = _callFee.text.trim();
    final videoFee = _videoFee.text.trim();
    final bioText = _bio.text.trim();
    final upiId = _upi.text.trim();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_ind_outlined, color: ModuleTheme.primary, size: 24),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Review Doctor Profile', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A))),
                          Text('Verify all entered details before submission', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _reviewSectionCard('1. Professional Information', [
                        _reviewRow('Full Name', _fullName.text.isEmpty ? '—' : _fullName.text),
                        _reviewRow('Specialization', spec.isEmpty ? '—' : spec),
                        _reviewRow('Qualification', qual.isEmpty ? '—' : qual),
                        _reviewRow('Experience', exp.isEmpty ? '—' : '$exp years'),
                        _reviewRow('Medical Reg No.', reg.isEmpty ? '—' : reg),
                      ]),
                      _reviewSectionCard('2. Hospital / Clinic Information', [
                        _reviewRow('Hospital / Clinic', hosp.isEmpty ? '—' : hosp),
                        _reviewRow('Clinic Address', addr.isEmpty ? '—' : addr),
                        _reviewRow('City / State', [city, state, pin].where((e) => e.isNotEmpty).join(', ').isEmpty ? '—' : [city, state, pin].where((e) => e.isNotEmpty).join(', ')),
                        _reviewRow('Google Maps', mapLoc.isEmpty ? '—' : mapLoc),
                      ]),
                      _reviewSectionCard('3 & 4. Modes & Working Availability', [
                        _reviewRow('Consultation Modes', _selectedModes.isEmpty ? '—' : _selectedModes.map(DoctorCatalog.modeLabel).join(', ')),
                        _reviewRow('Slot Duration', '$_slotDuration minutes'),
                        _reviewRow('Buffer Between Patients', '$_bufferMinutes minutes'),
                        _reviewRow('Emergency Available', _emergency ? 'Yes' : 'No'),
                        _reviewRow('Auto-Confirm Bookings', _autoConfirm ? 'Yes' : 'No'),
                      ]),
                      _reviewSectionCard('5 & 6. Languages & Services Offered', [
                        _reviewRow('Languages', _languages.isEmpty ? '—' : _languages.join(', ')),
                        _reviewRow('Services Offered', _servicesOffered.isEmpty ? '—' : _servicesOffered.join(', ')),
                      ]),
                      _reviewSectionCard('7 & 8. Fees & Bio', [
                        _reviewRow('Consultation Fee', fee.isEmpty ? '—' : '₹$fee'),
                        _reviewRow('Chat Fee', chatFee.isEmpty ? '—' : '₹$chatFee'),
                        _reviewRow('Call Fee', callFee.isEmpty ? '—' : '₹$callFee'),
                        _reviewRow('Video Fee', videoFee.isEmpty ? '—' : '₹$videoFee'),
                        _reviewRow('Bio', bioText.isEmpty ? '—' : bioText),
                      ]),
                      _reviewSectionCard('9 & 10. Bank Details & Documents', [
                        _reviewRow('UPI ID', upiId.isEmpty ? '—' : upiId),
                        _reviewRow('Bank Account', _accountNumber.text.isEmpty ? '—' : '${_bankName.text} (${_accountNumber.text})'),
                        _reviewRow('Profile Photo', _profile['profilePhotoPath'] != null ? 'Uploaded' : 'Not uploaded'),
                      ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Looks Good', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _reviewSectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: ModuleTheme.primary)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          ),
        ],
      ),
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
                label: Text(uploaded ? 'Replace' : 'Browse'),
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

  Widget _clinicPhotosTile() {
    final photos = _clinicPhotoPaths();
    final uploading = _uploadingType == 'CLINIC_PHOTO';
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
          const Row(
            children: [
              Expanded(
                child: Text(
                  '10.6 Clinic photos (waiting room / signage)',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            photos.isEmpty
                ? 'Browse and select multiple JPG or PNG images · max 5 MB each'
                : '${photos.length} photo${photos.length == 1 ? '' : 's'} uploaded',
            style: const TextStyle(color: ModuleTheme.textGray, fontSize: 12),
          ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: photos.map((path) {
                return GestureDetector(
                  onTap: () => _preview(path),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _docUrl(path) ?? '',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 72,
                        height: 72,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(Icons.image_outlined),
                      ),
                    ),
                  ),
                );
              }).toList(),
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
                onPressed: uploading ? null : _uploadClinicPhotos,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(photos.isEmpty ? 'Browse photos' : 'Add more photos'),
              ),
              if (photos.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: uploading ? null : () => _preview(photos.last),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview'),
                ),
              if (photos.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: uploading ? null : () => _deleteDoc('CLINIC_PHOTO'),
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
      const SizedBox(height: 12),
      const Text('4.7 Buffer between patients (minutes)', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
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
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 16, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Buffer time provides a required gap between consecutive patient appointments for sanitizing, note-taking, or case review.',
                style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.35),
              ),
            ),
          ],
        ),
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
                  _profilePhotoCard(),
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                  ),
                ]),
                _section('2', 'Clinic / Hospital Information', [
                  _field(_hospital, '2.1', 'Hospital / clinic name', required: true),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      '2.2 Full address *',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF334155)),
                    ),
                  ),
                  DynamicLocationHierarchyPicker(
                    api: context.read<AuthState>().api,
                    initialCountry: 'India',
                    initialState: _state,
                    initialCity: _city.text.isNotEmpty ? _city.text : null,
                    initialFullAddress: _clinicAddress.text.isNotEmpty ? _clinicAddress.text : null,
                    isRequired: true,
                    onLocationChanged: ({required country, required state, required district, String? city, String? fullAddress}) {
                      setState(() {
                        _state = state;
                        if (fullAddress != null) {
                          _clinicAddress.text = fullAddress.trim();
                        }
                        if (city != null && city.isNotEmpty) {
                          _city.text = city.trim();
                        } else if (district.isNotEmpty) {
                          _city.text = district.trim();
                        }
                      });
                    },
                  ),
                  _field(
                    _pincode,
                    '2.4',
                    'Pincode',
                    required: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    _mapLocation,
                    '2.5',
                    'Google Maps location',
                    hint: 'Paste Google Maps link (optional)',
                  ),
                  const SizedBox(height: 8),
                  ProfileLocationPicker(
                    lat: _clinicLat,
                    lng: _clinicLng,
                    mapLinkController: _mapLocation,
                    pinLabel: '2.6 Pin clinic on map',
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
                  MultiSelectDropdownField(
                    label: '5.1 Languages you consult in',
                    placeholder: 'Select languages you consult in...',
                    availableOptions: DoctorCatalog.languages,
                    selectedValues: _languages,
                    onSelectionChanged: (updated) => setState(() {
                      _languages
                        ..clear()
                        ..addAll(updated);
                    }),
                    hintText: 'Select all languages you are comfortable conducting consultations in.',
                    isRequired: true,
                  ),
                ]),
                _section('6', 'Services offered', [
                  MultiSelectDropdownField(
                    label: '6.1 Services patients can book',
                    placeholder: 'Select services offered...',
                    availableOptions: DoctorCatalog.services,
                    selectedValues: _servicesOffered,
                    onSelectionChanged: (updated) => setState(() {
                      _servicesOffered
                        ..clear()
                        ..addAll(updated);
                    }),
                    hintText: 'Select all medical consultation and clinical services patients can book with you.',
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
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BankDetailsSection(
                          sectionNumber: '9',
                          title: 'Payout & Bank Details',
                          accountHolderController: _accountHolder,
                          accountNumberController: _accountNumber,
                          confirmAccountNumberController: _confirmAccountNumber,
                          ifscController: _ifsc,
                          bankNameController: _bankName,
                          branchNameController: _branchName,
                          upiController: _upi,
                          accountType: _accountType,
                          onAccountTypeChanged: (t) => setState(() => _accountType = t),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Earnings stay in your wallet until you request a withdraw from the dashboard.',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                _section('10', 'Documents (optional)', [
                  const Text(
                    'Uploads are optional for now. You can add them later from this screen.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  _documentTile(
                    title: '10.1 Government ID',
                    type: 'GOVERNMENT_ID',
                    path: (_profile['idProofPath'] ?? _profile['identityDocumentPath'])?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.2 Medical Registration Certificate',
                    type: 'MEDICAL_REGISTRATION',
                    path: _profile['degreeCertificatePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.3 Medical License',
                    type: 'MEDICAL_LICENSE',
                    path: _profile['medicalLicensePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _documentTile(
                    title: '10.4 Extra certificates',
                    type: 'ADDITIONAL_CERTIFICATE',
                    path: _profile['additionalCertificatePath']?.toString(),
                    requiredDoc: false,
                  ),
                  _clinicPhotosTile(),
                ]),
                _section('11', 'Review & Submit', [
                  Text(
                    'Completion: ${(_profile['profileCompletionPct'] is num) ? (_profile['profileCompletionPct'] as num).round() : (int.tryParse('${_profile['profileCompletionPct']}') ?? 0)}%',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _profile['doctorProfileStatusLabel']?.toString() ??
                        _profile['doctorProfileStatus']?.toString() ??
                        'Incomplete',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  if ((_profile['nextStepGuidance']?.toString() ?? '').isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _profile['nextStepGuidance'].toString(),
                      style: const TextStyle(color: Color(0xFF334155), fontSize: 13, height: 1.4),
                    ),
                  ],
                  if (_profile['missingItems'] is List && (_profile['missingItems'] as List).isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Text('Still missing:', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    ...((_profile['missingItems'] as List).take(8).map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFFF43F5E))),
                                Expanded(child: Text('$item', style: const TextStyle(fontSize: 13))),
                              ],
                            ),
                          ),
                        )),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _showReviewProfileBottomSheet,
                    icon: const Icon(Icons.assignment_ind_outlined, size: 18),
                    label: const Text('Review Profile Details'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(46),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      side: const BorderSide(color: ModuleTheme.primary, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: ModuleTheme.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save your profile first. When all required sections are complete, submit for admin verification.',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (_saving || _submitting) ? null : _saveProfile,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
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
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(
                                (_profile['doctorProfileStatus']?.toString() == 'APPROVED')
                                    ? 'Submit Changes'
                                    : ((_profile['canSubmitForVerification'] == true) ? 'Submit Verification' : 'Submit (Incomplete)'),
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

class _ChecklistItemDef {
  final String code;
  final String label;
  final String matchKey;

  const _ChecklistItemDef({
    required this.code,
    required this.label,
    required this.matchKey,
  });
}

const _allChecklistDefs = <_ChecklistItemDef>[
  _ChecklistItemDef(code: '1.0', label: 'Profile photo', matchKey: 'Profile photo'),
  _ChecklistItemDef(code: '1.2', label: 'Specialization', matchKey: 'Specialization'),
  _ChecklistItemDef(code: '1.3', label: 'Qualification', matchKey: 'Qualification'),
  _ChecklistItemDef(code: '1.4', label: 'Medical registration number (3–60 alphanumeric characters)', matchKey: 'Medical registration number'),
  _ChecklistItemDef(code: '1.5', label: 'Years of experience (0–50)', matchKey: 'Years of experience'),
  _ChecklistItemDef(code: '2.1', label: 'Hospital / clinic name', matchKey: 'Hospital / clinic name'),
  _ChecklistItemDef(code: '2.2', label: 'Clinic address and city', matchKey: 'Clinic address'),
  _ChecklistItemDef(code: '2.4', label: 'State', matchKey: 'State'),
  _ChecklistItemDef(code: '2.5', label: 'Pincode', matchKey: 'Pincode'),
  _ChecklistItemDef(code: '3.', label: 'Consultation mode', matchKey: 'Consultation mode'),
  _ChecklistItemDef(code: '4.', label: 'Working availability', matchKey: 'Working availability'),
  _ChecklistItemDef(code: '5.', label: 'Languages', matchKey: 'Languages'),
  _ChecklistItemDef(code: '7.1', label: 'Consultation fee', matchKey: 'Consultation fee'),
];

class MultiSelectDropdownField extends StatelessWidget {
  const MultiSelectDropdownField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.availableOptions,
    required this.selectedValues,
    required this.onSelectionChanged,
    this.hintText,
    this.isRequired = false,
  });

  final String label;
  final String placeholder;
  final List<String> availableOptions;
  final Set<String> selectedValues;
  final ValueChanged<Set<String>> onSelectionChanged;
  final String? hintText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF334155)),
            ),
            if (isRequired)
              const Text(' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _openMultiSelectSheet(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: selectedValues.isEmpty ? const Color(0xFFCBD5E1) : const Color(0xFF94A3B8)),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: selectedValues.isEmpty
                      ? Text(
                          placeholder,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: selectedValues.map((val) {
                            return Chip(
                              label: Text(
                                val,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ModuleTheme.primary),
                              ),
                              backgroundColor: const Color(0xFFF0F7FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Color(0xFFBAE6FD)),
                              ),
                              deleteIcon: const Icon(Icons.close, size: 14, color: ModuleTheme.primary),
                              onDeleted: () {
                                final updated = Set<String>.from(selectedValues)..remove(val);
                                onSelectionChanged(updated);
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ),
        if (hintText != null && hintText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            hintText!,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ],
    );
  }

  void _openMultiSelectSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MultiSelectSheet(
        title: label,
        availableOptions: availableOptions,
        initialSelected: selectedValues,
        onSave: onSelectionChanged,
      ),
    );
  }
}

class _MultiSelectSheet extends StatefulWidget {
  const _MultiSelectSheet({
    required this.title,
    required this.availableOptions,
    required this.initialSelected,
    required this.onSave,
  });

  final String title;
  final List<String> availableOptions;
  final Set<String> initialSelected;
  final ValueChanged<Set<String>> onSave;

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late final Set<String> _tempSelected;
  final _searchCtrl = TextEditingController();
  final _customCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tempSelected = Set<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _customCtrl.dispose();
    super.dispose();
  }

  void _addCustom() {
    final text = _customCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _tempSelected.add(text);
        _customCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allOptions = <String>{...widget.availableOptions, ..._tempSelected}.toList();
    final filtered = _query.isEmpty
        ? allOptions
        : allOptions.where((opt) => opt.toLowerCase().contains(_query.toLowerCase())).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onSave(_tempSelected);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() {
                          _searchCtrl.clear();
                          _query = '';
                        }),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customCtrl,
                    decoration: InputDecoration(
                      hintText: 'Other (type custom)...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onSubmitted: (_) => _addCustom(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModuleTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('+ Add'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (ctx, idx) {
                final option = filtered[idx];
                final isSelected = _tempSelected.contains(option);
                return CheckboxListTile(
                  title: Text(option, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400)),
                  value: isSelected,
                  activeColor: ModuleTheme.primary,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _tempSelected.add(option);
                      } else {
                        _tempSelected.remove(option);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

