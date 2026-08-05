import 'api_client.dart';

class InvestorAuthService {
  InvestorAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/investor/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/investor/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/investor/me');

  Future<Map<String, dynamic>> marketplace() => _api.get('/api/investor/marketplace');

  Future<Map<String, dynamic>> invest(Map<String, dynamic> body) =>
      _api.post('/api/investor/invest', body: body);
}
