import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/fitness_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'fitness_qr_scanner_screen.dart';
import 'fitness_trainer_detail_screen.dart';

/// Member Fitness & Wellness browse — mockup layout, same booking flow.
class FitnessWellnessScreen extends StatefulWidget {
  const FitnessWellnessScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color purple = Color(0xFF7C3AED);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<FitnessWellnessScreen> createState() => _FitnessWellnessScreenState();
}

class _FitnessWellnessScreenState extends State<FitnessWellnessScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  late final TextEditingController _searchCtrl;
  late final TextEditingController _cityCtrl;
  late final FitnessService _fitness;
  late final PaymentService _payments;
  late final ModulePaymentCheckout _checkout;

  bool _loading = true;
  bool _loadingBookings = false;
  bool _loadingClasses = false;
  String? _error;
  List<Map<String, dynamic>> _trainers = [];
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _classes = [];
  List<Map<String, dynamic>> _attendanceList = [];
  Map<String, dynamic>? _progressSummary;
  String _bookingsSubTab = 'SCHEDULED';
  String _category = 'all';
  String _sort = 'rating';
  bool _availableOnly = false;
  final Set<int> _favorites = {};

  static const _categories = FitnessCatalog.browseFilters;

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _fitness = FitnessService(api);
    _payments = PaymentService(api);
    _checkout = ModulePaymentCheckout(_payments);
    _checkout.bind(
      onSuccess: (r) {
        if (!mounted) return;
        _checkout.handleSuccess(context, r);
      },
      onError: (r) {
        if (!mounted) return;
        _checkout.handleError(r);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(r.message ?? 'Payment cancelled or failed')),
        );
      },
    );
    _searchCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadClasses();
      if (_tabs.index == 2) _loadMyFitness();
    });
    _loadTrainers();
    _loadClasses();
    _loadMyFitness();
  }

  @override
  void dispose() {
    _checkout.dispose();
    _tabs.dispose();
    _searchCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTrainers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _fitness.trainers(
        city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
        sort: _sort,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        _trainers = ModuleTheme.toList(res['trainers']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load trainers';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadBookings() => _loadMyFitness();

  Future<void> _loadMyFitness() async {
    setState(() => _loadingBookings = true);
    try {
      final res = await _fitness.myBookings();
      if (!mounted) return;
      if (res['success'] == true) {
        _bookings = ModuleTheme.toList(res['bookings']);
      }
      final progRes = await _fitness.myProgress();
      if (progRes['success'] == true) {
        _progressSummary = progRes;
      }
      final attRes = await _fitness.myAttendance();
      if (attRes['success'] == true) {
        _attendanceList = ModuleTheme.toList(attRes['attendance']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
  }

  Future<void> _loadClasses() async {
    setState(() => _loadingClasses = true);
    try {
      final res = await _fitness.classes();
      if (!mounted) return;
      if (res['success'] == true) {
        _classes = ModuleTheme.toList(res['classes']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingClasses = false);
  }

  List<Map<String, dynamic>> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    var list = _trainers.where((t) {
      final specs = t['specializations']?.toString() ?? '';
      final name = (t['fullName']?.toString() ?? '').toLowerCase();
      final city = (t['city']?.toString() ?? '').toLowerCase();
      final catOk = FitnessCatalog.matchesCategory(specs, _category);
      final searchOk = q.isEmpty ||
          name.contains(q) ||
          specs.toLowerCase().contains(q) ||
          city.contains(q);
      final availOk = !_availableOnly || t['onlineAvailable'] != false;
      return catOk && searchOk && availOk;
    }).toList();

    list.sort((a, b) {
      switch (_sort) {
        case 'price_low':
          return _fees(a).compareTo(_fees(b));
        case 'price_high':
          return _fees(b).compareTo(_fees(a));
        case 'experience':
          return _exp(b).compareTo(_exp(a));
        default:
          return _rating(b).compareTo(_rating(a));
      }
    });
    return list;
  }

  double _fees(Map<String, dynamic> t) {
    final v = t['sessionFees'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  double _rating(Map<String, dynamic> t) {
    final v = t['rating'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  int _exp(Map<String, dynamic> t) {
    final v = t['experienceYears'] ?? t['experience'];
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? 0;
  }

  String? _photo(Map<String, dynamic> t) {
    final path = t['profilePhotoPath']?.toString();
    if (path == null || path.isEmpty) return null;
    return ModuleTheme.mediaUrl(context.read<AuthState>().api.baseUrl, path);
  }

  Future<void> _openTrainer(Map<String, dynamic> trainer) async {
    final id = trainer['id'];
    if (id is! num) return;
    final booked = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => FitnessTrainerDetailScreen(
          trainerId: id.toInt(),
          initialSummary: trainer,
        ),
      ),
    );
    if (booked == true && mounted) {
      _tabs.animateTo(1);
      await _loadBookings();
    }
  }

  Future<void> _payBooking({
    required int bookingId,
    required double amount,
    String trainerName = 'Trainer',
  }) async {
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
      onSuccess: () async {
        _tabs.animateTo(1);
        await _loadBookings();
      },
    );
  }

  Future<void> _reviewBooking(Map<String, dynamic> b) async {
    final bookingId = b['id'] is num ? (b['id'] as num).toInt() : int.tryParse('${b['id']}');
    if (bookingId == null) return;
    int rating = 5;
    final commentCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate your session'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final star = i + 1;
                  return IconButton(
                    onPressed: () => setLocal(() => rating = star),
                    icon: Icon(
                      star <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFF59E0B),
                    ),
                  );
                }),
              ),
              TextField(
                controller: commentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) {
      commentCtrl.dispose();
      return;
    }
    final comment = commentCtrl.text.trim();
    commentCtrl.dispose();
    final res = await _fitness.submitReview(bookingId, rating: rating, comment: comment);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Thank you for your review'
            : (res['error']?.toString() ?? 'Review failed')),
      ),
    );
    if (res['success'] == true) await _loadBookings();
  }

  Future<void> _cancelBooking(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel session?'),
        content: Text(FitnessCatalog.cancelPolicy),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cancel booking')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final res = await _fitness.cancelBooking(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Booking cancelled'
            : (res['error']?.toString() ?? 'Could not cancel')),
      ),
    );
    if (res['success'] == true) await _loadBookings();
  }

  void _showSortSheet() {
    const options = <(String, String)>[
      ('rating', 'Top rated'),
      ('price_low', 'Price: low to high'),
      ('price_high', 'Price: high to low'),
      ('experience', 'Most experienced'),
    ];
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('Sort by', style: TextStyle(fontWeight: FontWeight.w800))),
            ...options.map(
              (o) => ListTile(
                title: Text(o.$2),
                trailing: _sort == o.$1
                    ? const Icon(Icons.check_rounded, color: FitnessWellnessScreen.primary)
                    : null,
                onTap: () {
                  setState(() => _sort = o.$1);
                  Navigator.pop(ctx);
                  _loadTrainers();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filters', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _cityCtrl,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'e.g. Bengaluru',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available for booking'),
                subtitle: const Text('Hide trainers currently offline'),
                value: _availableOnly,
                activeThumbColor: FitnessWellnessScreen.primary,
                onChanged: (v) => setState(() => _availableOnly = v),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: FitnessWellnessScreen.primary),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _loadTrainers();
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
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
        backgroundColor: Colors.white,
        foregroundColor: FitnessWellnessScreen.navy,
        elevation: 0,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness & Wellness',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            Text(
              'Find verified trainers for your fitness goals',
              style: TextStyle(fontSize: 12, color: FitnessWellnessScreen.textGray, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadTrainers,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: 'Filters',
            onPressed: _showFiltersSheet,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: FitnessWellnessScreen.primary,
          unselectedLabelColor: FitnessWellnessScreen.textGray,
          indicatorColor: FitnessWellnessScreen.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          tabs: const [
            Tab(text: 'Browse Trainers'),
            Tab(text: 'Group Classes'),
            Tab(text: 'My Fitness'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildBrowse(filtered),
          _buildClasses(),
          _buildBookings(),
        ],
      ),
    );
  }

  Widget _buildBrowse(List<Map<String, dynamic>> filtered) {
    if (_loading) return ModuleTheme.loading();
    if (_error != null) return ModuleTheme.errorView(_error!, _loadTrainers);

    return RefreshIndicator(
      onRefresh: _loadTrainers,
      color: FitnessWellnessScreen.primary,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by name, specialization, or city…',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                prefixIcon: const Icon(Icons.search_rounded, color: FitnessWellnessScreen.textGray),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: FitnessWellnessScreen.primary),
                      const SizedBox(width: 2),
                      Text(
                        _commonCityLabel(),
                        style: const TextStyle(
                          color: FitnessWellnessScreen.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: FitnessWellnessScreen.primary, width: 1.4),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = _categories[i];
                final selected = _category == c.value;
                return ChoiceChip(
                  avatar: Icon(
                    c.icon,
                    size: 16,
                    color: selected ? Colors.white : FitnessWellnessScreen.navy,
                  ),
                  label: Text(c.label),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: FitnessWellnessScreen.navy,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : FitnessWellnessScreen.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: selected ? FitnessWellnessScreen.navy : const Color(0xFFE2E8F0)),
                  onSelected: (_) => setState(() => _category = c.value),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickFilterChip(
                  icon: Icons.tune_rounded,
                  label: 'Filters',
                  active: _availableOnly,
                  onTap: _showFiltersSheet,
                ),
                _QuickFilterChip(
                  icon: Icons.sort_rounded,
                  label: 'Sort',
                  onTap: _showSortSheet,
                ),
                _QuickFilterChip(
                  icon: Icons.circle,
                  iconSize: 10,
                  iconColor: const Color(0xFF22C55E),
                  label: 'Available Today',
                  active: _availableOnly,
                  onTap: () => setState(() => _availableOnly = !_availableOnly),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, size: 16, color: FitnessWellnessScreen.purple),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: FitnessWellnessScreen.textGray, fontSize: 13),
                      children: [
                        const TextSpan(text: 'Showing '),
                        TextSpan(
                          text: '${filtered.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: FitnessWellnessScreen.navy,
                          ),
                        ),
                        const TextSpan(text: ' verified fitness trainers'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: EmptyStateView(
                icon: Icons.fitness_center_outlined,
                title: 'No trainers found',
                message: 'Try another category or clear your search filters.',
              ),
            )
          else
            ...filtered.map((t) {
              final id = t['id'] is num ? (t['id'] as num).toInt() : null;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _TrainerCard(
                  trainer: t,
                  photoUrl: _photo(t),
                  favorited: id != null && _favorites.contains(id),
                  onFavorite: id == null
                      ? null
                      : () => setState(() {
                            if (_favorites.contains(id)) {
                              _favorites.remove(id);
                            } else {
                              _favorites.add(id);
                            }
                          }),
                  onViewProfile: () => _openTrainer(t),
                ),
              );
            }),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _TrustBanner(),
          ),
        ],
      ),
    );
  }

  String _commonCityLabel() {
    final typed = _cityCtrl.text.trim();
    if (typed.isNotEmpty) return typed;
    final cities = _trainers
        .map((t) => t['city']?.toString().trim() ?? '')
        .where((c) => c.isNotEmpty)
        .toList();
    if (cities.isEmpty) return 'Near you';
    final counts = <String, int>{};
    for (final c in cities) {
      counts[c] = (counts[c] ?? 0) + 1;
    }
    final top = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return top.first.key;
  }

  Widget _buildClasses() {
    if (_loadingClasses) return ModuleTheme.loading();
    return RefreshIndicator(
      onRefresh: _loadClasses,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.groups_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Join Group Fitness Classes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E1B4B))),
                      SizedBox(height: 2),
                      Text('Train with peers in HIIT, Yoga, Zumba, and self-defense conditioning.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_classes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('No group classes scheduled at this time. Check back soon!'),
              ),
            )
          else
            ..._classes.map((c) {
              final id = int.tryParse('${c['id']}');
              final trainer = c['trainer'];
              final trainerName = (trainer is Map) ? trainer['fullName']?.toString() : 'Verified Coach';
              final maxCap = c['maxCapacity'] is num ? (c['maxCapacity'] as num).toInt() : 20;
              final enrolled = c['currentEnrollment'] is num ? (c['currentEnrollment'] as num).toInt() : 0;
              final spotsLeft = maxCap - enrolled;
              final price = c['price'] is num ? (c['price'] as num).toDouble() : 0.0;
              final isFull = spotsLeft <= 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c['category']?.toString() ?? 'Fitness',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFFE11D48)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c['sessionType']?.toString() ?? 'ONLINE',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          price == 0 ? 'FREE' : '₹${price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: FitnessWellnessScreen.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      c['className']?.toString() ?? 'Group Class',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: FitnessWellnessScreen.navy),
                    ),
                    const SizedBox(height: 4),
                    Text('Coach: $trainerName', style: const TextStyle(fontSize: 13, color: FitnessWellnessScreen.textGray, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text('${c['classDate']} at ${c['classTime']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(width: 14),
                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text('${c['durationMinutes']} mins', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                    if ((c['description']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(c['description']?.toString() ?? '', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          isFull ? 'Class Full' : '$spotsLeft spots remaining',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isFull ? Colors.red : const Color(0xFF16A34A),
                          ),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: (isFull || id == null) ? null : () => _bookClassConfirmDialog(id, c),
                          style: FilledButton.styleFrom(
                            backgroundColor: FitnessWellnessScreen.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          ),
                          child: const Text('Book Spot', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  void _bookClassConfirmDialog(int classId, Map<String, dynamic> classData) {
    final price = classData['price'] is num ? (classData['price'] as num).toDouble() : 0.0;
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: Text('Book Spot: ${classData['className']}'),
        content: Text('Join this ${classData['sessionType']} group workout session on ${classData['classDate']} at ${classData['classTime']}.\n\nFee: ${price == 0 ? "FREE" : "₹$price"}\nPayment will be processed via your wallet balance.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: FitnessWellnessScreen.primary),
            onPressed: () async {
              final res = await _fitness.bookClass(classId);
              Navigator.pop(dCtx);
              if (res['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Class booked successfully! Spot confirmed.')),
                );
                _loadClasses();
                _loadMyFitness();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(res['error']?.toString() ?? 'Booking failed')),
                );
              }
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }

  void _openLogWeightDialog() {
    final weightCtrl = TextEditingController();
    final bodyFatCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Today\'s Weight & Metrics', style: TextStyle(fontWeight: FontWeight.w800)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Record your post-workout body weight and milestones to track your progress streak.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              const SizedBox(height: 14),
              TextField(
                controller: weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Body Weight (kg) *', hintText: 'e.g. 68.5', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyFatCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Body Fat % (optional)', hintText: 'e.g. 19.5', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Workout Notes & Achievements', hintText: 'e.g. Completed 45 mins HIIT + 5k run', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: FitnessWellnessScreen.primary),
            onPressed: () async {
              final weight = double.tryParse(weightCtrl.text.trim());
              if (weight == null || weight < 20 || weight > 300) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid weight between 20kg and 300kg')),
                );
                return;
              }
              final bodyFat = double.tryParse(bodyFatCtrl.text.trim());
              final res = await _fitness.logMyProgress(
                weightKg: weight,
                bodyFatPct: bodyFat,
                workoutNotes: notesCtrl.text.trim().isNotEmpty ? notesCtrl.text.trim() : null,
              );
              Navigator.pop(dCtx);
              if (res['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Weight and fitness milestone logged successfully!')),
                );
                _loadMyFitness();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(res['error']?.toString() ?? 'Failed to log progress')),
                );
              }
            },
            child: const Text('Save Metrics'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookings() {
    if (_loadingBookings) return ModuleTheme.loading();

    final scheduled = _bookings.where((b) => b['status'] != 'COMPLETED' && b['status'] != 'CANCELLED').toList();
    final completed = _bookings.where((b) => b['status'] == 'COMPLETED').toList();
    final streak = _progressSummary?['currentStreakDays'] ?? 0;
    final totalWorkouts = _progressSummary?['totalWorkoutsAttended'] ?? 0;
    final latestWeight = _progressSummary?['latestWeight'];
    final progressLogs = (_progressSummary?['progressLogs'] is List)
        ? (_progressSummary!['progressLogs'] as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    return RefreshIndicator(
      onRefresh: _loadMyFitness,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. TOP METRICS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Color(0xFFEA580C), size: 20),
                            const SizedBox(width: 4),
                            Text('$streak Days', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text('Streak', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                    Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, color: Color(0xFF16A34A), size: 20),
                            const SizedBox(width: 4),
                            Text('$totalWorkouts', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text('Workouts', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                    Container(height: 32, width: 1, color: const Color(0xFFE2E8F0)),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.monitor_weight_outlined, color: FitnessWellnessScreen.primary, size: 20),
                            const SizedBox(width: 4),
                            Text(latestWeight != null ? '$latestWeight kg' : '—', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text('Weight', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _openLogWeightDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FitnessWellnessScreen.primary,
                    side: const BorderSide(color: Color(0xFFFECDD3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size.fromHeight(38),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Log Today\'s Weight & Milestones', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. WORKOUT SESSION CHECK-IN CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFECDD3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF43F5E),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Session Self Check-In', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A))),
                      SizedBox(height: 2),
                      Text('Scan trainer QR code or enter code to verify', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF43F5E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onPressed: _openClientQrCheckInDialog,
                  child: const Text('Check In', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. SUB-TABS FILTER CHIPS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subTabChip('SCHEDULED', 'Scheduled (${scheduled.length})'),
                const SizedBox(width: 8),
                _subTabChip('ATTENDANCE', 'Attendance (${_attendanceList.length})'),
                const SizedBox(width: 8),
                _subTabChip('COMPLETED', 'Completed (${completed.length})'),
                const SizedBox(width: 8),
                _subTabChip('PROGRESS', 'Milestones (${progressLogs.length})'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. ACTIVE SUB-TAB CONTENT
          if (_bookingsSubTab == 'SCHEDULED')
            if (scheduled.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No scheduled sessions at this time.')),
              )
            else
              ...scheduled.map(_buildBookingCard)
          else if (_bookingsSubTab == 'ATTENDANCE')
            if (_attendanceList.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No attendance history recorded yet.')),
              )
            else
              ..._attendanceList.map((a) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${a['sessionDate'] ?? "Date"} · ${a['sessionTime'] ?? ""}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            Text('Session #${a['id']} · Coach: ${a['trainerName'] ?? "Coach"}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            if ((a['notes']?.toString() ?? '').isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text('Notes: ${a['notes']}', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                        ),
                        child: Text(
                          a['status']?.toString() ?? 'PRESENT',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: Color(0xFF16A34A)),
                        ),
                      ),
                    ],
                  ),
                );
              })
          else if (_bookingsSubTab == 'COMPLETED')
            if (completed.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No completed sessions yet.')),
              )
            else
              ...completed.map(_buildBookingCard)
          else if (_bookingsSubTab == 'PROGRESS')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Milestone Badges Grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: streak >= 3 ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.local_fire_department, color: Color(0xFFEA580C), size: 28),
                            const SizedBox(height: 4),
                            const Text('Consistency', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text(streak >= 3 ? '✓ Unlocked' : '3-Day Streak', style: TextStyle(fontSize: 11, color: streak >= 3 ? const Color(0xFF16A34A) : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: totalWorkouts >= 1 ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.military_tech_rounded, color: Color(0xFFF59E0B), size: 28),
                            const SizedBox(height: 4),
                            const Text('First Workout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text(totalWorkouts >= 1 ? '✓ Completed' : 'Start Today', style: TextStyle(fontSize: 11, color: totalWorkouts >= 1 ? const Color(0xFF16A34A) : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: progressLogs.length >= 5 ? const Color(0xFF16A34A) : const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.bolt_rounded, color: Color(0xFF3B82F6), size: 28),
                            const SizedBox(height: 4),
                            const Text('Dedicated', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            Text(progressLogs.length >= 5 ? '✓ Unlocked' : '5 Logs Goal', style: TextStyle(fontSize: 11, color: progressLogs.length >= 5 ? const Color(0xFF16A34A) : Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Logged Transformation History', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 10),
                if (progressLogs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('No weigh-in logs recorded yet. Tap "Log Today\'s Weight" to record your first entry.')),
                  )
                else
                  ...progressLogs.map((log) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFF1F2),
                          child: const Icon(Icons.monitor_weight_outlined, color: FitnessWellnessScreen.primary, size: 20),
                        ),
                        title: Text('${log['weightKg'] ?? "—"} kg', style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text('${log['logDate'] ?? ""} · ${log['workoutNotes'] ?? "Weight check-in"}'),
                        trailing: (log['bodyFatPct'] != null)
                            ? Text('${log['bodyFatPct']}% Fat', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B)))
                            : null,
                      ),
                    );
                  }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _subTabChip(String key, String label) {
    final active = _bookingsSubTab == key;
    return ChoiceChip(
      label: Text(label),
      selected: active,
      selectedColor: const Color(0xFFFFF1F2),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: active ? FitnessWellnessScreen.primary : const Color(0xFF475569),
      ),
      onSelected: (v) {
        if (v) setState(() => _bookingsSubTab = key);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b) {
    final nested = b['trainer'];
    final trainer = nested is Map ? Map<String, dynamic>.from(nested) : <String, dynamic>{};
    final needsPay = b['paymentRequired'] == true;
    final canReview = b['canReview'] == true;
    final canCancel = b['canCancel'] == true;
    final bookingId = b['id'] is num ? (b['id'] as num).toInt() : int.tryParse('${b['id']}');
    final amount = (b['amount'] is num)
        ? (b['amount'] as num).toDouble()
        : double.tryParse('${b['amount'] ?? b['paymentAmount']}') ?? 0;
    final status = b['status']?.toString() ?? 'PENDING';
    final photo = ModuleTheme.mediaUrl(
      context.read<AuthState>().api.baseUrl,
      trainer['profilePhotoPath']?.toString(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFFCE7F3),
                backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
                child: photo.isEmpty
                    ? Text(
                        (trainer['fullName']?.toString().isNotEmpty == true)
                            ? trainer['fullName'].toString()[0].toUpperCase()
                            : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainer['fullName']?.toString() ?? 'Trainer',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: FitnessWellnessScreen.navy,
                      ),
                    ),
                    Text(
                      '${b['category'] ?? 'Session'} · ${b['sessionType'] ?? ''}',
                      style: const TextStyle(fontSize: 12, color: FitnessWellnessScreen.textGray),
                    ),
                  ],
                ),
              ),
              _StatusPill(status: status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${b['bookingDate'] ?? '—'}  ·  ${b['bookingTime'] ?? ''}',
            style: const TextStyle(fontSize: 13, color: FitnessWellnessScreen.textGray),
          ),
          if (amount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '₹${amount.toStringAsFixed(0)} · ${b['paymentStatus'] ?? ''}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: FitnessWellnessScreen.primary),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (needsPay && bookingId != null)
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: FitnessWellnessScreen.primary),
                    onPressed: () => _payBooking(
                      bookingId: bookingId,
                      amount: amount,
                      trainerName: trainer['fullName']?.toString() ?? 'Trainer',
                    ),
                    child: const Text('Pay now'),
                  ),
                )
              else if (canReview)
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: FitnessWellnessScreen.purple),
                    onPressed: () => _reviewBooking(b),
                    child: const Text('Rate session'),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Status: $status')),
                      );
                    },
                    child: const Text('Details'),
                  ),
                ),
              if (canCancel && bookingId != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancelBooking(bookingId),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _openClientQrCheckInDialog() async {
    final scanned = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const FitnessQrScannerScreen()),
    );
    if (scanned == true) {
      _loadBookings();
    }
  }

  void _openManualTokenEntryDialog() {
    final tokenCtrl = TextEditingController();
    bool submitting = false;
    String? dialogError;
    Map<String, dynamic>? successData;

    showDialog(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (context, setDState) {
            if (successData != null) {
              final trainerName = successData?['trainerName']?.toString() ?? 'Coach';
              final already = successData?['alreadyCheckedIn'] == true;
              final completed = successData?['completedSessions'];
              final remaining = successData?['remainingSessions'];

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Icon(already ? Icons.info_outline : Icons.check_circle, size: 56, color: already ? Colors.blue : const Color(0xFF10B981)),
                    const SizedBox(height: 14),
                    Text(already ? 'Already Checked In!' : 'Attendance Confirmed!',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(successData?['message']?.toString() ?? 'Welcome to your workout with $trainerName.',
                        textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Color(0xD6000000))),
                    if (completed != null && remaining != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Sessions: $completed attended · $remaining remaining',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF0F172A))),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFF10B981), shape: const StadiumBorder()),
                      onPressed: () {
                        Navigator.pop(dCtx);
                        _loadBookings();
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: const [
                  Icon(Icons.qr_code_scanner, color: Color(0xFFF43F5E)),
                  SizedBox(width: 8),
                  Text('Workout Check-In', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter the session token displayed on your trainer\'s screen:',
                      style: TextStyle(fontSize: 13, color: Color(0xD6000000))),
                  const SizedBox(height: 14),
                  TextField(
                    controller: tokenCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. FIT-XXXX-XXXX',
                      prefixIcon: const Icon(Icons.vpn_key_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 10),
                    Text(dialogError!, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: submitting ? null : () => Navigator.pop(dCtx),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF43F5E), shape: const StadiumBorder()),
                  onPressed: submitting
                      ? null
                      : () async {
                          final token = tokenCtrl.text.trim();
                          if (token.isEmpty) {
                            setDState(() => dialogError = 'Please enter a valid QR token');
                            return;
                          }
                          setDState(() {
                            submitting = true;
                            dialogError = null;
                          });

                          try {
                            final res = await _fitness.checkInWithQr(token: token);
                            if (res['success'] == true) {
                              setDState(() {
                                submitting = false;
                                successData = res;
                              });
                            } else {
                              setDState(() {
                                submitting = false;
                                dialogError = res['error']?.toString() ?? 'Check-in failed. Please verify with trainer.';
                              });
                            }
                          } catch (e) {
                            setDState(() {
                              submitting = false;
                              dialogError = '$e';
                            });
                          }
                        },
                  child: submitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Check In'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _QuickFilterChip extends StatelessWidget {
  const _QuickFilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.iconSize = 16,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final double iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? const Color(0xFFEEF2FF) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? FitnessWellnessScreen.purple.withValues(alpha: 0.35) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: iconColor ?? FitnessWellnessScreen.navy),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: active ? FitnessWellnessScreen.purple : FitnessWellnessScreen.navy,
                ),
              ),
              if (label == 'Sort') ...[
                const SizedBox(width: 2),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainerCard extends StatelessWidget {
  const _TrainerCard({
    required this.trainer,
    required this.onViewProfile,
    this.photoUrl,
    this.favorited = false,
    this.onFavorite,
  });

  final Map<String, dynamic> trainer;
  final String? photoUrl;
  final bool favorited;
  final VoidCallback? onFavorite;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    final name = trainer['fullName']?.toString() ?? 'Trainer';
    final specs = FitnessCatalog.splitSpecializations(trainer['specializations']?.toString());
    final specsLabel = specs.isEmpty ? 'Fitness coaching' : specs.take(3).join(' • ');
    final rating = (trainer['rating'] is num)
        ? (trainer['rating'] as num).toDouble()
        : double.tryParse('${trainer['rating']}') ?? 0;
    final fees = (trainer['sessionFees'] is num)
        ? (trainer['sessionFees'] as num).toDouble()
        : double.tryParse('${trainer['sessionFees']}') ?? 0;
    final exp = trainer['experienceYears'] ?? trainer['experience'];
    final expLabel = exp == null || '$exp'.isEmpty ? null : '$exp Years Experience';
    final online = trainer['onlineAvailable'] != false;
    final serviceType = trainer['serviceType']?.toString() ?? 'Both';
    final city = trainer['city']?.toString();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'T';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFFCE7F3),
                  child: photoUrl != null && photoUrl!.isNotEmpty
                      ? Image.network(photoUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) {
                          return Center(
                            child: Text(initial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                          );
                        })
                      : Center(
                          child: Text(initial, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: FitnessWellnessScreen.navy,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded, size: 16, color: FitnessWellnessScreen.purple),
                            ],
                          ),
                        ),
                        _AvailabilityBadge(online: online),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specsLabel,
                      style: const TextStyle(
                        color: FitnessWellnessScreen.purple,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (city != null && city.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        city,
                        style: const TextStyle(fontSize: 12, color: FitnessWellnessScreen.textGray),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 3),
                            Text(
                              rating > 0 ? rating.toStringAsFixed(1) : 'New',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                        if (expLabel != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.workspace_premium_outlined, size: 14, color: FitnessWellnessScreen.textGray),
                              const SizedBox(width: 3),
                              Text(expLabel, style: const TextStyle(fontSize: 12, color: FitnessWellnessScreen.textGray)),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _serviceModes(serviceType)
                          .map(
                            (m) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(m.$1, size: 13, color: FitnessWellnessScreen.navy),
                                  const SizedBox(width: 4),
                                  Text(
                                    m.$2,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                fees > 0 ? '₹${fees.toStringAsFixed(0)} / session' : 'Fee on request',
                style: const TextStyle(
                  color: FitnessWellnessScreen.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  favorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: favorited ? FitnessWellnessScreen.primary : FitnessWellnessScreen.textGray,
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFF43F5E)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onViewProfile,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Text(
                        'View Profile',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<(IconData, String)> _serviceModes(String serviceType) {
    final s = serviceType.toLowerCase();
    if (s.contains('online') && !s.contains('offline') && !s.contains('both')) {
      return [(Icons.videocam_outlined, 'Online')];
    }
    if (s.contains('offline') && !s.contains('online') && !s.contains('both')) {
      return [(Icons.fitness_center, 'Gym'), (Icons.home_outlined, 'Home Visit')];
    }
    return [
      (Icons.videocam_outlined, 'Online'),
      (Icons.fitness_center, 'Gym'),
      (Icons.home_outlined, 'Home Visit'),
    ];
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: online ? const Color(0xFFDCFCE7) : const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        online ? 'Available today' : 'Next slot soon',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: online ? const Color(0xFF166534) : FitnessWellnessScreen.purple,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final s = status.toUpperCase();
    Color bg = const Color(0xFFFEF3C7);
    Color fg = const Color(0xFFB45309);
    if (s.contains('APPROVED') || s.contains('COMPLETED')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (s.contains('REJECT') || s.contains('CANCEL')) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFB91C1C);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _TrustBanner extends StatelessWidget {
  const _TrustBanner();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.verified_user_outlined, 'Verified Trainers', 'Background Verified'),
      (Icons.school_outlined, 'Certified Experts', 'Qualified Professionals'),
      (Icons.event_available_outlined, 'Easy Booking', 'Book in 3 Simple Steps'),
      (Icons.support_agent_outlined, '24/7 Support', "We're Here to Help"),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        children: items
            .map(
              (e) => Expanded(
                child: Column(
                  children: [
                    Icon(e.$1, size: 20, color: FitnessWellnessScreen.purple),
                    const SizedBox(height: 6),
                    Text(
                      e.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: FitnessWellnessScreen.navy),
                    ),
                    Text(
                      e.$3,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9, color: FitnessWellnessScreen.textGray),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
