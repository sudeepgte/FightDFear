import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/fitness_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
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
  String? _error;
  List<Map<String, dynamic>> _trainers = [];
  List<Map<String, dynamic>> _bookings = [];
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
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadBookings();
    });
    _loadTrainers();
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

  Future<void> _loadBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final res = await _fitness.myBookings();
      if (!mounted) return;
      if (res['success'] == true) {
        _bookings = ModuleTheme.toList(res['bookings']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
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
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildBrowse(filtered),
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

  Widget _buildBookings() {
    if (_loadingBookings) return ModuleTheme.loading();
    if (_bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadBookings,
        child: ListView(
          children: [
            EmptyStateView(
              icon: Icons.event_note_outlined,
              title: 'No bookings yet',
              message: 'Book a verified trainer from Browse Trainers — your sessions will appear here.',
              actionLabel: 'Browse Trainers',
              onAction: () => _tabs.animateTo(0),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        itemBuilder: (_, i) {
          final b = _bookings[i];
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
        },
      ),
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
