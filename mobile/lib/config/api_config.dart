/// Backend base URL for the Spring Boot API (port 8084 behind nginx).
///
/// Defaults to the production/testing server so the app talks to the same
/// database as the website. For local backend testing, override:
///   flutter run --dart-define=API_BASE=http://10.0.2.2:8084       (Android emulator)
///   flutter run --dart-define=API_BASE=http://localhost:8084      (desktop/Chrome)
///   flutter build apk --dart-define=API_BASE=http://<LAPTOP-IP>:8084
class ApiConfig {
  static const String productionHost = 'https://fightdfire.chethancodehub.com';
  static const String androidEmulatorHost = 'http://10.0.2.2:8084';
  static const String localhostHost = 'http://localhost:8084';

  /// Override at build time:
  /// flutter run --dart-define=API_BASE=http://192.168.1.10:8084
  static const String fromEnv = String.fromEnvironment('API_BASE');

  static String resolve({required bool isAndroid}) {
    if (fromEnv.isNotEmpty) return fromEnv;
    return productionHost;
  }
}
