import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/glow_space_service.dart';
import '../../services/payment_service.dart';
import '../../widgets/module_payment_checkout.dart';
import 'glow_space_screen.dart';

class GlowBookingConfirmationScreen extends StatefulWidget {
  const GlowBookingConfirmationScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  State<GlowBookingConfirmationScreen> createState() => _GlowBookingConfirmationScreenState();
}

class _GlowBookingConfirmationScreenState extends State<GlowBookingConfirmationScreen> {
  late final GlowSpaceService _api;
  late final ModulePaymentCheckout _checkout;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _booking;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthState>();
    _api = GlowSpaceService(auth.api);
    _checkout = ModulePaymentCheckout(PaymentService(auth.api));
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) => _checkout.handleError(r),
    );
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
      final res = await _api.bookingConfirmation(widget.bookingId);
      if (!mounted) return;
      if (res['success'] == true && res['booking'] is Map) {
        _booking = Map<String, dynamic>.from(res['booking'] as Map);
      } else {
        _error = res['error']?.toString() ?? 'Could not load booking';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _payNow() async {
    final b = _booking;
    if (b == null) return;
    await _checkout.pay(
      context: context,
      description: 'Glow Space booking #${widget.bookingId}',
      createOrderFn: () => PaymentService(context.read<AuthState>().api)
          .createGlowBookingOrder(widget.bookingId),
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'GLOW_BOOKING',
        'bookingId': widget.bookingId,
      },
      onSuccess: _load,
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = _booking;
    final paymentStatus = b?['paymentStatus']?.toString() ?? '';
    final paymentPending = b?['paymentRequired'] == true;
    final isSuccess = !paymentPending && paymentStatus != 'PAYMENT_PENDING';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: GlowSpaceScreen.navy,
        title: const Text('Booking Confirmation'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle_rounded : Icons.schedule_rounded,
                        size: 64,
                        color: isSuccess ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isSuccess ? 'Booking confirmed' : 'Payment pending',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 20),
                      _row('Booking ID', '#${b?['bookingId'] ?? widget.bookingId}'),
                      _row('Salon', b?['salonName'] ?? b?['salon']?['name'] ?? ''),
                      _row('Service', b?['itemName'] ?? b?['item']?['name'] ?? ''),
                      _row('Type', b?['bookingType']?.toString() ?? ''),
                      _row('Date', b?['bookingDate']?.toString() ?? ''),
                      _row('Time', b?['preferredTime']?.toString() ?? ''),
                      _row('Amount', b?['free'] == true ? 'Free' : '₹${b?['amount'] ?? b?['price'] ?? 0}'),
                      _row('Payment', paymentStatus.replaceAll('_', ' ')),
                      _row('Status', b?['bookingStatus']?.toString() ?? b?['status']?.toString() ?? ''),
                      if ((b?['bookingType']?.toString() ?? '') == 'DOOR' && (b?['address']?.toString().isNotEmpty ?? false))
                        _row('Address', b!['address'].toString()),
                      const Spacer(),
                      if (paymentPending)
                        FilledButton(
                          onPressed: _payNow,
                          style: FilledButton.styleFrom(backgroundColor: GlowSpaceScreen.primary),
                          child: const Text('Pay Now'),
                        ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const GlowSpaceScreen()),
                            (route) => route.isFirst,
                          );
                        },
                        child: const Text('Back to Glow Space'),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: GlowSpaceScreen.textGray))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
