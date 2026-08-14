import 'api_client.dart';

/// Admin martial arts centre approval.
class MartialArtsAdminService {
  MartialArtsAdminService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/martial-arts/admin/login',
      body: {'email': email.trim(), 'password': password},
      auth: false,
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveAdminToken(res['token'].toString());
    }
    return res;
  }

  Future<void> logout() => _api.clearAdminToken();

  Future<bool> isLoggedIn() async {
    final t = await _api.getAdminToken();
    return t != null && t.isNotEmpty;
  }

  Future<Map<String, dynamic>> listCentres({String status = 'pending'}) =>
      _api.get('/api/martial-arts/admin/centres?status=$status',
          auth: false, adminAuth: true);

  Future<Map<String, dynamic>> approve(int id) => _api.post(
        '/api/martial-arts/admin/centres/$id/approve',
        auth: false,
        adminAuth: true,
      );

  Future<Map<String, dynamic>> reject(int id) => _api.post(
        '/api/martial-arts/admin/centres/$id/reject',
        auth: false,
        adminAuth: true,
      );
}
