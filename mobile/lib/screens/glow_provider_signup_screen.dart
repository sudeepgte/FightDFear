import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../config/glow_catalog.dart';
import '../services/auth_state.dart';
import '../services/glow_provider_auth_service.dart';
import '../widgets/registration_form_kit.dart';

/// Single Glow Space provider registration (salon / beauty centre).
class GlowProviderSignupScreen extends StatefulWidget {
  const GlowProviderSignupScreen({super.key, this.initialTab = 0});

  /// Kept for call-site compatibility; dual tabs removed.
  final int initialTab;

  @override
  State<GlowProviderSignupScreen> createState() => _GlowProviderSignupScreenState();
}

class _GlowProviderSignupScreenState extends State<GlowProviderSignupScreen> {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  late final GlowProviderAuthService _api;

  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _bio = TextEditingController();
  final _hoursStart = TextEditingController(text: '10:00');
  final _hoursEnd = TextEditingController(text: '19:00');
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();

  final Set<String> _categories = {};
  final Set<String> _selectedServices = {};
  final Set<String> _days = {};
  bool _terms = false;
  bool _busy = false;
  String? _error;
  String? _expandedCategory;

  @override
  void initState() {
    super.initState();
    _api = GlowProviderAuthService(context.read<AuthState>().api);
  }

  @override
  void dispose() {
    for (final c in [
      _name, _username, _email, _phone, _city, _address, _bio,
      _hoursStart, _hoursEnd, _pass, _pass2,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _toggleCategory(GlowCategory cat) {
    setState(() {
      if (_categories.contains(cat.code)) {
        _categories.remove(cat.code);
        _selectedServices.removeWhere(cat.services.contains);
        if (_expandedCategory == cat.code) _expandedCategory = null;
      } else {
        _categories.add(cat.code);
        _expandedCategory = cat.code;
      }
    });
  }

  void _toggleService(String categoryCode, String service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
        _categories.add(categoryCode);
      }
    });
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty ||
        _username.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _pass.text.isEmpty) {
      setState(() => _error = 'Salon name, username, email and password are required.');
      return;
    }
    if (!RegValidators.isEmail(_email.text)) {
      setState(() => _error = 'Enter a valid email.');
      return;
    }
    if (_phone.text.trim().isNotEmpty && !RegValidators.isPhone10(_phone.text)) {
      setState(() => _error = 'Phone must be exactly 10 digits.');
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
    if (_categories.isEmpty) {
      setState(() => _error = 'Select at least one Glow Space category.');
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

    final servicesPayload = <Map<String, dynamic>>[];
    for (final cat in GlowCatalog.categories) {
      if (!_categories.contains(cat.code)) continue;
      final picked = cat.services.where(_selectedServices.contains).toList();
      final names = picked.isNotEmpty ? picked : cat.services.take(3).toList();
      for (final name in names) {
        servicesPayload.add({
          'category': cat.code,
          'name': name,
          'price': GlowCatalog.defaultPrice(cat.code),
          'durationMinutes': GlowCatalog.defaultDuration(cat.code),
        });
      }
    }

    final bio = [
      _bio.text.trim(),
      if (_email.text.trim().isNotEmpty) 'Email: ${_email.text.trim()}',
      'Categories: ${_categories.map(GlowCatalog.labelFor).join(', ')}',
      if (_days.isNotEmpty) 'Days: ${_days.join(', ')}',
      'Hours: ${_hoursStart.text.trim()} – ${_hoursEnd.text.trim()}',
    ].where((e) => e.isNotEmpty).join('\n');

    final res = await _api.registerSalon(
      name: _name.text,
      username: _username.text,
      password: _pass.text,
      confirmPassword: _pass2.text,
      phone: _phone.text,
      city: _city.text,
      address: _address.text,
      bio: bio,
      availabilityHours: '${_hoursStart.text.trim()} – ${_hoursEnd.text.trim()}',
      categories: _categories.toList(),
      services: servicesPayload,
    );

    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      final seeded = res['servicesSeeded'];
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Glow Space registered'),
          content: Text(
            'Your registration is pending admin approval.'
            '${seeded != null ? '\n\n$seeded services were prepared for your catalogue.' : ''}',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(backgroundColor: primary),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
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
        title: const Text('Join Glow Space', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const Text(
            'Register your salon under Glow Space',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: navy),
          ),
          const SizedBox(height: 6),
          const Text(
            'One registration for hair, skin, spa, bridal and more. Pick the categories you provide.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.35),
          ),
          const SizedBox(height: 18),
          _field(_name, 'Salon / Centre name *'),
          _field(_username, 'Username *'),
          _field(_email, 'Email *', keyboard: TextInputType.emailAddress),
          _field(_phone, 'Phone (10 digits)', keyboard: TextInputType.phone, digitsOnly: true),
          _field(_city, 'City'),
          _field(_address, 'Address', maxLines: 2),
          _field(_bio, 'About your Glow Space', maxLines: 3),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _field(_hoursStart, 'Opens')),
              const SizedBox(width: 10),
              Expanded(child: _field(_hoursEnd, 'Closes')),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Open days', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RegOptions.doctorWorkingDays.map((d) {
              final selected = _days.contains(d);
              return FilterChip(
                label: Text(d.substring(0, 3)),
                selected: selected,
                onSelected: (_) => setState(() {
                  if (selected) {
                    _days.remove(d);
                  } else {
                    _days.add(d);
                  }
                }),
                selectedColor: primary.withValues(alpha: 0.15),
                checkmarkColor: primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('Glow Space categories *', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 4),
          const Text(
            'Select categories, then optionally pick specific services to list.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 10),
          ...GlowCatalog.categories.map(_categoryCard),
          const SizedBox(height: 16),
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
              backgroundColor: primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _busy
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Submit Glow Space registration'),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(GlowCategory cat) {
    final selected = _categories.contains(cat.code);
    final expanded = _expandedCategory == cat.code;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? primary : Colors.grey.shade300, width: selected ? 1.5 : 1),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: primary.withValues(alpha: 0.12),
              child: Icon(cat.icon, color: primary, size: 20),
            ),
            title: Text(cat.label, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(cat.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: selected,
                  activeColor: primary,
                  onChanged: (_) => _toggleCategory(cat),
                ),
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() {
                    _expandedCategory = expanded ? null : cat.code;
                    if (!selected && !expanded) _categories.add(cat.code);
                  }),
                ),
              ],
            ),
            onTap: () => _toggleCategory(cat),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: cat.services.map((s) {
                  final on = _selectedServices.contains(s);
                  return FilterChip(
                    label: Text(s, style: const TextStyle(fontSize: 12)),
                    selected: on,
                    onSelected: (_) => _toggleService(cat.code, s),
                    selectedColor: primary.withValues(alpha: 0.15),
                    checkmarkColor: primary,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool obscure = false,
    int maxLines = 1,
    TextInputType? keyboard,
    bool digitsOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        obscureText: obscure,
        maxLines: obscure ? 1 : maxLines,
        keyboardType: keyboard,
        inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : null,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
