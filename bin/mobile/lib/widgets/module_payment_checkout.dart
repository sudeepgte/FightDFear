import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/payment_service.dart';

/// Shared Razorpay checkout used by Glow, Fitness, Events, Martial Arts, etc.
class ModulePaymentCheckout {
  ModulePaymentCheckout(this._payments);

  final PaymentService _payments;
  Razorpay? _razorpay;
  Map<String, dynamic> Function(PaymentSuccessResponse response)? _verifyPayload;
  void Function()? _onSuccess;
  void Function(String message)? _onError;
  bool _paying = false;
  bool _verifying = false;

  void bind({
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onError,
  }) {
    _razorpay ??= Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }

  Future<void> pay({
    required BuildContext context,
    required double amount,
    required Map<String, dynamic> Function(PaymentSuccessResponse response) verifyPayload,
    VoidCallback? onSuccess,
    void Function(String message)? onError,
    String description = 'Payment',
  }) async {
    if (_paying) return;
    if (amount <= 0) {
      onError?.call('No payment required');
      return;
    }
    _paying = true;
    _verifyPayload = verifyPayload;
    _onSuccess = onSuccess;
    _onError = onError;

    try {
      final orderRes = await _payments.createOrder(amount);
      if (!context.mounted) return;

      if (orderRes['orderId'] == null || orderRes['key'] == null) {
        final msg = orderRes['error']?.toString() ?? 'Payment gateway unavailable';
        onError?.call(msg);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      if (orderRes['mock'] == true) {
        await _verify(
          context,
          PaymentSuccessResponse(
            'mock_pay_${DateTime.now().millisecondsSinceEpoch}',
            orderRes['orderId']?.toString(),
            'mock_sig',
            <dynamic, dynamic>{'mock': true},
          ),
        );
        return;
      }

      _razorpay ??= Razorpay();
      _razorpay!.open({
        'key': orderRes['key'],
        'amount': orderRes['amount'],
        'currency': orderRes['currency'] ?? 'INR',
        'order_id': orderRes['orderId'],
        'name': 'Fight D Fear',
        'description': description,
        'theme': {'color': '#F43F5E'},
      });
    } finally {
      _paying = false;
    }
  }

  Future<void> handleSuccess(BuildContext context, PaymentSuccessResponse response) async {
    await _verify(context, response);
  }

  void handleError(PaymentFailureResponse response) {
    final msg = response.message ?? 'Payment cancelled or failed';
    _onError?.call(msg);
  }

  Future<void> _verify(BuildContext context, PaymentSuccessResponse response) async {
    if (_verifyPayload == null || _verifying) return;
    _verifying = true;
    try {
      final payload = _verifyPayload!(response);
      final verify = await _payments.verifyWithRetry(payload);
      if (!context.mounted) return;
      if (verify['error'] != null) {
        final msg = verify['error'].toString();
        _onError?.call(msg);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }
      _onSuccess?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful')),
      );
    } catch (e) {
      if (!context.mounted) return;
      final msg = '$e';
      _onError?.call(msg);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      _verifying = false;
    }
  }
}
