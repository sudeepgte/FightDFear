import 'api_client.dart';

/// Shared Razorpay checkout helpers — same backend endpoints as the web app.
class PaymentService {
  PaymentService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> config() =>
      _api.get('/payment/config', timeout: const Duration(seconds: 20));

  Future<Map<String, dynamic>> createOrder(double amount) => _api.post(
        '/payment/create-order',
        body: {'amount': amount},
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> verify(Map<String, dynamic> body) => _api.post(
        '/payment/verify',
        body: body,
        timeout: const Duration(seconds: 45),
      );
}
