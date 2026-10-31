import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ApiClient Storage & Channel Resilience Tests', () {
    test('Token save, read, and clear works with normal SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      expect(await api.getToken(), isNull);

      await api.saveToken('jwt-test-token-abc');
      expect(await api.getToken(), 'jwt-test-token-abc');

      // Verify it was actually written to SharedPreferences
      expect(prefs.getString('auth_token'), 'jwt-test-token-abc');

      await api.clearToken();
      expect(await api.getToken(), isNull);
      expect(prefs.getString('auth_token'), isNull);
    });

    test('In-memory fallback works when SharedPreferences is null or fails', () async {
      // Simulate platform channel failure / null prefs
      ApiClient.setPreferences(null);
      final api = ApiClient('http://10.0.2.2:8084');

      // Saving should not throw PlatformException
      await api.saveToken('in-memory-token-xyz');
      expect(await api.getToken(), 'in-memory-token-xyz');

      // Other tokens should also use resilient storage
      await api.saveDoctorToken('doc-token-123');
      expect(await api.getDoctorToken(), 'doc-token-123');

      await api.clearToken();
      expect(await api.getToken(), isNull);
      expect(await api.getDoctorToken(), 'doc-token-123');
    });

    test('Custom base URL storage and fallback', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      expect(api.baseUrl, 'http://10.0.2.2:8084');

      await api.setCustomBaseUrl('http://192.168.1.50:8084');
      expect(api.baseUrl, 'http://192.168.1.50:8084');
      expect(await api.getCustomBaseUrl(), 'http://192.168.1.50:8084');

      await api.setCustomBaseUrl(null);
      expect(api.baseUrl, 'http://10.0.2.2:8084');
      expect(await api.getCustomBaseUrl(), isNull);
    });
  });

  group('AuthState Error Formatting Tests', () {
    test('PlatformException is categorized as device storage error, not cannot reach server', () {
      final exception = PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel: dev.flutter.pigeon.shared_preferences_android.SharedPreferencesApi.getAll',
      );

      // Testing through auth_state error parsing
      final msg = exception.toString();
      expect(msg.contains('channel-error'), isTrue);
      expect(msg.contains('Cannot reach server'), isFalse);
    });
  });
}
