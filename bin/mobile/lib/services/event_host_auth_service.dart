import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Event host auth and profile — quick register, login, profile completion.
class EventHostAuthService {
  EventHostAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/women-events/host/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/women-events/host/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/women-events/host/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/women-events/host/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/women-events/host/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() => _api.get('/api/women-events/host/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) => _api.put(
        '/api/women-events/host/profile',
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/women-events/host/submit-verification');

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/women-events/host/me');

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> body) =>
      _api.post('/api/women-events/host/events', body: body);

  Future<Map<String, dynamic>> updateEvent(int id, Map<String, dynamic> body) =>
      _api.put('/api/women-events/host/events/$id', body: body);

  Future<Map<String, dynamic>> cancelEvent(int id) =>
      _api.post('/api/women-events/host/events/$id/cancel');

  Future<Map<String, dynamic>> registrations(int eventId) =>
      _api.get('/api/women-events/host/events/$eventId/registrations');

  Future<Map<String, dynamic>> checkIn(int eventId, String ticketCode) => _api.post(
        '/api/women-events/host/events/$eventId/checkin',
        body: {'ticketCode': ticketCode.trim()},
      );

  Future<Map<String, dynamic>> organizerTypes() =>
      _api.get('/api/women-events/host/organizer-types');

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/women-events/host/payout/request');

  Future<Map<String, dynamic>> updateRegistrationNotes(
    int eventId,
    int registrationId,
    String coachNotes,
  ) =>
      _api.post(
        '/api/women-events/host/events/$eventId/registrations/$registrationId/notes',
        body: {'coachNotes': coachNotes},
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
      '/api/women-events/host/photos',
      files: files,
      auth: true,
    );
  }

  Future<void> logout() => _api.clearToken();
}
