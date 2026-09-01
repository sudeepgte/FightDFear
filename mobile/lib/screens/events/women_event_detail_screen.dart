import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import '../../widgets/module_theme.dart';

/// Member event detail → register / pay.
class WomenEventDetailScreen extends StatefulWidget {
  const WomenEventDetailScreen({
    super.key,
    required this.eventId,
    this.initialSummary,
  });

  final int eventId;
  final Map<String, dynamic>? initialSummary;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF0F172A);

  @override
  State<WomenEventDetailScreen> createState() => _WomenEventDetailScreenState();
}

class _WomenEventDetailScreenState extends State<WomenEventDetailScreen> {
  late final WomenEventsService _api;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  bool _registering = false;
  String? _error;
  Map<String, dynamic> _event = {};

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = WomenEventsService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
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
    if (widget.initialSummary != null) {
      _event = Map<String, dynamic>.from(widget.initialSummary!);
    }
    _load();
  }

  @override
  void dispose() {
    _checkout.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.detail(widget.eventId);
      if (!mounted) return;
      if (res['success'] == true) {
        final e = res['event'];
        _event = e is Map ? Map<String, dynamic>.from(e) : _event;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load event';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  double get _fee {
    if (_event['free'] == true) return 0;
    final v = _event['entryFee'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }

  bool get _full => _event['full'] == true;
  bool get _already => _event['alreadyRegistered'] == true;
  bool get _myPaid => _event['myPaid'] == true;
  bool get _needsPay => _already && !_myPaid && _fee > 0;

  String _venueLine() {
    final venue = [
      _event['venue'],
      _event['city'],
    ].where((e) => e != null && '$e'.trim().isNotEmpty).join(', ');
    return venue.isEmpty ? 'Venue not provided' : venue;
  }

  Future<void> _pay(int registrationId, double amount) async {
    await _checkout.pay(
      context: context,
      amount: amount,
      description: 'Event ticket · ${_event['name'] ?? 'Event'}',
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'WOMEN_EVENT',
        'registrationId': registrationId,
        'amount': amount,
      },
      onSuccess: () async {
        await _load();
        if (!mounted) return;
        await _showConfirmationSheet(_event['myTicketCode']?.toString());
        if (mounted) Navigator.of(context).pop(true);
      },
      onError: (msg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$msg. Complete payment from My Tickets.')),
        );
      },
    );
  }

  Future<void> _register() async {
    if (_registering || _full || (_already && !_needsPay)) return;
    if (_needsPay) {
      final regId = _event['myRegistrationId'] is num
          ? (_event['myRegistrationId'] as num).toInt()
          : int.tryParse('${_event['myRegistrationId']}');
      if (regId == null) return;
      setState(() => _registering = true);
      try {
        await _pay(regId, _fee);
      } finally {
        if (mounted) setState(() => _registering = false);
      }
      return;
    }

    final confirmed = await _showReviewSheet();
    if (confirmed != true || !mounted) return;

    setState(() => _registering = true);
    try {
      final res = await _api.register(widget.eventId);
      if (!mounted) return;
      if (res['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error']?.toString() ?? 'Registration failed')),
        );
        return;
      }
      final paymentRequired = res['paymentRequired'] == true;
      final registrationId = res['registrationId'] is num
          ? (res['registrationId'] as num).toInt()
          : int.tryParse('${res['registrationId']}');
      final amount = (res['amount'] is num) ? (res['amount'] as num).toDouble() : _fee;

      if (paymentRequired && registrationId != null && amount > 0) {
        await _pay(registrationId, amount);
        await _load();
      } else {
        await _showConfirmationSheet(res['ticketCode']?.toString());
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _registering = false);
    }
  }

  Future<bool?> _showReviewSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Review registration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WomenEventDetailScreen.navy)),
            const SizedBox(height: 12),
            Text(_event['name']?.toString() ?? 'Event',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Organizer: ${_event['organizerName'] ?? 'Not provided'}'),
            Text('Date: ${_event['eventDate'] ?? 'Not provided'} ${_event['eventTime'] ?? ''}'),
            Text(_venueLine()),
            Text(_fee <= 0 ? 'Amount: Free' : 'Amount: ₹${_fee.toStringAsFixed(0)}'),
            Text('Ticket: 1 × attendee'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(backgroundColor: WomenEventDetailScreen.primary),
                    child: Text(_fee > 0 ? 'Continue' : 'Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationSheet(String? ticketCode) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Registration confirmed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF166534))),
            const SizedBox(height: 8),
            Text(_event['name']?.toString() ?? 'Event',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (ticketCode != null && ticketCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Ticket code: $ticketCode', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
            Text('Date: ${_event['eventDate'] ?? 'Not provided'} ${_event['eventTime'] ?? ''}'),
            Text(_venueLine()),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                style: FilledButton.styleFrom(backgroundColor: WomenEventDetailScreen.primary),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _event['name']?.toString() ?? 'Event';
    final category = WomenEventCatalog.labelFor(
      _event['categoryLabel']?.toString() ?? _event['category']?.toString(),
    );
    final seatsRemaining = _event['seatsRemaining'];
    final seatsTaken = _event['seatsTaken'] ?? _event['registrationCount'];

    String ctaLabel;
    if (_full && !_already) {
      ctaLabel = 'Event full';
    } else if (_already && _myPaid) {
      ctaLabel = 'Already registered';
    } else if (_needsPay) {
      ctaLabel = 'Pay now · ₹${_fee.toStringAsFixed(0)}';
    } else if (_fee > 0) {
      ctaLabel = 'Register & Pay · ₹${_fee.toStringAsFixed(0)}';
    } else {
      ctaLabel = 'Register free';
    }

    final canTap = !_registering && ((_needsPay) || (!_already && !_full));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Event details'),
        backgroundColor: Colors.white,
        foregroundColor: WomenEventDetailScreen.navy,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: canTap ? _register : null,
            style: FilledButton.styleFrom(
              backgroundColor: WomenEventDetailScreen.primary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _registering
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(ctaLabel),
          ),
        ),
      ),
      body: _loading && _event.isEmpty
          ? ModuleTheme.loading()
          : _error != null && _event.isEmpty
              ? ModuleTheme.errorView(_error!, _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: WomenEventDetailScreen.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        style: const TextStyle(
                          color: WomenEventDetailScreen.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip(Icons.event, _event['eventDate']?.toString().trim().isNotEmpty == true
                              ? _event['eventDate'].toString()
                              : 'Date not provided'),
                          if (_event['eventTime'] != null)
                            _chip(Icons.schedule, '${_event['eventTime']}'),
                          _chip(
                            Icons.place_outlined,
                            [_event['venue'], _event['city']]
                                .where((e) => e != null && '$e'.trim().isNotEmpty)
                                .join(', '),
                          ),
                          _chip(
                            Icons.currency_rupee,
                            _fee <= 0 ? 'Free entry' : '₹${_fee.toStringAsFixed(0)}',
                          ),
                          if (seatsRemaining != null)
                            _chip(Icons.groups_outlined, '$seatsRemaining seats left')
                          else if (seatsTaken != null)
                            _chip(Icons.groups_outlined, '$seatsTaken registered'),
                          if (_already)
                            _chip(
                              Icons.confirmation_number_outlined,
                              _event['myTicketCode']?.toString() ?? 'Registered',
                            ),
                          if (_event['rating'] is num && (_event['rating'] as num) > 0)
                            _chip(Icons.star, (_event['rating'] as num).toStringAsFixed(1)),
                        ],
                      ),
                      if (_event['organizerName'] != null) ...[
                        const SizedBox(height: 18),
                        const Text('Organizer', style: TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          '${_event['organizerName']}'
                          '${_event['organizerType'] != null ? ' · ${_event['organizerType']}' : ''}',
                          style: const TextStyle(color: ModuleTheme.textGray),
                        ),
                      ],
                      if (_event['contactInfo'] != null &&
                          _event['contactInfo'].toString().trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Contact: ${_event['contactInfo']}',
                            style: const TextStyle(color: ModuleTheme.textGray)),
                      ],
                      const SizedBox(height: 18),
                      const Text('About', style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                        (_event['description']?.toString().trim().isNotEmpty == true)
                            ? _event['description'].toString()
                            : 'No description provided yet.',
                        style: const TextStyle(height: 1.45, color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        WomenEventCatalog.cancelPolicy,
                        style: const TextStyle(fontSize: 12, color: ModuleTheme.textGray),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _chip(IconData icon, String label) {
    if (label.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: WomenEventDetailScreen.navy),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
