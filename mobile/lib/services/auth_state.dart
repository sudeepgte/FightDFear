import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_client.dart';
import 'navigation_service.dart';

class AuthState extends ChangeNotifier {
  AuthState() {
    _client = ApiClient(
      ApiConfig.resolve(isAndroid: defaultTargetPlatform == TargetPlatform.android),
    );
    ApiClient.onSessionExpired = _onGlobalSessionExpired;
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
    if (e is TimeoutException || msg.contains('TimeoutException')) {
      return 'Server timed out ($apiBaseUrl).\n'
          '• Connect phone to the SAME Wi-Fi as laptop ($apiBaseUrl).\n'
          '• Verify backend is running on port 8084.\n'
          '• Try testing $apiBaseUrl/api/auth/health in phone browser.';
    }
    if (e is SocketException ||
        e is http.ClientException ||
        msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('Failed host lookup')) {
      return 'Cannot reach server ($apiBaseUrl).\n'
          'Ensure backend is running on port 8084 and phone is on the same Wi-Fi network.';
    }
    if (e is PlatformException || msg.contains('PlatformException') || msg.contains('channel-error')) {
      return 'Device local storage issue: $e';
    }
    return 'Authentication error: $e';
  }

  Future<bool> pingServer([String? customUrl]) async {
    try {
      final client = customUrl == null ? _client : ApiClient(customUrl);
      final res = await client.get('/api/auth/health', auth: false, timeout: const Duration(seconds: 4));
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setServerUrl(String? url) async {
    await _client.setCustomBaseUrl(url);
    notifyListeners();
  }

  /// Automatically discovers a responsive backend server from candidates:
  /// 1. Saved custom URL
  /// 2. Current baseUrl
  /// 3. Candidates (Laptop LAN host, emulator host, localhost, cloud)
  Future<String?> autoDetectWorkingServer() async {
    // 1. If user set a custom URL, verify that first
    final custom = await _client.getCustomBaseUrl();
    if (custom != null && custom.isNotEmpty) {
      if (await pingServer(custom)) {
        return custom;
      }
    }

    // 2. Test current baseUrl
    if (await pingServer(_client.baseUrl)) {
      return _client.baseUrl;
    }

    // 3. Test candidates in priority order
    final candidates = ApiConfig.getCandidateUrls(
      isAndroid: defaultTargetPlatform == TargetPlatform.android,
    );

    for (final candidate in candidates) {
      if (candidate == _client.baseUrl) continue;
      final ok = await pingServer(candidate);
      if (ok) {
        debugPrint('Auto-detected responsive server URL: $candidate');
        await setServerUrl(candidate);
        return candidate;
      }
    }
    return null;
  }

  Future<void> bootstrap() async {
    loading = true;
    notifyListeners();
    try {
      // Check or auto-detect working server connection in background
      await autoDetectWorkingServer();

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
    } catch (e) {
      debugPrint('Bootstrap error: $e');
      loggedIn = false;
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
        timeout: const Duration(seconds: 15),
      );
      if (res['success'] == true && res['token'] != null) {
        try {
          await _client.saveToken(res['token'].toString());
        } catch (storageErr) {
          debugPrint('Warning: Token could not be written to persistent storage: $storageErr');
        }
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
      if (error != null && error!.isNotEmpty) {
        error = '$error (server: $apiBaseUrl)';
      }
    } catch (e) {
      // If network failure or timeout occurred, attempt auto-detecting a reachable candidate
      if (e is TimeoutException ||
          e is SocketException ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        final newUrl = await autoDetectWorkingServer();
        if (newUrl != null && newUrl != _client.baseUrl) {
          try {
            final retryRes = await _client.post(
              '/api/auth/login',
              body: {'email': emailInput.trim(), 'password': password},
              auth: false,
              timeout: const Duration(seconds: 15),
            );
            if (retryRes['success'] == true && retryRes['token'] != null) {
              try {
                await _client.saveToken(retryRes['token'].toString());
              } catch (_) {}
              loggedIn = true;
              name = retryRes['name']?.toString();
              email = retryRes['email']?.toString();
              userId = retryRes['userId'] is int
                  ? retryRes['userId'] as int
                  : int.tryParse('${retryRes['userId']}');
              loading = false;
              notifyListeners();
              return true;
            }
          } catch (_) {}
        }
      }
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

  /// Apply a user JWT session already saved on [api] (worker portal login).
  void applyUserSession(Map<String, dynamic> res) {
    loggedIn = true;
    name = res['name']?.toString();
    email = res['email']?.toString();
    userId = res['userId'] is int
        ? res['userId'] as int
        : int.tryParse('${res['userId']}');
    error = null;
    notifyListeners();
  }

  Future<void> _onGlobalSessionExpired(AuthRole role) async {
    if (role == AuthRole.member) {
      loggedIn = false;
      name = null;
      email = null;
      userId = null;
      error = 'Your session has expired. Please log in again.';
      notifyListeners();
    }
    await NavigationService.handleSessionExpired(role);
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
