import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/glow_catalog.dart';
import '../../config/maps_config.dart';
import '../../services/auth_state.dart';
import '../../services/glow_provider_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

class GlowSalonProfileCompletionScreen extends StatefulWidget {
  const GlowSalonProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<GlowSalonProfileCompletionScreen> createState() =>
      _GlowSalonProfileCompletionScreenState();
}

class _GlowSalonProfileCompletionScreenState extends State<GlowSalonProfileCompletionScreen> {
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _year = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _stateOther = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  final _bio = TextEditingController();
  final _hygiene = TextEditingController();
  final _upi = TextEditingController();
  final _bank = TextEditingController();
  final _serviceName = TextEditingController();
  final _servicePrice = TextEditingController(text: '499');

  String? _salonType;
  String? _designation;
  String? _state;
  String? _serviceCategory;
  String _serviceMode = 'SALON';
  int _duration = 30;
  int _buffer = 10;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;

  final Set<String> _categories = {};
  final Set<String> _audience = {};
  final Set<String> _facilities = {};
  final Set<String> _days = {};
  final Set<String> _blockedDates = {};
  bool _doorService = false;
  bool _femaleStaff = false;
  bool _hasFirstService = false;
  double? _lat;
  double? _lng;

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingGallery = false;
  String? _error;
  Map<String, dynamic> _profile = {};

  GlowProviderAuthService get _svc => GlowProviderAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _serviceCategory = GlowCatalog.categories.first.code;
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _name, _contact, _phone, _whatsapp, _year, _address, _city, _stateOther,
      _pincode, _mapLocation, _bio, _hygiene, _upi, _bank, _serviceName, _servicePrice,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await _svc.salonProfile();
    if (!mounted) return;
    if (res['success'] == true) {
      _applyProfile(Map<String, dynamic>.from(res));
      setState(() => _loading = false);
    } else {
      setState(() {
        _loading = false;
        _error = res['error']?.toString() ?? 'Failed to load profile';
      });
    }
  }

  String _pickOrOther(String raw, List<String> options, TextEditingController other) {
    final v = raw.trim();
    if (v.isEmpty) {
      other.clear();
      return '';
    }
    if (options.contains(v)) {
      other.clear();
      return v;
    }
    other.text = v;
    return 'Other';
  }

  void _applyProfile(Map<String, dynamic> p) {
    _profile = p;
    _name.text = p['name']?.toString() ?? '';
    _contact.text = p['contactPerson']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _year.text = p['establishedYear']?.toString() ?? '';
    _salonType = (p['salonType']?.toString().isNotEmpty == true) ? p['salonType'].toString() : null;
    _designation = (p['designation']?.toString().isNotEmpty == true) ? p['designation'].toString() : null;
    _address.text = p['address']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state = _pickOrOther(p['state']?.toString() ?? '', GlowCatalog.indianStates, _stateOther);
    if ((_state ?? '').isEmpty) _state = null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');
    if (_lat != null && _lng != null) {
      _mapLocation.text = 'https://maps.google.com/?q=$_lat,$_lng';
    }
    _categories
      ..clear()
      ..addAll(GlowCatalog.splitCsv(p['categoriesOffered']));
    _audience
      ..clear()
      ..addAll(GlowCatalog.splitCsv(p['audience']));
    _facilities
      ..clear()
      ..addAll(GlowCatalog.splitCsv(p['facilities']));
    _days
      ..clear()
      ..addAll(GlowCatalog.splitCsv(p['openDays']).map((e) => e.toUpperCase()));
    _blockedDates
      ..clear()
      ..addAll(GlowCatalog.splitCsv(p['blockedDates']));
    _doorService = p['doorService'] == true;
    _femaleStaff = p['femaleStaff'] == true;
    _openTime = GlowCatalog.parseTime(p['openTime']?.toString());
    _closeTime = GlowCatalog.parseTime(p['closeTime']?.toString());
    _breakStart = GlowCatalog.parseTime(p['breakStart']?.toString());
    _breakEnd = GlowCatalog.parseTime(p['breakEnd']?.toString());
    _bio.text = p['bio']?.toString() ?? '';
    _hygiene.text = p['hygieneNotes']?.toString() ?? '';
    _upi.text = p['upiId']?.toString() ?? '';
    _bank.text = p['bankDetails']?.toString() ?? '';
    final firstName = p['firstServiceName']?.toString() ?? '';
    _hasFirstService = firstName.isNotEmpty;
    if (firstName.isNotEmpty) _serviceName.text = firstName;
    if (p['firstServiceCategory'] != null) {
      _serviceCategory = GlowCatalog.byCode(p['firstServiceCategory']?.toString())?.code ?? _serviceCategory;
    }
    if (p['firstServiceDuration'] is num) _duration = (p['firstServiceDuration'] as num).toInt();
    if (p['firstServiceBuffer'] is num) _buffer = (p['firstServiceBuffer'] as num).toInt();
    if (p['firstServicePrice'] != null) _servicePrice.text = '${p['firstServicePrice']}';
    if (p['firstServiceMode']?.toString().isNotEmpty == true) {
      _serviceMode = p['firstServiceMode'].toString().toUpperCase();
    }
  }

  String get _resolvedState =>
      _state == 'Other' ? _stateOther.text.trim() : (_state ?? '').trim();

  Map<String, dynamic> _profileBody() => {
        'name': _name.text.trim(),
        'salonType': _salonType,
        'contactPerson': _contact.text.trim(),
        'designation': _designation,
        'phone': _phone.text.trim(),
        'whatsappNumber': _whatsapp.text.trim(),
        'establishedYear': int.tryParse(_year.text.trim()),
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'state': _resolvedState,
        'pincode': _pincode.text.trim(),
        if (_lat != null) 'latitude': _lat,
        if (_lng != null) 'longitude': _lng,
        'categoriesOffered': _categories.toList(),
        'audience': _audience.join(','),
        'doorService': _doorService,
        'femaleStaff': _femaleStaff,
        'facilities': _facilities.toList(),
        'openDays': _days.toList(),
        'openTime': _openTime == null ? '' : GlowCatalog.formatTime(_openTime!),
        'closeTime': _closeTime == null ? '' : GlowCatalog.formatTime(_closeTime!),
        'breakStart': _breakStart == null ? '' : GlowCatalog.formatTime(_breakStart!),
        'breakEnd': _breakEnd == null ? '' : GlowCatalog.formatTime(_breakEnd!),
        'blockedDates': _blockedDates.join(','),
        'bio': _bio.text.trim(),
        'hygieneNotes': _hygiene.text.trim(),
        'upiId': _upi.text.trim(),
        'bankDetails': _bank.text.trim(),
        if (!_hasFirstService && _serviceName.text.trim().isNotEmpty) ...{
          'firstServiceName': _serviceName.text.trim(),
          'firstServiceCategory': _serviceCategory,
          'firstServiceDuration': _duration,
          'firstServiceBuffer': _buffer,
          'firstServicePrice': double.tryParse(_servicePrice.text.trim()) ?? GlowCatalog.defaultPrice(_serviceCategory ?? 'HAIR'),
          'firstServiceMode': _serviceMode,
        },
      };

  String? _validate({bool forSubmit = false}) {
    if (_name.text.trim().isEmpty) return '1.1 Salon name is required';
    if ((_salonType ?? '').isEmpty) return '1.2 Salon type is required';
    if (_contact.text.trim().isEmpty) return '1.3 Owner / manager is required';
    if (!RegExp(r'^\d{10}$').hasMatch(_phone.text.trim())) return '1.5 Official phone must be 10 digits';
    if (_address.text.trim().isEmpty) return '2.1 Landmark / address is required';
    if (_city.text.trim().isEmpty) return '2.3 City is required';
    if (_resolvedState.isEmpty) return '2.4 State is required';
    if (!RegExp(r'^\d{6}$').hasMatch(_pincode.text.trim())) return '2.5 Pincode must be 6 digits';
    if (_categories.isEmpty) return '3.1 Select at least one category';
    if (_audience.isEmpty) return '4.1 Select who we serve';
    if (_days.isEmpty) return '6.1 Select open days';
    if (_openTime == null) return '6.2 Open time is required';
    if (_closeTime == null) return '6.3 Close time is required';
    if (_bio.text.trim().isEmpty) return '7.1 About the salon is required';
    if (forSubmit && !_hasFirstService && _serviceName.text.trim().isEmpty) {
      return '8. Add at least one service';
    }
    return null;
  }

  Future<void> _saveProfile() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Saving…',
        doneLabel: 'Saved',
        action: () async {
          final res = await _svc.updateSalonProfile(_profileBody());
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Failed to save profile');
          }
          _applyProfile(Map<String, dynamic>.from(res));
        },
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    final err = _validate(forSubmit: true);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ActionFeedback.run(
        context,
        loadingLabel: 'Submitting…',
        doneLabel: 'Submitted',
        action: () async {
          final saveRes = await _svc.updateSalonProfile(_profileBody());
          if (saveRes['success'] == true) _applyProfile(Map<String, dynamic>.from(saveRes));
          if (_profile['canSubmitForVerification'] != true) {
            throw Exception('Complete all mandatory fields before submitting');
          }
          final res = await _svc.submitSalonVerification();
          if (res['success'] != true) {
            throw Exception(res['error']?.toString() ?? 'Submit failed');
          }
          await _load();
        },
      );
      if (!mounted) return;
      await showVerificationSubmittedSheet(context);
      if (!mounted) return;
      if (widget.onFinished != null) {
        widget.onFinished!(context);
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickClock(void Function(TimeOfDay t) apply, TimeOfDay? current) async {
    final picked = await showTimePicker(context: context, initialTime: current ?? const TimeOfDay(hour: 10, minute: 0));
    if (picked != null) setState(() => apply(picked));
  }

  Future<void> _useCurrentLocation() async {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      if (mounted) setState(() => _error = 'Location permission is needed to pin the salon');
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
      _mapLocation.text = 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
    });
  }

  Future<void> _addBlockedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    final key = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    setState(() => _blockedDates.add(key));
  }

  Future<void> _uploadFile({required String kind}) async {
    String? path;
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
      path = img?.path;
    } catch (_) {}
    path ??= (await FilePicker.platform.pickFiles(type: FileType.image))?.files.single.path;
    if (path == null || path.isEmpty) return;
    setState(() {
      if (kind == 'photo') _uploadingPhoto = true;
      if (kind == 'gallery') _uploadingGallery = true;
    });
    try {
      final res = await _svc.uploadPhotos(
        profilePath: kind == 'photo' ? path : null,
        galleryPath: kind == 'gallery' ? path : null,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        await _load();
      } else {
        setState(() => _error = res['error']?.toString() ?? 'Upload failed');
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingPhoto = false;
          _uploadingGallery = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num) ? (_profile['profileCompletionPct'] as num).toDouble() : 0.0;
    final statusLabel = _profile['partnerProfileStatusLabel']?.toString() ?? 'Pending';
    final missing = GlowCatalog.splitCsv(_profile['missingItems']);
    final guidance = _profile['nextStepGuidance']?.toString();
    final canSubmit = _profile['canSubmitForVerification'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowSalonProfileCompletionScreen.navy,
        title: const Text('Complete Salon Profile', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                ProfileCompletionCard(
                  percent: pct,
                  statusLabel: statusLabel,
                  hint: ProfileCompletionCard.hintFromMissing(missing, guidance: guidance),
                  actionLabel: '',
                  onAction: () {},
                  showActionButton: false,
                  trailing: missing.isEmpty
                      ? null
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: missing
                              .map((m) => Chip(
                                    label: Text(m, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: const Color(0xFFFFF7ED),
                                  ))
                              .toList(),
                        ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: (_submitting || !canSubmit) ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: GlowSalonProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _submitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(canSubmit ? 'Submit for Verification' : 'Complete required items to submit'),
                ),
                const SizedBox(height: 16),
                _section('1', 'Salon identity', [
                  _field(_name, '1.1', 'Salon name', required: true),
                  _dropdown(
                    number: '1.2',
                    label: 'Salon type',
                    value: _salonType,
                    options: GlowCatalog.salonTypes,
                    required: true,
                    onChanged: (v) => setState(() => _salonType = v),
                  ),
                  _field(_contact, '1.3', 'Owner / manager', required: true),
                  _dropdown(
                    number: '1.4',
                    label: 'Designation',
                    value: _designation,
                    options: GlowCatalog.designations,
                    onChanged: (v) => setState(() => _designation = v),
                  ),
                  _field(_phone, '1.5', 'Official phone', required: true, keyboardType: TextInputType.phone, maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_whatsapp, '1.6', 'WhatsApp', keyboardType: TextInputType.phone, maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_year, '1.7', 'Year started', keyboardType: TextInputType.number, maxLength: 4, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                ]),
                _section('2', 'Location', [
                  _field(_address, '2.1', 'Landmark / address', required: true),
                  _field(_city, '2.3', 'City', required: true),
                  _dropdown(number: '2.4', label: 'State', value: _state, options: GlowCatalog.indianStates, required: true, onChanged: (v) => setState(() => _state = v)),
                  if (_state == 'Other') _field(_stateOther, '2.4', 'Enter state', required: true),
                  _field(_pincode, '2.5', 'Pincode', required: true, keyboardType: TextInputType.number, maxLength: 6, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_mapLocation, '2.6', 'Google Maps location', hint: 'Paste Maps link (optional)'),
                  const SizedBox(height: 8),
                  const Text('2.7 Pin salon on map', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(onPressed: _useCurrentLocation, icon: const Icon(Icons.my_location), label: const Text('Use current location')),
                  if (_lat != null && _lng != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 8),
                      child: Text('Pinned: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ),
                  SizedBox(
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        key: ValueKey('${_lat}_$_lng'),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_lat ?? MapsConfig.defaultLat, _lng ?? MapsConfig.defaultLng),
                          zoom: 14,
                        ),
                        markers: {
                          if (_lat != null && _lng != null)
                            Marker(markerId: const MarkerId('salon'), position: LatLng(_lat!, _lng!)),
                        },
                        onTap: (pos) => setState(() {
                          _lat = pos.latitude;
                          _lng = pos.longitude;
                          _mapLocation.text = 'https://maps.google.com/?q=${pos.latitude},${pos.longitude}';
                        }),
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        },
                      ),
                    ),
                  ),
                ]),
                _section('3', 'Categories', [
                  const Text('3.1 Services you offer *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: GlowCatalog.categories.map((c) {
                      final on = _categories.contains(c.code);
                      return FilterChip(
                        avatar: Icon(c.icon, size: 16),
                        label: Text(c.label),
                        selected: on,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _categories.add(c.code);
                          } else {
                            _categories.remove(c.code);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ]),
                _section('4', 'Who we serve', [
                  const Text('4.1 Audience *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(GlowCatalog.audiences, _audience),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.2 Door / home service'),
                    value: _doorService,
                    onChanged: (v) => setState(() => _doorService = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.3 Female staff available'),
                    value: _femaleStaff,
                    onChanged: (v) => setState(() => _femaleStaff = v),
                  ),
                ]),
                _section('5', 'Facilities', [
                  const Text('5.1 Amenities', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(GlowCatalog.facilities, _facilities),
                ]),
                _section('6', 'Hours & calendar', [
                  const Text('6.1 Open days *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: GlowCatalog.days.map((d) {
                      final on = _days.contains(d);
                      return FilterChip(
                        label: Text(d.substring(0, 3)),
                        selected: on,
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
                  const SizedBox(height: 10),
                  _timeTile('6.2 Open time *', _openTime, (t) => _openTime = t),
                  _timeTile('6.3 Close time *', _closeTime, (t) => _closeTime = t),
                  _timeTile('6.4 Break start', _breakStart, (t) => _breakStart = t),
                  _timeTile('6.5 Break end', _breakEnd, (t) => _breakEnd = t),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(onPressed: _addBlockedDate, icon: const Icon(Icons.event_busy), label: const Text('6.6 Add leave / blocked date')),
                  if (_blockedDates.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: _blockedDates
                          .map((d) => InputChip(label: Text(d), onDeleted: () => setState(() => _blockedDates.remove(d))))
                          .toList(),
                    ),
                ]),
                _section('7', 'About the salon', [
                  _field(_bio, '7.1', 'About', required: true, maxLines: 4),
                  _field(_hygiene, '7.2', 'Hygiene & safety notes', maxLines: 2),
                ]),
                _section('8', 'First service', [
                  Text(
                    _hasFirstService
                        ? 'You already have a service. Add more from the Services tab after approval.'
                        : 'Add at least one service to submit.',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  if (!_hasFirstService) ...[
                    const SizedBox(height: 10),
                    _field(_serviceName, '8.1', 'Service name', required: true),
                    _dropdown(
                      number: '8.2',
                      label: 'Category',
                      value: GlowCatalog.labelFor(_serviceCategory),
                      options: GlowCatalog.categories.map((c) => c.label).toList(),
                      required: true,
                      onChanged: (v) {
                        final match = GlowCatalog.categories.where((c) => c.label == v);
                        setState(() {
                          _serviceCategory = match.isEmpty ? 'HAIR' : match.first.code;
                          if (_serviceName.text.trim().isEmpty) {
                            _servicePrice.text = '${GlowCatalog.defaultPrice(_serviceCategory!)}';
                            _duration = GlowCatalog.defaultDuration(_serviceCategory!);
                          }
                        });
                      },
                    ),
                    _dropdown(
                      number: '8.3',
                      label: 'Duration (minutes)',
                      value: '$_duration',
                      options: GlowCatalog.durations.map((e) => '$e').toList(),
                      required: true,
                      onChanged: (v) => setState(() => _duration = int.tryParse(v ?? '30') ?? 30),
                    ),
                    _dropdown(
                      number: '8.4',
                      label: 'Buffer (minutes)',
                      value: '$_buffer',
                      options: GlowCatalog.buffers.map((e) => '$e').toList(),
                      onChanged: (v) => setState(() => _buffer = int.tryParse(v ?? '10') ?? 10),
                    ),
                    _field(_servicePrice, '8.5', 'Price (₹)', required: true, keyboardType: TextInputType.number),
                    _dropdown(
                      number: '8.6',
                      label: 'Mode',
                      value: _serviceMode,
                      options: GlowCatalog.serviceModes,
                      required: true,
                      onChanged: (v) => setState(() => _serviceMode = v ?? 'SALON'),
                    ),
                  ],
                ]),
                _section('9', 'Payout', [
                  _field(_upi, '9.1', 'UPI ID', hint: 'name@upi'),
                  _field(_bank, '9.2', 'Bank details', hint: 'Account name, number, IFSC', maxLines: 2),
                  const Text(
                    'UPI is needed to withdraw. Earnings stay in your wallet until you request payout from Finance.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                ]),
                _section('10', 'Documents (optional)', [
                  const Text('Uploads are optional. You can add them later.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  const SizedBox(height: 10),
                  _uploadTile('10.1 Profile photo', _profile['profileImageUrl']?.toString(), _uploadingPhoto, () => _uploadFile(kind: 'photo')),
                ]),
                _section('11', 'Salon photos (optional)', [
                  const Text('Interior, chair, and storefront photos help clients choose you.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  const SizedBox(height: 10),
                  _uploadTile(
                    '11.1 Gallery photo',
                    (_profile['galleryPhotos'] is List && (_profile['galleryPhotos'] as List).isNotEmpty)
                        ? (_profile['galleryPhotos'] as List).last.toString()
                        : null,
                    _uploadingGallery,
                    () => _uploadFile(kind: 'gallery'),
                  ),
                ]),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      : const Text('Save Profile'),
                ),
              ],
            ),
    );
  }

  Widget _section(String number, String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$number. $title', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String number,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
    bool required = false,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          hintText: hint,
          counterText: maxLength != null ? '' : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String number,
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool required = false,
  }) {
    final items = [...options];
    if (value != null && value.isNotEmpty && !items.contains(value)) items.add(value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        initialValue: value != null && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: '$number $label${required ? ' *' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _chips(List<String> options, Set<String> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final on = selected.contains(item);
        return FilterChip(
          label: Text(item),
          selected: on,
          onSelected: (v) => setState(() {
            if (v) {
              selected.add(item);
            } else {
              selected.remove(item);
            }
          }),
        );
      }).toList(),
    );
  }

  Widget _timeTile(String label, TimeOfDay? value, void Function(TimeOfDay t) apply) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        subtitle: Text(value == null ? 'Tap to pick' : GlowCatalog.formatTime(value)),
        trailing: const Icon(Icons.schedule),
        onTap: () => _pickClock(apply, value),
      ),
    );
  }

  Widget _uploadTile(String title, String? path, bool loading, VoidCallback onTap) {
    final uploaded = path != null && path.trim().isNotEmpty;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: loading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(uploaded ? Icons.check_circle : Icons.upload_file, color: ModuleTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(uploaded ? 'Uploaded' : 'JPG or PNG · optional'),
      trailing: const Icon(Icons.chevron_right),
      onTap: loading ? null : onTap,
    );
  }
}
