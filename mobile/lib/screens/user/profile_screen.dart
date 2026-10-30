import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../widgets/module_theme.dart';

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
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String? _email;
  String? _status;

  String? _nameError;
  String? _phoneError;
  String? _addressError;

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
        _nameCtrl.text = res['name']?.toString() ?? '';
        _phoneCtrl.text = res['phone']?.toString() ?? '';
        _addressCtrl.text = res['homeAddress']?.toString() ?? '';
        _email = res['email']?.toString();
        _status = res['status']?.toString();
      } else {
        _error = res['error']?.toString();
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() {
      _nameError = null;
      _phoneError = null;
      _addressError = null;
    });

    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();

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

    if (_nameError != null || _phoneError != null || _addressError != null) {
      setState(() {});
      return;
    }

    setState(() => _saving = true);
    try {
      final res = await _api.updateProfile(
        fullName: name,
        phoneNumber: phone,
        homeAddress: address,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        final auth = context.read<AuthState>();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        _nameCtrl.text = res['name']?.toString() ?? _nameCtrl.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Update failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _load)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_email != null)
                        Text('Email: $_email', style: const TextStyle(color: ModuleTheme.textGray)),
                      if (_status != null) ...[
                        const SizedBox(height: 4),
                        Text('Status: $_status', style: const TextStyle(color: ModuleTheme.textGray)),
                      ],
                      const SizedBox(height: 20),
                      TextField(
                        key: const ValueKey('member_profile_name_input'),
                        controller: _nameCtrl,
                        onChanged: (_) {
                          if (_nameError != null) setState(() => _nameError = null);
                        },
                        decoration: InputDecoration(
                          labelText: 'Full name *',
                          helperText: 'Enter your full name as it appears on your official documents.',
                          helperMaxLines: 2,
                          errorText: _nameError,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        key: const ValueKey('member_profile_phone_input'),
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) {
                          if (_phoneError != null) setState(() => _phoneError = null);
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone *',
                          helperText: 'Enter your 10-digit mobile number.',
                          helperMaxLines: 2,
                          errorText: _phoneError,
                          border: const OutlineInputBorder(),
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
                          labelText: 'Home address *',
                          helperText: 'Enter your residential address or location details.',
                          helperMaxLines: 2,
                          errorText: _addressError,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save changes'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
