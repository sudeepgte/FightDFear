import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/centre_auth_service.dart';
import '../widgets/registration_form_kit.dart';
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
  final trainerCtrl = TextEditingController();
  final costCtrl = TextEditingController(text: '0');
  final capacityCtrl = TextEditingController(text: '30');
  final descCtrl = TextEditingController();
  String duration = RegOptions.programDurations.first;
  String ageGroup = RegOptions.ageGroups.last;
  String difficulty = RegOptions.difficultyLevels.first;
  String mode = RegOptions.programModes[1];
  final slots = <TextEditingController>[];

  void dispose() {
    nameCtrl.dispose();
    trainerCtrl.dispose();
    costCtrl.dispose();
    capacityCtrl.dispose();
    descCtrl.dispose();
    for (final s in slots) {
      s.dispose();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': nameCtrl.text.trim(),
      'trainer': trainerCtrl.text.trim(),
      'cost': double.tryParse(costCtrl.text.trim()) ?? 0,
      'maxCapacity': int.tryParse(capacityCtrl.text.trim()) ?? 30,
      'description': descCtrl.text.trim(),
      'duration': duration,
      'ageGroup': ageGroup,
      'difficulty': difficulty,
      'mode': mode,
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
  bool _terms = false;
  String? _error;
  String _centreType = RegOptions.centreTypes.last;

  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _hoursStart = TextEditingController(text: '06:00');
  final _hoursEnd = TextEditingController(text: '21:00');
  final _aboutCtrl = TextEditingController();
  final _teachCtrl = TextEditingController();
  final _offerCtrl = TextEditingController();

  final Set<String> _days = {};
  final List<_ProgramRow> _programs = [_ProgramRow()];
  XFile? _certificate;
  XFile? _profilePhoto;
  XFile? _logo;
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
    for (final c in [
      _nameCtrl, _contactCtrl, _locationCtrl, _phoneCtrl, _altPhoneCtrl,
      _emailCtrl, _passCtrl, _confirmCtrl, _hoursStart, _hoursEnd,
      _aboutCtrl, _teachCtrl, _offerCtrl,
    ]) {
      c.dispose();
    }
    for (final p in _programs) {
      p.dispose();
    }
    super.dispose();
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0:
        if (_nameCtrl.text.trim().isEmpty ||
            _contactCtrl.text.trim().isEmpty ||
            _locationCtrl.text.trim().isEmpty ||
            !RegValidators.isPhone10(_phoneCtrl.text) ||
            !RegValidators.isEmail(_emailCtrl.text) ||
            !RegValidators.isPasswordStrong(_passCtrl.text) ||
            _passCtrl.text != _confirmCtrl.text) {
          setState(() => _error =
              'Fill mandatory fields. Phone = 10 digits, valid email, matching strong password (min 6 + number + symbol).');
          return false;
        }
        if (!_terms) {
          setState(() => _error = 'Please accept Terms & Conditions.');
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
      final about = [
        _aboutCtrl.text.trim(),
        'Centre type: $_centreType',
        'Contact person: ${_contactCtrl.text.trim()}',
        if (_altPhoneCtrl.text.trim().isNotEmpty) 'Alt phone: ${_altPhoneCtrl.text.trim()}',
        'Hours: ${_hoursStart.text.trim()} – ${_hoursEnd.text.trim()}',
      ].join('\n');
      final fields = <String, String>{
        'name': _nameCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'phoneNumber': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim().toLowerCase(),
        'password': _passCtrl.text,
        'about': about,
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
      if (_logo != null) {
        files.add(await http.MultipartFile.fromPath('logo', _logo!.path));
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
              about: about,
              howWeTeach: _teachCtrl.text,
              whatWeOffer: _offerCtrl.text,
              availableDays: _days.toList(),
              programs: programs,
            )
          : await _auth.registerWithFiles(fields: fields, files: files);
      if (!mounted) return;
      if (res['success'] == true) {
        await showRegistrationSuccessDialog(
          context,
          message:
              'Registration submitted successfully! Your centre details are under verification. You\'ll be notified once approved.',
          onDone: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
            );
          },
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
        title: Text('Register Centre · Step ${_step + 1} of 3', style: const TextStyle(fontWeight: FontWeight.w700)),
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
                  _field(_nameCtrl, 'Centre name *'),
                  DropdownButtonFormField<String>(
                    value: _centreType,
                    decoration: const InputDecoration(labelText: 'Centre type *', border: OutlineInputBorder()),
                    items: RegOptions.centreTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _centreType = v ?? _centreType),
                  ),
                  const SizedBox(height: 10),
                  _field(_contactCtrl, 'Contact person name *'),
                  _field(_locationCtrl, 'Google Maps / location *'),
                  _field(_phoneCtrl, 'Phone *', keyboard: TextInputType.phone, digits: 10),
                  _field(_altPhoneCtrl, 'Alternate mobile', keyboard: TextInputType.phone, digits: 10),
                  _field(_emailCtrl, 'Email *', keyboard: TextInputType.emailAddress),
                  FileUploadTile(
                    label: 'Centre logo',
                    fileName: _logo?.name,
                    onPick: () async {
                      final f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) setState(() => _logo = f);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(child: _field(_hoursStart, 'Working hours start')),
                      const SizedBox(width: 8),
                      Expanded(child: _field(_hoursEnd, 'Working hours end')),
                    ],
                  ),
                  ObscurePasswordField(
                    controller: _passCtrl,
                    label: 'Password *',
                    showStrength: true,
                    onChanged: (_) => setState(() {}),
                  ),
                  ObscurePasswordField(controller: _confirmCtrl, label: 'Confirm password *'),
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
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _terms,
                    onChanged: (v) => setState(() => _terms = v ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('I agree to the Terms & Conditions', style: TextStyle(fontSize: 13)),
                  ),
                ] else if (_step == 1) ...[
                  const Text('Step 2 — About', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  _field(_aboutCtrl, 'About centre *', maxLines: 4, maxLength: 500),
                  _field(_teachCtrl, 'How we teach *', maxLines: 4, maxLength: 500),
                  _field(_offerCtrl, 'Facilities & offers *', maxLines: 5, maxLength: 800),
                  const Text('Uploads (JPG/PNG/PDF up to 5 MB)', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  FileUploadTile(
                    label: 'Profile photo',
                    fileName: _profilePhoto?.name,
                    onPick: () async {
                      final f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) {
                        setState(() => _profilePhoto = f);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Uploaded ${f.name}')),
                        );
                      }
                    },
                  ),
                  FileUploadTile(
                    label: 'Trainer certificate',
                    fileName: _certificate?.name,
                    onPick: () async {
                      final f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) {
                        setState(() => _certificate = f);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Uploaded ${f.name}')),
                        );
                      }
                    },
                  ),
                  FileUploadTile(
                    label: 'Gallery photos',
                    fileName: _gallery.isEmpty ? null : '${_gallery.length} photo(s) selected',
                    optional: true,
                    onPick: () async {
                      final imgs = await _picker.pickMultiImage();
                      if (imgs.isNotEmpty) {
                        setState(() => _gallery.addAll(imgs));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added ${imgs.length} gallery image(s)')),
                          );
                        }
                      }
                    },
                  ),
                  if (_gallery.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: _gallery
                          .map((g) => Chip(
                                avatar: const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                label: Text(g.name, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
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
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Preview before submit', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          ..._programs.where((p) => p.nameCtrl.text.trim().isNotEmpty).map(
                                (p) => Text('• ${p.nameCtrl.text.trim()} · ${p.mode} · ${p.difficulty} · ₹${p.costCtrl.text}'),
                              ),
                        ],
                      ),
                    ),
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
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _busy
                                ? null
                                : () => setState(() {
                                      _step--;
                                      _error = null;
                                    }),
                            child: const Text('Back'),
                          ),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _busy
                              ? null
                              : () {
                                  if (_step < 2) {
                                    if (_validateStep(_step)) {
                                      setState(() {
                                        _step++;
                                        _error = null;
                                      });
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
          _field(row.trainerCtrl, 'Trainer name'),
          _field(row.descCtrl, 'Program description (optional)', maxLines: 2),
          _field(row.costCtrl, 'Monthly cost (₹)', keyboard: TextInputType.number),
          _field(row.capacityCtrl, 'Maximum capacity', keyboard: TextInputType.number),
          DropdownButtonFormField<String>(
            value: row.duration,
            decoration: const InputDecoration(labelText: 'Duration', border: OutlineInputBorder()),
            items: RegOptions.programDurations.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => row.duration = v ?? row.duration),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: row.ageGroup,
            decoration: const InputDecoration(labelText: 'Age group', border: OutlineInputBorder()),
            items: RegOptions.ageGroups.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => row.ageGroup = v ?? row.ageGroup),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: row.difficulty,
            decoration: const InputDecoration(labelText: 'Difficulty', border: OutlineInputBorder()),
            items: RegOptions.difficultyLevels.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => row.difficulty = v ?? row.difficulty),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: row.mode,
            decoration: const InputDecoration(labelText: 'Mode', border: OutlineInputBorder()),
            items: RegOptions.programModes.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (v) => setState(() => row.mode = v ?? row.mode),
          ),
          const SizedBox(height: 8),
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
    int? maxLength,
    int? digits,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: [
          if (digits != null) FilteringTextInputFormatter.digitsOnly,
          if (digits != null) LengthLimitingTextInputFormatter(digits),
        ],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
