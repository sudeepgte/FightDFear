import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/job_catalog.dart';
import '../../config/marketplace_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_theme.dart';
import 'marketplace_booking_chat_screen.dart';
import 'women_jobs_worker_detail_screen.dart';

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
  bool _busy = false;
  String? _error;
  String _workerCategory = 'all';
  final _cityFilter = TextEditingController();
  bool _availableToday = false;
  bool _doorOnly = false;
  bool _showFavorites = false;
  String _sort = 'rating';
  List<Map<String, dynamic>> _workers = [];
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _enrollments = [];
  List<({String value, String label, IconData icon})> _workerOptions =
      JobCatalog.browseFilters;

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
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) {
        _loadBookings();
      } else if (_tabs.index == 2) {
        _loadEnrollments();
      }
    });
    _loadInitial();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _cityFilter.dispose();
    _tabs.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }


  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final catRes = await _market.categories();
      if (catRes['success'] == true) {
        final wCats = ModuleTheme.toList(catRes['workerCategories']);
        if (wCats.isNotEmpty) {
          _workerOptions = [
            const (value: 'all', label: 'All Workers', icon: Icons.grid_view_rounded),
            ...wCats.map((c) {
              final value = c['value']?.toString() ?? c['code']?.toString() ?? '';
              return (
                value: value,
                label: c['label']?.toString() ?? JobCatalog.labelFor(value),
                icon: Icons.work_outline,
              );
            }).where((c) => c.value.isNotEmpty),
          ];
        }
      }
      await _loadWorkers();
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadWorkers() async {
    final res = _showFavorites
        ? await _market.jobFavorites()
        : await _market.workers(
            category: _workerCategory,
            city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
            availableToday: _availableToday ? true : null,
            doorService: _doorOnly ? true : null,
            sort: _sort,
          );
    if (res['success'] == true) {
      _workers = ModuleTheme.toList(res['workers']);
    } else {
      _error = res['error']?.toString();
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadBookings() async {
    try {
      final res = await _market.myBookings();
      if (res['success'] == true) {
        _bookings = ModuleTheme.toList(res['allBookings']);
      } else if (mounted) {
        _snack(res['error']?.toString() ?? 'Could not load bookings');
      }
    } catch (e) {
      if (mounted) _snack('$e');
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadEnrollments() async {
    try {
      final res = await _market.myEnrollments();
      if (res['success'] == true) {
        _enrollments = ModuleTheme.toList(res['enrollments']);
      } else if (mounted) {
        _snack(res['error']?.toString() ?? 'Could not load classes');
      }
    } catch (e) {
      if (mounted) _snack('$e');
    }
    if (mounted) setState(() {});
  }


  Future<void> _payEnrollment(int enrollmentId, double price) async {
    _pendingEnrollmentId = enrollmentId;
    _pendingWorkerBookingId = null;
    final order = await _payments.createOrder(price);
    if (!mounted) return;
    if (order['orderId'] == null) {
      _snack(order['error']?.toString() ?? 'Payment unavailable');
      await _cancelPendingEnrollment('Payment could not be started. Seat released.');
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

  Future<void> _cancelPendingEnrollment(String message) async {
    final id = _pendingEnrollmentId;
    _pendingEnrollmentId = null;
    if (id == null) return;
    try {
      final res = await _market.cancelEnrollment(id);
      if (mounted) {
        final extra = res['success'] == true
            ? ''
            : ' (${res['error'] ?? 'could not release seat automatically'})';
        _snack('$message$extra');
        _loadEnrollments();
      }
    } catch (e) {
      if (mounted) {
        _snack('$message ($e)');
        _loadEnrollments();
      }
    }
  }

  void _openWorker(Map<String, dynamic> worker) {
    final id = worker['id'] is int ? worker['id'] as int : int.tryParse('${worker['id']}');
    if (id == null) return;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WomenJobsWorkerDetailScreen(workerId: id)))
        .then((_) => _loadWorkers());
  }

  Future<void> _cancelWorkerBooking(Map<String, dynamic> booking) async {
    final id = booking['id'] is int ? booking['id'] as int : int.tryParse('${booking['id']}');
    if (id == null) return;
    final res = await _market.cancelWorkerBooking(id);
    if (!mounted) return;
    _snack(res['success'] == true
        ? (res['message']?.toString() ?? 'Cancelled')
        : (res['error']?.toString() ?? 'Cancel failed'));
    if (res['success'] == true) _loadBookings();
  }

  Future<void> _payWorkerBooking(Map<String, dynamic> booking) async {
    if (_busy) return;
    final id = booking['id'] is int ? booking['id'] as int : int.tryParse('${booking['id']}');
    final amount = (booking['totalAmount'] is num) ? (booking['totalAmount'] as num).toDouble() : 0.0;
    if (id == null || amount <= 0) return;
    _pendingWorkerBookingId = id;
    _pendingEnrollmentId = null;
    final order = await _payments.createOrder(amount);
    if (order['orderId'] == null) {
      _snack(order['error']?.toString() ?? 'Payment unavailable');
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
      _snack(verify['error'].toString());
      if (_pendingEnrollmentId != null) {
        await _cancelPendingEnrollment('Payment verification failed. Seat released.');
      }
      return;
    }
    _snack('Payment successful');
    _pendingWorkerBookingId = null;
    _pendingEnrollmentId = null;
    _loadBookings();
    _loadEnrollments();
  }

  void _onPaymentError(PaymentFailureResponse response) {
    final msg = response.message ?? 'Payment cancelled/failed';
    if (_pendingEnrollmentId != null) {
      _cancelPendingEnrollment('$msg. Your seat was released.');
      return;
    }
    _snack(msg);
  }

  void _showBookingDetail(Map<String, dynamic> b) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(b['kind'] == 'WORKER' ? 'Worker booking' : 'Provider booking',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Status: ${b['status'] ?? 'PENDING'}'),
            Text('When: ${b['bookingDate'] ?? b['requestedTime'] ?? '—'}'),
            if ((b['note']?.toString() ?? '').isNotEmpty) Text('Note: ${b['note']}'),
            if ((b['cancelPolicy']?.toString() ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(b['cancelPolicy'].toString(),
                  style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray)),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (b['kind'] == 'WORKER' &&
                    !['COMPLETED', 'CANCELLED', 'REJECTED', 'PAID']
                        .contains((b['status']?.toString() ?? '').toUpperCase()))
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _cancelWorkerBooking(b);
                    },
                    child: const Text('Cancel booking'),
                  ),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
              ],
            ),
          ],
        ),
      ),
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
                    _workersView(),
                    _bookingsView(),
                    _classesView(),
                  ],
                ),
    );
  }

  Widget _empty(String text) => ListView(children: [
        const SizedBox(height: 120),
        Center(child: Text(text, style: const TextStyle(color: ModuleTheme.textGray))),
      ]);

  Widget _workersView() {
    return RefreshIndicator(
      onRefresh: _loadWorkers,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 10),
          CategoryPillBar(
            options: _workerOptions,
            selected: _workerCategory,
            onSelected: (v) async {
              setState(() {
                _workerCategory = v;
                _showFavorites = false;
              });
              await _loadWorkers();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _cityFilter,
              decoration: InputDecoration(
                hintText: 'City',
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _loadWorkers),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _loadWorkers(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Wrap(
              spacing: 6,
              children: [
                FilterChip(
                  label: const Text('Available today'),
                  selected: _availableToday,
                  onSelected: (v) {
                    setState(() => _availableToday = v);
                    _loadWorkers();
                  },
                ),
                FilterChip(
                  label: const Text('Door service'),
                  selected: _doorOnly,
                  onSelected: (v) {
                    setState(() => _doorOnly = v);
                    _loadWorkers();
                  },
                ),
                FilterChip(
                  label: const Text('Favourites'),
                  selected: _showFavorites,
                  onSelected: (v) {
                    setState(() => _showFavorites = v);
                    _loadWorkers();
                  },
                ),
                ChoiceChip(
                  label: const Text('Top rated'),
                  selected: _sort == 'rating',
                  onSelected: (_) {
                    setState(() => _sort = 'rating');
                    _loadWorkers();
                  },
                ),
                ChoiceChip(
                  label: const Text('Fee'),
                  selected: _sort == 'fee',
                  onSelected: (_) {
                    setState(() => _sort = 'fee');
                    _loadWorkers();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Showing ${_workers.length} verified workers · book up to 60 days ahead',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
            ),
          ),
          if (_workers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No verified workers in this category yet.')),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: _workers.map((w) {
                  return DetailListingCard(
                    title: w['workerName']?.toString() ?? 'Worker',
                    eyebrow: JobCatalog.labelFor(w['jobCategory']?.toString()),
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
                      if (w['nextSlotLabel'] != null)
                        DetailTag(label: '${w['nextSlotLabel']}', icon: Icons.schedule),
                      if (w['availableToday'] == true)
                        const DetailTag(label: 'Today', icon: Icons.today_outlined),
                    ],
                    onPrimary: () => _openWorker(w),
                    primaryLabel: 'View & Book',
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
          ? _empty('No marketplace bookings yet')
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
                      DetailTag(label: JobCatalog.labelFor(worker['jobCategory']?.toString())),
                      if (b['totalAmount'] != null)
                        DetailTag(
                          label: '₹${b['totalAmount']}',
                          icon: Icons.currency_rupee,
                          background: const Color(0xFFDCFCE7),
                          foreground: const Color(0xFF166534),
                        ),
                    ],
                    primaryLabel: payable ? 'Pay now' : 'Details',
                    onPrimary: payable ? () => _payWorkerBooking(b) : () => _showBookingDetail(b),
                    showMediaActions: false,
                  );
                }
                final provider = b['provider'] is Map
                    ? Map<String, dynamic>.from(b['provider'] as Map)
                    : <String, dynamic>{};
                final confirmed = (b['status']?.toString().toUpperCase() == 'CONFIRMED');
                final bookingId = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                return DetailListingCard(
                  title: provider['fullName']?.toString() ?? 'Provider Booking',
                  eyebrow: b['status']?.toString() ?? 'PENDING',
                  location: b['requestedTime']?.toString(),
                  phone: provider['phone']?.toString(),
                  tags: [
                    DetailTag(label: MarketplaceCatalog.labelFor(provider['category']?.toString())),
                    if (b['note'] != null && '${b['note']}'.isNotEmpty)
                      DetailTag(label: '${b['note']}', icon: Icons.notes),
                  ],
                  primaryLabel: confirmed ? 'Chat' : 'Details',
                  onPrimary: confirmed && bookingId != null
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MarketplaceBookingChatScreen(
                              bookingId: bookingId,
                              asProvider: false,
                              peerName: provider['fullName']?.toString(),
                            ),
                          ));
                        }
                      : () => _showBookingDetail(b),
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
          ? _empty('No class enrollments yet')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _enrollments.length,
              itemBuilder: (_, i) {
                final e = _enrollments[i];
                final classItem = e['classItem'] is Map
                    ? Map<String, dynamic>.from(e['classItem'] as Map)
                    : <String, dynamic>{};
                final paymentStatus = e['paymentStatus']?.toString() ?? '';
                final status = e['status']?.toString() ?? '';
                final needsPay = paymentStatus.toUpperCase() == 'PENDING' &&
                    status.toUpperCase() != 'CANCELLED';
                final enrollmentId = e['id'] is int ? e['id'] as int : int.tryParse('${e['id']}');
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
                  primaryLabel: needsPay ? 'Pay or cancel' : 'Details',
                  onPrimary: needsPay && enrollmentId != null
                      ? () async {
                          final action = await showModalBottomSheet<String>(
                            context: context,
                            builder: (ctx) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.payments_outlined),
                                    title: const Text('Pay now'),
                                    onTap: () => Navigator.pop(ctx, 'pay'),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.cancel_outlined),
                                    title: const Text('Cancel enrollment'),
                                    onTap: () => Navigator.pop(ctx, 'cancel'),
                                  ),
                                ],
                              ),
                            ),
                          );
                          if (action == 'pay') {
                            await _payEnrollment(enrollmentId, price);
                          } else if (action == 'cancel') {
                            final res = await _market.cancelEnrollment(enrollmentId);
                            _snack(res['success'] == true
                                ? 'Enrollment cancelled. Seat released.'
                                : (res['error']?.toString() ?? 'Cancel failed'));
                            _loadEnrollments();
                          }
                        }
                      : () {},
                  showMediaActions: false,
                );
              },
            ),
    );
  }
}
