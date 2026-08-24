import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Glow Space provider auth — salon quick register, login, profile completion.
class GlowProviderAuthService {
  GlowProviderAuthService(this._api);

  final ApiClient _api;

  // ── Salon OTP / quick register ───────────────────────────────────────────

  Future<Map<String, dynamic>> sendSalonEmailOtp(String email) => _api.post(
        '/api/glow/provider/salon/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifySalonEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/glow/provider/salon/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerSalonQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/glow/provider/salon/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  /// Legacy full registration — kept for older clients.
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
      body: {
        'email': username.trim().toLowerCase(),
        'username': username.trim().toLowerCase(),
        'password': password,
      },
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveSalonToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> salonProfile() =>
      _api.get('/api/glow/provider/salon/profile', auth: false, salonAuth: true);

  Future<Map<String, dynamic>> updateSalonProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/glow/provider/salon/profile',
        body: body,
        auth: false,
        salonAuth: true,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitSalonVerification() => _api.post(
        '/api/glow/provider/salon/submit-verification',
        auth: false,
        salonAuth: true,
      );

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

  Future<Map<String, dynamic>> updateBookingNotes(int id, String coachNotes) =>
      _api.post(
        '/api/glow/salon/bookings/$id/notes',
        body: {'coachNotes': coachNotes},
        auth: false,
        salonAuth: true,
      );

  Future<Map<String, dynamic>> requestPayout() => _api.post(
        '/api/glow/salon/payout/request',
        auth: false,
        salonAuth: true,
      );

  Future<Map<String, dynamic>> uploadPhotos({
    String? profilePath,
    String? galleryPath,
  }) async {
    final files = <http.MultipartFile>[];
    if (profilePath != null && profilePath.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath('profileImage', profilePath));
    }
    if (galleryPath != null && galleryPath.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath('galleryPhotos', galleryPath));
    }
    return _api.postMultipart(
      '/api/glow/salon/photos',
      files: files,
      salonAuth: true,
    );
  }

  // ── Stylist OTP / quick register (available if Join Us path is wired) ───

  Future<Map<String, dynamic>> sendStylistEmailOtp(String email) => _api.post(
        '/api/glow/provider/stylist/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyStylistEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/glow/provider/stylist/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerStylistQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/glow/provider/stylist/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> loginStylist({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/glow/provider/login/stylist',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveStylistToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> stylistProfile() =>
      _api.get('/api/glow/provider/stylist/profile', auth: false, stylistAuth: true);

  Future<Map<String, dynamic>> updateStylistProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/glow/provider/stylist/profile',
        body: body,
        auth: false,
        stylistAuth: true,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitStylistVerification() => _api.post(
        '/api/glow/provider/stylist/submit-verification',
        auth: false,
        stylistAuth: true,
      );
}
