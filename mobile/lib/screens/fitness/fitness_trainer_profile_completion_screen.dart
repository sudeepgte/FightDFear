import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/fitness_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/fitness_trainer_auth_service.dart';
import '../../widgets/bank_details_form.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_completion_helpers.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/registration_form_kit.dart';
import '../../widgets/ux_feedback.dart';
import 'fitness_trainer_dashboard_screen.dart';

class FitnessTrainerProfileCompletionScreen extends StatefulWidget {
  const FitnessTrainerProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<FitnessTrainerProfileCompletionScreen> createState() =>
      _FitnessTrainerProfileCompletionScreenState();
}

class _FitnessTrainerProfileCompletionScreenState
    extends State<FitnessTrainerProfileCompletionScreen> {
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _fieldKeys = {};

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _years = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _stateOther = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  final _bio = TextEditingController();
  final _upi = TextEditingController();
  final _bank = TextEditingController();
  final _accountHolder = TextEditingController();
  final _accountNumber = TextEditingController();
  final _confirmAccountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();
  final _branchName = TextEditingController();
  String _accountType = 'Savings';
  final _rate = TextEditingController(text: '300');
  final _credential = TextEditingController();

  String? _designation;
  String? _state;
  String? _sessionMode;
  int _duration = 60;
  int _buffer = 10;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;

  final Set<String> _categories = {};
  final Set<String> _audience = {};
  final Set<String> _facilities = {};
  final Set<String> _days = {};
  final Set<String> _blockedDates = {};
  bool _doorService = false;
  double? _lat;
  double? _lng;

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingGallery = false;
  bool _uploadingCert = false;
  String? _error;
  final Map<String, String> _errors = {};
  Map<String, dynamic> _profile = {};

  FitnessTrainerAuthService get _svc =>
      FitnessTrainerAuthService(context.read<AuthState>().api);

  GlobalKey _key(String id) => _fieldKeys.putIfAbsent(id, () => GlobalKey());

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final c in [
      _name, _phone, _whatsapp, _years, _address, _city, _stateOther,
      _pincode, _mapLocation, _bio, _upi, _bank, _accountHolder, _accountNumber,
      _confirmAccountNumber, _ifsc, _bankName, _branchName, _rate, _credential,
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
    _name.text = p['fullName']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _years.text = (p['experience'] ?? p['experienceYears'] ?? p['yearsExperience'])?.toString() ?? '';
    _credential.text = p['credentialNumber']?.toString() ?? '';
    _designation = (p['designation']?.toString().isNotEmpty == true) ? p['designation'].toString() : null;
    _address.text = p['address']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state = _pickOrOther(p['state']?.toString() ?? '', FitnessCatalog.indianStates, _stateOther);
    if ((_state ?? '').isEmpty) _state = null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');
    if (_lat != null && _lng != null) {
      _mapLocation.text = 'https://maps.google.com/?q=$_lat,$_lng';
    }
    _categories
      ..clear()
      ..addAll(FitnessCatalog.splitCsv(p['specializations'] ?? p['categoriesOffered']));
    _audience
      ..clear()
      ..addAll(FitnessCatalog.splitCsv(p['audience']));
    _facilities
      ..clear()
      ..addAll(FitnessCatalog.splitCsv(p['facilities']));
    _days
      ..clear()
      ..addAll(FitnessCatalog.splitCsv(p['openDays']));
    _blockedDates
      ..clear()
      ..addAll(FitnessCatalog.splitCsv(p['blockedDates']));
    _doorService = p['doorService'] == true;
    _openTime = FitnessCatalog.parseTime(p['openTime']?.toString());
    _closeTime = FitnessCatalog.parseTime(p['closeTime']?.toString());
    _breakStart = FitnessCatalog.parseTime(p['breakStart']?.toString());
    _breakEnd = FitnessCatalog.parseTime(p['breakEnd']?.toString());
    _bio.text = p['bio']?.toString() ?? '';
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
    if (p['typicalPrice'] != null || p['sessionFees'] != null) {
      _rate.text = '${p['typicalPrice'] ?? p['sessionFees']}';
    }
    _duration = p['durationMinutes'] is num ? (p['durationMinutes'] as num).toInt() : 60;
    _buffer = p['bufferMinutes'] is num ? (p['bufferMinutes'] as num).toInt() : 10;
    _sessionMode = p['sessionMode']?.toString() ?? p['serviceType']?.toString();
    if ((_sessionMode ?? '').isEmpty) _sessionMode = FitnessCatalog.sessionModes.first;
  }

  Map<String, dynamic> _profileBody() {
    final state = _state == 'Other' ? _stateOther.text.trim() : (_state ?? '');
    return {
      'fullName': _name.text.trim(),
      'phone': _phone.text.trim(),
      'designation': _designation,
      'whatsappNumber': _whatsapp.text.trim(),
      'experience': int.tryParse(_years.text.trim()),
      'yearsExperience': _years.text.trim(),
      'credentialNumber': _credential.text.trim(),
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': state,
      'pincode': _pincode.text.trim(),
      'latitude': _lat,
      'longitude': _lng,
      'specializations': _categories.toList(),
      'categoriesOffered': _categories.toList(),
      'audience': _audience.toList(),
      'doorService': _doorService,
      'facilities': _facilities.toList(),
      'openDays': _days.toList(),
      'openTime': _openTime == null ? null : FitnessCatalog.formatTime(_openTime!),
      'closeTime': _closeTime == null ? null : FitnessCatalog.formatTime(_closeTime!),
      'breakStart': _breakStart == null ? null : FitnessCatalog.formatTime(_breakStart!),
      'breakEnd': _breakEnd == null ? null : FitnessCatalog.formatTime(_breakEnd!),
      'blockedDates': _blockedDates.toList(),
      'bio': _bio.text.trim(),
      'typicalPrice': double.tryParse(_rate.text.trim()) ?? 0,
      'sessionFees': double.tryParse(_rate.text.trim()) ?? 0,
      'sessionMode': _sessionMode,
      'serviceType': _sessionMode,
      'durationMinutes': _duration,
      'bufferMinutes': _buffer,
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
    };
  }

  bool _validateForm({bool forSubmit = false}) {
    final newErrors = <String, String>{};

    // 1. Identity & Credentials
    if (_name.text.trim().isEmpty) newErrors['name'] = 'Full name is required';
    if ((_designation ?? '').isEmpty) newErrors['designation'] = 'Designation is required';
    if (_phone.text.trim().length != 10) newErrors['phone'] = 'Official phone must be 10 digits';
    final expErr = RegValidators.experienceError(_years.text);
    if (expErr != null) newErrors['years'] = expErr;
    if (_credential.text.trim().isEmpty) newErrors['credential'] = 'Certification / registration number is required';

    final bankErr = BankDetailsSection.validateBankDetails(
      accountHolderController: _accountHolder,
      accountNumberController: _accountNumber,
      confirmAccountNumberController: _confirmAccountNumber,
      ifscController: _ifsc,
      bankNameController: _bankName,
      branchNameController: _branchName,
      upiController: _upi,
    );
    if (bankErr != null) newErrors['bankDetails'] = bankErr;

    // 2. Studio & Location
    if (_address.text.trim().isEmpty) newErrors['address'] = 'Street address is required';
    if (_city.text.trim().isEmpty) newErrors['city'] = 'City is required';
    if ((_state ?? '').isEmpty) newErrors['state'] = 'State is required';
    if (_state == 'Other' && _stateOther.text.trim().isEmpty) newErrors['stateOther'] = 'Enter state';
    if (_pincode.text.trim().length != 6) newErrors['pincode'] = 'Pincode must be 6 digits';

    // 3. Specializations & Audience
    if (_categories.isEmpty) newErrors['categories'] = 'Select at least one specialization';
    if (_audience.isEmpty) newErrors['audience'] = 'Target audience is required';

    // 4. Schedule, Pricing & Bio
    if (_days.isEmpty) newErrors['days'] = 'Select at least one open day';
    if (_openTime == null) newErrors['openTime'] = 'Open time is required';
    if (_closeTime == null) newErrors['closeTime'] = 'Close time is required';
    if (_bio.text.trim().isEmpty) newErrors['bio'] = 'Trainer bio / about description is required';
    if ((_sessionMode ?? '').isEmpty) newErrors['sessionMode'] = 'Session mode is required';
    if (double.tryParse(_rate.text.trim()) == null) newErrors['rate'] = 'Session fee is required (0 = free)';

    setState(() {
      _errors
        ..clear()
        ..addAll(newErrors);
      _error = newErrors.isNotEmpty ? 'Please fix the highlighted fields below' : null;
    });

    if (newErrors.isNotEmpty) {
      final firstKey = newErrors.keys.first;
      final targetKey = _fieldKeys[firstKey];
      if (targetKey?.currentContext != null) {
        Scrollable.ensureVisible(
          targetKey!.currentContext!,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
      return false;
    }

    if (forSubmit && _profile['canSubmitForVerification'] == false) {
      setState(() => _error = _profile['nextStepGuidance']?.toString() ?? 'Please complete all required fields.');
      return false;
    }

    return true;
  }

  void _finish() {
    if (!mounted) return;
    if (widget.onFinished != null) {
      widget.onFinished!(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const FitnessTrainerDashboardScreen()),
        (_) => false,
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_validateForm()) return;
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
      if (mounted) _finish();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (!_validateForm(forSubmit: true)) return;
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
      _finish();
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

  Future<void> _addBlockedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    final key = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() => _blockedDates.add(key));
  }

  Future<void> _uploadFile({required String kind}) async {
    String? path;
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
      path = img?.path;
    } catch (_) {}
    path ??= (await FilePicker.platform.pickFiles(type: FileType.image))?.files.single.path;
    if (path == null || path.isEmpty) return;
    setState(() {
      if (kind == 'photo') _uploadingPhoto = true;
      if (kind == 'gallery') _uploadingGallery = true;
      if (kind == 'cert') _uploadingCert = true;
    });
    try {
      final res = await _svc.uploadPhotos(
        profilePath: kind == 'photo' ? path : null,
        galleryPath: kind == 'gallery' ? path : null,
        certificatePath: kind == 'cert' ? path : null,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await _load();
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Upload failed');
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
          _uploadingGallery = false;
          _uploadingCert = false;
        });
      }
    }
  }

  void _skip() => _finish();

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num) ? (_profile['profileCompletionPct'] as num).toDouble() : 0.0;
    final missing = FitnessCatalog.splitCsv(_profile['missingItems']);
    final guidance = _profile['nextStepGuidance']?.toString();
    final canSubmit = _profile['canSubmitForVerification'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: FitnessTrainerProfileCompletionScreen.navy,
        title: const Text('Complete Coach Profile', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700)),
        actions: ProfileCompletionActions.appBar(
          onSkip: _loading ? null : _skip,
          onSave: (_loading || _saving) ? null : _saveProfile,
          saving: _saving,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: _profile['partnerProfileStatusLabel']?.toString() ?? 'Pending',
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
                    backgroundColor: FitnessTrainerProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(canSubmit ? 'Submit for Verification' : 'Complete required items to submit'),
                ),
                const SizedBox(height: 16),

                // SECTION 1: Identity & Credentials
                _sectionCard(
                  '1',
                  'Identity & Credentials',
                  Icons.badge_outlined,
                  [
                    _field(
                      fieldKey: 'name',
                      controller: _name,
                      number: '1.1',
                      label: 'Full Name',
                      required: true,
                    ),
                    _dropdown(
                      fieldKey: 'designation',
                      number: '1.2',
                      label: 'Designation / Title',
                      value: _designation,
                      options: FitnessCatalog.designations,
                      required: true,
                      onChanged: (v) {
                        setState(() {
                          _designation = v;
                          _errors.remove('designation');
                        });
                      },
                    ),
                    _field(
                      fieldKey: 'phone',
                      controller: _phone,
                      number: '1.5',
                      label: 'Official Phone',
                      required: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _field(
                      fieldKey: 'whatsapp',
                      controller: _whatsapp,
                      number: '1.6',
                      label: 'WhatsApp Number',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _field(
                      fieldKey: 'years',
                      controller: _years,
                      number: '1.7',
                      label: 'Years of Experience',
                      required: true,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                    ),
                    _field(
                      fieldKey: 'credential',
                      controller: _credential,
                      number: '1.8',
                      label: 'ACE / NASM / Yoga Alliance / Cert Number',
                      required: true,
                      hint: 'Enter your accreditation or certification license number',
                    ),
                  ],
                ),

                // SECTION 2: Studio & Location
                _sectionCard(
                  '2',
                  'Studio & Location',
                  Icons.location_on_outlined,
                  [
                    _field(
                      fieldKey: 'address',
                      controller: _address,
                      number: '2.1',
                      label: 'Studio / Home Address',
                      required: true,
                    ),
                    _field(
                      fieldKey: 'city',
                      controller: _city,
                      number: '2.3',
                      label: 'City',
                      required: true,
                    ),
                    _dropdown(
                      fieldKey: 'state',
                      number: '2.4',
                      label: 'State',
                      value: _state,
                      options: FitnessCatalog.indianStates,
                      required: true,
                      onChanged: (v) {
                        setState(() {
                          _state = v;
                          _errors.remove('state');
                        });
                      },
                    ),
                    if (_state == 'Other')
                      _field(
                        fieldKey: 'stateOther',
                        controller: _stateOther,
                        number: '2.4',
                        label: 'Enter State Name',
                        required: true,
                      ),
                    _field(
                      fieldKey: 'pincode',
                      controller: _pincode,
                      number: '2.5',
                      label: 'Pincode',
                      required: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _field(
                      fieldKey: 'mapLocation',
                      controller: _mapLocation,
                      number: '2.6',
                      label: 'Google Maps Link',
                      hint: 'Paste Maps link (optional)',
                    ),
                    const SizedBox(height: 8),
                    ProfileLocationPicker(
                      lat: _lat,
                      lng: _lng,
                      mapLinkController: _mapLocation,
                      pinLabel: '2.7 Pin Studio on Map',
                      onPinned: (lat, lng) => setState(() {
                        _lat = lat;
                        _lng = lng;
                      }),
                      onError: (msg) => setState(() => _error = msg),
                    ),
                  ],
                ),

                // SECTION 3: Specializations & Audience
                _sectionCard(
                  '3',
                  'Specializations & Audience',
                  Icons.fitness_center_outlined,
                  [
                    Container(key: _key('categories')),
                    Row(
                      children: [
                        const Text('3.1 Categories & Specializations *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        if (_errors.containsKey('categories')) ...[
                          const SizedBox(width: 8),
                          Text(_errors['categories']!, style: const TextStyle(fontSize: 12, color: Colors.red)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: FitnessCatalog.allSpecializations.map((c) {
                        final on = _categories.contains(c);
                        return FilterChip(
                          label: Text(c),
                          selected: on,
                          selectedColor: const Color(0xFFFFF1F2),
                          checkmarkColor: const Color(0xFFF43F5E),
                          onSelected: (v) => setState(() {
                            if (v) {
                              _categories.add(c);
                            } else {
                              _categories.remove(c);
                            }
                            _errors.remove('categories');
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(key: _key('audience')),
                    Row(
                      children: [
                        const Text('3.2 Target Audience / Who I Serve *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        if (_errors.containsKey('audience')) ...[
                          const SizedBox(width: 8),
                          Text(_errors['audience']!, style: const TextStyle(fontSize: 12, color: Colors.red)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    _chips(FitnessCatalog.audiences, _audience, 'audience'),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('3.3 Home / Doorstep Training Sessions'),
                      subtitle: const Text('Offer personalized sessions at client residence'),
                      value: _doorService,
                      activeThumbColor: FitnessTrainerProfileCompletionScreen.primary,
                      onChanged: (v) => setState(() => _doorService = v),
                    ),
                    const SizedBox(height: 8),
                    const Text('3.4 Studio Amenities & Equipment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    _chips(FitnessCatalog.facilities, _facilities, null),
                  ],
                ),

                // SECTION 4: Schedule, Pricing & Bio
                _sectionCard(
                  '4',
                  'Schedule, Pricing & Bio',
                  Icons.schedule_outlined,
                  [
                    Container(key: _key('days')),
                    Row(
                      children: [
                        const Text('4.1 Open Days *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                        if (_errors.containsKey('days')) ...[
                          const SizedBox(width: 8),
                          Text(_errors['days']!, style: const TextStyle(fontSize: 12, color: Colors.red)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: FitnessCatalog.days.map((d) {
                        final on = _days.contains(d);
                        return FilterChip(
                          label: Text(d.substring(0, 3)),
                          selected: on,
                          selectedColor: const Color(0xFFFFF1F2),
                          checkmarkColor: const Color(0xFFF43F5E),
                          onSelected: (v) => setState(() {
                            if (v) {
                              _days.add(d);
                            } else {
                              _days.remove(d);
                            }
                            _errors.remove('days');
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Container(key: _key('openTime')),
                    _timeTile('4.2 Daily Opening Time *', _openTime, (t) {
                      _openTime = t;
                      _errors.remove('openTime');
                    }, error: _errors['openTime']),
                    Container(key: _key('closeTime')),
                    _timeTile('4.3 Daily Closing Time *', _closeTime, (t) {
                      _closeTime = t;
                      _errors.remove('closeTime');
                    }, error: _errors['closeTime']),
                    _timeTile('4.4 Break Start (Optional)', _breakStart, (t) => _breakStart = t),
                    _timeTile('4.5 Break End (Optional)', _breakEnd, (t) => _breakEnd = t),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _addBlockedDate,
                      icon: const Icon(Icons.event_busy, size: 18),
                      label: const Text('4.6 Add Blocked Date / Vacation'),
                    ),
                    if (_blockedDates.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: _blockedDates
                            .map((d) => InputChip(
                                  label: Text(d),
                                  onDeleted: () => setState(() => _blockedDates.remove(d)),
                                ))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _field(
                      fieldKey: 'bio',
                      controller: _bio,
                      number: '4.7',
                      label: 'About Coach & Bio',
                      required: true,
                      maxLines: 4,
                      hint: 'Describe your training philosophy, approach, and track record',
                    ),
                    _dropdown(
                      fieldKey: 'sessionMode',
                      number: '4.8',
                      label: 'Session Mode',
                      value: _sessionMode,
                      options: FitnessCatalog.sessionModes,
                      required: true,
                      onChanged: (v) {
                        setState(() {
                          _sessionMode = v;
                          _errors.remove('sessionMode');
                        });
                      },
                    ),
                    _dropdown(
                      fieldKey: 'duration',
                      number: '4.9',
                      label: 'Standard Duration (minutes)',
                      value: '$_duration',
                      options: FitnessCatalog.durations.map((e) => '$e').toList(),
                      required: true,
                      onChanged: (v) => setState(() => _duration = int.tryParse(v ?? '60') ?? 60),
                    ),
                    _dropdown(
                      fieldKey: 'buffer',
                      number: '4.10',
                      label: 'Buffer Between Sessions (minutes)',
                      value: '$_buffer',
                      options: FitnessCatalog.buffers.map((e) => '$e').toList(),
                      onChanged: (v) => setState(() => _buffer = int.tryParse(v ?? '10') ?? 10),
                    ),
                    _field(
                      fieldKey: 'rate',
                      controller: _rate,
                      number: '4.11',
                      label: 'Session Fee (₹, 0 = free session)',
                      required: true,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),

                // SECTION 5: Payout & Bank Account
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BankDetailsSection(
                          sectionNumber: '5',
                          title: 'Payout Bank & UPI Details',
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
                        const SizedBox(height: 8),
                        const Text(
                          'Bank details and UPI ID are required for withdrawal payouts from your coach studio wallet.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),

                // SECTION 6: Certifications & Photos
                _sectionCard(
                  '6',
                  'Certifications & Photos',
                  Icons.photo_library_outlined,
                  [
                    const Text(
                      'High-resolution profile and certification photos build trust and significantly increase member bookings.',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    _uploadTile(
                      '6.1 Profile Avatar Photo',
                      _profile['profileImageUrl']?.toString() ?? _profile['profilePhotoPath']?.toString(),
                      _uploadingPhoto,
                      () => _uploadFile(kind: 'photo'),
                    ),
                    _uploadTile(
                      '6.2 Fitness Certification Document Scan',
                      _profile['certificationsPath']?.toString(),
                      _uploadingCert,
                      () => _uploadFile(kind: 'cert'),
                    ),
                    _uploadTile(
                      '6.3 Studio / Workout Gallery Photos',
                      (_profile['galleryPhotos'] is List && (_profile['galleryPhotos'] as List).isNotEmpty)
                          ? (_profile['galleryPhotos'] as List).last.toString()
                          : null,
                      _uploadingGallery,
                      () => _uploadFile(kind: 'gallery'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _saving ? null : _saveProfile,
                  style: FilledButton.styleFrom(
                    backgroundColor: FitnessTrainerProfileCompletionScreen.navy,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_outlined),
                  label: const Text('Save Profile Draft', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
                const SizedBox(height: 12),
              ],
            ),
    );
  }

  Widget _sectionCard(String number, String title, IconData icon, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: FitnessTrainerProfileCompletionScreen.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$number. $title',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: FitnessTrainerProfileCompletionScreen.navy),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _field({
    required String fieldKey,
    required TextEditingController controller,
    required String number,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    String? helper,
    bool required = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final hasErr = _errors.containsKey(fieldKey);
    final errorMsg = _errors[fieldKey];
    final resolvedHelper = helper ?? ProfileFieldHelper.helperForLabel(label);

    return Padding(
      key: _key(fieldKey),
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            onChanged: (_) {
              if (_errors.containsKey(fieldKey)) {
                setState(() => _errors.remove(fieldKey));
              }
            },
            decoration: InputDecoration(
              labelText: '$number $label${required ? ' *' : ''}',
              hintText: hint,
              helperText: hasErr ? null : resolvedHelper,
              helperMaxLines: 2,
              errorText: errorMsg,
              counterText: maxLength != null ? '' : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasErr ? Colors.red : FitnessTrainerProfileCompletionScreen.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: hasErr ? const Color(0xFFFEF2F2) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String fieldKey,
    required String number,
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool required = false,
    String? helper,
  }) {
    final items = [...options];
    if (value != null && value.isNotEmpty && !items.contains(value)) items.add(value);
    final resolvedHelper = helper ?? 'Select $label from the list.';
    final hasErr = _errors.containsKey(fieldKey);
    final errorMsg = _errors[fieldKey];

    return Padding(
      key: _key(fieldKey),
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value != null && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          helperText: hasErr ? null : resolvedHelper,
          helperMaxLines: 2,
          errorText: errorMsg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasErr ? Colors.red : FitnessTrainerProfileCompletionScreen.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: hasErr ? const Color(0xFFFEF2F2) : Colors.white,
        ),
        items: items.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _chips(List<String> options, Set<String> selected, String? fieldKey) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final on = selected.contains(item);
        return FilterChip(
          label: Text(item),
          selected: on,
          selectedColor: const Color(0xFFFFF1F2),
          checkmarkColor: const Color(0xFFF43F5E),
          onSelected: (v) => setState(() {
            if (v) {
              selected.add(item);
            } else {
              selected.remove(item);
            }
            if (fieldKey != null) _errors.remove(fieldKey);
          }),
        );
      }).toList(),
    );
  }

  Widget _timeTile(String label, TimeOfDay? value, void Function(TimeOfDay t) apply, {String? error}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(value == null ? 'Tap to pick time' : FitnessCatalog.formatTime(value)),
            trailing: const Icon(Icons.schedule, color: FitnessTrainerProfileCompletionScreen.primary),
            onTap: () => _pickClock(apply, value),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(error, style: const TextStyle(fontSize: 12, color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _uploadTile(String title, String? path, bool loading, VoidCallback onTap) {
    final uploaded = path != null && path.trim().isNotEmpty;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: loading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: uploaded ? const Color(0xFF16A34A) : FitnessTrainerProfileCompletionScreen.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(uploaded ? 'Uploaded · Tap to replace' : 'JPG or PNG · upload file'),
      trailing: const Icon(Icons.chevron_right),
      onTap: loading ? null : onTap,
    );
  }
}
