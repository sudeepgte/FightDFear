import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import 'women_event_detail_screen.dart';

class WomenEventsScreen extends StatefulWidget {
  const WomenEventsScreen({super.key});

  @override
  State<WomenEventsScreen> createState() => _WomenEventsScreenState();
}

class _WomenEventsScreenState extends State<WomenEventsScreen>
    with SingleTickerProviderStateMixin {
  late final WomenEventsService _api;
  late final ModulePaymentCheckout _checkout;
  late final TabController _tabs;
  bool _loading = true;
  bool _loadingRegs = false;
  bool _paying = false;
  bool _cancelling = false;
  String? _error;
  String? _regsError;
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _registrations = [];
  String _category = 'all';
  String _sort = 'newest';
  final _cityFilter = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authApi = context.read<AuthState>().api;
    _api = WomenEventsService(authApi);
    _checkout = ModulePaymentCheckout(PaymentService(authApi));
    _checkout.bind(
      onSuccess: (r) {
        if (!mounted) return;
        _checkout.handleSuccess(context, r);
      },
      onError: (r) {
        if (!mounted) return;
        _checkout.handleError(r);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${r.message ?? 'Payment cancelled'}. You can complete payment from My Tickets.',
            ),
          ),
        );
      },
    );
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) _loadRegistrations();
    });
    _loadEvents();
  }

  @override
  void dispose() {
    _checkout.dispose();
    _tabs.dispose();
    _cityFilter.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.list(
        category: _category == 'all' ? null : _category,
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        sort: _sort,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        _events = ModuleTheme.toList(res['events']);
      } else {
        _error = res['error']?.toString() ?? 'Failed to load events';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadRegistrations() async {
    setState(() {
      _loadingRegs = true;
      _regsError = null;
    });
    try {
      final res = await _api.myRegistrations();
      if (!mounted) return;
      if (res['success'] == true) {
        _registrations = ModuleTheme.toList(res['registrations']);
      } else {
        _regsError = res['error']?.toString() ?? 'Failed to load tickets';
      }
    } catch (e) {
      _regsError = '$e';
    }
    if (mounted) setState(() => _loadingRegs = false);
  }

  Future<void> _openDetail(Map<String, dynamic> event) async {
    final id = event['id'] is num ? (event['id'] as num).toInt() : int.tryParse('${event['id']}');
    if (id == null) return;
    final refreshed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => WomenEventDetailScreen(eventId: id, initialSummary: event),
      ),
    );
    if (!mounted) return;
    await _loadEvents();
    if (refreshed == true) {
      _tabs.animateTo(1);
      await _loadRegistrations();
    }
  }

  Future<void> _payForRegistration({
    required int registrationId,
    required double amount,
    required String eventName,
  }) async {
    if (_paying) return;
    setState(() => _paying = true);
    try {
      await _checkout.pay(
        context: context,
        amount: amount,
        description: 'Event ticket · $eventName',
        verifyPayload: (response) => {
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
          'type': 'WOMEN_EVENT',
          'registrationId': registrationId,
          'amount': amount,
        },
        onSuccess: () async {
          await _loadRegistrations();
          await _loadEvents();
        },
        onError: (msg) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$msg. Complete payment from My Tickets.')),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Future<void> _cancelRegistration(Map<String, dynamic> r) async {
    if (_cancelling) return;
    final id = r['registrationId'] is num
        ? (r['registrationId'] as num).toInt()
        : int.tryParse('${r['registrationId'] ?? r['id']}');
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel registration?'),
        content: Text(WomenEventCatalog.cancelPolicy),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cancel ticket')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _cancelling = true);
    try {
      final res = await _api.cancelRegistration(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['success'] == true
              ? 'Registration cancelled'
              : (res['error']?.toString() ?? 'Cancel failed')),
        ),
      );
      if (res['success'] == true) {
        await _loadRegistrations();
        await _loadEvents();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  Future<void> _rateRegistration(Map<String, dynamic> r) async {
    final id = r['registrationId'] is num
        ? (r['registrationId'] as num).toInt()
        : int.tryParse('${r['registrationId'] ?? r['id']}');
    if (id == null) return;
    int stars = 5;
    final review = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () => setLocal(() => stars = i + 1),
                    icon: Icon(i < stars ? Icons.star : Icons.star_border, color: Colors.amber),
                  ),
                ),
              ),
              TextField(
                controller: review,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Optional comment',
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
    if (ok != true || !mounted) return;
    final res = await _api.rateRegistration(id, rating: stars, review: review.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res['success'] == true
          ? 'Thanks for your review'
          : (res['error']?.toString() ?? 'Review failed')),
    ));
    if (res['success'] == true) _loadRegistrations();
  }

  void _showTicketDetails(Map<String, dynamic> r) {
    final event = r['event'] is Map ? Map<String, dynamic>.from(r['event'] as Map) : <String, dynamic>{};
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['name']?.toString() ?? 'Event',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text('Ticket: ${r['ticketCode'] ?? '—'}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Status: ${r['status'] ?? '—'}'),
            Text('Paid: ${r['paid'] == true ? 'Yes' : 'No'}'),
            if (event['eventDate'] != null) Text('Date: ${event['eventDate']} ${event['eventTime'] ?? ''}'),
            if (event['venue'] != null) Text('Venue: ${event['venue']}, ${event['city'] ?? ''}'),
            const SizedBox(height: 12),
            if (r['canCancel'] == true)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _cancelRegistration(r);
                  },
                  child: const Text('Cancel registration'),
                ),
              ),
            if (r['canReview'] == true)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _rateRegistration(r);
                  },
                  child: const Text('Leave a review'),
                ),
              ),
            if (r['cancelPolicy'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${r['cancelPolicy']}',
                  style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray),
                ),
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
        title: const Text('Women Events'),
        backgroundColor: Colors.white,
        foregroundColor: ModuleTheme.navy,
        bottom: TabBar(
          controller: _tabs,
          labelColor: ModuleTheme.primary,
          unselectedLabelColor: ModuleTheme.textGray,
          tabs: const [
            Tab(text: 'Events'),
            Tab(text: 'My Tickets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildEventsTab(),
          _buildTicketsTab(),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    if (_loading) return ModuleTheme.loading();
    if (_error != null) return ModuleTheme.errorView(_error!, _loadEvents);

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _category == 'all',
                    onSelected: (_) {
                      setState(() => _category = 'all');
                      _loadEvents();
                    },
                  ),
                ),
                ...WomenEventCatalog.categories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c.label, style: const TextStyle(fontSize: 12)),
                      selected: _category == c.code,
                      onSelected: (_) {
                        setState(() => _category = c.code);
                        _loadEvents();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _cityFilter,
              decoration: InputDecoration(
                hintText: 'City',
                prefixIcon: const Icon(Icons.search, size: 18),
                suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _loadEvents),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _loadEvents(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Wrap(
              spacing: 6,
              children: [
                ChoiceChip(
                  label: const Text('Newest'),
                  selected: _sort == 'newest',
                  onSelected: (_) {
                    setState(() => _sort = 'newest');
                    _loadEvents();
                  },
                ),
                ChoiceChip(
                  label: const Text('Top rated'),
                  selected: _sort == 'rating',
                  onSelected: (_) {
                    setState(() => _sort = 'rating');
                    _loadEvents();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Showing ${_events.length} women events',
              style: const TextStyle(color: ModuleTheme.textGray, fontSize: 13),
            ),
          ),
          if (_events.isEmpty)
            const EmptyStateView(
              icon: Icons.event_outlined,
              title: 'No events listed yet',
              message: 'Approved community events will appear here. Pull to refresh.',
            )
          else
            ..._events.map((e) {
              final loc = [
                e['venue'],
                e['city'],
              ].where((x) => x != null && x.toString().trim().isNotEmpty).join(', ');
              final image = e['imagePath']?.toString() ??
                  e['bannerUrl']?.toString() ??
                  e['bannerImage']?.toString();
              final isFree = e['free'] == true || ((e['entryFee'] is num) && (e['entryFee'] as num) <= 0);
              final already = e['alreadyRegistered'] == true;
              final full = e['full'] == true;
              String cta;
              if (already) {
                cta = e['myPaid'] == true ? 'View ticket' : 'Complete payment';
              } else if (full) {
                cta = 'Full';
              } else {
                cta = 'View & Register';
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DetailListingCard(
                  title: e['name']?.toString() ?? 'Event',
                  eyebrow: WomenEventCatalog.labelFor(
                    e['categoryLabel']?.toString() ?? e['category']?.toString(),
                  ),
                  location: loc.isEmpty ? e['eventDate']?.toString() : '$loc · ${e['eventDate'] ?? ''}',
                  photoUrl: (image == null || image.isEmpty) ? null : image,
                  showMediaActions: false,
                  tags: [
                    DetailTag(
                      label: isFree ? 'Free' : '₹${e['entryFee'] ?? 0}',
                      icon: Icons.currency_rupee,
                      background: const Color(0xFFE0E7FF),
                      foreground: const Color(0xFF3730A3),
                    ),
                    if (e['eventDate'] != null)
                      DetailTag(label: '${e['eventDate']}', icon: Icons.event),
                    if (e['seatsRemaining'] != null)
                      DetailTag(
                        label: '${e['seatsRemaining']} left',
                        icon: Icons.groups_outlined,
                      )
                    else if (e['capacity'] != null || e['maxParticipants'] != null)
                      DetailTag(
                        label: '${e['capacity'] ?? e['maxParticipants']} seats',
                        icon: Icons.groups_outlined,
                      ),
                    if (already)
                      const DetailTag(
                        label: 'Registered',
                        icon: Icons.check_circle_outline,
                        background: Color(0xFFDCFCE7),
                        foreground: Color(0xFF166534),
                      ),
                    if (e['rating'] != null && (e['rating'] is num) && (e['rating'] as num) > 0)
                      DetailTag(
                        label: '${(e['rating'] as num).toStringAsFixed(1)}',
                        icon: Icons.star,
                      ),
                  ],
                  primaryLabel: cta,
                  onPrimary: full && !already ? null : () => _openDetail(e),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTicketsTab() {
    if (_loadingRegs) return ModuleTheme.loading();
    if (_regsError != null) return ModuleTheme.errorView(_regsError!, _loadRegistrations);

    return RefreshIndicator(
      onRefresh: _loadRegistrations,
      child: _registrations.isEmpty
          ? ListView(
              children: [
                EmptyStateView(
                  icon: Icons.confirmation_number_outlined,
                  title: 'No tickets yet',
                  message: 'Register for an approved event to get your ticket code here.',
                  actionLabel: 'Browse Events',
                  onAction: () => _tabs.animateTo(0),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _registrations.length,
              itemBuilder: (_, i) {
                final r = _registrations[i];
                final event = r['event'] is Map
                    ? Map<String, dynamic>.from(r['event'] as Map)
                    : <String, dynamic>{};
                final name = event['name']?.toString() ?? 'Event';
                final needsPay = r['paymentRequired'] == true;
                final cancelled = (r['status']?.toString().toUpperCase() ?? '') == 'CANCELLED';
                final registrationId = r['registrationId'] is num
                    ? (r['registrationId'] as num).toInt()
                    : int.tryParse('${r['registrationId'] ?? r['id']}');
                final amount = (r['amount'] is num)
                    ? (r['amount'] as num).toDouble()
                    : double.tryParse('${event['entryFee']}') ?? 0;
                return DetailListingCard(
                  title: name,
                  eyebrow: cancelled
                      ? 'Cancelled'
                      : needsPay
                          ? 'Payment pending'
                          : 'Ticket',
                  location: event['venue']?.toString() ?? event['city']?.toString(),
                  showMediaActions: false,
                  tags: [
                    DetailTag(
                      label: r['ticketCode']?.toString() ?? '—',
                      icon: Icons.confirmation_number_outlined,
                      background: const Color(0xFFFEF3C7),
                      foreground: const Color(0xFFB45309),
                    ),
                    if (r['registeredAt'] != null)
                      DetailTag(label: '${r['registeredAt']}', icon: Icons.schedule),
                    if (r['status'] != null)
                      DetailTag(label: '${r['status']}', icon: Icons.info_outline),
                    if (needsPay)
                      const DetailTag(label: 'Pay to confirm', icon: Icons.payment),
                    if (r['checkedIn'] == true)
                      const DetailTag(
                        label: 'Checked in',
                        icon: Icons.verified,
                        background: Color(0xFFDCFCE7),
                        foreground: Color(0xFF166534),
                      ),
                  ],
                  primaryLabel: needsPay
                      ? (_paying ? 'Paying…' : 'Pay now')
                      : 'Ticket details',
                  onPrimary: needsPay && registrationId != null && !_paying
                      ? () => _payForRegistration(
                            registrationId: registrationId,
                            amount: amount,
                            eventName: name,
                          )
                      : () => _showTicketDetails(r),
                );
              },
            ),
    );
  }
}
