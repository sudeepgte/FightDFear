import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/glow_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'glow_provider_login_screen.dart';

/// Quick Glow Space salon registration — username + phone + email OTP.
/// Full details are collected later on the profile completion screen.
class GlowProviderSignupScreen extends StatefulWidget {
  const GlowProviderSignupScreen({super.key, this.initialTab = 0});

  /// Kept for call-site compatibility; dual tabs removed.
  final int initialTab;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<GlowProviderSignupScreen> createState() => _GlowProviderSignupScreenState();
}

class _GlowProviderSignupScreenState extends State<GlowProviderSignupScreen> {
  static const _resendCooldownSeconds = 60;

  late final GlowProviderAuthService _api;
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  final _emailOtp = TextEditingController();

  bool _terms = false;
  bool _busy = false;
  bool _emailOtpSent = false;
  bool _emailVerified = false;
  bool _verifyingOtp = false;
  int _resendSecondsRemaining = 0;
  Timer? _resendTimer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = GlowProviderAuthService(context.read<AuthState>().api);
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
    if (otp.length == 6 && !_verifyingOtp && !_busy && _emailOtpSent) {
      _verifyOtp();
    }
  }

  @override
  void dispose() {
    _stopResendTimer();
    _email.removeListener(_onEmailChanged);
    _emailOtp.removeListener(_onOtpChanged);
    for (final c in [_username, _phone, _email, _pass, _pass2, _emailOtp]) {
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

  Future<void> _sendOtp() async {
    if (!RegValidators.isEmail(_email.text)) {
      setState(() => _error = 'Enter a valid email.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _emailVerified = false;
      _emailOtp.clear();
    });
    final res = await _api.sendSalonEmailOtp(_email.text);
    if (!mounted) return;
    setState(() => _busy = false);
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
    final res = await _api.verifySalonEmailOtp(email: _email.text, otp: _emailOtp.text);
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
    final username = _username.text.trim().toLowerCase();
    if (username.length < 3) {
      setState(() => _error = 'Username must be at least 3 characters.');
      return;
    }
    if (!RegValidators.isPhone10(_phone.text)) {
      setState(() => _error = 'Phone must be exactly 10 digits.');
      return;
    }
    if (!RegValidators.isEmail(_email.text)) {
      setState(() => _error = 'Enter a valid email.');
      return;
    }
    if (!RegValidators.isPasswordStrong(_pass.text)) {
      setState(() => _error = 'Password needs 6+ chars, a number and special character.');
      return;
    }
    if (_pass.text != _pass2.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    if (!_emailVerified) {
      setState(() => _error = 'Please verify your email OTP before creating an account.');
      return;
    }
    if (!_terms) {
      setState(() => _error = 'Please accept Terms & Conditions.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final res = await _api.registerSalonQuick({
      'username': username,
      'email': _email.text.trim().toLowerCase(),
      'phone': _phone.text.trim(),
      'password': _pass.text,
      'confirmPassword': _pass2.text,
      'emailOtp': _emailOtp.text.trim(),
      'acceptedTerms': true,
    });

    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Account created'),
          content: Text(
            res['message']?.toString() ??
                'Please login and complete your Glow Space profile to submit for verification.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(
                backgroundColor: GlowProviderSignupScreen.primary,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GlowProviderLoginScreen()),
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
        foregroundColor: GlowProviderSignupScreen.navy,
        title: const Text('Join Glow Space', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick registration',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                SizedBox(height: 6),
                Text(
                  'Create your salon account with a few details. After login, complete your profile and submit for admin verification.',
                  style: TextStyle(color: GlowProviderSignupScreen.navy, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _field(_username, 'Username *', hint: 'Used to sign in (min 3 characters)'),
          _field(
            _phone,
            'Phone *',
            keyboard: TextInputType.phone,
            digitsOnly: true,
          ),
          _field(_email, 'Email *', keyboard: TextInputType.emailAddress),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: (_busy || _resendSecondsRemaining > 0) ? null : _sendOtp,
                  child: Text(
                    _emailOtpSent
                        ? (_resendSecondsRemaining > 0
                            ? 'Resend OTP (${_resendSecondsRemaining}s)'
                            : 'Resend OTP')
                        : 'Send email OTP',
                  ),
                ),
              ),
            ],
          ),
          if (_emailOtpSent) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _emailOtp,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                labelText: 'Email OTP *',
                border: const OutlineInputBorder(),
                suffixIcon: _emailVerified
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : (_verifyingOtp
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _field(_pass, 'Password *', obscure: true),
          _field(_pass2, 'Confirm password *', obscure: true),
          CheckboxListTile(
            value: _terms,
            onChanged: (v) => setState(() => _terms = v ?? false),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('I accept Terms & Conditions'),
          ),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
          ],
          FilledButton(
            onPressed: _busy ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: GlowProviderSignupScreen.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Create Glow Space account'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool obscure = false,
    TextInputType? keyboard,
    bool digitsOnly = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: keyboard,
        inputFormatters: digitsOnly
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
