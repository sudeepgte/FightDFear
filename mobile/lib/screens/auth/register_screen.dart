import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/registration_form_kit.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _address = TextEditingController();
  final _emergency = TextEditingController();
  final _dob = TextEditingController();

  String? _gender;
  String _language = 'English';
  String? _photoName;
  bool _terms = false;
  bool _emailOtpOk = false;
  bool _phoneOtpOk = false;
  bool _locating = false;
  bool _submitting = false;

  static const _languages = ['English', 'Hindi', 'Marathi', 'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Gujarati', 'Other'];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _address.dispose();
    _emergency.dispose();
    _dob.dispose();
    super.dispose();
  }

  bool get _passwordOk =>
      RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$')
          .hasMatch(_password.text);

  bool get _canSubmit {
    return !_submitting &&
        _name.text.trim().isNotEmpty &&
        RegValidators.isEmail(_email.text) &&
        RegValidators.isPhone10(_phone.text) &&
        RegValidators.isPhone10(_emergency.text) &&
        _emergency.text.trim() != _phone.text.trim() &&
        _dob.text.trim().isNotEmpty &&
        _passwordOk &&
        _password.text == _confirm.text &&
        _address.text.trim().isNotEmpty &&
        _terms &&
        _emailOtpOk &&
        _phoneOtpOk;
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      _dob.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _useGps() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required for GPS.')),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() {
        final maps = 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
        if (_address.text.trim().isEmpty) {
          _address.text = maps;
        } else if (!_address.text.contains('maps.google.com')) {
          _address.text = '${_address.text.trim()}\n$maps';
        } else {
          _address.text = maps;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not fetch location: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete required fields, OTP verification, and accept Terms.')),
      );
      return;
    }

    setState(() => _submitting = true);
    final auth = context.read<AuthState>();
    final reachable = await auth.pingServer();
    if (!mounted) return;
    if (!reachable) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot reach API at ${auth.apiBaseUrl}/api/auth/health. '
            'Use same Wi-Fi as laptop and turn off mobile data.',
          ),
        ),
      );
      return;
    }

    final result = await auth.register(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      phoneNumber: _phone.text.trim(),
      password: _password.text,
      homeAddress: _address.text.trim(),
      gender: _gender,
      dob: _dob.text.trim(),
      emergencyContact: _emergency.text.trim(),
      preferredLanguage: _language,
      profilePhoto: _photoName == null ? null : 'mobile:$_photoName',
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Registration failed')),
      );
      return;
    }

    await showRegistrationSuccessDialog(
      context,
      message: result['message']?.toString() ??
          'Registration successful. Your account is under admin verification. You will be able to log in once your account is approved.',
      onDone: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Register for Fight D Fear',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'New accounts need admin verification before login works.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                'API: ${context.read<AuthState>().apiBaseUrl}',
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              const SizedBox(height: 20),
              FileUploadTile(
                label: 'Profile photo',
                fileName: _photoName,
                optional: true,
                onPick: () async {
                  final name = await pickImageName();
                  if (name != null) setState(() => _photoName = name);
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Full name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {
                  _emailOtpOk = false;
                }),
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegValidators.isEmail(v)) return 'Enter a valid email';
                  return null;
                },
              ),
              OtpVerifyRow(
                label: 'Email',
                verified: _emailOtpOk,
                onVerified: () => setState(() => _emailOtpOk = true),
                onSend: () async {
                  final email = _email.text.trim();
                  if (!RegValidators.isEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter a valid email first')),
                    );
                    return false;
                  }
                  final res = await context.read<AuthState>().api.post(
                    '/api/auth/otp/send-email',
                    auth: false,
                    body: {'email': email.toLowerCase()},
                    timeout: const Duration(seconds: 30),
                  );
                  if (res['success'] == true) return true;
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['error']?.toString() ?? 'Failed to send OTP')),
                    );
                  }
                  return false;
                },
                onVerify: (otp) async {
                  final res = await context.read<AuthState>().api.post(
                    '/api/auth/otp/verify-email',
                    auth: false,
                    body: {
                      'email': _email.text.trim().toLowerCase(),
                      'otp': otp,
                    },
                  );
                  if (res['success'] == true) return null;
                  return res['error']?.toString() ?? 'Invalid or expired OTP';
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => setState(() {
                  _phoneOtpOk = false;
                }),
                decoration: const InputDecoration(
                  labelText: 'Phone (10 digits) *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || !RegValidators.isPhone10(v)) {
                    return 'Enter a 10-digit phone number';
                  }
                  return null;
                },
              ),
              OtpVerifyRow(
                label: 'Phone',
                verified: _phoneOtpOk,
                onVerified: () => setState(() => _phoneOtpOk = true),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emergency,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Emergency contact number *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || !RegValidators.isPhone10(v)) {
                    return 'Enter a 10-digit emergency contact number';
                  }
                  if (v.trim() == _phone.text.trim()) {
                    return 'Emergency contact should differ from your phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dob,
                readOnly: true,
                onTap: _pickDob,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Date of birth *',
                  hintText: 'YYYY-MM-DD',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDob,
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Date of birth is required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender (optional)',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                  DropdownMenuItem(value: 'MALE', child: Text('Male')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _gender = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _language,
                decoration: const InputDecoration(
                  labelText: 'Preferred language *',
                  border: OutlineInputBorder(),
                ),
                items: _languages
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _language = v ?? _language),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _address,
                maxLines: 2,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Current location / address *',
                  hintText: 'Address or Google Maps link',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: 'Use GPS',
                    onPressed: _locating ? null : _useGps,
                    icon: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Location / address is required' : null,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _locating ? null : _useGps,
                  icon: const Icon(Icons.gps_fixed, size: 18),
                  label: Text(_locating ? 'Fetching GPS…' : 'Use current GPS location'),
                ),
              ),
              const SizedBox(height: 8),
              ObscurePasswordField(
                controller: _password,
                label: 'Password *',
                showStrength: true,
                onChanged: (_) => setState(() {}),
              ),
              if (_password.text.isNotEmpty &&
                  !RegExp(r'^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$')
                      .hasMatch(_password.text))
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Min 6 chars with a number and special character (!@#\$%^&*)',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ObscurePasswordField(
                controller: _confirm,
                label: 'Confirm password *',
                onChanged: (_) => setState(() {}),
              ),
              if (_confirm.text.isNotEmpty && _confirm.text != _password.text)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Passwords do not match',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _terms,
                onChanged: (v) => setState(() => _terms = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I agree to the Terms & Conditions and Privacy Policy',
                  style: TextStyle(fontSize: 13),
                ),
              ),
              if (!_terms)
                const Padding(
                  padding: EdgeInsets.only(left: 12, bottom: 8),
                  child: Text('Required to register', style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _canSubmit ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Register'),
              ),
              const SizedBox(height: 8),
              Text(
                _canSubmit
                    ? 'Ready to submit'
                    : 'Complete required fields, verify the email OTP sent to your inbox, and accept Terms to enable Register.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
