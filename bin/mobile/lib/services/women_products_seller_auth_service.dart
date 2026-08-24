import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Women Products seller auth — quick register, login, profile completion.
class WomenProductsSellerAuthService {
  WomenProductsSellerAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/women-products/seller/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/women-products/seller/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) =>
      _api.post(
        '/api/women-products/seller/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  /// Legacy full registration — kept for older clients.
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

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/women-products/seller/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) =>
      _api.put(
        '/api/women-products/seller/profile',
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/women-products/seller/submit-verification');

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/women-products/seller/me');

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> body) =>
      _api.post('/api/women-products/seller/products', body: body);

  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> body) =>
      _api.put('/api/women-products/seller/products/$id', body: body);

  Future<Map<String, dynamic>> deleteProduct(int id) =>
      _api.delete('/api/women-products/seller/products/$id');

  Future<Map<String, dynamic>> uploadProductImage(int id, String filePath) async {
    final file = await http.MultipartFile.fromPath('image', filePath);
    return _api.postMultipart(
      '/api/women-products/seller/products/$id/image',
      files: [file],
      auth: true,
    );
  }

  Future<Map<String, dynamic>> updateOrderStatus(int id, String status) =>
      _api.post('/api/women-products/seller/orders/$id/status', body: {'status': status});

  Future<Map<String, dynamic>> trackOrder(int id) =>
      _api.get('/api/women-products/seller/orders/$id/track');

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/women-products/seller/payout/request');

  Future<Map<String, dynamic>> updateOrderNotes(int id, String coachNotes) =>
      _api.post('/api/women-products/seller/orders/$id/notes', body: {'coachNotes': coachNotes});

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
      '/api/women-products/seller/photos',
      files: files,
      auth: true,
    );
  }
}
