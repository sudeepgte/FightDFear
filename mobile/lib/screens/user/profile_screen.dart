import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/dynamic_location_hierarchy_picker.dart';
import '../../widgets/module_theme.dart';
import '../safety/contacts_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileService _api;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _uploadingPhoto = false;
  String? _error;

  String? _userId;
  String? _email;
  String? _status;
  String? _gender;
  String? _profilePhoto;
  String? _selectedState;
  String? _selectedDistrict;
  int _rewardPoints = 0;
  double _walletBalance = 0.0;
  int _completionPercentage = 0;
  List<String> _missingItems = [];

  String? _nameError;
  String? _phoneError;
  String? _addressError;
  String? _cityError;
  String? _whatsappError;

  @override
  void initState() {
    super.initState();
    _api = ProfileService(context.read<AuthState>().api);
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _dobCtrl.dispose();
    _ageCtrl.dispose();
    _whatsappCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.getProfile();
      if (!mounted) return;
      if (res['success'] == true) {
        _nameCtrl.text = res['fullName']?.toString() ?? res['name']?.toString() ?? '';
        _phoneCtrl.text = res['phoneNumber']?.toString() ?? res['phone']?.toString() ?? '';
        _addressCtrl.text = res['homeAddress']?.toString() ?? '';
        _cityCtrl.text = res['city']?.toString() ?? '';
        _dobCtrl.text = res['dob']?.toString() ?? '';
        _ageCtrl.text = res['age'] != null ? res['age'].toString() : '';
        _whatsappCtrl.text = res['whatsappNumber']?.toString() ?? '';

        _userId = res['id']?.toString();
        _email = res['email']?.toString();
        _status = res['status']?.toString();
        _gender = res['gender']?.toString();
        _profilePhoto = res['profilePhoto']?.toString();

        _rewardPoints = (res['rewardPoints'] as num?)?.toInt() ?? 0;
        _walletBalance = (res['walletBalance'] as num?)?.toDouble() ?? 0.0;
        _completionPercentage = (res['completionPercentage'] as num?)?.toInt() ??
            (res['profileCompletionPct'] as num?)?.toInt() ??
            0;

        if (res['missingItems'] is List) {
          _missingItems = (res['missingItems'] as List).map((e) => e.toString()).toList();
        } else {
          _missingItems = [];
        }
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      setState(() => _uploadingPhoto = true);
      final res = await _api.uploadPhoto(picked.path);
      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated successfully')),
        );
        setState(() {
          _profilePhoto = res['profilePhoto']?.toString() ?? _profilePhoto;
          if (res['completionPercentage'] != null) {
            _completionPercentage = (res['completionPercentage'] as num).toInt();
          }
          if (res['missingItems'] is List) {
            _missingItems = (res['missingItems'] as List).map((e) => e.toString()).toList();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Photo upload failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload photo: $e')),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _selectDateOfBirth() async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 20));
    if (_dobCtrl.text.isNotEmpty) {
      try {
        initial = DateTime.parse(_dobCtrl.text.trim());
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formatted =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _dobCtrl.text = formatted;

      final now = DateTime.now();
      int age = now.year - picked.year;
      if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
        age--;
      }
      if (age >= 0) {
        _ageCtrl.text = '$age';
      }
      setState(() {});
    }
  }

  Future<void> _save() async {
    setState(() {
      _nameError = null;
      _phoneError = null;
      _addressError = null;
      _cityError = null;
      _whatsappError = null;
    });

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final city = _cityCtrl.text.trim();
    final dob = _dobCtrl.text.trim();
    final ageStr = _ageCtrl.text.trim();
    final wa = _whatsappCtrl.text.trim();

    if (name.isEmpty) {
      _nameError = 'Full name is required';
    } else if (name.length < 2) {
      _nameError = 'Name must be at least 2 characters';
    }

    if (phone.isEmpty) {
      _phoneError = 'Phone number is required';
    } else if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _phoneError = 'Phone must be exactly 10 digits';
    }

    if (address.isEmpty) {
      _addressError = 'Home address is required';
    }

    if (city.isEmpty) {
      _cityError = 'City is required';
    }

    if (wa.isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(wa)) {
      _whatsappError = 'WhatsApp must be exactly 10 digits';
    }

    if (_nameError != null ||
        _phoneError != null ||
        _addressError != null ||
        _cityError != null ||
        _whatsappError != null) {
      setState(() {});
      return;
    }

    int? parsedAge;
    if (ageStr.isNotEmpty) {
      parsedAge = int.tryParse(ageStr);
    }

    setState(() => _saving = true);
    try {
      final res = await _api.updateProfile(
        fullName: name,
        phoneNumber: phone,
        homeAddress: address,
        city: city,
        dob: dob.isNotEmpty ? dob : null,
        age: parsedAge,
        gender: _gender,
        whatsappNumber: wa.isNotEmpty ? wa : null,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _nameCtrl.text = res['fullName']?.toString() ?? res['name']?.toString() ?? _nameCtrl.text;
          _phoneCtrl.text = res['phoneNumber']?.toString() ?? res['phone']?.toString() ?? _phoneCtrl.text;
          _addressCtrl.text = res['homeAddress']?.toString() ?? _addressCtrl.text;
          _cityCtrl.text = res['city']?.toString() ?? _cityCtrl.text;
          _dobCtrl.text = res['dob']?.toString() ?? _dobCtrl.text;
          _ageCtrl.text = res['age'] != null ? res['age'].toString() : _ageCtrl.text;
          _whatsappCtrl.text = res['whatsappNumber']?.toString() ?? _whatsappCtrl.text;
          _completionPercentage = (res['completionPercentage'] as num?)?.toInt() ?? _completionPercentage;
          if (res['missingItems'] is List) {
            _missingItems = (res['missingItems'] as List).map((e) => e.toString()).toList();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Update failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _getPhotoUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final baseUrl = context.read<AuthState>().api.baseUrl;
    if (path.startsWith('/')) return '$baseUrl$path';
    return '$baseUrl/$path';
  }

  Widget _headerCard() {
    final photoUrl = _getPhotoUrl(_profilePhoto);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: const Color(0xFFFFF1F2),
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null
                        ? Text(
                            _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF43F5E),
                            ),
                          )
                        : null,
                  ),
                  InkWell(
                    onTap: _uploadingPhoto ? null : _pickAndUploadPhoto,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _uploadingPhoto
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'Fight D Fear Member',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE4E6)),
                  ),
                  child: const Text(
                    'Member Profile',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF43F5E),
                    ),
                  ),
                ),
                if (_userId != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    'ID: #$_userId',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.monetization_on, color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '$_rewardPoints',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Coins Earned',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 28, width: 1, color: const Color(0xFFE2E8F0)),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.account_balance_wallet, color: Color(0xFF10B981), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '₹${_walletBalance.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Wallet Balance',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressCard() {
    return Card(
      elevation: 0,
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
                  'Profile Completion',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  '$_completionPercentage%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF43F5E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _completionPercentage / 100.0,
                minHeight: 8,
                backgroundColor: const Color(0xFFFFE4E6),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF43F5E)),
              ),
            ),
            if (_missingItems.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFE4E6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Color(0xFFE11D48)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Missing: ${_missingItems.join(", ")}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE11D48),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _headerCard(),
                      const SizedBox(height: 12),
                      _progressCard(),
                      const SizedBox(height: 16),
                      // Personal Information Section
                      Card(
                        elevation: 0,
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
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                key: const ValueKey('member_profile_name_input'),
                                controller: _nameCtrl,
                                onChanged: (_) {
                                  if (_nameError != null) setState(() => _nameError = null);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Full name *',
                                  helperText: 'Official full name as per Government ID',
                                  helperMaxLines: 1,
                                  errorText: _nameError,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: TextEditingController(text: _email ?? ''),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Email address',
                                  helperText: 'Account email cannot be modified directly',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                  filled: true,
                                  fillColor: Color(0xFFF1F5F9),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const ValueKey('member_profile_phone_input'),
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (_) {
                                  if (_phoneError != null) setState(() => _phoneError = null);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Mobile number *',
                                  helperText: '10-digit primary mobile number',
                                  counterText: '',
                                  errorText: _phoneError,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.phone_outlined),
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: (_gender != null &&
                                        ['FEMALE', 'MALE', 'OTHER']
                                            .contains(_gender!.toUpperCase()))
                                    ? _gender!.toUpperCase()
                                    : null,
                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.wc_outlined),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                                  DropdownMenuItem(value: 'MALE', child: Text('Male')),
                                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                                ],
                                onChanged: (val) {
                                  setState(() => _gender = val);
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: InkWell(
                                      onTap: _selectDateOfBirth,
                                      child: IgnorePointer(
                                        child: TextField(
                                          controller: _dobCtrl,
                                          decoration: const InputDecoration(
                                            labelText: 'Date of Birth',
                                            hintText: 'YYYY-MM-DD',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.calendar_today_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: _ageCtrl,
                                      keyboardType: TextInputType.number,
                                      maxLength: 3,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      decoration: const InputDecoration(
                                        labelText: 'Age',
                                        counterText: '',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.cake_outlined),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const ValueKey('member_profile_whatsapp_input'),
                                controller: _whatsappCtrl,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (_) {
                                  if (_whatsappError != null) setState(() => _whatsappError = null);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Emergency WhatsApp Number',
                                  helperText: 'For urgent SOS alerts & journey sharing',
                                  counterText: '',
                                  errorText: _whatsappError,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location & Address Section
                      Card(
                        elevation: 0,
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
                              const Text(
                                'Location & Residential Address',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 14),
                              DynamicLocationHierarchyPicker(
                                api: context.read<AuthState>().api,
                                initialCountry: 'India',
                                initialState: _selectedState,
                                initialCity: _cityCtrl.text.isNotEmpty ? _cityCtrl.text : null,
                                isRequired: false,
                                onLocationChanged: ({
                                  required country,
                                  required state,
                                  required district,
                                  required city,
                                }) {
                                  setState(() {
                                    _selectedState = state;
                                    _selectedDistrict = district;
                                    if (city.isNotEmpty) _cityCtrl.text = city;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const ValueKey('member_profile_city_input'),
                                controller: _cityCtrl,
                                onChanged: (_) {
                                  if (_cityError != null) setState(() => _cityError = null);
                                },
                                decoration: InputDecoration(
                                  labelText: 'City / Town *',
                                  errorText: _cityError,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.location_city_outlined),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                key: const ValueKey('member_profile_address_input'),
                                controller: _addressCtrl,
                                maxLines: 2,
                                onChanged: (_) {
                                  if (_addressError != null) setState(() => _addressError = null);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Home Address *',
                                  helperText: 'Your residence address for emergency response',
                                  helperMaxLines: 1,
                                  errorText: _addressError,
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.home_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Trusted Emergency Contacts Quick Link
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.emergency_outlined, color: Color(0xFFF43F5E)),
                          ),
                          title: const Text(
                            'Trusted Emergency Contacts',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: const Text(
                            'Manage contacts who receive emergency SOS alerts',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ContactsScreen()),
                            ).then((_) => _load());
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const ValueKey('member_profile_save_btn'),
                        onPressed: _saving ? null : _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFF43F5E),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Profile Changes',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}
