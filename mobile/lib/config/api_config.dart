/// Backend base URL for the Spring Boot API.
///
/// Defaults to the production server so the app talks to the same
/// database as the website out of the box. For local backend testing,
/// override at build/run time:
///   flutter run --dart-define=API_BASE=http://10.0.2.2:8084       (Android emulator)
///   flutter run --dart-define=API_BASE=http://localhost:8084      (desktop/Chrome)
///   flutter build apk --dart-define=API_BASE=http://<LAPTOP-IP>:8084  (physical phone, same LAN)
class ApiConfig {
  static const String productionHost = 'https://fightdfire.chethancodehub.com';

  /// Override at build time:
  /// flutter run --dart-define=API_BASE=http://192.168.1.10:8084
  static const String fromEnv = String.fromEnvironment('API_BASE');

  static String resolve({required bool isAndroid}) {
    if (fromEnv.isNotEmpty) return fromEnv;
    return productionHost;
  }
}
