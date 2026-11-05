/// Backend base URL for the Spring Boot API (port 8084).
///
/// Resolution order:
/// 1. `--dart-define=API_BASE=...` (always wins)
/// 2. Android: laptop LAN host (physical phone and emulator on the same Wi-Fi)
/// 3. Desktop / Web / iOS: `http://localhost:8084`
///
/// Staging / production builds must pass the public API URL:
///   flutter run --dart-define=API_BASE=https://YOUR_STAGING_DOMAIN
///   flutter build apk --dart-define=API_BASE=https://YOUR_PRODUCTION_DOMAIN
class ApiConfig {
  static const String androidEmulatorHost = 'http://10.0.2.2:8084';
  static const String localhostHost = 'http://localhost:8084';
  static const String defaultLocalLanHost = 'http://192.168.0.3:8084';

  /// Override at build time:
  /// flutter run --dart-define=API_BASE=http://192.168.x.x:8084
  static const String fromEnv = String.fromEnvironment('API_BASE');

  /// Candidate URLs in priority order for automatic reachability probing
  static List<String> getCandidateUrls({required bool isAndroid}) {
    final urls = <String>[];
    if (fromEnv.isNotEmpty) {
      urls.add(fromEnv.trim());
    }
    urls.add(defaultLocalLanHost);
    if (isAndroid) {
      urls.add(androidEmulatorHost);
    }
    urls.add(localhostHost);
    return urls.toSet().toList();
  }

  static String resolve({required bool isAndroid}) {
    if (fromEnv.isNotEmpty) return fromEnv;
    if (isAndroid) {
      return defaultLocalLanHost;
    }
    return localhostHost;
  }
}
