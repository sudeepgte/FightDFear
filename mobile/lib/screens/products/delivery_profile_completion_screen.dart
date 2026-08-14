import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/delivery_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/delivery_partner_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/profile_completion_actions.dart';
import '../../widgets/profile_location_picker.dart';
import '../../widgets/ux_feedback.dart';

class DeliveryProfileCompletionScreen extends StatefulWidget {
  const DeliveryProfileCompletionScreen({super.key, this.onFinished});

  final void Function(BuildContext context)? onFinished;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<DeliveryProfileCompletionScreen> createState() =>
      _DeliveryProfileCompletionScreenState();
}

class _DeliveryProfileCompletionScreenState
    extends State<DeliveryProfileCompletionScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _years = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _stateOther = TextEditingController();
  final _pincode = TextEditingController();
  final _mapLocation = TextEditingController();
  final _bio = TextEditingController();
  final _upi = TextEditingController();
  final _bank = TextEditingController();
  final _license = TextEditingController();

  String? _vehicle;
  String? _state;
  int _duration = 5;
  TimeOfDay? _openTime;
  TimeOfDay? _closeTime;
  TimeOfDay? _breakStart;
  TimeOfDay? _breakEnd;

  final Set<String> _categories = {};
  final Set<String> _audience = {};
  final Set<String> _facilities = {};
  final Set<String> _days = {};
  final Set<String> _blockedDates = {};
  bool _doorService = true;
  double? _lat;
  double? _lng;

  bool _loading = true;
  bool _saving = false;
  bool _submitting = false;
  bool _uploadingPhoto = false;
  bool _uploadingGallery = false;
  String? _error;
  Map<String, dynamic> _profile = {};

  DeliveryPartnerAuthService get _svc =>
      DeliveryPartnerAuthService(context.read<AuthState>().api);

  @override
  void initState() {
    super.initState();
    _vehicle = DeliveryCatalog.vehicles.first;
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _name, _phone, _whatsapp, _years, _address, _city, _stateOther,
      _pincode, _mapLocation, _bio, _upi, _bank, _license,
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
    final res = await _svc.profile();
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
    _name.text = p['fullName']?.toString() ?? '';
    _phone.text = p['phone']?.toString() ?? '';
    _whatsapp.text = p['whatsappNumber']?.toString() ?? '';
    _years.text = p['yearsExperience']?.toString() ?? '';
    _license.text = p['licenseNumber']?.toString() ?? '';
    _vehicle = (p['vehicleType']?.toString().isNotEmpty == true) ? p['vehicleType'].toString() : DeliveryCatalog.vehicles.first;
    _address.text = p['address']?.toString() ?? '';
    _city.text = p['city']?.toString() ?? '';
    _state = _pickOrOther(p['state']?.toString() ?? '', DeliveryCatalog.indianStates, _stateOther);
    if ((_state ?? '').isEmpty) _state = null;
    _pincode.text = p['pincode']?.toString() ?? '';
    _lat = p['latitude'] is num ? (p['latitude'] as num).toDouble() : double.tryParse('${p['latitude'] ?? ''}');
    _lng = p['longitude'] is num ? (p['longitude'] as num).toDouble() : double.tryParse('${p['longitude'] ?? ''}');
    if (_lat != null && _lng != null) {
      _mapLocation.text = 'https://maps.google.com/?q=$_lat,$_lng';
    }
    _categories
      ..clear()
      ..addAll(DeliveryCatalog.splitCsv(p['serviceAreas'] ?? p['serviceArea'] ?? p['categoriesOffered']));
    _facilities
      ..clear()
      ..addAll(DeliveryCatalog.splitCsv(p['facilities']));
    _audience
      ..clear()
      ..addAll(DeliveryCatalog.splitCsv(p['capabilities'] ?? p['audience']));
    _days
      ..clear()
      ..addAll(DeliveryCatalog.splitCsv(p['openDays']));
    _blockedDates
      ..clear()
      ..addAll(DeliveryCatalog.splitCsv(p['blockedDates']));
    _doorService = p['doorService'] == true;
    _openTime = DeliveryCatalog.parseTime(p['openTime']?.toString());
    _closeTime = DeliveryCatalog.parseTime(p['closeTime']?.toString());
    _breakStart = DeliveryCatalog.parseTime(p['breakStart']?.toString());
    _breakEnd = DeliveryCatalog.parseTime(p['breakEnd']?.toString());
    _bio.text = p['bio']?.toString() ?? '';
    _upi.text = p['upiId']?.toString() ?? '';
    _bank.text = p['bankDetails']?.toString() ?? '';
    _duration = p['typicalRadiusKm'] is num ? (p['typicalRadiusKm'] as num).toInt() : 5;
  }

  Map<String, dynamic> _profileBody() {
    final state = _state == 'Other' ? _stateOther.text.trim() : (_state ?? '');
    return {
      'fullName': _name.text.trim(),
      'phone': _phone.text.trim(),
      'vehicleType': _vehicle,
      'licenseNumber': _license.text.trim(),
      'whatsappNumber': _whatsapp.text.trim(),
      'yearsExperience': _years.text.trim(),
      'address': _address.text.trim(),
      'city': _city.text.trim(),
      'state': state,
      'pincode': _pincode.text.trim(),
      'latitude': _lat,
      'longitude': _lng,
      'serviceAreas': _categories.toList(),
      'serviceArea': _categories.join(', '),
      'capabilities': _audience.toList(),
      'doorService': _doorService,
      'facilities': _facilities.toList(),
      'openDays': _days.toList(),
      'openTime': _openTime == null ? null : DeliveryCatalog.formatTime(_openTime!),
      'closeTime': _closeTime == null ? null : DeliveryCatalog.formatTime(_closeTime!),
      'breakStart': _breakStart == null ? null : DeliveryCatalog.formatTime(_breakStart!),
      'breakEnd': _breakEnd == null ? null : DeliveryCatalog.formatTime(_breakEnd!),
      'blockedDates': _blockedDates.toList(),
      'bio': _bio.text.trim(),
      'typicalRadiusKm': _duration,
      'upiId': _upi.text.trim(),
      'bankDetails': _bank.text.trim(),
    };
  }

  String? _validate({bool forSubmit = false}) {
    if (_name.text.trim().isEmpty) return '1.1 Full name is required';
    if (_phone.text.trim().length != 10) return '1.5 Official phone must be 10 digits';
    if (_address.text.trim().isEmpty) return '2.1 Landmark / address is required';
    if (_city.text.trim().isEmpty) return '2.3 City is required';
    if ((_state ?? '').isEmpty) return '2.4 State is required';
    if (_state == 'Other' && _stateOther.text.trim().isEmpty) return '2.4 Enter state';
    if (_pincode.text.trim().length != 6) return '2.5 Pincode must be 6 digits';
    if (_categories.isEmpty && _city.text.trim().isEmpty) return '3.1 Service area is required';
    if (_audience.isEmpty) return '4.1 Who I serve is required';
    if (_days.isEmpty) return '6.1 Open days are required';
    if (_openTime == null) return '6.2 Open time is required';
    if (_closeTime == null) return '6.3 Close time is required';
    if (_bio.text.trim().isEmpty) return '7.1 About is required';
    if ((_vehicle ?? '').isEmpty) return '1.2 Vehicle is required';
    if (_vehicle != 'Cycle' && _license.text.trim().isEmpty) return '1.8 Driving licence number is required';
    if (forSubmit && _profile['canSubmitForVerification'] == false) {
      return _profile['nextStepGuidance']?.toString();
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
          final res = await _svc.updateProfile(_profileBody());
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
          final saveRes = await _svc.updateProfile(_profileBody());
          if (saveRes['success'] == true) _applyProfile(Map<String, dynamic>.from(saveRes));
          if (_profile['canSubmitForVerification'] != true) {
            throw Exception('Complete all mandatory fields before submitting');
          }
          final res = await _svc.submitVerification();
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
    final picked = await showTimePicker(context: context, initialTime: current ?? const TimeOfDay(hour: 9, minute: 0));
    if (picked != null) setState(() => apply(picked));
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


  void _skip() => ProfileCompletionActions.skip(context, widget.onFinished);

  @override
  Widget build(BuildContext context) {
    final pct = (_profile['profileCompletionPct'] is num) ? (_profile['profileCompletionPct'] as num).toDouble() : 0.0;
    final missing = DeliveryCatalog.splitCsv(_profile['missingItems']);
    final guidance = _profile['nextStepGuidance']?.toString();
    final canSubmit = _profile['canSubmitForVerification'] == true;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: DeliveryProfileCompletionScreen.navy,
        title: const Text('Complete Delivery Profile', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700)),
      actions: ProfileCompletionActions.appBar(
        onSkip: _loading ? null : _skip,
        onSave: (_loading || _saving) ? null : _saveProfile,
        saving: _saving,
      ),
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
                  statusLabel: _profile['partnerProfileStatusLabel']?.toString() ?? 'Pending',
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
                    backgroundColor: DeliveryProfileCompletionScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _submitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(canSubmit ? 'Submit for Verification' : 'Complete required items to submit'),
                ),
                const SizedBox(height: 16),
                _section('1', 'Rider identity', [
                  _field(_name, '1.1', 'Full name', required: true),
                  _dropdown(
                    number: '1.2',
                    label: 'Vehicle',
                    value: _vehicle,
                    options: DeliveryCatalog.vehicles,
                    required: true,
                    onChanged: (v) => setState(() => _vehicle = v),
                  ),
                  _field(_license, '1.8', 'Driving licence number', hint: 'Required for Bike / Scooter / Van'),
                  _field(_phone, '1.5', 'Official phone', required: true, keyboardType: TextInputType.phone, maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_whatsapp, '1.6', 'WhatsApp', keyboardType: TextInputType.phone, maxLength: 10, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_years, '1.7', 'Years of experience', keyboardType: TextInputType.number, maxLength: 2, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                ]),
                _section('2', 'Location', [
                  _field(_address, '2.1', 'Landmark / address', required: true),
                  _field(_city, '2.3', 'City', required: true),
                  _dropdown(number: '2.4', label: 'State', value: _state, options: DeliveryCatalog.indianStates, required: true, onChanged: (v) => setState(() => _state = v)),
                  if (_state == 'Other') _field(_stateOther, '2.4', 'Enter state', required: true),
                  _field(_pincode, '2.5', 'Pincode', required: true, keyboardType: TextInputType.number, maxLength: 6, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                  _field(_mapLocation, '2.6', 'Google Maps location', hint: 'Paste Maps link (optional)'),
                  const SizedBox(height: 8),
                  ProfileLocationPicker(
                    lat: _lat,
                    lng: _lng,
                    mapLinkController: _mapLocation,
                    pinLabel: '2.7 Pin base on map',
                    onPinned: (lat, lng) => setState(() {
                      _lat = lat;
                      _lng = lng;
                    }),
                    onError: (msg) => setState(() => _error = msg),
                  ),
                ]),
                _section('3', 'Service areas', [
                  const Text('3.1 Service areas *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['City centre', 'Suburbs', 'Nearby towns', 'Apartments', 'Markets'].map((c) {
                      final on = _categories.contains(c);
                      return FilterChip(
                        label: Text(c),
                        selected: on,
                        onSelected: (v) => setState(() {
                          if (v) {
                            _categories.add(c);
                          } else {
                            _categories.remove(c);
                          }
                        }),
                      );
                    }).toList(),
                  ),
                ]),
                _section('4', 'Who I serve', [
                  const Text('4.1 Audience *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(DeliveryCatalog.capabilities, _audience),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.2 COD collect'),
                    value: _doorService,
                    onChanged: (v) => setState(() => _doorService = v),
                  ),
                ]),
                _section('5', 'Readiness', [
                  const Text('5.1 Amenities / readiness', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  _chips(DeliveryCatalog.facilities, _facilities),
                ]),
                _section('6', 'Hours & calendar', [
                  const Text('6.1 Open days *', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: DeliveryCatalog.days.map((d) {
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
                _section('7', 'About you', [
                  _field(_bio, '7.1', 'About', required: true, maxLines: 4),
                ]),
                _section('8', 'First offering', [
                  _dropdown(
                    number: '8.1',
                    label: 'Typical radius (km)',
                    value: '$_duration',
                    options: DeliveryCatalog.radiuses.map((e) => '$e').toList(),
                    required: true,
                    onChanged: (v) => setState(() => _duration = int.tryParse(v ?? '5') ?? 5),
                  ),
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
                _section('11', 'Work photos (optional)', [
                  const Text('Photos of your work help clients choose you.', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
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
        subtitle: Text(value == null ? 'Tap to pick' : DeliveryCatalog.formatTime(value)),
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
