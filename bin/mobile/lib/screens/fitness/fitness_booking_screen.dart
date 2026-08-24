import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';

/// Member: choose service, package, date, slot, format → review → pay.
class FitnessBookingScreen extends StatefulWidget {
  const FitnessBookingScreen({
    super.key,
    required this.trainerId,
    this.trainerSummary,
  });

  final int trainerId;
  final Map<String, dynamic>? trainerSummary;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<FitnessBookingScreen> createState() => _FitnessBookingScreenState();
}

class _FitnessBookingScreenState extends State<FitnessBookingScreen> {
  late final FitnessService _svc;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  Map<String, dynamic> _trainer = {};

  String? _category;
  String _duration = 'SINGLE';
  String _sessionType = 'ONLINE';
  String? _timeSlot;
  DateTime? _date;
  final _noteCtrl = TextEditingController();
  List<Map<String, dynamic>> _dynamicSlots = [];
  bool _loadingSlots = false;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _svc = FitnessService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) {
        if (mounted) _snack(r.message ?? 'Payment cancelled or failed');
      },
    );
    if (widget.trainerSummary != null) {
      _trainer = Map<String, dynamic>.from(widget.trainerSummary!);
    }
    _load();
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    _checkout.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.trainerDetail(widget.trainerId);
      if (!mounted) return;
      if (res['success'] == true) {
        final t = res['trainer'];
        _trainer = t is Map ? Map<String, dynamic>.from(t) : _trainer;
        _initDefaults();
      } else {
        _error = res['error']?.toString() ?? 'Failed to load trainer';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _fetchSlotsForDate(DateTime date) async {
    setState(() {
      _loadingSlots = true;
      _timeSlot = null;
    });
    final dateStr =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      final res = await _svc.availableSlots(widget.trainerId, date: dateStr);
      if (!mounted) return;
      if (res['success'] == true && res['slots'] is List) {
        final list = (res['slots'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        setState(() {
          _dynamicSlots = list;
          final firstAvail = list.firstWhere((s) => s['available'] == true, orElse: () => {});
          if (firstAvail.isNotEmpty) {
            _timeSlot = firstAvail['time']?.toString();
          }
        });
      } else {
        setState(() => _dynamicSlots = []);
      }
    } catch (_) {
      if (mounted) setState(() => _dynamicSlots = []);
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  void _initDefaults() {
    final specs = (_trainer['specializations']?.toString() ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    _category = specs.isEmpty ? 'General Fitness' : specs.first;

    final st = (_trainer['serviceType']?.toString() ?? 'Both').toLowerCase();
    if (st.contains('offline') && !st.contains('online')) {
      _sessionType = 'OFFLINE';
    } else {
      _sessionType = 'ONLINE';
    }

    _date = DateTime.now().add(const Duration(days: 1));
    _fetchSlotsForDate(_date!);
  }

  List<Map<String, dynamic>> get _packages {
    final raw = _trainer['packages'];
    if (raw is List) {
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    final base = (_trainer['sessionFees'] is num)
        ? (_trainer['sessionFees'] as num).toDouble()
        : double.tryParse('${_trainer['sessionFees']}') ?? 0;
    return [
      {'id': 'SINGLE', 'label': 'Single session', 'totalSessions': 1, 'fees': base},
      {'id': 'MONTHLY', 'label': 'Monthly (12 sessions)', 'totalSessions': 12, 'fees': base * 10},
    ];
  }

  List<Map<String, dynamic>> get _timeSlotsList {
    if (_dynamicSlots.isNotEmpty) return _dynamicSlots;
    return const [
      {'time': '06:00 AM - 07:00 AM', 'available': true, 'reason': 'Available'},
      {'time': '07:00 AM - 08:00 AM', 'available': true, 'reason': 'Available'},
      {'time': '08:00 AM - 09:00 AM', 'available': true, 'reason': 'Available'},
      {'time': '09:00 AM - 10:00 AM', 'available': true, 'reason': 'Available'},
      {'time': '10:00 AM - 11:00 AM', 'available': true, 'reason': 'Available'},
      {'time': '04:00 PM - 05:00 PM', 'available': true, 'reason': 'Available'},
      {'time': '05:00 PM - 06:00 PM', 'available': true, 'reason': 'Available'},
      {'time': '06:00 PM - 07:00 PM', 'available': true, 'reason': 'Available'},
      {'time': '07:00 PM - 08:00 PM', 'available': true, 'reason': 'Available'},
    ];
  }

  List<String> get _categories {
    final specs = (_trainer['specializations']?.toString() ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (specs.isEmpty) return const ['General Fitness'];
    return specs;
  }

  Map<String, dynamic>? get _selectedPackage {
    for (final p in _packages) {
      if (p['id']?.toString() == _duration) return p;
    }
    return _packages.isEmpty ? null : _packages.first;
  }

  double get _price {
    final pkg = _selectedPackage;
    if (pkg == null) return 0;
    final f = pkg['fees'];
    if (f is num) return f.toDouble();
    return double.tryParse('$f') ?? 0;
  }

  bool get _canSubmit =>
      _category != null &&
      _category!.isNotEmpty &&
      _date != null &&
      _timeSlot != null &&
      _timeSlot!.isNotEmpty;

  Future<void> _confirmBooking() async {
    if (!_canSubmit || _date == null || _submitting) return;
    _submitting = true;
    final dateStr =
        '${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}';

    setState(() => _error = null);
    try {
      final res = await _svc.book(
        widget.trainerId,
        category: _category!,
        bookingDate: dateStr,
        bookingTime: _timeSlot!,
        sessionType: _sessionType,
        duration: _duration,
        note: _noteCtrl.text.trim(),
      );
      if (!mounted) return;
      if (res['success'] != true) {
        setState(() => _error = res['error']?.toString() ?? 'Booking failed');
        return;
      }

      final paymentRequired = res['paymentRequired'] == true;
      final bookingId = res['bookingId'] is num ? (res['bookingId'] as num).toInt() : int.tryParse('${res['bookingId']}');
      final amount = (res['amount'] is num) ? (res['amount'] as num).toDouble() : _price;
      final trainerName = _trainer['fullName']?.toString() ?? 'Trainer';

      if (paymentRequired && bookingId != null && amount > 0) {
        await _checkout.pay(
          context: context,
          amount: amount,
          description: 'Fitness session with $trainerName',
          verifyPayload: (response) => {
            'razorpay_order_id': response.orderId,
            'razorpay_payment_id': response.paymentId,
            'razorpay_signature': response.signature,
            'type': 'FITNESS',
            'bookingId': bookingId,
            'amount': amount,
          },
          onSuccess: () {
            if (!mounted) return;
            Navigator.of(context).pop(true);
          },
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking requested. Trainer will confirm your session.')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _date = picked);
      _fetchSlotsForDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _trainer['fullName']?.toString() ?? 'Trainer';
    final pkg = _selectedPackage;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Book Session'),
        backgroundColor: Colors.white,
        foregroundColor: FitnessBookingScreen.navy,
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null && _trainer.isEmpty
              ? ModuleTheme.errorView(_error!, _load)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: [
                    Text('with $name', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 16),
                    _section('Choose service'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((c) {
                        return ChoiceChip(
                          label: Text(c),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c),
                          selectedColor: const Color(0xFFFFE4E6),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _section('Choose package'),
                    ..._packages.map((p) {
                      final id = p['id']?.toString() ?? '';
                      final label = p['label']?.toString() ?? id;
                      final fees = p['fees'];
                      return RadioListTile<String>(
                        value: id,
                        groupValue: _duration,
                        onChanged: (v) => setState(() => _duration = v ?? _duration),
                        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('₹${fees is num ? fees : fees}'),
                        activeColor: FitnessBookingScreen.primary,
                      );
                    }),
                    const SizedBox(height: 8),
                    _section('Choose date'),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      tileColor: Colors.white,
                      leading: const Icon(Icons.calendar_today, color: FitnessBookingScreen.primary),
                      title: Text(_date == null
                          ? 'Select date'
                          : '${_date!.day}/${_date!.month}/${_date!.year}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 12),
                    _section('Choose time slot'),
                    if (_loadingSlots)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: FitnessBookingScreen.primary),
                          ),
                        ),
                      )
                    else if (_timeSlotsList.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Text('No slots available for this date.', style: TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _timeSlotsList.map((slotObj) {
                          final slot = slotObj['time']?.toString() ?? '';
                          final available = slotObj['available'] == true;
                          final reason = slotObj['reason']?.toString() ?? '';
                          return ChoiceChip(
                            label: Text(
                              available ? slot : '$slot ($reason)',
                              style: TextStyle(
                                fontSize: 11,
                                color: available ? null : Colors.grey.shade400,
                              ),
                            ),
                            selected: _timeSlot == slot && available,
                            onSelected: available ? (_) => setState(() => _timeSlot = slot) : null,
                            selectedColor: const Color(0xFFFFE4E6),
                            disabledColor: const Color(0xFFF1F5F9),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 16),
                    _section('Session format'),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'ONLINE', label: Text('Online'), icon: Icon(Icons.videocam_outlined)),
                        ButtonSegment(value: 'OFFLINE', label: Text('Offline'), icon: Icon(Icons.location_on_outlined)),
                      ],
                      selected: {_sessionType},
                      onSelectionChanged: (s) => setState(() => _sessionType = s.first),
                    ),
                    const SizedBox(height: 16),
                    _section('Notes (optional)'),
                    TextField(
                      controller: _noteCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Goals, injuries, preferences…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Review booking', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 10),
                          _reviewRow('Service', _category ?? '—'),
                          _reviewRow('Package', pkg?['label']?.toString() ?? _duration),
                          _reviewRow('Date', _date == null ? '—' : '${_date!.day}/${_date!.month}/${_date!.year}'),
                          _reviewRow('Time', _timeSlot ?? '—'),
                          _reviewRow('Format', _sessionType),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontWeight: FontWeight.w800)),
                              Text('₹${_price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: FitnessBookingScreen.primary,
                                  )),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Payment secures your slot. Trainer confirms before the session.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
      bottomNavigationBar: _loading
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton(
                  onPressed: _canSubmit && !_submitting ? _confirmBooking : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: FitnessBookingScreen.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(_price > 0 ? 'Confirm & Pay ₹${_price.toStringAsFixed(0)}' : 'Confirm booking'),
                ),
              ),
            ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }
}
