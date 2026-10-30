import 'package:flutter/material.dart';

import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/creator/creator_portal_login_screen.dart';
import '../screens/doctors/doctor_portal_login_screen.dart';
import '../screens/entrepreneur/entrepreneur_portal_login_screen.dart';
import '../screens/events/event_host_portal_login_screen.dart';
import '../screens/financial/financial_educator_portal_login_screen.dart';
import '../screens/fitness/fitness_trainer_portal_login_screen.dart';
import '../screens/glow/glow_provider_login_screen.dart';
import '../screens/investor/investor_portal_login_screen.dart';
import '../screens/marketplace/marketplace_provider_login_screen.dart';
import '../screens/marketplace/women_jobs_portal_login_screen.dart';
import '../screens/martial_arts/martial_arts_centre_login_screen.dart';
import '../screens/products/delivery_portal_login_screen.dart';
import '../screens/products/women_products_seller_login_screen.dart';
import 'api_client.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Optional hook for headless testing or custom interception
  static void Function(AuthRole role, String message)? onSessionExpiredForTesting;

  static Future<void> handleSessionExpired(AuthRole role) async {
    final state = navigatorKey.currentState;
    final context = navigatorKey.currentContext;

    final Widget targetScreen;
    final String message;

    switch (role) {
      case AuthRole.member:
        targetScreen = const LoginScreen();
        message = 'Your session has expired. Please log in again.';
        break;
      case AuthRole.creator:
        targetScreen = const CreatorPortalLoginScreen();
        message = 'Your creator session has expired. Please log in again.';
        break;
      case AuthRole.fitnessTrainer:
        targetScreen = const FitnessTrainerPortalLoginScreen();
        message = 'Your trainer session has expired. Please log in again.';
        break;
      case AuthRole.eventHost:
        targetScreen = const EventHostPortalLoginScreen();
        message = 'Your event host session has expired. Please log in again.';
        break;
      case AuthRole.deliveryPartner:
        targetScreen = const DeliveryPortalLoginScreen();
        message = 'Your delivery partner session has expired. Please log in again.';
        break;
      case AuthRole.investor:
        targetScreen = const InvestorPortalLoginScreen();
        message = 'Your investor session has expired. Please log in again.';
        break;
      case AuthRole.entrepreneur:
        targetScreen = const EntrepreneurPortalLoginScreen();
        message = 'Your entrepreneur session has expired. Please log in again.';
        break;
      case AuthRole.womenJobs:
        targetScreen = const WomenJobsPortalLoginScreen();
        message = 'Your jobs portal session has expired. Please log in again.';
        break;
      case AuthRole.womenProductsSeller:
        targetScreen = const WomenProductsSellerLoginScreen();
        message = 'Your seller session has expired. Please log in again.';
        break;
      case AuthRole.financialEducator:
        targetScreen = const FinancialEducatorPortalLoginScreen();
        message = 'Your educator session has expired. Please log in again.';
        break;
      case AuthRole.marketplaceProvider:
        targetScreen = const MarketplaceProviderLoginScreen();
        message = 'Your marketplace provider session has expired. Please log in again.';
        break;
      case AuthRole.doctor:
        targetScreen = const DoctorPortalLoginScreen();
        message = 'Your doctor session has expired. Please log in again.';
        break;
      case AuthRole.centre:
        targetScreen = const MartialArtsCentreLoginScreen();
        message = 'Your centre session has expired. Please log in again.';
        break;
      case AuthRole.salon:
      case AuthRole.stylist:
        targetScreen = const GlowProviderLoginScreen();
        message = 'Your glow session has expired. Please log in again.';
        break;
      case AuthRole.admin:
        targetScreen = const AdminDashboardScreen();
        message = 'Your admin session has expired. Please log in again.';
        break;
    }

    if (onSessionExpiredForTesting != null) {
      onSessionExpiredForTesting!(role, message);
    }

    if (context != null) {
      try {
        final scaffold = ScaffoldMessenger.maybeOf(context);
        if (scaffold != null) {
          scaffold.hideCurrentSnackBar();
          scaffold.showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: const Color(0xFFE11D48),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        debugPrint('Warning: Could not display session expiry banner: $e');
      }
    }

    if (state != null) {
      if (role == AuthRole.member) {
        state.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => targetScreen),
          (_) => false,
        );
      } else {
        state.push(
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      }
    }
  }
}
