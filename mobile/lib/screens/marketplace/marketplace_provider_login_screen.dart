import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'marketplace_provider_dashboard_screen.dart';

class MarketplaceProviderLoginScreen extends StatefulWidget {
  const MarketplaceProviderLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  State<MarketplaceProviderLoginScreen> createState() =>
      _MarketplaceProviderLoginScreenState();
}

class _MarketplaceProviderLoginScreenState extends State<MarketplaceProviderLoginScreen> {
  static const _draftKey = 'service_partner_register_draft_v1';

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _businessName = TextEditingController();
  final _location = TextEditingController();
  final _desc = TextEditingController();
  final _experience = TextEditingController();
  final _radius = TextEditingController(text: '10');
  final _price = TextEditingController();
  final _instagram = TextEditingController();
  final _facebook = TextEditingController();
  final _hours = TextEditingController(text: '10:00 AM – 7:00 PM');

  String _category = RegOptions.marketplaceCategories.first;
  String _serviceType = RegOptions.serviceTypes.last;
  final Set<String> _days = {};
  String? _photo;
  String? _photoPath;
  String? _portfolio;
  String? _portfolioPath;
  String? _govId;
  String? _govIdPath;
  bool _terms = false;
  bool _loading = false;
  bool _locating = false;
  bool _register = false;
  bool _draftRestored = false;
  String? _error;
  String? _draftHint;
  Timer? _autosaveTimer;

  @override
  void initState() {
    super.initState();
    _register = widget.startRegister;
    for (final c in _watchedControllers) {
      c.addListener(_onFieldChanged);
    }
    if (_register) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _offerDraftResume());
    }
  }

  List<TextEditingController> get _watchedControllers => [
        _email,
        _password,
        _confirm,
        _name,
        _phone,
        _businessName,
        _location,
        _desc,
        _experience,
        _radius,
        _price,
        _instagram,
        _facebook,
        _hours,
      ];

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    for (final c in _watchedControllers) {
      c.removeListener(_onFieldChanged);
      c.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged() {
    if (!mounted) return;
    setState(() {});
    if (_register) _scheduleAutosave();
  }

  void _scheduleAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 600), () async {
      await _saveDraft();
      if (mounted) {
        setState(() => _draftHint = 'Draft auto-saved');
      }
    });
  }

  Map<String, dynamic> _draftPayload() => {
        'email': _email.text,
        'name': _name.text,
        'phone': _phone.text,
        'businessName': _businessName.text,
        'location': _location.text,
        'desc': _desc.text,
        'experience': _experience.text,
        'radius': _radius.text,
        'price': _price.text,
        'instagram': _instagram.text,
        'facebook': _facebook.text,
        'hours': _hours.text,
        'category': _category,
        'serviceType': _serviceType,
        'days': _days.toList(),
        'terms': _terms,
        'photo': _photo,
        'photoPath': _photoPath,
        'portfolio': _portfolio,
        'portfolioPath': _portfolioPath,
        'govId': _govId,
        'govIdPath': _govIdPath,
        // Never persist passwords.
        'savedAt': DateTime.now().toIso8601String(),
      };

  Future<void> _saveDraft() async {
    if (!_register) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(_draftPayload()));
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _offerDraftResume() async {
    if (_draftRestored) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null || raw.isEmpty || !mounted) return;

    Map<String, dynamic> data;
    try {
      data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return;
    }

    final hasContent = [
      data['name'],
      data['email'],
      data['phone'],
      data['location'],
      data['businessName'],
    ].any((e) => e != null && e.toString().trim().isNotEmpty);
    if (!hasContent) return;

    final resume = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.restore, color: Color(0xFFF43F5E), size: 40),
        title: const Text('Continue Registration?'),
        content: const Text(
          'We found a saved Service Partner draft from an earlier session. '
          'Would you like to continue where you left off?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Start fresh'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (resume == true) {
      _applyDraft(data);
      _draftRestored = true;
      setState(() => _draftHint = 'Draft restored — keep filling to auto-save');
    } else {
      await _clearDraft();
      _draftRestored = true;
    }
  }

  void _applyDraft(Map<String, dynamic> data) {
    _email.text = data['email']?.toString() ?? '';
    _name.text = data['name']?.toString() ?? '';
    _phone.text = data['phone']?.toString() ?? '';
    _businessName.text = data['businessName']?.toString() ?? '';
    _location.text = data['location']?.toString() ?? '';
    _desc.text = data['desc']?.toString() ?? '';
    _experience.text = data['experience']?.toString() ?? '';
    _radius.text = data['radius']?.toString() ?? '10';
    _price.text = data['price']?.toString() ?? '';
    _instagram.text = data['instagram']?.toString() ?? '';
    _facebook.text = data['facebook']?.toString() ?? '';
    _hours.text = data['hours']?.toString() ?? _hours.text;
    final cat = data['category']?.toString();
    if (cat != null && RegOptions.marketplaceCategories.contains(cat)) {
      _category = cat;
    }
    final st = data['serviceType']?.toString();
    if (st != null && RegOptions.serviceTypes.contains(st)) {
      _serviceType = st;
    }
    _days
      ..clear()
      ..addAll(((data['days'] as List?) ?? const []).map((e) => e.toString()));
    _terms = data['terms'] == true;
    _photo = data['photo']?.toString();
    _photoPath = data['photoPath']?.toString();
    _portfolio = data['portfolio']?.toString();
    _portfolioPath = data['portfolioPath']?.toString();
    _govId = data['govId']?.toString();
    _govIdPath = data['govIdPath']?.toString();
    setState(() {});
  }

  List<String> get _missingRegisterFields {
    final missing = <String>[];
    if (_name.text.trim().isEmpty) missing.add('Full name');
    if (!RegValidators.isPhone10(_phone.text)) missing.add('Phone (10 digits)');
    if (_location.text.trim().isEmpty) missing.add('Address / location');
    if (!RegValidators.isEmail(_email.text)) missing.add('Valid email');
    if (!RegValidators.isPasswordStrong(_password.text)) {
      missing.add('Strong password');
    }
    if (_password.text != _confirm.text || _confirm.text.isEmpty) {
      missing.add('Matching confirm password');
    }
    if (!_terms) missing.add('Accept Terms');
    return missing;
  }

  bool get _canRegister => !_loading && _missingRegisterFields.isEmpty;

  bool get _canLogin {
    return !_loading && _email.text.trim().isNotEmpty && _password.text.isNotEmpty;
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _error = 'Location permission is required to use current location.');
        return;
      }
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() => _error = 'Please turn on location services and try again.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final maps = 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
      final label =
          'Current location (${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)})\n$maps';
      setState(() {
        _location.text = label;
        _draftHint = 'Location filled from GPS';
      });
      _scheduleAutosave();
    } catch (e) {
      setState(() => _error = 'Could not fetch location: $e');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickDoc({
    required void Function(PickedUpload u) apply,
  }) async {
    try {
      final u = await pickDocumentUpload();
      if (u == null) return;
      setState(() => apply(u));
      _scheduleAutosave();
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  Future<void> _submit() async {
    if (_register) {
      final missing = _missingRegisterFields;
      if (missing.isNotEmpty) {
        setState(() => _error = 'Still needed: ${missing.join(', ')}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complete: ${missing.join(' · ')}')),
        );
        return;
      }
    } else if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Email and password are required');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = MarketplaceProviderAuthService(context.read<AuthState>().api);
      final res = _register
          ? await api.register(
              fullName: _name.text.trim(),
              email: _email.text.trim(),
              phone: _phone.text.trim(),
              password: _password.text,
              confirmPassword: _confirm.text,
              category: _category.toUpperCase().replaceAll(' ', '_'),
              description: [
                if (_businessName.text.trim().isNotEmpty) 'Business: ${_businessName.text.trim()}',
                _desc.text.trim(),
                if (_experience.text.trim().isNotEmpty) 'Experience: ${_experience.text.trim()} yrs',
                'Service: $_serviceType',
                if (_radius.text.trim().isNotEmpty) 'Radius: ${_radius.text.trim()} km',
                if (_days.isNotEmpty) 'Days: ${_days.join(', ')}',
                if (_hours.text.trim().isNotEmpty) 'Hours: ${_hours.text.trim()}',
                if (_price.text.trim().isNotEmpty) 'Starting price: Rs ${_price.text.trim()}',
                if (_instagram.text.trim().isNotEmpty) 'IG: ${_instagram.text.trim()}',
                if (_facebook.text.trim().isNotEmpty) 'FB: ${_facebook.text.trim()}',
                if (_photo != null) 'Photo: $_photo',
                if (_portfolio != null) 'Portfolio: $_portfolio',
                if (_govId != null) 'Gov ID: $_govId',
              ].where((e) => e.isNotEmpty).join('\n'),
              locationText: _location.text.trim(),
            )
          : await api.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      if (res['success'] == true) {
        if (_register) {
          await _clearDraft();
          await showRegistrationSuccessDialog(
            context,
            message:
                'Registration submitted successfully. Your provider profile is under verification and will be activated after approval.',
            onDone: () => setState(() {
              _register = false;
              _password.clear();
              _confirm.clear();
              _terms = false;
            }),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MarketplaceProviderDashboardScreen()),
          );
        }
      } else {
        final msg = res['error']?.toString() ?? 'Action failed';
        setState(() => _error = msg);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      final msg = '$e';
      setState(() => _error = msg);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  static const Color _primary = Color(0xFFF43F5E);
  static const Color _navy = Color(0xFF1E1B4B);
  static const Color _muted = Color(0xFF64748B);

  InputDecoration _fieldDecoration(String label, {String? hint, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    );
  }

  Widget _gradientButton({required String label, required VoidCallback? onPressed}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? null
            : const LinearGradient(
                colors: [Color(0xFF2E1C59), Color(0xFFD93662)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: onPressed == null ? Colors.grey.shade400 : null,
        borderRadius: BorderRadius.circular(28),
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 52,
            child: Center(
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandHero({required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E1C59), Color(0xFFD93662)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(22)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.handshake_outlined, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 14),
          const Text(
            'Service Partner',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBody() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _brandHero(subtitle: 'Welcome back — manage bookings, clients & earnings'),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _navy),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use your verified Service Partner account',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                    const SizedBox(height: 18),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13)),
                      ),
                    ],
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration('Email *', hint: 'you@example.com'),
                    ),
                    const SizedBox(height: 12),
                    ObscurePasswordField(
                      controller: _password,
                      label: 'Password *',
                    ),
                    const SizedBox(height: 20),
                    _gradientButton(
                      label: 'Login',
                      onPressed: _loading ? null : _submit,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () async {
                              setState(() {
                                _register = true;
                                _error = null;
                              });
                              await _offerDraftResume();
                            },
                      child: const Text(
                        'New here? Register',
                        style: TextStyle(color: _primary, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missing = _register ? _missingRegisterFields : const <String>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: _navy,
        title: Text(
          _register ? 'Service Partner Join' : 'Service Partner Login',
          style: const TextStyle(fontWeight: FontWeight.w800, color: _navy),
        ),
        actions: [
          if (_register)
            IconButton(
              tooltip: 'Save draft now',
              onPressed: () async {
                await _saveDraft();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Draft saved. You can continue later.')),
                );
              },
              icon: const Icon(Icons.save_outlined),
            ),
        ],
      ),
      body: !_register
          ? _buildLoginBody()
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _brandHero(subtitle: 'Join our network and grow your local service business'),
                      const SizedBox(height: 14),
                      if (_draftHint != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.cloud_done_outlined, size: 16, color: Colors.teal),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(_draftHint!, style: const TextStyle(fontSize: 12, color: Colors.teal)),
                              ),
                            ],
                          ),
                        ),
                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(_error!, style: const TextStyle(color: Colors.red)),
                        ),
                      TextField(
                        controller: _name,
                        decoration: _fieldDecoration('Full name *'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: _fieldDecoration('Phone *', hint: '10-digit mobile number'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _businessName,
                        decoration: _fieldDecoration('Business name (optional)'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        key: ValueKey('cat_$_category'),
                        initialValue: _category,
                        decoration: _fieldDecoration('Service category *'),
                        items: RegOptions.marketplaceCategories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _category = v ?? _category);
                          _scheduleAutosave();
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _experience,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration('Experience (years)'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        key: ValueKey('svc_$_serviceType'),
                        initialValue: _serviceType,
                        decoration: _fieldDecoration('Service type *'),
                        items: RegOptions.serviceTypes
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _serviceType = v ?? _serviceType);
                          _scheduleAutosave();
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _radius,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration('Service radius (km)'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _location,
                        maxLines: 3,
                        decoration: _fieldDecoration('Address / location *', hint: 'Area, landmark, or Maps link'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _locating ? null : _useCurrentLocation,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primary,
                          side: const BorderSide(color: _primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: _locating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(_locating ? 'Getting location…' : 'Use Current Location'),
                      ),
                      ChipMultiSelect(
                        label: 'Working days',
                        options: RegOptions.weekDaysShort,
                        selected: _days,
                        onChanged: (s) {
                          setState(() {
                            _days
                              ..clear()
                              ..addAll(s);
                          });
                          _scheduleAutosave();
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _hours,
                        decoration: _fieldDecoration('Working hours'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _price,
                        keyboardType: TextInputType.number,
                        decoration: _fieldDecoration('Starting price (Rs)'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _desc,
                        maxLines: 3,
                        decoration: _fieldDecoration('Description'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _instagram,
                        decoration: _fieldDecoration('Instagram'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _facebook,
                        decoration: _fieldDecoration('Facebook'),
                      ),
                      FileUploadTile(
                        label: 'Profile photo',
                        fileName: _photo,
                        filePath: _photoPath,
                        onPick: () => _pickDoc(
                          apply: (u) {
                            _photo = u.name;
                            _photoPath = u.path;
                          },
                        ),
                        onClear: () {
                          setState(() {
                            _photo = null;
                            _photoPath = null;
                          });
                          _scheduleAutosave();
                        },
                      ),
                      FileUploadTile(
                        label: 'Portfolio / work images',
                        fileName: _portfolio,
                        filePath: _portfolioPath,
                        onPick: () => _pickDoc(
                          apply: (u) {
                            _portfolio = u.name;
                            _portfolioPath = u.path;
                          },
                        ),
                        onClear: () {
                          setState(() {
                            _portfolio = null;
                            _portfolioPath = null;
                          });
                          _scheduleAutosave();
                        },
                      ),
                      FileUploadTile(
                        label: 'Government ID verification',
                        fileName: _govId,
                        filePath: _govIdPath,
                        onPick: () => _pickDoc(
                          apply: (u) {
                            _govId = u.name;
                            _govIdPath = u.path;
                          },
                        ),
                        onClear: () {
                          setState(() {
                            _govId = null;
                            _govIdPath = null;
                          });
                          _scheduleAutosave();
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _email,
                        decoration: _fieldDecoration('Email *'),
                      ),
                      const SizedBox(height: 10),
                      ObscurePasswordField(
                        controller: _password,
                        label: 'Password *',
                        showStrength: true,
                      ),
                      if (_password.text.isNotEmpty && !RegValidators.isPasswordStrong(_password.text))
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Min 6 chars with a number and special character (!@#\$%^&*)',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ObscurePasswordField(
                        controller: _confirm,
                        label: 'Confirm password *',
                      ),
                      if (_confirm.text.isNotEmpty && _confirm.text != _password.text)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('Passwords do not match', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: _primary,
                        value: _terms,
                        onChanged: (v) {
                          setState(() => _terms = v ?? false);
                          _scheduleAutosave();
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text('I agree to the Terms & Conditions', style: TextStyle(fontSize: 13)),
                      ),
                      if (missing.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Still needed:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.orange.shade800),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: missing
                              .map(
                                (m) => Chip(
                                  label: Text(m, style: const TextStyle(fontSize: 11)),
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Colors.orange.shade50,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 13)),
                        ),
                      ],
                      const SizedBox(height: 12),
                      _gradientButton(
                        label: 'Submit Registration',
                        onPressed: _loading ? null : _submit,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Drafts auto-save as you type. Scroll up if name, phone, or location is still needed.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => setState(() {
                                  _register = false;
                                  _error = null;
                                }),
                        child: const Text(
                          'Already registered? Login',
                          style: TextStyle(color: _primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
