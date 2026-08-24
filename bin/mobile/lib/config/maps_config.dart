/// Google Maps API key (Android: also set in AndroidManifest.xml).
class MapsConfig {
  /// Override: flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_key
  static const String fromEnv = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static const String defaultKey = 'AIzaSyCr_gUF2YzV16dICNphMfnkyjBFurYLKaM';

  static String get apiKey =>
      fromEnv.isNotEmpty ? fromEnv : defaultKey;

  /// Default map center (Bangalore) when GPS unavailable.
  static const double defaultLat = 12.9716;
  static const double defaultLng = 77.5946;
}
