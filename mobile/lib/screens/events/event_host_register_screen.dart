import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/event_organizer_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/event_host_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'event_host_portal_login_screen.dart';

class EventHostRegisterScreen extends StatefulWidget {
  const EventHostRegisterScreen({super.key});

  @override
  State<EventHostRegisterScreen> createState() => _EventHostRegisterScreenState();
}

class _EventHostRegisterScreenState extends State<EventHostRegisterScreen> {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color softBg = Color(0xFFFFF1F5);
  static const Color muted = Color(0xFF64748B);
  static const _draftKey = 'event_host_register_draft_v1';
  static const _demoOtp = '123456';

  static const _steps = [
    'Org Type',
    'Events',
    'Details',
    'Venue',
    'Verify',
    'Media',
    'Account',
  ];

  final _page = PageController();
  int _step = 0;
  bool _busy = false;
  bool _locating = false;
  String? _error;

  // Account
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailOtp = TextEditingController();
  final _phoneOtp = TextEditingController();
  bool _emailVerified = false;
  bool _phoneVerified = false;
  bool _terms = false;

  // Org
  String? _orgType;
  final _fullName = TextEditingController();
  final _organizerName = TextEditingController();
  final _hostBio = TextEditingController();
  final _yearsExperience = TextEditingController();
  final _website = TextEditingController();

  // Event profile
  final Set<String> _eventCategories = {};
  String _frequency = EventOrganizerCatalog.frequencies[1];
  final Set<String> _modes = {'Offline'};
  final Set<String> _audiences = {};
  final Set<String> _languages = {'English'};
  final Set<String> _pricing = {'Free Events'};

  // Team / previous
  final _teamSize = TextEditingController();
  final _volunteers = TextEditingController();
  final _coordinators = TextEditingController();
  final _speakers = TextEditingController();
  final _totalEvents = TextEditingController();
  final _largestEvent = TextEditingController();
  final _expectedParticipants = TextEditingController();

  // Venue / location
  final Set<String> _venueTypes = {};
  final _capacity = TextEditingController();
  bool _parkingAvailable = false;
  bool _wheelchairAccessible = false;
  final Set<String> _facilities = {};
  final _address = TextEditingController();
  final _city = TextEditingController();
  String _state = RegOptions.indianStates.contains('Karnataka') ? 'Karnataka' : RegOptions.indianStates.first;
  double? _lat;
  double? _lng;

  // Verification docs
  final _gst = TextEditingController();
  final _ngoReg = TextEditingController();
  final _societyReg = TextEditingController();
  final _trustReg = TextEditingController();
  final _companyCin = TextEditingController();
  final _startupIndiaId = TextEditingController();
  String? _registrationDoc;

  // Media / gallery
  String? _logoName;
  String? _portfolioName;
  String? _photosName;
  String? _videosName;
  String? _brochureName;
  String? _certificatesName;
  String? _mediaCoverageName;

  // Social
  final _instagram = TextEditingController();
  final _facebook = TextEditingController();
  final _linkedin = TextEditingController();
  final _youtube = TextEditingController();
  final _whatsapp = TextEditingController();
  final _telegram = TextEditingController();
  final _twitter = TextEditingController();

  // Emergency
  final _emergencyPerson = TextEditingController();
  final _emergencyPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _page.dispose();
    for (final c in [
      _email, _phone, _password, _confirm, _emailOtp, _phoneOtp, _fullName,
      _organizerName, _hostBio, _yearsExperience, _website, _teamSize, _volunteers,
      _coordinators, _speakers, _totalEvents, _largestEvent, _expectedParticipants,
      _capacity, _address, _city, _gst, _ngoReg, _societyReg, _trustReg, _companyCin,
      _startupIndiaId, _instagram, _facebook, _linkedin, _youtube, _whatsapp,
      _telegram, _twitter, _emergencyPerson, _emergencyPhone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  List<OrgVerifyField> get _verifyFields =>
      EventOrganizerCatalog.byLabel(_orgType ?? '')?.verifyFields ?? const [];

  bool get _orgVerified {
    if (_registrationDoc != null && _registrationDoc!.isNotEmpty) return true;
    for (final f in _verifyFields) {
      if (_verifyController(f).text.trim().isNotEmpty) return true;
    }
    return false;
  }

  TextEditingController _verifyController(OrgVerifyField f) => switch (f) {
        OrgVerifyField.gst => _gst,
        OrgVerifyField.ngoReg => _ngoReg,
        OrgVerifyField.societyReg => _societyReg,
        OrgVerifyField.trustReg => _trustReg,
        OrgVerifyField.companyCin => _companyCin,
        OrgVerifyField.startupIndiaId => _startupIndiaId,
      };

  List<_CheckItem> get _completionItems => [
        _CheckItem('Basic details', _fullName.text.trim().isNotEmpty && _organizerName.text.trim().isNotEmpty),
        _CheckItem('Organization', _orgType != null),
        _CheckItem('Event categories', _eventCategories.isNotEmpty),
        _CheckItem('Address', _address.text.trim().isNotEmpty && _city.text.trim().isNotEmpty),
        _CheckItem('Email', RegValidators.isEmail(_email.text)),
        _CheckItem('Logo', _logoName != null && _logoName!.isNotEmpty, warnIfMissing: true),
        _CheckItem('Portfolio', _portfolioName != null && _portfolioName!.isNotEmpty, warnIfMissing: true),
      ];

  double get _completionPct {
    final items = _completionItems;
    if (items.isEmpty) return 0;
    return items.where((e) => e.ok).length / items.length;
  }

  bool get _passLen => _password.text.length >= 8;
  bool get _passUpper => RegExp(r'[A-Z]').hasMatch(_password.text);
  bool get _passLower => RegExp(r'[a-z]').hasMatch(_password.text);
  bool get _passNum => RegExp(r'[0-9]').hasMatch(_password.text);
  bool get _passSpecial => RegExp(r'[!@#$%^&*]').hasMatch(_password.text);
  bool get _passwordOk => _passLen && _passUpper && _passLower && _passNum && _passSpecial;

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        void apply(TextEditingController c, String key) => c.text = m[key]?.toString() ?? '';
        apply(_email, 'email');
        apply(_phone, 'phone');
        apply(_fullName, 'fullName');
        apply(_organizerName, 'organizerName');
        apply(_hostBio, 'hostBio');
        apply(_yearsExperience, 'yearsExperience');
        apply(_website, 'website');
        apply(_teamSize, 'teamSize');
        apply(_volunteers, 'volunteers');
        apply(_coordinators, 'coordinators');
        apply(_speakers, 'speakers');
        apply(_totalEvents, 'totalEvents');
        apply(_largestEvent, 'largestEvent');
        apply(_expectedParticipants, 'expectedParticipants');
        apply(_capacity, 'capacity');
        apply(_address, 'address');
        apply(_city, 'city');
        apply(_gst, 'gst');
        apply(_ngoReg, 'ngoReg');
        apply(_societyReg, 'societyReg');
        apply(_trustReg, 'trustReg');
        apply(_companyCin, 'companyCin');
        apply(_startupIndiaId, 'startupIndiaId');
        apply(_instagram, 'instagram');
        apply(_facebook, 'facebook');
        apply(_linkedin, 'linkedin');
        apply(_youtube, 'youtube');
        apply(_whatsapp, 'whatsapp');
        apply(_telegram, 'telegram');
        apply(_twitter, 'twitter');
        apply(_emergencyPerson, 'emergencyPerson');
        apply(_emergencyPhone, 'emergencyPhone');
        _orgType = m['orgType']?.toString();
        _frequency = m['frequency']?.toString() ?? _frequency;
        _state = m['state']?.toString() ?? _state;
        _parkingAvailable = m['parkingAvailable'] == true;
        _wheelchairAccessible = m['wheelchairAccessible'] == true;
        _lat = (m['lat'] as num?)?.toDouble();
        _lng = (m['lng'] as num?)?.toDouble();
        _logoName = m['logoName']?.toString();
        _portfolioName = m['portfolioName']?.toString();
        _registrationDoc = m['registrationDoc']?.toString();
        _photosName = m['photosName']?.toString();
        _videosName = m['videosName']?.toString();
        _brochureName = m['brochureName']?.toString();
        _certificatesName = m['certificatesName']?.toString();
        _mediaCoverageName = m['mediaCoverageName']?.toString();
        _eventCategories
          ..clear()
          ..addAll(((m['eventCategories'] as List?) ?? []).map((e) => e.toString()));
        _modes
          ..clear()
          ..addAll(((m['modes'] as List?) ?? ['Offline']).map((e) => e.toString()));
        _audiences
          ..clear()
          ..addAll(((m['audiences'] as List?) ?? []).map((e) => e.toString()));
        _languages
          ..clear()
          ..addAll(((m['languages'] as List?) ?? ['English']).map((e) => e.toString()));
        _pricing
          ..clear()
          ..addAll(((m['pricing'] as List?) ?? ['Free Events']).map((e) => e.toString()));
        _venueTypes
          ..clear()
          ..addAll(((m['venueTypes'] as List?) ?? []).map((e) => e.toString()));
        _facilities
          ..clear()
          ..addAll(((m['facilities'] as List?) ?? []).map((e) => e.toString()));
        _step = (m['step'] as num?)?.toInt().clamp(0, _steps.length - 1) ?? 0;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_page.hasClients) _page.jumpToPage(_step);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft restored — continue where you left off')),
        );
      }
    } catch (_) {}
  }

  Future<void> _saveDraft({bool notify = true}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _draftKey,
      jsonEncode({
        'step': _step,
        'email': _email.text,
        'phone': _phone.text,
        'fullName': _fullName.text,
        'organizerName': _organizerName.text,
        'hostBio': _hostBio.text,
        'yearsExperience': _yearsExperience.text,
        'website': _website.text,
        'teamSize': _teamSize.text,
        'volunteers': _volunteers.text,
        'coordinators': _coordinators.text,
        'speakers': _speakers.text,
        'totalEvents': _totalEvents.text,
        'largestEvent': _largestEvent.text,
        'expectedParticipants': _expectedParticipants.text,
        'capacity': _capacity.text,
        'address': _address.text,
        'city': _city.text,
        'state': _state,
        'gst': _gst.text,
        'ngoReg': _ngoReg.text,
        'societyReg': _societyReg.text,
        'trustReg': _trustReg.text,
        'companyCin': _companyCin.text,
        'startupIndiaId': _startupIndiaId.text,
        'instagram': _instagram.text,
        'facebook': _facebook.text,
        'linkedin': _linkedin.text,
        'youtube': _youtube.text,
        'whatsapp': _whatsapp.text,
        'telegram': _telegram.text,
        'twitter': _twitter.text,
        'emergencyPerson': _emergencyPerson.text,
        'emergencyPhone': _emergencyPhone.text,
        'orgType': _orgType,
        'frequency': _frequency,
        'parkingAvailable': _parkingAvailable,
        'wheelchairAccessible': _wheelchairAccessible,
        'lat': _lat,
        'lng': _lng,
        'logoName': _logoName,
        'portfolioName': _portfolioName,
        'registrationDoc': _registrationDoc,
        'photosName': _photosName,
        'videosName': _videosName,
        'brochureName': _brochureName,
        'certificatesName': _certificatesName,
        'mediaCoverageName': _mediaCoverageName,
        'eventCategories': _eventCategories.toList(),
        'modes': _modes.toList(),
        'audiences': _audiences.toList(),
        'languages': _languages.toList(),
        'pricing': _pricing.toList(),
        'venueTypes': _venueTypes.toList(),
        'facilities': _facilities.toList(),
      }),
    );
    if (notify && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved — you can continue later')),
      );
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_orgType == null) return 'Select an organization type';
        return null;
      case 1:
        if (_eventCategories.isEmpty) return 'Select at least one event category';
        if (_modes.isEmpty) return 'Select at least one event mode';
        return null;
      case 2:
        if (_fullName.text.trim().isEmpty) return 'Full name is required';
        if (_organizerName.text.trim().isEmpty) return 'Organization name is required';
        if (_hostBio.text.trim().isEmpty) return 'Organization description is required';
        if (_audiences.isEmpty) return 'Select your audience';
        if (_languages.isEmpty) return 'Select at least one language';
        return null;
      case 3:
        if (_venueTypes.isEmpty && !_modes.contains('Online')) {
          return 'Select venue type (or Online-only mode)';
        }
        if (_address.text.trim().isEmpty) return 'Office / venue address is required';
        if (_city.text.trim().isEmpty) return 'City is required';
        return null;
      case 4:
        if (_registrationDoc == null || _registrationDoc!.isEmpty) {
          return 'Upload organizer ID / registration document';
        }
        return null;
      case 5:
        if (_emergencyPerson.text.trim().isEmpty) return 'Emergency contact person is required';
        if (!RegValidators.isPhone10(_emergencyPhone.text)) {
          return 'Emergency phone must be 10 digits';
        }
        if (_pricing.isEmpty) return 'Select at least one pricing model';
        return null;
      case 6:
        final e = RegValidators.emailError(_email.text);
        if (e != null) return e;
        if (!RegValidators.isPhone10(_phone.text)) return 'Phone must be exactly 10 digits';
        if (!_emailVerified) return 'Please verify email OTP';
        if (!_phoneVerified) return 'Please verify phone OTP';
        if (!_passwordOk) return 'Password must meet all strength checks';
        if (_password.text != _confirm.text) return 'Passwords do not match';
        if (!_terms) return 'Please accept Terms & Conditions';
        return null;
      default:
        return null;
    }
  }

  Future<void> _next() async {
    final err = _validateStep(_step);
    if (err != null) {
      setState(() => _error = err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    setState(() => _error = null);
    await _saveDraft(notify: false);
    if (_step >= _steps.length - 1) {
      await _submit();
      return;
    }
    setState(() => _step++);
    await _page.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  Future<void> _back() async {
    if (_step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _step--;
      _error = null;
    });
    await _page.previousPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        if (_address.text.trim().isEmpty) {
          _address.text =
              'Lat ${pos.latitude.toStringAsFixed(5)}, Lng ${pos.longitude.toStringAsFixed(5)}';
        } else if (!_address.text.contains('Lat ')) {
          _address.text =
              '${_address.text.trim()}\nLat ${pos.latitude.toStringAsFixed(5)}, Lng ${pos.longitude.toStringAsFixed(5)}';
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current location added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickFile(void Function(String name) onPicked, {FileType type = FileType.any}) async {
    final result = await FilePicker.platform.pickFiles(type: type);
    if (result == null || result.files.isEmpty) return;
    setState(() => onPicked(result.files.first.name));
  }

  Map<String, String> _buildPayload() {
    final bio = [
      _hostBio.text.trim(),
      'Frequency: $_frequency',
      'Modes: ${_modes.join(', ')}',
      if (_venueTypes.isNotEmpty) 'Venue: ${_venueTypes.join(', ')}',
      if (_capacity.text.trim().isNotEmpty) 'Capacity: ${_capacity.text.trim()}',
      'Parking available: ${_parkingAvailable ? 'Yes' : 'No'}',
      'Wheelchair accessible: ${_wheelchairAccessible ? 'Yes' : 'No'}',
      if (_facilities.isNotEmpty) 'Facilities: ${_facilities.join(', ')}',
      'Audience: ${_audiences.join(', ')}',
      'Languages: ${_languages.join(', ')}',
      'Pricing: ${_pricing.join(', ')}',
      if (_teamSize.text.trim().isNotEmpty) 'Team size: ${_teamSize.text.trim()}',
      if (_volunteers.text.trim().isNotEmpty) 'Volunteers: ${_volunteers.text.trim()}',
      if (_coordinators.text.trim().isNotEmpty) 'Coordinators: ${_coordinators.text.trim()}',
      if (_speakers.text.trim().isNotEmpty) 'Speakers: ${_speakers.text.trim()}',
      if (_totalEvents.text.trim().isNotEmpty) 'Total events organized: ${_totalEvents.text.trim()}',
      if (_largestEvent.text.trim().isNotEmpty) 'Largest event: ${_largestEvent.text.trim()} participants',
      if (_gst.text.trim().isNotEmpty) 'GST: ${_gst.text.trim()}',
      if (_ngoReg.text.trim().isNotEmpty) 'NGO Reg: ${_ngoReg.text.trim()}',
      if (_societyReg.text.trim().isNotEmpty) 'Society Reg: ${_societyReg.text.trim()}',
      if (_trustReg.text.trim().isNotEmpty) 'Trust Reg: ${_trustReg.text.trim()}',
      if (_companyCin.text.trim().isNotEmpty) 'CIN: ${_companyCin.text.trim()}',
      if (_startupIndiaId.text.trim().isNotEmpty) 'Startup India ID: ${_startupIndiaId.text.trim()}',
      if (_youtube.text.trim().isNotEmpty) 'YouTube: ${_youtube.text.trim()}',
      if (_whatsapp.text.trim().isNotEmpty) 'WhatsApp: ${_whatsapp.text.trim()}',
      if (_telegram.text.trim().isNotEmpty) 'Telegram: ${_telegram.text.trim()}',
      if (_twitter.text.trim().isNotEmpty) 'X: ${_twitter.text.trim()}',
      'Emergency: ${_emergencyPerson.text.trim()} / ${_emergencyPhone.text.trim()}',
      if (_photosName != null) 'Gallery photos: mobile:$_photosName',
      if (_videosName != null) 'Gallery videos: mobile:$_videosName',
      if (_brochureName != null) 'Brochure: mobile:$_brochureName',
      if (_certificatesName != null) 'Certificates: mobile:$_certificatesName',
      if (_mediaCoverageName != null) 'Media coverage: mobile:$_mediaCoverageName',
      'Email verified: $_emailVerified',
      'Phone verified: $_phoneVerified',
      'Organization verified docs: $_orgVerified',
    ].where((e) => e.trim().isNotEmpty).join('\n');

    final address = [
      _address.text.trim(),
      if (_lat != null && _lng != null)
        'Maps: ${_lat!.toStringAsFixed(5)},${_lng!.toStringAsFixed(5)}',
    ].join('\n');

    return {
      'fullName': _fullName.text.trim(),
      'email': _email.text.trim().toLowerCase(),
      'phone': _phone.text.trim(),
      'organizerName': _organizerName.text.trim(),
      'organizerType': _orgType ?? '',
      'hostContact': _phone.text.trim(),
      'hostBio': bio,
      'city': _city.text.trim(),
      'state': _state,
      'officeAddress': address,
      'website': _website.text.trim(),
      'instagram': _instagram.text.trim(),
      'facebook': _facebook.text.trim(),
      'linkedin': _linkedin.text.trim(),
      'eventCategories': _eventCategories.join(', '),
      'yearsExperience': _yearsExperience.text.trim(),
      'expectedParticipants': _expectedParticipants.text.trim().isNotEmpty
          ? _expectedParticipants.text.trim()
          : _largestEvent.text.trim(),
      'password': _password.text,
      'confirmPassword': _confirm.text,
      'logoPath': _logoName == null || _logoName!.isEmpty ? 'mobile-pending' : 'mobile:$_logoName',
      'documentPath': _registrationDoc == null || _registrationDoc!.isEmpty
          ? 'mobile-pending'
          : 'mobile:$_registrationDoc',
      'portfolioPath':
          _portfolioName == null || _portfolioName!.isEmpty ? 'mobile-pending' : 'mobile:$_portfolioName',
    };
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final api = EventHostAuthService(context.read<AuthState>().api);
    final res = await api.register(_buildPayload());
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      await _clearDraft();
      if (!mounted) return;
      await showRegistrationSuccessDialog(
        context,
        message: res['message']?.toString() ??
            'Event organizer registration submitted. Your account is under verification and will activate after admin approval.',
        onDone: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const EventHostPortalLoginScreen()),
          );
        },
      );
    } else {
      final err = res['error']?.toString() ?? res['message']?.toString() ?? 'Registration failed';
      setState(() => _error = err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBg,
      appBar: AppBar(
        backgroundColor: softBg,
        elevation: 0,
        foregroundColor: navy,
        title: const Text('Event Organizer Join', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _busy ? null : () => _saveDraft(),
            child: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
        children: [
          _header(),
          _progress(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          Expanded(
            child: PageView(
              controller: _page,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _stepOrgType(),
                _stepEvents(),
                _stepDetails(),
                _stepVenue(),
                _stepVerify(),
                _stepMedia(),
                _stepAccount(),
              ],
            ),
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _header() {
    final pct = (_completionPct * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Join as Event Organizer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: navy)),
          const SizedBox(height: 4),
          const Text('Complete your organizer profile. Activates after admin verification.',
              style: TextStyle(color: muted, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFBCFE8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Profile Completion',
                          style: TextStyle(fontWeight: FontWeight.w800, color: navy)),
                    ),
                    Text('$pct%', style: const TextStyle(fontWeight: FontWeight.w800, color: primary)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _completionPct,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFFCE7F3),
                    color: primary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final i in _completionItems) _statusChip(i),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(_CheckItem i) {
    final color = i.ok ? const Color(0xFF15803D) : (i.warnIfMissing ? const Color(0xFFB45309) : muted);
    final icon = i.ok
        ? Icons.check_circle
        : (i.warnIfMissing ? Icons.warning_amber_rounded : Icons.radio_button_unchecked);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(99)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(i.label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= _step ? primary : const Color(0xFFFBCFE8),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: i == _step ? primary : muted,
                    ),
                  ),
                ],
              ),
            ),
            if (i < _steps.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _busy ? null : _back,
              style: OutlinedButton.styleFrom(
                foregroundColor: navy,
                side: const BorderSide(color: Color(0xFFF9A8D4)),
                minimumSize: const Size(96, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_step == 0 ? 'Close' : 'Back'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: _busy ? null : _next,
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _busy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_step == _steps.length - 1 ? 'Submit' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepOrgType() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Organization type'),
        const Text('Choose the type that best describes your organization.',
            style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        for (final t in EventOrganizerCatalog.orgTypes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _orgType = t.label),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _orgType == t.label ? const Color(0xFFFFE4E6) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _orgType == t.label ? primary : const Color(0xFFFCE7F3),
                    width: _orgType == t.label ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(t.icon, color: primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(t.label,
                          style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                    ),
                    if (_orgType == t.label) const Icon(Icons.check_circle, color: primary),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _stepEvents() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Event categories'),
        const Text('Select all that apply.', style: TextStyle(color: muted)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in EventOrganizerCatalog.eventCategories)
              FilterChip(
                label: Text(c),
                selected: _eventCategories.contains(c),
                onSelected: (v) => setState(() {
                  if (v) {
                    _eventCategories.add(c);
                  } else {
                    _eventCategories.remove(c);
                  }
                }),
                selectedColor: const Color(0xFFFFE4E6),
                checkmarkColor: primary,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _eventCategories.contains(c) ? primary : navy,
                ),
              ),
          ],
        ),
        const SizedBox(height: 18),
        _sectionTitle('How often do you organize events?'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in EventOrganizerCatalog.frequencies)
              ChoiceChip(
                label: Text(f),
                selected: _frequency == f,
                onSelected: (_) => setState(() => _frequency = f),
                selectedColor: const Color(0xFFFFE4E6),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _frequency == f ? primary : navy,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _sectionTitle('Event modes'),
        Wrap(
          spacing: 8,
          children: [
            for (final m in EventOrganizerCatalog.modes)
              FilterChip(
                label: Text(m),
                selected: _modes.contains(m),
                onSelected: (v) => setState(() {
                  if (v) {
                    _modes.add(m);
                  } else {
                    _modes.remove(m);
                  }
                }),
                selectedColor: const Color(0xFFFFE4E6),
                checkmarkColor: primary,
              ),
          ],
        ),
      ],
    );
  }

  Widget _stepDetails() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Organization details'),
        _field(_fullName, 'Full name *'),
        _field(_organizerName, 'Organization name *'),
        _field(_hostBio, 'Organization description *', maxLines: 4, maxLength: 500),
        _field(_yearsExperience, 'Years of event management experience',
            keyboard: TextInputType.number, digitsOnly: true),
        _field(_website, 'Website (optional)', hint: 'https://'),
        const SizedBox(height: 8),
        _sectionTitle('Organizer team'),
        Row(children: [
          Expanded(child: _field(_teamSize, 'Team size', keyboard: TextInputType.number, digitsOnly: true)),
          const SizedBox(width: 10),
          Expanded(child: _field(_volunteers, 'Volunteers', keyboard: TextInputType.number, digitsOnly: true)),
        ]),
        Row(children: [
          Expanded(child: _field(_coordinators, 'Event coordinators', keyboard: TextInputType.number, digitsOnly: true)),
          const SizedBox(width: 10),
          Expanded(child: _field(_speakers, 'Speakers', keyboard: TextInputType.number, digitsOnly: true)),
        ]),
        _sectionTitle('Previous events'),
        Row(children: [
          Expanded(child: _field(_totalEvents, 'Total events organized', keyboard: TextInputType.number, digitsOnly: true)),
          const SizedBox(width: 10),
          Expanded(child: _field(_largestEvent, 'Largest event (participants)', keyboard: TextInputType.number, digitsOnly: true)),
        ]),
        _field(_expectedParticipants, 'Typical expected participants',
            keyboard: TextInputType.number, digitsOnly: true),
        _sectionTitle('Audience'),
        _multiChips(_audiences, EventOrganizerCatalog.audiences),
        const SizedBox(height: 12),
        _sectionTitle('Languages'),
        _multiChips(_languages, EventOrganizerCatalog.languages),
      ],
    );
  }

  Widget _stepVenue() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Venue information'),
        _multiChips(_venueTypes, EventOrganizerCatalog.venueTypes),
        const SizedBox(height: 12),
        _field(_capacity, 'Capacity', keyboard: TextInputType.number, digitsOnly: true),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Parking available', style: TextStyle(fontWeight: FontWeight.w700)),
          value: _parkingAvailable,
          activeThumbColor: primary,
          onChanged: (v) => setState(() => _parkingAvailable = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Wheelchair accessible', style: TextStyle(fontWeight: FontWeight.w700)),
          value: _wheelchairAccessible,
          activeThumbColor: primary,
          onChanged: (v) => setState(() => _wheelchairAccessible = v),
        ),
        _sectionTitle('Event facilities'),
        _multiChips(_facilities, EventOrganizerCatalog.facilities),
        const SizedBox(height: 16),
        _sectionTitle('Office / venue location'),
        OutlinedButton.icon(
          onPressed: _locating ? null : _useCurrentLocation,
          icon: _locating
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.my_location),
          label: const Text('Use Current Location'),
          style: OutlinedButton.styleFrom(foregroundColor: primary),
        ),
        const SizedBox(height: 8),
        _field(_address, 'Address / Maps location *', maxLines: 3),
        _field(_city, 'City *'),
        DropdownButtonFormField<String>(
          initialValue: _state,
          decoration: _decoration('State *'),
          items: RegOptions.indianStates
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _state = v ?? _state),
        ),
        if (_lat != null && _lng != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '📍 ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
              style: const TextStyle(color: muted, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _stepVerify() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Organization verification'),
        Text(
          _orgType == null
              ? 'Select organization type first.'
              : 'Relevant fields for $_orgType',
          style: const TextStyle(color: muted),
        ),
        const SizedBox(height: 12),
        for (final f in _verifyFields)
          _field(_verifyController(f), EventOrganizerCatalog.verifyLabel(f)),
        if (_verifyFields.isEmpty)
          const Text('No extra registration IDs required for this type.',
              style: TextStyle(color: muted)),
        const SizedBox(height: 12),
        _uploadCard(
          title: _registrationDoc == null ? 'Organizer ID / registration document *' : 'Document uploaded',
          fileName: _registrationDoc,
          onPick: () => _pickFile((n) => _registrationDoc = n),
          onClear: _registrationDoc == null ? null : () => setState(() => _registrationDoc = null),
        ),
      ],
    );
  }

  Widget _stepMedia() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Uploads'),
        _uploadCard(
          title: _logoName == null ? 'Organization logo' : 'Logo uploaded',
          fileName: _logoName,
          onPick: () => _pickFile((n) => _logoName = n, type: FileType.image),
          onClear: _logoName == null ? null : () => setState(() => _logoName = null),
        ),
        const SizedBox(height: 10),
        _uploadCard(
          title: _portfolioName == null ? 'Previous events portfolio' : 'Portfolio uploaded',
          fileName: _portfolioName,
          onPick: () => _pickFile((n) => _portfolioName = n),
          onClear: _portfolioName == null ? null : () => setState(() => _portfolioName = null),
        ),
        const SizedBox(height: 16),
        _sectionTitle('Event gallery'),
        _uploadCard(
          title: _photosName == null ? 'Photos' : 'Photos uploaded',
          fileName: _photosName,
          onPick: () => _pickFile((n) => _photosName = n, type: FileType.image),
          onClear: _photosName == null ? null : () => setState(() => _photosName = null),
        ),
        const SizedBox(height: 8),
        _uploadCard(
          title: _videosName == null ? 'Videos' : 'Videos uploaded',
          fileName: _videosName,
          onPick: () => _pickFile((n) => _videosName = n, type: FileType.video),
          onClear: _videosName == null ? null : () => setState(() => _videosName = null),
        ),
        const SizedBox(height: 8),
        _uploadCard(
          title: _brochureName == null ? 'Brochure' : 'Brochure uploaded',
          fileName: _brochureName,
          onPick: () => _pickFile((n) => _brochureName = n),
          onClear: _brochureName == null ? null : () => setState(() => _brochureName = null),
        ),
        const SizedBox(height: 8),
        _uploadCard(
          title: _certificatesName == null ? 'Certificates' : 'Certificates uploaded',
          fileName: _certificatesName,
          onPick: () => _pickFile((n) => _certificatesName = n),
          onClear: _certificatesName == null ? null : () => setState(() => _certificatesName = null),
        ),
        const SizedBox(height: 8),
        _uploadCard(
          title: _mediaCoverageName == null ? 'Media coverage' : 'Media coverage uploaded',
          fileName: _mediaCoverageName,
          onPick: () => _pickFile((n) => _mediaCoverageName = n),
          onClear: _mediaCoverageName == null ? null : () => setState(() => _mediaCoverageName = null),
        ),
        const SizedBox(height: 16),
        _sectionTitle('Event pricing'),
        _multiChips(_pricing, EventOrganizerCatalog.pricingModels),
        const SizedBox(height: 16),
        _sectionTitle('Social media'),
        _field(_instagram, 'Instagram'),
        _field(_facebook, 'Facebook'),
        _field(_linkedin, 'LinkedIn'),
        _field(_youtube, 'YouTube'),
        _field(_whatsapp, 'WhatsApp', keyboard: TextInputType.phone),
        _field(_telegram, 'Telegram'),
        _field(_twitter, 'X (Twitter)'),
        const SizedBox(height: 8),
        _sectionTitle('Emergency contact'),
        _field(_emergencyPerson, 'Emergency contact person *'),
        _field(_emergencyPhone, 'Emergency phone *',
            keyboard: TextInputType.phone, digitsOnly: true, maxLength: 10),
      ],
    );
  }

  Widget _stepAccount() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _sectionTitle('Create account'),
        _field(_email, 'Email *', keyboard: TextInputType.emailAddress, onChanged: (_) {
          setState(() => _emailVerified = false);
        }),
        _otpRow(
          controller: _emailOtp,
          verified: _emailVerified,
          label: 'Email OTP',
          onVerify: () {
            if (_emailOtp.text.trim() == _demoOtp && RegValidators.isEmail(_email.text)) {
              setState(() => _emailVerified = true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter demo OTP 123456 after a valid email')),
              );
            }
          },
        ),
        _field(_phone, 'Phone *', keyboard: TextInputType.phone, digitsOnly: true, maxLength: 10,
            onChanged: (_) {
          setState(() => _phoneVerified = false);
        }),
        _otpRow(
          controller: _phoneOtp,
          verified: _phoneVerified,
          label: 'Phone OTP',
          onVerify: () {
            if (_phoneOtp.text.trim() == _demoOtp && RegValidators.isPhone10(_phone.text)) {
              setState(() => _phoneVerified = true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter demo OTP 123456 after a valid phone')),
              );
            }
          },
        ),
        const SizedBox(height: 8),
        _sectionTitle('Organizer verification'),
        _verifyStatus('Email Verified', _emailVerified),
        _verifyStatus('Phone Verified', _phoneVerified),
        _verifyStatus('Organization Verified', _orgVerified),
        const SizedBox(height: 12),
        _field(_password, 'Password *', obscure: true, onChanged: (_) => setState(() {})),
        _passCheck('8 Characters', _passLen),
        _passCheck('Uppercase', _passUpper),
        _passCheck('Lowercase', _passLower),
        _passCheck('Number', _passNum),
        _passCheck('Special Character', _passSpecial),
        const SizedBox(height: 8),
        _field(_confirm, 'Confirm password *', obscure: true),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _terms,
          activeColor: primary,
          onChanged: (v) => setState(() => _terms = v ?? false),
          title: const Text('I accept Terms & Conditions',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        OutlinedButton.icon(
          onPressed: () => _saveDraft(),
          icon: const Icon(Icons.bookmark_outline),
          label: const Text('Save Draft · Continue Later'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: primary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  Widget _otpRow({
    required TextEditingController controller,
    required bool verified,
    required String label,
    required VoidCallback onVerify,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !verified,
              decoration: _decoration(verified ? '$label ✓' : '$label (demo: 123456)'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: verified ? null : onVerify,
            style: FilledButton.styleFrom(backgroundColor: primary),
            child: Text(verified ? 'Done' : 'Verify'),
          ),
        ],
      ),
    );
  }

  Widget _verifyStatus(String label, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18, color: ok ? const Color(0xFF15803D) : muted),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: ok ? const Color(0xFF15803D) : muted,
              )),
        ],
      ),
    );
  }

  Widget _passCheck(String label, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16, color: ok ? const Color(0xFF15803D) : muted),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ok ? const Color(0xFF15803D) : muted,
              )),
        ],
      ),
    );
  }

  Widget _multiChips(Set<String> selected, List<String> options) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          FilterChip(
            label: Text(o),
            selected: selected.contains(o),
            onSelected: (v) => setState(() {
              if (v) {
                selected.add(o);
              } else {
                selected.remove(o);
              }
            }),
            selectedColor: const Color(0xFFFFE4E6),
            checkmarkColor: primary,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected.contains(o) ? primary : navy,
            ),
          ),
      ],
    );
  }

  Widget _uploadCard({
    required String title,
    required String? fileName,
    required VoidCallback onPick,
    VoidCallback? onClear,
  }) {
    final uploaded = fileName != null && fileName.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: uploaded ? primary : const Color(0xFFFCE7F3)),
      ),
      child: Row(
        children: [
          Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: navy)),
                if (uploaded) Text(fileName, style: const TextStyle(fontSize: 12, color: muted)),
              ],
            ),
          ),
          TextButton(
            onPressed: onPick,
            child: Text(uploaded ? 'Replace' : 'Upload',
                style: const TextStyle(color: primary, fontWeight: FontWeight.w700)),
          ),
          if (onClear != null)
            IconButton(onPressed: onClear, icon: const Icon(Icons.delete_outline, color: muted)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)),
      );

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFCE7F3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType? keyboard,
    bool obscure = false,
    bool digitsOnly = false,
    int maxLines = 1,
    int? maxLength,
    String? hint,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        maxLength: maxLength,
        keyboardType: keyboard,
        onChanged: onChanged ?? (_) => setState(() {}),
        inputFormatters: [if (digitsOnly) FilteringTextInputFormatter.digitsOnly],
        decoration: _decoration(label, hint: hint),
      ),
    );
  }
}

class _CheckItem {
  const _CheckItem(this.label, this.ok, {this.warnIfMissing = false});
  final String label;
  final bool ok;
  final bool warnIfMissing;
}
