import 'api_client.dart';

class DoctorAuthService {
  DoctorAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post(
        '/api/doctors/provider/register',
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
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/doctors/provider/me');

  Future<Map<String, dynamic>> updateAppointmentStatus(int id, String status) =>
      _api.post('/api/doctors/provider/appointments/$id/status', body: {'status': status});

  Future<Map<String, dynamic>> savePrescription(int id, String prescriptionText) =>
      _api.post('/api/doctors/provider/appointments/$id/prescription', body: {
        'prescriptionText': prescriptionText,
      });

  Future<Map<String, dynamic>> joinAppointment(int id, {bool audioOnly = false}) =>
      _api.get('/api/doctors/appointments/$id/join?audioOnly=$audioOnly');

  Future<Map<String, dynamic>> chatHistory(int doctorId, {required int userId}) =>
      _api.get('/api/doctors/$doctorId/chat?userId=$userId');

  Future<Map<String, dynamic>> sendChat(int doctorId, {required int userId, required String message}) =>
      _api.post('/api/doctors/$doctorId/chat', body: {
        'userId': userId,
        'message': message,
      });
}
