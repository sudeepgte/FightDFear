import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import 'doctor_dashboard_screen.dart';

class DoctorPortalLoginScreen extends StatefulWidget {
  const DoctorPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  State<DoctorPortalLoginScreen> createState() => _DoctorPortalLoginScreenState();
}

class _DoctorPortalLoginScreenState extends State<DoctorPortalLoginScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _emailOtp = TextEditingController();

  bool _register = false;
  bool _loading = false;
  bool _terms = false;
  bool _emailOtpSent = false;
  String? _error;

  DoctorAuthService get _svc => DoctorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _register = widget.startRegister;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _emailOtp.dispose();
    super.dispose();
  }

  String? _validateEmail(String email) {
    final v = email.trim();
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String phone) {
    final v = phone.trim();
    if (v.isEmpty) return 'Mobile number is required';
    if (!RegExp(r'^\d{10}$').hasMatch(v)) return 'Phone must be 10 digits';
    return null;
  }

  String? _validatePassword(String pass) {
    if (pass.isEmpty) return 'Password is required';
    if (pass.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[0-9]').hasMatch(pass) || !RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\]').hasMatch(pass)) {
      return 'Password must include a number and special character';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    final emailErr = _validateEmail(_email.text);
    if (emailErr != null) {
      setState(() => _error = emailErr);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _svc.sendEmailOtp(_email.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['success'] == true) {
      setState(() => _emailOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Failed to send OTP');
    }
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (_register) {
      if ((_name.text.trim()).isEmpty) {
        setState(() => _error = 'Full name is required');
        return;
      }
      final emailErr = _validateEmail(_email.text);
      if (emailErr != null) {
        setState(() => _error = emailErr);
        return;
      }
      final phoneErr = _validatePhone(_phone.text);
      if (phoneErr != null) {
        setState(() => _error = phoneErr);
        return;
      }
      final passErr = _validatePassword(_password.text);
      if (passErr != null) {
        setState(() => _error = passErr);
        return;
      }
      if (_password.text != _confirmPassword.text) {
        setState(() => _error = 'Password and confirm password do not match');
        return;
      }
      if (!_terms) {
        setState(() => _error = 'Please accept Terms & Privacy Policy');
        return;
      }
      if (!_emailOtpSent) {
        setState(() => _error = 'Please send email OTP first');
        return;
      }
      if (!RegExp(r'^\d{6}$').hasMatch(_emailOtp.text.trim())) {
        setState(() => _error = 'Please enter the 6-digit email OTP');
        return;
      }
    } else {
      final emailErr = _validateEmail(_email.text);
      if (emailErr != null) {
        setState(() => _error = emailErr);
        return;
      }
      if (_password.text.trim().isEmpty) {
        setState(() => _error = 'Password is required');
        return;
      }
    }

    setState(() => _loading = true);
    final res = _register
        ? await _svc.registerQuick({
            'fullName': _name.text.trim(),
            'phone': _phone.text.trim(),
            'email': _email.text.trim().toLowerCase(),
            'password': _password.text,
            'confirmPassword': _confirmPassword.text,
            'emailOtp': _emailOtp.text.trim(),
            'acceptedTerms': true,
          })
        : await _svc.login(
            email: _email.text.trim(),
            password: _password.text,
          );
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['success'] == true) {
      if (_register) {
        setState(() {
          _register = false;
          _name.clear();
          _phone.clear();
          _password.clear();
          _confirmPassword.clear();
          _emailOtp.clear();
          _emailOtpSent = false;
          _terms = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message']?.toString() ??
                  'Account created successfully. Login and complete your profile.',
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
        );
      }
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Request failed');
    }
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(_register ? 'Join as Doctor' : 'Doctor Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _register ? 'Quick Registration' : 'Welcome Doctor',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _register
                          ? 'Create your account in under a minute. Complete your professional profile after login.'
                          : 'Sign in to your doctor dashboard.',
                    ),
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    if (_register) ...[
                      _input(controller: _name, label: 'Full name'),
                      _input(controller: _phone, label: 'Mobile number', keyboardType: TextInputType.phone),
                    ],
                    _input(controller: _email, label: 'Email', keyboardType: TextInputType.emailAddress),
                    if (_register) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _input(controller: _emailOtp, label: 'Email OTP', keyboardType: TextInputType.number),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _loading ? null : _sendOtp,
                            child: Text(_emailOtpSent ? 'Resend OTP' : 'Send OTP'),
                          ),
                        ],
                      ),
                    ],
                    _input(controller: _password, label: 'Password', obscure: true),
                    if (_register) ...[
                      _input(controller: _confirmPassword, label: 'Confirm password', obscure: true),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('I accept Terms & Privacy Policy'),
                        value: _terms,
                        onChanged: (v) => setState(() => _terms = v ?? false),
                      ),
                    ],
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_register ? 'Create Account' : 'Login'),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() {
                                _register = !_register;
                                _error = null;
                              }),
                      child: Text(_register ? 'Already have an account? Login' : 'New doctor? Join now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
