import 'package:http/http.dart' as http;

import 'api_client.dart';

class FinancialEducatorAuthService {
  FinancialEducatorAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/financial-literacy/educator/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/financial-literacy/educator/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/financial-literacy/educator/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/financial-literacy/educator/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/financial-literacy/educator/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put('/api/financial-literacy/educator/profile',
          body: body, timeout: const Duration(seconds: 30));

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/financial-literacy/educator/submit-verification');

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/financial-literacy/educator/me');

  Future<Map<String, dynamic>> addVideo(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/videos', body: body);

  Future<Map<String, dynamic>> deleteVideo(int id) =>
      _api.delete('/api/financial-literacy/educator/videos/$id');

  Future<Map<String, dynamic>> addLive(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/live-sessions', body: body);

  Future<Map<String, dynamic>> deleteLive(int id) =>
      _api.delete('/api/financial-literacy/educator/live-sessions/$id');

  Future<Map<String, dynamic>> addWorkshop(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/workshops', body: body);

  Future<Map<String, dynamic>> deleteWorkshop(int id) =>
      _api.delete('/api/financial-literacy/educator/workshops/$id');

  Future<Map<String, dynamic>> setEnrollmentStatus(int id, String status) =>
      _api.post('/api/financial-literacy/educator/enrollments/$id/status',
          body: {'status': status});

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/financial-literacy/educator/payout/request');

  Future<Map<String, dynamic>> updateEnrollmentNotes(int id, String coachNotes) =>
      _api.post('/api/financial-literacy/educator/enrollments/$id/notes',
          body: {'coachNotes': coachNotes});

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
      '/api/financial-literacy/educator/photos',
      files: files,
      auth: true,
    );
  }
}
