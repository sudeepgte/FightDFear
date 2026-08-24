import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/doctor_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';

class WomenDoctorBookingScreen extends StatefulWidget {
  const WomenDoctorBookingScreen({
    super.key,
    required this.doctorId,
    this.doctorSummary,
    this.followUpOfId,
  });

  final int doctorId;
  final Map<String, dynamic>? doctorSummary;
  final int? followUpOfId;

  @override
  State<WomenDoctorBookingScreen> createState() => _WomenDoctorBookingScreenState();
}

class _WomenDoctorBookingScreenState extends State<WomenDoctorBookingScreen> {
  late final DoctorService _svc;
  late final PaymentService _payments;
  late final Razorpay _razorpay;

  bool _loading = true;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _doctor = {};

  final _patientName = TextEditingController();
  final _age = TextEditingController();
  final _symptoms = TextEditingController();
  String _gender = DoctorCatalog.patientGenders.first;
  String? _consultType;
  DateTime? _date;
  TimeOfDay? _time;
  final List<String> _reportPaths = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _svc = DoctorService(api);
    _payments = PaymentService(api);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaid);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPayError);
    if (widget.doctorSummary != null) {
      _doctor = Map<String, dynamic>.from(widget.doctorSummary!);
    }
    _load();
  }

  @override
  void dispose() {
    _patientName.dispose();
    _age.dispose();
    _symptoms.dispose();
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.detail(widget.doctorId);
      if (!mounted) return;
      if (res['success'] == true && res['doctor'] is Map) {
        _doctor = Map<String, dynamic>.from(res['doctor'] as Map);
        _initDefaults();
      } else {
        _error = res['error']?.toString() ?? 'Failed to load doctor';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  void _initDefaults() {
    final modes = DoctorCatalog.consultationModesOf(_doctor);
    _consultType = modes.isEmpty ? 'CLINIC' : modes.first;
    final dates = DoctorCatalog.bookableDates(_doctor);
    _date = dates.isEmpty ? null : dates.first;
    final times = _date == null ? <TimeOfDay>[] : DoctorCatalog.timesForDate(_doctor, _date!);
    _time = times.isEmpty ? null : times.first;
  }

  List<String> get _modes => DoctorCatalog.consultationModesOf(_doctor);
  List<DateTime> get _dates => DoctorCatalog.bookableDates(_doctor);
  List<TimeOfDay> get _times =>
      _date == null ? const [] : DoctorCatalog.timesForDate(_doctor, _date!);

  double _feeFor(String mode) {
    num? pick;
    if (mode == 'VIDEO') {
      pick = (_doctor['videoFee'] ?? _doctor['callFee'] ?? _doctor['consultationFee']) as num?;
    } else if (mode == 'ONLINE') {
      pick = (_doctor['chatFee'] ?? _doctor['consultationFee']) as num?;
    } else {
      pick = _doctor['consultationFee'] as num?;
    }
    final base = pick?.toDouble() ?? 0;
    if (widget.followUpOfId != null) return (base * 0.5).roundToDouble();
    return base;
  }

  String? _validate() {
    if (_patientName.text.trim().isEmpty) return 'Patient name is required';
    final age = int.tryParse(_age.text.trim());
    if (age == null || age < 1 || age > 120) return 'Enter a valid age (1–120)';
    if (_symptoms.text.trim().isEmpty) return 'Please describe symptoms or reason';
    if (_consultType == null) return 'Select a consultation mode';
    if (_date == null) return 'Select a date';
    if (_time == null) return 'Select a time slot';
    return null;
  }

  String get _reason => DoctorCatalog.composeReason(
        patientName: _patientName.text,
        age: _age.text,
        gender: _gender,
        symptoms: _symptoms.text,
      );

  DateTime? get _appt {
    if (_date == null || _time == null) return null;
    return DateTime(_date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    final appt = _appt!;
    final apptStr = DoctorCatalog.formatAppt(appt);
    final mode = _consultType!;
    final fee = _feeFor(mode);
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      if (fee > 0) {
        await _startPayment(apptStr: apptStr, mode: mode, fee: fee);
      } else {
        final res = await _svc.book(
          widget.doctorId,
          notes: _reason,
          reason: _reason,
          appointmentTime: apptStr,
          consultationType: mode,
          followUpOfId: widget.followUpOfId,
        );
        if (!mounted) return;
        if (res['success'] != true) {
          setState(() => _error = res['error']?.toString() ?? 'Booking failed');
          return;
        }
        await _confirmed(
          apptStr: apptStr,
          status: res['status']?.toString() ?? 'Requested',
          appointmentId: res['appointmentId'] is num
              ? (res['appointmentId'] as num).toInt()
              : int.tryParse('${res['appointmentId']}'),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _startPayment({
    required String apptStr,
    required String mode,
    required double fee,
  }) async {
    final orderRes = await _payments.createDoctorOrder(
      doctorId: widget.doctorId,
      consultationType: mode,
      appointmentTime: apptStr,
      reason: _reason,
    );
    if (!mounted) return;
    if (orderRes['orderId'] == null || orderRes['key'] == null) {
      setState(() => _error = orderRes['error']?.toString() ?? 'Payment gateway unavailable');
      return;
    }
    if (orderRes['mock'] == true) {
      await _verifyPayment(
        PaymentSuccessResponse(
          'mock_pay_${DateTime.now().millisecondsSinceEpoch}',
          orderRes['orderId']?.toString(),
          'mock_sig',
          <dynamic, dynamic>{'mock': true},
        ),
        apptStr: apptStr,
        mode: mode,
        fee: fee,
      );
      return;
    }
    _pendingAppt = apptStr;
    _pendingMode = mode;
    _pendingFee = fee;
    _razorpay.open({
      'key': orderRes['key'],
      'amount': orderRes['amount'],
      'currency': orderRes['currency'] ?? 'INR',
      'order_id': orderRes['orderId'],
      'name': 'Fight D Fear Medical',
      'description': 'Consultation with ${_doctor['fullName'] ?? 'Doctor'}',
      'theme': {'color': '#F43F5E'},
    });
  }

  String _pendingAppt = '';
  String _pendingMode = '';
  double _pendingFee = 0;

  void _onPaid(PaymentSuccessResponse response) {
    _verifyPayment(response, apptStr: _pendingAppt, mode: _pendingMode, fee: _pendingFee);
  }

  void _onPayError(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() => _error = response.message ?? 'Payment cancelled or failed');
  }

  Future<void> _verifyPayment(
    PaymentSuccessResponse response, {
    required String apptStr,
    required String mode,
    required double fee,
  }) async {
    try {
      Map<String, dynamic>? verify;
      await ActionFeedback.run(
        context,
        loadingLabel: 'Confirming payment…',
        doneLabel: 'Confirmed',
        action: () async {
          verify = await _payments.verify({
            'razorpay_order_id': response.orderId,
            'razorpay_payment_id': response.paymentId,
            'razorpay_signature': response.signature,
            'type': 'DOCTOR',
            'targetId': widget.doctorId,
            'amount': fee,
            'appointmentTime': apptStr,
            'consultationType': mode,
            'reason': _reason,
          });
          if (verify!['error'] != null) {
            throw Exception(verify!['error'].toString());
          }
          return verify;
        },
      );
      if (!mounted || verify == null) return;
      await _confirmed(
        apptStr: apptStr,
        status: verify!['status']?.toString() ?? 'Confirmed',
        appointmentId: verify!['appointmentId'] is num
            ? (verify!['appointmentId'] as num).toInt()
            : int.tryParse('${verify!['appointmentId']}'),
      );
    } catch (e) {
      if (mounted) setState(() => _error = 'Verification failed: $e');
    }
  }

  Future<void> _confirmed({
    required String apptStr,
    required String status,
    int? appointmentId,
  }) async {
    if (appointmentId != null && _reportPaths.isNotEmpty) {
      for (final path in _reportPaths) {
        try {
          await _svc.uploadReport(appointmentId, filePath: path);
        } catch (_) {}
      }
    }
    final dt = DateTime.tryParse(apptStr.replaceFirst(' ', 'T'));
    await showAppointmentConfirmedSheet(
      context,
      doctorName: _doctor['fullName']?.toString() ?? 'Doctor',
      dateLabel: dt == null ? apptStr : '${DoctorCatalog.weekdayName(dt.weekday)}, ${dt.day}/${dt.month}/${dt.year}',
      timeLabel: dt == null
          ? '—'
          : MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: dt.hour, minute: dt.minute)),
      statusLabel: status,
      doctorId: widget.doctorId,
      appointmentId: appointmentId,
      appointmentIso: apptStr,
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _date ?? (_dates.isEmpty ? now : _dates.first);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      selectableDayPredicate: (d) {
        final day = DateTime(d.year, d.month, d.day);
        return DoctorCatalog.timesForDate(_doctor, day).isNotEmpty;
      },
    );
    if (picked == null) return;
    setState(() {
      _date = DateTime(picked.year, picked.month, picked.day);
      final times = DoctorCatalog.timesForDate(_doctor, _date!);
      _time = times.isEmpty ? null : times.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = _doctor['fullName']?.toString() ?? 'Doctor';
    final fee = _feeFor(_consultType ?? 'CLINIC');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Book appointment'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Text('Consultation with ${name.startsWith('Dr') ? name : 'Dr. $name'}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  fee > 0 ? 'Fee: ₹${fee.toStringAsFixed(0)}' : 'No consultation fee listed',
                  style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w700),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                const Text('1. Patient details', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                TextField(
                  controller: _patientName,
                  decoration: const InputDecoration(
                    labelText: '1.1 Patient name *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  decoration: const InputDecoration(
                    labelText: '1.2 Age *',
                    counterText: '',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(
                    labelText: '1.3 Gender *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: DoctorCatalog.patientGenders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? _gender),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _symptoms,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: '1.4 Symptoms / reason *',
                    hintText: 'What should the doctor know before the visit?',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                const Text('2. Consultation', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _modes.contains(_consultType) ? _consultType : null,
                  decoration: const InputDecoration(
                    labelText: '2.1 Mode *',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _modes
                      .map((m) => DropdownMenuItem(value: m, child: Text(DoctorCatalog.modeLabel(m))))
                      .toList(),
                  onChanged: (v) => setState(() => _consultType = v),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Expanded(
                      child: Text('2.2 Date *', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_month_outlined, size: 18),
                      label: const Text('Calendar'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Free cancellation until 2 hours before the appointment. After that the fee is not refunded.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  ),
                ),
                if (widget.followUpOfId != null)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('Follow-up visit — 50% of the usual fee.', style: TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w700)),
                  ),
                if (_dates.isEmpty)
                  const Text('No slots this week. Try another doctor or Instant Consult.', style: TextStyle(color: Colors.red))
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _dates.map((d) {
                      final on = _date != null &&
                          _date!.year == d.year &&
                          _date!.month == d.month &&
                          _date!.day == d.day;
                      return ChoiceChip(
                        label: Text('${DoctorCatalog.weekdayShort(d.weekday)} ${d.day}/${d.month}'),
                        selected: on,
                        onSelected: (_) => setState(() {
                          _date = d;
                          final times = DoctorCatalog.timesForDate(_doctor, d);
                          _time = times.isEmpty ? null : times.first;
                        }),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 14),
                const Text('2.3 Time *', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                if (_times.isEmpty)
                  const Text('No times on the selected date.', style: TextStyle(color: Color(0xFF64748B)))
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _times.map((t) {
                      final on = _time != null && _time!.hour == t.hour && _time!.minute == t.minute;
                      return ChoiceChip(
                        label: Text(MaterialLocalizations.of(context).formatTimeOfDay(t)),
                        selected: on,
                        onSelected: (_) => setState(() => _time = t),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 18),
                const Text('3. Reports (optional)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 6),
                const Text(
                  'Upload thyroid, scan, or lab reports (JPG / PNG / PDF) so the doctor can review them.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
                      allowMultiple: true,
                    );
                    if (picked == null) return;
                    setState(() {
                      for (final f in picked.files) {
                        if (f.path != null) _reportPaths.add(f.path!);
                      }
                    });
                  },
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('Add reports'),
                ),
                if (_reportPaths.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('${_reportPaths.length} file(s) attached', style: const TextStyle(fontSize: 12)),
                  ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: ModuleTheme.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(fee > 0 ? 'Pay ₹${fee.toStringAsFixed(0)} & book' : 'Request booking'),
                ),
              ],
            ),
    );
  }
}
