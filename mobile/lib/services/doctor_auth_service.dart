import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class DoctorAuthService {
  DoctorAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) =>
      _api.post(
        '/api/doctors/provider/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({required String email, required String otp}) =>
      _api.post(
        '/api/doctors/provider/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/doctors/provider/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/doctors/provider/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveDoctorToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> logout() => _api.post(
        '/api/doctors/provider/logout',
        doctorAuth: true,
      );

  Future<void> clearLocalSession() => _api.clearDoctorToken();

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/doctors/provider/me', doctorAuth: true);

  Future<Map<String, dynamic>> profile() => _api.get('/api/doctors/provider/profile', doctorAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/doctors/provider/profile',
        doctorAuth: true,
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> uploadDocument({
    required String type,
    required File file,
    void Function(double progress)? onProgress,
  }) async {
    final filename = file.path.split(RegExp(r'[\\/]')).last;
    final multipart = await http.MultipartFile.fromPath(
      'file',
      file.path,
      filename: filename,
    );
    return _api.postMultipart(
      '/api/doctors/provider/documents/$type',
      doctorAuth: true,
      files: [multipart],
      onProgress: onProgress,
    );
  }

  Future<Map<String, dynamic>> deleteDocument(String type) =>
      _api.delete('/api/doctors/provider/documents/$type', doctorAuth: true);

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/doctors/provider/submit-verification', doctorAuth: true);

  Future<Map<String, dynamic>> setOnline(bool online) =>
      _api.post('/api/doctors/provider/online', doctorAuth: true, body: {'online': online});

  Future<Map<String, dynamic>> analytics() =>
      _api.get('/api/doctors/provider/analytics', doctorAuth: true);

  Future<Map<String, dynamic>> reviews() =>
      _api.get('/api/doctors/provider/reviews', doctorAuth: true);

  Future<Map<String, dynamic>> notifications() =>
      _api.get('/api/doctors/provider/notifications', doctorAuth: true);

  Future<Map<String, dynamic>> markNotificationsRead() =>
      _api.post('/api/doctors/provider/notifications/read-all', doctorAuth: true);

  Future<Map<String, dynamic>> verificationHistory() =>
      _api.get('/api/doctors/provider/verification-history', doctorAuth: true);

  Future<Map<String, dynamic>> updateAppointmentStatus(int id, String status) =>
      _api.post(
        '/api/doctors/provider/appointments/$id/status',
        doctorAuth: true,
        body: {'status': status},
      );

  Future<Map<String, dynamic>> savePrescription(
    int id,
    String prescriptionText, {
    String? prescriptionJson,
    String? doctorNotes,
  }) =>
      _api.post('/api/doctors/provider/appointments/$id/prescription', doctorAuth: true, body: {
        'prescriptionText': prescriptionText,
        if (prescriptionJson != null) 'prescriptionJson': prescriptionJson,
        if (doctorNotes != null) 'doctorNotes': doctorNotes,
      });

  Future<Map<String, dynamic>> reschedule(int id, String appointmentTime) =>
      _api.post('/api/doctors/provider/appointments/$id/reschedule', doctorAuth: true, body: {
        'appointmentTime': appointmentTime,
      });

  Future<Map<String, dynamic>> patientFile(int userId) =>
      _api.get('/api/doctors/provider/patients/$userId', doctorAuth: true);

  Future<Map<String, dynamic>> pingWaiting(int id) =>
      _api.post('/api/doctors/provider/appointments/$id/waiting', doctorAuth: true);

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/doctors/provider/payout/request', doctorAuth: true);

  Future<Map<String, dynamic>> joinAppointment(int id, {bool audioOnly = false}) =>
      _api.get('/api/doctors/appointments/$id/join?audioOnly=$audioOnly', doctorAuth: true);

  Future<Map<String, dynamic>> instantPending() =>
      _api.get('/api/doctors/provider/instant/pending', doctorAuth: true);

  Future<Map<String, dynamic>> acceptInstant(int id) =>
      _api.post('/api/doctors/provider/instant/$id/accept', doctorAuth: true);

  Future<Map<String, dynamic>> declineInstant(int id) =>
      _api.post('/api/doctors/provider/instant/$id/decline', doctorAuth: true);

  Future<Map<String, dynamic>> chatHistory(int doctorId, {required int userId}) =>
      _api.get('/api/doctors/$doctorId/chat?userId=$userId', doctorAuth: true);

  Future<Map<String, dynamic>> sendChat(
    int doctorId, {
    required int userId,
    required String message,
    String? attachmentPath,
  }) =>
      _api.post('/api/doctors/$doctorId/chat', doctorAuth: true, body: {
        'userId': userId,
        'message': message,
        if (attachmentPath != null) 'attachmentPath': attachmentPath,
      });

  Future<Map<String, dynamic>> uploadChatFile(int doctorId, {required int userId, required String filePath}) async {
    final name = filePath.split(RegExp(r'[\\/]')).last;
    final multipart = await http.MultipartFile.fromPath('file', filePath, filename: name);
    return _api.postMultipart(
      '/api/doctors/$doctorId/chat-file',
      doctorAuth: true,
      fields: {'userId': '$userId'},
      files: [multipart],
    );
  }

  Future<({List<int> bytes, int statusCode, String? filename})> prescriptionPdf(int appointmentId) =>
      _api.getBytes('/api/doctors/appointments/$appointmentId/prescription.pdf', doctorAuth: true);
}
