import 'package:http/http.dart' as http;

import 'auth_state.dart';
import 'api_client.dart';

/// Women Jobs worker portal — quick register, login, then profile completion.
class WomenJobsAuthService {
  WomenJobsAuthService(this._api, [AuthState? _]);

  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/marketplace/jobs/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/marketplace/jobs/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/marketplace/jobs/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/marketplace/jobs/dashboard', womenJobsAuth: true);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/marketplace/jobs/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveWomenJobsToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/marketplace/jobs/profile', womenJobsAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/marketplace/jobs/profile',
        womenJobsAuth: true,
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/marketplace/jobs/submit-verification', womenJobsAuth: true);

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/marketplace/jobs/payout/request', womenJobsAuth: true);

  Future<Map<String, dynamic>> updateBookingNotes(int id, String coachNotes) =>
      _api.post('/api/job-bookings/$id/notes',
          womenJobsAuth: true, body: {'coachNotes': coachNotes});

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
      '/api/marketplace/jobs/photos',
      files: files,
      womenJobsAuth: true,
    );
  }

  Future<void> logout() => _api.clearWomenJobsToken();
}
