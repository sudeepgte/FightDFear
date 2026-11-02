import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/funding_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/investor_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import 'investor_dashboard_screen.dart';

class InvestorProfileCompletionScreen extends StatefulWidget {
  const InvestorProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<InvestorProfileCompletionScreen> createState() =>
      _InvestorProfileCompletionScreenState();
}

class _InvestorProfileCompletionScreenState
    extends State<InvestorProfileCompletionScreen> {
  final _scrollController = ScrollController();

  // Section 0: Professional Profile Headshot
  String? _profilePhotoUrl;
  String? _selectedProfilePhotoPath;

  // Section 1: Business Profile & Credentials
  final _fullNameController = TextEditingController();
  final _designationController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _credentialNumberController = TextEditingController(); // PAN / SEBI / AIF
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();

  // Section 2: Address & Operations
  String? _state;
  final _stateOtherController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _mapLinkController = TextEditingController();
  double? _lat;
  double? _lng;

  // Section 3: Investment Thesis & Ticket Size
  final _categoriesOfferedController = TextEditingController();
  final _audienceController = TextEditingController();
  String _ticketMode = 'Angel'; // Angel, Seed, Series, Grant
  final _typicalPriceController = TextEditingController();

  // Section 4: Pitch Meeting & Call Slots
  final _openDaysController = TextEditingController(text: 'Mon-Fri');
  TimeOfDay? _openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? _closeTime = const TimeOfDay(hour: 18, minute: 0);

  // Section 5: Profile Bio & Mentorship Focus
  final _bioController = TextEditingController();

  // Section 6: Payout & Settlement Account
  String _payoutMode = 'UPI'; // 'UPI' or 'BANK'
  final _upiIdController = TextEditingController();
  final _bankAccountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _confirmAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankBranchController = TextEditingController();

  // Global Keys for section scrolling
  final _section0Key = GlobalKey();
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  final _section3Key = GlobalKey();
  final _section4Key = GlobalKey();
  final _section5Key = GlobalKey();
  final _section6Key = GlobalKey();

  final Map<String, String> _errors = {};

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _globalError;
  Map<String, dynamic> _profile = {};

  InvestorAuthService get _svc =>
      InvestorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fullNameController.dispose();
    _designationController.dispose();
    _companyNameController.dispose();
    _credentialNumberController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _stateOtherController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _mapLinkController.dispose();
    _categoriesOfferedController.dispose();
    _audienceController.dispose();
    _typicalPriceController.dispose();
    _openDaysController.dispose();
    _bioController.dispose();
    _upiIdController.dispose();
    _bankAccountHolderController.dispose();
    _bankNameController.dispose();
    _bankAccountNumberController.dispose();
    _confirmAccountNumberController.dispose();
    _bankIfscController.dispose();
    _bankBranchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _globalError = null;
    });
    try {
      final res = await _svc.profile();
      if (!mounted) return;
      if (res['success'] == true) {
        _applyProfile(Map<String, dynamic>.from(res));
        setState(() => _loading = false);
      } else {
        setState(() {
          _loading = false;
          _globalError = res['error']?.toString() ?? 'Failed to load profile';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _globalError = '$e';
        });
      }
    }
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    _profilePhotoUrl = p['profilePhoto']?.toString() ?? p['profileImageUrl']?.toString();
    _fullNameController.text = p['fullName']?.toString() ?? '';
    _designationController.text = p['designation']?.toString() ?? '';
    _companyNameController.text = p['companyName']?.toString() ?? '';
    _credentialNumberController.text = p['credentialNumber']?.toString() ?? '';
    _phoneController.text = p['phone']?.toString() ?? '';
    _whatsappController.text = p['whatsappNumber']?.toString() ?? '';

    // Location
    final st = p['state']?.toString() ?? '';
    if (FundingCatalog.indianStates.contains(st)) {
      _state = st;
    } else if (st.isNotEmpty) {
      _state = 'Other';
      _stateOtherController.text = st;
    }
    _cityController.text = p['city']?.toString() ?? p['preferredLocations']?.toString() ?? '';
    _pincodeController.text = p['pincode']?.toString() ?? '';
    _addressController.text = p['address']?.toString() ?? '';
    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');

    // Investment Thesis
    final cats = p['categoriesOffered'] ?? p['preferredCategories'];
    if (cats is List) {
      _categoriesOfferedController.text = cats.join(', ');
    } else {
      _categoriesOfferedController.text = cats?.toString() ?? '';
    }

    final aud = p['audience'];
    if (aud is List) {
      _audienceController.text = aud.join(', ');
    } else {
      _audienceController.text = aud?.toString() ?? '';
    }

    final mode = p['ticketMode']?.toString() ?? p['sessionMode']?.toString() ?? 'Angel';
    if (FundingCatalog.ticketModes.contains(mode)) {
      _ticketMode = mode;
    }

    final typical = p['typicalPrice'] ?? p['typicalCheque'];
    if (typical != null && typical != 0) {
      _typicalPriceController.text = '$typical';
    }

    // Availability
    final days = p['openDays'];
    if (days is List) {
      _openDaysController.text = days.join(', ');
    } else if (days != null && days.toString().isNotEmpty) {
      _openDaysController.text = days.toString();
    }
    _openTime = FundingCatalog.parseTime(p['openTime']?.toString()) ?? const TimeOfDay(hour: 9, minute: 0);
    _closeTime = FundingCatalog.parseTime(p['closeTime']?.toString()) ?? const TimeOfDay(hour: 18, minute: 0);

    // Bio
    _bioController.text = p['bio']?.toString() ?? p['investmentInterests']?.toString() ?? '';

    // Payout
    final upi = p['upiId']?.toString() ?? '';
    _upiIdController.text = upi;

    final details = p['bankDetails']?.toString() ?? '';
    if (details.contains('Account Holder:')) {
      for (final part in details.split('|')) {
        final pair = part.split(':');
        if (pair.length == 2) {
          final k = pair[0].trim().toLowerCase();
          final v = pair[1].trim();
          if (k.contains('holder') && _bankAccountHolderController.text.isEmpty) {
            _bankAccountHolderController.text = v;
          } else if (k.contains('bank') && _bankNameController.text.isEmpty) {
            _bankNameController.text = v;
          } else if (k.contains('a/c') && _bankAccountNumberController.text.isEmpty) {
            _bankAccountNumberController.text = v;
            _confirmAccountNumberController.text = v;
          } else if (k.contains('ifsc') && _bankIfscController.text.isEmpty) {
            _bankIfscController.text = v;
          } else if (k.contains('branch') && _bankBranchController.text.isEmpty) {
            _bankBranchController.text = v;
          }
        }
      }
      _payoutMode = 'BANK';
    } else {
      _payoutMode = upi.isNotEmpty ? 'UPI' : 'UPI';
    }
  }

  // ── 17 Criteria Live Status Calculation ───────────────────────────────────

  List<String> _calculateMissing() {
    final missing = <String>[];
    // 0. Profile photo
    if ((_profilePhotoUrl ?? '').isEmpty && (_selectedProfilePhotoPath ?? '').isEmpty) {
      missing.add('Professional profile headshot');
    }
    // 1. Full name
    if (_fullNameController.text.trim().length < 2) {
      missing.add('Full legal name');
    }
    // 2. Designation
    if (_designationController.text.trim().isEmpty) {
      missing.add('Role / Designation');
    }
    // 3. Company name
    if (_companyNameController.text.trim().isEmpty) {
      missing.add('Company / Fund name');
    }
    // 4. PAN / SEBI credential
    if (_credentialNumberController.text.trim().isEmpty) {
      missing.add('PAN / SEBI / AIF number');
    }
    // 5. Official phone
    if (!RegExp(r'^[0-9]{10}$').hasMatch(_phoneController.text.trim())) {
      missing.add('10-digit mobile phone');
    }
    // 6. Street address
    if (_addressController.text.trim().isEmpty) {
      missing.add('Street address');
    }
    // 7. City
    if (_cityController.text.trim().isEmpty) {
      missing.add('City');
    }
    // 8. State
    final st = _state == 'Other' ? _stateOtherController.text.trim() : (_state ?? '');
    if (st.isEmpty) {
      missing.add('State');
    }
    // 9. Pincode
    if (!RegExp(r'^[0-9]{6}$').hasMatch(_pincodeController.text.trim())) {
      missing.add('6-digit pincode');
    }
    // 10. Target sectors
    if (_categoriesOfferedController.text.trim().isEmpty) {
      missing.add('Target sectors');
    }
    // 11. Target audience
    if (_audienceController.text.trim().isEmpty) {
      missing.add('Who I fund');
    }
    // 12. Open days
    if (_openDaysController.text.trim().isEmpty) {
      missing.add('Meeting days');
    }
    // 13. Open time
    if (_openTime == null) {
      missing.add('Meeting start time');
    }
    // 14. Close time
    if (_closeTime == null) {
      missing.add('Meeting close time');
    }
    // 15. Bio (min 15 chars)
    if (_bioController.text.trim().length < 15) {
      missing.add('Bio & Criteria (min 15 characters)');
    }
    // 16. Typical cheque (> 0)
    final cheque = double.tryParse(_typicalPriceController.text.trim());
    if (cheque == null || cheque < 1000) {
      missing.add('Typical cheque size (min ₹1,000)');
    }

    return missing;
  }

  int get _completionPct {
    final missing = _calculateMissing();
    final completed = 17 - missing.length;
    return ((completed * 100) / 17).round().clamp(0, 100);
  }

  // ── Validation for Form Submission ────────────────────────────────────────

  bool _validateForm({bool forSubmit = false}) {
    final errs = <String, String>{};
    GlobalKey? firstInvalidSection;

    if (forSubmit && (_profilePhotoUrl ?? '').isEmpty && (_selectedProfilePhotoPath ?? '').isEmpty) {
      errs['photo'] = 'Profile photo is required';
      firstInvalidSection ??= _section0Key;
    }

    if (_fullNameController.text.trim().isEmpty) {
      errs['fullName'] = 'Full name is required';
      firstInvalidSection ??= _section1Key;
    }

    if (_designationController.text.trim().isEmpty) {
      errs['designation'] = 'Role / Designation is required';
      firstInvalidSection ??= _section1Key;
    }

    if (_companyNameController.text.trim().isEmpty) {
      errs['companyName'] = 'Company or fund name is required';
      firstInvalidSection ??= _section1Key;
    }

    final cred = _credentialNumberController.text.trim();
    if (cred.isEmpty) {
      errs['credentialNumber'] = '10-digit PAN or SEBI Registration Number is required';
      firstInvalidSection ??= _section1Key;
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      errs['phone'] = 'Mobile phone is required';
      firstInvalidSection ??= _section1Key;
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      errs['phone'] = 'Enter a valid 10-digit mobile number';
      firstInvalidSection ??= _section1Key;
    }

    final whatsapp = _whatsappController.text.trim();
    if (whatsapp.isNotEmpty && !RegExp(r'^[0-9]{10}$').hasMatch(whatsapp)) {
      errs['whatsapp'] = 'WhatsApp number must be 10 digits';
      firstInvalidSection ??= _section1Key;
    }

    final st = _state == 'Other' ? _stateOtherController.text.trim() : (_state ?? '');
    if (st.isEmpty) {
      errs['state'] = 'State is required';
      firstInvalidSection ??= _section2Key;
    }

    if (_cityController.text.trim().isEmpty) {
      errs['city'] = 'City is required';
      firstInvalidSection ??= _section2Key;
    }

    final pincode = _pincodeController.text.trim();
    if (pincode.isEmpty) {
      errs['pincode'] = 'Pincode is required';
      firstInvalidSection ??= _section2Key;
    } else if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode)) {
      errs['pincode'] = 'Enter a valid 6-digit Indian pincode';
      firstInvalidSection ??= _section2Key;
    }

    if (_addressController.text.trim().isEmpty) {
      errs['address'] = 'Street address is required';
      firstInvalidSection ??= _section2Key;
    }

    if (_categoriesOfferedController.text.trim().isEmpty) {
      errs['categoriesOffered'] = 'Target sectors are required';
      firstInvalidSection ??= _section3Key;
    }

    if (_audienceController.text.trim().isEmpty) {
      errs['audience'] = 'Target audience is required';
      firstInvalidSection ??= _section3Key;
    }

    final cheque = double.tryParse(_typicalPriceController.text.trim());
    if (cheque == null || cheque < 1000) {
      errs['typicalPrice'] = 'Cheque size must be at least ₹1,000';
      firstInvalidSection ??= _section3Key;
    }

    if (_openDaysController.text.trim().isEmpty) {
      errs['openDays'] = 'Available days are required (e.g. Mon-Fri)';
      firstInvalidSection ??= _section4Key;
    }

    if (_openTime == null || _closeTime == null) {
      errs['timeSlots'] = 'Meeting time slots are required';
      firstInvalidSection ??= _section4Key;
    }

    final bio = _bioController.text.trim();
    if (bio.isEmpty) {
      errs['bio'] = 'Bio is required';
      firstInvalidSection ??= _section5Key;
    } else if (bio.length < 15) {
      errs['bio'] = 'Bio must be at least 15 characters';
      firstInvalidSection ??= _section5Key;
    }

    setState(() => _errors
      ..clear()
      ..addAll(errs));

    if (errs.isNotEmpty && firstInvalidSection != null) {
      final context = firstInvalidSection.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildPayload() {
    final state = _state == 'Other' ? _stateOtherController.text.trim() : (_state ?? '');

    final payload = <String, dynamic>{
      'fullName': _fullNameController.text.trim(),
      'designation': _designationController.text.trim(),
      'companyName': _companyNameController.text.trim(),
      'credentialNumber': _credentialNumberController.text.trim().toUpperCase(),
      'phone': _phoneController.text.trim(),
      'whatsappNumber': _whatsappController.text.trim(),
      'state': state,
      'city': _cityController.text.trim(),
      'preferredLocations': _cityController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'address': _addressController.text.trim(),
      'latitude': _lat,
      'longitude': _lng,
      'categoriesOffered': _categoriesOfferedController.text.trim(),
      'preferredCategories': _categoriesOfferedController.text.trim(),
      'audience': _audienceController.text.trim(),
      'ticketMode': _ticketMode,
      'sessionMode': _ticketMode,
      'typicalPrice': double.tryParse(_typicalPriceController.text.trim()),
      'typicalCheque': double.tryParse(_typicalPriceController.text.trim()),
      'openDays': _openDaysController.text.trim(),
      'openTime': _openTime != null ? FundingCatalog.formatTime(_openTime!) : '09:00',
      'closeTime': _closeTime != null ? FundingCatalog.formatTime(_closeTime!) : '18:00',
      'bio': _bioController.text.trim(),
      'investmentInterests': _bioController.text.trim(),
    };

    if (_payoutMode == 'UPI') {
      payload['upiId'] = _upiIdController.text.trim();
    } else {
      payload['bankAccountHolder'] = _bankAccountHolderController.text.trim();
      payload['bankName'] = _bankNameController.text.trim();
      payload['bankAccountNumber'] = _bankAccountNumberController.text.trim();
      payload['bankIfsc'] = _bankIfscController.text.trim().toUpperCase();
      payload['bankBranch'] = _bankBranchController.text.trim();
    }

    return payload;
  }

  Future<void> _saveDraft() async {
    setState(() {
      _saving = true;
      _globalError = null;
    });
    try {
      if (_selectedProfilePhotoPath != null) {
        await _svc.uploadPhotos(profilePath: _selectedProfilePhotoPath);
      }
      final res = await _svc.updateProfile(_buildPayload());
      if (res['success'] != true) {
        throw Exception(res['error']?.toString() ?? 'Failed to save profile');
      }
      if (mounted) {
        _applyProfile(Map<String, dynamic>.from(res));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Investor profile draft saved!'),
            backgroundColor: Colors.teal,
          ),
        );
        _finish();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _globalError = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _finish() {
    if (!mounted) return;
    if (widget.onFinished != null) {
      widget.onFinished!(context);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const InvestorDashboardScreen()),
        (_) => false,
      );
    }
  }

  void _skip() => _finish();

  Future<void> _submitForVerification() async {
    final valid = _validateForm(forSubmit: true);
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all 17 required items before submitting.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
      _globalError = null;
    });
    try {
      if (_selectedProfilePhotoPath != null) {
        await _svc.uploadPhotos(profilePath: _selectedProfilePhotoPath);
      }
      final updateRes = await _svc.updateProfile(_buildPayload());
      if (updateRes['success'] != true) {
        throw Exception(updateRes['error']?.toString() ?? 'Failed to update profile');
      }
      final submitRes = await _svc.submitVerification();
      if (submitRes['success'] != true) {
        throw Exception(submitRes['error']?.toString() ?? 'Verification submission failed');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Investor profile submitted for Admin Verification!'),
            backgroundColor: Colors.green,
          ),
        );
        _finish();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _globalError = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() {
        _selectedProfilePhotoPath = image.path;
        _errors.remove('photo');
      });
    }
  }

  Future<void> _selectTime(bool isOpenTime) async {
    final initial = isOpenTime ? _openTime : _closeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complete Profile')),
        body: ModuleTheme.loading(),
      );
    }

    final missing = _calculateMissing();
    final pct = _completionPct;
    final status = _profile['partnerProfileStatusLabel']?.toString() ??
        _profile['partnerProfileStatus']?.toString() ??
        'Incomplete';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Investor Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: InvestorProfileCompletionScreen.navy,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _skip,
        ),
        actions: ProfileCompletionActions.appBar(
          onSkip: (_loading || _saving || _submitting) ? null : _skip,
          onSave: (_loading || _saving || _submitting) ? null : _saveDraft,
          saving: _saving,
        ),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            if (_globalError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDA4AF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFBE123C)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _globalError!,
                        style: const TextStyle(
                            color: Color(0xFFBE123C), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── TOP PROGRESS CARD ───────────────────────────────────────────
            _buildProgressCard(pct, status, missing),
            const SizedBox(height: 16),

            // ── SECTION 0: HEADSHOT ─────────────────────────────────────────
            Container(key: _section0Key, child: _buildSection0()),
            const SizedBox(height: 16),

            // ── SECTION 1: BUSINESS PROFILE & CREDENTIALS ───────────────────
            Container(key: _section1Key, child: _buildSection1()),
            const SizedBox(height: 16),

            // ── SECTION 2: ADDRESS & OPERATIONS ─────────────────────────────
            Container(key: _section2Key, child: _buildSection2()),
            const SizedBox(height: 16),

            // ── SECTION 3: INVESTMENT THESIS & TICKET SIZE ──────────────────
            Container(key: _section3Key, child: _buildSection3()),
            const SizedBox(height: 16),

            // ── SECTION 4: PITCH MEETING & CALL SLOTS ───────────────────────
            Container(key: _section4Key, child: _buildSection4()),
            const SizedBox(height: 16),

            // ── SECTION 5: PROFILE BIO & MENTORSHIP FOCUS ───────────────────
            Container(key: _section5Key, child: _buildSection5()),
            const SizedBox(height: 16),

            // ── SECTION 6: PAYOUT & SETTLEMENT ACCOUNT ──────────────────────
            Container(key: _section6Key, child: _buildSection6()),
            const SizedBox(height: 24),

            // ── ACTION BUTTONS ──────────────────────────────────────────────
            _buildActionButtons(pct == 100),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Progress Card ─────────────────────────────────────────────────────────

  Widget _buildProgressCard(int pct, String status, List<String> missing) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$pct% Completed (${17 - missing.length} / 17 items)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: InvestorProfileCompletionScreen.navy,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pct == 100 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: pct == 100 ? const Color(0xFF166534) : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct / 100.0,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                pct == 100 ? const Color(0xFF10B981) : InvestorProfileCompletionScreen.primary,
              ),
            ),
          ),
          if (missing.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Required for Admin Verification:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: missing.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, size: 6, color: Color(0xFFF43F5E)),
                      const SizedBox(width: 5),
                      Text(item, style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── SECTION 0: HEADSHOT ───────────────────────────────────────────────────

  Widget _buildSection0() {
    return _buildCard(
      title: '0. Professional Profile Headshot',
      subtitle: 'Verified investor photo for compliance and network trust',
      icon: Icons.camera_alt_outlined,
      children: [
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfilePhoto,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: const Color(0xFFF1F5F9),
                      backgroundImage: _selectedProfilePhotoPath != null
                          ? null
                          : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                              ? NetworkImage(_profilePhotoUrl!)
                              : null) as ImageProvider?,
                      child: (_selectedProfilePhotoPath == null &&
                              (_profilePhotoUrl == null || _profilePhotoUrl!.isEmpty))
                          ? const Icon(Icons.person, size: 42, color: Color(0xFF94A3B8))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: InvestorProfileCompletionScreen.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Professional Portrait *',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              if (_errors.containsKey('photo'))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _errors['photo']!,
                    style: const TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── SECTION 1: BUSINESS PROFILE & CREDENTIALS ─────────────────────────────

  Widget _buildSection1() {
    return _buildCard(
      title: '1. Business Profile & Credentials',
      subtitle: 'Investor identity and accreditation credentials',
      icon: Icons.badge_outlined,
      children: [
        _buildTextField(
          label: 'Full Name *',
          controller: _fullNameController,
          placeholder: 'Your full legal name',
          errorText: _errors['fullName'],
          helperText: 'Your name as per SEBI / PAN documentation',
          onChanged: (_) => setState(() => _errors.remove('fullName')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Role / Designation *',
          controller: _designationController,
          placeholder: 'e.g. Managing Partner / Angel Investor',
          errorText: _errors['designation'],
          helperText: 'Your current investment position or title',
          onChanged: (_) => setState(() => _errors.remove('designation')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Company / Fund Name *',
          controller: _companyNameController,
          placeholder: 'e.g. Apex Capital Ventures',
          errorText: _errors['companyName'],
          helperText: 'Investment firm, syndicate or family office name',
          onChanged: (_) => setState(() => _errors.remove('companyName')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'PAN / SEBI / AIF ID *',
          controller: _credentialNumberController,
          placeholder: '10-digit PAN or SEBI Registration Number',
          textCapitalization: TextCapitalization.characters,
          errorText: _errors['credentialNumber'],
          helperText: 'Accreditation reference for compliance verification',
          onChanged: (_) => setState(() => _errors.remove('credentialNumber')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Mobile Phone *',
          controller: _phoneController,
          placeholder: '10-digit mobile number',
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['phone'],
          helperText: '10 digits for OTP and deal communications',
          onChanged: (_) => setState(() => _errors.remove('phone')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'WhatsApp Number (Optional)',
          controller: _whatsappController,
          placeholder: '10-digit WhatsApp number',
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['whatsapp'],
          helperText: 'Instant notifications and entrepreneur chats',
          onChanged: (_) => setState(() => _errors.remove('whatsapp')),
        ),
      ],
    );
  }

  // ── SECTION 2: ADDRESS & OPERATIONS ───────────────────────────────────────

  Widget _buildSection2() {
    return _buildCard(
      title: '2. Address & Operations',
      subtitle: 'Office location and operating region',
      icon: Icons.location_on_outlined,
      children: [
        const Text(
          'Country',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Text('India', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        const SizedBox(height: 12),

        _buildDropdown(
          label: 'State *',
          value: _state,
          items: FundingCatalog.indianStates,
          errorText: _errors['state'],
          helperText: 'State where your investment office is registered',
          onChanged: (val) {
            setState(() {
              _state = val;
              _errors.remove('state');
            });
          },
        ),
        if (_state == 'Other') ...[
          const SizedBox(height: 8),
          _buildTextField(
            label: 'Enter State *',
            controller: _stateOtherController,
            placeholder: 'e.g. Specific Territory',
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: 12),

        _buildTextField(
          label: 'City *',
          controller: _cityController,
          placeholder: 'e.g. Mumbai, Bengaluru, Delhi',
          errorText: _errors['city'],
          helperText: 'Primary operating city',
          onChanged: (_) => setState(() => _errors.remove('city')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Pincode *',
          controller: _pincodeController,
          placeholder: '6-digit Pincode',
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['pincode'],
          helperText: '6-digit Indian Postal Code',
          onChanged: (_) => setState(() => _errors.remove('pincode')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Street Address *',
          controller: _addressController,
          placeholder: 'Office/Suite No, Building Name, Street, Landmark',
          errorText: _errors['address'],
          helperText: 'Full physical office or correspondence address',
          onChanged: (_) => setState(() => _errors.remove('address')),
        ),
        const SizedBox(height: 12),

        ProfileLocationPicker(
          lat: _lat,
          lng: _lng,
          mapLinkController: _mapLinkController,
          onPinned: (lat, lng) {
            setState(() {
              _lat = lat;
              _lng = lng;
            });
          },
        ),
      ],
    );
  }

  // ── SECTION 3: INVESTMENT THESIS & TICKET SIZE ────────────────────────────

  Widget _buildSection3() {
    return _buildCard(
      title: '3. Investment Thesis & Ticket Size',
      subtitle: 'Cheque size, sectors and funding stages',
      icon: Icons.monetization_on_outlined,
      children: [
        _buildTextField(
          label: 'Target Sectors *',
          controller: _categoriesOfferedController,
          placeholder: 'e.g. Tech, Retail, Apparel, Handicrafts, Healthcare',
          errorText: _errors['categoriesOffered'],
          helperText: 'Industries and venture categories you actively fund',
          onChanged: (_) => setState(() => _errors.remove('categoriesOffered')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Target Audience / Who I Fund *',
          controller: _audienceController,
          placeholder: 'e.g. Women Founders, Early-stage D2C, Tech Startups',
          errorText: _errors['audience'],
          helperText: 'Founder personas, demographics, or business models',
          onChanged: (_) => setState(() => _errors.remove('audience')),
        ),
        const SizedBox(height: 12),

        _buildDropdown(
          label: 'Investment Stage *',
          value: _ticketMode,
          items: FundingCatalog.ticketModes,
          helperText: 'Preferred investment vehicle or stage',
          onChanged: (val) {
            if (val != null) setState(() => _ticketMode = val);
          },
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Typical Cheque / Budget (₹) *',
          controller: _typicalPriceController,
          placeholder: 'e.g. 50000',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['typicalPrice'],
          helperText: 'Average or starting investment ticket (Minimum ₹1,000)',
          onChanged: (_) => setState(() => _errors.remove('typicalPrice')),
        ),
      ],
    );
  }

  // ── SECTION 4: PITCH MEETING & CALL SLOTS ─────────────────────────────────

  Widget _buildSection4() {
    return _buildCard(
      title: '4. Pitch Meeting & Call Slots',
      subtitle: 'Calendar availability for entrepreneur pitch discussions',
      icon: Icons.calendar_today_outlined,
      children: [
        _buildTextField(
          label: 'Available Days *',
          controller: _openDaysController,
          placeholder: 'e.g. Mon-Fri or Monday, Wednesday, Friday',
          errorText: _errors['openDays'],
          helperText: 'Days open for 1-on-1 pitch presentations',
          onChanged: (_) => setState(() => _errors.remove('openDays')),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Start Time *',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () => _selectTime(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(_openTime != null ? _openTime!.format(context) : '09:00 AM'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('End Time *',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () => _selectTime(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(_closeTime != null ? _closeTime!.format(context) : '06:00 PM'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── SECTION 5: PROFILE BIO & MENTORSHIP FOCUS ─────────────────────────────

  Widget _buildSection5() {
    return _buildCard(
      title: '5. Profile Bio & Mentorship Focus',
      subtitle: 'Investment criteria, background and value-add',
      icon: Icons.edit_note_outlined,
      children: [
        _buildTextField(
          label: 'Bio & Investment Criteria *',
          controller: _bioController,
          placeholder:
              'Briefly introduce your investment criteria, background, support, and mentorship expertise...',
          maxLines: 4,
          errorText: _errors['bio'],
          helperText: 'Introduction visible to entrepreneurs (Minimum 15 characters)',
          onChanged: (_) => setState(() => _errors.remove('bio')),
        ),
      ],
    );
  }

  // ── SECTION 6: PAYOUT & SETTLEMENT ACCOUNT ────────────────────────────────

  Widget _buildSection6() {
    return _buildCard(
      title: '6. Payout & Settlement Account',
      subtitle: 'Receiving returns, escrow refunds and settlements',
      icon: Icons.account_balance_outlined,
      children: [
        const Text(
          'Select Settlement Method',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('UPI ID')),
                selected: _payoutMode == 'UPI',
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _payoutMode == 'UPI'
                      ? InvestorProfileCompletionScreen.primary
                      : const Color(0xFF475569),
                ),
                onSelected: (val) {
                  if (val) setState(() => _payoutMode = 'UPI');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('Bank Account')),
                selected: _payoutMode == 'BANK',
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _payoutMode == 'BANK'
                      ? InvestorProfileCompletionScreen.primary
                      : const Color(0xFF475569),
                ),
                onSelected: (val) {
                  if (val) setState(() => _payoutMode = 'BANK');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (_payoutMode == 'UPI') ...[
          _buildTextField(
            label: 'UPI ID',
            controller: _upiIdController,
            placeholder: 'e.g. username@okhdfcbank',
            helperText: 'Virtual Payment Address for returns/refund settlements',
          ),
        ] else ...[
          _buildTextField(
            label: 'Account Holder Name',
            controller: _bankAccountHolderController,
            placeholder: 'Name as per bank records',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Bank Name',
            controller: _bankNameController,
            placeholder: 'e.g. HDFC Bank, ICICI Bank, SBI',
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Bank Account Number',
            controller: _bankAccountNumberController,
            placeholder: 'Enter bank account number (9 to 18 digits)',
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 18,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(18)],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Confirm Account Number',
            controller: _confirmAccountNumberController,
            placeholder: 'Re-enter bank account number',
            keyboardType: TextInputType.number,
            maxLength: 18,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(18)],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'IFSC Code',
            controller: _bankIfscController,
            placeholder: 'e.g. HDFC0001234',
            textCapitalization: TextCapitalization.characters,
            maxLength: 11,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Branch Name',
            controller: _bankBranchController,
            placeholder: 'e.g. Nariman Point Branch',
          ),
        ],
      ],
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons(bool isComplete) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (_saving || _submitting) ? null : _submitForVerification,
            style: ElevatedButton.styleFrom(
              backgroundColor: isComplete
                  ? const Color(0xFF10B981)
                  : InvestorProfileCompletionScreen.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _submitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isComplete ? 'Submit for Admin Verification' : 'Verify & Submit Profile',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: (_saving || _submitting) ? null : _saveDraft,
            style: OutlinedButton.styleFrom(
              foregroundColor: InvestorProfileCompletionScreen.navy,
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, size: 18),
                      SizedBox(width: 6),
                      Text('Save Draft', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ── UI Helpers ────────────────────────────────────────────────────────────

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: InvestorProfileCompletionScreen.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: InvestorProfileCompletionScreen.navy,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? placeholder,
    String? helperText,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: errorText != null ? const Color(0xFFE11D48) : const Color(0xFFCBD5E1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: InvestorProfileCompletionScreen.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(fontSize: 11, color: Color(0xFFE11D48), fontWeight: FontWeight.w500),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? helperText,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null ? const Color(0xFFE11D48) : const Color(0xFFCBD5E1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.contains(value) ? value : null,
              hint: const Text('Select an option', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText,
            style: const TextStyle(fontSize: 11, color: Color(0xFFE11D48), fontWeight: FontWeight.w500),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ],
    );
  }
}
