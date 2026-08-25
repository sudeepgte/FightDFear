import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/martial_arts_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';

class MartialArtsCentreProfileCompletionScreen extends StatefulWidget {
  const MartialArtsCentreProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentreProfileCompletionScreen> createState() =>
      _MartialArtsCentreProfileCompletionScreenState();
}

class _MartialArtsCentreProfileCompletionScreenState
    extends State<MartialArtsCentreProfileCompletionScreen> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _yearStarted = TextEditingController();
  final _area = TextEditingController();
  final _city = TextEditingController();
  final _stateOther = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  final _about = TextEditingController();
  final _howWeTeach = TextEditingController();
  final _startingFee = TextEditingController();
  final _upi = TextEditingController();
  final _bank = TextEditingController();
  final _batchName = TextEditingController();
  final _batchInstructor = TextEditingController();
  final _batchFee = TextEditingController(text: '0');
  final _batchAdmission = TextEditingController(text: '0');
  final _batchCapacity = TextEditingController(text: '20');

  String? _centreType;
  String? _designation;
  String? _affiliation;
  String? _state;
  String? _batchStyle;
  String _batchMode = 'Offline';
  String _trialType = 'None';
  int _duration = 60;
  int _buffer = 0;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;
  TimeOfDay _batchStart = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _batchEnd = const TimeOfDay(hour: 7, minute: 0);

  final Set<String> _styles = {};
  final Set<String> _audience = {};
  final Set<String> _ageGroups = {};
  final Set<String> _facilities = {};
  final Set<String> _offers = {};
  final Set<String> _days = {};
  final Set<String> _batchDays = {};
  final Set<String> _blockedDates = {};
  bool _womenOnly = false;
  bool _femaleInstructor = false;
  bool _trialAvailable = false;
  double? _lat;
  double? _lng;

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingCert = false;
  bool _uploadingGallery = false;
  String? _error;
  Map<String, dynamic> _profile = {};
  int _batchCount = 0;

  CentreAuthService get _svc => CentreAuthService(context.read<AuthState>().api);
  String get _baseUrl => context.read<AuthState>().api.baseUrl;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _name, _contact, _phone, _whatsapp, _yearStarted, _area, _city, _stateOther,
      _pincode, _mapLocation, _about, _howWeTeach, _startingFee, _upi, _bank,
      _batchName, _batchInstructor, _batchFee, _batchAdmission, _batchCapacity,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _svc.profile();
    if (!mounted) return;
    if (res['success'] == true) {
      _applyProfile(Map<String, dynamic>.from(res));
      final meta = await _svc.dashboardMeta();
      if (mounted && meta['success'] == true) {
        final batches = meta['batches'];
        if (batches is List) {
          _batchCount = batches.where((b) => b is Map && b['isBatch'] != false).length;
        }
      }
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
    _name.text = p['name']?.toString() ?? '';
    _contact.text = p['contactPerson']?.toString() ?? '';
    _phone.text = p['phoneNumber']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _yearStarted.text = p['yearStarted']?.toString() ?? '';
    _centreType = (p['centreType']?.toString().isNotEmpty == true) ? p['centreType'].toString() : null;
    _designation = (p['designation']?.toString().isNotEmpty == true) ? p['designation'].toString() : null;
    _affiliation = (p['affiliation']?.toString().isNotEmpty == true) ? p['affiliation'].toString() : null;
    _area.text = p['area']?.toString().isNotEmpty == true
        ? p['area'].toString()
        : (p['location']?.toString() ?? '');
    _city.text = p['city']?.toString() ?? '';
    _state = _pickOrOther(p['state']?.toString() ?? '', MartialArtsCatalog.indianStates, _stateOther);
    if ((_state ?? '').isEmpty) _state = null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _mapLocation.text = p['googleMapLocation']?.toString() ?? '';
    _lat = p['centreLat'] is num ? (p['centreLat'] as num).toDouble() : double.tryParse('${p['centreLat'] ?? ''}');
    _lng = p['centreLng'] is num ? (p['centreLng'] as num).toDouble() : double.tryParse('${p['centreLng'] ?? ''}');
    _styles
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['stylesTaught']));
    _audience
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['audience']));
    _ageGroups
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['ageGroups']));
    _facilities
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['facilities']));
    _offers
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['whatWeOffer']));
    _days
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['availableDays']).map((e) => e.toUpperCase()));
    _blockedDates
      ..clear()
      ..addAll(MartialArtsCatalog.splitCsv(p['blockedDates']));
    _womenOnly = p['womenOnlyBatches'] == true;
    _femaleInstructor = p['femaleInstructor'] == true;
    _trialAvailable = p['trialAvailable'] == true;
    _openTime = MartialArtsCatalog.parseTime(p['openTime']?.toString());
    _closeTime = MartialArtsCatalog.parseTime(p['closeTime']?.toString());
    _breakStart = MartialArtsCatalog.parseTime(p['breakStart']?.toString());
    _breakEnd = MartialArtsCatalog.parseTime(p['breakEnd']?.toString());
    _about.text = p['about']?.toString() ?? '';
    _howWeTeach.text = p['howWeTeach']?.toString() ?? '';
    _startingFee.text = p['startingFee']?.toString() ?? '';
    _upi.text = p['upiId']?.toString() ?? '';
    _bank.text = p['bankDetails']?.toString() ?? '';
    if (_batchName.text.isEmpty && _name.text.isNotEmpty) {
      _batchName.text = '${_name.text.trim()} — Beginner';
    }
    if (_batchInstructor.text.isEmpty) {
      _batchInstructor.text = _contact.text.isNotEmpty ? _contact.text : _name.text;
    }
    _batchStyle ??= MartialArtsCatalog.styles.first;
    if (_batchDays.isEmpty) _batchDays.addAll(_days);
  }

  String get _resolvedState =>
      _state == 'Other' ? _stateOther.text.trim() : (_state ?? '').trim();

  Map<String, dynamic> _profileBody() => {
        'name': _name.text.trim(),
        'centreType': _centreType,
        'contactPerson': _contact.text.trim(),
        'designation': _designation,
        'phoneNumber': _phone.text.trim(),
        'whatsappNumber': _whatsapp.text.trim(),
        'yearStarted': int.tryParse(_yearStarted.text.trim()),
        'affiliation': _affiliation,
        'location': _area.text.trim(),
        'area': _area.text.trim(),
        'city': _city.text.trim(),
        'state': _resolvedState,
        'pincode': _pincode.text.trim(),
        'googleMapLocation': _mapLocation.text.trim(),
        if (_lat != null) 'centreLat': _lat,
        if (_lng != null) 'centreLng': _lng,
        'stylesTaught': _styles.toList(),
        'audience': _audience.toList(),
        'womenOnlyBatches': _womenOnly,
        'femaleInstructor': _femaleInstructor,
        'ageGroups': _ageGroups.toList(),
        'facilities': _facilities.toList(),
        'availableDays': _days.toList(),
        'openTime': _openTime == null ? '' : MartialArtsCatalog.formatTime(_openTime!),
        'closeTime': _closeTime == null ? '' : MartialArtsCatalog.formatTime(_closeTime!),
        'breakStart': _breakStart == null ? '' : MartialArtsCatalog.formatTime(_breakStart!),
        'breakEnd': _breakEnd == null ? '' : MartialArtsCatalog.formatTime(_breakEnd!),
        'blockedDates': _blockedDates.join(','),
        'about': _about.text.trim(),
        'howWeTeach': _howWeTeach.text.trim(),
        'whatWeOffer': _offers.toList(),
        'startingFee': double.tryParse(_startingFee.text.trim()),
        'trialAvailable': _trialAvailable,
        'upiId': _upi.text.trim(),
        'bankDetails': _bank.text.trim(),
      };

  String? _validate({bool forSubmit = false}) {
    if (_name.text.trim().isEmpty) return '1.1 Centre name is required';
    if ((_centreType ?? '').isEmpty) return '1.2 Centre type is required';
    if (_contact.text.trim().isEmpty) return '1.3 Owner / manager is required';
    if (!RegExp(r'^\d{10}$').hasMatch(_phone.text.trim())) return '1.5 Official phone must be 10 digits';
    if (_area.text.trim().isEmpty) return '2.1 Hall / landmark is required';
    if (_city.text.trim().isEmpty) return '2.3 City is required';
    if (_resolvedState.isEmpty) return '2.4 State is required';
    if (!RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim())) return '2.5 Pincode must be 6 digits';
    if (_styles.isEmpty) return '3.1 Select at least one style';
    if (_audience.isEmpty) return '4.1 Select who can join';
    if (_days.isEmpty) return '6.1 Select open days';
    if (_openTime == null) return '6.2 Open time is required';
    if (_closeTime == null) return '6.3 Close time is required';
    if (_about.text.trim().isEmpty) return '7.1 About the centre is required';
    if (_howWeTeach.text.trim().isEmpty) return '7.2 How we teach is required';
    if (_offers.isEmpty) return '7.3 Select what you offer';
    if (forSubmit && _batchCount == 0) return '8. Add at least one program / batch';
    return null;
  }

  Future<void> _saveProfile() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
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
          final res = await _svc.updateProfile(_profileBody());
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Failed to save profile');
          }
          _applyProfile(Map<String, dynamic>.from(res));
        },
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _createFirstBatch() async {
    if (_batchName.text.trim().isEmpty || _batchInstructor.text.trim().isEmpty) {
      setState(() => _error = '8.1 Program name and 8.4 instructor are required');
      return;
    }
    if (_batchDays.isEmpty) {
      setState(() => _error = '8.3 Select batch days');
      return;
    }
    final endM = _batchEnd.hour * 60 + _batchEnd.minute;
    final startM = _batchStart.hour * 60 + _batchStart.minute;
    if (endM <= startM) {
      setState(() => _error = '8. Batch end time must be after start time');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final res = await _svc.saveBatch({
      'name': _batchName.text.trim(),
      'style': _batchStyle ?? MartialArtsCatalog.styles.first,
      'instructor': _batchInstructor.text.trim(),
      'availableDays': _batchDays.join(','),
      'timeSlot':
          '${MartialArtsCatalog.formatTime(_batchStart)}-${MartialArtsCatalog.formatTime(_batchEnd)}',
      'fee': double.tryParse(_batchFee.text.trim()) ?? 0,
      'admissionFee': double.tryParse(_batchAdmission.text.trim()) ?? 0,
      'capacity': (int.tryParse(_batchCapacity.text.trim()) ?? 20).clamp(5, 100),
      'batchType': _batchMode,
      'status': 'Active',
      'trialType': _trialType,
      'durationMinutes': _duration,
      'bufferMinutes': _buffer,
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (res['success'] == true) {
      setState(() => _batchCount = 1);
      await _load();
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Could not create program');
    }
  }

  Future<void> _submit() async {
    final err = _validate(forSubmit: true);
    if (err != null) {
      setState(() => _error = err);
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
          if (saveRes['success'] == true) _applyProfile(Map<String, dynamic>.from(saveRes));
          if (_profile['canSubmitForVerification'] != true) {
            throw Exception('Complete all mandatory fields before submitting');
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
      if (!mounted) return;
      if (widget.onFinished != null) {
        widget.onFinished!(context);
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickClock(void Function(TimeOfDay t) apply, TimeOfDay? current) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? const TimeOfDay(hour: 6, minute: 0),
    );
    if (picked != null) setState(() => apply(picked));
  }

  void _skip() => ProfileCompletionActions.skip(context, widget.onFinished);

  Future<void> _addBlockedDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d == null) return;
    final key =
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    setState(() => _blockedDates.add(key));
  }

  Future<void> _uploadFile({required String kind}) async {
    File? file;
    if (kind == 'cert') {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
      );
      if (picked == null || picked.files.isEmpty || picked.files.first.path == null) return;
      file = File(picked.files.first.path!);
    } else {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;
      file = File(picked.path);
    }
    setState(() {
      if (kind == 'photo') _uploadingPhoto = true;
      if (kind == 'cert') _uploadingCert = true;
      if (kind == 'gallery') _uploadingGallery = true;
    });
    final field = kind == 'cert'
        ? 'certificate'
        : kind == 'gallery'
            ? 'galleryPhotos'
            : 'profileImage';
    final multipart = await http.MultipartFile.fromPath(field, file.path);
    final res = await _svc.updateSettings(
      fields: {
        'name': _name.text.trim().isEmpty ? (_profile['name']?.toString() ?? 'Centre') : _name.text.trim(),
        'email': _profile['email']?.toString() ?? '',
        if (_phone.text.trim().isNotEmpty) 'phoneNumber': _phone.text.trim(),
      },
      files: [multipart],
    );
    if (!mounted) return;
    setState(() {
      _uploadingPhoto = false;
      _uploadingCert = false;
      _uploadingGallery = false;
    });
    if (res['success'] == true) {
      await _load();
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Upload failed');
    }
  }

  Future<void> _preview(String? path) async {
    if (path == null || path.isEmpty) return;
    final url = path.startsWith('http') ? path : '$_baseUrl$path';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toDouble()
        : double.tryParse('${_profile['profileCompletionPct']}') ?? 0;
    final status = _profile['centreProfileStatus']?.toString() ?? 'PROFILE_INCOMPLETE';
    final statusLabel = (_profile['centreProfileStatusLabel'] ?? status).toString();
    final missing = (_profile['missingItems'] is List)
        ? (_profile['missingItems'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final canSubmit = _profile['canSubmitForVerification'] == true;
    final guidance = _profile['nextStepGuidance']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreProfileCompletionScreen.navy,
        title: const Text('Complete Centre Profile', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700)),
        actions: ProfileCompletionActions.appBar(
          onSkip: _loading ? null : _skip,
          onSave: (_loading || _saving) ? null : _saveProfile,
          saving: _saving,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: statusLabel,
                  hint: ProfileCompletionCard.hintFromMissing(missing, guidance: guidance),
                  actionLabel: '',
                  onAction: () {},
                  showActionButton: false,
                  trailing: missing.isEmpty
                      ? null
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: missing
                              .map((m) => Chip(
                                    label: Text(m, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: const Color(0xFFFFF7ED),
                                  ))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: MartialArtsCentreProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(canSubmit ? 'Submit for Verification' : 'Complete required items to submit'),
                ),
                const SizedBox(height: 16),
                _section('1', 'Centre identity', [
                  _field(_name, '1.1', 'Centre name', required: true),
                  _dropdown(
                    number: '1.2',
                    label: 'Centre type',
                    value: _centreType,
                    options: MartialArtsCatalog.centreTypes,
                    required: true,
                    onChanged: (v) => setState(() => _centreType = v),
                  ),
                  _field(_contact, '1.3', 'Owner / manager', required: true),
                  _dropdown(
                    number: '1.4',
                    label: 'Designation',
                    value: _designation,
                    options: MartialArtsCatalog.designations,
                    onChanged: (v) => setState(() => _designation = v),
                  ),
                  _field(
                    _phone,
                    '1.5',
                    'Official phone',
                    required: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    _whatsapp,
                    '1.6',
                    'WhatsApp',
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    _yearStarted,
                    '1.7',
                    'Year started',
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _dropdown(
                    number: '1.8',
                    label: 'Affiliation',
                    value: _affiliation,
                    options: MartialArtsCatalog.affiliations,
                    onChanged: (v) => setState(() => _affiliation = v),
                  ),
                ]),
                _section('2', 'Location', [
                  _field(_area, '2.1', 'Hall / landmark', required: true),
                  _field(_city, '2.3', 'City', required: true),
                  _dropdown(
                    number: '2.4',
                    label: 'State',
                    value: _state,
                    options: MartialArtsCatalog.indianStates,
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
                  _field(_mapLocation, '2.6', 'Google Maps location', hint: 'Paste Maps link (optional)'),
                  const SizedBox(height: 8),
                  ProfileLocationPicker(
                    lat: _lat,
                    lng: _lng,
                    mapLinkController: _mapLocation,
                    pinLabel: '2.7 Pin centre on map',
                    onPinned: (lat, lng) => setState(() {
                      _lat = lat;
                      _lng = lng;
                    }),
                    onError: (msg) => setState(() => _error = msg),
                  ),
                ]),
                _section('3', 'Styles taught', [
                  const Text('3.1 Martial arts styles *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(MartialArtsCatalog.styles, _styles),
                ]),
                _section('4', 'Who can join', [
                  const Text('4.1 Audience *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(MartialArtsCatalog.audiences, _audience),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.2 Women-only batches'),
                    value: _womenOnly,
                    onChanged: (v) => setState(() => _womenOnly = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.3 Female instructor available'),
                    value: _femaleInstructor,
                    onChanged: (v) => setState(() => _femaleInstructor = v),
                  ),
                  const Text('4.4 Age groups', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(MartialArtsCatalog.ageGroups, _ageGroups),
                ]),
                _section('5', 'Facilities', [
                  const Text('5.1 Amenities', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(MartialArtsCatalog.facilities, _facilities),
                ]),
                _section('6', 'Hours & calendar', [
                  const Text('6.1 Open days *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: MartialArtsCatalog.days.map((d) {
                      final on = _days.contains(d);
                      return FilterChip(
                        label: Text(d.substring(0, 3)),
                        selected: on,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _days.add(d);
                          } else {
                            _days.remove(d);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  _timeTile('6.2 Open time *', _openTime, (t) => _openTime = t),
                  _timeTile('6.3 Close time *', _closeTime, (t) => _closeTime = t),
                  _timeTile('6.4 Break start', _breakStart, (t) => _breakStart = t),
                  _timeTile('6.5 Break end', _breakEnd, (t) => _breakEnd = t),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addBlockedDate,
                    icon: const Icon(Icons.event_busy),
                    label: const Text('6.6 Add leave / blocked date'),
                  ),
                  if (_blockedDates.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: _blockedDates
                          .map((d) => InputChip(
                                label: Text(d),
                                onDeleted: () => setState(() => _blockedDates.remove(d)),
                              ))
                          .toList(),
                    ),
                ]),
                _section('7', 'About the centre', [
                  _field(_about, '7.1', 'About', required: true, maxLines: 4),
                  _field(_howWeTeach, '7.2', 'How we teach', required: true, maxLines: 3),
                  const Text('7.3 What we offer *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(MartialArtsCatalog.offers, _offers),
                ]),
                _section('8', 'First program / batch', [
                  Text(
                    _batchCount > 0
                        ? 'You have $_batchCount program(s). Add more from the Batches tab.'
                        : 'Add at least one martial arts program to submit.',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  if (_batchCount == 0) ...[
                    const SizedBox(height: 10),
                    _field(_batchName, '8.1', 'Program name', required: true),
                    _dropdown(
                      number: '8.2',
                      label: 'Style',
                      value: _batchStyle,
                      options: MartialArtsCatalog.styles,
                      required: true,
                      onChanged: (v) => setState(() => _batchStyle = v),
                    ),
                    const Text('8.3 Batch days *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    Wrap(
                      spacing: 8,
                      children: MartialArtsCatalog.days.map((d) {
                        final on = _batchDays.contains(d);
                        return FilterChip(
                          label: Text(d.substring(0, 3)),
                          selected: on,
                          onSelected: (v) => setState(() {
                            if (v) {
                              _batchDays.add(d);
                            } else {
                              _batchDays.remove(d);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                    _timeTile('8.4 Start time *', _batchStart, (t) => _batchStart = t),
                    _timeTile('8.5 End time *', _batchEnd, (t) => _batchEnd = t),
                    _dropdown(
                      number: '8.6',
                      label: 'Duration (minutes)',
                      value: '$_duration',
                      options: MartialArtsCatalog.durations.map((e) => '$e').toList(),
                      onChanged: (v) => setState(() => _duration = int.tryParse(v ?? '60') ?? 60),
                    ),
                    _dropdown(
                      number: '8.7',
                      label: 'Buffer (minutes)',
                      value: '$_buffer',
                      options: const ['0', '5', '10', '15'],
                      onChanged: (v) => setState(() => _buffer = int.tryParse(v ?? '0') ?? 0),
                    ),
                    _field(_batchInstructor, '8.8', 'Instructor', required: true),
                    _field(_batchCapacity, '8.9', 'Capacity', required: true, keyboardType: TextInputType.number),
                    _field(_batchFee, '8.11', 'Monthly fee (₹)', required: true, keyboardType: TextInputType.number),
                    _field(_batchAdmission, '8.12', 'Admission fee (₹)', keyboardType: TextInputType.number),
                    _dropdown(
                      number: '8.13',
                      label: 'Trial',
                      value: _trialType,
                      options: MartialArtsCatalog.trialTypes,
                      onChanged: (v) => setState(() {
                        _trialType = v ?? 'None';
                        _trialAvailable = _trialType != 'None';
                      }),
                    ),
                    _dropdown(
                      number: '8.14',
                      label: 'Mode',
                      value: _batchMode,
                      options: MartialArtsCatalog.modes,
                      required: true,
                      onChanged: (v) => setState(() => _batchMode = v ?? 'Offline'),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: _saving ? null : _createFirstBatch,
                      child: const Text('Create first program'),
                    ),
                  ],
                ]),
                _section('9', 'Payout', [
                  _field(_upi, '9.1', 'UPI ID', hint: 'name@upi'),
                  _field(_bank, '9.2', 'Bank details', hint: 'Account name, number, IFSC', maxLines: 2),
                  _field(_startingFee, '9.3', 'Starting monthly fee (₹)', keyboardType: TextInputType.number),
                  const Text(
                    'Earnings stay in your wallet until you request a withdraw from Finance.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                ]),
                _section('10', 'Documents (optional)', [
                  const Text(
                    'Uploads are optional. You can add them later.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  _uploadTile(
                    '10.1 Profile photo',
                    _profile['profilePhoto']?.toString(),
                    _uploadingPhoto,
                    () => _uploadFile(kind: 'photo'),
                  ),
                  _uploadTile(
                    '10.2 Trainer / affiliation certificate',
                    _profile['certificatePath']?.toString(),
                    _uploadingCert,
                    () => _uploadFile(kind: 'cert'),
                  ),
                ]),
                _section('11', 'Centre photos (optional)', [
                  const Text(
                    'Hall, mats, and entrance photos help members choose you.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  _uploadTile(
                    '11.1 Gallery photo',
                    (_profile['galleryPhotos'] is List && (_profile['galleryPhotos'] as List).isNotEmpty)
                        ? (_profile['galleryPhotos'] as List).last.toString()
                        : null,
                    _uploadingGallery,
                    () => _uploadFile(kind: 'gallery'),
                  ),
                ]),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white) : const Text('Save Profile'),
                ),
              ],
            ),
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
    if (value != null && value.isNotEmpty && !items.contains(value)) items.add(value);
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

  Widget _chips(List<String> options, Set<String> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final on = selected.contains(item);
        return FilterChip(
          label: Text(item),
          selected: on,
          onSelected: (v) => setState(() {
            if (v) {
              selected.add(item);
            } else {
              selected.remove(item);
            }
          }),
        );
      }).toList(),
    );
  }

  Widget _timeTile(String label, TimeOfDay? value, void Function(TimeOfDay t) onPicked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        subtitle: Text(value == null ? 'Tap to pick' : MartialArtsCatalog.formatTime(value)),
        trailing: const Icon(Icons.schedule),
        onTap: () => _pickClock(onPicked, value),
      ),
    );
  }

  Widget _uploadTile(String title, String? path, bool loading, VoidCallback onTap) {
    final uploaded = path != null && path.trim().isNotEmpty;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: loading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: ModuleTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(uploaded ? 'Uploaded' : 'JPG, PNG or PDF · optional'),
      trailing: uploaded
          ? IconButton(icon: const Icon(Icons.visibility_outlined), onPressed: () => _preview(path))
          : const Icon(Icons.chevron_right),
      onTap: loading ? null : onTap,
    );
  }
}
