import 'api_client.dart';
import 'package:http/http.dart' as http;

/// Fitness trainer auth and profile — quick register, login, profile completion.
class FitnessTrainerAuthService {
  FitnessTrainerAuthService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> sendEmailOtp(String email) => _api.post(
        '/api/fitness/trainer/otp/send-email',
        auth: false,
        body: {'email': email.trim().toLowerCase()},
      );

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) =>
      _api.post(
        '/api/fitness/trainer/otp/verify-email',
        auth: false,
        body: {'email': email.trim().toLowerCase(), 'otp': otp.trim()},
      );

  Future<Map<String, dynamic>> registerQuick(Map<String, dynamic> body) => _api.post(
        '/api/fitness/trainer/register-quick',
        auth: false,
        body: body,
        timeout: const Duration(seconds: 45),
      );

  /// Legacy full registration — kept for older clients.
  Future<Map<String, dynamic>> register(Map<String, dynamic> body) =>
      _api.post('/api/fitness/trainer/register', auth: false, body: body);

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final res = await _api.post(
      '/api/fitness/trainer/login',
      auth: false,
      body: {'email': email.trim().toLowerCase(), 'password': password},
    );
    // TRAINER JWT is stored via isolated fitness_trainer_auth_token.
    if (res['success'] == true && res['token'] != null) {
      await _api.saveFitnessTrainerToken(res['token'].toString());
    }
    return res;
  }

  Future<Map<String, dynamic>> profile() =>
      _api.get('/api/fitness/trainer/profile', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> body) => _api.put(
        '/api/fitness/trainer/profile',
        fitnessTrainerAuth: true,
        body: body,
        timeout: const Duration(seconds: 30),
      );

  Future<Map<String, dynamic>> submitVerification() =>
      _api.post('/api/fitness/trainer/submit-verification', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> uploadDocuments({
    http.MultipartFile? profilePhoto,
    http.MultipartFile? certificate,
  }) {
    final files = <http.MultipartFile>[
      if (profilePhoto != null) profilePhoto,
      if (certificate != null) certificate,
    ];
    return _api.postMultipart(
      '/api/fitness/trainer/profile/upload',
      files: files,
      fitnessTrainerAuth: true,
    );
  }

  Future<Map<String, dynamic>> updateOnlineStatus(bool online) => _api.put(
        '/api/fitness/trainer/online-status',
        fitnessTrainerAuth: true,
        body: {'online': online},
      );

  Future<Map<String, dynamic>> dashboard() =>
      _api.get('/api/fitness/trainer/me', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> updateBookingStatus(int id, String status) =>
      _api.post('/api/fitness/trainer/bookings/$id/status',
          fitnessTrainerAuth: true, body: {'status': status});

  Future<Map<String, dynamic>> requestPayout() =>
      _api.post('/api/fitness/trainer/payout/request', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> updateBookingNotes(int id, String coachNotes) =>
      _api.post('/api/fitness/trainer/bookings/$id/notes',
          fitnessTrainerAuth: true, body: {'coachNotes': coachNotes});

  Future<Map<String, dynamic>> uploadPhotos({
    String? profilePath,
    String? galleryPath,
    String? certificatePath,
  }) async {
    final files = <http.MultipartFile>[];
    if (profilePath != null && profilePath.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath('profileImage', profilePath));
    }
    if (galleryPath != null && galleryPath.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath('galleryPhotos', galleryPath));
    }
    if (certificatePath != null && certificatePath.isNotEmpty) {
      files.add(await http.MultipartFile.fromPath('certificate', certificatePath));
    }
    return _api.postMultipart(
      '/api/fitness/trainer/photos',
      files: files,
      fitnessTrainerAuth: true,
    );
  }

  Future<Map<String, dynamic>> getPackages() =>
      _api.get('/api/fitness/trainer/packages', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> savePackage(Map<String, dynamic> body) =>
      _api.post('/api/fitness/trainer/packages', fitnessTrainerAuth: true, body: body);

  Future<Map<String, dynamic>> deletePackage(int id) =>
      _api.delete('/api/fitness/trainer/packages/$id', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> markAttendance({
    required int bookingId,
    String? sessionDate,
    String? sessionTime,
    String status = 'PRESENT',
    String? notes,
  }) =>
      _api.post('/api/fitness/trainer/attendance', fitnessTrainerAuth: true, body: {
        'bookingId': bookingId,
        if (sessionDate != null) 'sessionDate': sessionDate,
        if (sessionTime != null) 'sessionTime': sessionTime,
        'status': status,
        if (notes != null) 'notes': notes,
      });

  Future<Map<String, dynamic>> logProgress({
    required int userId,
    double? weightKg,
    double? bodyFatPct,
    int workoutsCompleted = 1,
    String? metricsJson,
    String? workoutNotes,
  }) =>
      _api.post('/api/fitness/trainer/progress', fitnessTrainerAuth: true, body: {
        'userId': userId,
        if (weightKg != null) 'weightKg': weightKg,
        if (bodyFatPct != null) 'bodyFatPct': bodyFatPct,
        'workoutsCompleted': workoutsCompleted,
        if (metricsJson != null) 'metricsJson': metricsJson,
        if (workoutNotes != null) 'workoutNotes': workoutNotes,
      });

  Future<Map<String, dynamic>> createQrSession({
    int duration = 15,
    int? classId,
    double? latitude,
    double? longitude,
  }) =>
      _api.post('/api/fitness/trainer/qr-session', fitnessTrainerAuth: true, body: {
        'duration': duration,
        if (classId != null) 'classId': classId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });

  Future<Map<String, dynamic>> closeQrSession(int sessionId) =>
      _api.post('/api/fitness/trainer/qr-session/$sessionId/close', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> getQrAttendees(int sessionId) =>
      _api.get('/api/fitness/trainer/qr-session/$sessionId/attendees', fitnessTrainerAuth: true);

  Future<Map<String, dynamic>> getActiveQrSession() =>
      _api.get('/api/fitness/trainer/qr-session/active', fitnessTrainerAuth: true);

  Future<void> logout() => _api.clearFitnessTrainerToken();
}

