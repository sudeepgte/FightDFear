import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/admin_service.dart';
import 'package:fight_d_fear/services/api_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AdminService tests', () {
    test('Admin token management works', () async {
      final api = ApiClient('http://localhost:8080');
      final admin = AdminService(api);

      expect(await admin.isLoggedIn(), isFalse);

      await api.saveAdminToken('mock-admin-token-12345');
      expect(await admin.isLoggedIn(), isTrue);

      await admin.logout();
      expect(await admin.isLoggedIn(), isFalse);
    });
  });
}
