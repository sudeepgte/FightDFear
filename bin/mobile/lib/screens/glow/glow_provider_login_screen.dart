import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/glow_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'glow_salon_dashboard_screen.dart';
import 'glow_salon_profile_completion_screen.dart';

class GlowProviderLoginScreen extends StatelessWidget {
  const GlowProviderLoginScreen({super.key, this.startRegister = false, this.initialTab = 0});

  final bool startRegister;

  /// Kept for older call sites that passed a tab index.
  final int initialTab;

  Widget _dashboard(BuildContext context) => const GlowSalonDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GlowSalonProfileCompletionScreen(
            onFinished: (ctx) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: _dashboard),
              );
            },
          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: _dashboard),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = GlowProviderAuthService(api);
    return PortalAuthScreen(
      title: 'Glow Space',
      defaultRegister: startRegister || initialTab == 1,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage bookings, services and your salon profile',
      loginIcon: Icons.spa_outlined,
      successMessage:
          'Account created. Please login and complete your Glow Space profile to submit for verification.',
      registerFields: const [
        RegFieldDef(
          key: '_role',
          label: 'Join Us as Glow Space — complete salon details after login.',
          type: RegInputType.section,
        ),
        RegFieldDef(key: 'fullName', label: 'Full name / salon name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
      ],
      onSendEmailOtp: svc.sendSalonEmailOtp,
      onVerifyEmailOtp: ({required email, required otp}) =>
          svc.verifySalonEmailOtp(email: email, otp: otp),
      onLoginSuccess: _openAfterLogin,
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          return svc.registerSalonQuick({
            'fullName': extra['fullName'] ?? '',
            'username': email,
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
        }
        return svc.loginSalon(username: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
