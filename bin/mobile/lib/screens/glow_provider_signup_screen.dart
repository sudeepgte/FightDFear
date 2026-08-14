import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/glow_provider_auth_service.dart';

class GlowProviderSignupScreen extends StatefulWidget {
  const GlowProviderSignupScreen({super.key, this.initialTab = 0});

  /// 0 = Salon, 1 = Stylist
  final int initialTab;

  @override
  State<GlowProviderSignupScreen> createState() => _GlowProviderSignupScreenState();
}

class _GlowProviderSignupScreenState extends State<GlowProviderSignupScreen> with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  late final GlowProviderAuthService _api;
  late final TabController _tabs;

  final _salonName = TextEditingController();
  final _salonUsername = TextEditingController();
  final _salonPhone = TextEditingController();
  final _salonCity = TextEditingController();
  final _salonAddress = TextEditingController();
  final _salonBio = TextEditingController();
  final _salonHours = TextEditingController();
  final _salonPass = TextEditingController();
  final _salonPass2 = TextEditingController();

  final _stylistFirst = TextEditingController();
  final _stylistLast = TextEditingController();
  final _stylistEmail = TextEditingController();
  final _stylistPhone = TextEditingController();
  final _stylistSpecialization = TextEditingController();
  final _stylistBio = TextEditingController();
  final _stylistHours = TextEditingController();
  final _stylistPass = TextEditingController();
  final _stylistPass2 = TextEditingController();

  bool _busy = false;
  bool _obscureSalon = true;
  bool _obscureStylist = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _api = GlowProviderAuthService(context.read<AuthState>().api);
    final tab = widget.initialTab.clamp(0, 1);
    _tabs = TabController(length: 2, vsync: this, initialIndex: tab);
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final c in [
      _salonName,
      _salonUsername,
      _salonPhone,
      _salonCity,
      _salonAddress,
      _salonBio,
      _salonHours,
      _salonPass,
      _salonPass2,
      _stylistFirst,
      _stylistLast,
      _stylistEmail,
      _stylistPhone,
      _stylistSpecialization,
      _stylistBio,
      _stylistHours,
      _stylistPass,
      _stylistPass2,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submitSalon() async {
    if (_salonName.text.trim().isEmpty || _salonUsername.text.trim().isEmpty || _salonPass.text.isEmpty) {
      setState(() => _error = 'Salon name, username and password are required.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _api.registerSalon(
      name: _salonName.text,
      username: _salonUsername.text,
      password: _salonPass.text,
      confirmPassword: _salonPass2.text,
      phone: _salonPhone.text,
      city: _salonCity.text,
      address: _salonAddress.text,
      bio: _salonBio.text,
      availabilityHours: _salonHours.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    await _showResult(res);
  }

  Future<void> _submitStylist() async {
    if (_stylistFirst.text.trim().isEmpty || _stylistEmail.text.trim().isEmpty || _stylistPass.text.isEmpty) {
      setState(() => _error = 'First name, email and password are required.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _api.registerStylist(
      firstName: _stylistFirst.text,
      lastName: _stylistLast.text,
      email: _stylistEmail.text,
      password: _stylistPass.text,
      confirmPassword: _stylistPass2.text,
      contactNumber: _stylistPhone.text,
      specialization: _stylistSpecialization.text,
      bio: _stylistBio.text,
      availabilityHours: _stylistHours.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    await _showResult(res);
  }

  Future<void> _showResult(Map<String, dynamic> res) async {
    if (res['success'] == true) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Registration submitted'),
          content: Text(
            '${res['message'] ?? 'Submitted successfully.'}\n\nUse web or existing provider login after admin approval.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop();
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
        foregroundColor: navy,
        title: const Text('Glow Provider Sign Up', style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: primary,
          labelColor: primary,
          tabs: const [
            Tab(text: 'Salon'),
            Tab(text: 'Stylist'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildSalonForm(),
          _buildStylistForm(),
        ],
      ),
    );
  }

  Widget _buildSalonForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _text(_salonName, 'Salon name'),
        _text(_salonUsername, 'Username'),
        _text(_salonPhone, 'Phone (optional)', keyboard: TextInputType.phone),
        _text(_salonCity, 'City (optional)'),
        _text(_salonAddress, 'Address (optional)', maxLines: 2),
        _text(_salonBio, 'Bio (optional)', maxLines: 3),
        _text(_salonHours, 'Availability hours (optional)'),
        _text(_salonPass, 'Password', obscure: _obscureSalon, suffix: IconButton(icon: Icon(_obscureSalon ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscureSalon = !_obscureSalon))),
        _text(_salonPass2, 'Confirm password', obscure: _obscureSalon),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy ? null : _submitSalon,
          style: FilledButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 14)),
          child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Register salon'),
        ),
      ],
    );
  }

  Widget _buildStylistForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _text(_stylistFirst, 'First name'),
        _text(_stylistLast, 'Last name (optional)'),
        _text(_stylistEmail, 'Email', keyboard: TextInputType.emailAddress),
        _text(_stylistPhone, 'Phone (optional)', keyboard: TextInputType.phone),
        _text(_stylistSpecialization, 'Specialization (optional)'),
        _text(_stylistBio, 'Bio (optional)', maxLines: 3),
        _text(_stylistHours, 'Availability hours (optional)'),
        _text(_stylistPass, 'Password', obscure: _obscureStylist, suffix: IconButton(icon: Icon(_obscureStylist ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _obscureStylist = !_obscureStylist))),
        _text(_stylistPass2, 'Confirm password', obscure: _obscureStylist),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy ? null : _submitStylist,
          style: FilledButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 14)),
          child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Register stylist'),
        ),
      ],
    );
  }

  Widget _text(
    TextEditingController ctrl,
    String label, {
    TextInputType? keyboard,
    bool obscure = false,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        obscureText: obscure,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
