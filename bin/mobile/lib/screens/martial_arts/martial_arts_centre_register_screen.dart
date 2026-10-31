import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'martial_arts_centre_login_screen.dart';

/// Quick Self-Defense Trainer / Centre registration — few fields + email OTP.
/// Full details are collected later on the profile completion screen.
class MartialArtsCentreRegisterScreen extends StatefulWidget {
  const MartialArtsCentreRegisterScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentreRegisterScreen> createState() =>
      _MartialArtsCentreRegisterScreenState();
}

class _MartialArtsCentreRegisterScreenState extends State<MartialArtsCentreRegisterScreen> {
  static const _resendCooldownSeconds = 60;

  late final CentreAuthService _auth;
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _emailOtp = TextEditingController();

  bool _loading = false;
  bool _terms = false;
  bool _emailOtpSent = false;
  bool _emailVerified = false;
  bool _verifyingOtp = false;
  int _resendSecondsRemaining = 0;
  Timer? _resendTimer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _auth = CentreAuthService(context.read<AuthState>().api);
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
    if (_emailVerified) setState(() => _emailVerified = false);
    final otp = _emailOtp.text.trim();
    if (otp.length == 6 && !_verifyingOtp && !_loading && _emailOtpSent) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    _stopResendTimer();
    _email.removeListener(_onEmailChanged);
    _emailOtp.removeListener(_onOtpChanged);
    for (final c in [_name, _contact, _phone, _email, _password, _confirm, _emailOtp]) {
      c.dispose();
    }
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
    final res = await _auth.sendEmailOtp(_email.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['success'] == true) {
      setState(() => _emailOtpSent = true);
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Unable to send OTP');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _verifyingOtp = true;
      _error = null;
    });
    final res = await _auth.verifyEmailOtp(email: _email.text, otp: _emailOtp.text);
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
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Centre / trainer name is required');
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
    if (_password.text != _confirm.text) {
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

    setState(() => _loading = true);
    final res = await _auth.registerQuick({
      'name': _name.text.trim(),
      'contactPerson': _contact.text.trim().isEmpty ? _name.text.trim() : _contact.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim().toLowerCase(),
      'password': _password.text,
      'confirmPassword': _confirm.text,
      'emailOtp': _emailOtp.text.trim(),
      'acceptedTerms': true,
    });
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['message']?.toString() ??
                'Account created. Login and complete your profile.',
          ),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
      );
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreRegisterScreen.navy,
        title: const Text('Join as Self-Defense Trainer', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick registration', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 6),
                const Text(
                  'For Karate, Taekwondo & self-defence centres. After login, add your martial arts programs and batches.',
                  style: TextStyle(color: MartialArtsCentreRegisterScreen.navy, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  'For Gym, Zumba or wellness coaching, register as Fitness Trainer instead.',
                  style: TextStyle(color: MartialArtsCentreRegisterScreen.navy.withValues(alpha: 0.75), fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Centre / Trainer name *',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contact,
            decoration: const InputDecoration(
              labelText: 'Contact person (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            decoration: const InputDecoration(
              labelText: 'Mobile number *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: (_loading || _resendSecondsRemaining > 0) ? null : _sendOtp,
                  style: FilledButton.styleFrom(backgroundColor: MartialArtsCentreRegisterScreen.primary),
                  child: Text(_emailOtpSent
                      ? (_resendSecondsRemaining > 0 ? 'Resend in ${_resendSecondsRemaining}s' : 'Resend OTP')
                      : 'Send email OTP'),
                ),
              ),
              if (_emailVerified) ...[
                const SizedBox(width: 10),
                const Icon(Icons.verified, color: Color(0xFF16A34A)),
              ],
            ],
          ),
          if (_emailOtpSent) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _emailOtp,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
              decoration: InputDecoration(
                labelText: 'Email OTP *',
                border: const OutlineInputBorder(),
                suffixIcon: _verifyingOtp
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : null,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ObscurePasswordField(
            controller: _password,
            label: 'Password *',
            showStrength: true,
            filled: true,
            prefixIcon: Icons.lock_outline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          ObscurePasswordField(
            controller: _confirm,
            label: 'Confirm password *',
            filled: true,
            prefixIcon: Icons.lock_outline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _terms,
            onChanged: (v) => setState(() => _terms = v ?? false),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('I accept the Terms & Privacy Policy'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _loading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: MartialArtsCentreRegisterScreen.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Create account'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
            ),
            child: const Text('Already registered? Sign in'),
          ),
        ],
      ),
    );
  }
}
