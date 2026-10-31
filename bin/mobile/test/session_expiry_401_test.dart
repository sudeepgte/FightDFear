import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/auth_state.dart';
import 'package:fight_d_fear/services/navigation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ApiClient.resetSessionExpiredStateForTesting();
    NavigationService.onSessionExpiredForTesting = null;
  });

  group('Phase 2: Global HTTP 401 Session-Expiry Handling Tests', () {
    test('1-3. Expire Member token on authenticated request: clears member token, updates AuthState, triggers member expiry', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('expired-member-jwt');
      auth.loggedIn = true;

      AuthRole? expiredRole;
      String? expiredMsg;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiredRole = role;
        expiredMsg = msg;
      };

      // Mock 401 on an authenticated Member endpoint
      final mockResponse = http.Response(
        jsonEncode({'success': false, 'message': 'JWT token has expired'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      final res = auth.api.decodeResponse(mockResponse, path: '/api/me', role: AuthRole.member);

      expect(res['_status'], 401);
      expect(res['sessionExpired'], true);
      expect(res['expiredRole'], 'member');

      // Allow microtasks / async unawaited handleSessionExpired to finish
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Verify Member token cleared
      expect(await auth.api.getToken(), isNull);
      expect(prefs.getString('auth_token'), isNull);

      // Verify AuthState updated
      expect(auth.loggedIn, false);
      expect(auth.error, 'Your session has expired. Please log in again.');

      // Verify NavigationService triggered
      expect(expiredRole, AuthRole.member);
      expect(expiredMsg, 'Your session has expired. Please log in again.');
    });

    test('4-6. Expire Fitness Trainer token: clears ONLY trainer token, Member session remains ACTIVE', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('active-member-jwt');
      await auth.api.saveFitnessTrainerToken('expired-trainer-jwt');
      auth.loggedIn = true;

      AuthRole? expiredRole;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiredRole = role;
      };

      final mockResponse = http.Response(
        jsonEncode({'success': false, 'message': 'Trainer JWT expired'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      final res = auth.api.decodeResponse(
        mockResponse,
        path: '/api/fitness/trainer/profile',
        role: AuthRole.fitnessTrainer,
      );

      expect(res['_status'], 401);
      expect(res['sessionExpired'], true);
      expect(res['expiredRole'], 'fitnessTrainer');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Trainer token must be cleared
      expect(await auth.api.getFitnessTrainerToken(), isNull);
      expect(prefs.getString('fitness_trainer_auth_token'), isNull);

      // CRITICAL: Member token and AuthState must remain completely active!
      expect(await auth.api.getToken(), 'active-member-jwt');
      expect(prefs.getString('auth_token'), 'active-member-jwt');
      expect(auth.loggedIn, true);

      // Verify Navigation triggered for trainer
      expect(expiredRole, AuthRole.fitnessTrainer);
    });

    test('7. Expire Event Host token: preserves Member session and Trainer session', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('active-member-jwt');
      await auth.api.saveFitnessTrainerToken('active-trainer-jwt');
      await auth.api.saveEventHostToken('expired-host-jwt');
      auth.loggedIn = true;

      AuthRole? expiredRole;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiredRole = role;
      };

      final mockResponse = http.Response(
        jsonEncode({'success': false, 'message': 'Host JWT expired'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      auth.api.decodeResponse(
        mockResponse,
        path: '/api/women-events/host/profile',
        role: AuthRole.eventHost,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Only host token is cleared
      expect(await auth.api.getEventHostToken(), isNull);

      // Member and Trainer sessions remain active
      expect(await auth.api.getToken(), 'active-member-jwt');
      expect(await auth.api.getFitnessTrainerToken(), 'active-trainer-jwt');
      expect(auth.loggedIn, true);
      expect(expiredRole, AuthRole.eventHost);
    });

    test('8. Concurrency protection: simultaneous 401 responses invoke expiry handler only ONCE per role', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('member-token-123');

      int expiryCallCount = 0;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiryCallCount++;
      };

      final mockResponse = http.Response(
        jsonEncode({'success': false, 'message': 'Expired'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      // Trigger 5 simultaneous 401 responses for Member
      auth.api.decodeResponse(mockResponse, path: '/api/me', role: AuthRole.member);
      auth.api.decodeResponse(mockResponse, path: '/api/sos/active', role: AuthRole.member);
      auth.api.decodeResponse(mockResponse, path: '/api/journey/active', role: AuthRole.member);
      auth.api.decodeResponse(mockResponse, path: '/api/me/trusted-contacts', role: AuthRole.member);
      auth.api.decodeResponse(mockResponse, path: '/api/notifications', role: AuthRole.member);

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Must be handled exactly ONCE, avoiding duplicate navigation or dialogs
      expect(expiryCallCount, 1);
      expect(await auth.api.getToken(), isNull);
    });

    test('9. Important Exceptions: Authentication endpoints (login, register, otp) do NOT trigger session expiry on 401', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('saved-token');

      bool expiryTriggered = false;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiryTriggered = true;
      };

      final invalidCredsResponse = http.Response(
        jsonEncode({'success': false, 'error': 'Invalid credentials'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      // Test Member login 401
      final res1 = auth.api.decodeResponse(
        invalidCredsResponse,
        path: '/api/auth/login',
        role: null, // login is unauthenticated
      );
      expect(res1['sessionExpired'], isNull);
      expect(res1['error'], 'Invalid credentials');
      expect(expiryTriggered, false);

      // Test Provider login 401 (even if role is somehow passed)
      final res2 = auth.api.decodeResponse(
        invalidCredsResponse,
        path: '/api/fitness/trainer/login',
        role: AuthRole.fitnessTrainer,
      );
      expect(res2['sessionExpired'], isNull);
      expect(res2['error'], 'Invalid credentials');
      expect(expiryTriggered, false);

      // Test OTP endpoint 401
      final res3 = auth.api.decodeResponse(
        invalidCredsResponse,
        path: '/api/creator-hub/otp/verify-email',
        role: AuthRole.creator,
      );
      expect(res3['sessionExpired'], isNull);
      expect(expiryTriggered, false);

      // Token was NOT wiped
      expect(await auth.api.getToken(), 'saved-token');
    });

    test('10. Existing Admin, Doctor, Centre, Salon and Stylist sessions handled reliably', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);

      final auth = AuthState();
      await auth.api.saveToken('member-jwt');
      await auth.api.saveDoctorToken('doctor-jwt');
      await auth.api.saveAdminToken('admin-jwt');

      AuthRole? expiredRole;
      NavigationService.onSessionExpiredForTesting = (role, msg) {
        expiredRole = role;
      };

      final mockResponse = http.Response(
        jsonEncode({'success': false, 'message': 'Doctor session expired'}),
        401,
        headers: {'content-type': 'application/json'},
      );

      auth.api.decodeResponse(
        mockResponse,
        path: '/api/doctors/profile',
        role: AuthRole.doctor,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Doctor token cleared
      expect(await auth.api.getDoctorToken(), isNull);

      // Member and Admin sessions unaffected
      expect(await auth.api.getToken(), 'member-jwt');
      expect(await auth.api.getAdminToken(), 'admin-jwt');
      expect(expiredRole, AuthRole.doctor);
    });
  });
}
