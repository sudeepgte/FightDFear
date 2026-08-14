/// Backend base URL for the Spring Boot API (port 8086).
///
/// - Android emulator → 10.0.2.2 maps to the host machine's localhost
/// - Chrome / Windows desktop → localhost
/// - Physical phone → set your PC's LAN IP, e.g. http://192.168.1.10:8086
class ApiConfig {
  static const String androidEmulatorHost = 'http://10.0.2.2:8086';
  static const String localhostHost = 'http://localhost:8086';

  /// Override at build time:
  /// flutter run --dart-define=API_BASE=http://192.168.1.10:8086
  static const String fromEnv = String.fromEnvironment('API_BASE');

  static String resolve({required bool isAndroid}) {
    if (fromEnv.isNotEmpty) return fromEnv;
    return isAndroid ? androidEmulatorHost : localhostHost;
  }
}
