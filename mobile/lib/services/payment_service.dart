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
        timeout: const Duration(seconds: 30),
      );

  /// Idempotent verify with exponential backoff (network blips after Razorpay success).
  Future<Map<String, dynamic>> verifyWithRetry(
    Map<String, dynamic> body, {
    int maxAttempts = 3,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final result = await verify(body);
        if (result['error'] == null || attempt == maxAttempts - 1) {
          return result;
        }
        lastError = result['error'];
      } catch (e) {
        lastError = e;
        if (attempt == maxAttempts - 1) rethrow;
      }
      await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    }
    return {'error': lastError?.toString() ?? 'Payment verification failed'};
  }
}
