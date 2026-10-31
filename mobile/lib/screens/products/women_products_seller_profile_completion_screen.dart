import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../../widgets/bank_details_form.dart';
import '../../widgets/dynamic_location_hierarchy_picker.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_completion_helpers.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';
import 'women_products_seller_pending_approval_screen.dart';

/// Screen for completing and editing the Women Products Seller Profile.
/// Exact functional replica of the website's `seller-profile.jsp` across all 9 sections,
/// validations, helpers, location hierarchy, bank details, uploads, and live storefront preview.
class WomenProductsSellerProfileCompletionScreen extends StatefulWidget {
  const WomenProductsSellerProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color roseSoft = Color(0xFFFFF1F2);
  static const Color roseBorder = Color(0xFFFECDD3);
  static const Color navy = Color(0xFF0F172A);
  static const Color bgPage = Color(0xFFF8FAFC);

  @override
  State<WomenProductsSellerProfileCompletionScreen> createState() =>
      _WomenProductsSellerProfileCompletionScreenState();
}

class _WomenProductsSellerProfileCompletionScreenState
    extends State<WomenProductsSellerProfileCompletionScreen> {
  // Section 1: Seller Identity & Contact
  final _fullName = TextEditingController();
  final _businessName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _experience = TextEditingController();
  String? _designation;

  // Section 2: Physical Store & Operational Location
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  String? _state;
  double? _lat;
  double? _lng;

  // Section 3: Categories & Brand Specialty
  final _category = TextEditingController();
  String? _brandType;
  final Set<String> _categoriesOffered = {};

  // Section 4: Service Area & Communication
  final _serviceArea = TextEditingController();
  final _languagesSpoken = TextEditingController();

  // Section 5: Shop Facilities & Qualifications
  final _qualification = TextEditingController();
  final _facilities = TextEditingController();

  // Section 6: Operating Hours & Schedule
  final Set<String> _availableDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};
  TimeOfDay? _workingHoursFrom = const TimeOfDay(hour: 9, minute: 30);
  TimeOfDay? _workingHoursTo = const TimeOfDay(hour: 20, minute: 0);

  // Section 7: About the Shop & Brand Story
  final _description = TextEditingController();

  // Section 8: Payout & Bank Details
  final _accountHolder = TextEditingController();
  final _accountNumber = TextEditingController();
  final _confirmAccountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();
  final _branchName = TextEditingController();
  final _upi = TextEditingController();
  final _gstin = TextEditingController();
  String _accountType = 'Current';

  // Section 9: Visuals & Documents
  String? _profilePhotoPath;
  String? _identityDocPath;
  List<String> _galleryPhotos = [];

  // Metadata / State
  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingDoc = false;
  bool _uploadingGallery = false;
  String? _error;
  Map<String, dynamic> _profile = {};

  WomenProductsSellerAuthService get _svc =>
      WomenProductsSellerAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _fullName, _businessName, _email, _phone, _whatsapp, _experience,
      _address, _city, _pincode, _mapLocation, _category, _serviceArea,
      _languagesSpoken, _qualification, _facilities, _description,
      _accountHolder, _accountNumber, _confirmAccountNumber, _ifsc,
      _bankName, _branchName, _upi, _gstin,
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

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    // Section 1
    _fullName.text = p['fullName']?.toString() ?? '';
    _businessName.text = p['businessName']?.toString() ?? '';
    _email.text = p['email']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _experience.text = p['experience']?.toString() ?? p['yearsExperience']?.toString() ?? '';
    _designation = p['designation']?.toString().isNotEmpty == true ? p['designation'].toString() : null;

    // Section 2
    _address.text = p['address']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state = p['state']?.toString().isNotEmpty == true ? p['state'].toString() : null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');
    if (_lat != null && _lng != null) {
      _mapLocation.text = 'https://maps.google.com/?q=$_lat,$_lng';
    }

    // Section 3
    final primaryCat = p['category']?.toString() ?? p['primaryCategory']?.toString() ?? '';
    _category.text = primaryCat;
    _brandType = p['brandType']?.toString().isNotEmpty == true ? p['brandType'].toString() : null;
    _categoriesOffered
      ..clear()
      ..addAll(SellerCatalog.splitCsv(p['categoriesOffered']));
    if (primaryCat.isNotEmpty && !_categoriesOffered.contains(primaryCat)) {
      _categoriesOffered.add(primaryCat);
    }

    // Section 4
    _serviceArea.text = p['serviceArea']?.toString() ?? '';
    _languagesSpoken.text = p['languagesSpoken']?.toString() ?? '';

    // Section 5
    _qualification.text = p['qualification']?.toString() ?? '';
    _facilities.text = p['facilities'] is List
        ? (p['facilities'] as List).join(', ')
        : (p['facilities']?.toString() ?? '');

    // Section 6
    final rawDays = p['availableDays']?.toString() ?? p['openDays']?.toString() ?? '';
    if (rawDays.isNotEmpty) {
      _availableDays
        ..clear()
        ..addAll(SellerCatalog.splitCsv(rawDays));
    }
    final rawFrom = p['workingHoursFrom']?.toString() ?? p['openTime']?.toString();
    final rawTo = p['workingHoursTo']?.toString() ?? p['closeTime']?.toString();
    if (rawFrom != null && rawFrom.isNotEmpty) {
      _workingHoursFrom = SellerCatalog.parseTime(rawFrom) ?? _workingHoursFrom;
    }
    if (rawTo != null && rawTo.isNotEmpty) {
      _workingHoursTo = SellerCatalog.parseTime(rawTo) ?? _workingHoursTo;
    }

    // Section 7
    _description.text = p['description']?.toString() ?? p['bio']?.toString() ?? '';

    // Section 8
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
    _gstin.text = p['gstin']?.toString() ?? '';
    if (p['upiId']?.toString().isNotEmpty == true) {
      _upi.text = p['upiId'].toString();
    }

    // Section 9
    _profilePhotoPath = p['profilePhotoPath']?.toString() ?? p['profileImageUrl']?.toString();
    _identityDocPath = p['identityDocPath']?.toString();
    if (p['galleryPhotos'] is List) {
      _galleryPhotos = (p['galleryPhotos'] as List).map((e) => e.toString()).toList();
    } else if (p['galleryPhotos'] is String) {
      _galleryPhotos = SellerCatalog.splitCsv(p['galleryPhotos']);
    }
  }

  Map<String, dynamic> _profileBody() {
    final fromStr = _workingHoursFrom != null ? SellerCatalog.formatTime(_workingHoursFrom!) : '09:30';
    final toStr = _workingHoursTo != null ? SellerCatalog.formatTime(_workingHoursTo!) : '20:00';
    final daysStr = _availableDays.join(',');
    final catStr = _category.text.trim();

    return {
      // Section 1
      'fullName': _fullName.text.trim(),
      'businessName': _businessName.text.trim(),
      'phone': _phone.text.trim(),
      'designation': _designation,
      'whatsappNumber': _whatsapp.text.trim(),
      'experience': _experience.text.trim(),
      'yearsExperience': _experience.text.trim(),

      // Section 2
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': _state ?? '',
      'pincode': _pincode.text.trim(),
      'latitude': _lat,
      'longitude': _lng,

      // Section 3
      'category': catStr,
      'primaryCategory': catStr,
      'brandType': _brandType,
      'categoriesOffered': _categoriesOffered.toList(),

      // Section 4
      'serviceArea': _serviceArea.text.trim(),
      'languagesSpoken': _languagesSpoken.text.trim(),

      // Section 5
      'qualification': _qualification.text.trim(),
      'facilities': _facilities.text.trim(),

      // Section 6
      'availableDays': daysStr,
      'openDays': _availableDays.toList(),
      'workingHoursFrom': fromStr,
      'openTime': fromStr,
      'workingHoursTo': toStr,
      'closeTime': toStr,

      // Section 7
      'description': _description.text.trim(),
      'bio': _description.text.trim(),

      // Section 8
      'gstin': _gstin.text.trim().toUpperCase(),
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

      // Defaults for compatibility
      'dispatchHours': 24,
      'typicalPrice': 499.0,
    };
  }

  String? _validate({bool forSubmit = false}) {
    // 1. Seller Identity
    final name = _fullName.text.trim();
    if (name.length < 2 || name.length > 80 || RegExp(r'\d').hasMatch(name)) {
      return '1.1 Full Name must be 2–80 letters only (no digits).';
    }
    final shop = _businessName.text.trim();
    if (shop.length < 2 || shop.length > 100) {
      return '1.2 Shop / Business Name is required (2–100 characters).';
    }
    final ph = _phone.text.trim();
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(ph)) {
      return '1.4 Official Phone must be a valid 10-digit Indian number starting with 6–9.';
    }
    if ((_designation ?? '').trim().isEmpty) {
      return '1.5 Role or Designation is required.';
    }
    final wa = _whatsapp.text.trim();
    if (wa.isNotEmpty && !RegExp(r'^[6-9]\d{9}$').hasMatch(wa)) {
      return '1.6 WhatsApp number must be 10 digits starting with 6–9.';
    }

    // 2. Location
    final addr = _address.text.trim();
    if (addr.length < 10) {
      return '2.1 Business Address must be at least 10 characters long.';
    }
    if ((_state ?? '').trim().isEmpty) {
      return '2.2 State / Union Territory is required.';
    }
    if (_city.text.trim().isEmpty) {
      return '2.3 City / District is required.';
    }
    final pin = _pincode.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      return '2.4 Postal Pincode must be exactly 6 digits.';
    }

    // 3. Category & Brand
    if (_category.text.trim().isEmpty) {
      return '3.1 Primary Product Category is required.';
    }
    if ((_brandType ?? '').trim().isEmpty) {
      return '3.2 Brand / Listing Type is required.';
    }

    // 6. Schedule
    if (_availableDays.isEmpty) {
      return '6.1 At least one available operating day is required.';
    }
    if (_workingHoursFrom == null || _workingHoursTo == null) {
      return '6.2 Operating hours (Opening & Closing times) are required.';
    }

    // 7. Description
    final desc = _description.text.trim();
    if (desc.length < 10) {
      return '7.1 Shop Description is required (minimum 10 characters).';
    }

    // 8. Bank verification
    final acc = _accountNumber.text.trim();
    final confirmAcc = _confirmAccountNumber.text.trim();
    if (acc.isNotEmpty || confirmAcc.isNotEmpty) {
      if (acc != confirmAcc) {
        return '8.4 Bank account numbers do not match.';
      }
    }
    final ifsc = _ifsc.text.trim().toUpperCase();
    if (ifsc.isNotEmpty && !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      return '8.5 IFSC must be 4 letters, 0, and 6 alphanumeric characters (e.g. SBIN0001234).';
    }
    final upi = _upi.text.trim();
    if (upi.isNotEmpty && !RegExp(r'^[\w.-]+@[\w.-]+$').hasMatch(upi)) {
      return '8.7 Enter a valid UPI ID (e.g. name@bank).';
    }
    final gstin = _gstin.text.trim().toUpperCase();
    if (gstin.isNotEmpty && gstin.length != 15) {
      return '8.8 GSTIN must be exactly 15 characters.';
    }

    if (forSubmit && _profile['canSubmitForVerification'] == false) {
      return _profile['nextStepGuidance']?.toString() ?? 'Please complete all mandatory fields before submitting.';
    }

    return null;
  }

  Future<void> _saveProfile() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      _showErrorDialog(err);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Saving Profile…',
        doneLabel: 'Profile Saved',
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
    final err = _validate(forSubmit: true);
    if (err != null) {
      setState(() => _error = err);
      _showErrorDialog(err);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Submitting Store…',
        doneLabel: 'Submitted for Review',
        action: () async {
          final saveRes = await _svc.updateProfile(_profileBody());
          if (saveRes['success'] == true) {
            _applyProfile(Map<String, dynamic>.from(saveRes));
          }
          final res = await _svc.submitVerification();
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Submission failed');
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => WomenProductsSellerPendingApprovalScreen(
              initialProfile: _profile,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickTime(bool isOpening) async {
    final current = isOpening ? _workingHoursFrom : _workingHoursTo;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? (isOpening ? const TimeOfDay(hour: 9, minute: 30) : const TimeOfDay(hour: 20, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isOpening) {
          _workingHoursFrom = picked;
        } else {
          _workingHoursTo = picked;
        }
      });
    }
  }

  Future<void> _uploadFile({required String kind}) async {
    String? path;
    try {
      if (kind == 'photo') {
        final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
        path = img?.path;
      } else if (kind == 'doc') {
        final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png']);
        path = res?.files.single.path;
      } else if (kind == 'gallery') {
        final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
        path = img?.path;
      }
    } catch (_) {}

    if (path == null || path.isEmpty) return;

    setState(() {
      if (kind == 'photo') _uploadingPhoto = true;
      if (kind == 'doc') _uploadingDoc = true;
      if (kind == 'gallery') _uploadingGallery = true;
    });

    try {
      final res = await _svc.uploadPhotos(
        profilePath: kind == 'photo' ? path : null,
        identityDocPath: kind == 'doc' ? path : null,
        galleryPath: kind == 'gallery' ? path : null,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await _load();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kind == 'photo' ? 'Store logo updated!' : (kind == 'doc' ? 'Identity document uploaded!' : 'Showcase photo added!')),
            backgroundColor: const Color(0xFF16A34A),
          ),
        );
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Upload failed');
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
          _uploadingDoc = false;
          _uploadingGallery = false;
        });
      }
    }
  }

  void _skip() => ProfileCompletionActions.skip(context, widget.onFinished);

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num)
        ? (_profile['profileCompletionPct'] as num).toDouble()
        : 0.0;
    final missing = SellerCatalog.splitCsv(_profile['missingItems']);
    final guidance = _profile['nextStepGuidance']?.toString();
    final canSubmit = _profile['canSubmitForVerification'] == true;
    final changesNote = _profile['changesRequestedNote']?.toString();
    final rejectionReason = _profile['rejectionReason']?.toString();

    return Scaffold(
      backgroundColor: WomenProductsSellerProfileCompletionScreen.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: WomenProductsSellerProfileCompletionScreen.navy,
        title: const Text(
          'Complete Seller Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFEE2E2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_error!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],

                // Changes Requested Banner
                if (changesNote != null && changesNote.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFEF3C7), width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Action Required: Changes Requested by Admin',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFB45309)),
                              ),
                              const SizedBox(height: 4),
                              Text(changesNote, style: const TextStyle(fontSize: 13, color: Color(0xFF92400E))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Rejection Banner
                if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.cancel_rounded, color: Color(0xFFB91C1C), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Application Rejected — Update Required',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFFB91C1C)),
                              ),
                              const SizedBox(height: 4),
                              Text(rejectionReason, style: const TextStyle(fontSize: 13, color: Color(0xFF991B1B))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Completion Progress Card
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: _profile['partnerProfileStatusLabel']?.toString() ?? 'Profile Incomplete',
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

                // Submit Verification Button
                FilledButton.icon(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.verified_user_rounded, size: 20),
                  label: Text(
                    canSubmit ? 'Submit for Admin Verification' : 'Complete required fields to submit',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: WomenProductsSellerProfileCompletionScreen.primary,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),

                const SizedBox(height: 20),

                // SECTION 1: Seller Identity & Contact
                _sectionCard(
                  icon: Icons.badge_rounded,
                  sectionNumber: '1',
                  title: 'Seller Identity & Contact',
                  subtitle: 'Personal and business identification details that build customer trust.',
                  children: [
                    _field(
                      _fullName,
                      '1.1',
                      'Full Name',
                      required: true,
                      hint: 'Your full legal name',
                      maxLength: 80,
                    ),
                    _field(
                      _businessName,
                      '1.2',
                      'Shop / Business Name',
                      required: true,
                      hint: 'e.g. Namratha Handlooms & Crafts',
                      maxLength: 100,
                    ),
                    _readOnlyField(
                      label: 'Official Email (Not Editable)',
                      value: _email.text.isNotEmpty ? _email.text : (_profile['email']?.toString() ?? 'seller@example.com'),
                      icon: Icons.lock_outline_rounded,
                    ),
                    _field(
                      _phone,
                      '1.4',
                      'Official Phone',
                      required: true,
                      hint: '10-digit mobile number starting with 6–9',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _dropdown(
                      number: '1.5',
                      label: 'Role / Designation',
                      value: _designation,
                      options: SellerCatalog.designations,
                      required: true,
                      onChanged: (v) => setState(() => _designation = v),
                    ),
                    _field(
                      _whatsapp,
                      '1.6',
                      'WhatsApp Number',
                      hint: '10-digit WhatsApp number for customer updates',
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _field(
                      _experience,
                      '1.7',
                      'Experience / Years in Business',
                      hint: 'e.g. 5+ years crafting handmade organic soaps',
                      maxLength: 100,
                    ),
                  ],
                ),

                // SECTION 2: Physical Store & Operational Location
                _sectionCard(
                  icon: Icons.location_on_rounded,
                  sectionNumber: '2',
                  title: 'Physical Store & Operational Location',
                  subtitle: 'Define where your shop or dispatch warehouse is physically based.',
                  children: [
                    // Dynamic Location Hierarchy Picker (Country -> State -> District -> City)
                    DynamicLocationHierarchyPicker(
                      api: context.read<AuthState>().api,
                      initialCountry: 'India',
                      initialState: _state,
                      initialCity: _city.text.isNotEmpty ? _city.text : null,
                      isRequired: true,
                      onLocationChanged: ({required country, required state, required district, required city}) {
                        setState(() {
                          _state = state;
                          if (city.isNotEmpty) _city.text = city;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _field(
                      _address,
                      '2.1',
                      'Landmark / Business Address',
                      required: true,
                      hint: 'Shop/Building #, Street name, Area, Landmark (min 10 chars)',
                      maxLines: 2,
                    ),
                    _field(
                      _city,
                      '2.2',
                      'City / Locality',
                      required: true,
                      hint: 'Your city or operational town',
                    ),
                    _dropdown(
                      number: '2.3',
                      label: 'State / Union Territory',
                      value: _state,
                      options: SellerCatalog.indianStates,
                      required: true,
                      onChanged: (v) => setState(() => _state = v),
                    ),
                    _field(
                      _pincode,
                      '2.4',
                      'Postal Pincode',
                      required: true,
                      hint: '6-digit Indian PIN code',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    _field(
                      _mapLocation,
                      '2.5',
                      'Google Maps Link',
                      hint: 'Auto-filled via map pin or paste link',
                    ),
                    const SizedBox(height: 8),
                    ProfileLocationPicker(
                      lat: _lat,
                      lng: _lng,
                      mapLinkController: _mapLocation,
                      pinLabel: 'Pin Exact Shop Location on Map',
                      onPinned: (lat, lng) => setState(() {
                        _lat = lat;
                        _lng = lng;
                      }),
                      onError: (msg) => setState(() => _error = msg),
                    ),
                  ],
                ),

                // SECTION 3: Categories & Brand Specialty
                _sectionCard(
                  icon: Icons.category_rounded,
                  sectionNumber: '3',
                  title: 'Categories & Brand Specialty',
                  subtitle: 'Specify the primary product categories you sell and your brand classification.',
                  children: [
                    _field(
                      _category,
                      '3.1',
                      'Primary Product Category',
                      required: true,
                      hint: 'e.g. Handloom Sarees, Organic Skincare, Terracotta Jewellery',
                    ),
                    _dropdown(
                      number: '3.2',
                      label: 'Brand / Listing Type',
                      value: _brandType,
                      options: SellerCatalog.brandTypes,
                      required: true,
                      onChanged: (v) => setState(() => _brandType = v),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Categories Offered (Select all that apply):',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SellerCatalog.categories.map((c) {
                        final on = _categoriesOffered.contains(c.code) || _categoriesOffered.contains(c.label);
                        return FilterChip(
                          label: Text(c.label),
                          selected: on,
                          selectedColor: const Color(0xFFFFF1F2),
                          checkmarkColor: WomenProductsSellerProfileCompletionScreen.primary,
                          onSelected: (v) => setState(() {
                            if (v) {
                              _categoriesOffered.add(c.label);
                              if (_category.text.trim().isEmpty) _category.text = c.label;
                            } else {
                              _categoriesOffered.remove(c.label);
                              _categoriesOffered.remove(c.code);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // SECTION 4: Service Area & Communication
                _sectionCard(
                  icon: Icons.public_rounded,
                  sectionNumber: '4',
                  title: 'Service Area & Communication',
                  subtitle: 'Regions you deliver to and languages your customer support speaks.',
                  children: [
                    _field(
                      _serviceArea,
                      '4.1',
                      'Delivery / Service Area',
                      hint: 'e.g. Pan India, South India, Local Citywide Same-Day',
                    ),
                    _field(
                      _languagesSpoken,
                      '4.2',
                      'Languages Spoken',
                      hint: 'e.g. English, Hindi, Kannada, Tamil',
                    ),
                  ],
                ),

                // SECTION 5: Shop Facilities & Qualifications
                _sectionCard(
                  icon: Icons.verified_rounded,
                  sectionNumber: '5',
                  title: 'Shop Facilities & Credentials',
                  subtitle: 'Artisan certifications, store amenities, and quality assurance.',
                  children: [
                    _field(
                      _qualification,
                      '5.1',
                      'Qualifications / Certifications',
                      hint: 'e.g. Certified Organic Producer, Handloom Mark Holder, MSME Registered',
                      maxLines: 2,
                    ),
                    _field(
                      _facilities,
                      '5.2',
                      'Store Amenities & Services',
                      hint: 'e.g. Trial room, Custom tailoring, Eco-friendly packaging, Gift wrapping',
                    ),
                  ],
                ),

                // SECTION 6: Operating Hours & Schedule
                _sectionCard(
                  icon: Icons.access_time_rounded,
                  sectionNumber: '6',
                  title: 'Operating Hours & Schedule',
                  subtitle: 'Inform customers when your physical shop is open or dispatch team is active.',
                  children: [
                    const Text(
                      'Available Operating Days *',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((d) {
                        final on = _availableDays.contains(d);
                        return FilterChip(
                          label: Text(d),
                          selected: on,
                          selectedColor: const Color(0xFFFFF1F2),
                          checkmarkColor: WomenProductsSellerProfileCompletionScreen.primary,
                          onSelected: (v) => setState(() {
                            if (v) {
                              _availableDays.add(d);
                            } else {
                              _availableDays.remove(d);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickTime(true),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Opening Time *', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_rounded, size: 16, color: WomenProductsSellerProfileCompletionScreen.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        _workingHoursFrom != null ? SellerCatalog.formatTime(_workingHoursFrom!) : '09:30',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickTime(false),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFCBD5E1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Closing Time *', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule_rounded, size: 16, color: WomenProductsSellerProfileCompletionScreen.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        _workingHoursTo != null ? SellerCatalog.formatTime(_workingHoursTo!) : '20:00',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // SECTION 7: About the Shop & Brand Story
                _sectionCard(
                  icon: Icons.menu_book_rounded,
                  sectionNumber: '7',
                  title: 'About the Shop & Brand Story',
                  subtitle: 'Share your journey, values, product uniqueness, and artisanal philosophy.',
                  children: [
                    _field(
                      _description,
                      '7.1',
                      'Shop Description',
                      required: true,
                      hint: 'Tell customers about your brand heritage, quality standards, and craftsmanship (min 10 characters)...',
                      maxLines: 4,
                      maxLength: 2000,
                    ),
                  ],
                ),

                // SECTION 8: Payout & Bank Account Details
                _sectionCard(
                  icon: Icons.account_balance_rounded,
                  sectionNumber: '8',
                  title: 'Payout & Bank Account Details',
                  subtitle: 'Payout details are encrypted and securely used to disburse customer order payments.',
                  children: [
                    _field(_accountHolder, '8.1', 'Account Holder Name', hint: 'Name as per bank passbook'),
                    _field(_bankName, '8.2', 'Bank Name', hint: 'e.g. State Bank of India, HDFC Bank'),
                    _field(
                      _accountNumber,
                      '8.3',
                      'Account Number',
                      hint: 'Enter bank account number',
                      keyboardType: TextInputType.number,
                    ),
                    _field(
                      _confirmAccountNumber,
                      '8.4',
                      'Confirm Account Number',
                      hint: 'Re-enter account number',
                      keyboardType: TextInputType.number,
                    ),
                    if (_accountNumber.text.isNotEmpty && _confirmAccountNumber.text.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              _accountNumber.text == _confirmAccountNumber.text ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              size: 16,
                              color: _accountNumber.text == _confirmAccountNumber.text ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _accountNumber.text == _confirmAccountNumber.text ? 'Account numbers match' : 'Account numbers do not match',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _accountNumber.text == _confirmAccountNumber.text ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    _field(
                      _ifsc,
                      '8.5',
                      'IFSC Code',
                      hint: 'e.g. SBIN0001234',
                      maxLength: 11,
                    ),
                    _field(_branchName, '8.6', 'Branch Name', hint: 'e.g. Indiranagar, Bengaluru'),
                    _field(_upi, '8.7', 'UPI ID (Instant Payouts)', hint: 'username@bank'),
                    _field(
                      _gstin,
                      '8.8',
                      'GSTIN (Optional)',
                      hint: '15-character GSTIN (e.g. 22AAAAA0000A1Z5)',
                      maxLength: 15,
                    ),
                  ],
                ),

                // SECTION 9: Profile Photo & Verification Documents
                _sectionCard(
                  icon: Icons.photo_library_rounded,
                  sectionNumber: '9',
                  title: 'Profile Photo & Verification Documents',
                  subtitle: 'Visual assets for your store and business identity documents for account verification.',
                  children: [
                    // Profile Photo
                    const Text('Store Avatar / Portrait Photo', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: const Color(0xFFFFF1F2),
                          backgroundImage: _profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
                              ? NetworkImage(_profilePhotoPath!) as ImageProvider
                              : null,
                          child: (_profilePhotoPath == null || _profilePhotoPath!.isEmpty)
                              ? Text(
                                  _fullName.text.isNotEmpty ? _fullName.text.substring(0, 1).toUpperCase() : 'S',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: WomenProductsSellerProfileCompletionScreen.primary),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _uploadingPhoto ? null : () => _uploadFile(kind: 'photo'),
                                icon: _uploadingPhoto
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.camera_alt_rounded, size: 16),
                                label: const Text('Choose Photo'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: WomenProductsSellerProfileCompletionScreen.primary,
                                  side: const BorderSide(color: WomenProductsSellerProfileCompletionScreen.roseBorder),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('JPG, PNG or WEBP under 5MB.', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24, color: Color(0xFFF1F5F9)),

                    // Identity Document
                    const Text('Identity Document (Aadhaar / Voter ID / MSME / GST)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _uploadingDoc
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(
                              _identityDocPath != null && _identityDocPath!.isNotEmpty ? Icons.task_alt_rounded : Icons.upload_file_rounded,
                              color: _identityDocPath != null && _identityDocPath!.isNotEmpty ? const Color(0xFF16A34A) : WomenProductsSellerProfileCompletionScreen.primary,
                            ),
                      title: Text(
                        _identityDocPath != null && _identityDocPath!.isNotEmpty ? 'Identity Document Uploaded' : 'Upload Verification Document',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      subtitle: const Text('PDF, JPG or PNG (Encrypted for Admin Verification)'),
                      trailing: OutlinedButton(
                        onPressed: _uploadingDoc ? null : () => _uploadFile(kind: 'doc'),
                        child: Text(_identityDocPath != null && _identityDocPath!.isNotEmpty ? 'Replace' : 'Upload'),
                      ),
                    ),

                    const Divider(height: 24, color: Color(0xFFF1F5F9)),

                    // Gallery Photos
                    const Text('Workshop / Store Showcase Photos', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _uploadingGallery ? null : () => _uploadFile(kind: 'gallery'),
                      icon: _uploadingGallery
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.add_photo_alternate_rounded, size: 18),
                      label: Text('Add Showcase Photo (${_galleryPhotos.length} uploaded)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: WomenProductsSellerProfileCompletionScreen.navy,
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Live Storefront Preview Card (matching website seller-profile.jsp lines 1260-1327)
                _storefrontPreviewCard(pct),

                const SizedBox(height: 24),

                // Bottom Save & Submit Buttons
                FilledButton.icon(
                  onPressed: _saving ? null : _saveProfile,
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_outline_rounded, size: 20),
                  label: const Text('Save & Update Profile', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  style: FilledButton.styleFrom(
                    backgroundColor: WomenProductsSellerProfileCompletionScreen.navy,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),

                const SizedBox(height: 12),

                FilledButton.icon(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 20),
                  label: const Text('Submit for Admin Verification', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  style: FilledButton.styleFrom(
                    backgroundColor: WomenProductsSellerProfileCompletionScreen.primary,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String sectionNumber,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
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
                child: Icon(icon, color: WomenProductsSellerProfileCompletionScreen.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$sectionNumber. $title',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: WomenProductsSellerProfileCompletionScreen.navy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.3),
          ),
          const Divider(height: 24, color: Color(0xFFF1F5F9)),
          ...children,
        ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          hintText: hint,
          helperText: ProfileFieldHelper.instructionForField(label: label, hint: hint, required: required),
          helperMaxLines: 2,
          counterText: maxLength != null ? null : '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: WomenProductsSellerProfileCompletionScreen.primary, width: 1.5)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 3),
                  Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: WomenProductsSellerProfileCompletionScreen.navy)),
                ],
              ),
            ),
            Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
          ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value != null && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          helperText: ProfileFieldHelper.instructionForField(label: label, required: required),
          helperMaxLines: 2,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: WomenProductsSellerProfileCompletionScreen.primary, width: 1.5)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: (v) {
          onChanged(v);
          setState(() {});
        },
      ),
    );
  }

  Widget _storefrontPreviewCard(double pct) {
    final shop = _businessName.text.isNotEmpty ? _businessName.text : 'Store Name';
    final founder = _fullName.text.isNotEmpty ? _fullName.text : 'Founder Name';
    final cat = _category.text.isNotEmpty ? _category.text : 'General Products';
    final brand = _brandType ?? 'Artisan Boutique';
    final phone = _phone.text.isNotEmpty ? _phone.text : '+91 98765 43210';
    final location = [_city.text, _state].where((e) => e != null && e.isNotEmpty).join(', ');
    final fromStr = _workingHoursFrom != null ? SellerCatalog.formatTime(_workingHoursFrom!) : '09:30';
    final toStr = _workingHoursTo != null ? SellerCatalog.formatTime(_workingHoursTo!) : '20:00';
    final status = (_profile['partnerProfileStatus'] ?? 'PENDING').toString().toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECDD3), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0FF43F5E),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.storefront_rounded, size: 18, color: WomenProductsSellerProfileCompletionScreen.primary),
                  SizedBox(width: 8),
                  Text(
                    'Storefront Live Preview',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: WomenProductsSellerProfileCompletionScreen.navy),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFECDD3)),
                ),
                child: Text(
                  '${pct.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: WomenProductsSellerProfileCompletionScreen.primary),
                ),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFF1F2),
                backgroundImage: _profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
                    ? NetworkImage(_profilePhotoPath!) as ImageProvider
                    : null,
                child: (_profilePhotoPath == null || _profilePhotoPath!.isEmpty)
                    ? Text(
                        founder.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenProductsSellerProfileCompletionScreen.primary),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      founder,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: WomenProductsSellerProfileCompletionScreen.navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shop,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: WomenProductsSellerProfileCompletionScreen.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _previewMeta(Icons.phone_outlined, phone),
          if (location.isNotEmpty) _previewMeta(Icons.location_on_outlined, location),
          _previewMeta(Icons.access_time_rounded, '$fromStr – $toStr'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _previewChip(cat, const Color(0xFFF1F5F9), const Color(0xFF334155)),
              _previewChip(brand, const Color(0xFFF1F5F9), const Color(0xFF334155)),
              _previewChip(
                status,
                status == 'APPROVED' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                status == 'APPROVED' ? const Color(0xFF15803D) : const Color(0xFFB45309),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewMeta(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: text),
      ),
    );
  }
}
