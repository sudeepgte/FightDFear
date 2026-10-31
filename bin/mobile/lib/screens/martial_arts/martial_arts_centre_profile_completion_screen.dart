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
import 'martial_arts_centre_dashboard_screen.dart';
import 'martial_arts_centre_pending_approval_screen.dart';

/// Exact functional replica of the website's Centre Profile Completion form (`centreProfileCompletion.jsp`).
/// Preserves every section, field, validation rule, helper text, and submission workflow.
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
  // Section 1: Centre Identity & Contact
  final _name = TextEditingController();
  final _contactPerson = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _yearStarted = TextEditingController();
  final _affiliation = TextEditingController();
  String? _centreType = 'Academy';
  String? _designation = 'Head coach';

  // Section 2: Location & Address
  final _location = TextEditingController();
  String _selectedCountry = 'India';
  String? _selectedState;
  String? _selectedDistrict;
  final _customCity = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLink = TextEditingController();
  double? _centreLat;
  double? _centreLng;

  // Section 3: Martial Arts Styles
  final Set<String> _styles = {};

  // Section 4: Target Audience
  final Set<String> _audience = {};

  // Section 5: Training Environment & Amenities
  bool _womenOnly = false;
  bool _femaleInstructor = false;
  final Set<String> _facilities = {};

  // Section 6: Working Hours & Schedule
  final Set<String> _availableDays = {};
  TimeOfDay _openTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 21, minute: 0);

  // Section 7: About the Centre & Methodology
  final _about = TextEditingController();
  final _howWeTeach = TextEditingController();
  final Set<String> _offers = {};

  // Section 8: Payout & Bank Account Details
  final _upiId = TextEditingController();
  final _bankAccountHolder = TextEditingController();
  final _bankName = TextEditingController();
  final _bankAccountNumber = TextEditingController();
  final _confirmAccountNumber = TextEditingController();
  final _bankIfsc = TextEditingController();
  final _bankBranch = TextEditingController();

  // Uploads & files
  String? _profilePhotoPath;
  File? _newProfilePhotoFile;
  String? _certificatePath;
  File? _newCertificateFile;
  List<String> _savedGalleryPhotos = [];
  List<File> _newGalleryFiles = [];

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _profile = {};

  CentreAuthService get _svc => CentreAuthService(context.read<AuthState>().api);
  String get _baseUrl => context.read<AuthState>().api.baseUrl;

  // Exact styles matching centreProfileCompletion.jsp
  static const List<String> kStylesList = [
    'Karate',
    'Taekwondo',
    'Self-Defence',
    'Kickboxing',
    'Boxing',
    'MMA',
    'Judo',
    'Krav Maga',
    'Jiu-Jitsu',
    'Kung Fu',
    'Muay Thai',
    'Kalari',
  ];

  // Exact audience matching centreProfileCompletion.jsp
  static const List<String> kAudienceList = [
    'Women & Girls',
    'Kids (5-12 yrs)',
    'Teens & College Students',
    'Beginners & Working Women',
    'Professional Athletes',
    'Senior Citizens',
  ];

  // Exact amenities matching centreProfileCompletion.jsp
  static const List<String> kFacilitiesList = [
    'Tatami Mats',
    'Changing Rooms',
    'Drinking Water',
    'Punching Bags',
    'First Aid Box',
    'CCTV Security',
    'Shower Area',
    'Air Conditioning / Ventilation',
  ];

  // Exact days matching centreProfileCompletion.jsp
  static const List<String> kDaysList = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  // Exact offers matching centreProfileCompletion.jsp
  static const List<String> kOffersList = [
    'Regular class',
    'Trial class',
    'Belt grading',
    'Workshops',
    'Self-defence crash course',
  ];

  // Exact Centre Types matching centreProfileCompletion.jsp
  static const List<String> kCentreTypes = [
    'Academy',
    'Dojo',
    'Training hall',
    'Home studio',
    'Community hall',
    'Outdoor',
  ];

  // Exact Designations matching centreProfileCompletion.jsp
  static const List<String> kDesignations = [
    'Head coach',
    'Owner',
    'Manager',
    'Instructor',
  ];

  // Exact Countries matching centreProfileCompletion.jsp
  static const List<String> kCountries = [
    'India',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'United Arab Emirates',
    'Singapore',
    'Other',
  ];

  // State -> Districts dataset matching centreProfileCompletion.jsp
  static const Map<String, List<String>> kStateDistricts = {
    'Andhra Pradesh': ['Ananthapuramu', 'Chittoor', 'East Godavari', 'Eluru', 'Guntur', 'Kakinada', 'Krishna', 'Kurnool', 'NTR', 'Palnadu', 'Prakasam', 'Srikakulam', 'Tirupati', 'Visakhapatnam', 'Vizianagaram', 'West Godavari', 'YSR Kadapa', 'Other'],
    'Assam': ['Guwahati (Kamrup Metro)', 'Kamrup', 'Dibrugarh', 'Silchar (Cachar)', 'Jorhat', 'Nagaon', 'Tinsukia', 'Tezpur (Sonitpur)', 'Barpeta', 'Dhubri', 'Other'],
    'Bihar': ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Purnia', 'Darbhanga', 'Bihar Sharif (Nalanda)', 'Arrah (Bhojpur)', 'Begusarai', 'Katihar', 'Munger', 'Other'],
    'Delhi': ['Central Delhi', 'East Delhi', 'New Delhi', 'North Delhi', 'North East Delhi', 'North West Delhi', 'South Delhi', 'South East Delhi', 'South West Delhi', 'West Delhi', 'Other'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar', 'Jamnagar', 'Gandhinagar', 'Junagadh', 'Anand', 'Navsari', 'Other'],
    'Haryana': ['Gurugram', 'Faridabad', 'Panipat', 'Ambala', 'Yamunanagar', 'Rohtak', 'Hisar', 'Karnal', 'Sonipat', 'Panchkula', 'Other'],
    'Karnataka': ['Bengaluru Urban', 'Bengaluru Rural', 'Mysuru', 'Hubballi-Dharwad', 'Mangaluru (Dakshina Kannada)', 'Belagavi', 'Kalaburagi', 'Ballari', 'Udupi', 'Other'],
    'Kerala': ['Thiruvananthapuram', 'Ernakulam (Kochi)', 'Kozhikode', 'Thrissur', 'Kollam', 'Palakkad', 'Malappuram', 'Kannur', 'Kottayam', 'Alappuzha', 'Other'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Jabalpur', 'Gwalior', 'Ujjain', 'Sagar', 'Dewas', 'Satna', 'Ratlam', 'Rewa', 'Other'],
    'Maharashtra': ['Mumbai City', 'Mumbai Suburban', 'Pune', 'Nagpur', 'Thane', 'Nashik', 'Chhatrapati Sambhajinagar (Aurangabad)', 'Solapur', 'Kolhapur', 'Amravati', 'Navi Mumbai', 'Other'],
    'Punjab': ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda', 'Mohali (SAS Nagar)', 'Hoshiarpur', 'Batala', 'Pathankot', 'Moga', 'Other'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Kota', 'Bikaner', 'Ajmer', 'Udaipur', 'Bhilwara', 'Alwar', 'Bharatpur', 'Sikar', 'Other'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Tiruppur', 'Erode', 'Vellore', 'Thoothukudi', 'Other'],
    'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Khammam', 'Karimnagar', 'Ramagundam', 'Mahbubnagar', 'Nalgonda', 'Other'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Ghaziabad', 'Agra', 'Varanasi', 'Meerut', 'Prayagraj (Allahabad)', 'Bareilly', 'Aligarh', 'Moradabad', 'Noida (Gautam Buddha Nagar)', 'Other'],
    'West Bengal': ['Kolkata', 'Howrah', 'North 24 Parganas', 'South 24 Parganas', 'Siliguri (Darjeeling)', 'Asansol (Paschim Bardhaman)', 'Durgapur', 'Other'],
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _contactPerson.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _yearStarted.dispose();
    _affiliation.dispose();
    _location.dispose();
    _customCity.dispose();
    _pincode.dispose();
    _mapLink.dispose();
    _about.dispose();
    _howWeTeach.dispose();
    _upiId.dispose();
    _bankAccountHolder.dispose();
    _bankName.dispose();
    _bankAccountNumber.dispose();
    _confirmAccountNumber.dispose();
    _bankIfsc.dispose();
    _bankBranch.dispose();
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
    _name.text = p['name']?.toString() ?? '';
    _contactPerson.text = p['contactPerson']?.toString() ?? '';
    _phone.text = p['phoneNumber']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _yearStarted.text = p['yearStarted']?.toString() ?? '';
    _affiliation.text = p['affiliation']?.toString() ?? '';

    final cType = p['centreType']?.toString();
    if (cType != null && kCentreTypes.contains(cType)) {
      _centreType = cType;
    } else if (cType != null && cType.isNotEmpty) {
      _centreType = cType;
    }

    final desig = p['designation']?.toString();
    if (desig != null && kDesignations.contains(desig)) {
      _designation = desig;
    }

    _location.text = p['location']?.toString() ?? p['area']?.toString() ?? '';

    // State & City
    final st = p['state']?.toString();
    if (st != null && st.isNotEmpty) {
      _selectedState = st;
    }
    final ct = p['city']?.toString() ?? '';
    if (ct.isNotEmpty) {
      final districts = kStateDistricts[_selectedState] ?? ['Other'];
      if (districts.contains(ct)) {
        _selectedDistrict = ct;
      } else {
        _selectedDistrict = 'Other';
        _customCity.text = ct;
      }
    }

    _pincode.text = p['pincode']?.toString() ?? '';
    _mapLink.text = p['googleMapLocation']?.toString() ?? '';
    _centreLat = p['centreLat'] is num ? (p['centreLat'] as num).toDouble() : double.tryParse('${p['centreLat'] ?? ''}');
    _centreLng = p['centreLng'] is num ? (p['centreLng'] as num).toDouble() : double.tryParse('${p['centreLng'] ?? ''}');

    _styles.clear();
    _styles.addAll(MartialArtsCatalog.splitCsv(p['stylesTaught']));

    _audience.clear();
    _audience.addAll(MartialArtsCatalog.splitCsv(p['audience']));

    _womenOnly = p['womenOnlyBatches'] == true;
    _femaleInstructor = p['femaleInstructor'] == true;

    _facilities.clear();
    _facilities.addAll(MartialArtsCatalog.splitCsv(p['facilities']));

    _availableDays.clear();
    _availableDays.addAll(MartialArtsCatalog.splitCsv(p['availableDays']).map((e) => e.toUpperCase()));

    _openTime = MartialArtsCatalog.parseTime(p['openTime']?.toString()) ?? const TimeOfDay(hour: 6, minute: 0);
    _closeTime = MartialArtsCatalog.parseTime(p['closeTime']?.toString()) ?? const TimeOfDay(hour: 21, minute: 0);

    _about.text = p['about']?.toString() ?? '';
    _howWeTeach.text = p['howWeTeach']?.toString() ?? '';

    _offers.clear();
    _offers.addAll(MartialArtsCatalog.splitCsv(p['whatWeOffer']));

    _upiId.text = p['upiId']?.toString() ?? '';

    // Parse bankDetails string
    _parseBankDetails(p['bankDetails']?.toString());

    // Photos
    _profilePhotoPath = p['profilePhoto']?.toString();
    _certificatePath = p['certificatePath']?.toString();
    if (p['galleryPhotos'] is List) {
      _savedGalleryPhotos = (p['galleryPhotos'] as List).map((e) => e.toString()).toList();
    }
  }

  void _parseBankDetails(String? raw) {
    if (raw == null || raw.trim().isEmpty) return;
    if (raw.contains('|')) {
      for (final part in raw.split('|')) {
        final lower = part.trim().toLowerCase();
        final colon = part.indexOf(':');
        if (colon < 0) continue;
        final val = part.substring(colon + 1).trim();
        if (lower.startsWith('account holder:')) {
          _bankAccountHolder.text = val;
        } else if (lower.startsWith('bank:')) {
          _bankName.text = val;
        } else if (lower.startsWith('a/c:') || lower.startsWith('account:')) {
          _bankAccountNumber.text = val;
          _confirmAccountNumber.text = val;
        } else if (lower.startsWith('ifsc:')) {
          _bankIfsc.text = val;
        } else if (lower.startsWith('branch:')) {
          _bankBranch.text = val;
        }
      }
    } else {
      _bankAccountHolder.text = raw.trim();
    }
  }

  String _serializeBankDetails() {
    final holder = _bankAccountHolder.text.trim();
    final bank = _bankName.text.trim();
    final acc = _bankAccountNumber.text.trim();
    final ifsc = _bankIfsc.text.trim().toUpperCase();
    final branch = _bankBranch.text.trim();
    if (holder.isEmpty && bank.isEmpty && acc.isEmpty) return '';
    return 'Account Holder: $holder | Bank: $bank | A/C: $acc | IFSC: $ifsc | Branch: $branch';
  }

  String get _effectiveCity {
    if (_selectedDistrict == 'Other') {
      return _customCity.text.trim();
    }
    return _selectedDistrict ?? '';
  }

  // 16 Milestones Calculation matching centreProfileCompletion.jsp
  int _calculateMilestoneProgress() {
    int filled = 0;
    if (_name.text.trim().length >= 2) filled++;
    if ((_centreType ?? '').isNotEmpty) filled++;
    if (_contactPerson.text.trim().length >= 2) filled++;
    if (RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text.trim())) filled++;
    if (_location.text.trim().length >= 3) filled++;
    if (_effectiveCity.isNotEmpty) filled++;
    if ((_selectedState ?? '').isNotEmpty) filled++;
    if (RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim())) filled++;
    if (_styles.isNotEmpty) filled++;
    if (_audience.isNotEmpty) filled++;
    if (_availableDays.isNotEmpty) filled++;
    filled++; // openTime (always set)
    filled++; // closeTime (always set)
    if (_about.text.trim().length >= 10) filled++;
    if (_howWeTeach.text.trim().length >= 10) filled++;
    if (_offers.isNotEmpty) filled++;
    return ((filled / 16.0) * 100).round().clamp(0, 100);
  }

  List<String> _getMissingMilestoneItems() {
    final missing = <String>[];
    if (_name.text.trim().length < 2) missing.add('1.1 Centre name');
    if ((_centreType ?? '').isEmpty) missing.add('1.2 Centre type');
    if (_contactPerson.text.trim().length < 2) missing.add('1.3 Owner / head coach');
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text.trim())) missing.add('1.5 Official phone (10 digits)');
    if (_location.text.trim().length < 3) missing.add('2.1 Street address');
    if (_effectiveCity.isEmpty) missing.add('2.4 District / City');
    if ((_selectedState ?? '').isEmpty) missing.add('2.3 State / Region');
    if (!RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim())) missing.add('2.5 Pincode (6 digits)');
    if (_styles.isEmpty) missing.add('3. Martial Arts Styles');
    if (_audience.isEmpty) missing.add('4. Target Audience');
    if (_availableDays.isEmpty) missing.add('6.1 Open Days');
    if (_about.text.trim().length < 10) missing.add('7.1 About the Centre (min 10 chars)');
    if (_howWeTeach.text.trim().length < 10) missing.add('7.2 Teaching Methodology (min 10 chars)');
    if (_offers.isEmpty) missing.add('7.3 What We Offer');
    return missing;
  }

  Map<String, dynamic> _buildProfilePayload() {
    return {
      'name': _name.text.trim(),
      'centreType': _centreType,
      'contactPerson': _contactPerson.text.trim(),
      'designation': _designation,
      'phoneNumber': _phone.text.trim(),
      'whatsappNumber': _whatsapp.text.trim(),
      'yearStarted': int.tryParse(_yearStarted.text.trim()),
      'affiliation': _affiliation.text.trim(),
      'location': _location.text.trim(),
      'area': _location.text.trim(),
      'country': _selectedCountry,
      'state': _selectedState ?? '',
      'city': _effectiveCity,
      'pincode': _pincode.text.trim(),
      'googleMapLocation': _mapLink.text.trim(),
      if (_centreLat != null) 'centreLat': _centreLat,
      if (_centreLng != null) 'centreLng': _centreLng,
      'stylesTaught': _styles.toList(),
      'audience': _audience.toList(),
      'womenOnlyBatches': _womenOnly,
      'femaleInstructor': _femaleInstructor,
      'facilities': _facilities.toList(),
      'availableDays': _availableDays.toList(),
      'openTime': MartialArtsCatalog.formatTime(_openTime),
      'closeTime': MartialArtsCatalog.formatTime(_closeTime),
      'about': _about.text.trim(),
      'howWeTeach': _howWeTeach.text.trim(),
      'whatWeOffer': _offers.toList(),
      'upiId': _upiId.text.trim(),
      'bankDetails': _serializeBankDetails(),
    };
  }

  String? _validate({required bool forSubmit}) {
    if (_name.text.trim().length < 2) return '1.1 Centre name is required (minimum 2 characters)';
    if ((_centreType ?? '').isEmpty) return '1.2 Centre type is required';
    if (_contactPerson.text.trim().length < 2) return '1.3 Owner or coach name is required (minimum 2 characters)';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(_phone.text.trim())) {
      return '1.5 Valid 10-digit phone number starting with 6, 7, 8, or 9 is required';
    }
    if (_whatsapp.text.trim().isNotEmpty && !RegExp(r'^[6-9]\d{9}$').hasMatch(_whatsapp.text.trim())) {
      return '1.6 Enter a valid 10-digit WhatsApp number';
    }
    if (_yearStarted.text.trim().isNotEmpty) {
      final y = int.tryParse(_yearStarted.text.trim());
      final curY = DateTime.now().year;
      if (y == null || y < 1950 || y > curY) {
        return '1.7 Enter a valid year started between 1950 and $curY';
      }
    }
    if (_location.text.trim().length < 3) return '2.1 Street address or hall name is required (at least 3 characters)';
    if ((_selectedState ?? '').isEmpty) return '2.3 State is required';
    if (_effectiveCity.isEmpty) return '2.4 District or City is required';
    if (!RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim())) return '2.5 Enter a valid 6-digit pincode';

    final acc = _bankAccountNumber.text.trim();
    final confirmAcc = _confirmAccountNumber.text.trim();
    if (acc.isNotEmpty && confirmAcc.isNotEmpty && acc != confirmAcc) {
      return '8.5 Bank account numbers do not match';
    }
    final ifsc = _bankIfsc.text.trim().toUpperCase();
    if (ifsc.isNotEmpty && !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      return '8.6 Invalid IFSC format (e.g. SBIN0001234)';
    }

    if (forSubmit) {
      if (_styles.isEmpty) return '3. Select at least one martial arts style taught';
      if (_audience.isEmpty) return '4. Select at least one target audience category';
      if (_availableDays.isEmpty) return '6.1 Select at least one open training day';
      if (_about.text.trim().length < 10) return '7.1 About the centre is required (minimum 10 characters)';
      if (_howWeTeach.text.trim().length < 10) return '7.2 Teaching methodology is required (minimum 10 characters)';
      if (_offers.isEmpty) return '7.3 Select at least one training offer';
    }
    return null;
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final file = File(picked.path);
    setState(() => _newProfilePhotoFile = file);
    await _uploadMultipartFile('profileImage', file);
  }

  Future<void> _pickCertificate() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (picked == null || picked.files.isEmpty || picked.files.first.path == null) return;
    final file = File(picked.files.first.path!);
    setState(() => _newCertificateFile = file);
    await _uploadMultipartFile('certificate', file);
  }

  Future<void> _pickGalleryPhotos() async {
    final picker = ImagePicker();
    final pickedList = await picker.pickMultiImage(imageQuality: 85);
    if (pickedList.isEmpty) return;
    final files = pickedList.map((x) => File(x.path)).toList();
    setState(() => _newGalleryFiles = files);

    // Upload each to backend
    for (final f in files) {
      await _uploadMultipartFile('galleryPhotos', f);
    }
  }

  Future<void> _uploadMultipartFile(String fieldName, File file) async {
    try {
      final multipart = await http.MultipartFile.fromPath(fieldName, file.path);
      final res = await _svc.updateSettings(
        fields: {
          'name': _name.text.trim().isEmpty ? (_profile['name']?.toString() ?? 'Centre') : _name.text.trim(),
          'email': _profile['email']?.toString() ?? '',
          if (_phone.text.trim().isNotEmpty) 'phoneNumber': _phone.text.trim(),
        },
        files: [multipart],
      );
      if (res['success'] == true) {
        await _load();
      }
    } catch (_) {}
  }

  Future<void> _saveProfileDirectly() async {
    final err = _validate(forSubmit: false);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final res = await _svc.updateProfile(_buildProfilePayload());
      if (!mounted) return;
      if (res['success'] == true) {
        _applyProfile(Map<String, dynamic>.from(res));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile details saved successfully!'),
            backgroundColor: Color(0xFF16A34A),
          ),
        );
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Failed to save profile');
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submitForVerification() async {
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
      // 1. Save profile payload first
      final saveRes = await _svc.updateProfile(_buildProfilePayload());
      if (saveRes['success'] != true) {
        throw Exception(saveRes['error']?.toString() ?? 'Failed to save before submitting');
      }

      // 2. Submit for verification
      final res = await _svc.submitVerification();
      if (!mounted) return;
      if (res['success'] != true) {
        final msg = res['error']?.toString() ?? res['message']?.toString() ?? '';
        if (!msg.toLowerCase().contains('already')) {
          throw Exception(msg.isNotEmpty ? msg : 'Submission failed');
        }
      }

      await showVerificationSubmittedSheet(context);
      if (!mounted) return;
      if (widget.onFinished != null) {
        widget.onFinished!(context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MartialArtsCentrePendingApprovalScreen(initialProfile: saveRes),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _openPreviewModal() {
    final name = _name.text.trim().isNotEmpty ? _name.text.trim() : 'Centre Name';
    final coach = _contactPerson.text.trim().isNotEmpty ? _contactPerson.text.trim() : 'Owner / Head Coach';
    final designation = _designation ?? 'Head coach';
    final centreType = _centreType ?? 'Academy';
    final locationStr = '${_effectiveCity.isNotEmpty ? _effectiveCity : "City"}, ${_selectedState ?? "State"}';
    final openTimeStr = MartialArtsCatalog.formatTime(_openTime);
    final closeTimeStr = MartialArtsCatalog.formatTime(_closeTime);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Modal Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.military_tech, color: Color(0xFFF43F5E), size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Centre Profile Preview',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              // Modal Content Grid
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Hero Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFE4E6)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: const Color(0xFFFFE4E6),
                            backgroundImage: _profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
                                ? NetworkImage('$_baseUrl$_profilePhotoPath')
                                : null,
                            child: _profilePhotoPath == null || _profilePhotoPath!.isEmpty
                                ? Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'M',
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E)),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                    ),
                                    const Icon(Icons.verified, color: Color(0xFFF43F5E), size: 18),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$coach ($designation)',
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                      child: Text(centreType, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                      child: Text(locationStr, style: const TextStyle(fontSize: 11, color: Color(0xFFE11D48), fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Highlights: Operating Hours & Women Safety
                    _previewBox('Operating Hours', [
                      Text('$openTimeStr - $closeTimeStr', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: _availableDays.map((d) => Chip(
                          label: Text(d.substring(0, 3)),
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    if (_womenOnly || _femaleInstructor) ...[
                      _previewBox('Women Safety Highlights', [
                        if (_womenOnly)
                          const Row(
                            children: [
                              Icon(Icons.female, color: Color(0xFFE11D48), size: 18),
                              SizedBox(width: 6),
                              Text('Exclusive Women-Only Batches', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        if (_womenOnly && _femaleInstructor) const SizedBox(height: 6),
                        if (_femaleInstructor)
                          const Row(
                            children: [
                              Icon(Icons.verified_user, color: Color(0xFF16A34A), size: 18),
                              SizedBox(width: 6),
                              Text('Female Black-Belt Instructor Present', style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                      ]),
                      const SizedBox(height: 12),
                    ],

                    // Styles Taught
                    _previewBox('Martial Arts Disciplines Offered', [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _styles.map((s) => Chip(
                          label: Text(s),
                          backgroundColor: const Color(0xFFFFF1F2),
                          labelStyle: const TextStyle(color: Color(0xFFE11D48), fontWeight: FontWeight.w600),
                        )).toList(),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // Who Can Join
                    _previewBox('Who Can Join', [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: _audience.map((a) => Chip(label: Text(a))).toList(),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // Amenities
                    if (_facilities.isNotEmpty) ...[
                      _previewBox('Dojo Amenities & Facilities', [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _facilities.map((f) => Chip(
                            avatar: const Icon(Icons.check, size: 16, color: Color(0xFF16A34A)),
                            label: Text(f),
                          )).toList(),
                        ),
                      ]),
                      const SizedBox(height: 12),
                    ],

                    // About
                    _previewBox('About the Centre', [
                      Text(
                        _about.text.trim().isNotEmpty ? _about.text.trim() : 'Dedicated martial arts and personal defense academy.',
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // How We Teach
                    _previewBox('Teaching Methodology', [
                      Text(
                        _howWeTeach.text.trim().isNotEmpty ? _howWeTeach.text.trim() : 'Structured belt grading syllabus, daily fitness warmups, technique drills, and practical self-defense application.',
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                    ]),
                    const SizedBox(height: 12),

                    // Bank & Settlement
                    _previewBox('Settlement & Payout Account', [
                      Text(
                        _bankAccountNumber.text.trim().isNotEmpty
                            ? 'A/C: •••• ${_bankAccountNumber.text.trim().length > 4 ? _bankAccountNumber.text.trim().substring(_bankAccountNumber.text.trim().length - 4) : _bankAccountNumber.text.trim()} (${_bankName.text.trim().isNotEmpty ? _bankName.text.trim() : "Bank"}) • IFSC: ${_bankIfsc.text.trim().toUpperCase()}${_upiId.text.trim().isNotEmpty ? " • UPI: " + _upiId.text.trim() : ""}'
                            : 'Direct Bank details not provided yet',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ]),
                  ],
                ),
              ),
              // Modal Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Back to Editing'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _submitForVerification();
                        },
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                        child: const Text('Submit for Verification'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _previewBox(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pct = _calculateMilestoneProgress();
    final missing = _getMissingMilestoneItems();
    final status = _profile['centreProfileStatus']?.toString() ?? 'PROFILE_INCOMPLETE';
    final changesNote = _profile['changesRequestedNote']?.toString();
    final rejectionReason = _profile['rejectionReason']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Complete Centre Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreProfileCompletionScreen.navy,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _loading || _saving ? null : _saveProfileDirectly,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              children: [
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Text(_error!, style: const TextStyle(color: Color(0xFFDC2626))),
                  ),
                ],
                if (changesNote != null && changesNote.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDBA74)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Admin Review Feedback', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9A3412))),
                              const SizedBox(height: 4),
                              Text(changesNote, style: const TextStyle(fontSize: 13, color: Color(0xFF7C2D12))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Registration Rejected', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF991B1B))),
                              const SizedBox(height: 4),
                              Text(rejectionReason, style: const TextStyle(fontSize: 13, color: Color(0xFF7F1D1D))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Real-time 16 Milestones Progress Card matching website
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile Verification Progress',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              '$pct%',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFFF43F5E)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: pct / 100.0,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFFFE4E6),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF43F5E)),
                          ),
                        ),
                        if (missing.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Missing items (${missing.length}):',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: missing.map((m) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFFFE4E6)),
                              ),
                              child: Text(m, style: const TextStyle(fontSize: 11, color: Color(0xFFE11D48))),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // SECTION 0: Official Centre Logo / Profile Image
                _sectionCard(
                  title: 'Official Centre Logo / Profile Image',
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFFFE4E6),
                        backgroundImage: _newProfilePhotoFile != null
                            ? FileImage(_newProfilePhotoFile!)
                            : (_profilePhotoPath != null && _profilePhotoPath!.isNotEmpty
                                ? NetworkImage('$_baseUrl$_profilePhotoPath')
                                : null) as ImageProvider?,
                        child: (_newProfilePhotoFile == null && (_profilePhotoPath == null || _profilePhotoPath!.isEmpty))
                            ? Text(
                                _name.text.isNotEmpty ? _name.text[0].toUpperCase() : 'M',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF43F5E)),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Upload Dojo Logo / Facade Photo',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'A clear, professional logo or centre front photo increases student trust. Accepts JPG, PNG, or WebP (max 5MB).',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: _pickPhoto,
                              icon: const Icon(Icons.upload, size: 16),
                              label: const Text('Choose Centre Logo'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // SECTION 1: Centre Identity & Contact
                _sectionCard(
                  title: '1. Centre Identity & Contact',
                  child: Column(
                    children: [
                      TextField(
                        controller: _name,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '1.1 Centre Name *',
                          hintText: 'e.g. Apex Martial Arts Academy',
                          helperText: 'Official academy, dojo or training studio name (minimum 2 characters).',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _centreType,
                        decoration: const InputDecoration(
                          labelText: '1.2 Centre Type *',
                          border: OutlineInputBorder(),
                        ),
                        items: kCentreTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (v) => setState(() => _centreType = v),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _contactPerson,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '1.3 Owner / Head Coach *',
                          hintText: 'e.g. Sensei Rajesh Kumar',
                          helperText: 'Name of chief instructor or manager (letters and spaces only).',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _designation,
                        decoration: const InputDecoration(
                          labelText: '1.4 Designation',
                          border: OutlineInputBorder(),
                        ),
                        items: kDesignations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                        onChanged: (v) => setState(() => _designation = v),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '1.5 Official Phone Number *',
                          hintText: '10-digit mobile number',
                          helperText: '10-digit mobile number starting with 6, 7, 8, or 9.',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _whatsapp,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '1.6 WhatsApp Number',
                          hintText: '10-digit WhatsApp number',
                          helperText: 'Optional direct student inquiry number (10 digits).',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _yearStarted,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '1.7 Year Started',
                          hintText: 'e.g. 2018',
                          helperText: 'Year established between 1950 and current year.',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _affiliation,
                        decoration: const InputDecoration(
                          labelText: '1.8 Federation / Style Affiliation',
                          hintText: 'e.g. World Karate Federation, KAI, Indian Boxing Association',
                          helperText: 'Official sports council, federation, or black-belt certifying body.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                // SECTION 2: Location & Premises Address
                _sectionCard(
                  title: '2. Location & Premises Address',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _location,
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '2.1 Street Address / Hall / Landmark *',
                          hintText: 'Door/Plot No, Hall name, Landmark, Road',
                          helperText: 'Full premises address, training floor, or landmark for student navigation.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: '2.2 Country *',
                          helperText: 'Selecting a country updates the available states / regions',
                          border: OutlineInputBorder(),
                        ),
                        items: kCountries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedCountry = v ?? 'India';
                            _selectedState = null;
                            _selectedDistrict = null;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: const InputDecoration(
                          labelText: '2.3 State / Region *',
                          helperText: 'Selecting a state updates the available districts / cities',
                          border: OutlineInputBorder(),
                        ),
                        items: (kStateDistricts.keys.toList()).map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedState = v;
                            _selectedDistrict = null;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: _selectedDistrict,
                        decoration: const InputDecoration(
                          labelText: '2.4 District / City *',
                          helperText: "Filters to chosen state's districts / cities",
                          border: OutlineInputBorder(),
                        ),
                        items: (_selectedState != null && kStateDistricts.containsKey(_selectedState))
                            ? kStateDistricts[_selectedState]!.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList()
                            : const [DropdownMenuItem(value: 'Other', child: Text('Other'))],
                        onChanged: (v) {
                          setState(() {
                            _selectedDistrict = v;
                          });
                        },
                      ),
                      if (_selectedDistrict == 'Other') ...[
                        const SizedBox(height: 14),
                        TextField(
                          controller: _customCity,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Custom City / Town Name *',
                            hintText: 'Type city or town name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      TextField(
                        controller: _pincode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '2.5 Pincode *',
                          hintText: '6-digit Pincode',
                          helperText: '6-digit postal code (e.g. 400001).',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _mapLink,
                        decoration: const InputDecoration(
                          labelText: '2.6 Google Map Location Link',
                          hintText: 'https://maps.google.com/?q=... or click Select from Map',
                          helperText: 'Click Select from Map to search or pin your centre, or paste your Google Maps link.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ProfileLocationPicker(
                        lat: _centreLat,
                        lng: _centreLng,
                        mapLinkController: _mapLink,
                        pinLabel: 'Select from Map',
                        onPinned: (lat, lng) => setState(() {
                          _centreLat = lat;
                          _centreLng = lng;
                        }),
                        onError: (msg) => setState(() => _error = msg),
                      ),
                    ],
                  ),
                ),

                // SECTION 3: Martial Arts Styles Taught *
                _sectionCard(
                  title: '3. Martial Arts Styles Taught *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select all combat disciplines and martial arts systems offered at your centre:',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kStylesList.map((style) {
                          final selected = _styles.contains(style);
                          return FilterChip(
                            label: Text(style),
                            selected: selected,
                            selectedColor: const Color(0xFFFFF1F2),
                            checkmarkColor: const Color(0xFFF43F5E),
                            labelStyle: TextStyle(
                              color: selected ? const Color(0xFFF43F5E) : const Color(0xFF0F172A),
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _styles.add(style);
                                } else {
                                  _styles.remove(style);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // SECTION 4: Who Can Join (Target Audience) *
                _sectionCard(
                  title: '4. Who Can Join (Target Audience) *',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kAudienceList.map((aud) {
                      final selected = _audience.contains(aud);
                      return FilterChip(
                        label: Text(aud),
                        selected: selected,
                        selectedColor: const Color(0xFFFFF1F2),
                        checkmarkColor: const Color(0xFFF43F5E),
                        labelStyle: TextStyle(
                          color: selected ? const Color(0xFFF43F5E) : const Color(0xFF0F172A),
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _audience.add(aud);
                            } else {
                              _audience.remove(aud);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                // SECTION 5: Training Environment & Amenities
                _sectionCard(
                  title: '5. Training Environment & Amenities',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Exclusive Women-Only Batches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Dedicated slots reserved exclusively for female students and girls', style: TextStyle(fontSize: 12)),
                        value: _womenOnly,
                        activeColor: const Color(0xFFF43F5E),
                        onChanged: (v) => setState(() => _womenOnly = v),
                      ),
                      const Divider(),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Female Black-Belt Instructor Present', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Certified female trainers and coaches actively conducting training', style: TextStyle(fontSize: 12)),
                        value: _femaleInstructor,
                        activeColor: const Color(0xFF16A34A),
                        onChanged: (v) => setState(() => _femaleInstructor = v),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Dojo Amenities & Facilities:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kFacilitiesList.map((fac) {
                          final selected = _facilities.contains(fac);
                          return FilterChip(
                            label: Text(fac),
                            selected: selected,
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _facilities.add(fac);
                                } else {
                                  _facilities.remove(fac);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // SECTION 6: Available Days & Timings *
                _sectionCard(
                  title: '6. Available Days & Timings *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('6.1 Open Days *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kDaysList.map((d) {
                          final selected = _availableDays.contains(d);
                          return FilterChip(
                            label: Text(d.substring(0, 3)),
                            selected: selected,
                            selectedColor: const Color(0xFFFFF1F2),
                            checkmarkColor: const Color(0xFFF43F5E),
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _availableDays.add(d);
                                } else {
                                  _availableDays.remove(d);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('6.2 Opening Time *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              subtitle: Text(MartialArtsCatalog.formatTime(_openTime), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              trailing: const Icon(Icons.access_time),
                              onTap: () async {
                                final picked = await showTimePicker(context: context, initialTime: _openTime);
                                if (picked != null) setState(() => _openTime = picked);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('6.3 Closing Time *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              subtitle: Text(MartialArtsCatalog.formatTime(_closeTime), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              trailing: const Icon(Icons.access_time),
                              onTap: () async {
                                final picked = await showTimePicker(context: context, initialTime: _closeTime);
                                if (picked != null) setState(() => _closeTime = picked);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // SECTION 7: About the Centre & Methodology *
                _sectionCard(
                  title: '7. About the Centre & Methodology *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _about,
                        maxLines: 4,
                        maxLength: 2000,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '7.1 About the Centre & Philosophy *',
                          hintText: 'Describe your training ethos, instructors, safety standards, and dojo culture...',
                          helperText: 'Minimum 10 characters detailing your centre history and values.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _howWeTeach,
                        maxLines: 3,
                        maxLength: 1500,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          labelText: '7.2 How We Teach & Step-by-Step Methodology *',
                          hintText: 'Explain your teaching progression (warmups, belt grading, sparring, self-defense drills)...',
                          helperText: 'Minimum 10 characters describing coaching style and belt progression.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text('7.3 What We Offer *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: kOffersList.map((offer) {
                          final selected = _offers.contains(offer);
                          return FilterChip(
                            label: Text(offer),
                            selected: selected,
                            selectedColor: const Color(0xFFFFF1F2),
                            checkmarkColor: const Color(0xFFF43F5E),
                            onSelected: (val) {
                              setState(() {
                                if (val) {
                                  _offers.add(offer);
                                } else {
                                  _offers.remove(offer);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // SECTION 8: Payout & Bank Account Details
                _sectionCard(
                  title: '8. Payout & Bank Account Details',
                  child: Column(
                    children: [
                      TextField(
                        controller: _upiId,
                        decoration: const InputDecoration(
                          labelText: '8.1 Direct UPI ID (Optional)',
                          hintText: 'centre@upi',
                          helperText: 'Virtual Payment Address for automated fee settlements.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _bankAccountHolder,
                        decoration: const InputDecoration(
                          labelText: '8.2 Account Holder Name',
                          hintText: 'Name as per bank records',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _bankName,
                        decoration: const InputDecoration(
                          labelText: '8.3 Bank Name',
                          hintText: 'e.g. HDFC Bank, ICICI Bank, SBI',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _bankAccountNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '8.4 Account Number',
                          hintText: 'Bank Account Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _confirmAccountNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: '8.5 Confirm Account Number',
                          hintText: 'Re-enter Account Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _bankIfsc,
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 11,
                        decoration: const InputDecoration(
                          labelText: '8.6 IFSC Code',
                          hintText: 'e.g. HDFC0001234',
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _bankBranch,
                        decoration: const InputDecoration(
                          labelText: '8.7 Branch Name',
                          hintText: 'e.g. Andheri West Branch',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),

                // SECTION 9: Trainer Certification & Proof (Optional)
                _sectionCard(
                  title: '9. Trainer Certification & Proof (Optional)',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '9.1 Black Belt / Coach Certificate / Registration Proof',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _pickCertificate,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Choose Certificate File (.pdf, images)'),
                      ),
                      if (_newCertificateFile != null) ...[
                        const SizedBox(height: 6),
                        Text('Selected: ${_newCertificateFile!.path.split(RegExp(r"[\\/]")).last}', style: const TextStyle(fontSize: 12, color: Color(0xFF16A34A))),
                      ] else if (_certificatePath != null && _certificatePath!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 16),
                            const SizedBox(width: 6),
                            Expanded(child: Text('Certificate on file: $_certificatePath', style: const TextStyle(fontSize: 12, color: Color(0xFF16A34A)))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // SECTION 10: Centre & Dojo Gallery Photos
                _sectionCard(
                  title: '10. Centre & Dojo Gallery Photos',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upload photos of your training mats, equipment, class sessions, and student belt grading ceremonies.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _pickGalleryPhotos,
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Choose Gallery Photos (Multiple)'),
                        ),
                      ),
                      if (_newGalleryFiles.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text('${_newGalleryFiles.length} new photos selected for upload', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF16A34A))),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _newGalleryFiles.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (ctx, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_newGalleryFiles[i], width: 72, height: 72, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                      if (_savedGalleryPhotos.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text('Currently Saved Gallery Photos (${_savedGalleryPhotos.length}):', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _savedGalleryPhotos.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (ctx, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network('$_baseUrl${_savedGalleryPhotos[i]}', width: 72, height: 72, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                // Bottom Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _saveProfileDirectly,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _saving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Save Profile Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submitting ? null : _openPreviewModal,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF43F5E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _submitting
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Preview & Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}
