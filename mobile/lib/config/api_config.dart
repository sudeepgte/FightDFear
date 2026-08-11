import 'package:flutter/foundation.dart';

/// Backend base URL for the Spring Boot API (port 8084).
///
/// Resolution order:
/// 1. `--dart-define=API_BASE=...` (always wins)
/// 2. Debug builds → local backend (emulator: 10.0.2.2, else localhost)
/// 3. Release builds → production
///
/// Examples:
///   flutter run --dart-define=API_BASE=http://192.168.1.10:8084
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
    // Keep local admin + Flutter on the same MySQL DB during development.
    if (kDebugMode) {
      return isAndroid ? androidEmulatorHost : localhostHost;
    }
    return productionHost;
  }
}
