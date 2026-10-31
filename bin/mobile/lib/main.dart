import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/landing/landing_screen.dart';
import 'services/api_client.dart';
import 'services/auth_state.dart';
import 'services/background_location_service.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final prefs = await SharedPreferences.getInstance();
    ApiClient.setPreferences(prefs);
  } catch (e) {
    debugPrint('Warning: SharedPreferences pre-initialization failed: $e');
  }

  try {
    await BackgroundLocationService.instance.init();
  } catch (e) {
    debugPrint('Warning: BackgroundLocationService init failed: $e');
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    debugPrint(details.stack?.toString() ?? '');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught async error: $error\n$stack');
    return true;
  };
  ErrorWidget.builder = (details) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'UI error:\n${details.exceptionAsString()}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      ),
    );
  };
  runApp(const FightDFearApp());
}

class FightDFearApp extends StatelessWidget {
  const FightDFearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final auth = AuthState();
        // Defer network bootstrap so first frame always paints.
        Future.microtask(auth.bootstrap);
        return auth;
      },
      child: MaterialApp(
        title: 'Fight D Fear',
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF43F5E),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          useMaterial3: true,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}
