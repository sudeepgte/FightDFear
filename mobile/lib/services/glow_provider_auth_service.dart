import 'api_client.dart';

class GlowProviderAuthService {
  GlowProviderAuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> registerSalon({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    String? phone,
    String? city,
    String? address,
    String? bio,
    String? availabilityHours,
    List<String>? categories,
    List<Map<String, dynamic>>? services,
  }) {
    return _api.post(
      '/api/glow/provider/register/salon',
      auth: false,
      body: {
        'name': name.trim(),
        'username': username.trim().toLowerCase(),
        'password': password,
        'confirmPassword': confirmPassword,
        'phone': phone?.trim() ?? '',
        'city': city?.trim() ?? '',
        'address': address?.trim() ?? '',
        'bio': bio?.trim() ?? '',
        'availabilityHours': availabilityHours?.trim() ?? '',
        if (categories != null && categories.isNotEmpty) 'categories': categories,
        if (services != null && services.isNotEmpty) 'services': services,
      },
    );
  }

  Future<Map<String, dynamic>> loginSalon({
    required String username,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/glow/provider/login/salon',
      auth: false,
      body: {'username': username.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveSalonToken(res['token'].toString());
    }
    return res;
  }

  Future<void> logoutSalon() => _api.clearSalonToken();

  Future<bool> isSalonLoggedIn() async {
    final t = await _api.getSalonToken();
    return t != null && t.isNotEmpty;
  }

  Future<Map<String, dynamic>> salonDashboard() =>
      _api.get('/api/glow/salon/me', auth: false, salonAuth: true);

  Future<Map<String, dynamic>> updateBookingStatus(int id, String status) =>
      _api.post(
        '/api/glow/salon/bookings/$id/status',
        body: {'status': status},
        auth: false,
        salonAuth: true,
      );

  Future<Map<String, dynamic>> saveService(Map<String, dynamic> body) =>
      _api.post('/api/glow/salon/services', body: body, auth: false, salonAuth: true);

  Future<Map<String, dynamic>> deleteService(int id) =>
      _api.delete('/api/glow/salon/services/$id', salonAuth: true);

  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> body) =>
      _api.post('/api/glow/salon/settings', body: body, auth: false, salonAuth: true);
}
