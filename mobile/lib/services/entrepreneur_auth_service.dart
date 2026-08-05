import 'api_client.dart';

class EntrepreneurAuthService {
  EntrepreneurAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/entrepreneur/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/entrepreneur/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/entrepreneur/me');

  Future<Map<String, dynamic>> createProposal(Map<String, dynamic> body) =>
      _api.post('/api/entrepreneur/proposals', body: body);
}
