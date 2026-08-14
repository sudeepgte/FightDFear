import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/auth_state.dart';
import '../services/martial_arts_service.dart';

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
  final _emergencyCtrl = TextEditingController();
  final _goalCtrl = TextEditingController();
  final _motivationCtrl = TextEditingController();
  final _medicalCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();
  final _fitnessCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _trainerCtrl = TextEditingController();

  String _gender = 'Female';
  String _skill = 'Beginner';
  final Set<String> _days = {};
  bool _consentAccuracy = false;
  bool _consentRules = false;
  bool _busy = false;
  String? _error;

  int? _pendingEnrollmentId;
  int? _pendingCentreId;
  int? _pendingBatchId;
  double _pendingAmount = 0;

  static const _weekDays = [
    'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
  ];

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
    _startDateCtrl.text = DateTime.now().add(const Duration(days: 7)).toIso8601String().substring(0, 10);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _ageCtrl.dispose();
    _dobCtrl.dispose();
    _addressCtrl.dispose();
    _emergencyCtrl.dispose();
    _goalCtrl.dispose();
    _motivationCtrl.dispose();
    _medicalCtrl.dispose();
    _allergyCtrl.dispose();
    _fitnessCtrl.dispose();
    _startDateCtrl.dispose();
    _trainerCtrl.dispose();
    super.dispose();
  }

  Map<String, dynamic> _enrollBody(int centreId, int batchId) {
    final fee = widget.batch['fee'];
    return {
      'centerId': centreId,
      'batchId': batchId,
      'fullName': _nameCtrl.text.trim(),
      'dob': _dobCtrl.text.trim().isEmpty ? null : _dobCtrl.text.trim(),
      'age': int.tryParse(_ageCtrl.text.trim()),
      'gender': _gender,
      'phoneNumber': _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'emergencyName': _emergencyCtrl.text.trim(),
      'style': widget.batch['style'],
      'skillLevel': _skill,
      'preferredDays': _days.toList(),
      'goal': _goalCtrl.text.trim(),
      'motivation': _motivationCtrl.text.trim(),
      'medicalConditions': _medicalCtrl.text.trim(),
      'allergies': _allergyCtrl.text.trim(),
      'fitnessNotes': _fitnessCtrl.text.trim(),
      'startDate': _startDateCtrl.text.trim().isEmpty ? null : _startDateCtrl.text.trim(),
      'trainerPreference': _trainerCtrl.text.trim(),
      'monthlyFee': fee is num ? fee.toDouble() : double.tryParse('$fee'),
      'consentAccuracy': _consentAccuracy,
      'consentRules': _consentRules,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentAccuracy || !_consentRules) {
      setState(() => _error = 'Please accept both consent checkboxes.');
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

    setState(() {
      _busy = true;
      _error = null;
    });

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

      final free = res['free'] == true;
      if (free) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? 'Enrolled!')),
        );
        Navigator.of(context).pop(true);
        return;
      }

      final amount = (res['amount'] is num) ? (res['amount'] as num).toDouble() : _pendingAmount;
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
      _pendingAmount = amount;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful! Enrollment confirmed.')),
      );
      Navigator.of(context).pop(true);
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

  @override
  Widget build(BuildContext context) {
    final free = widget.batch['free'] == true;
    final fee = widget.batch['fee'];
    final feeLabel = free
        ? 'Free batch'
        : 'Fee: ₹${(fee is num ? fee.toDouble() : double.tryParse('$fee') ?? 0).toStringAsFixed(0)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsEnrollScreen.navy,
        elevation: 0.5,
        title: const Text('Enroll', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Text(widget.centre['name']?.toString() ?? '',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: MartialArtsEnrollScreen.navy)),
            const SizedBox(height: 4),
            Text('${widget.batch['name'] ?? 'Batch'} · $feeLabel',
                style: const TextStyle(color: Color(0xFF64748B))),
            if (!free) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Paid batches: complete Razorpay checkout in-app after submitting the form.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9A3412)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _field(_nameCtrl, 'Full name', required: true),
            _field(_phoneCtrl, 'Phone', required: true, keyboard: TextInputType.phone),
            _field(_emailCtrl, 'Email', required: true, keyboard: TextInputType.emailAddress),
            _field(_ageCtrl, 'Age', keyboard: TextInputType.number),
            _field(_dobCtrl, 'Date of birth (YYYY-MM-DD)'),
            DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _gender = v ?? _gender),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _skill,
              decoration: const InputDecoration(labelText: 'Skill level', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
              ],
              onChanged: (v) => setState(() => _skill = v ?? _skill),
            ),
            const SizedBox(height: 12),
            _field(_addressCtrl, 'Residential address'),
            _field(_emergencyCtrl, 'Emergency contact name'),
            _field(_goalCtrl, 'Training goal'),
            _field(_motivationCtrl, 'Motivation'),
            _field(_medicalCtrl, 'Medical conditions'),
            _field(_allergyCtrl, 'Allergies'),
            _field(_fitnessCtrl, 'Fitness notes'),
            _field(_startDateCtrl, 'Preferred start date (YYYY-MM-DD)'),
            _field(_trainerCtrl, 'Trainer preference'),
            const SizedBox(height: 8),
            const Text('Preferred days', style: TextStyle(fontWeight: FontWeight.w600)),
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
            CheckboxListTile(
              value: _consentAccuracy,
              onChanged: (v) => setState(() => _consentAccuracy = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text('I confirm the details above are accurate', style: TextStyle(fontSize: 14)),
            ),
            CheckboxListTile(
              value: _consentRules,
              onChanged: (v) => setState(() => _consentRules = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text('I agree to centre training rules', style: TextStyle(fontSize: 14)),
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
                onPressed: _busy ? null : _submit,
                style: FilledButton.styleFrom(backgroundColor: MartialArtsEnrollScreen.primary),
                child: _busy
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(free ? 'Confirm enrollment' : 'Enroll & pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
