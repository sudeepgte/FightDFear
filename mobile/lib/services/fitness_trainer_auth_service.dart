import 'api_client.dart';

class FitnessTrainerAuthService {
  FitnessTrainerAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/fitness/trainer/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/fitness/trainer/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/fitness/trainer/me');

  Future<Map<String, dynamic>> updateBookingStatus(int id, String status) =>
      _api.post('/api/fitness/trainer/bookings/$id/status', body: {'status': status});
}
