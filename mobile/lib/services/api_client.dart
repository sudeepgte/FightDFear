import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum AuthRole {
  member,
  creator,
  fitnessTrainer,
  eventHost,
  deliveryPartner,
  investor,
  entrepreneur,
  womenJobs,
  womenProductsSeller,
  financialEducator,
  marketplaceProvider,
  womenLawyer,
  doctor,
  centre,
  salon,
  stylist,
  admin,
}

class ApiClient {
  ApiClient(this._defaultBaseUrl) {
    _initCustomBaseUrl();
  }

  final String _defaultBaseUrl;
  String? _customBaseUrl;

  String get baseUrl => _customBaseUrl ?? _defaultBaseUrl;

  static final Set<AuthRole> _activeExpiringRoles = <AuthRole>{};
  static final Map<AuthRole, DateTime> _lastExpiryHandled = <AuthRole, DateTime>{};

  /// Global hook called when a session expires (HTTP 401 on authenticated call).
  static Future<void> Function(AuthRole role)? onSessionExpired;

  static void resetSessionExpiredStateForTesting() {
    _activeExpiringRoles.clear();
    _lastExpiryHandled.clear();
  }

  static const _customBaseUrlKey = 'custom_api_base_url';
  static const _tokenKey = 'auth_token';
  static const _doctorTokenKey = 'doctor_auth_token';
  static const _centreTokenKey = 'centre_auth_token';
  static const _adminTokenKey = 'admin_auth_token';
  static const _salonTokenKey = 'salon_auth_token';
  static const _stylistTokenKey = 'stylist_auth_token';
  static const _creatorTokenKey = 'creator_auth_token';
  static const _fitnessTrainerTokenKey = 'fitness_trainer_auth_token';
  static const _eventHostTokenKey = 'event_host_auth_token';
  static const _deliveryPartnerTokenKey = 'delivery_partner_auth_token';
  static const _investorTokenKey = 'investor_auth_token';
  static const _entrepreneurTokenKey = 'entrepreneur_auth_token';
  static const _womenJobsTokenKey = 'women_jobs_auth_token';
  static const _womenProductsSellerTokenKey = 'women_products_seller_auth_token';
  static const _financialEducatorTokenKey = 'financial_educator_auth_token';
  static const _marketplaceProviderTokenKey = 'marketplace_provider_auth_token';
  static const _womenLawyerTokenKey = 'women_lawyer_auth_token';
  static const _browseTimeout = Duration(seconds: 8);
  static const _uploadTimeout = Duration(seconds: 120);

  // Cached SharedPreferences instance + in-memory store for platform channel resilience
  static SharedPreferences? _cachedPrefs;
  static final Map<String, String> _memoryStore = {};

  static void setPreferences(SharedPreferences? prefs) {
    _cachedPrefs = prefs;
  }

  static Future<SharedPreferences?> getPreferences() async {
    if (_cachedPrefs != null) return _cachedPrefs;
    try {
      _cachedPrefs = await SharedPreferences.getInstance();
      return _cachedPrefs;
    } catch (e) {
      debugPrint('Warning: SharedPreferences.getInstance() failed: $e');
      return null;
    }
  }

  static Future<String?> readStorage(String key) async {
    try {
      final prefs = await getPreferences();
      if (prefs != null) {
        final val = prefs.getString(key);
        if (val != null) {
          _memoryStore[key] = val;
          return val;
        }
      }
    } catch (e) {
      debugPrint('Storage read error for $key: $e');
    }
    return _memoryStore[key];
  }

  static Future<void> writeStorage(String key, String value) async {
    _memoryStore[key] = value;
    try {
      final prefs = await getPreferences();
      if (prefs != null) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      debugPrint('Storage write error for $key: $e');
    }
  }

  static Future<void> removeStorage(String key) async {
    _memoryStore.remove(key);
    try {
      final prefs = await getPreferences();
      if (prefs != null) {
        await prefs.remove(key);
      }
    } catch (e) {
      debugPrint('Storage remove error for $key: $e');
    }
  }

  Future<void> _initCustomBaseUrl() async {
    try {
      final saved = await readStorage(_customBaseUrlKey);
      if (saved != null && saved.trim().isNotEmpty) {
        _customBaseUrl = saved.trim();
      }
    } catch (_) {}
  }

  Future<void> setCustomBaseUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      _customBaseUrl = null;
      await removeStorage(_customBaseUrlKey);
    } else {
      _customBaseUrl = url.trim();
      await writeStorage(_customBaseUrlKey, url.trim());
    }
  }

  Future<String?> getCustomBaseUrl() => readStorage(_customBaseUrlKey);

  Future<String?> getToken() => readStorage(_tokenKey);
  Future<void> saveToken(String token) => writeStorage(_tokenKey, token);
  Future<void> clearToken() => removeStorage(_tokenKey);

  Future<String?> getDoctorToken() => readStorage(_doctorTokenKey);
  Future<void> saveDoctorToken(String token) => writeStorage(_doctorTokenKey, token);
  Future<void> clearDoctorToken() => removeStorage(_doctorTokenKey);

  Future<String?> getCentreToken() => readStorage(_centreTokenKey);
  Future<void> saveCentreToken(String token) => writeStorage(_centreTokenKey, token);
  Future<void> clearCentreToken() => removeStorage(_centreTokenKey);

  Future<String?> getAdminToken() => readStorage(_adminTokenKey);
  Future<void> saveAdminToken(String token) => writeStorage(_adminTokenKey, token);
  Future<void> clearAdminToken() => removeStorage(_adminTokenKey);

  Future<String?> getSalonToken() => readStorage(_salonTokenKey);
  Future<void> saveSalonToken(String token) => writeStorage(_salonTokenKey, token);
  Future<void> clearSalonToken() => removeStorage(_salonTokenKey);

  Future<String?> getStylistToken() => readStorage(_stylistTokenKey);
  Future<void> saveStylistToken(String token) => writeStorage(_stylistTokenKey, token);
  Future<void> clearStylistToken() => removeStorage(_stylistTokenKey);

  Future<String?> getCreatorToken() => readStorage(_creatorTokenKey);
  Future<void> saveCreatorToken(String token) => writeStorage(_creatorTokenKey, token);
  Future<void> clearCreatorToken() => removeStorage(_creatorTokenKey);

  Future<String?> getFitnessTrainerToken() => readStorage(_fitnessTrainerTokenKey);
  Future<void> saveFitnessTrainerToken(String token) => writeStorage(_fitnessTrainerTokenKey, token);
  Future<void> clearFitnessTrainerToken() => removeStorage(_fitnessTrainerTokenKey);

  Future<String?> getEventHostToken() => readStorage(_eventHostTokenKey);
  Future<void> saveEventHostToken(String token) => writeStorage(_eventHostTokenKey, token);
  Future<void> clearEventHostToken() => removeStorage(_eventHostTokenKey);

  Future<String?> getDeliveryPartnerToken() => readStorage(_deliveryPartnerTokenKey);
  Future<void> saveDeliveryPartnerToken(String token) => writeStorage(_deliveryPartnerTokenKey, token);
  Future<void> clearDeliveryPartnerToken() => removeStorage(_deliveryPartnerTokenKey);

  Future<String?> getInvestorToken() => readStorage(_investorTokenKey);
  Future<void> saveInvestorToken(String token) => writeStorage(_investorTokenKey, token);
  Future<void> clearInvestorToken() => removeStorage(_investorTokenKey);

  Future<String?> getEntrepreneurToken() => readStorage(_entrepreneurTokenKey);
  Future<void> saveEntrepreneurToken(String token) => writeStorage(_entrepreneurTokenKey, token);
  Future<void> clearEntrepreneurToken() => removeStorage(_entrepreneurTokenKey);

  Future<String?> getWomenJobsToken() => readStorage(_womenJobsTokenKey);
  Future<void> saveWomenJobsToken(String token) => writeStorage(_womenJobsTokenKey, token);
  Future<void> clearWomenJobsToken() => removeStorage(_womenJobsTokenKey);

  Future<String?> getWomenProductsSellerToken() => readStorage(_womenProductsSellerTokenKey);
  Future<void> saveWomenProductsSellerToken(String token) => writeStorage(_womenProductsSellerTokenKey, token);
  Future<void> clearWomenProductsSellerToken() => removeStorage(_womenProductsSellerTokenKey);

  Future<String?> getFinancialEducatorToken() => readStorage(_financialEducatorTokenKey);
  Future<void> saveFinancialEducatorToken(String token) => writeStorage(_financialEducatorTokenKey, token);
  Future<void> clearFinancialEducatorToken() => removeStorage(_financialEducatorTokenKey);

  Future<String?> getMarketplaceProviderToken() => readStorage(_marketplaceProviderTokenKey);
  Future<void> saveMarketplaceProviderToken(String token) => writeStorage(_marketplaceProviderTokenKey, token);
  Future<void> clearMarketplaceProviderToken() => removeStorage(_marketplaceProviderTokenKey);

  Future<String?> getWomenLawyerToken() => readStorage(_womenLawyerTokenKey);
  Future<void> saveWomenLawyerToken(String token) => writeStorage(_womenLawyerTokenKey, token);
  Future<void> clearWomenLawyerToken() => removeStorage(_womenLawyerTokenKey);

  Future<void> clearTokenForRole(AuthRole role) async {
    switch (role) {
      case AuthRole.member:
        await clearToken();
        break;
      case AuthRole.creator:
        await clearCreatorToken();
        break;
      case AuthRole.fitnessTrainer:
        await clearFitnessTrainerToken();
        break;
      case AuthRole.eventHost:
        await clearEventHostToken();
        break;
      case AuthRole.deliveryPartner:
        await clearDeliveryPartnerToken();
        break;
      case AuthRole.investor:
        await clearInvestorToken();
        break;
      case AuthRole.entrepreneur:
        await clearEntrepreneurToken();
        break;
      case AuthRole.womenJobs:
        await clearWomenJobsToken();
        break;
      case AuthRole.womenProductsSeller:
        await clearWomenProductsSellerToken();
        break;
      case AuthRole.financialEducator:
        await clearFinancialEducatorToken();
        break;
      case AuthRole.marketplaceProvider:
        await clearMarketplaceProviderToken();
        break;
      case AuthRole.womenLawyer:
        await clearWomenLawyerToken();
        break;
      case AuthRole.doctor:
        await clearDoctorToken();
        break;
      case AuthRole.centre:
        await clearCentreToken();
        break;
      case AuthRole.salon:
        await clearSalonToken();
        break;
      case AuthRole.stylist:
        await clearStylistToken();
        break;
      case AuthRole.admin:
        await clearAdminToken();
        break;
    }
  }

  static bool isAuthEndpoint(String path) {
    final lower = path.toLowerCase();
    return lower.contains('/login') ||
        lower.contains('/register') ||
        lower.contains('/register-quick') ||
        lower.contains('/otp/') ||
        lower.contains('/verify-email') ||
        lower.contains('/send-email') ||
        lower.contains('/forgot-password') ||
        lower.contains('/reset-password') ||
        lower.contains('/refresh-token') ||
        lower.contains('/health');
  }

  AuthRole? _determineAuthRole({
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
  }) {
    if (adminAuth) return AuthRole.admin;
    if (doctorAuth) return AuthRole.doctor;
    if (salonAuth) return AuthRole.salon;
    if (stylistAuth) return AuthRole.stylist;
    if (centreAuth) return AuthRole.centre;
    if (creatorAuth) return AuthRole.creator;
    if (fitnessTrainerAuth) return AuthRole.fitnessTrainer;
    if (eventHostAuth) return AuthRole.eventHost;
    if (deliveryPartnerAuth) return AuthRole.deliveryPartner;
    if (investorAuth) return AuthRole.investor;
    if (entrepreneurAuth) return AuthRole.entrepreneur;
    if (womenJobsAuth) return AuthRole.womenJobs;
    if (womenProductsSellerAuth) return AuthRole.womenProductsSeller;
    if (financialEducatorAuth) return AuthRole.financialEducator;
    if (womenLawyerAuth) return AuthRole.womenLawyer;
    if (marketplaceProviderAuth) return AuthRole.marketplaceProvider;
    if (auth) return AuthRole.member;
    return null;
  }

  Future<void> handleSessionExpired(AuthRole role) async {
    if (_activeExpiringRoles.contains(role)) return;
    final last = _lastExpiryHandled[role];
    if (last != null && DateTime.now().difference(last) < const Duration(seconds: 3)) {
      return;
    }
    _activeExpiringRoles.add(role);
    try {
      await clearTokenForRole(role);
      if (onSessionExpired != null) {
        await onSessionExpired!(role);
      }
      _lastExpiryHandled[role] = DateTime.now();
    } catch (e) {
      debugPrint('Error handling session expiration for $role: $e');
    } finally {
      _activeExpiringRoles.remove(role);
    }
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<String?> _resolveToken({
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
  }) async {
    if (adminAuth) return getAdminToken();
    if (doctorAuth) return getDoctorToken();
    if (salonAuth) return getSalonToken();
    if (stylistAuth) return getStylistToken();
    if (centreAuth) return getCentreToken();
    if (creatorAuth) {
      final t = await getCreatorToken();
      if (t != null && t.isNotEmpty) return t;
      return getToken();
    }
    if (fitnessTrainerAuth) return getFitnessTrainerToken();
    if (eventHostAuth) return getEventHostToken();
    if (deliveryPartnerAuth) return getDeliveryPartnerToken();
    if (investorAuth) return getInvestorToken();
    if (entrepreneurAuth) return getEntrepreneurToken();
    if (womenJobsAuth) return getWomenJobsToken();
    if (womenProductsSellerAuth) return getWomenProductsSellerToken();
    if (financialEducatorAuth) return getFinancialEducatorToken();
    if (womenLawyerAuth) {
      final t = await getWomenLawyerToken();
      if (t != null && t.isNotEmpty) return t;
      return getMarketplaceProviderToken();
    }
    if (marketplaceProviderAuth) return getMarketplaceProviderToken();
    if (auth) return getToken();
    return null;
  }

  Future<Map<String, String>> _headers({
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await _resolveToken(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    List<http.MultipartFile> files = const [],
    bool auth = false,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool adminAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
    void Function(double progress)? onProgress,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final req = http.MultipartRequest('POST', _uri(path));
    req.fields.addAll(fields);
    req.files.addAll(files);
    req.headers['Accept'] = 'application/json';
    final token = await _resolveToken(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    if (token != null && token.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $token';
    }

    http.StreamedResponse streamed;
    if (onProgress == null) {
      streamed = await req.send().timeout(_uploadTimeout);
    } else {
      final total = req.contentLength;
      final byteStream = req.finalize();
      var sent = 0;
      final counted = byteStream.transform<List<int>>(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sent += data.length;
            if (total > 0) {
              onProgress((sent / total).clamp(0.0, 1.0));
            }
            sink.add(data);
          },
        ),
      );
      final proxy = http.StreamedRequest(req.method, req.url);
      proxy.headers.addAll(req.headers);
      if (total >= 0) {
        proxy.contentLength = total;
      }
      counted.listen(
        proxy.sink.add,
        onError: proxy.sink.addError,
        onDone: proxy.sink.close,
        cancelOnError: true,
      );
      streamed = await proxy.send().timeout(_uploadTimeout);
    }

    final res = await http.Response.fromStream(streamed);
    return _decode(res, path: path, role: role);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
    Duration? timeout,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final res = await http
        .post(
          _uri(path),
          headers: await _headers(
            auth: auth,
            doctorAuth: doctorAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
            creatorAuth: creatorAuth,
            fitnessTrainerAuth: fitnessTrainerAuth,
            eventHostAuth: eventHostAuth,
            deliveryPartnerAuth: deliveryPartnerAuth,
            investorAuth: investorAuth,
            entrepreneurAuth: entrepreneurAuth,
            womenJobsAuth: womenJobsAuth,
            womenProductsSellerAuth: womenProductsSellerAuth,
            financialEducatorAuth: financialEducatorAuth,
            marketplaceProviderAuth: marketplaceProviderAuth,
            womenLawyerAuth: womenLawyerAuth,
          ),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(timeout ?? _browseTimeout);
    return _decode(res, path: path, role: role);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
    Duration? timeout,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final res = await http
        .get(
          _uri(path),
          headers: await _headers(
            auth: auth,
            doctorAuth: doctorAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
            creatorAuth: creatorAuth,
            fitnessTrainerAuth: fitnessTrainerAuth,
            eventHostAuth: eventHostAuth,
            deliveryPartnerAuth: deliveryPartnerAuth,
            investorAuth: investorAuth,
            entrepreneurAuth: entrepreneurAuth,
            womenJobsAuth: womenJobsAuth,
            womenProductsSellerAuth: womenProductsSellerAuth,
            financialEducatorAuth: financialEducatorAuth,
            marketplaceProviderAuth: marketplaceProviderAuth,
            womenLawyerAuth: womenLawyerAuth,
          ),
        )
        .timeout(timeout ?? _browseTimeout);
    return _decode(res, path: path, role: role);
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
        .timeout(timeout ?? _browseTimeout);
    return _decode(res, path: path, role: auth ? AuthRole.member : null);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
    Duration? timeout,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final res = await http
        .put(
          _uri(path),
          headers: await _headers(
            auth: auth,
            doctorAuth: doctorAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
            creatorAuth: creatorAuth,
            fitnessTrainerAuth: fitnessTrainerAuth,
            eventHostAuth: eventHostAuth,
            deliveryPartnerAuth: deliveryPartnerAuth,
            investorAuth: investorAuth,
            entrepreneurAuth: entrepreneurAuth,
            womenJobsAuth: womenJobsAuth,
            womenProductsSellerAuth: womenProductsSellerAuth,
            financialEducatorAuth: financialEducatorAuth,
            marketplaceProviderAuth: marketplaceProviderAuth,
            womenLawyerAuth: womenLawyerAuth,
          ),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(timeout ?? _browseTimeout);
    return _decode(res, path: path, role: role);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
    Duration? timeout,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final req = http.Request('PATCH', _uri(path));
    req.headers.addAll(await _headers(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    ));
    if (body != null) req.body = jsonEncode(body);
    final streamed = await req.send().timeout(timeout ?? _browseTimeout);
    final res = await http.Response.fromStream(streamed);
    return _decode(res, path: path, role: role);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
  }) async {
    final hasProvider = doctorAuth ||
        centreAuth ||
        adminAuth ||
        salonAuth ||
        stylistAuth ||
        creatorAuth ||
        fitnessTrainerAuth ||
        eventHostAuth ||
        deliveryPartnerAuth ||
        investorAuth ||
        entrepreneurAuth ||
        womenJobsAuth ||
        womenProductsSellerAuth ||
        financialEducatorAuth ||
        marketplaceProviderAuth ||
        womenLawyerAuth;
    final role = _determineAuthRole(
      auth: !hasProvider,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final res = await http
        .delete(
          _uri(path),
          headers: await _headers(
            auth: !hasProvider,
            doctorAuth: doctorAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
            creatorAuth: creatorAuth,
            fitnessTrainerAuth: fitnessTrainerAuth,
            eventHostAuth: eventHostAuth,
            deliveryPartnerAuth: deliveryPartnerAuth,
            investorAuth: investorAuth,
            entrepreneurAuth: entrepreneurAuth,
            womenJobsAuth: womenJobsAuth,
            womenProductsSellerAuth: womenProductsSellerAuth,
            financialEducatorAuth: financialEducatorAuth,
            marketplaceProviderAuth: marketplaceProviderAuth,
            womenLawyerAuth: womenLawyerAuth,
          ),
        )
        .timeout(_browseTimeout);
    return _decode(res, path: path, role: role);
  }

  /// Download binary file (e.g. certificate PDF).
  Future<({List<int> bytes, int statusCode, String? filename})> getBytes(
    String path, {
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    bool womenLawyerAuth = false,
  }) async {
    final role = _determineAuthRole(
      auth: auth,
      doctorAuth: doctorAuth,
      centreAuth: centreAuth,
      adminAuth: adminAuth,
      salonAuth: salonAuth,
      stylistAuth: stylistAuth,
      creatorAuth: creatorAuth,
      fitnessTrainerAuth: fitnessTrainerAuth,
      eventHostAuth: eventHostAuth,
      deliveryPartnerAuth: deliveryPartnerAuth,
      investorAuth: investorAuth,
      entrepreneurAuth: entrepreneurAuth,
      womenJobsAuth: womenJobsAuth,
      womenProductsSellerAuth: womenProductsSellerAuth,
      financialEducatorAuth: financialEducatorAuth,
      marketplaceProviderAuth: marketplaceProviderAuth,
      womenLawyerAuth: womenLawyerAuth,
    );
    final res = await http
        .get(
          _uri(path),
          headers: await _headers(
            auth: auth,
            doctorAuth: doctorAuth,
            centreAuth: centreAuth,
            adminAuth: adminAuth,
            salonAuth: salonAuth,
            stylistAuth: stylistAuth,
            creatorAuth: creatorAuth,
            fitnessTrainerAuth: fitnessTrainerAuth,
            eventHostAuth: eventHostAuth,
            deliveryPartnerAuth: deliveryPartnerAuth,
            investorAuth: investorAuth,
            entrepreneurAuth: entrepreneurAuth,
            womenJobsAuth: womenJobsAuth,
            womenProductsSellerAuth: womenProductsSellerAuth,
            financialEducatorAuth: financialEducatorAuth,
            marketplaceProviderAuth: marketplaceProviderAuth,
            womenLawyerAuth: womenLawyerAuth,
          ),
        )
        .timeout(_uploadTimeout);
    if (res.statusCode == 401 && role != null && !isAuthEndpoint(path)) {
      unawaited(handleSessionExpired(role));
    }
    String? filename;
    final cd = res.headers['content-disposition'];
    if (cd != null && cd.contains('filename=')) {
      filename = cd.split('filename=').last.replaceAll('"', '').trim();
    }
    return (bytes: res.bodyBytes, statusCode: res.statusCode, filename: filename);
  }

  /// Exposed for multipart callers that build their own request.
  Map<String, dynamic> decodeResponse(http.Response res, {String? path, AuthRole? role}) =>
      _decode(res, path: path, role: role);

  Map<String, dynamic> _decode(
    http.Response res, {
    String? path,
    AuthRole? role,
  }) {
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

    // Role-specific 401 session-expiration handling
    if (res.statusCode == 401) {
      final isAuth = path != null && isAuthEndpoint(path);
      if (role != null && !isAuth) {
        json['sessionExpired'] = true;
        json['expiredRole'] = role.name;
        json['error'] = 'Your session has expired. Please log in again.';
        unawaited(handleSessionExpired(role));
      }
    }

    return json;
  }
}
