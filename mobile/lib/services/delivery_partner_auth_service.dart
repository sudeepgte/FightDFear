import 'package:http/http.dart' as http;

import 'api_client.dart';

class DeliveryPartnerAuthService {
  DeliveryPartnerAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/delivery/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/delivery/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/delivery/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/delivery/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() => _api.get('/api/delivery/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put('/api/delivery/profile', body: body, timeout: const Duration(seconds: 30));

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/delivery/submit-verification');

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/delivery/me');

  Future<Map<String, dynamic>> acceptOrder(int id) =>
      _api.post('/api/delivery/orders/$id/accept');

  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) =>
      _api.post('/api/delivery/orders/$id/status', body: {'status': status});

  Future<Map<String, dynamic>> trackOrder(int id) =>
      _api.get('/api/delivery/orders/$id/track');

  Future<Map<String, dynamic>> pingLocation({
    required int orderId,
    required double lat,
    required double lng,
  }) =>
      _api.post('/api/delivery/orders/$orderId/location', body: {
        'lat': lat,
        'lng': lng,
      });

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/delivery/payout/request');

  Future<Map<String, dynamic>> updateOrderNotes(int id, String coachNotes) =>
      _api.post('/api/delivery/orders/$id/notes', body: {'coachNotes': coachNotes});

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
      '/api/delivery/photos',
      files: files,
      auth: true,
    );
  }
}
