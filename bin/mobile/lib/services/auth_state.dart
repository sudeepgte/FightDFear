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
        // Offline or backend unavailable — keep session for later API calls.
        loggedIn = true;
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
      error = 'Cannot reach server (${_client.baseUrl}). Is the backend on :8084?';
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
      final res = await _client.post('/api/auth/register', body: body, auth: false);
      if (res['success'] == true) {
        return res;
      }
      error = res['error']?.toString() ?? 'Registration failed';
      return null;
    } catch (e) {
      error = 'Cannot reach server (${_client.baseUrl}). Is the backend on :8084?';
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
