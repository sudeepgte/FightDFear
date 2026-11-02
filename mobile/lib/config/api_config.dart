import 'package:flutter/foundation.dart';

/// Backend base URL for the Spring Boot API (port 8084).
///
/// Resolution order:
/// 1. `--dart-define=API_BASE=...` (always wins)
/// 2. Android:
///    - Default to the active laptop LAN host (`http://192.168.0.3:8084`), which is reachable
///      from BOTH physical phones on Wi-Fi AND the Android emulator.
/// 3. Desktop / Web / iOS simulator:
///    - Debug: `http://localhost:8084`
///    - Release: `https://fightdfire.chethancodehub.com`
///
/// Examples:
///   flutter run --dart-define=API_BASE=http://192.168.0.3:8084
///   flutter build apk --dart-define=API_BASE=http://`LAPTOP-IP`:8084
class ApiConfig {
  static const String productionHost = 'https://fightdfire.chethancodehub.com';
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
    // Laptop LAN host works for physical devices AND emulators connected to the same Wi-Fi
    urls.add(defaultLocalLanHost);
    if (isAndroid) {
      urls.add(androidEmulatorHost);
    }
    urls.add(localhostHost);
    urls.add(productionHost);
    return urls.toSet().toList();
  }

  static String resolve({required bool isAndroid}) {
    if (fromEnv.isNotEmpty) return fromEnv;
    // On Android devices (both physical phones and emulators), default to the laptop LAN IP.
    // Physical phones CANNOT reach 10.0.2.2 (it only exists inside Android emulator).
    // Emulators CAN reach 192.168.0.3 just as easily as physical phones.
    if (isAndroid) {
      return defaultLocalLanHost;
    }
    if (kDebugMode) {
      return localhostHost;
    }
    return productionHost;
  }
}

