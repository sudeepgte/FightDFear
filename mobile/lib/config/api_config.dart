/// Backend base URL for the Spring Boot API (port 8086).
///
/// - Android emulator → http://10.0.2.2:8086 (maps to laptop localhost)
/// - Physical phone later → build with:
///   flutter build apk --dart-define=API_BASE=http://<LAPTOP-IP>:8086
///   or use USB: adb reverse tcp:8086 tcp:8086 + API_BASE=http://127.0.0.1:8086
/// - Chrome / Windows desktop → localhost
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
