import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/lawyer_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/bank_details_form.dart';
import '../../widgets/dynamic_location_hierarchy_picker.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';
import 'women_lawyer_pending_approval_screen.dart';

/// Complete Women Lawyer profile completion & editing screen.
/// Replicates all sections, fields, validations and live preview from `lawyer/profileCompletion.jsp`.
class WomenLawyerProfileCompletionScreen extends StatefulWidget {
  const WomenLawyerProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);
  static const Color bgPage = Color(0xFFF8FAFC);

  @override
  State<WomenLawyerProfileCompletionScreen> createState() =>
      _WomenLawyerProfileCompletionScreenState();
}

class _WomenLawyerProfileCompletionScreenState
    extends State<WomenLawyerProfileCompletionScreen> {
  // Section 1: Professional Identity
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _barCouncil = TextEditingController();
  final _years = TextEditingController();
  final _languages = TextEditingController();
  String? _designation;

  // Section 2: Legal Expertise & Bio
  final _bio = TextEditingController();
  final _audience = TextEditingController();
  final Set<String> _practiceAreas = {};

  // Section 3: Chamber Address & Location
  final _address = TextEditingController();
  String _country = 'India';
  String? _state;
  String? _district;
  String? _city;
  final _pincode = TextEditingController();
  final _facilities = TextEditingController();
  final _mapLocation = TextEditingController();
  double? _lat;
  double? _lng;

  // Section 4: Schedule & Availability
  final _openDays = TextEditingController(text: 'Mon - Fri');
  String _serviceMode = 'CHAMBER';
  int _duration = 60;
  String _consultMode = 'Video Call';
  TimeOfDay? _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? _closeTime = const TimeOfDay(hour: 18, minute: 0);

  // Section 5: Fees & Banking
  final _fee = TextEditingController(text: '1000');
  final _upi = TextEditingController();
  final _accountHolder = TextEditingController();
  final _accountNumber = TextEditingController();
  final _confirmAccountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();
  final _branchName = TextEditingController();
  String _accountType = 'Savings';

  // State flags & photos
  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingChamberPhoto = false;
  String? _error;
  String? _profilePhotoUrl;
  String? _chamberPhotoUrl;
  Map<String, dynamic> _profile = {};
  final Map<String, String> _errors = {};

  MarketplaceProviderAuthService get _svc =>
      MarketplaceProviderAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _phone,
      _whatsapp,
      _barCouncil,
      _years,
      _languages,
      _bio,
      _audience,
      _address,
      _pincode,
      _facilities,
      _mapLocation,
      _openDays,
      _fee,
      _upi,
      _accountHolder,
      _accountNumber,
      _confirmAccountNumber,
      _ifsc,
      _bankName,
      _branchName,
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
        _error = res['error']?.toString() ?? 'Failed to load lawyer profile';
      });
    }
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;

    // 1. Identity
    _name.text = p['fullName']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _barCouncil.text = p['barCouncilId']?.toString() ?? '';
    _years.text = (p['experienceYears'] ?? p['yearsExperience'])?.toString() ?? '';
    _languages.text = p['languages']?.toString() ?? '';
    final des = p['designation']?.toString();
    _designation = (des != null && des.isNotEmpty) ? des : null;

    // Photos
    _profilePhotoUrl = p['profilePhoto']?.toString() ?? p['profileImageUrl']?.toString();
    if (_profilePhotoUrl == 'web-pending' || _profilePhotoUrl == 'mobile-pending') {
      _profilePhotoUrl = null;
    }
    _chamberPhotoUrl = p['galleryPhotos'] is List
        ? ((p['galleryPhotos'] as List).isNotEmpty ? (p['galleryPhotos'] as List).first.toString() : null)
        : (p['galleryPhotos']?.toString().split(',').firstOrNull);

    // 2. Practice & Bio
    _bio.text = p['bio']?.toString() ?? p['description']?.toString() ?? '';
    _audience.text = p['audience'] is List
        ? (p['audience'] as List).join(', ')
        : (p['audience']?.toString() ?? '');
    _practiceAreas
      ..clear()
      ..addAll(LawyerCatalog.splitCsv(p['practiceAreas']));

    // 3. Location
    _address.text = p['address']?.toString() ?? '';
    _country = p['country']?.toString() ?? 'India';
    _state = p['state']?.toString();
    _city = p['city']?.toString();
    _district = p['district']?.toString();
    _pincode.text = p['pincode']?.toString() ?? '';
    _facilities.text = p['facilities'] is List
        ? (p['facilities'] as List).join(', ')
        : (p['facilities']?.toString() ?? '');

    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');
    if (_lat != null && _lng != null) {
      _mapLocation.text = 'https://maps.google.com/?q=$_lat,$_lng';
    }

    // 4. Schedule
    final days = p['openDays'];
    if (days != null && days.toString().isNotEmpty) {
      _openDays.text = days is List ? days.join(', ') : days.toString();
    }
    _serviceMode = (p['serviceMode']?.toString().isNotEmpty == true)
        ? p['serviceMode'].toString().toUpperCase()
        : 'CHAMBER';
    _duration = p['durationMinutes'] is num ? (p['durationMinutes'] as num).toInt() : 60;
    _consultMode = p['consultationMode']?.toString() ?? 'Video Call';
    _openTime = LawyerCatalog.parseTime(p['openTime']?.toString()) ?? const TimeOfDay(hour: 9, minute: 0);
    _closeTime = LawyerCatalog.parseTime(p['closeTime']?.toString()) ?? const TimeOfDay(hour: 18, minute: 0);

    // 5. Fees & Bank
    if (p['consultationFee'] != null) {
      _fee.text = '${p['consultationFee']}';
    }
    _upi.text = p['upiId']?.toString() ?? '';
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
  }

  Map<String, dynamic> _profileBody() {
    return {
      'fullName': _name.text.trim(),
      'phone': _phone.text.trim(),
      'whatsappNumber': _whatsapp.text.trim(),
      'designation': _designation,
      'barCouncilId': _barCouncil.text.trim().toUpperCase(),
      'experienceYears': int.tryParse(_years.text.trim()),
      'yearsExperience': _years.text.trim(),
      'languages': _languages.text.trim(),
      'practiceAreas': _practiceAreas.toList(),
      'bio': _bio.text.trim(),
      'description': _bio.text.trim(),
      'audience': _audience.text.trim(),
      'address': _address.text.trim(),
      'country': _country,
      'state': _state ?? '',
      'district': _district ?? '',
      'city': _city ?? '',
      'pincode': _pincode.text.trim(),
      'facilities': _facilities.text.trim(),
      'latitude': _lat,
      'longitude': _lng,
      'openDays': _openDays.text.trim(),
      'serviceMode': _serviceMode,
      'durationMinutes': _duration,
      'consultationMode': _consultMode,
      'openTime': _openTime == null ? null : LawyerCatalog.formatTime(_openTime!),
      'closeTime': _closeTime == null ? null : LawyerCatalog.formatTime(_closeTime!),
      'consultationFee': double.tryParse(_fee.text.trim()) ?? 0,
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
    final errs = <String, String>{};

    if (_name.text.trim().isEmpty) {
      errs['name'] = 'Enter your full legal/professional name';
    }
    if (_phone.text.trim().length != 10) {
      errs['phone'] = 'Official phone number must be 10 digits';
    }
    if (_whatsapp.text.trim().isNotEmpty && _whatsapp.text.trim().length != 10) {
      errs['whatsapp'] = 'WhatsApp number must be 10 digits';
    }
    if (_barCouncil.text.trim().isEmpty) {
      errs['barCouncil'] = 'Valid Bar Council registration number is required';
    }
    final exp = int.tryParse(_years.text.trim());
    if (exp == null || exp < 0 || exp > 60) {
      errs['years'] = 'Enter valid experience in years (0 to 60)';
    }
    if (_languages.text.trim().isEmpty) {
      errs['languages'] = 'Enter languages in which you provide legal counsel';
    }
    if (_practiceAreas.isEmpty) {
      errs['practiceAreas'] = 'Select at least one legal practice area';
    }
    if (_bio.text.trim().length < 25) {
      errs['bio'] = 'Professional bio must be at least 25 characters';
    }
    if (_address.text.trim().isEmpty) {
      errs['address'] = 'Chamber or office address is required';
    }
    if ((_state ?? '').trim().isEmpty) {
      errs['state'] = 'Select your State';
    }
    if ((_city ?? '').trim().isEmpty) {
      errs['city'] = 'Select or enter your City';
    }
    if (_pincode.text.trim().length != 6) {
      errs['pincode'] = 'Pincode must be 6 digits';
    }
    if (_openDays.text.trim().isEmpty) {
      errs['openDays'] = 'Open days are required (e.g. Mon - Fri)';
    }
    final feeVal = double.tryParse(_fee.text.trim());
    if (feeVal == null || feeVal < 0) {
      errs['fee'] = 'Enter valid consultation fee (0 for Free/Pro Bono)';
    }

    // Bank validation
    if (_accountNumber.text.trim().isNotEmpty) {
      if (_accountNumber.text.trim().length < 9) {
        errs['accountNumber'] = 'Bank account number must be at least 9 digits';
      }
      if (_confirmAccountNumber.text.trim() != _accountNumber.text.trim()) {
        errs['confirmAccountNumber'] = 'Account numbers do not match';
      }
      if (_ifsc.text.trim().length != 11) {
        errs['ifsc'] = 'IFSC code must be 11 characters (e.g. SBIN0001234)';
      }
      if (_accountHolder.text.trim().isEmpty) {
        errs['accountHolder'] = 'Account holder name is required';
      }
      if (_bankName.text.trim().isEmpty) {
        errs['bankName'] = 'Bank name is required';
      }
    }

    setState(() => _errors
      ..clear()
      ..addAll(errs));

    if (errs.isNotEmpty) {
      _error = errs.values.first;
      return false;
    }
    return true;
  }

  Future<void> _uploadHeadshot() async {
    String? path;
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      path = img?.path;
    } catch (_) {}
    path ??= (await FilePicker.platform.pickFiles(type: FileType.image))?.files.single.path;
    if (path == null || path.isEmpty) return;

    setState(() => _uploadingPhoto = true);
    try {
      final res = await _svc.uploadPhotos(profilePath: path);
      if (!mounted) return;
      if (res['success'] == true) {
        await _load();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Advocate photo uploaded successfully')),
        );
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Failed to upload photo');
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _uploadChamberPhoto() async {
    String? path;
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
      path = img?.path;
    } catch (_) {}
    path ??= (await FilePicker.platform.pickFiles(type: FileType.image))?.files.single.path;
    if (path == null || path.isEmpty) return;

    setState(() => _uploadingChamberPhoto = true);
    try {
      final res = await _svc.uploadPhotos(galleryPath: path);
      if (!mounted) return;
      if (res['success'] == true) {
        await _load();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chamber photo uploaded successfully')),
        );
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Failed to upload chamber photo');
      }
    } finally {
      if (mounted) setState(() => _uploadingChamberPhoto = false);
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
        loadingLabel: 'Saving lawyer profile…',
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

  Future<void> _submit() async {
    if (!_validateForm(forSubmit: true)) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Submitting credentials for verification…',
        doneLabel: 'Submitted',
        action: () async {
          final saveRes = await _svc.updateProfile(_profileBody());
          if (saveRes['success'] == true) _applyProfile(Map<String, dynamic>.from(saveRes));
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

      // Navigate to dedicated Pending Approval screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WomenLawyerPendingApprovalScreen(initialProfile: _profile),
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _skip() => ProfileCompletionActions.skip(context, widget.onFinished);

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toDouble()
        : 0.0;
    final missing = LawyerCatalog.splitCsv(_profile['missingItems']);
    final guidance = _profile['nextStepGuidance']?.toString();
    final canSubmit = _profile['canSubmitForVerification'] == true;

    return Scaffold(
      backgroundColor: WomenLawyerProfileCompletionScreen.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WomenLawyerProfileCompletionScreen.navy,
        elevation: 0.5,
        title: const Text(
          'Complete Lawyer Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: ProfileCompletionActions.appBar(
          onSkip: _loading ? null : _skip,
          onSave: (_loading || _saving) ? null : _saveProfile,
          saving: _saving,
        ),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
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
                        const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Completion Progress Header Matching Website
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: _profile['partnerProfileStatusLabel']?.toString() ?? 'Incomplete',
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
                                    label: Text(m, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    backgroundColor: const Color(0xFFFFF7ED),
                                  ))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 12),

                // Submit For Verification Action
                FilledButton.icon(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(canSubmit ? 'Submit Profile for Admin Verification' : 'Complete Required Sections to Submit'),
                  style: FilledButton.styleFrom(
                    backgroundColor: WomenLawyerProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 1: Professional Identity
                _sectionCard('1', 'Professional Identity', Icons.badge_rounded, [
                  _field(
                    controller: _name,
                    keyName: 'name',
                    label: 'Lawyer Name *',
                    helper: 'Enter your full legal/professional name as registered with the Bar Council.',
                    placeholder: 'e.g. Adv. Priya Sharma',
                  ),
                  _dropdown(
                    keyName: 'designation',
                    label: 'Professional Designation',
                    helper: 'Select your primary professional title.',
                    value: _designation,
                    options: LawyerCatalog.designations,
                    onChanged: (v) => setState(() => _designation = v),
                  ),
                  _field(
                    controller: _phone,
                    keyName: 'phone',
                    label: 'Official Phone Number *',
                    helper: '10-digit mobile number for client contact.',
                    placeholder: 'e.g. 9876543210',
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    controller: _whatsapp,
                    keyName: 'whatsapp',
                    label: 'WhatsApp Number',
                    helper: '10-digit WhatsApp number for case updates.',
                    placeholder: 'e.g. 9876543210',
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    controller: _barCouncil,
                    keyName: 'barCouncil',
                    label: 'Bar Council Registration Number *',
                    helper: 'Enter your valid State Bar Council enrolment number (e.g. MAH/1234/2018).',
                    placeholder: 'e.g. MAH/1234/2018 or D/567/2015',
                  ),
                  _field(
                    controller: _years,
                    keyName: 'years',
                    label: 'Years of Experience *',
                    helper: 'Enter your total years of active legal practice.',
                    placeholder: 'e.g. 8',
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    controller: _languages,
                    keyName: 'languages',
                    label: 'Languages Spoken *',
                    helper: 'Languages you provide legal counsel in (e.g. English, Hindi, Kannada).',
                    placeholder: 'e.g. English, Hindi, Marathi',
                  ),

                  // Headshot photo upload
                  const SizedBox(height: 8),
                  _uploadTile(
                    label: 'Advocate Professional Headshot',
                    helper: 'Upload professional portrait for client trust (JPG, PNG, WebP up to 5MB).',
                    imageUrl: _profilePhotoUrl,
                    loading: _uploadingPhoto,
                    onUpload: _uploadHeadshot,
                  ),
                ]),

                // SECTION 2: Legal Expertise & Bio
                _sectionCard('2', 'Legal Expertise & Profile', Icons.gavel_rounded, [
                  _practiceAreasPicker(),
                  const SizedBox(height: 12),
                  _field(
                    controller: _bio,
                    keyName: 'bio',
                    label: 'Professional Biography *',
                    helper: 'Describe your legal practice, key court appearances, and focus on justice (min 25 chars).',
                    placeholder: 'Describe your legal experience, notable representations, courts of practice...',
                    maxLines: 4,
                  ),
                  _field(
                    controller: _audience,
                    keyName: 'audience',
                    label: 'Client Focus / Audience',
                    helper: 'Groups of clients you primarily counsel.',
                    placeholder: 'e.g. Women, Victims of Harassment, Working Professionals',
                  ),
                ]),

                // SECTION 3: Chamber & Office Address
                _sectionCard('3', 'Chamber & Office Location', Icons.location_on_rounded, [
                  _field(
                    controller: _address,
                    keyName: 'address',
                    label: 'Chamber / Office Address *',
                    helper: 'Chamber number, building, street, or court complex.',
                    placeholder: 'Chamber/Office number, building name, street or court complex...',
                    maxLines: 2,
                  ),
                  DynamicLocationHierarchyPicker(
                    api: context.read<AuthState>().api,
                    initialCountry: _country,
                    initialState: _state,
                    initialDistrict: _district,
                    initialCity: _city,
                    isRequired: true,
                    onLocationChanged: ({
                      required country,
                      required state,
                      required district,
                      required city,
                    }) {
                      setState(() {
                        _country = country;
                        _state = state;
                        _district = district;
                        _city = city;
                        _errors.remove('state');
                        _errors.remove('city');
                      });
                    },
                  ),
                  if (_errors['state'] != null || _errors['city'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        _errors['state'] ?? _errors['city']!,
                        style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  _field(
                    controller: _pincode,
                    keyName: 'pincode',
                    label: 'Pincode *',
                    helper: '6-digit postal code of your chamber location.',
                    placeholder: 'e.g. 400001',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    controller: _facilities,
                    keyName: 'facilities',
                    label: 'Chamber Facilities',
                    helper: 'Amenities available for client consultations.',
                    placeholder: 'e.g. Private Consultation Room, Video Conference Facility, Waiting Lounge',
                  ),
                  const SizedBox(height: 8),
                  ProfileLocationPicker(
                    lat: _lat,
                    lng: _lng,
                    mapLinkController: _mapLocation,
                    pinLabel: 'Pin chamber coordinates on map',
                    onPinned: (lat, lng) => setState(() {
                      _lat = lat;
                      _lng = lng;
                    }),
                    onError: (msg) => setState(() => _error = msg),
                  ),
                ]),

                // SECTION 4: Schedule, Consultation & Availability
                _sectionCard('4', 'Schedule, Consultation & Availability', Icons.schedule_rounded, [
                  _field(
                    controller: _openDays,
                    keyName: 'openDays',
                    label: 'Available Working Days *',
                    helper: 'Days you are available for client consultations (e.g. Mon - Fri, Mon - Sat).',
                    placeholder: 'e.g. Mon - Fri',
                  ),
                  _dropdown(
                    keyName: 'serviceMode',
                    label: 'Service Mode *',
                    helper: 'Consultation delivery model.',
                    value: _serviceMode,
                    options: LawyerCatalog.serviceModes,
                    onChanged: (v) => setState(() => _serviceMode = v ?? 'CHAMBER'),
                  ),
                  _dropdown(
                    keyName: 'durationMinutes',
                    label: 'Session Duration *',
                    helper: 'Standard duration per consultation session.',
                    value: '$_duration mins',
                    options: const ['15 mins', '30 mins', '45 mins', '60 mins', '90 mins', '120 mins'],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => _duration = int.tryParse(v.split(' ').first) ?? 60);
                      }
                    },
                  ),
                  _dropdown(
                    keyName: 'consultationMode',
                    label: 'Consultation Mode *',
                    helper: 'Mode in which consultations are conducted.',
                    value: _consultMode,
                    options: LawyerCatalog.consultModes,
                    onChanged: (v) => setState(() => _consultMode = v ?? 'Video Call'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _timeTile(
                          label: 'Opening Time',
                          time: _openTime,
                          onPick: () => _pickTime(_openTime, (t) => _openTime = t),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _timeTile(
                          label: 'Closing Time',
                          time: _closeTime,
                          onPick: () => _pickTime(_closeTime, (t) => _closeTime = t),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _uploadTile(
                    label: 'Chamber / Office Photo',
                    helper: 'Upload a clear photograph of your consultation room or chamber.',
                    imageUrl: _chamberPhotoUrl,
                    loading: _uploadingChamberPhoto,
                    onUpload: _uploadChamberPhoto,
                  ),
                ]),

                // SECTION 5: Consultation Fees & Banking Details
                _sectionCard('5', 'Consultation Fees & Banking Details', Icons.account_balance_wallet_rounded, [
                  _field(
                    controller: _fee,
                    keyName: 'fee',
                    label: 'Consultation Fee (INR) *',
                    helper: 'Fee per session in ₹ (enter 0 for Free / Pro Bono legal support).',
                    placeholder: 'e.g. 1000',
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _field(
                    controller: _upi,
                    keyName: 'upi',
                    label: 'UPI ID for Direct Payouts',
                    helper: 'Fast settlement UPI identifier (e.g. advocate@oksbi).',
                    placeholder: 'e.g. advocate@oksbi',
                  ),
                  const SizedBox(height: 12),
                  BankDetailsSection(
                    accountHolderController: _accountHolder,
                    accountNumberController: _accountNumber,
                    confirmAccountNumberController: _confirmAccountNumber,
                    ifscController: _ifsc,
                    bankNameController: _bankName,
                    branchNameController: _branchName,
                    upiController: _upi,
                    accountType: _accountType,
                    onAccountTypeChanged: (t) => setState(() => _accountType = t),
                    isRequired: false,
                    title: 'Advocate Bank Account for Consultation Payouts',
                  ),
                ]),

                // LIVE PROFILE PREVIEW CARD (Matches Website `profileCompletion.jsp:738-800`)
                _livePreviewCard(),

                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: (_loading || _saving) ? null : _saveProfile,
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: const Text('Save & Continue Later', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  style: FilledButton.styleFrom(
                    backgroundColor: WomenLawyerProfileCompletionScreen.navy,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
    );
  }

  // --- Helper Builders ---

  Widget _sectionCard(String step, String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: WomenLawyerProfileCompletionScreen.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: WomenLawyerProfileCompletionScreen.navy,
                  ),
                ),
              ),
              Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            ],
          ),
          const Divider(height: 28),
          ...children,
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String keyName,
    required String label,
    required String helper,
    String? placeholder,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    final hasErr = _errors.containsKey(keyName);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            inputFormatters: formatters,
            onChanged: (_) {
              if (hasErr) setState(() => _errors.remove(keyName));
            },
            decoration: InputDecoration(
              hintText: placeholder,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: hasErr ? Colors.red : const Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: hasErr ? Colors.red : const Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: hasErr ? Colors.red : WomenLawyerProfileCompletionScreen.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasErr ? _errors[keyName]! : helper,
            style: TextStyle(
              fontSize: 11,
              fontWeight: hasErr ? FontWeight.w700 : FontWeight.w500,
              color: hasErr ? Colors.red : WomenLawyerProfileCompletionScreen.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String keyName,
    required String label,
    required String helper,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final hasErr = _errors.containsKey(keyName);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: options.contains(value) ? value : null,
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 14)))).toList(),
            onChanged: (v) {
              if (hasErr) setState(() => _errors.remove(keyName));
              onChanged(v);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? Colors.red : const Color(0xFFCBD5E1))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? Colors.red : const Color(0xFFCBD5E1))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: hasErr ? Colors.red : WomenLawyerProfileCompletionScreen.primary, width: 1.5)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasErr ? _errors[keyName]! : helper,
            style: TextStyle(fontSize: 11, fontWeight: hasErr ? FontWeight.w700 : FontWeight.w500, color: hasErr ? Colors.red : WomenLawyerProfileCompletionScreen.textGray),
          ),
        ],
      ),
    );
  }

  Widget _practiceAreasPicker() {
    final hasErr = _errors.containsKey('practiceAreas');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Practice Areas *',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: LawyerCatalog.practiceAreas.map((area) {
            final selected = _practiceAreas.contains(area);
            return FilterChip(
              label: Text(area, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? Colors.white : const Color(0xFF1E293B))),
              selected: selected,
              selectedColor: WomenLawyerProfileCompletionScreen.primary,
              backgroundColor: const Color(0xFFF1F5F9),
              checkmarkColor: Colors.white,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _practiceAreas.add(area);
                  } else {
                    _practiceAreas.remove(area);
                  }
                  _errors.remove('practiceAreas');
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        Text(
          hasErr ? _errors['practiceAreas']! : 'Select the legal domains you handle.',
          style: TextStyle(fontSize: 11, fontWeight: hasErr ? FontWeight.w700 : FontWeight.w500, color: hasErr ? Colors.red : WomenLawyerProfileCompletionScreen.textGray),
        ),
      ],
    );
  }

  Widget _uploadTile({
    required String label,
    required String helper,
    required String? imageUrl,
    required bool loading,
    required VoidCallback onUpload,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: WomenLawyerProfileCompletionScreen.primary),
            ),
            clipBehavior: Clip.antiAlias,
            child: (imageUrl != null && imageUrl.isNotEmpty)
                ? Image.network(
                    imageUrl.startsWith('http') ? imageUrl : '${context.read<AuthState>().api.baseUrl}/$imageUrl',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stackTrace) => const Icon(Icons.person_rounded, color: WomenLawyerProfileCompletionScreen.primary),
                  )
                : const Icon(Icons.person_rounded, color: WomenLawyerProfileCompletionScreen.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: WomenLawyerProfileCompletionScreen.navy)),
                const SizedBox(height: 2),
                Text(helper, style: const TextStyle(fontSize: 11, color: WomenLawyerProfileCompletionScreen.textGray)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: loading ? null : onUpload,
            icon: loading
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.upload_rounded, size: 16),
            label: Text(loading ? 'Uploading…' : 'Upload', style: const TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(
              backgroundColor: WomenLawyerProfileCompletionScreen.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeTile({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onPick,
  }) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: WomenLawyerProfileCompletionScreen.textGray)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: WomenLawyerProfileCompletionScreen.primary),
                const SizedBox(width: 6),
                Text(
                  time == null ? 'Select' : time.format(context),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(TimeOfDay? current, ValueChanged<TimeOfDay> onPicked) async {
    final t = await showTimePicker(context: context, initialTime: current ?? const TimeOfDay(hour: 9, minute: 0));
    if (t != null) setState(() => onPicked(t));
  }

  // --- LIVE PUBLIC CLIENT VIEW PREVIEW CARD ---
  // Matches website `profileCompletion.jsp:738-800`
  Widget _livePreviewCard() {
    final name = _name.text.trim().isEmpty ? 'Advocate Name' : _name.text.trim();
    final des = _designation ?? 'Advocate';
    final barId = _barCouncil.text.trim().isEmpty ? 'BAR-ID: PENDING' : _barCouncil.text.trim().toUpperCase();
    final city = (_city ?? '').isEmpty ? 'City' : _city!;
    final state = (_state ?? '').isEmpty ? 'State' : _state!;
    final fee = _fee.text.trim().isEmpty ? '1000' : _fee.text.trim();
    final bio = _bio.text.trim().isEmpty
        ? 'Dedicated legal counsel providing fearless advocacy, rights awareness, and compassionate support.'
        : _bio.text.trim();

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECDD3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text('LIVE CLIENT PREVIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                ],
              ),
              const Text('PUBLIC PROFILE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WomenLawyerProfileCompletionScreen.primary),
                ),
                alignment: Alignment.center,
                child: Text(
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'L',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenLawyerProfileCompletionScreen.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: WomenLawyerProfileCompletionScreen.navy),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                      ],
                    ),
                    Text(des, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: WomenLawyerProfileCompletionScreen.primary)),
                    Text(barId, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: WomenLawyerProfileCompletionScreen.primary),
              const SizedBox(width: 4),
              Text('$city, $state', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _previewStat('Fee', '₹$fee'),
              _previewStat('Duration', '$_duration mins'),
              _previewStat('Experience', '${_years.text.isEmpty ? "0" : _years.text} Yrs'),
              _previewStat('Mode', _serviceMode),
            ],
          ),
          if (_practiceAreas.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text('Practice Areas', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _practiceAreas
                  .map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                        child: Text(a, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          const Text('About Advocate', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(bio, style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _previewStat(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
