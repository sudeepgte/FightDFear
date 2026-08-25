import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/glow_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/glow_space_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import 'glow_booking_confirmation_screen.dart';
import 'glow_space_salon_detail_screen.dart';

class GlowSpaceScreen extends StatefulWidget {
  const GlowSpaceScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<GlowSpaceScreen> createState() => _GlowSpaceScreenState();
}

class _GlowSpaceScreenState extends State<GlowSpaceScreen>
    with SingleTickerProviderStateMixin {
  late final GlowSpaceService _api;
  late final TabController _tabs;
  late final Razorpay _razorpay;
  bool _loading = true;
  bool _loadingBookings = false;
  String? _error;
  List<Map<String, dynamic>> _salons = [];
  List<Map<String, dynamic>> _liveServices = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _bookings = [];
  String _section = 'CATEGORIES';
  String? _selectedCategory;
  int? _pendingPayBookingId;
  final _cityFilter = TextEditingController();
  final _searchFilter = TextEditingController();
  bool _availableToday = false;
  bool _doorOnly = false;
  String _sort = 'rating';
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = GlowSpaceService(api);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadFavorites();
      if (_tabs.index == 2) _loadBookings();
    });
    _loadExplore();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _cityFilter.dispose();
    _searchFilter.dispose();
    _tabs.dispose();
    super.dispose();
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _loadExplore() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final salonsRes = await _api.salons(
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        search: _searchFilter.text.trim().isEmpty ? null : _searchFilter.text.trim(),
        category: _selectedCategory,
        availableToday: _availableToday ? true : null,
        doorService: _doorOnly ? true : null,
        sort: _sort,
      );
      final servicesRes = await _api.services();
      final offersRes = await _api.offers();
      if (!mounted) return;
      if (salonsRes['success'] == true) {
        _salons = _toList(salonsRes['salons']);
        _liveServices = _toList(servicesRes['services']);
        _offers = _toList(offersRes['offers']);
      } else {
        _error = salonsRes['error']?.toString() ?? 'Could not load Glow Space';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadBookings() async {
    setState(() => _loadingBookings = true);
    try {
      final res = await _api.myBookings();
      if (!mounted) return;
      if (res['success'] == true) {
        _bookings = _toList(res['bookings']);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingBookings = false);
  }

  Future<void> _loadFavorites() async {
    try {
      final res = await _api.favorites();
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() => _favorites = _toList(res['salons']));
      }
    } catch (_) {}
  }

  List<Map<String, dynamic>> _toList(dynamic raw) =>
      raw is List ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList() : <Map<String, dynamic>>[];

  List<Map<String, dynamic>> get _filteredLiveServices {
    if (_selectedCategory == null) return _liveServices;
    return _liveServices.where((s) {
      final code = s['category']?.toString().toUpperCase();
      final mapped = GlowCatalog.byCode(code);
      return mapped?.code == _selectedCategory;
    }).toList();
  }

  Future<void> _bookItem({
    required String itemType,
    required int itemId,
    required String title,
  }) async {
    DateTime date = DateTime.now().add(const Duration(days: 1));
    String time = '11:00';
    final addressCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String bookingType = 'ONLINE';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Book $title'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (picked != null) setLocal(() => date = picked);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Time'),
                  subtitle: Text(time),
                  trailing: const Icon(Icons.schedule),
                  onTap: () async {
                    final picked = await showTimePicker(context: ctx, initialTime: const TimeOfDay(hour: 11, minute: 0));
                    if (picked != null) {
                      setLocal(() => time = GlowCatalog.formatTime(picked));
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: bookingType,
                  items: const [
                    DropdownMenuItem(value: 'ONLINE', child: Text('At salon')),
                    DropdownMenuItem(value: 'DOOR', child: Text('Door service')),
                  ],
                  onChanged: (v) => setLocal(() => bookingType = v ?? 'ONLINE'),
                  decoration: const InputDecoration(labelText: 'Booking type'),
                ),
                if (bookingType == 'DOOR') ...[
                  const SizedBox(height: 8),
                  TextField(controller: addressCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Address')),
                ],
                const SizedBox(height: 8),
                TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes (optional)')),
                const SizedBox(height: 8),
                Text(GlowCatalog.cancelPolicy, style: const TextStyle(fontSize: 11, color: GlowSpaceScreen.textGray)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Confirm')),
          ],
        ),
      ),
    );

    if (ok != true) return;
    final res = await _api.createBooking(
      itemType: itemType,
      itemId: itemId,
      bookingDate: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      preferredTime: time,
      bookingType: bookingType,
      address: addressCtrl.text.trim(),
      notes: notesCtrl.text.trim(),
    );
    if (!mounted) return;
    if (res['success'] == true) {
      final paymentRequired = res['paymentRequired'] == true;
      final bookingId = res['bookingId'] is int ? res['bookingId'] as int : int.tryParse('${res['bookingId']}');
      final amount = (res['amount'] is num) ? (res['amount'] as num).toDouble() : 0.0;
      if (paymentRequired && bookingId != null) {
        await _startPayment(bookingId: bookingId);
      } else if (bookingId != null) {
        await _openConfirmation(bookingId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']?.toString() ?? 'Booking created')),
        );
      }
      _tabs.animateTo(2);
      await _loadBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Booking failed')),
      );
    }
  }

  Future<void> _openConfirmation(int bookingId) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GlowBookingConfirmationScreen(bookingId: bookingId)),
    );
    await _loadBookings();
  }

  Future<void> _startPayment({required int bookingId}) async {
    _pendingPayBookingId = bookingId;
    final orderRes = await _api.createPaymentOrder(bookingId);
    if (!mounted) return;
    if (orderRes['orderId'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orderRes['error']?.toString() ?? 'Payment gateway unavailable')),
      );
      return;
    }
    _razorpay.open({
      'key': orderRes['key'],
      'amount': orderRes['amount'],
      'order_id': orderRes['orderId'],
      'name': 'Fight D Fear',
      'description': 'Glow Space Booking',
    });
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final verify = await _api.verifyPayment({
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'GLOW_BOOKING',
        'bookingId': _pendingPayBookingId,
      });
      if (!mounted) return;
      if (verify['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verify['error'].toString())));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful — booking confirmed')),
        );
        if (_pendingPayBookingId != null) {
          await _openConfirmation(_pendingPayBookingId!);
        } else {
          await _loadBookings();
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  void _onPaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Payment failed')),
    );
  }

  Future<void> _rescheduleBooking(Map<String, dynamic> b) async {
    final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
    final salonId = b['salon'] is Map ? (b['salon'] as Map)['id'] : null;
    if (id == null || salonId == null) return;
    final sid = salonId is int ? salonId : int.tryParse('$salonId');
    if (sid == null) return;

    DateTime date = DateTime.tryParse(b['bookingDate']?.toString() ?? '') ?? DateTime.now().add(const Duration(days: 1));
    String time = b['preferredTime']?.toString() ?? '11:00';
    List<String> slots = [];

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Reschedule booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('New date'),
                subtitle: Text('${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  if (picked == null) return;
                  final key = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  final slotRes = await _api.salonSlots(sid, date: key);
                  setLocal(() {
                    date = picked;
                    slots = (slotRes['slots'] is List)
                        ? (slotRes['slots'] as List).map((e) => e.toString()).toList()
                        : <String>[];
                    if (slots.isNotEmpty) time = slots.first;
                  });
                },
              ),
              if (slots.isEmpty)
                const Text('Pick a date to load slots', style: TextStyle(color: GlowSpaceScreen.textGray))
              else
                DropdownButtonFormField<String>(
                  initialValue: slots.contains(time) ? time : slots.first,
                  items: slots.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (v) => setLocal(() => time = v ?? time),
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.rescheduleBooking(
      id,
      bookingDate: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      preferredTime: time,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Booking rescheduled' : (res['error']?.toString() ?? 'Failed'))),
    );
    if (res['success'] == true) _loadBookings();
  }

  Future<void> _reviewSalon(int salonId) async {
    int rating = 5;
    final comment = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate & Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: rating,
                items: const [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e ★'))).toList(),
                onChanged: (v) => setLocal(() => rating = v ?? 5),
                decoration: const InputDecoration(labelText: 'Rating'),
              ),
              TextField(controller: comment, maxLines: 3, decoration: const InputDecoration(labelText: 'Comment')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Post')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.addReview(salonId, rating: rating, comment: comment.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Review saved' : (res['error']?.toString() ?? 'Failed'))),
    );
    if (res['success'] == true) _loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowSpaceScreen.navy,
        title: const Text('Glow Space', style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabs,
          labelColor: GlowSpaceScreen.primary,
          unselectedLabelColor: GlowSpaceScreen.textGray,
          indicatorColor: GlowSpaceScreen.primary,
          tabs: const [
            Tab(text: 'Explore'),
            Tab(text: 'Favourites'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildExplore(),
          _buildFavorites(),
          _buildBookings(),
        ],
      ),
    );
  }

  Widget _buildExplore() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            TextButton(onPressed: _loadExplore, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        CategoryPillBar(
          options: const [
            (value: 'CATEGORIES', label: 'Categories', icon: Icons.grid_view_rounded),
            (value: 'SERVICES', label: 'Services', icon: Icons.spa_outlined),
            (value: 'SALONS', label: 'Salons', icon: Icons.storefront_outlined),
            (value: 'OFFERS', label: 'Offers', icon: Icons.local_offer_outlined),
          ],
          selected: _section,
          onSelected: (v) => setState(() {
            _section = v;
            if (v == 'CATEGORIES') _selectedCategory = null;
          }),
        ),
        if (_section == 'SALONS') _salonFilters(),
        if (_section == 'SERVICES' || _selectedCategory != null) _categoryFilterChips(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadExplore,
            color: GlowSpaceScreen.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: switch (_section) {
                'CATEGORIES' => [_categoriesGrid()],
                'SERVICES' => _serviceTiles(),
                'SALONS' => _salons.map(_salonTile).toList(),
                _ => _offers.map(_offerTile).toList(),
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _salonFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        children: [
          TextField(
            controller: _searchFilter,
            decoration: InputDecoration(
              hintText: 'Search salons or services',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _loadExplore),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _loadExplore(),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _cityFilter,
            decoration: InputDecoration(
              hintText: 'City',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _loadExplore),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _loadExplore(),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              FilterChip(
                label: const Text('Available today'),
                selected: _availableToday,
                onSelected: (v) {
                  setState(() => _availableToday = v);
                  _loadExplore();
                },
              ),
              FilterChip(
                label: const Text('Door service'),
                selected: _doorOnly,
                onSelected: (v) {
                  setState(() => _doorOnly = v);
                  _loadExplore();
                },
              ),
              ChoiceChip(
                label: const Text('Top rated'),
                selected: _sort == 'rating',
                onSelected: (_) {
                  setState(() => _sort = 'rating');
                  _loadExplore();
                },
              ),
              ChoiceChip(
                label: const Text('Fee'),
                selected: _sort == 'fee',
                onSelected: (_) {
                  setState(() => _sort = 'fee');
                  _loadExplore();
                },
              ),
              ChoiceChip(
                label: const Text('Nearest'),
                selected: _sort == 'nearest',
                onSelected: (_) {
                  setState(() => _sort = 'nearest');
                  _loadExplore();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites() {
    if (_favorites.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadFavorites,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text('No favourites yet — tap the heart on a salon')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: _favorites.map(_salonTile).toList(),
      ),
    );
  }

  Widget _categoryFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: const Text('All'),
              selected: _selectedCategory == null,
              onSelected: (_) => setState(() => _selectedCategory = null),
              selectedColor: GlowSpaceScreen.primary.withValues(alpha: 0.15),
            ),
          ),
          ...GlowCatalog.categories.map((c) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  avatar: Icon(c.icon, size: 16),
                  label: Text(c.label),
                  selected: _selectedCategory == c.code,
                  onSelected: (_) => setState(() {
                    _selectedCategory = c.code;
                    _section = 'SERVICES';
                  }),
                  selectedColor: GlowSpaceScreen.primary.withValues(alpha: 0.15),
                ),
              )),
        ],
      ),
    );
  }

  Widget _categoriesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What Glow Space provides',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: GlowSpaceScreen.navy),
        ),
        const SizedBox(height: 4),
        const Text(
          'Browse hair, skin, spa, bridal and more — then book from verified salons.',
          style: TextStyle(color: GlowSpaceScreen.textGray, height: 1.35),
        ),
        const SizedBox(height: 14),
        ...GlowCatalog.categories.map((cat) {
          final liveCount = _liveServices.where((s) {
            final mapped = GlowCatalog.byCode(s['category']?.toString());
            return mapped?.code == cat.code;
          }).length;
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => setState(() {
                _selectedCategory = cat.code;
                _section = 'SERVICES';
              }),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: GlowSpaceScreen.primary.withValues(alpha: 0.12),
                      child: Icon(cat.icon, color: GlowSpaceScreen.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text(cat.description, style: const TextStyle(color: GlowSpaceScreen.textGray, fontSize: 12)),
                          const SizedBox(height: 6),
                          Text(
                            '${cat.services.length} catalogue services · $liveCount bookable now',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: GlowSpaceScreen.primary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: GlowSpaceScreen.textGray),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  List<Widget> _serviceTiles() {
    final cat = GlowCatalog.byCode(_selectedCategory);
    final live = _filteredLiveServices;
    final widgets = <Widget>[];

    if (cat != null) {
      widgets.add(Text(cat.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: GlowSpaceScreen.navy)));
      widgets.add(const SizedBox(height: 4));
      widgets.add(Text(cat.description, style: const TextStyle(color: GlowSpaceScreen.textGray)));
      widgets.add(const SizedBox(height: 12));
    }

    if (live.isNotEmpty) {
      widgets.add(const Text('Bookable now', style: TextStyle(fontWeight: FontWeight.w700)));
      widgets.add(const SizedBox(height: 8));
      for (final s in live) {
        widgets.add(_liveServiceTile(s));
      }
      widgets.add(const SizedBox(height: 16));
    }

    if (cat != null) {
      widgets.add(const Text('Full service menu', style: TextStyle(fontWeight: FontWeight.w700)));
      widgets.add(const SizedBox(height: 8));
      for (final name in cat.services) {
        final match = live.where((s) => (s['name']?.toString() ?? '').toLowerCase() == name.toLowerCase()).toList();
        widgets.add(Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              match.isEmpty
                  ? 'Available at Glow Space salons'
                  : 'From ₹${match.first['price'] ?? 0} · ${match.first['salonName'] ?? 'Salon'}',
            ),
            trailing: match.isEmpty
                ? TextButton(
                    onPressed: () => setState(() => _section = 'SALONS'),
                    child: const Text('Find salon'),
                  )
                : FilledButton(
                    onPressed: () {
                      final id = match.first['id'] is int
                          ? match.first['id'] as int
                          : int.tryParse('${match.first['id']}');
                      if (id == null) return;
                      _bookItem(itemType: 'SERVICE', itemId: id, title: name);
                    },
                    style: FilledButton.styleFrom(backgroundColor: GlowSpaceScreen.primary),
                    child: const Text('Book'),
                  ),
          ),
        ));
      }
    } else if (live.isEmpty) {
      widgets.add(const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: Text('No bookable services yet. Browse categories or salons.')),
      ));
    }

    return widgets;
  }

  Widget _liveServiceTile(Map<String, dynamic> s) {
    final id = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
    return DetailListingCard(
      title: s['name']?.toString() ?? 'Service',
      eyebrow: GlowCatalog.labelFor(s['category']?.toString()),
      location: s['salonName']?.toString(),
      showMediaActions: false,
      tags: [
        DetailTag(
          label: '₹${s['price'] ?? 0}',
          icon: Icons.currency_rupee,
          background: const Color(0xFFE0E7FF),
          foreground: const Color(0xFF3730A3),
        ),
        if (s['durationMinutes'] != null)
          DetailTag(label: '${s['durationMinutes']} min', icon: Icons.timer_outlined),
      ],
      primaryLabel: 'Book',
      onPrimary: id == null
          ? null
          : () => _bookItem(
                itemType: 'SERVICE',
                itemId: id,
                title: s['name']?.toString() ?? 'Service',
              ),
    );
  }

  Widget _buildBookings() {
    if (_loadingBookings) return const Center(child: CircularProgressIndicator());
    if (_bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadBookings,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text('No Glow bookings yet')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final b = _bookings[i];
          final salon = b['salon'] is Map ? Map<String, dynamic>.from(b['salon'] as Map) : <String, dynamic>{};
          final item = b['item'] is Map ? Map<String, dynamic>.from(b['item'] as Map) : <String, dynamic>{};
          final type = b['itemType']?.toString() ?? '';
          final status = (b['status']?.toString() ?? 'PENDING').toUpperCase();
          final itemTitle = item['name']?.toString() ?? item['serviceName']?.toString() ?? item['title']?.toString() ?? type;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  '${salon['name'] ?? ''} · ${b['bookingDate'] ?? ''} ${b['preferredTime'] ?? ''}',
                  style: const TextStyle(color: GlowSpaceScreen.textGray),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    _statusChip(b['status']?.toString() ?? 'PENDING'),
                    _statusChip(b['bookingType']?.toString() ?? 'ONLINE', color: Colors.indigo),
                    if (b['price'] != null) _statusChip('₹${b['price']}', color: Colors.teal),
                  ],
                ),
                const SizedBox(height: 8),
                _trackRow('Placed', true),
                _trackRow('Confirmed', const ['CONFIRMED', 'PAID', 'COMPLETED'].contains(status)),
                _trackRow('Completed', status == 'COMPLETED'),
                if (status == 'CANCELLED' || status == 'REJECTED')
                  Text(
                    status == 'REJECTED' ? 'This booking was rejected.' : 'This booking was cancelled.',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFBE123C)),
                  ),
                if (b['paymentRequired'] == true) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                        final amount = (b['price'] is num) ? (b['price'] as num).toDouble() : 0.0;
                        if (id != null) _startPayment(bookingId: id);
                      },
                      style: FilledButton.styleFrom(backgroundColor: GlowSpaceScreen.primary),
                      child: const Text('Pay now'),
                    ),
                  ),
                ],
                if ((b['canCancel'] == true || status == 'PENDING') &&
                    (b['id'] is int || int.tryParse('${b['id']}') != null))
                  TextButton(
                    onPressed: () async {
                      final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                      if (id == null) return;
                      final messenger = ScaffoldMessenger.of(context);
                      final res = await _api.cancelBooking(id);
                      if (!mounted) return;
                      messenger.showSnackBar(SnackBar(
                        content: Text(res['success'] == true
                            ? 'Booking cancelled'
                            : (res['error']?.toString() ?? 'Cancel failed')),
                      ));
                      if (res['success'] == true) _loadBookings();
                    },
                    child: Text(b['canCancelFree'] == true ? 'Cancel (free)' : 'Cancel booking'),
                  ),
                if (b['canReschedule'] == true && (b['id'] is int || int.tryParse('${b['id']}') != null))
                  TextButton(
                    onPressed: () => _rescheduleBooking(b),
                    child: const Text('Reschedule'),
                  ),
                if (b['canReview'] == true && salon['id'] != null)
                  TextButton(
                    onPressed: () => _reviewSalon(
                      salon['id'] is int ? salon['id'] as int : int.parse('${salon['id']}'),
                    ),
                    child: const Text('Rate & Review'),
                  ),
                if (b['id'] is int || int.tryParse('${b['id']}') != null)
                  TextButton(
                    onPressed: () {
                      final id = b['id'] is int ? b['id'] as int : int.tryParse('${b['id']}');
                      if (id != null) _openConfirmation(id);
                    },
                    child: const Text('View confirmation'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _salonTile(Map<String, dynamic> s) {
    final id = s['id'] is int ? s['id'] as int : int.tryParse('${s['id']}');
    final image = _mediaUrl(s['profileImageUrl']?.toString());
    final loc = [s['city'], s['state'], s['address']]
        .where((e) => e != null && e.toString().trim().isNotEmpty)
        .map((e) => e.toString())
        .join(', ');
    return DetailListingCard(
      title: s['name']?.toString() ?? 'Salon',
      eyebrow: 'Glow Space',
      location: loc.isEmpty ? 'Location not set' : loc,
      photoUrl: image.isEmpty ? null : image,
      phone: s['phone']?.toString(),
      tags: [
        if (s['rating'] != null)
          DetailTag(
            label: '${s['rating']}',
            icon: Icons.star,
            background: const Color(0xFFFEF3C7),
            foreground: const Color(0xFFB45309),
          ),
        if (s['startingFee'] != null && s['startingFee'] != 0)
          DetailTag(label: 'From ₹${s['startingFee']}', icon: Icons.currency_rupee),
        if (s['availableToday'] == true)
          DetailTag(label: 'Today', icon: Icons.event_available, background: const Color(0xFFDCFCE7), foreground: const Color(0xFF166534)),
        if (s['nextSlot'] is Map)
          DetailTag(label: '${(s['nextSlot'] as Map)['label'] ?? 'Next slot'}', icon: Icons.schedule),
        if (s['availabilityHours'] != null)
          DetailTag(label: '${s['availabilityHours']}', icon: Icons.access_time),
      ],
      primaryLabel: 'View & Book',
      onPrimary: id == null
          ? null
          : () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => GlowSpaceSalonDetailScreen(salonId: id)),
              );
              await _loadBookings();
            },
    );
  }

  Widget _offerTile(Map<String, dynamic> o) {
    final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    final discount = o['discountPercent'];
    return DetailListingCard(
      title: o['title']?.toString() ?? 'Offer',
      eyebrow: 'Special Offer',
      location: o['salonName']?.toString(),
      showMediaActions: false,
      tags: [
        if (discount != null)
          DetailTag(
            label: '$discount% off',
            icon: Icons.local_offer_outlined,
            background: const Color(0xFFFFE4E6),
            foreground: GlowSpaceScreen.primary,
          ),
        DetailTag(
          label: '₹${o['discountedPrice'] ?? o['offerPrice'] ?? 0}',
          icon: Icons.currency_rupee,
          background: const Color(0xFFDCFCE7),
          foreground: const Color(0xFF166534),
        ),
      ],
      primaryLabel: 'Book offer',
      onPrimary: id == null
          ? null
          : () => _bookItem(
                itemType: 'OFFER',
                itemId: id,
                title: o['title']?.toString() ?? 'Offer',
              ),
    );
  }

  Widget _trackRow(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 14, color: done ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: done ? const Color(0xFF166534) : GlowSpaceScreen.textGray)),
        ],
      ),
    );
  }

  Widget _statusChip(String label, {Color color = GlowSpaceScreen.primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
