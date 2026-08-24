import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/martial_arts_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/martial_arts_service.dart';
import '../../widgets/registration_form_kit.dart';

class MartialArtsEnrollScreen extends StatefulWidget {
  const MartialArtsEnrollScreen({
    super.key,
    required this.centre,
    required this.batch,
  });

  final Map<String, dynamic> centre;
  final Map<String, dynamic> batch;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const int minAge = 16;

  @override
  State<MartialArtsEnrollScreen> createState() => _MartialArtsEnrollScreenState();
}

class _MartialArtsEnrollScreenState extends State<MartialArtsEnrollScreen> {
  late final MartialArtsService _api;
  late final Razorpay _razorpay;
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _medicationsCtrl = TextEditingController();
  final _medicalCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();
  final _motivationCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _trainerCtrl = TextEditingController();

  String _gender = 'Female';
  String _skill = 'Beginner';
  String _occupation = 'Student';
  String _emergencyRelation = 'Parent';
  String _preferredBatch = 'Morning';
  String _trainingMode = 'Offline';
  String _previousExperience = 'No';
  String _fitnessGoal = 'Self-Defence';
  String _bloodGroup = 'O+';
  final Set<String> _days = {};
  bool _noMedicalConditions = false;
  bool _consentAccuracy = false;
  bool _consentRules = false;
  bool _consentPayment = false;
  bool _consentPolicy = false;
  bool _busy = false;
  String? _error;

  int? _pendingEnrollmentId;
  int? _pendingCentreId;
  int? _pendingBatchId;

  static const _weekDays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];
  static const _occupations = [
    'Student',
    'Working Professional',
    'Homemaker',
    'Self-employed',
    'Other',
  ];
  static const _relations = [
    'Father',
    'Mother',
    'Husband',
    'Wife',
    'Brother',
    'Sister',
    'Friend',
    'Guardian',
    'Other',
  ];
  static const _batchSlots = ['Morning', 'Afternoon', 'Evening'];
  static const _modes = ['Offline', 'Online', 'Hybrid'];
  static const _goals = [
    'Weight Loss',
    'Strength',
    'Self-Defence',
    'General Fitness',
    'Competition',
  ];
  static const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  double get _courseFee {
    final fee = widget.batch['fee'];
    if (widget.batch['free'] == true) return 0;
    if (fee is num) return fee.toDouble();
    return double.tryParse('$fee') ?? 0;
  }

  double get _gst => 0;
  double get _totalPayable => _courseFee + _gst;
  bool get _isFree => widget.batch['free'] == true || _courseFee <= 0;

  @override
  void initState() {
    super.initState();
    _api = MartialArtsService(context.read<AuthState>().api);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    final auth = context.read<AuthState>();
    _nameCtrl.text = auth.name ?? '';
    _emailCtrl.text = auth.email ?? '';
    final skill = widget.batch['skillLevel']?.toString();
    if (skill != null && ['Beginner', 'Intermediate', 'Advanced'].contains(skill)) {
      _skill = skill;
    }
    final mode = widget.batch['batchType']?.toString();
    if (mode != null && _modes.map((e) => e.toLowerCase()).contains(mode.toLowerCase())) {
      _trainingMode = _modes.firstWhere((m) => m.toLowerCase() == mode.toLowerCase());
    }
    _startDateCtrl.text = DateTime.now().add(const Duration(days: 7)).toIso8601String().substring(0, 10);
  }

  @override
  void dispose() {
    _razorpay.clear();
    for (final c in [
      _nameCtrl,
      _phoneCtrl,
      _emailCtrl,
      _ageCtrl,
      _dobCtrl,
      _addressCtrl,
      _heightCtrl,
      _weightCtrl,
      _emergencyNameCtrl,
      _emergencyPhoneCtrl,
      _medicationsCtrl,
      _medicalCtrl,
      _allergyCtrl,
      _motivationCtrl,
      _startDateCtrl,
      _trainerCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _applyDob(DateTime picked) {
    final today = DateTime.now();
    var age = today.year - picked.year;
    if (today.month < picked.month ||
        (today.month == picked.month && today.day < picked.day)) {
      age--;
    }
    setState(() {
      _dobCtrl.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _ageCtrl.text = age < 0 ? '' : '$age';
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) _applyDob(picked);
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked == null) return;
    setState(() {
      _startDateCtrl.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    });
  }

  bool get _canSubmit {
    if (_busy) return false;
    if (_nameCtrl.text.trim().isEmpty) return false;
    if (!RegValidators.isEmail(_emailCtrl.text)) return false;
    if (!RegValidators.isPhone10(_phoneCtrl.text)) return false;
    if (_dobCtrl.text.trim().isEmpty) return false;
    final age = int.tryParse(_ageCtrl.text.trim()) ?? -1;
    if (age < MartialArtsEnrollScreen.minAge) return false;
    if (_addressCtrl.text.trim().isEmpty) return false;
    if (_emergencyNameCtrl.text.trim().isEmpty) return false;
    if (!RegValidators.isPhone10(_emergencyPhoneCtrl.text)) return false;
    if (_emergencyPhoneCtrl.text.trim() == _phoneCtrl.text.trim()) return false;
    if (_startDateCtrl.text.trim().isEmpty) return false;
    final start = DateTime.tryParse(_startDateCtrl.text.trim());
    if (start == null) return false;
    final today = DateTime.now();
    final startDay = DateTime(start.year, start.month, start.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    if (startDay.isBefore(todayDay)) return false;
    if (!_consentAccuracy || !_consentRules || !_consentPolicy) return false;
    if (!_isFree && !_consentPayment) return false;
    if (!_noMedicalConditions && _medicalCtrl.text.trim().isEmpty) return false;
    return true;
  }

  Map<String, dynamic> _enrollBody(int centreId, int batchId) {
    final medical = _noMedicalConditions
        ? 'None declared'
        : [
            if (_medicalCtrl.text.trim().isNotEmpty) _medicalCtrl.text.trim(),
            if (_medicationsCtrl.text.trim().isNotEmpty) 'Medications: ${_medicationsCtrl.text.trim()}',
            'Blood group: $_bloodGroup',
          ].join(' · ');

    final fitness = [
      'Occupation: $_occupation',
      if (_heightCtrl.text.trim().isNotEmpty) 'Height: ${_heightCtrl.text.trim()} cm',
      if (_weightCtrl.text.trim().isNotEmpty) 'Weight: ${_weightCtrl.text.trim()} kg',
      'Preferred batch: $_preferredBatch',
      'Training mode: $_trainingMode',
      'Previous experience: $_previousExperience',
      'Fitness goal: $_fitnessGoal',
    ].join('\n');

    return {
      'centerId': centreId,
      'batchId': batchId,
      'fullName': _nameCtrl.text.trim(),
      'dob': _dobCtrl.text.trim(),
      'age': int.tryParse(_ageCtrl.text.trim()),
      'gender': _gender,
      'phoneNumber': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'emergencyName':
          '${_emergencyNameCtrl.text.trim()} ($_emergencyRelation) · ${_emergencyPhoneCtrl.text.trim()}',
      'style': widget.batch['style'],
      'skillLevel': _skill,
      'preferredDays': _days.toList(),
      'goal': _fitnessGoal,
      'motivation': [
        if (_motivationCtrl.text.trim().isNotEmpty) _motivationCtrl.text.trim(),
        'Preferred batch slot: $_preferredBatch',
        'Mode: $_trainingMode',
      ].join('\n'),
      'medicalConditions': medical,
      'allergies': _allergyCtrl.text.trim(),
      'fitnessNotes': fitness,
      'startDate': _startDateCtrl.text.trim(),
      'trainerPreference': _trainerCtrl.text.trim(),
      'monthlyFee': _courseFee,
      'consentAccuracy': _consentAccuracy,
      'consentRules': _consentRules,
      'consentPolicy': _consentPolicy,
    };
  }

  Future<void> _showSuccessAndPop({required bool paid}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Enrollment Successful!'),
        content: Text(
          paid
              ? 'Your enrollment request has been received. Payment has been completed successfully, and your training will begin on ${_startDateCtrl.text.trim()}. You will receive batch details via email and SMS.'
              : 'Your enrollment request has been received. Your training will begin on ${_startDateCtrl.text.trim()}. You will receive batch details via email and SMS.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;
    if (!_canSubmit) {
      setState(() => _error = 'Complete required fields and confirmation checkboxes.');
      return;
    }

    final centreId = widget.centre['id'] is int
        ? widget.centre['id'] as int
        : int.tryParse('${widget.centre['id']}');
    final batchId = widget.batch['id'] is int
        ? widget.batch['id'] as int
        : int.tryParse('${widget.batch['id']}');
    if (centreId == null || batchId == null) {
      setState(() => _error = 'Invalid centre/batch');
      return;
    }

    setState(() => _busy = true);

    try {
      final res = await _api.enroll(_enrollBody(centreId, batchId));
      if (!mounted) return;
      if (res['success'] != true) {
        setState(() {
          _busy = false;
          _error = res['error']?.toString() ?? 'Enrollment failed';
        });
        return;
      }

      final free = res['free'] == true || _isFree;
      if (free) {
        setState(() => _busy = false);
        await _showSuccessAndPop(paid: false);
        return;
      }

      final amount = (res['amount'] is num) ? (res['amount'] as num).toDouble() : _totalPayable;
      final enrollmentId = res['enrollmentId'] is int
          ? res['enrollmentId'] as int
          : int.tryParse('${res['enrollmentId']}');
      if (enrollmentId == null || amount <= 0) {
        setState(() {
          _busy = false;
          _error = 'Could not start payment';
        });
        return;
      }

      _pendingEnrollmentId = enrollmentId;
      _pendingCentreId = centreId;
      _pendingBatchId = batchId;

      final orderRes = await _api.createPaymentOrder(amount);
      if (!mounted) return;
      if (orderRes['orderId'] == null) {
        setState(() {
          _busy = false;
          _error = orderRes['error']?.toString() ?? 'Payment gateway unavailable';
        });
        return;
      }

      final options = {
        'key': orderRes['key'],
        'amount': orderRes['amount'],
        'order_id': orderRes['orderId'],
        'name': 'Fight D Fear',
        'description': 'Martial Arts Enrollment',
        'prefill': {
          'email': _emailCtrl.text.trim(),
          'contact': _phoneCtrl.text.trim(),
          'name': _nameCtrl.text.trim(),
        },
      };
      _razorpay.open(options);
      setState(() => _busy = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = '$e';
      });
    }
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _busy = true);
    try {
      final verify = await _api.verifyPayment({
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'MARTIAL_ARTS',
        'enrollmentId': _pendingEnrollmentId,
        'centerId': _pendingCentreId,
        'batchId': _pendingBatchId,
      });
      if (!mounted) return;
      if (verify['error'] != null) {
        setState(() {
          _busy = false;
          _error = verify['error'].toString();
        });
        return;
      }
      setState(() => _busy = false);
      await _showSuccessAndPop(paid: true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = 'Verification failed: $e';
        });
      }
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = response.message ?? 'Payment cancelled or failed';
    });
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          color: MartialArtsEnrollScreen.navy,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feeLabel = _isFree ? 'Free batch' : 'Fee: ₹${_courseFee.toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsEnrollScreen.navy,
        elevation: 0.5,
        title: const Text('Enroll', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        // Extra left inset helps avoid overlap with system/accessibility overlays.
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 40),
            children: [
              Text(
                widget.centre['name']?.toString() ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: MartialArtsEnrollScreen.navy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.batch['name'] ?? 'Batch'} · $feeLabel',
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              _section('Personal information'),
              _field(_nameCtrl, 'Full name *', required: true),
              _field(
                _phoneCtrl,
                'Phone *',
                required: true,
                keyboard: TextInputType.phone,
                digits: 10,
                validator: (v) => RegValidators.phoneError(v ?? ''),
              ),
              _field(
                _emailCtrl,
                'Email *',
                required: true,
                keyboard: TextInputType.emailAddress,
                validator: (v) => RegValidators.emailError(v ?? ''),
              ),
              TextFormField(
                controller: _dobCtrl,
                readOnly: true,
                onTap: _pickDob,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Date of birth *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: _pickDob,
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Date of birth is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Age (auto-calculated) *',
                  border: const OutlineInputBorder(),
                  helperText: 'Minimum age: ${MartialArtsEnrollScreen.minAge}',
                ),
                validator: (v) {
                  final age = int.tryParse(v ?? '');
                  if (age == null) return 'Select date of birth';
                  if (age < MartialArtsEnrollScreen.minAge) {
                    return 'You must be at least ${MartialArtsEnrollScreen.minAge} years old';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender *', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _gender = v ?? _gender),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _occupation,
                decoration: const InputDecoration(labelText: 'Occupation *', border: OutlineInputBorder()),
                items: _occupations.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (v) => setState(() => _occupation = v ?? _occupation),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      _heightCtrl,
                      'Height cm (optional)',
                      keyboard: TextInputType.number,
                      digits: 3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _field(
                      _weightCtrl,
                      'Weight kg (optional)',
                      keyboard: TextInputType.number,
                      digits: 3,
                    ),
                  ),
                ],
              ),
              _field(_addressCtrl, 'Residential address *', required: true, maxLines: 2),

              _section('Emergency information'),
              _field(_emergencyNameCtrl, 'Emergency contact name *', required: true),
              DropdownButtonFormField<String>(
                value: _emergencyRelation,
                decoration: const InputDecoration(
                  labelText: 'Relationship *',
                  border: OutlineInputBorder(),
                ),
                items: _relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _emergencyRelation = v ?? _emergencyRelation),
              ),
              const SizedBox(height: 12),
              _field(
                _emergencyPhoneCtrl,
                'Emergency contact number *',
                required: true,
                keyboard: TextInputType.phone,
                digits: 10,
                validator: (v) {
                  final err = RegValidators.phoneError(v ?? '', label: 'Emergency contact');
                  if (err != null) return err;
                  if ((v ?? '').trim() == _phoneCtrl.text.trim()) {
                    return 'Emergency contact must differ from your phone';
                  }
                  return null;
                },
              ),

              _section('Training details'),
              DropdownButtonFormField<String>(
                value: _skill,
                decoration: const InputDecoration(labelText: 'Skill level *', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                  DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                  DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                ],
                onChanged: (v) => setState(() => _skill = v ?? _skill),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _preferredBatch,
                decoration: const InputDecoration(
                  labelText: 'Preferred batch *',
                  border: OutlineInputBorder(),
                ),
                items: _batchSlots.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _preferredBatch = v ?? _preferredBatch),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _trainingMode,
                decoration: const InputDecoration(
                  labelText: 'Training mode *',
                  border: OutlineInputBorder(),
                ),
                items: _modes.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) => setState(() => _trainingMode = v ?? _trainingMode),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _previousExperience,
                decoration: const InputDecoration(
                  labelText: 'Previous martial arts experience *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                  DropdownMenuItem(value: 'No', child: Text('No')),
                ],
                onChanged: (v) => setState(() => _previousExperience = v ?? _previousExperience),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _fitnessGoal,
                decoration: const InputDecoration(
                  labelText: 'Fitness goal *',
                  border: OutlineInputBorder(),
                ),
                items: _goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _fitnessGoal = v ?? _fitnessGoal),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _startDateCtrl,
                readOnly: true,
                onTap: _pickStartDate,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Preferred start date *',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.event),
                    onPressed: _pickStartDate,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Start date is required';
                  final start = DateTime.tryParse(v.trim());
                  if (start == null) return 'Invalid date';
                  final today = DateTime.now();
                  final startDay = DateTime(start.year, start.month, start.day);
                  final todayDay = DateTime(today.year, today.month, today.day);
                  if (startDay.isBefore(todayDay)) return 'Start date cannot be in the past';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _field(_trainerCtrl, 'Trainer preference (optional)'),
              _field(_motivationCtrl, 'Motivation (optional)', maxLines: 2),
              const Text('Preferred days', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _weekDays.map((d) {
                  final selected = _days.contains(d);
                  return FilterChip(
                    label: Text(d.substring(0, 3)),
                    selected: selected,
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

              _section('Medical information'),
              DropdownButtonFormField<String>(
                value: _bloodGroup,
                decoration: const InputDecoration(
                  labelText: 'Blood group *',
                  border: OutlineInputBorder(),
                ),
                items: _bloodGroups.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _bloodGroup = v ?? _bloodGroup),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: _noMedicalConditions,
                onChanged: (v) => setState(() {
                  _noMedicalConditions = v ?? false;
                  if (_noMedicalConditions) _medicalCtrl.clear();
                }),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text('I have no medical conditions', style: TextStyle(fontSize: 14)),
              ),
              if (!_noMedicalConditions)
                _field(
                  _medicalCtrl,
                  'Medical conditions *',
                  required: true,
                  maxLines: 2,
                ),
              _field(_medicationsCtrl, 'Current medications (optional)', maxLines: 2),
              _field(_allergyCtrl, 'Allergies (optional)'),

              if (!_isFree) ...[
                _section('Payment summary'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _feeRow('Course fee', '₹${_courseFee.toStringAsFixed(0)}'),
                        _feeRow('GST', '₹${_gst.toStringAsFixed(0)}'),
                        const Divider(),
                        _feeRow('Total payable', '₹${_totalPayable.toStringAsFixed(0)}', bold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _consentPayment,
                  onChanged: (v) => setState(() => _consentPayment = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'I understand that enrollment is confirmed only after successful payment',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],

              CheckboxListTile(
                value: _consentAccuracy,
                onChanged: (v) => setState(() => _consentAccuracy = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'I confirm the details above are accurate',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CheckboxListTile(
                value: _consentRules,
                onChanged: (v) => setState(() => _consentRules = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'I agree to centre training rules',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CheckboxListTile(
                value: _consentPolicy,
                onChanged: (v) => setState(() => _consentPolicy = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  MartialArtsCatalog.cancelPolicy,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: MartialArtsEnrollScreen.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isFree ? 'Confirm enrollment' : 'Enroll & pay'),
                ),
              ),
              if (!_canSubmit)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Complete required fields and confirmation checkboxes to enable enrollment.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feeRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    bool required = false,
    TextInputType? keyboard,
    int maxLines = 1,
    int? digits,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        inputFormatters: [
          if (digits != null) FilteringTextInputFormatter.digitsOnly,
          if (digits != null) LengthLimitingTextInputFormatter(digits),
        ],
        validator: validator ??
            (required
                ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
                : null),
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
