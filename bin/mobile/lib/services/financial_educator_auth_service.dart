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
      await _api.saveFinancialEducatorToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/financial-literacy/educator/profile', financialEducatorAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put('/api/financial-literacy/educator/profile',
          financialEducatorAuth: true, body: body, timeout: const Duration(seconds: 30));

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/financial-literacy/educator/submit-verification',
          financialEducatorAuth: true);

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/financial-literacy/educator/me', financialEducatorAuth: true);

  Future<Map<String, dynamic>> addVideo(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/videos',
          financialEducatorAuth: true, body: body);

  Future<Map<String, dynamic>> deleteVideo(int id) =>
      _api.delete('/api/financial-literacy/educator/videos/$id', financialEducatorAuth: true);

  Future<Map<String, dynamic>> addLive(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/live-sessions',
          financialEducatorAuth: true, body: body);

  Future<Map<String, dynamic>> deleteLive(int id) =>
      _api.delete('/api/financial-literacy/educator/live-sessions/$id',
          financialEducatorAuth: true);

  Future<Map<String, dynamic>> addWorkshop(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/educator/workshops',
          financialEducatorAuth: true, body: body);

  Future<Map<String, dynamic>> deleteWorkshop(int id) =>
      _api.delete('/api/financial-literacy/educator/workshops/$id',
          financialEducatorAuth: true);

  Future<Map<String, dynamic>> setEnrollmentStatus(int id, String status) =>
      _api.post('/api/financial-literacy/educator/enrollments/$id/status',
          financialEducatorAuth: true, body: {'status': status});

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/financial-literacy/educator/payout/request',
          financialEducatorAuth: true);

  Future<Map<String, dynamic>> updateEnrollmentNotes(int id, String coachNotes) =>
      _api.post('/api/financial-literacy/educator/enrollments/$id/notes',
          financialEducatorAuth: true, body: {'coachNotes': coachNotes});

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
      financialEducatorAuth: true,
    );
  }

  Future<void> logout() => _api.clearFinancialEducatorToken();
}
