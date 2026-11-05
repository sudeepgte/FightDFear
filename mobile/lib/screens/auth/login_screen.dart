import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../widgets/registration_form_kit.dart';
import '../../widgets/server_config_dialog.dart';
import '../safety/home_screen.dart';
import 'register_screen.dart';
import '../user/user_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.initialEmail,
    this.redirectToSos = false,
    this.popOnSuccess = false,
  });

  /// Pre-filled email (e.g. after registration).
  final String? initialEmail;

  /// When true, successful login opens the SOS home instead of popping back.
  final bool redirectToSos;

  /// When true, successful login pops this route with `true` (for gated actions).
  final bool popOnSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _error;
  bool _detectingServer = false;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _email.text = widget.initialEmail!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthState>().autoDetectWorkingServer();
      }
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _emailError = null;
      _passwordError = null;
    });

    final email = _email.text.trim();
    final pass = _password.text;

    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
    } else if (!RegValidators.isEmail(email)) {
      setState(() => _emailError = 'Enter a valid mail id (must be @gmail.com)');
    }

    if (pass.isEmpty) {
      setState(() => _passwordError = 'Password is required');
    }

    if (_emailError != null || _passwordError != null) {
      setState(() => _error = _emailError ?? _passwordError);
      return;
    }

    final auth = context.read<AuthState>();
    final ok = await auth.login(_email.text, _password.text);
    if (!mounted) return;
    if (!ok) {
      setState(() => _error = auth.error ?? 'Login failed');
      return;
    }
    if (widget.popOnSuccess) {
      Navigator.of(context).pop(true);
    } else if (widget.redirectToSos) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => route.isFirst,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
        (route) => route.isFirst,
      );
    }
  }

  Future<void> _openForgotPassword() async {
    final emailCtrl = TextEditingController(text: _email.text.trim());
    String? localError;
    bool sending = false;

    await showDialog<void>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.lock_reset, color: Color(0xFFF43F5E)),
              SizedBox(width: 8),
              Text('Forgot Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your registered email address below. A password reset link will be sent to your email inbox.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'user@gmail.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: localError,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: sending ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
              onPressed: sending
                  ? null
                  : () async {
                      final email = emailCtrl.text.trim();
                      if (email.isEmpty) {
                        setDialogState(() => localError = 'Please enter your email address');
                        return;
                      }
                      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
                        setDialogState(() => localError = 'Please enter a valid email address');
                        return;
                      }
                      setDialogState(() {
                        sending = true;
                        localError = null;
                      });
                      try {
                        final api = context.read<AuthState>().api;
                        final res = await api.post(
                          '/api/auth/forgot-password',
                          auth: false,
                          body: {'email': email},
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          final msg = res['message']?.toString() ??
                              'If an account with that email exists, a password reset link has been sent to your inbox.';
                          showDialog<void>(
                            context: context,
                            builder: (infoCtx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              title: const Text('Password Reset Sent'),
                              content: Text(msg),
                              actions: [
                                FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E)),
                                  onPressed: () => Navigator.pop(infoCtx),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          sending = false;
                          localError = 'Failed to send request: $e';
                        });
                      }
                    },
              child: sending
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Send Link'),
            ),
          ],
        ),
      ),
    );
    emailCtrl.dispose();
  }

  InputDecoration _decoration(String label, {IconData? icon, Widget? suffix, String? helperText, String? errorText}) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      helperMaxLines: 2,
      errorText: errorText,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon == null ? null : Icon(icon, color: const Color(0xFFBE123C)),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFF43F5E), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sign in'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E1B4B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.dns_outlined),
            tooltip: 'Server Connection',
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE4E6), Color(0xFFFFF1F2), Color(0xFFF8FAFC)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(56, 16, 20, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF43F5E).withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite_rounded, size: 40, color: Color(0xFFF43F5E)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Fight D Fear',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1B4B),
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign in to use SOS & trusted contacts',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: InkWell(
                        onTap: () => ServerConfigDialog.show(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.dns_outlined, size: 12, color: Color(0xFFF43F5E)),
                              const SizedBox(width: 4),
                              Text(
                                context.watch<AuthState>().apiBaseUrl,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.edit, size: 10, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13, height: 1.3)),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: [
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          backgroundColor: Colors.white,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: _detectingServer
                                            ? null
                                            : () async {
                                                final messenger = ScaffoldMessenger.of(context);
                                                setState(() => _detectingServer = true);
                                                final auth = context.read<AuthState>();
                                                final found = await auth.autoDetectWorkingServer();
                                                if (!mounted) return;
                                                setState(() => _detectingServer = false);
                                                if (found != null) {
                                                  setState(() => _error = null);
                                                  messenger.showSnackBar(
                                                    SnackBar(content: Text('Connected to: $found')),
                                                  );
                                                } else {
                                                  messenger.showSnackBar(
                                                    const SnackBar(content: Text('No active server detected. Please ensure Wi-Fi connection.')),
                                                  );
                                                }
                                              },
                                        icon: _detectingServer
                                            ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                                            : const Icon(Icons.refresh_rounded, size: 14, color: Color(0xFFBE123C)),
                                        label: Text(
                                          _detectingServer ? 'Detecting...' : 'Auto-detect Server',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFFBE123C), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          backgroundColor: Colors.white,
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: () => ServerConfigDialog.show(context),
                                        icon: const Icon(Icons.settings_outlined, size: 14, color: Color(0xFF64748B)),
                                        label: const Text(
                                          'Change IP',
                                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          TextField(
                            key: const ValueKey('login_email_input'),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            onChanged: (_) {
                              if (_emailError != null) setState(() => _emailError = null);
                            },
                            decoration: _decoration(
                              'Email',
                              icon: Icons.email_outlined,
                              helperText: 'Enter your registered @gmail.com address.',
                              errorText: _emailError,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            key: const ValueKey('login_password_input'),
                            controller: _password,
                            obscureText: _obscure,
                            autofillHints: const [AutofillHints.password],
                            onChanged: (_) {
                              if (_passwordError != null) setState(() => _passwordError = null);
                            },
                            onSubmitted: (_) => _submit(),
                            decoration: _decoration(
                              'Password',
                              icon: Icons.lock_outline,
                              helperText: 'Enter your account password.',
                              errorText: _passwordError,
                              suffix: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _openForgotPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFFF43F5E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 52,
                            child: FilledButton(
                              onPressed: auth.loading ? null : _submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF43F5E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              child: auth.loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                    )
                                  : const Text('Sign in'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFBE123C),
                        side: const BorderSide(color: Color(0xFFF43F5E)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Create account'),
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
