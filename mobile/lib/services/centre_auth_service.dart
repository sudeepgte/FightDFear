import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_client.dart';

/// Centre owner auth and operations — register, login, dashboard, batches, students.
class CentreAuthService {
  CentreAuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/martial-arts/centre/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/martial-arts/centre/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      '/api/martial-arts/centre/login',
      body: {'email': email.trim(), 'password': password},
      auth: false,
    );
    if (res['success'] == true && res['token'] != null) {
      await _api.saveCentreToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/martial-arts/centre/profile', auth: false, centreAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) => _api.put(
        '/api/martial-arts/centre/profile',
        body: body,
        auth: false,
        centreAuth: true,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() => _api.post(
        '/api/martial-arts/centre/submit-verification',
        auth: false,
        centreAuth: true,
      );

  Future<void> logout() => _api.clearCentreToken();

  Future<bool> isLoggedIn() async {
    final t = await _api.getCentreToken();
    return t != null && t.isNotEmpty;
  }

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/martial-arts/centre/me', auth: false, centreAuth: true);

  Future<Map<String, dynamic>> dashboardMeta() =>
      _api.get('/api/martial-arts/centre/dashboard/meta', auth: false, centreAuth: true);

  Future<Map<String, dynamic>> saveBatch(Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/batches',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> deleteBatch(int id) =>
      _api.delete('/api/martial-arts/centre/batches/$id', centreAuth: true);

  Future<Map<String, dynamic>> updateStudentStatus(int enrollmentId, String status) =>
      _api.post(
        '/api/martial-arts/centre/students/$enrollmentId/status',
        body: {'status': status},
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> studentFile(int enrollmentId) => _api.get(
        '/api/martial-arts/centre/students/$enrollmentId',
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> saveStudentNotes(int enrollmentId, String notes) => _api.post(
        '/api/martial-arts/centre/students/$enrollmentId/notes',
        body: {'notes': notes},
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> requestPayout() => _api.post(
        '/api/martial-arts/centre/payout/request',
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> attendanceSessions({String? date}) {
    final q = date == null ? '' : '?date=$date';
    return _api.get('/api/martial-arts/centre/attendance/sessions$q',
        auth: false, centreAuth: true);
  }

  Future<Map<String, dynamic>> attendanceTrainees({
    required String type,
    required int id,
    required String date,
  }) =>
      _api.get(
        '/api/martial-arts/centre/attendance/trainees?type=$type&id=$id&date=$date',
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> saveAttendance(Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/attendance/save',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> createOnlineClass(Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/online-classes',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> startOnlineClass(int id) => _api.post(
        '/api/martial-arts/centre/online-classes/$id/start',
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> endOnlineClass(int id) => _api.post(
        '/api/martial-arts/centre/online-classes/$id/end',
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> deleteOnlineClass(int id) =>
      _api.delete('/api/martial-arts/centre/online-classes/$id', centreAuth: true);

  Future<Map<String, dynamic>> updateSettings({
    required Map<String, String> fields,
    List<http.MultipartFile> files = const [],
  }) =>
      _api.postMultipart(
        '/api/martial-arts/centre/settings',
        fields: fields,
        files: files,
        auth: false,
        centreAuth: true,
      );

  // QR Attendance Sessions
  Future<Map<String, dynamic>> createQrSession({
    required int batchId,
    String? date,
    int duration = 15,
  }) =>
      _api.post(
        '/api/martial-arts/centre/qr-session',
        body: {
          'batchId': batchId,
          if (date != null) 'date': date,
          'duration': duration,
        },
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> getQrSession({
    required int batchId,
    String? date,
  }) {
    final d = (date != null && date.isNotEmpty) ? '&date=$date' : '';
    return _api.get(
      '/api/martial-arts/centre/qr-session?batchId=$batchId$d',
      auth: false,
      centreAuth: true,
    );
  }

  Future<Map<String, dynamic>> closeQrSession(int id) => _api.post(
        '/api/martial-arts/centre/qr-session/$id/close',
        auth: false,
        centreAuth: true,
      );

  // Belt Grading & Assessments
  Future<Map<String, dynamic>> getGradingCriteria({String? style, String? belt}) {
    final params = <String>[];
    if (style != null && style.isNotEmpty) params.add('style=${Uri.encodeComponent(style)}');
    if (belt != null && belt.isNotEmpty) params.add('belt=${Uri.encodeComponent(belt)}');
    final q = params.isEmpty ? '' : '?${params.join('&')}';
    return _api.get('/api/martial-arts/centre/grading/criteria$q', auth: false, centreAuth: true);
  }

  Future<Map<String, dynamic>> getGradings({String? status, int? batchId}) {
    final params = <String>[];
    if (status != null && status.isNotEmpty) params.add('status=${Uri.encodeComponent(status)}');
    if (batchId != null) params.add('batchId=$batchId');
    final q = params.isEmpty ? '' : '?${params.join('&')}';
    return _api.get('/api/martial-arts/centre/gradings$q', auth: false, centreAuth: true);
  }

  Future<Map<String, dynamic>> scheduleGrading(Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/gradings/schedule',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> scoreGrading(int id, Map<String, dynamic> body) => _api.post(
        '/api/martial-arts/centre/gradings/$id/score',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> promoteGrading(int id) => _api.post(
        '/api/martial-arts/centre/gradings/$id/promote',
        auth: false,
        centreAuth: true,
      );

  // Instructors
  Future<Map<String, dynamic>> getInstructors() =>
      _api.get('/api/martial-arts/centre/instructors', auth: false, centreAuth: true);

  Future<Map<String, dynamic>> createInstructor(Map<String, String> body) => _api.post(
        '/api/martial-arts/centre/instructors',
        body: body,
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> deleteInstructor(int id) =>
      _api.delete('/api/martial-arts/centre/instructors/$id', centreAuth: true);

  // Trainee Renewal
  Future<Map<String, dynamic>> updateRenewal(
    int enrollmentId, {
    required String renewalStatus,
    String? nextRenewalDate,
  }) =>
      _api.post(
        '/api/martial-arts/centre/enrollments/$enrollmentId/renewal',
        body: {
          'renewalStatus': renewalStatus,
          if (nextRenewalDate != null && nextRenewalDate.isNotEmpty)
            'nextRenewalDate': nextRenewalDate,
        },
        auth: false,
        centreAuth: true,
      );

  Future<Map<String, dynamic>> registerLite({
    required String name,
    required String location,
    required String phoneNumber,
    required String email,
    required String password,
    required String about,
    required String howWeTeach,
    required String whatWeOffer,
    required List<String> availableDays,
    required List<Map<String, dynamic>> programs,
  }) async {
    final body = <String, dynamic>{
      'name': name.trim(),
      'location': location.trim(),
      'phoneNumber': phoneNumber.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'about': about.trim(),
      'howWeTeach': howWeTeach.trim(),
      'whatWeOffer': whatWeOffer.trim(),
      'availableDaysCsv': availableDays.join(','),
      'martialArtsJson': jsonEncode(programs),
    };
    return _api.post('/api/martial-arts/centre/register-lite', body: body, auth: false);
  }

  Future<Map<String, dynamic>> registerWithFiles({
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) =>
      _api.postMultipart(
        '/api/martial-arts/centre/register',
        fields: fields,
        files: files,
        auth: false,
      );
}
