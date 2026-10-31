import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Entrepreneur auth and funding collaboration APIs.
class EntrepreneurAuthService {
  EntrepreneurAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/entrepreneur/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/entrepreneur/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/entrepreneur/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/entrepreneur/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/entrepreneur/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveEntrepreneurToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/entrepreneur/profile', entrepreneurAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) => _api.put(
        '/api/entrepreneur/profile',
        entrepreneurAuth: true,
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/entrepreneur/submit-verification', entrepreneurAuth: true);

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/entrepreneur/me', entrepreneurAuth: true);

  Future<Map<String, dynamic>> proposalCategories() =>
      _api.get('/api/entrepreneur/proposal-categories', entrepreneurAuth: true);

  Future<Map<String, dynamic>> interests() =>
      _api.get('/api/entrepreneur/interests', entrepreneurAuth: true);

  Future<Map<String, dynamic>> createProposal(Map<String, dynamic> body) =>
      _api.post('/api/entrepreneur/proposals', entrepreneurAuth: true, body: body);

  Future<Map<String, dynamic>> updateProposal(int id, Map<String, dynamic> body) =>
      _api.put('/api/entrepreneur/proposals/$id', entrepreneurAuth: true, body: body);

  Future<Map<String, dynamic>> cancelProposal(int id) =>
      _api.post('/api/entrepreneur/proposals/$id/cancel', entrepreneurAuth: true);

  Future<Map<String, dynamic>> uploadPitch({
    http.MultipartFile? document,
    http.MultipartFile? videoPitch,
    int? proposalId,
  }) {
    final files = <http.MultipartFile>[
      if (document != null) document,
      if (videoPitch != null) videoPitch,
    ];
    return _api.postMultipart(
      '/api/entrepreneur/pitch/upload',
      fields: {
        if (proposalId != null) 'proposalId': '$proposalId',
      },
      files: files,
      entrepreneurAuth: true,
    );
  }

  Future<Map<String, dynamic>> uploadProposalPitch({
    required int proposalId,
    http.MultipartFile? document,
    http.MultipartFile? videoPitch,
  }) {
    final files = <http.MultipartFile>[
      if (document != null) document,
      if (videoPitch != null) videoPitch,
    ];
    return _api.postMultipart(
      '/api/entrepreneur/proposals/$proposalId/upload',
      files: files,
      entrepreneurAuth: true,
    );
  }

  Future<Map<String, dynamic>> meetings() =>
      _api.get('/api/entrepreneur/meetings', entrepreneurAuth: true);

  Future<Map<String, dynamic>> acceptMeeting(int id) =>
      _api.post('/api/entrepreneur/meetings/$id/accept', entrepreneurAuth: true);

  Future<Map<String, dynamic>> rejectMeeting(int id) =>
      _api.post('/api/entrepreneur/meetings/$id/reject', entrepreneurAuth: true);

  Future<Map<String, dynamic>> chatThreads() =>
      _api.get('/api/entrepreneur/chat/threads', entrepreneurAuth: true);

  Future<Map<String, dynamic>> chatMessages({
    required int proposalId,
    required int investorId,
  }) =>
      _api.get(
        '/api/entrepreneur/chat?proposalId=$proposalId&investorId=$investorId',
        entrepreneurAuth: true,
      );

  Future<Map<String, dynamic>> sendChat({
    required int proposalId,
    required int investorId,
    required String message,
  }) =>
      _api.post('/api/entrepreneur/chat', entrepreneurAuth: true, body: {
        'proposalId': proposalId,
        'investorId': investorId,
        'message': message,
      });

  Future<Map<String, dynamic>> fundingDetail() =>
      _api.get('/api/entrepreneur/funding-detail', entrepreneurAuth: true);

  Future<Map<String, dynamic>> payCommission(int investmentId) =>
      _api.post('/api/entrepreneur/investments/$investmentId/commission/pay', entrepreneurAuth: true);

  Future<Map<String, dynamic>> updateBank(Map<String, dynamic> body) =>
      _api.put('/api/entrepreneur/bank', entrepreneurAuth: true, body: body);

  Future<Map<String, dynamic>> notifications() =>
      _api.get('/api/entrepreneur/notifications', entrepreneurAuth: true);

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/entrepreneur/payout/request', entrepreneurAuth: true);

  Future<Map<String, dynamic>> updateInterestNotes(int id, String coachNotes) =>
      _api.post('/api/entrepreneur/investments/$id/notes',
          entrepreneurAuth: true, body: {'coachNotes': coachNotes});

  Future<Map<String, dynamic>> cancelMeeting(int id) =>
      _api.post('/api/entrepreneur/meetings/$id/cancel', entrepreneurAuth: true);

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
      '/api/entrepreneur/photos',
      files: files,
      entrepreneurAuth: true,
    );
  }

  Future<void> logout() => _api.clearEntrepreneurToken();
}
