import 'api_client.dart';

/// Shared Razorpay checkout helpers — same backend endpoints as the web app.
class PaymentService {
  PaymentService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> config() =>
      _api.get('/payment/config', timeout: const Duration(seconds: 20));

  /// Generic amount-based order (marketplace / martial arts / glow).
  Future<Map<String, dynamic>> createOrder(double amount, {String? type, Map<String, dynamic>? extra}) =>
      _api.post(
        '/payment/create-order',
        body: {
          'amount': amount,
          if (type != null && type.isNotEmpty) 'type': type,
          ...?extra,
        },
        timeout: const Duration(seconds: 45),
      );

  /// Women Doctor paid booking — server resolves fee from doctor + consultation type.
  Future<Map<String, dynamic>> createDoctorOrder({
    required int doctorId,
    required String consultationType,
    required String appointmentTime,
    String reason = '',
  }) =>
      _api.post(
        '/payment/create-order',
        body: {
          'type': 'DOCTOR',
          'targetId': doctorId,
          'consultationType': consultationType,
          'appointmentTime': appointmentTime,
          if (reason.isNotEmpty) 'reason': reason,
        },
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> verify(Map<String, dynamic> body) => _api.post(
        '/payment/verify',
        body: body,
        timeout: const Duration(seconds: 45),
      );
}
