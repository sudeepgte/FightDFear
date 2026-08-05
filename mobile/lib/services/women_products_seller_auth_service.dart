import 'api_client.dart';

class WomenProductsSellerAuthService {
  WomenProductsSellerAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/women-products/seller/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/women-products/seller/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/women-products/seller/me');

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> body) =>
      _api.post('/api/women-products/seller/products', body: body);

  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) =>
      _api.post('/api/women-products/seller/orders/$id/status', body: {'status': status});
}
