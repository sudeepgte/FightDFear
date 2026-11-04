import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/maps_config.dart';
import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/event_host_auth_service.dart';
import '../../widgets/profile_location_picker.dart';

/// Full event creation & editing screen matching web `/women-events/organizer/create`.
class EventCreateEditScreen extends StatefulWidget {
  const EventCreateEditScreen({
    super.key,
    this.existing,
    this.hostInfo,
  });

  final Map<String, dynamic>? existing;
  final Map<String, dynamic>? hostInfo;

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color border = Color(0xFFE2E8F0);
  static const Color softBg = Color(0xFFF8FAFC);

  @override
  State<EventCreateEditScreen> createState() => _EventCreateEditScreenState();
}

class _EventCreateEditScreenState extends State<EventCreateEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _shortDescCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _customCityCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _mapsLocationCtrl = TextEditingController();
  final _feeCtrl = TextEditingController(text: '0');
  final _boothFeeCtrl = TextEditingController(text: '0');
  final _seatsCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _organizerNameCtrl = TextEditingController();
  final _streamLinkCtrl = TextEditingController();
  final _meetingPlatformCtrl = TextEditingController();
  final _cancelPolicyCtrl = TextEditingController(text: WomenEventCatalog.cancelPolicy);
  final _refundPolicyCtrl = TextEditingController();
  final _ageRestrictionCtrl = TextEditingController();
  final _whatToBringCtrl = TextEditingController();
  final _participantReqCtrl = TextEditingController();

  // Selection state
  late String _categoryCode;
  String _organizerType = 'NGO';
  String _eventFormat = 'OFFLINE'; // OFFLINE, ONLINE, HYBRID
  bool _isVirtual = false;
  bool _isFree = true;
  String? _selectedState;
  String? _selectedDistrict;

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  DateTime? _regCloseDate;
  TimeOfDay? _regCloseTime;

  double? _pinnedLat;
  double? _pinnedLng;

  String? _bannerLocalPath;
  String? _bannerRemoteUrl;

  bool _submitting = false;
  String? _submitError;

  EventHostAuthService get _svc =>
      EventHostAuthService(context.read<AuthState>().api);

  bool get _isEdit => widget.existing != null;

  static const Map<String, List<String>> indiaStatesData = {
    'Andhra Pradesh': ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Nellore', 'Kurnool', 'Tirupati', 'Kakinada', 'Rajahmundry', 'Kadapa', 'Anantapur', 'Other'],
    'Arunachal Pradesh': ['Itanagar', 'Naharlagun', 'Pasighat', 'Tawang', 'Ziro', 'Other'],
    'Assam': ['Guwahati (Kamrup Metro)', 'Silchar', 'Dibrugarh', 'Jorhat', 'Nagaon', 'Tinsukia', 'Tezpur', 'Other'],
    'Bihar': ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Purnia', 'Darbhanga', 'Bihar Sharif', 'Arrah', 'Other'],
    'Chhattisgarh': ['Raipur', 'Bhilai', 'Bilaspur', 'Korba', 'Rajnandgaon', 'Jagdalpur', 'Other'],
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda', 'North Goa', 'South Goa', 'Other'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar', 'Jamnagar', 'Gandhinagar', 'Junagadh', 'Anand', 'Other'],
    'Haryana': ['Gurugram', 'Faridabad', 'Panipat', 'Ambala', 'Yamunanagar', 'Rohtak', 'Hisar', 'Karnal', 'Sonipat', 'Panchkula', 'Other'],
    'Himachal Pradesh': ['Shimla', 'Dharamshala', 'Mandi', 'Solan', 'Kullu', 'Hamirpur', 'Other'],
    'Jharkhand': ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro', 'Deoghar', 'Hazaribagh', 'Other'],
    'Karnataka': ['Bengaluru', 'Mysuru', 'Hubballi-Dharwad', 'Mangaluru', 'Belagavi', 'Kalaburagi', 'Davanagere', 'Shivamogga', 'Udupi', 'Other'],
    'Kerala': ['Thiruvananthapuram', 'Kochi (Ernakulam)', 'Kozhikode', 'Thrissur', 'Kollam', 'Palakkad', 'Kannur', 'Kottayam', 'Alappuzha', 'Other'],
    'Madhya Pradesh': ['Bhopal', 'Indore', 'Jabalpur', 'Gwalior', 'Ujjain', 'Sagar', 'Dewas', 'Satna', 'Other'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Nashik', 'Chhatrapati Sambhajinagar (Aurangabad)', 'Solapur', 'Kolhapur', 'Navi Mumbai', 'Other'],
    'Manipur': ['Imphal West', 'Imphal East', 'Thoubal', 'Churachandpur', 'Other'],
    'Meghalaya': ['Shillong', 'Tura', 'Jowai', 'Other'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Champhai', 'Other'],
    'Nagaland': ['Kohima', 'Dimapur', 'Mokokchung', 'Other'],
    'Odisha': ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur', 'Puri', 'Balasore', 'Other'],
    'Punjab': ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda', 'SAS Nagar (Mohali)', 'Other'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Kota', 'Bikaner', 'Ajmer', 'Udaipur', 'Bhilwara', 'Alwar', 'Other'],
    'Sikkim': ['Gangtok', 'Namchi', 'Gyalshing', 'Other'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem', 'Tirunelveli', 'Tiruppur', 'Vellore', 'Erode', 'Other'],
    'Telangana': ['Hyderabad', 'Warangal', 'Nizamabad', 'Khammam', 'Karimnagar', 'Secunderabad', 'Other'],
    'Tripura': ['Agartala', 'Dharmanagar', 'Udaipur', 'Other'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Prayagraj', 'Noida / Greater Noida', 'Ghaziabad', 'Meerut', 'Bareilly', 'Aligarh', 'Other'],
    'Uttarakhand': ['Dehradun', 'Haridwar', 'Roorkee', 'Haldwani', 'Rishikesh', 'Nainital', 'Other'],
    'West Bengal': ['Kolkata', 'Howrah', 'Durgapur', 'Asansol', 'Siliguri', 'Darjeeling', 'Other'],
    'Delhi': ['New Delhi', 'Central Delhi', 'South Delhi', 'North Delhi', 'East Delhi', 'West Delhi', 'Other'],
    'Chandigarh': ['Chandigarh', 'Other'],
    'Jammu and Kashmir': ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla', 'Other'],
    'Ladakh': ['Leh', 'Kargil', 'Other'],
    'Puducherry': ['Puducherry', 'Karaikal', 'Other'],
  };

  static const List<String> organizerTypeList = [
    'NGO',
    'Company',
    'College / University',
    'Government',
    'Community',
    'Gym / Fitness Centre',
    'Hospital / Clinic',
    'Fitness Trainer',
    'Women Entrepreneur',
    'Startup',
    'Charity Foundation',
    'Sports Club',
    'Youth Organization',
  ];

  @override
  void initState() {
    super.initState();
    _categoryCode = WomenEventCatalog.categories.first.code;
    _initFromExistingOrHost();
  }

  void _initFromExistingOrHost() {
    final e = widget.existing;
    final h = widget.hostInfo ?? {};

    if (e != null) {
      _nameCtrl.text = e['name']?.toString() ?? '';
      _descCtrl.text = e['description']?.toString() ?? '';
      _shortDescCtrl.text = e['shortDescription']?.toString() ?? '';
      _venueCtrl.text = e['venue']?.toString() ?? '';
      _cityCtrl.text = e['city']?.toString() ?? '';
      _pincodeCtrl.text = e['venuePincode']?.toString() ?? '';
      _areaCtrl.text = e['venueArea']?.toString() ?? '';
      _mapsLocationCtrl.text = e['mapsLocation']?.toString() ?? '';

      final feeVal = (e['entryFee'] is num) ? (e['entryFee'] as num).toDouble() : double.tryParse('${e['entryFee']}') ?? 0.0;
      _feeCtrl.text = feeVal > 0 ? feeVal.toStringAsFixed(0) : '0';
      _isFree = e['free'] == true || feeVal <= 0;

      final boothVal = (e['boothFee'] is num) ? (e['boothFee'] as num).toDouble() : double.tryParse('${e['boothFee']}') ?? 0.0;
      _boothFeeCtrl.text = boothVal > 0 ? boothVal.toStringAsFixed(0) : '0';

      _seatsCtrl.text = e['maxParticipants']?.toString() ?? e['capacity']?.toString() ?? '';
      _contactCtrl.text = e['contactInfo']?.toString() ?? '';
      _organizerNameCtrl.text = e['organizerName']?.toString() ?? '';
      _organizerType = e['organizerType']?.toString() ?? 'NGO';
      _streamLinkCtrl.text = e['streamLink']?.toString() ?? '';
      _meetingPlatformCtrl.text = e['meetingPlatform']?.toString() ?? '';
      _cancelPolicyCtrl.text = e['cancellationPolicy']?.toString() ?? WomenEventCatalog.cancelPolicy;
      _refundPolicyCtrl.text = e['refundPolicy']?.toString() ?? '';
      _ageRestrictionCtrl.text = e['ageRestriction']?.toString() ?? '';
      _whatToBringCtrl.text = e['whatToBring']?.toString() ?? '';
      _participantReqCtrl.text = e['participantRequirements']?.toString() ?? '';

      _categoryCode = WomenEventCatalog.codeFor(e['category']?.toString()) ?? WomenEventCatalog.categories.first.code;
      _eventFormat = (e['eventFormat']?.toString() ?? (e['virtual'] == true ? 'ONLINE' : 'OFFLINE')).toUpperCase();
      _isVirtual = _eventFormat == 'ONLINE' || _eventFormat == 'HYBRID' || e['virtual'] == true;

      _resolveStateAndCity(e['venueState']?.toString(), e['city']?.toString());

      _bannerRemoteUrl = e['bannerImage']?.toString() ?? e['imagePath']?.toString() ?? e['bannerUrl']?.toString();

      final rawDate = e['eventDate']?.toString();
      if (rawDate != null && rawDate.isNotEmpty) {
        _startDate = DateTime.tryParse(rawDate);
      }
      final rawTime = e['eventTime']?.toString();
      if (rawTime != null && rawTime.isNotEmpty) {
        final parts = rawTime.split(':');
        if (parts.length >= 2) {
          _startTime = TimeOfDay(hour: int.tryParse(parts[0]) ?? 10, minute: int.tryParse(parts[1]) ?? 0);
        }
      }

      final rawEnd = e['endsAt']?.toString();
      if (rawEnd != null && rawEnd.isNotEmpty) {
        final dt = DateTime.tryParse(rawEnd);
        if (dt != null) {
          _endDate = dt;
          _endTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
        }
      }

      final rawClose = e['registrationClosesAt']?.toString();
      if (rawClose != null && rawClose.isNotEmpty) {
        final dt = DateTime.tryParse(rawClose);
        if (dt != null) {
          _regCloseDate = dt;
          _regCloseTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
        }
      }
    } else {
      // Pre-fill from host profile
      _organizerNameCtrl.text = h['organizerName']?.toString() ?? h['fullName']?.toString() ?? '';
      _organizerType = h['organizerType']?.toString() ?? 'NGO';
      _contactCtrl.text = h['hostContact']?.toString() ?? h['phone']?.toString() ?? '';
      _venueCtrl.text = h['officeAddress']?.toString() ?? '';
      _resolveStateAndCity(h['state']?.toString() ?? h['venueState']?.toString(), h['city']?.toString());
      _cityCtrl.text = h['city']?.toString() ?? '';
      _pincodeCtrl.text = h['pincode']?.toString() ?? '';
      _areaCtrl.text = h['area']?.toString() ?? '';
      _startDate = DateTime.now().add(const Duration(days: 7));
      _startTime = const TimeOfDay(hour: 10, minute: 0);
    }
  }

  void _resolveStateAndCity(String? rawState, String? rawCity) {
    String? state = rawState?.trim();
    String? city = rawCity?.trim();

    // Normalize City Aliases (e.g. Banglore/Bangalore -> Bengaluru)
    String normalizedCity = city ?? '';
    final lowerCity = normalizedCity.toLowerCase();
    if (lowerCity == 'banglore' || lowerCity == 'bangalore') {
      normalizedCity = 'Bengaluru';
      state ??= 'Karnataka';
    } else if (lowerCity == 'bombay') {
      normalizedCity = 'Mumbai';
      state ??= 'Maharashtra';
    } else if (lowerCity == 'madras') {
      normalizedCity = 'Chennai';
      state ??= 'Tamil Nadu';
    } else if (lowerCity == 'calcutta') {
      normalizedCity = 'Kolkata';
      state ??= 'West Bengal';
    } else if (lowerCity == 'gurgaon') {
      normalizedCity = 'Gurugram';
      state ??= 'Haryana';
    } else if (lowerCity == 'mysore') {
      normalizedCity = 'Mysuru';
      state ??= 'Karnataka';
    } else if (lowerCity == 'mangalore') {
      normalizedCity = 'Mangaluru';
      state ??= 'Karnataka';
    } else if (lowerCity == 'hubli') {
      normalizedCity = 'Hubballi-Dharwad';
      state ??= 'Karnataka';
    }

    // 1. Resolve State
    if (state != null && state.isNotEmpty) {
      final stateMatch = indiaStatesData.keys.firstWhere(
        (k) => k.toLowerCase() == state!.toLowerCase(),
        orElse: () => '',
      );
      _selectedState = stateMatch.isNotEmpty ? stateMatch : null;
    } else {
      _selectedState = null;
    }

    // If state unknown but city is provided, discover state by city
    if (_selectedState == null && normalizedCity.isNotEmpty) {
      for (final entry in indiaStatesData.entries) {
        if (entry.value.any((c) => c.toLowerCase() == normalizedCity.toLowerCase() && c != 'Other')) {
          _selectedState = entry.key;
          break;
        }
      }
    }

    // 2. Resolve District
    if (_selectedState != null && normalizedCity.isNotEmpty) {
      final list = indiaStatesData[_selectedState!] ?? [];
      final districtMatch = list.firstWhere(
        (d) => d.toLowerCase() == normalizedCity.toLowerCase(),
        orElse: () => '',
      );
      if (districtMatch.isNotEmpty) {
        _selectedDistrict = districtMatch;
      } else {
        _selectedDistrict = 'Other';
        _customCityCtrl.text = city ?? '';
      }
    } else {
      _selectedDistrict = null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _shortDescCtrl.dispose();
    _venueCtrl.dispose();
    _cityCtrl.dispose();
    _customCityCtrl.dispose();
    _pincodeCtrl.dispose();
    _areaCtrl.dispose();
    _mapsLocationCtrl.dispose();
    _feeCtrl.dispose();
    _boothFeeCtrl.dispose();
    _seatsCtrl.dispose();
    _contactCtrl.dispose();
    _organizerNameCtrl.dispose();
    _streamLinkCtrl.dispose();
    _meetingPlatformCtrl.dispose();
    _cancelPolicyCtrl.dispose();
    _refundPolicyCtrl.dispose();
    _ageRestrictionCtrl.dispose();
    _whatToBringCtrl.dispose();
    _participantReqCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickBanner() async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (img != null) {
        setState(() => _bannerLocalPath = img.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      setState(() {
        _pinnedLat = pos.latitude;
        _pinnedLng = pos.longitude;
        _mapsLocationCtrl.text = 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location pinned: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not fetch location: $e')),
      );
    }
  }

  Future<void> _openMapPin() async {
    final picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => ProfileMapPinScreen(
          initialLat: _pinnedLat ?? MapsConfig.defaultLat,
          initialLng: _pinnedLng ?? MapsConfig.defaultLng,
          title: 'Pin Event Venue Location',
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        _pinnedLat = picked.latitude;
        _pinnedLng = picked.longitude;
        _mapsLocationCtrl.text = 'https://maps.google.com/?q=${picked.latitude},${picked.longitude}';
      });
    }
  }

  Future<void> _handleSave({required bool saveDraft}) async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _submitError = 'Please correct the highlighted fields above');
      return;
    }

    if (_startDate == null) {
      setState(() => _submitError = 'Event start date is required');
      return;
    }

    final isOfflineOrHybrid = _eventFormat == 'OFFLINE' || _eventFormat == 'HYBRID';
    if (isOfflineOrHybrid) {
      if (_venueCtrl.text.trim().isEmpty) {
        setState(() => _submitError = 'Street address / venue name is required for offline events');
        return;
      }
      final effectiveCity = _selectedDistrict == 'Other'
          ? _customCityCtrl.text.trim()
          : (_selectedDistrict ?? _cityCtrl.text.trim());
      if (effectiveCity.isEmpty) {
        setState(() => _submitError = 'City / District is required for offline events');
        return;
      }
    }

    setState(() {
      _submitting = true;
      _submitError = null;
    });

    final effectiveCity = _selectedDistrict == 'Other'
        ? _customCityCtrl.text.trim()
        : (_selectedDistrict ?? _cityCtrl.text.trim());

    final feeVal = _isFree ? 0.0 : (double.tryParse(_feeCtrl.text.trim()) ?? 0.0);
    final boothVal = double.tryParse(_boothFeeCtrl.text.trim()) ?? 0.0;
    final seatsVal = int.tryParse(_seatsCtrl.text.trim());

    final body = <String, dynamic>{
      'name': _nameCtrl.text.trim(),
      'category': _categoryCode,
      'description': _descCtrl.text.trim(),
      'shortDescription': _shortDescCtrl.text.trim(),
      'organizerType': _organizerType,
      'organizerName': _organizerNameCtrl.text.trim(),
      'eventDate': _fmtDate(_startDate!),
      'eventTime': _fmtTime(_startTime ?? const TimeOfDay(hour: 10, minute: 0)),
      'eventFormat': _eventFormat,
      'virtual': _isVirtual,
      'venue': _venueCtrl.text.trim().isEmpty ? 'Online' : _venueCtrl.text.trim(),
      'city': effectiveCity.isEmpty ? 'Online' : effectiveCity,
      'venueState': _selectedState ?? '',
      'venuePincode': _pincodeCtrl.text.trim(),
      'venueArea': _areaCtrl.text.trim(),
      'mapsLocation': _mapsLocationCtrl.text.trim(),
      'entryFee': feeVal,
      'boothFee': boothVal,
      'maxParticipants': ?seatsVal,
      'contactInfo': _contactCtrl.text.trim(),
      'streamLink': _streamLinkCtrl.text.trim(),
      'meetingPlatform': _meetingPlatformCtrl.text.trim(),
      'cancellationPolicy': _cancelPolicyCtrl.text.trim(),
      'refundPolicy': _refundPolicyCtrl.text.trim(),
      'ageRestriction': _ageRestrictionCtrl.text.trim(),
      'whatToBring': _whatToBringCtrl.text.trim(),
      'participantRequirements': _participantReqCtrl.text.trim(),
      'saveDraft': saveDraft,
      'draft': saveDraft,
    };

    if (_endDate != null) {
      body['endDate'] = _fmtDate(_endDate!);
      if (_endTime != null) body['endTime'] = _fmtTime(_endTime!);
    }
    if (_regCloseDate != null) {
      final t = _regCloseTime ?? const TimeOfDay(hour: 23, minute: 59);
      body['registrationCloses'] = '${_fmtDate(_regCloseDate!)}T${_fmtTime(t)}';
    }

    try {
      Map<String, dynamic> res;
      int? targetEventId;

      if (_isEdit) {
        final id = widget.existing!['id'];
        targetEventId = (id is num) ? id.toInt() : int.tryParse('$id');
        if (targetEventId == null) throw 'Invalid event ID';
        res = await _svc.updateEvent(targetEventId, body);
      } else {
        res = await _svc.createEvent(body);
        final created = res['event'];
        if (created is Map && created['id'] != null) {
          targetEventId = (created['id'] is num)
              ? (created['id'] as num).toInt()
              : int.tryParse('${created['id']}');
        }
      }

      if (res['success'] != true) {
        throw res['error']?.toString() ?? (_isEdit ? 'Update failed' : 'Creation failed');
      }

      // If user selected a local banner image, upload it now
      if (_bannerLocalPath != null && targetEventId != null) {
        try {
          await _svc.uploadEventBanner(targetEventId, _bannerLocalPath!);
        } catch (uploadErr) {
          debugPrint('Banner upload warning: $uploadErr');
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saveDraft
                ? 'Draft saved successfully'
                : (_isEdit ? 'Event updated successfully' : 'Event submitted for admin approval!'),
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _submitError = '$e';
      });
    }
  }

  void _showPreviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollCtrl) {
            final effectiveCity = _selectedDistrict == 'Other'
                ? _customCityCtrl.text.trim()
                : (_selectedDistrict ?? _cityCtrl.text.trim());
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Public Preview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: EventCreateEditScreen.navy,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // Banner preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _bannerLocalPath != null
                                ? Image.file(File(_bannerLocalPath!), fit: BoxFit.cover)
                                : (_bannerRemoteUrl != null && _bannerRemoteUrl!.isNotEmpty)
                                    ? Image.network(_bannerRemoteUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderBanner())
                                    : _placeholderBanner(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Badges
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: EventCreateEditScreen.softPink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                WomenEventCatalog.labelFor(_categoryCode),
                                style: const TextStyle(
                                  color: EventCreateEditScreen.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _eventFormat,
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _isFree ? 'FREE' : '₹${_feeCtrl.text.trim()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: EventCreateEditScreen.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _nameCtrl.text.trim().isEmpty ? 'Event Title' : _nameCtrl.text.trim(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: EventCreateEditScreen.navy,
                          ),
                        ),
                        if (_shortDescCtrl.text.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            _shortDescCtrl.text.trim(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Organizer info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EventCreateEditScreen.softBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: EventCreateEditScreen.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: EventCreateEditScreen.primary,
                                radius: 18,
                                child: Text(
                                  _organizerNameCtrl.text.trim().isNotEmpty
                                      ? _organizerNameCtrl.text.trim()[0].toUpperCase()
                                      : 'O',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _organizerNameCtrl.text.trim().isEmpty
                                          ? 'Organizer Name'
                                          : _organizerNameCtrl.text.trim(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: EventCreateEditScreen.navy,
                                      ),
                                    ),
                                    Text(
                                      _organizerType,
                                      style: const TextStyle(fontSize: 12, color: EventCreateEditScreen.muted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Date & Time, Venue
                        _previewInfoRow(
                          Icons.calendar_month_outlined,
                          _startDate != null
                              ? '${_fmtDate(_startDate!)} at ${_fmtTime(_startTime ?? const TimeOfDay(hour: 10, minute: 0))}'
                              : 'Select date & time',
                        ),
                        const SizedBox(height: 8),
                        _previewInfoRow(
                          Icons.location_on_outlined,
                          _eventFormat == 'ONLINE'
                              ? 'Online Event (${_meetingPlatformCtrl.text.trim().isEmpty ? "Platform link upon registration" : _meetingPlatformCtrl.text.trim()})'
                              : '${_venueCtrl.text.trim()}, $effectiveCity, ${_selectedState ?? ""}',
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: EventCreateEditScreen.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _descCtrl.text.trim().isEmpty ? 'No description entered yet.' : _descCtrl.text.trim(),
                          style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                  // Footer buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: EventCreateEditScreen.border)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Back to Edit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: EventCreateEditScreen.primary),
                            onPressed: () {
                              Navigator.pop(ctx);
                              _handleSave(saveDraft: false);
                            },
                            child: const Text('Submit for Approval'),
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
      },
    );
  }

  Widget _previewInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: EventCreateEditScreen.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: EventCreateEditScreen.navy),
          ),
        ),
      ],
    );
  }

  Widget _placeholderBanner() {
    return Container(
      color: EventCreateEditScreen.softPink,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 48, color: EventCreateEditScreen.primary),
            SizedBox(height: 6),
            Text(
              'No Banner Selected',
              style: TextStyle(color: EventCreateEditScreen.primary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventCreateEditScreen.softBg,
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Event' : 'Create New Event',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        foregroundColor: EventCreateEditScreen.navy,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _showPreviewSheet,
            icon: const Icon(Icons.visibility_outlined, size: 18),
            label: const Text('Preview'),
            style: TextButton.styleFrom(foregroundColor: EventCreateEditScreen.primary),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (!_isEdit) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting ? null : () => _handleSave(saveDraft: true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: EventCreateEditScreen.border),
                    ),
                    child: const Text('Save Draft', style: TextStyle(color: EventCreateEditScreen.navy, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _submitting ? null : () => _handleSave(saveDraft: false),
                  style: FilledButton.styleFrom(
                    backgroundColor: EventCreateEditScreen.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          _isEdit ? 'Save Changes' : 'Submit for Approval',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            if (_submitError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  border: Border.all(color: const Color(0xFFFECACA)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _submitError!,
                        style: const TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // SECTION 1: BASIC INFORMATION
            _sectionCard(
              title: 'Basic Information',
              icon: Icons.info_outline,
              children: [
                _buildTextField(
                  controller: _nameCtrl,
                  label: 'Event Name *',
                  hint: "e.g., Women's Day Yoga & Wellness Camp",
                  validator: (v) {
                    if (v == null || v.trim().length < 3) return 'Please enter an event name (at least 3 characters)';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _categoryCode,
                        isExpanded: true,
                        decoration: _inputDeco('Category *'),
                        items: WomenEventCatalog.categories
                            .map((c) => DropdownMenuItem(value: c.code, child: Text(c.label, overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _categoryCode = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: organizerTypeList.contains(_organizerType) ? _organizerType : organizerTypeList.first,
                        isExpanded: true,
                        decoration: _inputDeco('Organizer Type *'),
                        items: organizerTypeList
                            .map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _organizerType = v);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _organizerNameCtrl,
                  label: 'Organizer / Organization Name *',
                  hint: 'e.g., She Leads Foundation',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Organizer name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _shortDescCtrl,
                  label: 'Short Tagline / Summary',
                  hint: 'Brief one-line highlight for event cards',
                  maxLength: 140,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  controller: _descCtrl,
                  label: 'Event Description *',
                  hint: "Describe your event — what will happen, who should attend, and what they'll gain...",
                  maxLines: 4,
                  validator: (v) {
                    if (v == null || v.trim().length < 20) return 'Detailed description must be at least 20 characters';
                    return null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SECTION 2: DATE, TIME & FORMAT
            _sectionCard(
              title: 'Date, Time & Format',
              icon: Icons.calendar_today_outlined,
              children: [
                // Format Selector (Offline / Online / Hybrid)
                const Text(
                  'Event Format',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: EventCreateEditScreen.muted),
                ),
                const SizedBox(height: 6),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'OFFLINE', label: Text('Offline'), icon: Icon(Icons.apartment)),
                    ButtonSegment(value: 'ONLINE', label: Text('Online'), icon: Icon(Icons.videocam_outlined)),
                    ButtonSegment(value: 'HYBRID', label: Text('Hybrid'), icon: Icon(Icons.devices_outlined)),
                  ],
                  selected: {_eventFormat},
                  onSelectionChanged: (val) {
                    setState(() {
                      _eventFormat = val.first;
                      _isVirtual = _eventFormat == 'ONLINE' || _eventFormat == 'HYBRID';
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Start Date & Time
                Row(
                  children: [
                    Expanded(
                      child: _datePickerTile(
                        label: 'Event Date *',
                        date: _startDate,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now().add(const Duration(days: 7)),
                            firstDate: DateTime.now().subtract(const Duration(days: 1)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          if (d != null) setState(() => _startDate = d);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _timePickerTile(
                        label: 'Start Time',
                        time: _startTime,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: _startTime ?? const TimeOfDay(hour: 10, minute: 0),
                          );
                          if (t != null) setState(() => _startTime = t);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // End Date & Time (Optional)
                Row(
                  children: [
                    Expanded(
                      child: _datePickerTile(
                        label: 'End Date (Optional)',
                        date: _endDate,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? _startDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                          );
                          if (d != null) setState(() => _endDate = d);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _timePickerTile(
                        label: 'End Time',
                        time: _endTime,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: _endTime ?? const TimeOfDay(hour: 12, minute: 0),
                          );
                          if (t != null) setState(() => _endTime = t);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Registration Closes
                Row(
                  children: [
                    Expanded(
                      child: _datePickerTile(
                        label: 'Registration Closes Date',
                        date: _regCloseDate,
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _regCloseDate ?? _startDate ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 1)),
                            lastDate: _startDate ?? DateTime.now().add(const Duration(days: 365)),
                          );
                          if (d != null) setState(() => _regCloseDate = d);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _timePickerTile(
                        label: 'Closes Time',
                        time: _regCloseTime,
                        onTap: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: _regCloseTime ?? const TimeOfDay(hour: 18, minute: 0),
                          );
                          if (t != null) setState(() => _regCloseTime = t);
                        },
                      ),
                    ),
                  ],
                ),

                // Virtual details if Online or Hybrid
                if (_isVirtual) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: EventCreateEditScreen.softPink,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Online Meeting & Streaming Access',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: EventCreateEditScreen.navy),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Link will only be visible to registered and paid attendees.',
                          style: TextStyle(fontSize: 11, color: EventCreateEditScreen.muted),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _streamLinkCtrl,
                          label: 'Meeting / Live Stream Link',
                          hint: 'https://zoom.us/j/... or Google Meet URL',
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _meetingPlatformCtrl,
                          label: 'Meeting Platform Name',
                          hint: 'Zoom, Google Meet, YouTube Live, Teams',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),

            // SECTION 3: LOCATION (FOR OFFLINE / HYBRID)
            if (_eventFormat == 'OFFLINE' || _eventFormat == 'HYBRID') ...[
              _sectionCard(
                title: 'Venue & Location',
                icon: Icons.place_outlined,
                children: [
                  // Interactive Map Actions
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: EventCreateEditScreen.softPink,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFECDD3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Interactive Map Pinning',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: EventCreateEditScreen.navy),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pin on map or use GPS to generate Google Maps link automatically.',
                          style: TextStyle(fontSize: 11, color: EventCreateEditScreen.muted),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(backgroundColor: EventCreateEditScreen.primary),
                                onPressed: _openMapPin,
                                icon: const Icon(Icons.pin_drop_outlined, size: 18),
                                label: const Text('Pin on Map', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _useCurrentLocation,
                                icon: const Icon(Icons.my_location, size: 18),
                                label: const Text('Current GPS', style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    controller: _venueCtrl,
                    label: 'Street Address / Venue Name *',
                    hint: 'Building, hall name, street or landmark',
                    validator: (v) {
                      if (_eventFormat != 'ONLINE' && (v == null || v.trim().length < 3)) {
                        return 'Please enter street address / venue name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // State and City Dropdowns
                  Builder(
                    builder: (context) {
                      final bool stateValid = _selectedState != null && indiaStatesData.containsKey(_selectedState);
                      final String? safeState = stateValid ? _selectedState : null;
                      final List<String> cityList = stateValid
                          ? List<String>.from(indiaStatesData[_selectedState]!)
                          : <String>[];

                      if (cityList.isNotEmpty && !cityList.contains('Other')) {
                        cityList.add('Other');
                      }

                      String? safeDistrict;
                      if (_selectedDistrict != null && cityList.contains(_selectedDistrict)) {
                        safeDistrict = _selectedDistrict;
                      } else if (_selectedDistrict != null && _selectedDistrict!.trim().isNotEmpty) {
                        final match = cityList.firstWhere(
                          (c) => c.toLowerCase() == _selectedDistrict!.trim().toLowerCase(),
                          orElse: () => '',
                        );
                        if (match.isNotEmpty) {
                          safeDistrict = match;
                        } else if (cityList.isNotEmpty) {
                          safeDistrict = 'Other';
                          if (_customCityCtrl.text.trim().isEmpty && _selectedDistrict != 'Other') {
                            _customCityCtrl.text = _selectedDistrict!;
                          }
                        }
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: safeState,
                              isExpanded: true,
                              decoration: _inputDeco('State / UT *'),
                              hint: const Text('Select State', overflow: TextOverflow.ellipsis),
                              items: indiaStatesData.keys
                                  .map((st) => DropdownMenuItem(value: st, child: Text(st, overflow: TextOverflow.ellipsis)))
                                  .toList(),
                              onChanged: (st) {
                                setState(() {
                                  _selectedState = st;
                                  _selectedDistrict = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: safeDistrict,
                              isExpanded: true,
                              decoration: _inputDeco('City / District *'),
                              hint: Text(safeState == null ? 'Select State First' : 'Select City', overflow: TextOverflow.ellipsis),
                              items: cityList
                                  .map((ct) => DropdownMenuItem(value: ct, child: Text(ct, overflow: TextOverflow.ellipsis)))
                                  .toList(),
                              onChanged: (ct) {
                                setState(() => _selectedDistrict = ct);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  if (_selectedDistrict == 'Other') ...[
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _customCityCtrl,
                      label: 'Custom City / Town Name *',
                      hint: 'Enter your city or district name',
                    ),
                  ],
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _pincodeCtrl,
                          label: 'Postal PIN Code',
                          hint: '6-digit PIN',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _areaCtrl,
                          label: 'Area / Neighborhood',
                          hint: 'e.g., Bandra West, Indiranagar',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildTextField(
                    controller: _mapsLocationCtrl,
                    label: 'Google Maps Link / Coordinates',
                    hint: 'Auto-filled via Pin / GPS or paste Maps URL',
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],

            // SECTION 4: PRICING, BOOTH & CAPACITY
            _sectionCard(
              title: 'Fee, Booth & Capacity',
              icon: Icons.payments_outlined,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() {
                          _isFree = true;
                          _feeCtrl.text = '0';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _isFree ? EventCreateEditScreen.softPink : Colors.white,
                            border: Border.all(
                              color: _isFree ? EventCreateEditScreen.primary : EventCreateEditScreen.border,
                              width: _isFree ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Free Event',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _isFree ? EventCreateEditScreen.primary : EventCreateEditScreen.navy,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _isFree = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: !_isFree ? EventCreateEditScreen.softPink : Colors.white,
                            border: Border.all(
                              color: !_isFree ? EventCreateEditScreen.primary : EventCreateEditScreen.border,
                              width: !_isFree ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Paid Event',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: !_isFree ? EventCreateEditScreen.primary : EventCreateEditScreen.navy,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!_isFree) ...[
                  const SizedBox(height: 14),
                  _buildTextField(
                    controller: _feeCtrl,
                    label: 'Entry Fee (₹) *',
                    hint: 'Ticket price per participant',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (!_isFree) {
                        final val = double.tryParse(v ?? '');
                        if (val == null || val <= 0) return 'Please enter an entry fee greater than 0';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _boothFeeCtrl,
                        label: 'Stall / Booth Fee (₹)',
                        hint: '0 if not applicable',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _seatsCtrl,
                        label: 'Max Capacity',
                        hint: 'Unlimited if blank',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SECTION 5: POLICIES & REQUIREMENTS
            _sectionCard(
              title: 'Policies & Requirements',
              icon: Icons.shield_outlined,
              children: [
                _buildTextField(
                  controller: _cancelPolicyCtrl,
                  label: 'Cancellation Policy',
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _refundPolicyCtrl,
                  label: 'Refund Policy',
                  hint: 'e.g. 100% refund up to 24 hours before start',
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _ageRestrictionCtrl,
                        label: 'Age Restriction',
                        hint: 'e.g., 18+, 16+, All ages',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _whatToBringCtrl,
                        label: 'What to Bring',
                        hint: 'ID proof, water bottle, yoga mat',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _participantReqCtrl,
                  label: 'Participant Requirements',
                  hint: 'Any prior preparation, dress code or equipment',
                  maxLines: 2,
                ),
              ],
            ),
            const SizedBox(height: 18),

            // SECTION 6: CONTACT & BANNER IMAGE
            _sectionCard(
              title: 'Contact Info & Banner',
              icon: Icons.image_outlined,
              children: [
                _buildTextField(
                  controller: _contactCtrl,
                  label: 'Contact Info (Phone / Email) *',
                  hint: '10-digit phone number or email address',
                  validator: (v) {
                    if (v == null || v.trim().length < 6) return 'Please provide valid contact phone or email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Banner Upload Card
                const Text(
                  'Event Banner Image',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: EventCreateEditScreen.navy),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Recommended: 1200×600 px · JPG or PNG',
                  style: TextStyle(fontSize: 11, color: EventCreateEditScreen.muted),
                ),
                const SizedBox(height: 10),

                InkWell(
                  onTap: _pickBanner,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: EventCreateEditScreen.softPink,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFECDD3), style: BorderStyle.solid),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _bannerLocalPath != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(File(_bannerLocalPath!), fit: BoxFit.cover),
                                Container(
                                  color: Colors.black.withOpacity(0.35),
                                  child: const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.edit, color: Colors.white, size: 20),
                                        SizedBox(width: 8),
                                        Text('Change Banner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : (_bannerRemoteUrl != null && _bannerRemoteUrl!.isNotEmpty)
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(_bannerRemoteUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholderBanner()),
                                    Container(
                                      color: Colors.black.withOpacity(0.35),
                                      child: const Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.edit, color: Colors.white, size: 20),
                                            SizedBox(width: 8),
                                            Text('Change Banner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, size: 40, color: EventCreateEditScreen.primary),
                                    SizedBox(height: 8),
                                    Text('Tap to select banner from gallery', style: TextStyle(fontWeight: FontWeight.w700, color: EventCreateEditScreen.navy)),
                                    SizedBox(height: 4),
                                    Text('JPG, PNG up to 5MB', style: TextStyle(fontSize: 11, color: EventCreateEditScreen.muted)),
                                  ],
                                ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EventCreateEditScreen.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                  color: EventCreateEditScreen.softPink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: EventCreateEditScreen.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: EventCreateEditScreen.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDeco(label, hint: hint),
    );
  }

  InputDecoration _inputDeco(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(fontSize: 13, color: EventCreateEditScreen.muted),
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: EventCreateEditScreen.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: EventCreateEditScreen.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: EventCreateEditScreen.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  Widget _datePickerTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDeco(label).copyWith(
          suffixIcon: const Icon(Icons.calendar_month, size: 18, color: EventCreateEditScreen.primary),
        ),
        child: Text(
          date == null ? 'Select date' : _fmtDate(date),
          style: TextStyle(
            fontSize: 13,
            color: date == null ? EventCreateEditScreen.muted : EventCreateEditScreen.navy,
            fontWeight: date == null ? FontWeight.normal : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _timePickerTile({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDeco(label).copyWith(
          suffixIcon: const Icon(Icons.access_time, size: 18, color: EventCreateEditScreen.primary),
        ),
        child: Text(
          time == null ? 'Select time' : _fmtTime(time),
          style: TextStyle(
            fontSize: 13,
            color: time == null ? EventCreateEditScreen.muted : EventCreateEditScreen.navy,
            fontWeight: time == null ? FontWeight.normal : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
