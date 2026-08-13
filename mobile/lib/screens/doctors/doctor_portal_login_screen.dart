import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import 'doctor_dashboard_screen.dart';
import 'doctor_profile_completion_screen.dart';

class DoctorPortalLoginScreen extends StatefulWidget {
  const DoctorPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  State<DoctorPortalLoginScreen> createState() => _DoctorPortalLoginScreenState();
}

class _DoctorPortalLoginScreenState extends State<DoctorPortalLoginScreen> {
  static const _resendCooldownSeconds = 60;

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
  bool _emailVerified = false;
  bool _verifyingOtp = false;
  int _resendSecondsRemaining = 0;
  Timer? _resendTimer;
  String? _error;

  DoctorAuthService get _svc => DoctorAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _register = widget.startRegister;
    _email.addListener(_onEmailChanged);
    _emailOtp.addListener(_onOtpChanged);
  }

  void _onEmailChanged() {
    if (_emailOtpSent || _emailVerified) {
      setState(() {
        _emailOtpSent = false;
        _emailVerified = false;
        _emailOtp.clear();
      });
      _stopResendTimer();
    }
  }

  void _onOtpChanged() {
    if (_emailVerified) {
      setState(() => _emailVerified = false);
    }
    final otp = _emailOtp.text.trim();
    if (otp.length == 6 && !_verifyingOtp && !_loading && _emailOtpSent) {
      _verifyOtp(auto: true);
    }
  }

  @override
  void dispose() {
    _stopResendTimer();
    _email.removeListener(_onEmailChanged);
    _emailOtp.removeListener(_onOtpChanged);
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _emailOtp.dispose();
    super.dispose();
  }

  void _stopResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = null;
    _resendSecondsRemaining = 0;
  }

  void _startResendTimer() {
    _stopResendTimer();
    setState(() => _resendSecondsRemaining = _resendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() => _resendSecondsRemaining = 0);
      } else {
        setState(() => _resendSecondsRemaining -= 1);
      }
    });
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
      _emailVerified = false;
      _emailOtp.clear();
    });
    final res = await _svc.sendEmailOtp(_email.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['success'] == true) {
      setState(() => _emailOtpSent = true);
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Failed to send OTP');
    }
  }

  Future<void> _verifyOtp({bool auto = false}) async {
    if (_emailVerified || _verifyingOtp) return;

    final emailErr = _validateEmail(_email.text);
    if (emailErr != null) {
      setState(() => _error = emailErr);
      return;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(_emailOtp.text.trim())) {
      if (!auto) setState(() => _error = 'Please enter the 6-digit email OTP');
      return;
    }

    setState(() {
      _verifyingOtp = true;
      _error = null;
    });
    final res = await _svc.verifyEmailOtp(email: _email.text, otp: _emailOtp.text);
    if (!mounted) return;
    setState(() => _verifyingOtp = false);
    if (res['success'] == true) {
      setState(() => _emailVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified successfully')),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Invalid or expired OTP');
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
      if (!_emailVerified) {
        setState(() => _error = 'Please verify your email OTP before creating an account');
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
          _emailVerified = false;
          _terms = false;
        });
        _stopResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message']?.toString() ??
                  'Account created successfully. Login and complete your profile.',
            ),
          ),
        );
      } else {
        final needsCompletion = res['needsProfileCompletion'] == true;
        if (needsCompletion) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DoctorProfileCompletionScreen(
                onFinished: (ctx) {
                  Navigator.of(ctx).pushReplacement(
                    MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
                  );
                },
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
          );
        }
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
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    bool enabled = true,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          counterText: maxLength != null ? '' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFFF1F5F9),
        ),
      ),
    );
  }

  Widget _buildEmailVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _input(
          controller: _email,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          enabled: !_emailVerified,
        ),
        if (_emailVerified)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 8),
                Text(
                  'Email Verified',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        else ...[
          FilledButton(
            onPressed: (_loading || (_emailOtpSent && _resendSecondsRemaining > 0)) ? null : _sendOtp,
            child: Text(_emailOtpSent ? 'Resend OTP' : 'Send OTP'),
          ),
          if (_emailOtpSent && _resendSecondsRemaining > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                'Resend available in ${_resendSecondsRemaining}s',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ),
          const SizedBox(height: 4),
          _input(
            controller: _emailOtp,
            label: '6-digit OTP',
            hintText: 'Enter code from email',
            keyboardType: TextInputType.number,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          FilledButton.tonal(
            onPressed: (_loading || _verifyingOtp || _emailOtp.text.trim().length != 6) ? null : () => _verifyOtp(),
            child: _verifyingOtp
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verify OTP'),
          ),
          if (_emailOtpSent && !_emailVerified)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'OTP is verified automatically after you enter all 6 digits.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canCreateAccount = _register && _emailVerified && _terms && !_loading;

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
                      _buildEmailVerificationSection(),
                    ] else
                      _input(controller: _email, label: 'Email', keyboardType: TextInputType.emailAddress),
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
                      onPressed: (_register ? canCreateAccount : !_loading) ? _submit : null,
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
                                _emailOtpSent = false;
                                _emailVerified = false;
                                _emailOtp.clear();
                                _stopResendTimer();
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
