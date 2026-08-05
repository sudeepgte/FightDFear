import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/auth_state.dart';
import '../services/module_services.dart';
import '../services/payment_service.dart';
import '../widgets/detail_listing_card.dart';
import '../widgets/module_theme.dart';

class WomenMarketplaceScreen extends StatefulWidget {
  const WomenMarketplaceScreen({super.key});

  @override
  State<WomenMarketplaceScreen> createState() => _WomenMarketplaceScreenState();
}

class _WomenMarketplaceScreenState extends State<WomenMarketplaceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final MarketplaceService _market;
  late final PaymentService _payments;
  late final Razorpay _razorpay;

  bool _loading = true;
  String? _error;
  String _providerCategory = 'all';
  String _workerCategory = '';
  List<Map<String, dynamic>> _providers = [];
  List<Map<String, dynamic>> _workers = [];
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _enrollments = [];
  List<({String value, String label, IconData icon})> _providerOptions = const [
    (value: 'all', label: 'All Providers', icon: Icons.grid_view_rounded),
  ];
  List<({String value, String label, IconData icon})> _workerOptions = const [];

  int? _pendingWorkerBookingId;
  int? _pendingEnrollmentId;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _market = MarketplaceService(api);
    _payments = PaymentService(api);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 2) {
        _loadBookings();
      } else if (_tabs.index == 3) {
        _loadEnrollments();
      }
    });
    _loadInitial();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final catRes = await _market.categories();
      if (catRes['success'] == true) {
        final pCats = ModuleTheme.toList(catRes['providerCategories']);
        final wCats = ModuleTheme.toList(catRes['workerCategories']);
        _providerOptions = [
          const (value: 'all', label: 'All Providers', icon: Icons.grid_view_rounded),
          ...pCats.map((c) {
            final value = c['value']?.toString() ?? '';
            return (
              value: value,
              label: c['label']?.toString() ?? value,
              icon: _providerIcon(value),
            );
          }),
        ];
        _workerOptions = wCats
            .map((c) => (
                  value: c['value']?.toString() ?? '',
                  label: c['label']?.toString() ?? '',
                  icon: Icons.work_outline,
                ))
            .where((c) => c.value.isNotEmpty)
            .toList();
        if (_workerCategory.isEmpty && _workerOptions.isNotEmpty) {
          _workerCategory = _workerOptions.first.value;
        }
      }
      await _loadProviders();
      await _loadWorkers();
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  IconData _providerIcon(String value) {
    return switch (value) {
      'TUTOR' => Icons.school_outlined,
      'HOME_BAKER' => Icons.cake_outlined,
      'LANGUAGE_TRAINER' => Icons.translate_outlined,
      'WOMEN_PRODUCTS' => Icons.shopping_bag_outlined,
      'WOMEN_LAWYER' => Icons.gavel_outlined,
      'FITNESS_ZUMBA' => Icons.fitness_center,
      _ => Icons.storefront_outlined,
    };
  }

  Future<void> _loadProviders() async {
    final res = await _market.providers(
      category: _providerCategory == 'all' ? null : _providerCategory,
    );
    if (res['success'] == true) {
      _providers = ModuleTheme.toList(res['providers']);
    } else {
      _error = res['error']?.toString();
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadWorkers() async {
    if (_workerCategory.isEmpty) {
      _workers = [];
      if (mounted) setState(() {});
      return;
    }
    final res = await _market.workers(_workerCategory);
    if (res['success'] == true) {
      _workers = ModuleTheme.toList(res['workers']);
    } else {
      _error = res['error']?.toString();
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadBookings() async {
    final res = await _market.myBookings();
    if (res['success'] == true) {
      _bookings = ModuleTheme.toList(res['allBookings']);
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadEnrollments() async {
    final res = await _market.myEnrollments();
    if (res['success'] == true) {
      _enrollments = ModuleTheme.toList(res['enrollments']);
    }
    if (mounted) setState(() {});
  }

  Future<void> _bookProvider(Map<String, dynamic> provider) async {
    final id = provider['id'] is int ? provider['id'] as int : int.tryParse('${provider['id']}');
    if (id == null) return;
    final noteCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${provider['fullName'] ?? 'Provider'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(
                labelText: 'Requested time (yyyy-MM-ddTHH:mm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Request')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await _market.book(
      id,
      note: noteCtrl.text.trim(),
      requestedTime: dateCtrl.text.trim().isEmpty ? null : dateCtrl.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Booking requested' : '${res['error']}')),
    );
    if (res['success'] == true) {
      _tabs.animateTo(2);
      _loadBookings();
    }
  }

  Future<void> _openProviderDetail(Map<String, dynamic> provider) async {
    final id = provider['id'] is int ? provider['id'] as int : int.tryParse('${provider['id']}');
    if (id == null) return;
    final detail = await _market.providerDetail(id);
    if (!mounted) return;
    if (detail['success'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${detail['error'] ?? 'Unable to load details'}')),
      );
      return;
    }
    final classes = ModuleTheme.toList(detail['classes']);
    final reviews = ModuleTheme.toList(detail['reviews']);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailListingCard(
                title: provider['fullName']?.toString() ?? 'Provider',
                eyebrow: provider['category']?.toString(),
                location: provider['locationText']?.toString(),
                phone: provider['phone']?.toString(),
                tags: [
                  if (provider['rating'] != null)
                    DetailTag(
                      label: '${provider['rating']}',
                      icon: Icons.star,
                      background: const Color(0xFFFEF3C7),
                      foreground: const Color(0xFFB45309),
                    ),
                ],
                onPrimary: () {
                  Navigator.pop(ctx);
                  _bookProvider(provider);
                },
                primaryLabel: 'Book Session',
              ),
              const SizedBox(height: 10),
              const Text('Classes', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              if (classes.isEmpty)
                const Text('No classes listed')
              else
                ...classes.map((c) => _classCard(c)),
              const SizedBox(height: 12),
              const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              if (reviews.isEmpty)
                const Text('No reviews yet')
              else
                ...reviews.take(5).map((r) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFFE4E6),
                        child: Text((r['userName']?.toString() ?? 'U').substring(0, 1)),
                      ),
                      title: Text(r['userName']?.toString() ?? 'User'),
                      subtitle: Text(r['comment']?.toString() ?? ''),
                      trailing: Text('${r['rating'] ?? '-'}★'),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _classCard(Map<String, dynamic> c) {
    final id = c['id'] is int ? c['id'] as int : int.tryParse('${c['id']}');
    final price = (c['price'] is num) ? (c['price'] as num).toDouble() : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(c['className']?.toString() ?? 'Class', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('${c['dateTime'] ?? ''} · ${c['mode'] ?? ''}', style: const TextStyle(color: ModuleTheme.textGray)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              DetailTag(label: '₹${price.toStringAsFixed(0)}', icon: Icons.currency_rupee),
              DetailTag(label: '${c['availableSeats'] ?? 0} seats', icon: Icons.groups),
            ].map((t) => _tagChip(t)).toList(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: id == null ? null : () => _enrollClass(id, price),
              child: Text(price > 0 ? 'Enroll & Pay' : 'Enroll'),
            ),
          )
        ],
      ),
    );
  }

  Widget _tagChip(DetailTag t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: t.background, borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (t.icon != null) ...[
          Icon(t.icon, size: 13, color: t.foreground),
          const SizedBox(width: 4),
        ],
        Text(t.label, style: TextStyle(color: t.foreground, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Future<void> _enrollClass(int classId, double price) async {
    final res = await _market.enrollClass(classId);
    if (!mounted) return;
    if (res['success'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${res['error']}')));
      return;
    }
    final enrollmentId = res['enrollmentId'] is int
        ? res['enrollmentId'] as int
        : int.tryParse('${res['enrollmentId']}');
    final paymentRequired = res['paymentRequired'] == true;
    if (!paymentRequired || enrollmentId == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enrolled successfully')));
      _tabs.animateTo(3);
      _loadEnrollments();
      return;
    }
    _pendingEnrollmentId = enrollmentId;
    final order = await _payments.createOrder(price);
    if (!mounted) return;
    if (order['orderId'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(order['error']?.toString() ?? 'Payment unavailable')),
      );
      return;
    }
    _razorpay.open({
      'key': order['key'],
      'amount': order['amount'],
      'currency': order['currency'] ?? 'INR',
      'name': 'Fight D Fear Marketplace',
      'description': 'Class Enrollment',
      'order_id': order['orderId'],
      'theme': {'color': '#F43F5E'},
    });
  }

  Future<void> _bookWorker(Map<String, dynamic> worker) async {
    final id = worker['id'] is int ? worker['id'] as int : int.tryParse('${worker['id']}');
    if (id == null) return;
    final dateCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '${worker['hourlyRate'] ?? 0}');
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Book ${worker['workerName'] ?? 'Worker'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(
                labelText: 'Booking time (yyyy-MM-ddTHH:mm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Book Worker')),
        ],
      ),
    );
    if (ok != true) return;
    final amount = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
    final res = await _market.bookWorker(
      id,
      bookingDate: dateCtrl.text.trim(),
      totalAmount: amount,
      note: noteCtrl.text.trim(),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Worker booking created' : '${res['error']}')),
    );
    if (res['success'] == true) {
      _tabs.animateTo(2);
      _loadBookings();
    }
  }

  Future<void> _payWorkerBooking(Map<String, dynamic> booking) async {
    final id = booking['id'] is int ? booking['id'] as int : int.tryParse('${booking['id']}');
    final amount = (booking['totalAmount'] is num)
        ? (booking['totalAmount'] as num).toDouble()
        : 0.0;
    if (id == null || amount <= 0) return;
    _pendingWorkerBookingId = id;
    _pendingEnrollmentId = null;
    final order = await _payments.createOrder(amount);
    if (order['orderId'] == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(order['error']?.toString() ?? 'Payment unavailable')),
      );
      return;
    }
    _razorpay.open({
      'key': order['key'],
      'amount': order['amount'],
      'currency': order['currency'] ?? 'INR',
      'name': 'Fight D Fear Marketplace',
      'description': 'Worker booking payment',
      'order_id': order['orderId'],
      'theme': {'color': '#F43F5E'},
    });
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    Map<String, dynamic> payload = {
      'razorpay_order_id': response.orderId,
      'razorpay_payment_id': response.paymentId,
      'razorpay_signature': response.signature,
    };
    if (_pendingEnrollmentId != null) {
      payload = {
        ...payload,
        'type': 'MARKETPLACE',
        'enrollmentId': _pendingEnrollmentId,
      };
    } else if (_pendingWorkerBookingId != null) {
      payload = {
        ...payload,
        'type': 'WORKER_BOOKING',
        'targetId': _pendingWorkerBookingId,
      };
    } else {
      return;
    }
    final verify = await _payments.verify(payload);
    if (!mounted) return;
    if (verify['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(verify['error'].toString())),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful')),
    );
    _pendingWorkerBookingId = null;
    _pendingEnrollmentId = null;
    _loadBookings();
    _loadEnrollments();
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Payment cancelled/failed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Women Marketplace'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: ModuleTheme.primary,
          unselectedLabelColor: ModuleTheme.textGray,
          tabs: const [
            Tab(text: 'Providers'),
            Tab(text: 'Workers'),
            Tab(text: 'My Bookings'),
            Tab(text: 'My Classes'),
          ],
        ),
      ),
      body: _loading
          ? ModuleTheme.loading()
          : _error != null
              ? ModuleTheme.errorView(_error!, _loadInitial)
              : TabBarView(
                  controller: _tabs,
                  children: [
                    _providersView(),
                    _workersView(),
                    _bookingsView(),
                    _classesView(),
                  ],
                ),
    );
  }

  Widget _providersView() {
    return RefreshIndicator(
      onRefresh: _loadProviders,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 10),
          CategoryPillBar(
            options: _providerOptions,
            selected: _providerCategory,
            onSelected: (v) async {
              setState(() => _providerCategory = v);
              await _loadProviders();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Showing ${_providers.length} verified marketplace providers',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: _providers.map((p) {
                return DetailListingCard(
                  title: p['fullName']?.toString() ?? 'Provider',
                  eyebrow: p['category']?.toString() ?? 'Marketplace',
                  location: p['locationText']?.toString(),
                  phone: p['phone']?.toString(),
                  tags: [
                    if (p['rating'] != null)
                      DetailTag(
                        label: '${p['rating']}',
                        icon: Icons.star,
                        background: const Color(0xFFFEF3C7),
                        foreground: const Color(0xFFB45309),
                      ),
                  ],
                  onPrimary: () => _openProviderDetail(p),
                  primaryLabel: 'View Profile & Book',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _workersView() {
    return RefreshIndicator(
      onRefresh: _loadWorkers,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 10),
          if (_workerOptions.isNotEmpty)
            CategoryPillBar(
              options: _workerOptions,
              selected: _workerCategory,
              onSelected: (v) async {
                setState(() => _workerCategory = v);
                await _loadWorkers();
              },
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Showing ${_workers.length} verified workers',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: _workers.map((w) {
                return DetailListingCard(
                  title: w['workerName']?.toString() ?? 'Worker',
                  eyebrow: w['jobCategory']?.toString() ?? 'Worker',
                  location: w['location']?.toString(),
                  phone: w['phone']?.toString(),
                  tags: [
                    DetailTag(
                      label: '₹${w['hourlyRate'] ?? 0}/hr',
                      icon: Icons.currency_rupee,
                      background: const Color(0xFFE0E7FF),
                      foreground: const Color(0xFF3730A3),
                    ),
                    if (w['jobSubCategory'] != null)
                      DetailTag(label: '${w['jobSubCategory']}', icon: Icons.category_outlined),
                  ],
                  onPrimary: () => _bookWorker(w),
                  primaryLabel: 'Book Worker',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingsView() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: _bookings.isEmpty
          ? ListView(children: const [
              SizedBox(height: 120),
              Center(child: Text('No marketplace bookings yet')),
            ])
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _bookings.length,
              itemBuilder: (_, i) {
                final b = _bookings[i];
                if (b['kind'] == 'WORKER') {
                  final worker = b['worker'] is Map
                      ? Map<String, dynamic>.from(b['worker'] as Map)
                      : <String, dynamic>{};
                  final payable = (b['status']?.toString().toUpperCase() == 'ACCEPTED');
                  return DetailListingCard(
                    title: worker['workerName']?.toString() ?? 'Worker Booking',
                    eyebrow: b['status']?.toString() ?? 'PENDING',
                    location: b['bookingDate']?.toString(),
                    phone: worker['phone']?.toString(),
                    tags: [
                      DetailTag(label: worker['jobCategory']?.toString() ?? 'Worker'),
                      if (b['totalAmount'] != null)
                        DetailTag(
                          label: '₹${b['totalAmount']}',
                          icon: Icons.currency_rupee,
                          background: const Color(0xFFDCFCE7),
                          foreground: const Color(0xFF166534),
                        ),
                    ],
                    primaryLabel: payable ? 'Pay now' : 'Details',
                    onPrimary: payable ? () => _payWorkerBooking(b) : () {},
                    showMediaActions: false,
                  );
                }
                final provider = b['provider'] is Map
                    ? Map<String, dynamic>.from(b['provider'] as Map)
                    : <String, dynamic>{};
                return DetailListingCard(
                  title: provider['fullName']?.toString() ?? 'Provider Booking',
                  eyebrow: b['status']?.toString() ?? 'PENDING',
                  location: b['requestedTime']?.toString(),
                  phone: provider['phone']?.toString(),
                  tags: [
                    DetailTag(label: provider['category']?.toString() ?? 'Provider'),
                    if (b['note'] != null && '${b['note']}'.isNotEmpty)
                      DetailTag(label: '${b['note']}', icon: Icons.notes),
                  ],
                  primaryLabel: 'Details',
                  onPrimary: () {},
                  showMediaActions: false,
                );
              },
            ),
    );
  }

  Widget _classesView() {
    return RefreshIndicator(
      onRefresh: _loadEnrollments,
      child: _enrollments.isEmpty
          ? ListView(children: const [
              SizedBox(height: 120),
              Center(child: Text('No class enrollments yet')),
            ])
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _enrollments.length,
              itemBuilder: (_, i) {
                final e = _enrollments[i];
                final classItem = e['classItem'] is Map
                    ? Map<String, dynamic>.from(e['classItem'] as Map)
                    : <String, dynamic>{};
                final paymentStatus = e['paymentStatus']?.toString() ?? '';
                final needsPay = paymentStatus.toUpperCase() == 'PENDING';
                final classId = classItem['id'] is int
                    ? classItem['id'] as int
                    : int.tryParse('${classItem['id']}');
                final price = (classItem['price'] is num)
                    ? (classItem['price'] as num).toDouble()
                    : 0.0;
                return DetailListingCard(
                  title: classItem['className']?.toString() ?? 'Class',
                  eyebrow: paymentStatus,
                  location: classItem['dateTime']?.toString(),
                  tags: [
                    DetailTag(label: classItem['mode']?.toString() ?? 'Class'),
                    if (classItem['price'] != null)
                      DetailTag(
                        label: '₹${classItem['price']}',
                        icon: Icons.currency_rupee,
                        background: const Color(0xFFE0E7FF),
                        foreground: const Color(0xFF3730A3),
                      ),
                  ],
                  primaryLabel: needsPay ? 'Pay now' : 'Details',
                  onPrimary: needsPay && classId != null ? () => _enrollClass(classId, price) : () {},
                  showMediaActions: false,
                );
              },
            ),
    );
  }
}

