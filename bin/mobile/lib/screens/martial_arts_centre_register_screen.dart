import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/centre_auth_service.dart';
import 'martial_arts_centre_login_screen.dart';

class MartialArtsCentreRegisterScreen extends StatefulWidget {
  const MartialArtsCentreRegisterScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentreRegisterScreen> createState() =>
      _MartialArtsCentreRegisterScreenState();
}

class _ProgramRow {
  _ProgramRow() {
    slots.add(TextEditingController());
  }
  final nameCtrl = TextEditingController();
  final costCtrl = TextEditingController(text: '0');
  final slots = <TextEditingController>[];

  void dispose() {
    nameCtrl.dispose();
    costCtrl.dispose();
    for (final s in slots) {
      s.dispose();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nameCtrl.text.trim(),
      'cost': double.tryParse(costCtrl.text.trim()) ?? 0,
      'slots': slots
          .map((s) => s.text.trim())
          .where((t) => t.isNotEmpty)
          .map((t) => {'timeRange': t})
          .toList(),
    };
  }
}

class _MartialArtsCentreRegisterScreenState extends State<MartialArtsCentreRegisterScreen> {
  late final CentreAuthService _auth;
  int _step = 0;
  bool _busy = false;
  String? _error;

  final _nameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _teachCtrl = TextEditingController();
  final _offerCtrl = TextEditingController();

  final Set<String> _days = {};
  final List<_ProgramRow> _programs = [_ProgramRow()];
  XFile? _certificate;
  XFile? _profilePhoto;
  final List<XFile> _gallery = [];
  final _picker = ImagePicker();

  static const _weekDays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];

  @override
  void initState() {
    super.initState();
    _auth = CentreAuthService(context.read<AuthState>().api);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _aboutCtrl.dispose();
    _teachCtrl.dispose();
    _offerCtrl.dispose();
    for (final p in _programs) {
      p.dispose();
    }
    super.dispose();
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty ||
            _locationCtrl.text.trim().isEmpty ||
            _phoneCtrl.text.trim().length != 10 ||
            _emailCtrl.text.trim().isEmpty ||
            _passCtrl.text.length < 6) {
          setState(() => _error = 'Fill all fields. Phone = 10 digits, password min 6 chars with number & symbol.');
          return false;
        }
        return true;
      case 1:
        if (_aboutCtrl.text.trim().isEmpty ||
            _teachCtrl.text.trim().isEmpty ||
            _offerCtrl.text.trim().isEmpty) {
          setState(() => _error = 'About, teaching method, and facilities are required.');
          return false;
        }
        return true;
      case 2:
        final programs = _programs.map((p) => p.toJson()).where((p) => (p['name'] as String).isNotEmpty).toList();
        if (programs.isEmpty) {
          setState(() => _error = 'Add at least one program.');
          return false;
        }
        for (final p in programs) {
          final slots = p['slots'] as List;
          if (slots.isEmpty) {
            setState(() => _error = 'Each program needs at least one time slot.');
            return false;
          }
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _submit() async {
    if (!_validateStep(2)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final programs = _programs.map((p) => p.toJson()).where((p) => (p['name'] as String).isNotEmpty).toList();
      final fields = <String, String>{
        'name': _nameCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'phoneNumber': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim().toLowerCase(),
        'password': _passCtrl.text,
        'about': _aboutCtrl.text.trim(),
        'howWeTeach': _teachCtrl.text.trim(),
        'whatWeOffer': _offerCtrl.text.trim(),
        'availableDays': _days.join(','),
        'martialArtsJson': jsonEncode(programs),
      };
      final files = <http.MultipartFile>[];
      if (_certificate != null) {
        files.add(await http.MultipartFile.fromPath('certificate', _certificate!.path));
      }
      if (_profilePhoto != null) {
        files.add(await http.MultipartFile.fromPath('profileimage', _profilePhoto!.path));
      }
      for (final g in _gallery) {
        files.add(await http.MultipartFile.fromPath('galleryPhotos', g.path));
      }
      final res = files.isEmpty
          ? await _auth.registerLite(
              name: _nameCtrl.text,
              location: _locationCtrl.text,
              phoneNumber: _phoneCtrl.text,
              email: _emailCtrl.text,
              password: _passCtrl.text,
              about: _aboutCtrl.text,
              howWeTeach: _teachCtrl.text,
              whatWeOffer: _offerCtrl.text,
              availableDays: _days.toList(),
              programs: programs,
            )
          : await _auth.registerWithFiles(fields: fields, files: files);
      if (!mounted) return;
      if (res['success'] == true) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Registration submitted'),
            content: Text(
              res['message']?.toString() ??
                  'Wait for admin approval, then sign in with your centre email.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
                  );
                },
                child: const Text('Go to sign in'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _busy = false;
          _error = res['error']?.toString() ?? 'Registration failed';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsCentreRegisterScreen.navy,
        title: const Text('Register Centre', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: List.generate(3, (i) {
                final active = i == _step;
                final done = i < _step;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                    height: 6,
                    decoration: BoxDecoration(
                      color: active || done
                          ? MartialArtsCentreRegisterScreen.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_step == 0) ...[
                  const Text('Step 1 — Identity & contact', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _field(_nameCtrl, 'Centre name'),
                  _field(_locationCtrl, 'Location (city, area)'),
                  _field(_phoneCtrl, 'Phone (10 digits)', keyboard: TextInputType.phone),
                  _field(_emailCtrl, 'Email', keyboard: TextInputType.emailAddress),
                  _field(_passCtrl, 'Password', obscure: true),
                  const SizedBox(height: 8),
                  const Text('Working days', style: TextStyle(fontWeight: FontWeight.w600)),
                  Wrap(
                    spacing: 8,
                    children: _weekDays.map((d) {
                      final sel = _days.contains(d);
                      return FilterChip(
                        label: Text(d.substring(0, 3)),
                        selected: sel,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _days.add(d);
                          } else {
                            _days.remove(d);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ] else if (_step == 1) ...[
                  const Text('Step 2 — About', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _field(_aboutCtrl, 'About centre', maxLines: 3),
                  _field(_teachCtrl, 'How we teach', maxLines: 3),
                  _field(_offerCtrl, 'Facilities & offers', maxLines: 3),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) setState(() => _profilePhoto = f);
                    },
                    icon: const Icon(Icons.photo),
                    label: Text(_profilePhoto == null ? 'Profile photo' : 'Profile photo selected'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) setState(() => _certificate = f);
                    },
                    icon: const Icon(Icons.verified),
                    label: Text(_certificate == null ? 'Trainer certificate' : 'Certificate selected'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final imgs = await _picker.pickMultiImage();
                      if (imgs.isNotEmpty) setState(() => _gallery.addAll(imgs));
                    },
                    icon: const Icon(Icons.collections),
                    label: Text(_gallery.isEmpty ? 'Gallery photos' : '${_gallery.length} gallery photo(s)'),
                  ),
                ] else ...[
                  const Text('Step 3 — Programs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  ..._programs.asMap().entries.map((e) => _programCard(e.key, e.value)),
                  TextButton.icon(
                    onPressed: () => setState(() => _programs.add(_ProgramRow())),
                    icon: const Icon(Icons.add),
                    label: const Text('Add program'),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy ? null : () => setState(() { _step--; _error = null; }),
                          child: const Text('Back'),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _busy
                            ? null
                            : () {
                                if (_step < 2) {
                                  if (_validateStep(_step)) {
                                    setState(() { _step++; _error = null; });
                                  }
                                } else {
                                  _submit();
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: MartialArtsCentreRegisterScreen.primary,
                        ),
                        child: _busy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text(_step < 2 ? 'Continue' : 'Submit registration'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _programCard(int index, _ProgramRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _field(row.nameCtrl, 'Program name (e.g. Karate)')),
              if (_programs.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => setState(() {
                    row.dispose();
                    _programs.removeAt(index);
                  }),
                ),
            ],
          ),
          _field(row.costCtrl, 'Monthly cost (₹)', keyboard: TextInputType.number),
          const Text('Time slots', style: TextStyle(fontWeight: FontWeight.w600)),
          ...row.slots.asMap().entries.map((e) {
            return Row(
              children: [
                Expanded(child: _field(e.value, 'e.g. 5PM-6PM')),
                if (row.slots.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() {
                      e.value.dispose();
                      row.slots.removeAt(e.key);
                    }),
                  ),
              ],
            );
          }),
          TextButton.icon(
            onPressed: () => setState(() => row.slots.add(TextEditingController())),
            icon: const Icon(Icons.add),
            label: const Text('Add slot'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    TextInputType? keyboard,
    int maxLines = 1,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: maxLines,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
