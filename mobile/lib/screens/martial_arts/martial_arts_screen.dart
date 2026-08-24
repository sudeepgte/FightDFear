import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/martial_arts_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import '../../services/martial_arts_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_payment_checkout.dart';
import 'martial_arts_admin_screen.dart';
import 'martial_arts_centre_dashboard_screen.dart';
import 'martial_arts_centre_login_screen.dart';
import 'martial_arts_centre_register_screen.dart';
import 'martial_arts_centre_screen.dart';
import 'martial_arts_qr_scanner_screen.dart';

/// Browse approved martial arts centres + My Trainings.
class MartialArtsScreen extends StatefulWidget {
  const MartialArtsScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<MartialArtsScreen> createState() => _MartialArtsScreenState();
}

class _MartialArtsScreenState extends State<MartialArtsScreen>
    with SingleTickerProviderStateMixin {
  late final MartialArtsService _api;
  late final CentreAuthService _centreAuth;
  late final PaymentService _payments;
  late final ModulePaymentCheckout _checkout;
  late final TabController _tabs;
  final _searchCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String? _styleFilter;
  String _sort = 'rating';
  bool _batchToday = false;
  bool _onlineOnly = false;
  double? _feeMax;

  bool _loading = true;
  bool _centreLoggedIn = false;
  String? _error;
  List<Map<String, dynamic>> _centres = [];
  List<Map<String, dynamic>> _enrollments = [];
  List<Map<String, dynamic>> _journey = [];
  Map<String, dynamic>? _attendance;
  Map<String, dynamic>? _onlineSections;

  @override
  void initState() {
    super.initState();
    _api = MartialArtsService(context.read<AuthState>().api);
    _centreAuth = CentreAuthService(context.read<AuthState>().api);
    _payments = PaymentService(context.read<AuthState>().api);
    _checkout = ModulePaymentCheckout(_payments);
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) => _checkout.handleError(r),
    );
    _tabs = TabController(length: 5, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      switch (_tabs.index) {
        case 1:
          _loadEnrollments();
        case 2:
          _loadJourney();
        case 3:
          _loadAttendance();
        case 4:
          _loadOnlineClasses();
      }
    });
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _centreLoggedIn = await _centreAuth.isLoggedIn();
    await _loadCentres();
  }

  Future<void> _refreshCentreLogin() async {
    _centreLoggedIn = await _centreAuth.isLoggedIn();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _checkout.dispose();
    _tabs.dispose();
    _searchCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: StatefulBuilder(
          builder: (ctx, setLocal) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Filters', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 12),
              TextField(
                controller: _cityCtrl,
                decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _styleFilter,
                decoration: const InputDecoration(labelText: 'Style', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any style')),
                  ...MartialArtsCatalog.styles.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                ],
                onChanged: (v) => setLocal(() => _styleFilter = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<double?>(
                initialValue: _feeMax,
                decoration: const InputDecoration(labelText: 'Max fee', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Any fee')),
                  DropdownMenuItem(value: 1000, child: Text('Under ₹1000')),
                  DropdownMenuItem(value: 2000, child: Text('Under ₹2000')),
                  DropdownMenuItem(value: 4000, child: Text('Under ₹4000')),
                ],
                onChanged: (v) => setLocal(() => _feeMax = v),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _loadCentres();
                },
                child: const Text('Apply'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _payEnrollment(Map<String, dynamic> e) async {
    final enrollmentId = e['enrollmentId'] is num ? (e['enrollmentId'] as num).toInt() : int.tryParse('${e['enrollmentId']}');
    final centreId = e['centreId'] is num ? (e['centreId'] as num).toInt() : int.tryParse('${e['centreId']}');
    final batchId = e['batchId'] is num ? (e['batchId'] as num).toInt() : int.tryParse('${e['batchId']}');
    final amount = (e['amount'] is num) ? (e['amount'] as num).toDouble() : double.tryParse('${e['fee'] ?? e['amount']}') ?? 0;
    if (enrollmentId == null || amount <= 0) return;
    await _checkout.pay(
      context: context,
      amount: amount,
      description: 'Martial Arts · ${e['batchName'] ?? 'Enrollment'}',
      createOrderFn: () => _payments.createOrder(
        amount,
        type: 'MARTIAL_ARTS',
        extra: {'enrollmentId': enrollmentId},
      ),
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'MARTIAL_ARTS',
        'enrollmentId': enrollmentId,
        if (centreId != null) 'centerId': centreId,
        if (batchId != null) 'batchId': batchId,
      },
      onSuccess: _loadEnrollments,
    );
  }

  Future<void> _loadCentres({String? q}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.listCentres(
        q: q ?? _searchCtrl.text,
        city: _cityCtrl.text,
        style: _styleFilter,
        feeMax: _feeMax,
        batchToday: _batchToday ? true : null,
        online: _onlineOnly ? true : null,
        sort: _sort,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['centres'];
        _centres = raw is List
            ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
      } else {
        _error = res['error']?.toString() ?? 'Could not load centres';
      }
    } catch (e) {
      if (mounted) _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadEnrollments() async {
    try {
      final res = await _api.myEnrollments();
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['enrollments'];
        setState(() {
          _enrollments = raw is List
              ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
              : [];
        });
      }
    } catch (_) {}
  }

  Future<void> _loadJourney() async {
    try {
      final res = await _api.trainingJourney();
      if (!mounted || res['success'] != true) return;
      setState(() {
        _journey = (res['trainings'] is List)
            ? (res['trainings'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
      });
    } catch (_) {}
  }

  Future<void> _loadAttendance() async {
    try {
      final res = await _api.myAttendance();
      if (!mounted || res['success'] != true) return;
      setState(() => _attendance = res);
    } catch (_) {}
  }

  Future<void> _loadOnlineClasses() async {
    try {
      final res = await _api.onlineClasses();
      if (!mounted || res['success'] != true) return;
      setState(() {
        _onlineSections = res['sections'] is Map
            ? Map<String, dynamic>.from(res['sections'] as Map)
            : null;
      });
    } catch (_) {}
  }

  Future<void> _downloadCert(int enrollmentId) async {
    try {
      final file = await _api.downloadCertificate(enrollmentId);
      if (file.statusCode != 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Certificate not available')),
          );
        }
        return;
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/${file.filename ?? 'certificate_$enrollmentId.pdf'}';
      await File(path).writeAsBytes(file.bytes);
      await OpenFile.open(path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  String _feeLabel(Map<String, dynamic> c) {
    final min = c['minFee'];
    final max = c['maxFee'];
    if (min == null && max == null) return 'Fee on request';
    final minN = (min is num) ? min.toDouble() : null;
    final maxN = (max is num) ? max.toDouble() : null;
    if (minN != null && minN <= 0 && (maxN == null || maxN <= 0)) return 'Free';
    if (minN != null && maxN != null && minN == maxN) {
      return minN <= 0 ? 'Free' : '₹${minN.toStringAsFixed(0)}';
    }
    if (minN != null && maxN != null) {
      return '₹${minN.toStringAsFixed(0)} – ₹${maxN.toStringAsFixed(0)}';
    }
    if (minN != null) return minN <= 0 ? 'Free' : 'From ₹${minN.toStringAsFixed(0)}';
    return 'Fee on request';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: MartialArtsScreen.navy,
        elevation: 0.5,
        title: const Text(
          'Martial Arts Centres',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'QR Check-in',
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MartialArtsQrScannerScreen()),
              );
              _loadAttendance();
            },
          ),
          IconButton(
            tooltip: 'Admin approval',
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MartialArtsAdminScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Centre portal',
            icon: const Icon(Icons.storefront_outlined),
            onPressed: () async {
              if (_centreLoggedIn) {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MartialArtsCentreDashboardScreen()),
                );
              } else {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
                );
              }
              await _refreshCentreLogin();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: MartialArtsScreen.primary,
          unselectedLabelColor: MartialArtsScreen.textGray,
          indicatorColor: MartialArtsScreen.primary,
          tabs: const [
            Tab(text: 'Explore'),
            Tab(text: 'Enrollments'),
            Tab(text: 'Journey'),
            Tab(text: 'Attendance'),
            Tab(text: 'Online'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildExplore(),
          _buildMyTrainings(),
          _buildJourney(),
          _buildAttendance(),
          _buildOnline(),
        ],
      ),
    );
  }

  Widget _buildExplore() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Martial arts & self-defence centre?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Karate, Taekwondo & similar — register here. For Gym or Zumba, use Fitness & Wellness.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_centreLoggedIn)
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MartialArtsCentreDashboardScreen()),
                          );
                          await _refreshCentreLogin();
                        },
                        child: const Text('My dashboard'),
                      )
                    else ...[
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MartialArtsCentreRegisterScreen()),
                          );
                        },
                        child: const Text('Register trainer'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: MartialArtsScreen.primary),
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
                          );
                          await _refreshCentreLogin();
                        },
                        child: const Text('Centre sign in'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            textInputAction: TextInputAction.search,
            onSubmitted: (v) => _loadCentres(q: v),
            decoration: InputDecoration(
              hintText: 'Search by name or location',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: _openFilters,
              ),
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
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Batch today'),
                selected: _batchToday,
                onSelected: (v) {
                  setState(() => _batchToday = v);
                  _loadCentres();
                },
              ),
              FilterChip(
                label: const Text('Online'),
                selected: _onlineOnly,
                onSelected: (v) {
                  setState(() => _onlineOnly = v);
                  _loadCentres();
                },
              ),
              ChoiceChip(
                label: Text('Sort: $_sort'),
                selected: true,
                onSelected: (_) {
                  setState(() {
                    _sort = _sort == 'rating' ? 'fee' : (_sort == 'fee' ? 'nearest' : 'rating');
                  });
                  _loadCentres();
                },
              ),
            ],
          ),
        ),
        if (!_loading && _error == null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${_centres.length} martial arts centres',
                style: const TextStyle(color: MartialArtsScreen.textGray, fontSize: 13),
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            color: MartialArtsScreen.primary,
            onRefresh: () => _loadCentres(q: _searchCtrl.text),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? ListView(
                        children: [
                          const SizedBox(height: 80),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () => _loadCentres(q: _searchCtrl.text),
                              child: const Text('Retry'),
                            ),
                          ),
                        ],
                      )
                    : _centres.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 100),
                              Center(
                                child: Text(
                                  'No approved centres found',
                                  style: TextStyle(color: MartialArtsScreen.textGray),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: _centres.length,
                            itemBuilder: (context, i) {
                              final c = _centres[i];
                              final id = c['id'] is int
                                  ? c['id'] as int
                                  : int.tryParse('${c['id']}') ?? 0;
                              final photo = _mediaUrl(c['profilePhoto']?.toString());
                              final styles = (c['styles'] is List)
                                  ? (c['styles'] as List).map((e) => e.toString()).toList()
                                  : <String>[];
                              final tags = <DetailTag>[
                                DetailTag(
                                  label: _feeLabel(c),
                                  icon: Icons.currency_rupee,
                                  background: const Color(0xFFE0E7FF),
                                  foreground: const Color(0xFF3730A3),
                                ),
                                if ((c['rating'] is num) && (c['rating'] as num) > 0)
                                  DetailTag(
                                    label: '${c['rating']}★',
                                    icon: Icons.star,
                                  ),
                                DetailTag(
                                  label: c['availabilityLabel']?.toString() ?? '${c['batchCount'] ?? 0} batches',
                                  icon: Icons.groups_outlined,
                                ),
                                if (c['trialAvailable'] == true)
                                  DetailTag(
                                    label: 'Trial',
                                    icon: Icons.event_available,
                                    background: const Color(0xFFDCFCE7),
                                    foreground: const Color(0xFF166534),
                                  ),
                                ...styles.take(2).map((s) => DetailTag(
                                      label: s,
                                      icon: Icons.sports_martial_arts,
                                      background: const Color(0xFFFFE4E6),
                                      foreground: MartialArtsScreen.primary,
                                    )),
                              ];
                              return DetailListingCard(
                                title: c['name']?.toString() ?? 'Centre',
                                eyebrow: 'Martial Arts Centre',
                                location: c['location']?.toString(),
                                photoUrl: photo.isEmpty ? null : photo,
                                tags: tags,
                                phone: c['phoneNumber']?.toString(),
                                showMediaActions: true,
                                primaryLabel: 'View Centre & Enroll',
                                onPrimary: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => MartialArtsCentreScreen(centreId: id),
                                    ),
                                  );
                                  if (_tabs.index == 1) _loadEnrollments();
                                },
                              );
                            },
                          ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyTrainings() {
    if (_enrollments.isEmpty) {
      return RefreshIndicator(
        color: MartialArtsScreen.primary,
        onRefresh: _loadEnrollments,
        child: ListView(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.fitness_center, size: 48, color: MartialArtsScreen.textGray),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'No enrollments yet',
                style: TextStyle(color: MartialArtsScreen.textGray),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _tabs.animateTo(0),
                child: const Text('Browse centres'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: MartialArtsScreen.primary,
      onRefresh: _loadEnrollments,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _enrollments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final e = _enrollments[i];
          final status = e['status']?.toString() ?? 'PENDING';
          final pay = e['paymentStatus']?.toString() ?? 'PENDING';
          final needsPay = e['paymentRequired'] == true;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['centreName']?.toString() ?? 'Centre',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: MartialArtsScreen.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${e['batchName'] ?? 'Batch'} · ${e['martialArtType'] ?? ''}',
                  style: const TextStyle(color: MartialArtsScreen.textGray),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(status, MartialArtsScreen.primary),
                    _chip(pay, needsPay ? Colors.orange : Colors.green),
                    if (e['mode'] != null) _chip('${e['mode']}', MartialArtsScreen.navy),
                  ],
                ),
                if (e['slot'] != null) ...[
                  const SizedBox(height: 8),
                  Text('Slot: ${e['slot']}', style: const TextStyle(fontSize: 13)),
                ],
                if (e['awaitingCentreReview'] == true) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Waiting for centre review. Payment unlocks after approval.',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
                if (needsPay) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Approved — payment pending (₹${e['amount'] ?? e['fee'] ?? 0}). Complete payment to activate enrollment.',
                    style: const TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => _payEnrollment(e),
                      style: FilledButton.styleFrom(backgroundColor: MartialArtsScreen.primary),
                      child: const Text('Pay now'),
                    ),
                  ),
                ],
                if (e['canCancel'] == true) ...[
                  const SizedBox(height: 8),
                  Text(e['cancelPolicy']?.toString() ?? MartialArtsCatalog.cancelPolicy,
                      style: const TextStyle(fontSize: 11, color: MartialArtsScreen.textGray)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final eid = e['enrollmentId'] is int
                            ? e['enrollmentId'] as int
                            : int.tryParse('${e['enrollmentId']}');
                        if (eid == null) return;
                        final res = await _api.cancelEnrollment(eid);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res['message']?.toString() ?? res['error']?.toString() ?? 'Done')),
                        );
                        if (res['success'] == true) _loadEnrollments();
                      },
                      child: const Text('Cancel enrollment'),
                    ),
                  ),
                ],
                if (e['certificateAvailable'] == true) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      final eid = e['enrollmentId'] is int
                          ? e['enrollmentId'] as int
                          : int.tryParse('${e['enrollmentId']}');
                      if (eid != null) _downloadCert(eid);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download certificate'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildJourney() {
    if (_journey.isEmpty) {
      return RefreshIndicator(
        color: MartialArtsScreen.primary,
        onRefresh: _loadJourney,
        child: ListView(
          children: const [
            SizedBox(height: 80),
            Center(child: Text('No active trainings', style: TextStyle(color: MartialArtsScreen.textGray))),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: MartialArtsScreen.primary,
      onRefresh: _loadJourney,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _journey.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final t = _journey[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['centreName']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Text('${t['batchName'] ?? ''} · ${t['martialArtType'] ?? ''}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: ((t['progress'] is num ? t['progress'] as num : 0).toDouble()) / 100,
                  color: MartialArtsScreen.primary,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 8),
                Text('Progress: ${t['progress'] ?? 0}% · Attendance: ${t['attendancePercentage'] ?? 0}%'),
                Text('Trainer: ${t['trainerName'] ?? 'N/A'} · Status: ${t['status'] ?? ''}'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendance() {
    final records = (_attendance?['records'] is List)
        ? (_attendance!['records'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : <Map<String, dynamic>>[];
    return RefreshIndicator(
      color: MartialArtsScreen.primary,
      onRefresh: _loadAttendance,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_attendance != null) ...[
            Row(
              children: [
                _statTile('Total', '${_attendance!['totalClasses'] ?? 0}'),
                _statTile('Present', '${_attendance!['presentCount'] ?? 0}'),
                _statTile('Rate', '${_attendance!['attendancePercentage'] ?? 0}%'),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MartialArtsQrScannerScreen()),
                );
                _loadAttendance();
              },
              style: FilledButton.styleFrom(backgroundColor: MartialArtsScreen.primary),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR to Check In'),
            ),
            const SizedBox(height: 16),
          ],
          if (records.isEmpty)
            const Center(child: Text('No attendance records yet'))
          else
            ...records.map((r) => ListTile(
                  title: Text(r['batchName']?.toString() ?? ''),
                  subtitle: Text('${r['date'] ?? ''} · ${r['mode'] ?? ''}'),
                  trailing: Text(r['status']?.toString() ?? ''),
                )),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: MartialArtsScreen.textGray)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildOnline() {
    final sections = _onlineSections ?? {};
    return RefreshIndicator(
      color: MartialArtsScreen.primary,
      onRefresh: _loadOnlineClasses,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final key in ['live', 'upcoming', 'invitations', 'completed'])
            if (sections[key] is List && (sections[key] as List).isNotEmpty) ...[
              Text(key.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...(sections[key] as List).whereType<Map>().map((raw) {
                final c = Map<String, dynamic>.from(raw);
                final idRaw = c['id'];
                final isBatch = idRaw is String && idRaw.startsWith('batch-');
                final classId = isBatch ? null : (idRaw is int ? idRaw : int.tryParse('$idRaw'));
                final link = c['meetingLink']?.toString();
                return Card(
                  child: ListTile(
                    title: Text(c['title']?.toString() ?? 'Class'),
                    subtitle: Text(
                      '${c['date'] ?? ''} · ${c['startTime'] ?? ''} · ${c['classStatus'] ?? ''}\n${c['joinHint'] ?? 'Join 5 min before class'}',
                    ),
                    isThreeLine: true,
                    trailing: (c['canJoin'] == true && link != null && link.isNotEmpty) || classId != null
                        ? IconButton(
                            icon: const Icon(Icons.video_call),
                            onPressed: () async {
                              if (classId != null) {
                                final join = await _api.joinOnlineClass(classId);
                                final jlink = join['meetingLink']?.toString() ?? link;
                                if (join['success'] == true && jlink != null && jlink.isNotEmpty) {
                                  await launchUrl(Uri.parse(jlink), mode: LaunchMode.externalApplication);
                                  return;
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(join['error']?.toString() ?? c['joinHint']?.toString() ?? 'Join window closed')),
                                  );
                                }
                                return;
                              }
                              if (link != null && link.isNotEmpty) {
                                await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
                              }
                            },
                          )
                        : (key == 'invitations'
                            ? IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () async {
                                  final iid = c['invitationId'] is int
                                      ? c['invitationId'] as int
                                      : int.tryParse('${c['invitationId']}');
                                  if (iid != null) {
                                    await _api.respondInvitation(invitationId: iid, action: 'ACCEPT');
                                    _loadOnlineClasses();
                                  }
                                },
                              )
                            : (classId != null && key == 'live'
                                ? IconButton(
                                    icon: const Icon(Icons.how_to_reg),
                                    onPressed: () => _api.checkInOnlineClass(
                                          onlineClassId: classId,
                                          date: DateTime.now().toIso8601String().substring(0, 10),
                                        ),
                                  )
                                : null)),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          if (_onlineSections == null)
            const Center(child: Text('Loading…'))
          else if (sections.values.every((v) => v is! List || v.isEmpty))
            const Center(child: Text('No online classes')),
        ],
      ),
    );
  }
}
