import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/funding_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/entrepreneur_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import 'entrepreneur_dashboard_screen.dart';

class EntrepreneurProfileCompletionScreen extends StatefulWidget {
  const EntrepreneurProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<EntrepreneurProfileCompletionScreen> createState() =>
      _EntrepreneurProfileCompletionScreenState();
}

class _EntrepreneurProfileCompletionScreenState
    extends State<EntrepreneurProfileCompletionScreen> {
  final _scrollController = ScrollController();

  // Section 1: Business Identity & Founder Details
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  String? _businessCategory;
  final _businessCategoryOtherController = TextEditingController();
  final _designationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _dobController = TextEditingController();
  String? _profilePhotoUrl;
  String? _selectedProfilePhotoPath;

  // Section 2: Location & Operations
  String? _state;
  final _stateOtherController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _businessLocationController = TextEditingController();
  final _mapLinkController = TextEditingController();
  double? _lat;
  double? _lng;

  // Section 3: Financial & Investment Details
  final _investmentNeededController = TextEditingController();
  final _expectedMonthlyIncomeController = TextEditingController();
  final _businessExperienceController = TextEditingController();

  // Section 4: Identity & Legal Verification
  final _aadhaarNumberController = TextEditingController();
  final _panNumberController = TextEditingController();

  // Section 5: Business Overview & Pitch Deck
  final _businessDescriptionController = TextEditingController();
  String? _pitchDeckPath;
  String? _selectedPitchDeckPath;
  List<String> _galleryPhotos = [];
  final List<String> _selectedGalleryPhotos = [];

  // Section 6: Payout & Disbursement Details
  String _payoutMode = 'UPI'; // 'UPI' or 'BANK'
  final _upiIdController = TextEditingController();
  final _bankAccountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _confirmAccountNumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _bankBranchController = TextEditingController();

  // Global Keys for scrolling to invalid sections/fields
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  final _section3Key = GlobalKey();
  final _section4Key = GlobalKey();
  final _section5Key = GlobalKey();
  final _section6Key = GlobalKey();

  // Field errors map
  final Map<String, String> _errors = {};

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _globalError;
  Map<String, dynamic> _profile = {};

  EntrepreneurAuthService get _svc =>
      EntrepreneurAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fullNameController.dispose();
    _businessNameController.dispose();
    _businessCategoryOtherController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _dobController.dispose();
    _stateOtherController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _businessLocationController.dispose();
    _mapLinkController.dispose();
    _investmentNeededController.dispose();
    _expectedMonthlyIncomeController.dispose();
    _businessExperienceController.dispose();
    _aadhaarNumberController.dispose();
    _panNumberController.dispose();
    _businessDescriptionController.dispose();
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
    _fullNameController.text = p['fullName']?.toString() ?? '';
    final bName = p['businessName']?.toString() ?? '';
    _businessNameController.text =
        bName.toLowerCase() == 'pending profile completion' ? '' : bName;

    // Category
    final cat = p['businessCategory']?.toString() ?? '';
    if (FundingCatalog.entrepreneurBusinessCategories.contains(cat)) {
      _businessCategory = cat;
    } else if (cat.isNotEmpty) {
      _businessCategory = 'Other';
      _businessCategoryOtherController.text = cat;
    }

    _designationController.text = p['designation']?.toString() ?? '';
    _emailController.text = p['email']?.toString() ?? '';
    _phoneController.text = p['phone']?.toString() ?? '';
    _whatsappController.text = p['whatsappNumber']?.toString() ?? '';
    _dobController.text = p['dob']?.toString() ?? '';
    _profilePhotoUrl = p['profilePhoto']?.toString() ?? p['profileImageUrl']?.toString();

    // Location
    final st = p['state']?.toString() ?? '';
    if (FundingCatalog.indianStates.contains(st)) {
      _state = st;
    } else if (st.isNotEmpty) {
      _state = 'Other';
      _stateOtherController.text = st;
    }
    _cityController.text = p['city']?.toString() ?? '';
    _pincodeController.text = p['pincode']?.toString() ?? '';
    final loc = p['businessLocation']?.toString() ?? p['address']?.toString() ?? '';
    _businessLocationController.text =
        loc.toLowerCase() == 'pending' ? '' : loc;

    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');

    // Financial
    if (p['investmentNeeded'] != null && (p['investmentNeeded'] as num) > 0) {
      _investmentNeededController.text = '${p['investmentNeeded']}';
    }
    if (p['expectedMonthlyIncome'] != null && (p['expectedMonthlyIncome'] as num) > 0) {
      _expectedMonthlyIncomeController.text = '${p['expectedMonthlyIncome']}';
    }
    if (p['businessExperience'] != null) {
      _businessExperienceController.text = '${p['businessExperience']}';
    }

    // Identity
    _aadhaarNumberController.text = p['aadhaarNumber']?.toString() ?? '';
    _panNumberController.text = p['panNumber']?.toString() ?? p['credentialNumber']?.toString() ?? '';

    // Description
    final desc = p['businessDescription']?.toString() ?? p['bio']?.toString() ?? '';
    _businessDescriptionController.text =
        desc.toLowerCase().contains('profile pending completion') ? '' : desc;

    _pitchDeckPath = p['documentsPath']?.toString() ?? p['pitchDeckPath']?.toString();
    _galleryPhotos = FundingCatalog.splitCsv(p['galleryPhotos'] ?? p['photosPath']);

    // Payout
    final upi = p['upiId']?.toString() ?? '';
    _upiIdController.text = upi;
    final bNameField = p['bankName']?.toString() ?? '';
    final accNo = p['accountNumber']?.toString() ?? '';
    final ifsc = p['ifscCode']?.toString() ?? '';
    _bankNameController.text = bNameField;
    _bankAccountNumberController.text = accNo;
    _confirmAccountNumberController.text = accNo;
    _bankIfscController.text = ifsc;

    // Parse bank details string if available
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
    }

    if (accNo.isNotEmpty || bNameField.isNotEmpty) {
      _payoutMode = 'BANK';
    } else {
      _payoutMode = 'UPI';
    }
  }

  // ── 16 Criteria Live Status Calculation ───────────────────────────────────

  List<String> _calculateMissing() {
    final missing = <String>[];
    // 1. Profile photo
    if ((_profilePhotoUrl ?? '').isEmpty && (_selectedProfilePhotoPath ?? '').isEmpty) {
      missing.add('Founder headshot / logo photo');
    }
    // 2. Full name (min 2 chars)
    if (_fullNameController.text.trim().length < 2) {
      missing.add('Full name (min 2 characters)');
    }
    // 3. Business name (min 2 chars, not placeholder)
    final bName = _businessNameController.text.trim();
    if (bName.length < 2 || bName.toLowerCase() == 'pending profile completion') {
      missing.add('Business venture name (min 2 characters)');
    }
    // 4. Business category
    final cat = _businessCategory == 'Other'
        ? _businessCategoryOtherController.text.trim()
        : (_businessCategory ?? '');
    if (cat.isEmpty) {
      missing.add('Business category');
    }
    // 5. Account email
    final email = _emailController.text.trim();
    if (!RegExp(r'^[A-Za-z0-9+_.-]+@(.+)$').hasMatch(email)) {
      missing.add('Valid account email');
    }
    // 6. Mobile phone (10 digits)
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      missing.add('10-digit mobile phone');
    }
    // 7. Street address / landmark (min 3 chars, not placeholder)
    final loc = _businessLocationController.text.trim();
    if (loc.length < 3 || loc.toLowerCase() == 'pending') {
      missing.add('Street address / landmark');
    }
    // 8. State
    final st = _state == 'Other' ? _stateOtherController.text.trim() : (_state ?? '');
    if (st.isEmpty) {
      missing.add('Operating state');
    }
    // 9. City
    if (_cityController.text.trim().isEmpty) {
      missing.add('City');
    }
    // 10. Pincode (6 digits)
    if (!RegExp(r'^[0-9]{6}$').hasMatch(_pincodeController.text.trim())) {
      missing.add('6-digit pincode');
    }
    // 11. Funding required (> 0)
    final needed = double.tryParse(_investmentNeededController.text.trim());
    if (needed == null || needed < 1000) {
      missing.add('Funding required (min ₹1,000)');
    }
    // 12. Expected monthly income (> 0)
    final income = double.tryParse(_expectedMonthlyIncomeController.text.trim());
    if (income == null || income < 100) {
      missing.add('Expected monthly revenue (min ₹100)');
    }
    // 13. Business experience (>= 0)
    final exp = int.tryParse(_businessExperienceController.text.trim());
    if (exp == null || exp < 0) {
      missing.add('Business experience (years)');
    }
    // 14. Aadhaar number (12 digits)
    if (!RegExp(r'^[0-9]{12}$').hasMatch(_aadhaarNumberController.text.trim())) {
      missing.add('12-digit Aadhaar number');
    }
    // 15. Business description (min 10 chars, not placeholder)
    final desc = _businessDescriptionController.text.trim();
    if (desc.length < 10 || desc.toLowerCase().contains('profile pending completion')) {
      missing.add('Business description & vision (min 10 chars)');
    }
    // 16. Payout info: valid UPI ID OR complete valid Bank Details
    final hasUpi = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$')
        .hasMatch(_upiIdController.text.trim());
    final hasBank = RegExp(r'^[0-9]{9,18}$')
            .hasMatch(_bankAccountNumberController.text.trim()) &&
        RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
            .hasMatch(_bankIfscController.text.trim().toUpperCase());
    if (!hasUpi && !hasBank) {
      missing.add('Payout details (valid UPI ID or Bank account with IFSC)');
    }

    return missing;
  }

  int get _completionPct {
    final missing = _calculateMissing();
    final completed = 16 - missing.length;
    return ((completed * 100) / 16).round().clamp(0, 100);
  }

  // ── Validation for fields ─────────────────────────────────────────────────

  bool _validateForm({bool forSubmit = false}) {
    final errs = <String, String>{};
    GlobalKey? firstInvalidSection;

    // Full name
    if (_fullNameController.text.trim().isEmpty) {
      errs['fullName'] = 'Full name is required';
      firstInvalidSection ??= _section1Key;
    } else if (_fullNameController.text.trim().length < 2) {
      errs['fullName'] = 'Full name must be at least 2 characters';
      firstInvalidSection ??= _section1Key;
    }

    // Business name
    final bName = _businessNameController.text.trim();
    if (bName.isEmpty || bName.toLowerCase() == 'pending profile completion') {
      errs['businessName'] = 'Business name is required';
      firstInvalidSection ??= _section1Key;
    } else if (bName.length < 2) {
      errs['businessName'] = 'Business name must be at least 2 characters';
      firstInvalidSection ??= _section1Key;
    }

    // Category
    final cat = _businessCategory == 'Other'
        ? _businessCategoryOtherController.text.trim()
        : (_businessCategory ?? '');
    if (cat.isEmpty) {
      errs['businessCategory'] = 'Please select a business category';
      firstInvalidSection ??= _section1Key;
    }

    // Email
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      errs['email'] = 'Email address is required';
      firstInvalidSection ??= _section1Key;
    } else if (!RegExp(r'^[A-Za-z0-9+_.-]+@(.+)$').hasMatch(email)) {
      errs['email'] = 'Enter a valid email address';
      firstInvalidSection ??= _section1Key;
    }

    // Phone
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      errs['phone'] = 'Mobile phone is required';
      firstInvalidSection ??= _section1Key;
    } else if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(phone)) {
      errs['phone'] = 'Enter a valid 10-digit mobile number starting with 6-9';
      firstInvalidSection ??= _section1Key;
    }

    // WhatsApp (optional, but validate format if entered)
    final whatsapp = _whatsappController.text.trim();
    if (whatsapp.isNotEmpty && !RegExp(r'^[0-9]{10}$').hasMatch(whatsapp)) {
      errs['whatsapp'] = 'WhatsApp number must be 10 digits';
      firstInvalidSection ??= _section1Key;
    }

    // State
    final st = _state == 'Other' ? _stateOtherController.text.trim() : (_state ?? '');
    if (st.isEmpty) {
      errs['state'] = 'Please select a state';
      firstInvalidSection ??= _section2Key;
    }

    // City
    if (_cityController.text.trim().isEmpty) {
      errs['city'] = 'City is required';
      firstInvalidSection ??= _section2Key;
    }

    // Pincode
    final pincode = _pincodeController.text.trim();
    if (pincode.isEmpty) {
      errs['pincode'] = 'Pincode is required';
      firstInvalidSection ??= _section2Key;
    } else if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(pincode)) {
      errs['pincode'] = 'Enter a valid 6-digit Indian pincode';
      firstInvalidSection ??= _section2Key;
    }

    // Location
    final loc = _businessLocationController.text.trim();
    if (loc.isEmpty || loc.toLowerCase() == 'pending') {
      errs['location'] = 'Street address / landmark is required';
      firstInvalidSection ??= _section2Key;
    } else if (loc.length < 3) {
      errs['location'] = 'Street address must be at least 3 characters';
      firstInvalidSection ??= _section2Key;
    }

    // Investment needed
    final needed = double.tryParse(_investmentNeededController.text.trim());
    if (needed == null || needed < 1000) {
      errs['investmentNeeded'] = 'Funding required must be at least ₹1,000';
      firstInvalidSection ??= _section3Key;
    }

    // Expected income
    final income = double.tryParse(_expectedMonthlyIncomeController.text.trim());
    if (income == null || income < 100) {
      errs['expectedMonthlyIncome'] = 'Expected monthly income must be at least ₹100';
      firstInvalidSection ??= _section3Key;
    }

    // Experience
    final exp = int.tryParse(_businessExperienceController.text.trim());
    if (exp == null || exp < 0 || exp > 60) {
      errs['businessExperience'] = 'Enter experience between 0 and 60 years';
      firstInvalidSection ??= _section3Key;
    }

    // Aadhaar
    final aadhaar = _aadhaarNumberController.text.trim();
    if (aadhaar.isEmpty) {
      errs['aadhaar'] = 'Aadhaar number is required for verification';
      firstInvalidSection ??= _section4Key;
    } else if (!RegExp(r'^[0-9]{12}$').hasMatch(aadhaar)) {
      errs['aadhaar'] = 'Aadhaar number must be exactly 12 digits';
      firstInvalidSection ??= _section4Key;
    }

    // PAN (optional, but validate format if present)
    final pan = _panNumberController.text.trim().toUpperCase();
    if (pan.isNotEmpty && !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(pan)) {
      errs['pan'] = 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
      firstInvalidSection ??= _section4Key;
    }

    // Description
    final desc = _businessDescriptionController.text.trim();
    if (desc.isEmpty || desc.toLowerCase().contains('profile pending completion')) {
      errs['description'] = 'Business description is required';
      firstInvalidSection ??= _section5Key;
    } else if (desc.length < 10) {
      errs['description'] = 'Description must be at least 10 characters';
      firstInvalidSection ??= _section5Key;
    }

    // Payout details
    if (_payoutMode == 'UPI') {
      final upi = _upiIdController.text.trim();
      if (upi.isEmpty) {
        errs['upi'] = 'UPI ID is required';
        firstInvalidSection ??= _section6Key;
      } else if (!RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$').hasMatch(upi)) {
        errs['upi'] = 'Enter a valid UPI ID (e.g. name@okhdfcbank)';
        firstInvalidSection ??= _section6Key;
      }
    } else {
      if (_bankAccountHolderController.text.trim().isEmpty) {
        errs['bankAccountHolder'] = 'Account holder name is required';
        firstInvalidSection ??= _section6Key;
      }
      if (_bankNameController.text.trim().isEmpty) {
        errs['bankName'] = 'Bank name is required';
        firstInvalidSection ??= _section6Key;
      }
      final acc = _bankAccountNumberController.text.trim();
      if (acc.isEmpty) {
        errs['bankAccountNumber'] = 'Account number is required';
        firstInvalidSection ??= _section6Key;
      } else if (!RegExp(r'^[0-9]{9,18}$').hasMatch(acc)) {
        errs['bankAccountNumber'] = 'Account number must be 9 to 18 digits';
        firstInvalidSection ??= _section6Key;
      }
      final confirm = _confirmAccountNumberController.text.trim();
      if (confirm != acc) {
        errs['confirmAccountNumber'] = 'Account numbers do not match';
        firstInvalidSection ??= _section6Key;
      }
      final ifsc = _bankIfscController.text.trim().toUpperCase();
      if (ifsc.isEmpty) {
        errs['bankIfsc'] = 'IFSC code is required';
        firstInvalidSection ??= _section6Key;
      } else if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
        errs['bankIfsc'] = 'Enter valid 11-char IFSC (e.g. SBIN0001234)';
        firstInvalidSection ??= _section6Key;
      }
    }

    if (forSubmit) {
      if ((_profilePhotoUrl ?? '').isEmpty && (_selectedProfilePhotoPath ?? '').isEmpty) {
        errs['photo'] = 'Founder portrait / logo is required for submission';
        firstInvalidSection ??= _section1Key;
      }
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
    final category = _businessCategory == 'Other'
        ? _businessCategoryOtherController.text.trim()
        : (_businessCategory ?? '');

    final payload = <String, dynamic>{
      'fullName': _fullNameController.text.trim(),
      'businessName': _businessNameController.text.trim(),
      'businessCategory': category,
      'designation': _designationController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'whatsappNumber': _whatsappController.text.trim(),
      'dob': _dobController.text.trim(),
      'state': state,
      'city': _cityController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'businessLocation': _businessLocationController.text.trim(),
      'address': _businessLocationController.text.trim(),
      'latitude': _lat,
      'longitude': _lng,
      'investmentNeeded': double.tryParse(_investmentNeededController.text.trim()),
      'expectedMonthlyIncome': double.tryParse(_expectedMonthlyIncomeController.text.trim()),
      'businessExperience': int.tryParse(_businessExperienceController.text.trim()),
      'aadhaarNumber': _aadhaarNumberController.text.trim(),
      'panNumber': _panNumberController.text.trim().toUpperCase(),
      'businessDescription': _businessDescriptionController.text.trim(),
      'bio': _businessDescriptionController.text.trim(),
    };

    if (_payoutMode == 'UPI') {
      payload['upiId'] = _upiIdController.text.trim();
    } else {
      payload['bankAccountHolder'] = _bankAccountHolderController.text.trim();
      payload['bankName'] = _bankNameController.text.trim();
      payload['bankAccountNumber'] = _bankAccountNumberController.text.trim();
      payload['accountNumber'] = _bankAccountNumberController.text.trim();
      payload['bankIfsc'] = _bankIfscController.text.trim().toUpperCase();
      payload['ifscCode'] = _bankIfscController.text.trim().toUpperCase();
      payload['bankBranch'] = _bankBranchController.text.trim();
    }

    return payload;
  }

  // ── Save Draft ────────────────────────────────────────────────────────────

  Future<void> _saveDraft() async {
    setState(() {
      _saving = true;
      _globalError = null;
    });
    try {
      // 1. Upload profile photo if newly selected
      if (_selectedProfilePhotoPath != null) {
        await _svc.uploadPhotos(profilePath: _selectedProfilePhotoPath);
      }
      // 2. Upload pitch deck if newly selected
      if (_selectedPitchDeckPath != null) {
        await _svc.uploadPitchDeck(_selectedPitchDeckPath!);
      }
      // 3. Update profile payload
      final res = await _svc.updateProfile(_buildPayload());
      if (res['success'] != true) {
        throw Exception(res['error']?.toString() ?? 'Failed to save profile');
      }
      if (mounted) {
        _applyProfile(Map<String, dynamic>.from(res));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile draft saved successfully!'),
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
        MaterialPageRoute(builder: (_) => const EntrepreneurDashboardScreen()),
        (_) => false,
      );
    }
  }

  void _skip() => _finish();

  // ── Submit for Admin Verification ─────────────────────────────────────────

  Future<void> _submitForVerification() async {
    final valid = _validateForm(forSubmit: true);
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all 16 required items before submitting.'),
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
      // 1. Upload photo if selected
      if (_selectedProfilePhotoPath != null) {
        await _svc.uploadPhotos(profilePath: _selectedProfilePhotoPath);
      }
      // 2. Upload pitch deck if selected
      if (_selectedPitchDeckPath != null) {
        await _svc.uploadPitchDeck(_selectedPitchDeckPath!);
      }
      // 3. Update profile
      final updateRes = await _svc.updateProfile(_buildPayload());
      if (updateRes['success'] != true) {
        throw Exception(updateRes['error']?.toString() ?? 'Failed to update profile');
      }
      // 4. Submit for verification
      final submitRes = await _svc.submitVerification();
      if (submitRes['success'] != true) {
        throw Exception(submitRes['error']?.toString() ?? 'Verification submission failed');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile submitted for Admin Verification!'),
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

  // ── Image & File Pickers ──────────────────────────────────────────────────

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

  Future<void> _pickPitchDeck() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPitchDeckPath = result.files.single.path;
      });
    }
  }

  Future<void> _pickGalleryPhotos() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() {
        _selectedGalleryPhotos.addAll(images.map((img) => img.path));
      });
    }
  }

  // ── Build Method ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile Completion')),
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
          'Entrepreneur Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: EntrepreneurProfileCompletionScreen.navy,
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

            // ── SECTION 1: BUSINESS IDENTITY & FOUNDER DETAILS ──────────────
            Container(key: _section1Key, child: _buildSection1()),
            const SizedBox(height: 16),

            // ── SECTION 2: LOCATION & OPERATIONS ────────────────────────────
            Container(key: _section2Key, child: _buildSection2()),
            const SizedBox(height: 16),

            // ── SECTION 3: FINANCIAL & INVESTMENT DETAILS ───────────────────
            Container(key: _section3Key, child: _buildSection3()),
            const SizedBox(height: 16),

            // ── SECTION 4: IDENTITY & LEGAL VERIFICATION ────────────────────
            Container(key: _section4Key, child: _buildSection4()),
            const SizedBox(height: 16),

            // ── SECTION 5: BUSINESS OVERVIEW & PITCH DECK ───────────────────
            Container(key: _section5Key, child: _buildSection5()),
            const SizedBox(height: 16),

            // ── SECTION 6: PAYOUT & DISBURSEMENT DETAILS ────────────────────
            Container(key: _section6Key, child: _buildSection6()),
            const SizedBox(height: 24),

            // ── BOTTOM ACTION BUTTONS ───────────────────────────────────────
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
                '$pct% Completed (${16 - missing.length} / 16 items)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: EntrepreneurProfileCompletionScreen.navy,
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
                pct == 100 ? const Color(0xFF10B981) : EntrepreneurProfileCompletionScreen.primary,
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
                      Text(
                        item,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
                      ),
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

  // ── SECTION 1: BUSINESS IDENTITY & FOUNDER DETAILS ────────────────────────

  Widget _buildSection1() {
    return _buildCard(
      title: '1. Business Identity & Founder Details',
      subtitle: 'Basic founder and startup credentials',
      icon: Icons.person_outline,
      children: [
        // Profile photo
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
                          ? null // In tests / preview, image path
                          : (_profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                              ? NetworkImage(_profilePhotoUrl!)
                              : null) as ImageProvider?,
                      child: (_selectedProfilePhotoPath == null &&
                              (_profilePhotoUrl == null || _profilePhotoUrl!.isEmpty))
                          ? const Icon(Icons.business, size: 42, color: Color(0xFF94A3B8))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: EntrepreneurProfileCompletionScreen.primary,
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
                'Founder Portrait / Logo *',
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
        const SizedBox(height: 16),

        _buildTextField(
          label: 'Full Name *',
          controller: _fullNameController,
          placeholder: 'e.g. Ananya Sharma',
          errorText: _errors['fullName'],
          helperText: 'Your legal name as per government records',
          onChanged: (_) => setState(() => _errors.remove('fullName')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Business / Venture Name *',
          controller: _businessNameController,
          placeholder: 'e.g. Lotus Crafts & Handloom',
          errorText: _errors['businessName'],
          helperText: 'Brand, company or enterprise name',
          onChanged: (_) => setState(() => _errors.remove('businessName')),
        ),
        const SizedBox(height: 12),

        _buildDropdown(
          label: 'Business Category *',
          value: _businessCategory,
          items: FundingCatalog.entrepreneurBusinessCategories,
          errorText: _errors['businessCategory'],
          helperText: 'Primary operating sector of your enterprise',
          onChanged: (val) {
            setState(() {
              _businessCategory = val;
              _errors.remove('businessCategory');
            });
          },
        ),
        if (_businessCategory == 'Other') ...[
          const SizedBox(height: 8),
          _buildTextField(
            label: 'Specify Category *',
            controller: _businessCategoryOtherController,
            placeholder: 'Enter your business category',
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Designation / Role',
          controller: _designationController,
          placeholder: 'e.g. Founder, Managing Partner, CEO',
          helperText: 'Your official role in the business',
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Account Email *',
          controller: _emailController,
          placeholder: 'founder@example.com',
          keyboardType: TextInputType.emailAddress,
          errorText: _errors['email'],
          helperText: 'Registered login and notifications email',
          onChanged: (_) => setState(() => _errors.remove('email')),
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
          helperText: '10 digits starting with 6-9 for OTP and calls',
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
          helperText: 'Direct investor communication channel',
          onChanged: (_) => setState(() => _errors.remove('whatsapp')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Date of Birth (Optional)',
          controller: _dobController,
          placeholder: 'YYYY-MM-DD',
          helperText: 'For age and legal eligibility confirmation',
        ),
      ],
    );
  }

  // ── SECTION 2: LOCATION & OPERATIONS ──────────────────────────────────────

  Widget _buildSection2() {
    return _buildCard(
      title: '2. Location & Operations',
      subtitle: 'Operating address and geocoding',
      icon: Icons.location_on_outlined,
      children: [
        // Country
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
          helperText: 'State where your business operates',
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
            placeholder: 'e.g. Specific Union Territory',
            onChanged: (_) => setState(() {}),
          ),
        ],
        const SizedBox(height: 12),

        _buildTextField(
          label: 'City *',
          controller: _cityController,
          placeholder: 'e.g. Mumbai, Bengaluru, Lucknow',
          errorText: _errors['city'],
          helperText: 'Operating city or district',
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
          label: 'Street Address / Landmark *',
          controller: _businessLocationController,
          placeholder: 'Shop/Office No, Building name, Street, Landmark',
          errorText: _errors['location'],
          helperText: 'Full physical address of shop, office or workshop',
          onChanged: (_) => setState(() => _errors.remove('location')),
        ),
        const SizedBox(height: 12),

        // Coordinates & Map preview
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

  // ── SECTION 3: FINANCIAL & INVESTMENT DETAILS ─────────────────────────────

  Widget _buildSection3() {
    return _buildCard(
      title: '3. Financial & Investment Details',
      subtitle: 'Capital requirements and unit economics',
      icon: Icons.currency_rupee,
      children: [
        _buildTextField(
          label: 'Funding Required (₹) *',
          controller: _investmentNeededController,
          placeholder: 'e.g. 250000',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['investmentNeeded'],
          helperText: 'Total capital needed (Minimum ₹1,000)',
          onChanged: (_) => setState(() => _errors.remove('investmentNeeded')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Expected Monthly Revenue (₹) *',
          controller: _expectedMonthlyIncomeController,
          placeholder: 'e.g. 50000',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['expectedMonthlyIncome'],
          helperText: 'Projected or current monthly revenue (Minimum ₹100)',
          onChanged: (_) => setState(() => _errors.remove('expectedMonthlyIncome')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'Business Experience (Years) *',
          controller: _businessExperienceController,
          placeholder: 'e.g. 2 (enter 0 if new venture)',
          keyboardType: TextInputType.number,
          maxLength: 2,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
          errorText: _errors['businessExperience'],
          helperText: 'Years of industry or entrepreneurial experience (0-60)',
          onChanged: (_) => setState(() => _errors.remove('businessExperience')),
        ),
      ],
    );
  }

  // ── SECTION 4: IDENTITY & LEGAL VERIFICATION ──────────────────────────────

  Widget _buildSection4() {
    return _buildCard(
      title: '4. Identity & Legal Verification',
      subtitle: 'Statutory compliance and KYC documents',
      icon: Icons.verified_user_outlined,
      children: [
        _buildTextField(
          label: 'Aadhaar Number *',
          controller: _aadhaarNumberController,
          placeholder: '12-digit Aadhaar number',
          keyboardType: TextInputType.number,
          maxLength: 12,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: _errors['aadhaar'],
          helperText: 'Mandatory 12-digit UIDAI number for identity verification',
          onChanged: (_) => setState(() => _errors.remove('aadhaar')),
        ),
        const SizedBox(height: 12),

        _buildTextField(
          label: 'PAN Number (Optional)',
          controller: _panNumberController,
          placeholder: 'e.g. ABCDE1234F',
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
          errorText: _errors['pan'],
          helperText: '10-character alphanumeric PAN for tax verification',
          onChanged: (_) => setState(() => _errors.remove('pan')),
        ),
      ],
    );
  }

  // ── SECTION 5: BUSINESS OVERVIEW & PITCH DECK ─────────────────────────────

  Widget _buildSection5() {
    return _buildCard(
      title: '5. Business Overview & Pitch Deck',
      subtitle: 'Pitch deck, gallery and business description',
      icon: Icons.description_outlined,
      children: [
        _buildTextField(
          label: 'Business Description & Vision *',
          controller: _businessDescriptionController,
          placeholder:
              'Describe your product/service, target customers, competitive edge, and how funds will be utilized...',
          maxLines: 4,
          errorText: _errors['description'],
          helperText: 'Detailed overview of your enterprise (Minimum 10 characters)',
          onChanged: (_) => setState(() => _errors.remove('description')),
        ),
        const SizedBox(height: 14),

        // Pitch Deck Document upload
        const Text(
          'Pitch Deck Document (PDF / Presentation)',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _pickPitchDeck,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Color(0xFFE11D48)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedPitchDeckPath != null
                        ? _selectedPitchDeckPath!.split(RegExp(r'[\\/]')).last
                        : (_pitchDeckPath != null && _pitchDeckPath!.isNotEmpty
                            ? 'Pitch Deck Uploaded'
                            : 'Choose Pitch Deck File (PDF, Images)'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: (_selectedPitchDeckPath != null ||
                              (_pitchDeckPath != null && _pitchDeckPath!.isNotEmpty))
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                const Icon(Icons.upload_file, color: Color(0xFF64748B), size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Gallery Photos
        const Text(
          'Business & Product Gallery Photos',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: _pickGalleryPhotos,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text('Select Photos (${_selectedGalleryPhotos.length + _galleryPhotos.length} added)'),
          style: OutlinedButton.styleFrom(
            foregroundColor: EntrepreneurProfileCompletionScreen.navy,
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // ── SECTION 6: PAYOUT & DISBURSEMENT DETAILS ──────────────────────────────

  Widget _buildSection6() {
    return _buildCard(
      title: '6. Payout & Disbursement Details',
      subtitle: 'Where investor disbursements are sent',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        const Text(
          'Select Payout Method *',
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
                      ? EntrepreneurProfileCompletionScreen.primary
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
                      ? EntrepreneurProfileCompletionScreen.primary
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
            label: 'UPI ID *',
            controller: _upiIdController,
            placeholder: 'e.g. foundername@okaxis, business@upi',
            errorText: _errors['upi'],
            helperText: 'Direct VPA for instant UPI escrow disbursements',
            onChanged: (_) => setState(() => _errors.remove('upi')),
          ),
        ] else ...[
          _buildTextField(
            label: 'Account Holder Name *',
            controller: _bankAccountHolderController,
            placeholder: 'Name as per bank records',
            errorText: _errors['bankAccountHolder'],
            onChanged: (_) => setState(() => _errors.remove('bankAccountHolder')),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Bank Name *',
            controller: _bankNameController,
            placeholder: 'e.g. State Bank of India, HDFC Bank',
            errorText: _errors['bankName'],
            onChanged: (_) => setState(() => _errors.remove('bankName')),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Bank Account Number *',
            controller: _bankAccountNumberController,
            placeholder: '9 to 18 digits',
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 18,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(18)],
            errorText: _errors['bankAccountNumber'],
            onChanged: (_) => setState(() => _errors.remove('bankAccountNumber')),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Confirm Account Number *',
            controller: _confirmAccountNumberController,
            placeholder: 'Re-enter bank account number',
            keyboardType: TextInputType.number,
            maxLength: 18,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(18)],
            errorText: _errors['confirmAccountNumber'],
            onChanged: (_) => setState(() => _errors.remove('confirmAccountNumber')),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'IFSC Code *',
            controller: _bankIfscController,
            placeholder: 'e.g. SBIN0001234',
            textCapitalization: TextCapitalization.characters,
            maxLength: 11,
            errorText: _errors['bankIfsc'],
            helperText: '11-character Indian Financial System Code',
            onChanged: (_) => setState(() => _errors.remove('bankIfsc')),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Branch Name',
            controller: _bankBranchController,
            placeholder: 'e.g. Connaught Place Branch',
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
                  : EntrepreneurProfileCompletionScreen.primary,
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
              foregroundColor: EntrepreneurProfileCompletionScreen.navy,
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
                child: Icon(icon, color: EntrepreneurProfileCompletionScreen.primary, size: 20),
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
                        color: EntrepreneurProfileCompletionScreen.navy,
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
                color: EntrepreneurProfileCompletionScreen.primary,
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
