import 'package:http/http.dart' as http;

import 'auth_state.dart';
import 'api_client.dart';

class CreatorAuthService {
  CreatorAuthService(this._api, [this._auth]);

  final ApiClient _api;
  final AuthState? _auth;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/creator-hub/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/creator-hub/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/creator-hub/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/creator-hub/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
      _auth?.applyUserSession(res);
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() => _api.get('/api/creator-hub/creator-profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put('/api/creator-hub/creator-profile', body: body, timeout: const Duration(seconds: 30));

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/creator-hub/submit-verification');

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/creator-hub/payout/request');

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
      '/api/creator-hub/photos',
      files: files,
      auth: true,
    );
  }
}
