import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';
import '../doctors/doctor_chat_screen.dart';

enum CatalogKind { doctors, marketplace, lawyers, fitness }

class ProviderCatalogScreen extends StatefulWidget {
  const ProviderCatalogScreen({
    super.key,
    required this.title,
    required this.kind,
  });

  final String title;
  final CatalogKind kind;

  @override
  State<ProviderCatalogScreen> createState() => _ProviderCatalogScreenState();
}

class _ProviderCatalogScreenState extends State<ProviderCatalogScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final TextEditingController _searchCtrl;
  late final PaymentService _payments;
  late final Razorpay _razorpay;
  DoctorService? _doctors;
  MarketplaceService? _marketplace;
  FitnessService? _fitness;

  bool _loading = true;
  bool _loadingBookings = false;
  String? _error;
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _bookings = [];
  String _category = 'all';

  int? _pendingDoctorId;
  double _pendingDoctorAmount = 0;
  String _pendingApptTime = '';
  String _pendingConsultType = 'CLINIC';
  String _pendingReason = '';

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _doctors = DoctorService(api);
    _marketplace = MarketplaceService(api);
    _fitness = FitnessService(api);
    _payments = PaymentService(api);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onDoctorPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onDoctorPaymentError);
    _searchCtrl = TextEditingController();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadBookings();
    });
    _loadList();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _tabs.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _listKey => switch (widget.kind) {
        CatalogKind.doctors => 'doctors',
        CatalogKind.marketplace || CatalogKind.lawyers => 'providers',
        CatalogKind.fitness => 'trainers',
      };

  String get _noun => switch (widget.kind) {
        CatalogKind.doctors => 'verified medical experts',
        CatalogKind.lawyers => 'verified lawyers',
        CatalogKind.marketplace => 'verified marketplace providers',
        CatalogKind.fitness => 'verified fitness trainers',
      };

  List<({String value, String label, IconData icon})> get _categories {
    switch (widget.kind) {
      case CatalogKind.doctors:
        return const [
          (value: 'all', label: 'All Experts', icon: Icons.grid_view_rounded),
          (value: 'Gynecologist', label: 'Gynecologist', icon: Icons.female),
          (value: 'Psychologist', label: 'Psychologist', icon: Icons.psychology_alt_outlined),
          (value: 'General Physician', label: 'General Physician', icon: Icons.monitor_heart_outlined),
          (value: 'Dermatologist', label: 'Dermatologist', icon: Icons.spa_outlined),
          (value: 'Pediatrician', label: 'Pediatrician', icon: Icons.child_care_outlined),
          (value: 'Nutritionist', label: 'Nutritionist', icon: Icons.restaurant_outlined),
        ];
      case CatalogKind.lawyers:
        return const [
          (value: 'all', label: 'All Lawyers', icon: Icons.grid_view_rounded),
          (value: 'WOMEN_LAWYER', label: 'Women Lawyer', icon: Icons.gavel_outlined),
        ];
      case CatalogKind.marketplace:
        return const [
          (value: 'all', label: 'All Providers', icon: Icons.grid_view_rounded),
          (value: 'HOME_SERVICE', label: 'Home Service', icon: Icons.home_repair_service_outlined),
          (value: 'BEAUTY', label: 'Beauty', icon: Icons.face_retouching_natural),
          (value: 'EDUCATION', label: 'Education', icon: Icons.school_outlined),
          (value: 'WOMEN_LAWYER', label: 'Lawyer', icon: Icons.gavel_outlined),
        ];
      case CatalogKind.fitness:
        return const [
          (value: 'all', label: 'All Trainers', icon: Icons.grid_view_rounded),
          (value: 'Yoga', label: 'Yoga', icon: Icons.self_improvement),
          (value: 'HIIT', label: 'HIIT', icon: Icons.fitness_center),
          (value: 'Zumba', label: 'Zumba', icon: Icons.music_note),
          (value: 'Strength', label: 'Strength', icon: Icons.sports_gymnastics),
        ];
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _items.where((item) {
      final specialty = _specialty(item).toLowerCase();
      final name = _title(item).toLowerCase();
      final loc = _location(item).toLowerCase();
      final catOk = _category == 'all' ||
          specialty.contains(_category.toLowerCase()) ||
          specialty == _category.toLowerCase();
      final searchOk = q.isEmpty || name.contains(q) || specialty.contains(q) || loc.contains(q);
      return catOk && searchOk;
    }).toList();
  }

  Future<void> _loadList() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.list();
        case CatalogKind.lawyers:
          res = await _marketplace!.providers(category: 'WOMEN_LAWYER');
        case CatalogKind.marketplace:
          res = await _marketplace!.providers();
        case CatalogKind.fitness:
          res = await _fitness!.trainers();
      }
      if (!mounted) return;
      if (res['success'] == true) {
        _items = ModuleTheme.toList(res[_listKey]);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.myAppointments();
          if (res['success'] == true) _bookings = ModuleTheme.toList(res['appointments']);
        case CatalogKind.marketplace:
        case CatalogKind.lawyers:
          res = await _marketplace!.myBookings();
          if (res['success'] == true) _bookings = ModuleTheme.toList(res['bookings']);
        case CatalogKind.fitness:
          res = await _fitness!.myBookings();
          if (res['success'] == true) _bookings = ModuleTheme.toList(res['bookings']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
  }

  String _title(Map<String, dynamic> item) =>
      item['fullName']?.toString() ?? item['name']?.toString() ?? 'Provider';

  String _specialty(Map<String, dynamic> item) {
    switch (widget.kind) {
      case CatalogKind.doctors:
        return item['specialization']?.toString() ?? '';
      case CatalogKind.lawyers:
      case CatalogKind.marketplace:
        return item['category']?.toString() ?? '';
      case CatalogKind.fitness:
        return item['specializations']?.toString() ?? '';
    }
  }

  String _location(Map<String, dynamic> item) =>
      item['locationText']?.toString() ?? item['city']?.toString() ?? '';

  String? _photo(Map<String, dynamic> item) {
    final path = item['profilePhotoPath']?.toString();
    if (path == null || path.isEmpty) return null;
    return ModuleTheme.mediaUrl(context.read<AuthState>().api.baseUrl, path);
  }

  List<DetailTag> _tags(Map<String, dynamic> item) {
    final tags = <DetailTag>[];
    final rating = item['rating'];
    if (rating != null) {
      tags.add(DetailTag(
        label: rating is num ? rating.toStringAsFixed(1) : '$rating',
        icon: Icons.star,
        background: const Color(0xFFFEF3C7),
        foreground: const Color(0xFFB45309),
      ));
    }
    if (item['emergencyAvailable'] == true) {
      tags.add(const DetailTag(
        label: 'Emergency',
        icon: Icons.bolt,
        background: Color(0xFFFEE2E2),
        foreground: Color(0xFFB91C1C),
      ));
    }
    final qual = item['qualification']?.toString();
    if (qual != null && qual.isNotEmpty) {
      tags.add(DetailTag(label: qual, icon: Icons.school_outlined));
    }
    final exp = item['experienceYears'];
    if (exp != null) {
      tags.add(DetailTag(
        label: '$exp Years Exp',
        icon: Icons.schedule,
        background: const Color(0xFFF3E8FF),
        foreground: const Color(0xFF7E22CE),
      ));
    }
    final consult = item['consultationType']?.toString();
    if (consult != null && consult.isNotEmpty) {
      tags.add(DetailTag(
        label: consult,
        icon: Icons.laptop,
        background: const Color(0xFFDCFCE7),
        foreground: const Color(0xFF166534),
      ));
    }
    final fee = item['consultationFee'] ?? item['sessionFees'];
    if (fee != null) {
      tags.add(DetailTag(
        label: '₹${fee is num ? fee.toStringAsFixed(0) : fee}',
        icon: Icons.currency_rupee,
        background: const Color(0xFFE0E7FF),
        foreground: const Color(0xFF3730A3),
      ));
    }
    final timings = item['availableTimings']?.toString();
    if (timings != null && timings.isNotEmpty) {
      tags.add(DetailTag(label: timings, icon: Icons.access_time));
    }
    final desc = item['description']?.toString();
    if (desc != null && desc.isNotEmpty && tags.length < 5) {
      tags.add(DetailTag(label: desc.length > 28 ? '${desc.substring(0, 28)}…' : desc));
    }
    return tags;
  }

  Future<void> _bookItem(Map<String, dynamic> item) async {
    final id = item['id'];
    if (id is! num) return;

    if (widget.kind == CatalogKind.doctors) {
      await _bookDoctor(item);
      return;
    }

    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${_title(item)}'),
        content: TextField(
          controller: noteCtrl,
          decoration: const InputDecoration(
            labelText: 'Notes / reason (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Request booking')),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      final Map<String, dynamic> res;
      switch (widget.kind) {
        case CatalogKind.doctors:
          res = await _doctors!.book(id.toInt(), notes: noteCtrl.text);
        case CatalogKind.marketplace:
        case CatalogKind.lawyers:
          res = await _marketplace!.book(id.toInt(), note: noteCtrl.text);
        case CatalogKind.fitness:
          res = await _fitness!.book(id.toInt(), note: noteCtrl.text);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['success'] == true
                ? (res['message']?.toString() ?? 'Booking requested')
                : (res['error']?.toString() ?? 'Booking failed'),
          ),
        ),
      );
      if (res['success'] == true) {
        _tabs.animateTo(1);
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  List<DateTime> _doctorDateOptions(Map<String, dynamic> item) {
    final daysRaw = item['availableDays']?.toString() ?? '';
    final allowed = daysRaw
        .split(RegExp(r'[,|]'))
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toSet();
    final out = <DateTime>[];
    final now = DateTime.now();
    for (var i = 1; i <= 14 && out.length < 7; i++) {
      final d = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      if (allowed.isEmpty ||
          allowed.any((a) =>
              a.contains(_weekdayName(d.weekday).toLowerCase()) ||
              a == _weekdayShort(d.weekday).toLowerCase())) {
        out.add(d);
      }
    }
    if (out.isEmpty) {
      for (var i = 1; i <= 7; i++) {
        final d = DateTime(now.year, now.month, now.day).add(Duration(days: i));
        out.add(d);
      }
    }
    return out;
  }

  String _weekdayName(int weekday) {
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[weekday - 1];
  }

  String _weekdayShort(int weekday) {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday - 1];
  }

  List<TimeOfDay> _doctorTimeOptions(Map<String, dynamic> item) {
    final start = _parseClock(item['startTime']?.toString());
    final end = _parseClock(item['endTime']?.toString());
    if (start != null && end != null && (end.hour * 60 + end.minute) > (start.hour * 60 + start.minute)) {
      final slots = <TimeOfDay>[];
      var mins = start.hour * 60 + start.minute;
      final endMins = end.hour * 60 + end.minute;
      while (mins + 30 <= endMins) {
        slots.add(TimeOfDay(hour: mins ~/ 60, minute: mins % 60));
        mins += 60;
      }
      if (slots.isNotEmpty) return slots;
    }
    // Fallback ranges when schedule text is free-form (e.g. "9:00 AM – 1:00 PM, …")
    final slotsText = '${item['startTime'] ?? ''} ${item['endTime'] ?? ''}'.toLowerCase();
    if (slotsText.contains('6:00') || slotsText.contains('8:00 pm') || slotsText.contains('evening')) {
      return const [
        TimeOfDay(hour: 9, minute: 0),
        TimeOfDay(hour: 11, minute: 0),
        TimeOfDay(hour: 14, minute: 0),
        TimeOfDay(hour: 16, minute: 0),
        TimeOfDay(hour: 18, minute: 0),
        TimeOfDay(hour: 19, minute: 0),
      ];
    }
    return const [
      TimeOfDay(hour: 9, minute: 0),
      TimeOfDay(hour: 10, minute: 0),
      TimeOfDay(hour: 11, minute: 0),
      TimeOfDay(hour: 14, minute: 0),
      TimeOfDay(hour: 15, minute: 0),
      TimeOfDay(hour: 16, minute: 0),
    ];
  }

  TimeOfDay? _parseClock(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final m = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(raw.trim());
    if (m == null) return null;
    final h = int.tryParse(m.group(1)!);
    final min = int.tryParse(m.group(2)!);
    if (h == null || min == null || h > 23 || min > 59) return null;
    return TimeOfDay(hour: h, minute: min);
  }

  String _formatAppt(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:00';
  }

  Future<void> _bookDoctor(Map<String, dynamic> item) async {
    final id = item['id'];
    if (id is! num) return;

    // Prefer freshest schedule from detail API
    Map<String, dynamic> doctor = Map<String, dynamic>.from(item);
    try {
      final detail = await _doctors!.detail(id.toInt());
      if (detail['success'] == true && detail['doctor'] is Map) {
        doctor = Map<String, dynamic>.from(detail['doctor'] as Map);
      }
    } catch (_) {}

    if (!mounted) return;
    final noteCtrl = TextEditingController();
    final dates = _doctorDateOptions(doctor);
    final times = _doctorTimeOptions(doctor);
    if (dates.isEmpty || times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No available slots for this doctor')),
      );
      return;
    }
    DateTime selectedDate = dates.first;
    TimeOfDay selectedTime = times.first;
    String consultType = 'CLINIC';
    final feeRaw = doctor['consultationFee'] ?? item['consultationFee'];
    final fee = feeRaw is num ? feeRaw.toDouble() : double.tryParse('$feeRaw') ?? 0.0;
    final isPaid = fee > 0;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(isPaid ? 'Book & Pay' : 'Book ${_title(doctor)}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_specialty(doctor).isNotEmpty)
                  Text(_specialty(doctor), style: const TextStyle(color: ModuleTheme.primary, fontWeight: FontWeight.w700)),
                if (isPaid) ...[
                  const SizedBox(height: 8),
                  Text('Consultation fee: ₹${fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: consultType,
                  decoration: const InputDecoration(labelText: 'Consultation mode', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'CLINIC', child: Text('In Clinic')),
                    DropdownMenuItem(value: 'VIDEO', child: Text('Video')),
                    DropdownMenuItem(value: 'ONLINE', child: Text('Online')),
                    DropdownMenuItem(value: 'OFFLINE', child: Text('Home Visit')),
                  ],
                  onChanged: (v) => setLocal(() => consultType = v ?? 'CLINIC'),
                ),
                const SizedBox(height: 12),
                const Text('Date', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: dates.map((d) {
                    final on = selectedDate.year == d.year && selectedDate.month == d.month && selectedDate.day == d.day;
                    return ChoiceChip(
                      label: Text('${_weekdayShort(d.weekday)} ${d.day}/${d.month}'),
                      selected: on,
                      onSelected: (_) => setLocal(() => selectedDate = d),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: times.map((t) {
                    final on = selectedTime.hour == t.hour && selectedTime.minute == t.minute;
                    final label = MaterialLocalizations.of(ctx).formatTimeOfDay(t);
                    return ChoiceChip(
                      label: Text(label),
                      selected: on,
                      onSelected: (_) => setLocal(() => selectedTime = t),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notes / reason (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isPaid ? 'Pay with Razorpay' : 'Request booking'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;

    final appt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final apptStr = _formatAppt(appt);
    final reason = noteCtrl.text.trim();

    if (isPaid) {
      await _startDoctorPayment(
        doctorId: id.toInt(),
        amount: fee,
        consultType: consultType,
        reason: reason,
        doctorName: _title(doctor),
        appointmentTime: apptStr,
      );
      return;
    }

    try {
      final res = await _doctors!.book(
        id.toInt(),
        notes: reason,
        reason: reason,
        appointmentTime: apptStr,
        consultationType: consultType,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['success'] == true
                ? (res['message']?.toString() ?? 'Booking requested')
                : (res['error']?.toString() ?? 'Booking failed'),
          ),
        ),
      );
      if (res['success'] == true) {
        _tabs.animateTo(1);
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<void> _startDoctorPayment({
    required int doctorId,
    required double amount,
    required String consultType,
    required String reason,
    required String doctorName,
    required String appointmentTime,
  }) async {
    _pendingDoctorId = doctorId;
    _pendingDoctorAmount = amount;
    _pendingConsultType = consultType;
    _pendingReason = reason;
    _pendingApptTime = appointmentTime;

    final orderRes = await _payments.createOrder(amount);
    if (!mounted) return;
    if (orderRes['orderId'] == null || orderRes['key'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orderRes['error']?.toString() ??
                'Payment gateway unavailable. Restart backend with local profile (Razorpay keys).',
          ),
        ),
      );
      return;
    }

    _razorpay.open({
      'key': orderRes['key'],
      'amount': orderRes['amount'],
      'currency': orderRes['currency'] ?? 'INR',
      'order_id': orderRes['orderId'],
      'name': 'Fight D Fear Medical',
      'description': 'Consultation with $doctorName',
      'theme': {'color': '#F43F5E'},
    });
  }

  Future<void> _onDoctorPaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final verify = await _payments.verify({
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'DOCTOR',
        'targetId': _pendingDoctorId,
        'amount': _pendingDoctorAmount,
        'appointmentTime': _pendingApptTime,
        'consultationType': _pendingConsultType,
        'reason': _pendingReason,
      });
      if (!mounted) return;
      if (verify['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verify['error'].toString())));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful — appointment booked')),
      );
      _tabs.animateTo(1);
      await _loadBookings();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
      }
    }
  }

  void _onDoctorPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Payment cancelled or failed')),
    );
  }

  Future<void> _showProfile(Map<String, dynamic> item) async {
    final doctorId = item['id'] is num ? (item['id'] as num).toInt() : int.tryParse('${item['id']}');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DetailListingCard(
                  title: _title(item),
                  eyebrow: _specialty(item),
                  location: _location(item),
                  photoUrl: _photo(item),
                  tags: _tags(item),
                  phone: item['phone']?.toString(),
                  onChat: widget.kind == CatalogKind.doctors && doctorId != null
                      ? () {
                          Navigator.pop(ctx);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DoctorChatScreen(
                                api: context.read<AuthState>().api,
                                doctorId: doctorId,
                                title: 'Chat · ${_title(item)}',
                              ),
                            ),
                          );
                        }
                      : null,
                  onVideo: widget.kind == CatalogKind.doctors
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book a VIDEO/ONLINE slot, then join from My Bookings')),
                          );
                        }
                      : null,
                  onPrimary: () {
                    Navigator.pop(ctx);
                    _bookItem(item);
                  },
                ),
                if (item['email'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Email: ${item['email']}', style: const TextStyle(color: ModuleTheme.textGray)),
                ],
                if (item['availableDays'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Days: ${item['availableDays']}', style: const TextStyle(color: ModuleTheme.textGray)),
                ],
                if (item['description'] != null) ...[
                  const SizedBox(height: 8),
                  Text(item['description'].toString()),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showBookingDetails(Map<String, dynamic> b) async {
    if (widget.kind != CatalogKind.doctors) return;
    final id = b['id'] is num ? (b['id'] as num).toInt() : int.tryParse('${b['id']}');
    final nested = b['doctor'];
    final doctor = nested is Map ? Map<String, dynamic>.from(nested) : <String, dynamic>{};
    final doctorId = doctor['id'] is num ? (doctor['id'] as num).toInt() : int.tryParse('${doctor['id']}');
    final status = b['status']?.toString() ?? '';
    final canCancel = b['canCancel'] == true;
    final canReview = b['canReview'] == true;
    final type = b['consultationType']?.toString() ?? '';
    final canJoin = type == 'VIDEO' || type == 'ONLINE' || (b['meetingRoomId']?.toString().isNotEmpty == true);
    final prescription = b['prescriptionText']?.toString();

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(doctor['fullName']?.toString() ?? 'Appointment', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: $status'),
            Text('When: ${b['appointmentTime'] ?? '—'}'),
            Text('Mode: ${type.isEmpty ? '—' : type}'),
            if (b['amountPaid'] != null) Text('Paid: ₹${b['amountPaid']}'),
            if (b['reason'] != null) Text('Reason: ${b['reason']}'),
            if (prescription != null && prescription.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Prescription', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(prescription),
            ],
            const SizedBox(height: 12),
            if (doctorId != null)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DoctorChatScreen(
                        api: context.read<AuthState>().api,
                        doctorId: doctorId,
                        title: 'Chat · ${doctor['fullName'] ?? 'Doctor'}',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat with doctor'),
              ),
            if (canJoin && id != null)
              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  openDoctorJitsi(context, context.read<AuthState>().api, id, audioOnly: false);
                },
                icon: const Icon(Icons.videocam_outlined),
                label: const Text('Join video call'),
              ),
            if (canReview && doctorId != null)
              FilledButton.tonalIcon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await showDoctorReviewDialog(
                    context,
                    service: _doctors!,
                    doctorId: doctorId,
                    onDone: _loadBookings,
                  );
                },
                icon: const Icon(Icons.star_outline),
                label: const Text('Leave a review'),
              ),
            if (canCancel && id != null)
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Cancel appointment?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Keep')),
                        FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Cancel booking')),
                      ],
                    ),
                  );
                  if (confirm != true) return;
                  final res = await _doctors!.cancelAppointment(id);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        res['success'] == true
                            ? (res['message']?.toString() ?? 'Cancelled')
                            : (res['error']?.toString() ?? 'Cancel failed'),
                      ),
                    ),
                  );
                  if (res['success'] == true) _loadBookings();
                },
                child: const Text('Cancel appointment', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        bottom: TabBar(
          controller: _tabs,
          labelColor: ModuleTheme.primary,
          unselectedLabelColor: ModuleTheme.textGray,
          tabs: const [
            Tab(text: 'Browse'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _loading
              ? ModuleTheme.loading()
              : _error != null
                  ? ModuleTheme.errorView(_error!, _loadList)
                  : RefreshIndicator(
                      onRefresh: _loadList,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Search by name, specialization, or city…',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                          ),
                          CategoryPillBar(
                            options: _categories,
                            selected: _category,
                            onSelected: (v) => setState(() => _category = v),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16, color: ModuleTheme.textGray),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Showing ${filtered.length} $_noun',
                                    style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Center(child: Text('Nothing listed yet.')),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: filtered.map((item) {
                                  return DetailListingCard(
                                    title: _title(item),
                                    eyebrow: _specialty(item),
                                    location: _location(item),
                                    photoUrl: _photo(item),
                                    tags: _tags(item),
                                    phone: item['phone']?.toString(),
                                    onPrimary: () => _showProfile(item),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
          _loadingBookings
              ? ModuleTheme.loading()
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: _bookings.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(child: Text('No bookings yet.')),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _bookings.length,
                          itemBuilder: (_, i) {
                            final b = _bookings[i];
                            final nested = b['doctor'] ?? b['provider'] ?? b['trainer'];
                            final nestedMap = nested is Map
                                ? Map<String, dynamic>.from(nested)
                                : <String, dynamic>{};
                            return DetailListingCard(
                              title: nestedMap['fullName']?.toString() ?? 'Booking',
                              eyebrow: b['status']?.toString() ?? 'PENDING',
                              location: nestedMap['locationText']?.toString() ??
                                  nestedMap['city']?.toString(),
                              photoUrl: ModuleTheme.mediaUrl(
                                context.read<AuthState>().api.baseUrl,
                                nestedMap['profilePhotoPath']?.toString(),
                              ),
                              tags: [
                                DetailTag(
                                  label: '${b['appointmentTime'] ?? b['requestedTime'] ?? b['bookingDate'] ?? 'Scheduled'}',
                                  icon: Icons.event,
                                ),
                                if (b['consultationType'] != null)
                                  DetailTag(label: '${b['consultationType']}', icon: Icons.medical_services_outlined),
                                if (b['reason'] != null || b['note'] != null)
                                  DetailTag(label: '${b['reason'] ?? b['note']}'),
                                if (b['prescriptionText'] != null)
                                  const DetailTag(label: 'Prescription ready', icon: Icons.medication_outlined),
                              ],
                              showMediaActions: false,
                              primaryLabel: 'Details',
                              onPrimary: () => _showBookingDetails(b),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
