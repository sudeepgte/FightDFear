import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/digital_ticket_dialog.dart';
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
  String _formatFilter = 'ALL';
  String _priceFilter = 'ALL';
  final _searchFilter = TextEditingController();
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
    _searchFilter.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      bool? isFree;
      if (_priceFilter == 'FREE') isFree = true;
      if (_priceFilter == 'PAID') isFree = false;

      final res = await _api.list(
        category: _category == 'all' ? null : _category,
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        format: _formatFilter == 'ALL' ? null : _formatFilter,
        free: isFree,
        search: _searchFilter.text.trim().isEmpty ? null : _searchFilter.text.trim(),
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => DigitalTicketDialog(
        ticketCode: r['ticketCode']?.toString() ?? '—',
        qrToken: r['qrToken']?.toString(),
        eventName: event['name']?.toString() ?? 'Event',
        attendeeName: r['attendeeName']?.toString(),
        eventDate: event['eventDate']?.toString(),
        eventTime: event['eventTime']?.toString(),
        venue: event['venue']?.toString(),
        city: event['city']?.toString(),
        mapsLocation: event['mapsLocation']?.toString(),
        eventFormat: event['eventFormat']?.toString() ?? 'OFFLINE',
        virtual: event['virtual'] == true,
        streamLink: event['streamLink']?.toString(),
        meetingPlatform: event['meetingPlatform']?.toString(),
        status: r['status']?.toString() ?? 'REGISTERED',
        checkedIn: r['checkedIn'] == true,
        checkedInAt: r['checkedInAt']?.toString(),
        amountPaid: (r['amountPaid'] is num) ? (r['amountPaid'] as num).toDouble() : 0.0,
        ticketTypeName: r['ticketTypeName']?.toString() ?? 'General',
        canCancel: r['canCancel'] == true,
        onCancel: r['canCancel'] == true
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                _cancelRegistration(r);
              }
            : null,
        canReview: r['canReview'] == true,
        onReview: r['canReview'] == true
            ? () {
                Navigator.of(context, rootNavigator: true).pop();
                _rateRegistration(r);
              }
            : null,
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
        foregroundColor: const Color(0xFF0F172A),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchFilter,
                    decoration: InputDecoration(
                      hintText: 'Search events or keywords...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      suffixIcon: _searchFilter.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                _searchFilter.clear();
                                _loadEvents();
                              },
                            )
                          : null,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    onSubmitted: (_) => _loadEvents(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _cityFilter,
                    decoration: InputDecoration(
                      hintText: 'City',
                      prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                      suffixIcon: _cityFilter.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                _cityFilter.clear();
                                _loadEvents();
                              },
                            )
                          : null,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    onSubmitted: (_) => _loadEvents(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All Categories'),
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
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...['ALL', 'OFFLINE', 'ONLINE', 'HYBRID'].map((f) {
                    final label = f == 'ALL'
                        ? 'All Formats'
                        : (f == 'OFFLINE' ? 'In-Person' : (f == 'ONLINE' ? 'Online' : 'Hybrid'));
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(label, style: const TextStyle(fontSize: 11)),
                        selected: _formatFilter == f,
                        onSelected: (_) {
                          setState(() => _formatFilter = f);
                          _loadEvents();
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  ...['ALL', 'FREE', 'PAID'].map((p) {
                    final label = p == 'ALL' ? 'All Prices' : (p == 'FREE' ? 'Free' : 'Paid');
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(label, style: const TextStyle(fontSize: 11)),
                        selected: _priceFilter == p,
                        onSelected: (_) {
                          setState(() => _priceFilter = p);
                          _loadEvents();
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Newest', style: TextStyle(fontSize: 11)),
                    selected: _sort == 'newest',
                    onSelected: (_) {
                      setState(() => _sort = 'newest');
                      _loadEvents();
                    },
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('Top rated', style: TextStyle(fontSize: 11)),
                    selected: _sort == 'rating',
                    onSelected: (_) {
                      setState(() => _sort = 'rating');
                      _loadEvents();
                    },
                  ),
                ],
              ),
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
              final format = (e['eventFormat']?.toString().toUpperCase() ??
                  (e['virtual'] == true ? 'ONLINE' : 'OFFLINE'));
              final formatTag = format == 'ONLINE'
                  ? const DetailTag(
                      label: 'Online',
                      icon: Icons.videocam,
                      background: Color(0xFFEFF6FF),
                      foreground: Color(0xFF1D4ED8),
                    )
                  : format == 'HYBRID'
                      ? const DetailTag(
                          label: 'Hybrid',
                          icon: Icons.sensors,
                          background: Color(0xFFFAF5FF),
                          foreground: Color(0xFF7E22CE),
                        )
                      : const DetailTag(
                          label: 'In-person',
                          icon: Icons.place_outlined,
                          background: Color(0xFFF1F5F9),
                          foreground: Color(0xFF334155),
                        );
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
                    formatTag,
                    DetailTag(
                      label: isFree ? 'Free' : '₹${e['entryFee'] ?? 0}',
                      icon: Icons.currency_rupee,
                      background: const Color(0xFFFFF1F2),
                      foreground: const Color(0xFFE11D48),
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
                        label: (e['rating'] as num).toStringAsFixed(1),
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
                    if (r['ticketTypeName'] != null)
                      DetailTag(
                        label: '${r['ticketTypeName']}',
                        icon: Icons.local_activity_outlined,
                      ),
                    if (r['registeredAt'] != null)
                      DetailTag(label: '${r['registeredAt']}', icon: Icons.schedule),
                    if (r['status'] != null)
                      DetailTag(
                        label: '${r['status']}',
                        icon: Icons.info_outline,
                        background: cancelled ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                        foreground: cancelled ? const Color(0xFF991B1B) : const Color(0xFF334155),
                      ),
                    if (needsPay)
                      const DetailTag(
                        label: 'Pay to confirm',
                        icon: Icons.payment,
                        background: Color(0xFFFFF1F2),
                        foreground: Color(0xFFBE123C),
                      ),
                    DetailTag(
                      label: r['checkedIn'] == true ? 'Attended' : 'Awaiting Entry',
                      icon: r['checkedIn'] == true ? Icons.verified : Icons.access_time,
                      background: r['checkedIn'] == true ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                      foreground: r['checkedIn'] == true ? const Color(0xFF166534) : const Color(0xFF64748B),
                    ),
                  ],
                  primaryLabel: needsPay
                      ? (_paying ? 'Paying…' : 'Pay now')
                      : 'View Digital Ticket',
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
