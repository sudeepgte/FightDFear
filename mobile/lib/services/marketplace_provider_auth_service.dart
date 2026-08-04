import 'api_client.dart';

class MarketplaceProviderAuthService {
  MarketplaceProviderAuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String category,
    String description = '',
    String locationText = '',
  }) {
    return _api.post(
      '/api/marketplace/provider/register',
      auth: false,
      body: {
        'fullName': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'password': password,
        'confirmPassword': confirmPassword,
        'category': category.trim(),
        'description': description.trim(),
        'locationText': locationText.trim(),
      },
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/marketplace/provider/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/marketplace/provider/me');

  Future<Map<String, dynamic>> updateBookingStatus(int bookingId, String status) =>
      _api.post('/api/marketplace/provider/bookings/$bookingId/status', body: {
        'status': status,
      });

  Future<Map<String, dynamic>> addClass(Map<String, dynamic> payload) =>
      _api.post('/api/marketplace/provider/classes', body: payload);
}

