import 'api_client.dart';

class EventHostAuthService {
  EventHostAuthService(this._api);
  final ApiClient _api;

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

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/women-events/host/me');

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> body) =>
      _api.post('/api/women-events/host/events', body: body);

  Future<Map<String, dynamic>> registrations(int eventId) =>
      _api.get('/api/women-events/host/events/$eventId/registrations');
}
