import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/glow_provider_auth_service.dart';
import 'glow_provider_signup_screen.dart';
import 'glow_salon_dashboard_screen.dart';

class GlowProviderLoginScreen extends StatefulWidget {
  const GlowProviderLoginScreen({super.key, this.initialTab = 0});

  /// Kept for call-site compatibility; stylist tab removed.
  final int initialTab;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<GlowProviderLoginScreen> createState() => _GlowProviderLoginScreenState();
}

class _GlowProviderLoginScreenState extends State<GlowProviderLoginScreen> {
  late final GlowProviderAuthService _auth;
  final _user = TextEditingController();
  final _pass = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _auth = GlowProviderAuthService(context.read<AuthState>().api);
  }

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.loginSalon(username: _user.text, password: _pass.text);
    if (!mounted) return;
    if (res['success'] == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GlowSalonDashboardScreen()),
      );
    } else {
      setState(() {
        _busy = false;
        _error = res['error']?.toString() ?? 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowProviderLoginScreen.navy,
        title: const Text('Glow Space Sign in', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Salon / Glow Space portal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: GlowProviderLoginScreen.navy),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sign in to manage bookings, services and your Glow Space profile.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _user,
            decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pass,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _login,
            style: FilledButton.styleFrom(
              backgroundColor: GlowProviderLoginScreen.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _busy
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Sign in to Glow Space'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GlowProviderSignupScreen()),
            ),
            child: const Text('New here? Register your Glow Space'),
          ),
        ],
      ),
    );
  }
}
