import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/women_event_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/module_services.dart';
import '../../services/payment_service.dart';
import '../../widgets/digital_ticket_dialog.dart';
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
      _event['venueArea'],
      _event['city'],
      _event['venueState'],
      _event['venuePincode'],
    ].where((e) => e != null && '$e'.trim().isNotEmpty).join(', ');
    return venue.isEmpty ? 'Venue not provided' : venue;
  }

  void _openTicketModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => DigitalTicketDialog(
        ticketCode: _event['myTicketCode']?.toString() ?? 'WE-${_event['id']}',
        qrToken: _event['qrToken']?.toString(),
        eventName: _event['name']?.toString() ?? 'Event',
        eventDate: _event['eventDate']?.toString(),
        eventTime: _event['eventTime']?.toString(),
        venue: _event['venue']?.toString(),
        city: _event['city']?.toString(),
        mapsLocation: _event['mapsLocation']?.toString(),
        eventFormat: _event['eventFormat']?.toString() ?? 'OFFLINE',
        virtual: _event['virtual'] == true,
        streamLink: _event['streamLink']?.toString(),
        meetingPlatform: _event['meetingPlatform']?.toString(),
        status: _event['myStatus']?.toString() ?? 'CONFIRMED',
        checkedIn: _event['checkedIn'] == true,
        amountPaid: _fee,
        ticketTypeName: _event['ticketTypeName']?.toString() ?? 'Standard Pass',
        canCancel: true,
        onCancel: () {
          Navigator.of(context, rootNavigator: true).pop();
          // User can cancel from the tickets tab
        },
        canReview: true,
        onReview: () {
          Navigator.of(context, rootNavigator: true).pop();
          // User can review from the tickets tab
        },
      ),
    );
  }

  Future<void> _openGoogleMaps() async {
    final raw = _event['mapsLocation']?.toString().trim();
    Uri? uri;
    if (raw != null && raw.isNotEmpty && (raw.startsWith('http://') || raw.startsWith('https://'))) {
      uri = Uri.tryParse(raw);
    }
    if (uri == null) {
      final query = [
        _event['venue'],
        _event['venueArea'],
        _event['city'],
        _event['venueState'],
        _event['venuePincode'],
      ].where((s) => s != null && '$s'.trim().isNotEmpty).join(', ');
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openStreamLink() async {
    final raw = _event['streamLink']?.toString().trim();
    if (raw == null || raw.isEmpty) return;
    var uri = Uri.tryParse(raw);
    if (uri != null && !uri.hasScheme) {
      uri = Uri.tryParse('https://$raw');
    }
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callContact(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _emailContact(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
            const Text(
              'Review Registration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WomenEventDetailScreen.navy),
            ),
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
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(backgroundColor: WomenEventDetailScreen.primary),
                    child: Text(_fee > 0 ? 'Proceed to Pay' : 'Confirm Registration'),
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
            Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF166534), size: 24),
                SizedBox(width: 8),
                Text(
                  'Registration Confirmed!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(_event['name']?.toString() ?? 'Event',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (ticketCode != null && ticketCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Ticket code: $ticketCode',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFB45309), fontFamily: 'monospace')),
              ),
            ],
            const SizedBox(height: 8),
            Text('Date: ${_event['eventDate'] ?? 'Not provided'} ${_event['eventTime'] ?? ''}'),
            Text(_venueLine()),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openTicketModal();
                    },
                    icon: const Icon(Icons.qr_code, size: 18),
                    label: const Text('View Ticket'),
                    style: FilledButton.styleFrom(backgroundColor: WomenEventDetailScreen.primary),
                  ),
                ),
              ],
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
    final banner = _event['imagePath']?.toString() ??
        _event['bannerUrl']?.toString() ??
        _event['bannerImage']?.toString();
    final format = (_event['eventFormat']?.toString().toUpperCase() ??
        (_event['virtual'] == true ? 'ONLINE' : 'OFFLINE'));
    final isOnlineOrHybrid = format == 'ONLINE' || format == 'HYBRID' || _event['virtual'] == true;
    final isOfflineOrHybrid = format == 'OFFLINE' || format == 'HYBRID' || _event['virtual'] != true;

    String ctaLabel;
    IconData ctaIcon = Icons.arrow_forward;
    if (_full && !_already) {
      ctaLabel = 'Event full';
      ctaIcon = Icons.block;
    } else if (_already && _myPaid) {
      ctaLabel = 'View Digital Ticket';
      ctaIcon = Icons.confirmation_number_outlined;
    } else if (_needsPay) {
      ctaLabel = 'Pay now · ₹${_fee.toStringAsFixed(0)}';
      ctaIcon = Icons.payment;
    } else if (_fee > 0) {
      ctaLabel = 'Review & Pay · ₹${_fee.toStringAsFixed(0)}';
      ctaIcon = Icons.payment;
    } else {
      ctaLabel = 'Register Free';
      ctaIcon = Icons.check_circle_outline;
    }

    final canTap = !_registering && ((_needsPay) || (!_already && !_full) || (_already && _myPaid));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Event details'),
        backgroundColor: Colors.white,
        foregroundColor: WomenEventDetailScreen.navy,
        elevation: 0,
        actions: [
          if (_already && _myPaid)
            IconButton(
              icon: const Icon(Icons.confirmation_number_outlined, color: WomenEventDetailScreen.primary),
              tooltip: 'Digital Ticket',
              onPressed: _openTicketModal,
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: canTap
                ? () {
                    if (_already && _myPaid) {
                      _openTicketModal();
                    } else {
                      _register();
                    }
                  }
                : null,
            icon: _registering
                ? const SizedBox.shrink()
                : Icon(ctaIcon, size: 18),
            label: _registering
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(ctaLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            style: FilledButton.styleFrom(
              backgroundColor: (_already && _myPaid) ? const Color(0xFF0F172A) : WomenEventDetailScreen.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
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
                      // Active Registration Banner
                      if (_already && _myPaid) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF1F2), Color(0xFFFCE7F3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDA4AF)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF43F5E).withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.confirmation_number, color: Color(0xFFE11D48), size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('You are registered!',
                                        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A), fontSize: 15)),
                                    if (_event['myTicketCode'] != null)
                                      Text('Ticket: ${_event['myTicketCode']}',
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFE11D48),
                                            fontSize: 13,
                                          )),
                                    Text(
                                      _event['checkedIn'] == true ? 'Attendance verified' : 'Show QR ticket at entry',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(
                                onPressed: _openTicketModal,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE11D48),
                                  side: const BorderSide(color: Color(0xFFE11D48)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: const Text('View Ticket', style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Event Banner Image
                      if (banner != null && banner.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              ModuleTheme.networkImage(
                                banner,
                                height: 210,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: WomenEventDetailScreen.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                              if (format == 'ONLINE')
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1D4ED8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.videocam, size: 12, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text('ONLINE',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Event Title
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: WomenEventDetailScreen.navy,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (banner == null || banner.isEmpty) ...[
                        Text(
                          category,
                          style: const TextStyle(
                            color: WomenEventDetailScreen.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Short description lead if available
                      if (_event['shortDescription'] != null &&
                          _event['shortDescription'].toString().trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          _event['shortDescription'].toString(),
                          style: const TextStyle(fontSize: 14, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // High-level metadata badges
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Format Badge
                          _chip(
                            format == 'ONLINE'
                                ? Icons.videocam
                                : (format == 'HYBRID' ? Icons.sensors : Icons.place_outlined),
                            format == 'ONLINE'
                                ? 'Virtual / Online'
                                : (format == 'HYBRID' ? 'Hybrid Event' : 'In-person'),
                          ),
                          _chip(
                            Icons.currency_rupee,
                            _fee <= 0 ? 'Free entry' : '₹${_fee.toStringAsFixed(0)} ticket',
                          ),
                          if (_event['boothFee'] != null &&
                              (_event['boothFee'] is num) &&
                              (_event['boothFee'] as num) > 0)
                            _chip(Icons.storefront, 'Stall: ₹${_event['boothFee']}'),
                          if (seatsRemaining != null)
                            _chip(Icons.groups_outlined, '$seatsRemaining seats left')
                          else if (seatsTaken != null)
                            _chip(Icons.groups_outlined, '$seatsTaken registered'),
                          if (_event['rating'] is num && (_event['rating'] as num) > 0)
                            _chip(Icons.star, (_event['rating'] as num).toStringAsFixed(1)),
                        ],
                      ),

                      // Schedule & Timing Card
                      const SizedBox(height: 20),
                      _sectionCard(
                        title: 'Date & Timing',
                        icon: Icons.calendar_month,
                        child: Column(
                          children: [
                            _infoRow(
                              Icons.play_circle_outline,
                              'Starts',
                              '${_event['eventDate'] ?? 'Date TBD'}${_event['eventTime'] != null ? ' at ${_event['eventTime']}' : ''}',
                            ),
                            if (_event['endDate'] != null && _event['endDate'].toString().trim().isNotEmpty) ...[
                              const Divider(height: 16),
                              _infoRow(
                                Icons.stop_circle_outlined,
                                'Ends',
                                '${_event['endDate']}${_event['endTime'] != null ? ' at ${_event['endTime']}' : ''}',
                              ),
                            ],
                            if (_event['registrationClosesAt'] != null || _event['registrationCloses'] != null) ...[
                              const Divider(height: 16),
                              _infoRow(
                                Icons.timer_outlined,
                                'Registration Closes',
                                '${_event['registrationClosesAt'] ?? _event['registrationCloses']}',
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Online Streaming / Platform Card (for ONLINE or HYBRID events)
                      if (isOnlineOrHybrid) ...[
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Virtual Session Access',
                          icon: Icons.videocam_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_event['meetingPlatform'] != null &&
                                  _event['meetingPlatform'].toString().trim().isNotEmpty)
                                _infoRow(
                                  Icons.devices,
                                  'Platform',
                                  '${_event['meetingPlatform']}',
                                ),
                              if (_already && _myPaid) ...[
                                if (_event['streamLink'] != null &&
                                    _event['streamLink'].toString().trim().isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.icon(
                                      onPressed: _openStreamLink,
                                      icon: const Icon(Icons.open_in_new, size: 16),
                                      label: const Text('Join Stream / Meeting'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF1D4ED8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Link: ${_event['streamLink']}',
                                    style: const TextStyle(fontSize: 11, color: ModuleTheme.textGray),
                                  ),
                                ] else ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Stream link will be posted by host shortly before session starts.',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                  ),
                                ],
                              ] else ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFBFDBFE)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.lock_outline, color: Color(0xFF1D4ED8), size: 20),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Meeting join link is unlocked once you complete registration.',
                                          style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A), fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],

                      // Venue & Location Card (for OFFLINE or HYBRID events)
                      if (isOfflineOrHybrid) ...[
                        const SizedBox(height: 16),
                        _sectionCard(
                          title: 'Venue & Location',
                          icon: Icons.place_outlined,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(
                                Icons.business,
                                'Venue',
                                _event['venue']?.toString() ?? 'Venue details provided upon booking',
                              ),
                              if (_event['venueArea'] != null &&
                                  _event['venueArea'].toString().trim().isNotEmpty) ...[
                                const Divider(height: 16),
                                _infoRow(Icons.near_me_outlined, 'Area', '${_event['venueArea']}'),
                              ],
                              const Divider(height: 16),
                              _infoRow(
                                Icons.map_outlined,
                                'City / State',
                                [
                                  _event['city'],
                                  _event['venueState'],
                                  _event['venuePincode'],
                                ].where((s) => s != null && '$s'.trim().isNotEmpty).join(', '),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _openGoogleMaps,
                                  icon: const Icon(Icons.directions, size: 18),
                                  label: const Text('Get Directions in Google Maps'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: WomenEventDetailScreen.navy,
                                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // About the Event Card
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'About The Event',
                        icon: Icons.info_outline,
                        child: Text(
                          (_event['description']?.toString().trim().isNotEmpty == true)
                              ? _event['description'].toString()
                              : 'No detailed description provided yet.',
                          style: const TextStyle(height: 1.5, color: Color(0xFF334155), fontSize: 14),
                        ),
                      ),

                      // Policies & Attendee Requirements Card
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'Policies & Requirements',
                        icon: Icons.policy_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_event['ageRestriction'] != null &&
                                _event['ageRestriction'].toString().trim().isNotEmpty) ...[
                              _infoRow(Icons.person_outline, 'Age Restriction', '${_event['ageRestriction']}'),
                              const Divider(height: 16),
                            ],
                            if (_event['whatToBring'] != null &&
                                _event['whatToBring'].toString().trim().isNotEmpty) ...[
                              _infoRow(Icons.backpack_outlined, 'What To Bring', '${_event['whatToBring']}'),
                              const Divider(height: 16),
                            ],
                            if (_event['participantRequirements'] != null &&
                                _event['participantRequirements'].toString().trim().isNotEmpty) ...[
                              _infoRow(Icons.checklist_rtl, 'Requirements', '${_event['participantRequirements']}'),
                              const Divider(height: 16),
                            ],
                            _infoRow(
                              Icons.cancel_outlined,
                              'Cancellation Policy',
                              (_event['cancellationPolicy'] != null &&
                                      _event['cancellationPolicy'].toString().trim().isNotEmpty)
                                  ? _event['cancellationPolicy'].toString()
                                  : WomenEventCatalog.cancelPolicy,
                            ),
                            if (_event['refundPolicy'] != null &&
                                _event['refundPolicy'].toString().trim().isNotEmpty) ...[
                              const Divider(height: 16),
                              _infoRow(Icons.currency_exchange, 'Refund Policy', '${_event['refundPolicy']}'),
                            ],
                          ],
                        ),
                      ),

                      // Organizer & Contact Card
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'Organizer & Host',
                        icon: Icons.supervised_user_circle_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(
                              Icons.business_center_outlined,
                              'Organizer',
                              '${_event['organizerName'] ?? 'Community Host'}'
                              '${_event['organizerType'] != null ? ' · ${_event['organizerType']}' : ''}',
                            ),
                            if (_event['contactInfo'] != null &&
                                _event['contactInfo'].toString().trim().isNotEmpty) ...[
                              const Divider(height: 16),
                              _infoRow(Icons.contact_mail_outlined, 'Contact', '${_event['contactInfo']}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (_event['contactInfo'].toString().contains('@'))
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _emailContact(_event['contactInfo'].toString()),
                                        icon: const Icon(Icons.email_outlined, size: 16),
                                        label: const Text('Email'),
                                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () => _callContact(_event['contactInfo'].toString()),
                                        icon: const Icon(Icons.phone_outlined, size: 16),
                                        label: const Text('Call'),
                                        style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFDA4AF)),
                          ),
                          child: Text(_error!, style: const TextStyle(color: Color(0xFF9F1239))),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x050F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: WomenEventDetailScreen.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: WomenEventDetailScreen.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),
        ),
      ],
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
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
