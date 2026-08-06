import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient(this.baseUrl);

  final String baseUrl;
  static const _tokenKey = 'auth_token';
  static const _centreTokenKey = 'centre_auth_token';
  static const _adminTokenKey = 'admin_auth_token';
  static const _salonTokenKey = 'salon_auth_token';
  static const _stylistTokenKey = 'stylist_auth_token';
  static const _timeout = Duration(seconds: 8);
  static const _uploadTimeout = Duration(seconds: 120);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getCentreToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_centreTokenKey);
  }

  Future<void> saveCentreToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_centreTokenKey, token);
  }

  Future<void> clearCentreToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_centreTokenKey);
  }

  Future<String?> getAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminTokenKey);
  }

  Future<void> saveAdminToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminTokenKey, token);
  }

  Future<void> clearAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminTokenKey);
  }

  Future<String?> getSalonToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_salonTokenKey);
  }

  Future<void> saveSalonToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_salonTokenKey, token);
  }

  Future<void> clearSalonToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_salonTokenKey);
  }

  Future<String?> getStylistToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stylistTokenKey);
  }

  Future<void> saveStylistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stylistTokenKey, token);
  }

  Future<void> clearStylistToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stylistTokenKey);
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, String>> _headers({
    bool auth = true,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (adminAuth) {
      final token = await getAdminToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } else if (salonAuth) {
      final token = await getSalonToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } else if (stylistAuth) {
      final token = await getStylistToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } else if (centreAuth) {
      final token = await getCentreToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } else if (auth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    List<http.MultipartFile> files = const [],
    bool auth = false,
    bool centreAuth = false,
  }) async {
    final req = http.MultipartRequest('POST', _uri(path));
    req.fields.addAll(fields);
    req.files.addAll(files);
    req.headers['Accept'] = 'application/json';
    if (centreAuth) {
      final token = await getCentreToken();
      if (token != null && token.isNotEmpty) {
        req.headers['Authorization'] = 'Bearer $token';
      }
    } else if (auth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        req.headers['Authorization'] = 'Bearer $token';
      }
    }
    final streamed = await req.send().timeout(_uploadTimeout);
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    Duration? timeout,
  }) async {
    final res = await http
        .post(
          _uri(path),
          headers: await _headers(
            auth: auth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
          ),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(timeout ?? _timeout);
    return _decode(res);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool auth = true,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    Duration? timeout,
  }) async {
    final res = await http
        .get(
          _uri(path),
          headers: await _headers(
            auth: auth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
          ),
        )
        .timeout(timeout ?? _timeout);
    return _decode(res);
  }

  /// POST application/x-www-form-urlencoded (e.g. /danger-points create).
  Future<Map<String, dynamic>> postForm(
    String path, {
    required Map<String, String> fields,
    bool auth = true,
    Duration? timeout,
  }) async {
    final headers = await _headers(auth: auth);
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    final res = await http
        .post(
          _uri(path),
          headers: headers,
          body: fields,
        )
        .timeout(timeout ?? _timeout);
    return _decode(res);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final res = await http
        .put(
          _uri(path),
          headers: await _headers(),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(_timeout);
    return _decode(res);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final req = http.Request('PATCH', _uri(path));
    req.headers.addAll(await _headers());
    if (body != null) req.body = jsonEncode(body);
    final streamed = await req.send().timeout(_timeout);
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
  }) async {
    final res = await http
        .delete(
          _uri(path),
          headers: await _headers(
            auth: !centreAuth && !adminAuth && !salonAuth && !stylistAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
          ),
        )
        .timeout(_timeout);
    return _decode(res);
  }

  /// Download binary file (e.g. certificate PDF).
  Future<({List<int> bytes, int statusCode, String? filename})> getBytes(
    String path, {
    bool auth = true,
  }) async {
    final res = await http
        .get(_uri(path), headers: await _headers(auth: auth))
        .timeout(_uploadTimeout);
    String? filename;
    final cd = res.headers['content-disposition'];
    if (cd != null && cd.contains('filename=')) {
      filename = cd.split('filename=').last.replaceAll('"', '').trim();
    }
    return (bytes: res.bodyBytes, statusCode: res.statusCode, filename: filename);
  }

  /// Exposed for multipart callers that build their own request.
  Map<String, dynamic> decodeResponse(http.Response res) => _decode(res);

  Map<String, dynamic> _decode(http.Response res) {
    Map<String, dynamic> json;
    try {
      final decoded = jsonDecode(res.body);
      json = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded};
    } catch (_) {
      // nginx HTML pages (502/504) are not JSON — surface a clear message.
      final body = res.body.toLowerCase();
      String error;
      if (res.statusCode == 502 || body.contains('502 bad gateway')) {
        error =
            'Server is down (502). The app behind nginx is not running on port 8084. '
            'Restart Spring Boot / Docker on the testing server, then try again.';
      } else if (res.statusCode == 504 || body.contains('504 gateway')) {
        error = 'Server timed out (504). Try again in a moment.';
      } else if (res.statusCode == 503) {
        error = 'Server unavailable (503). Try again shortly.';
      } else {
        error = 'Invalid server response (${res.statusCode})';
      }
      json = <String, dynamic>{
        'success': false,
        'error': error,
      };
    }
    json['_status'] = res.statusCode;
    if (res.statusCode >= 400 && json['error'] == null) {
      json['error'] = json['message'] ?? 'Request failed (${res.statusCode})';
      json['success'] = false;
    }
    if (res.statusCode == 502 &&
        (json['error'] == null ||
            json['error'].toString().contains('Invalid server'))) {
      json['success'] = false;
      json['error'] =
          'Server is down (502). Restart the backend on the testing server (port 8084).';
    }
    return json;
  }
}
