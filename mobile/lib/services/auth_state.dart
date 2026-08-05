import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import 'api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState() {
    _client = ApiClient(
      ApiConfig.resolve(isAndroid: defaultTargetPlatform == TargetPlatform.android),
    );
  }

  late final ApiClient _client;
  bool loading = true;
  bool loggedIn = false;
  String? error;
  String? name;
  String? email;
  int? userId;

  ApiClient get api => _client;
  String get apiBaseUrl => _client.baseUrl;

  String _networkErrorMessage(Object e) {
    final msg = e.toString();
    if (msg.contains('TimeoutException')) {
      return 'Server timed out ($apiBaseUrl). '
          'Turn OFF mobile data, connect phone to same Wi-Fi as laptop, '
          'then open $apiBaseUrl/api/auth/health in phone browser.';
    }
    return 'Cannot reach server ($apiBaseUrl). Details: $e';
  }

  Future<bool> pingServer() async {
    try {
      final res = await _client.get('/api/auth/health', auth: false, timeout: const Duration(seconds: 8));
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> bootstrap() async {
    loading = true;
    notifyListeners();
    try {
      final token = await _client.getToken();
      if (token == null || token.isEmpty) {
        loggedIn = false;
        return;
      }
      try {
        final me = await _client.get('/api/me');
        if (me['success'] == true) {
          loggedIn = true;
          name = me['name']?.toString();
          email = me['email']?.toString();
          userId = me['userId'] is int
              ? me['userId'] as int
              : int.tryParse('${me['userId']}');
        } else {
          await _client.clearToken();
          loggedIn = false;
        }
      } catch (_) {
        // Offline or backend unavailable — do not fake a logged-in session.
        loggedIn = false;
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String emailInput, String password) async {
    error = null;
    loading = true;
    notifyListeners();
    try {
      final res = await _client.post(
        '/api/auth/login',
        body: {'email': emailInput.trim(), 'password': password},
        auth: false,
        timeout: const Duration(seconds: 20),
      );
      if (res['success'] == true && res['token'] != null) {
        await _client.saveToken(res['token'].toString());
        loggedIn = true;
        name = res['name']?.toString();
        email = res['email']?.toString();
        userId = res['userId'] is int
            ? res['userId'] as int
            : int.tryParse('${res['userId']}');
        loading = false;
        notifyListeners();
        return true;
      }
      error = res['error']?.toString() ?? 'Login failed';
    } catch (e) {
      error = _networkErrorMessage(e);
    }
    loading = false;
    notifyListeners();
    return false;
  }

  /// Returns response map on success, null on failure (see [error]).
  Future<Map<String, dynamic>?> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? homeAddress,
    String? gender,
    String? dob,
    String? emergencyContact,
    String? preferredLanguage,
    String? profilePhoto,
  }) async {
    error = null;
    try {
      final body = <String, dynamic>{
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phoneNumber': phoneNumber.trim(),
        'password': password,
      };
      if (homeAddress != null && homeAddress.trim().isNotEmpty) {
        body['homeAddress'] = homeAddress.trim();
      }
      if (gender != null && gender.isNotEmpty) {
        body['gender'] = gender;
      }
      if (dob != null && dob.trim().isNotEmpty) {
        body['dob'] = dob.trim();
      }
      if (emergencyContact != null && emergencyContact.trim().isNotEmpty) {
        body['emergencyContact'] = emergencyContact.trim();
      }
      if (preferredLanguage != null && preferredLanguage.trim().isNotEmpty) {
        body['preferredLanguage'] = preferredLanguage.trim();
      }
      if (profilePhoto != null && profilePhoto.trim().isNotEmpty) {
        body['profilePhoto'] = profilePhoto.trim();
      }
      final res = await _client.post(
        '/api/auth/register',
        body: body,
        auth: false,
        timeout: const Duration(seconds: 20),
      );
      if (res['success'] == true) {
        return res;
      }
      error = res['error']?.toString() ?? 'Registration failed';
      return null;
    } catch (e) {
      error = _networkErrorMessage(e);
      return null;
    }
  }

  Future<void> logout() async {
    await _client.clearToken();
    loggedIn = false;
    name = null;
    email = null;
    userId = null;
    notifyListeners();
  }
}
