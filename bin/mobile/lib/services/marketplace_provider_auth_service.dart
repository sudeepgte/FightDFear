import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Marketplace / Service Partner auth — quick register, login, profile completion.
class MarketplaceProviderAuthService {
  MarketplaceProviderAuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/marketplace/provider/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/marketplace/provider/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/marketplace/provider/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  /// Legacy full registration — kept for older clients.
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
    String? expectedCategory,
  }) async {
    final res = await _api.post(
      '/api/marketplace/provider/login',
      auth: false,
      body: {
        'email': email.trim().toLowerCase(),
        'password': password,
        if (expectedCategory != null && expectedCategory.isNotEmpty)
          'expectedCategory': expectedCategory,
      },
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/marketplace/provider/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/marketplace/provider/profile',
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/marketplace/provider/submit-verification');

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/marketplace/provider/me');

  Future<Map<String, dynamic>> updateBookingStatus(int bookingId, String status) =>
      _api.post('/api/marketplace/provider/bookings/$bookingId/status', body: {
        'status': status,
      });

  Future<Map<String, dynamic>> addClass(Map<String, dynamic> payload) =>
      _api.post('/api/marketplace/provider/classes', body: payload);

  Future<Map<String, dynamic>> bookingMessages(int bookingId) =>
      _api.get('/api/marketplace/provider/bookings/$bookingId/messages');

  Future<Map<String, dynamic>> sendBookingMessage(int bookingId, String content) =>
      _api.post('/api/marketplace/provider/bookings/$bookingId/messages', body: {
        'content': content,
      });

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/marketplace/provider/payout/request');

  Future<Map<String, dynamic>> updateBookingNotes(int id, String coachNotes) =>
      _api.post('/api/marketplace/provider/bookings/$id/notes', body: {'coachNotes': coachNotes});

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
      '/api/marketplace/provider/photos',
      files: files,
      auth: true,
    );
  }
}
