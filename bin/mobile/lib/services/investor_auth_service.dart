import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Investor auth and funding collaboration APIs.
class InvestorAuthService {
  InvestorAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/investor/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/investor/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/investor/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

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

  Future<Map<String, dynamic>> profile() => _api.get('/api/investor/profile');

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) => _api.put(
        '/api/investor/profile',
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/investor/submit-verification');

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/investor/me');

  Future<Map<String, dynamic>> marketplace({
    String? category,
    String? city,
    String? sort,
  }) {
    final q = <String, String>{};
    if (category != null && category.isNotEmpty && category != 'All') {
      q['category'] = category;
    }
    if (city != null && city.trim().isNotEmpty) q['city'] = city.trim();
    if (sort != null && sort.isNotEmpty) q['sort'] = sort;
    final qs = q.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/investor/marketplace${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> proposalCategories() =>
      _api.get('/api/investor/proposal-categories');

  Future<Map<String, dynamic>> invest(Map<String, dynamic> body) =>
      _api.post('/api/investor/invest', body: body);

  Future<Map<String, dynamic>> withdrawInterest(int investmentId) =>
      _api.post('/api/investor/investments/$investmentId/withdraw');

  Future<Map<String, dynamic>> subscribe() => _api.post('/api/investor/subscribe');

  Future<Map<String, dynamic>> meetings() => _api.get('/api/investor/meetings');

  Future<Map<String, dynamic>> requestMeeting({
    required int proposalId,
    required String meetingTime,
    String location = '',
    String notes = '',
  }) =>
      _api.post('/api/investor/proposals/$proposalId/meetings', body: {
        'meetingTime': meetingTime,
        'location': location,
        'notes': notes,
      });

  Future<Map<String, dynamic>> chatThreads() => _api.get('/api/investor/chat/threads');

  Future<Map<String, dynamic>> chatMessages({required int proposalId}) =>
      _api.get('/api/investor/chat?proposalId=$proposalId');

  Future<Map<String, dynamic>> sendChat({
    required int proposalId,
    required String message,
  }) =>
      _api.post('/api/investor/chat', body: {
        'proposalId': proposalId,
        'message': message,
      });

  Future<Map<String, dynamic>> notifications() =>
      _api.get('/api/investor/notifications');

  Future<Map<String, dynamic>> rateInvestment(int id, {required int rating, String review = ''}) =>
      _api.post('/api/investor/investments/$id/rate', body: {'rating': rating, 'review': review});

  Future<Map<String, dynamic>> cancelMeeting(int id) =>
      _api.post('/api/investor/meetings/$id/cancel');

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
      '/api/investor/photos',
      files: files,
      auth: true,
    );
  }

  Future<void> logout() => _api.clearToken();
}
