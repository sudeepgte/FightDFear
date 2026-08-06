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

  Future<Map<String, dynamic>> updateAppointmentStatus(int id, String status) =>
      _api.post(
        '/api/doctors/provider/appointments/$id/status',
        doctorAuth: true,
        body: {'status': status},
      );

  Future<Map<String, dynamic>> savePrescription(int id, String prescriptionText) =>
      _api.post('/api/doctors/provider/appointments/$id/prescription', doctorAuth: true, body: {
        'prescriptionText': prescriptionText,
      });

  Future<Map<String, dynamic>> joinAppointment(int id, {bool audioOnly = false}) =>
      _api.get('/api/doctors/appointments/$id/join?audioOnly=$audioOnly', doctorAuth: true);

  Future<Map<String, dynamic>> chatHistory(int doctorId, {required int userId}) =>
      _api.get('/api/doctors/$doctorId/chat?userId=$userId', doctorAuth: true);

  Future<Map<String, dynamic>> sendChat(int doctorId, {required int userId, required String message}) =>
      _api.post('/api/doctors/$doctorId/chat', doctorAuth: true, body: {
        'userId': userId,
        'message': message,
      });
}
