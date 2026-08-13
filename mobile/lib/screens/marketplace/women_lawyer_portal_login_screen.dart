import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'women_lawyer_dashboard_screen.dart';
import 'women_lawyer_profile_completion_screen.dart';

class WomenLawyerPortalLoginScreen extends StatelessWidget {
  const WomenLawyerPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) => const WomenLawyerDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WomenLawyerProfileCompletionScreen(
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
    final svc = MarketplaceProviderAuthService(api);
    return PortalAuthScreen(
      title: 'Women Lawyer',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage legal consultations and clients',
      loginIcon: Icons.gavel_outlined,
      successMessage:
          'Account created. Please login and complete your lawyer profile to submit for verification.',
      registerFields: const [
        RegFieldDef(
          key: '_role',
          label: 'Join Us as Women Lawyer — category is locked to legal consultations.',
          type: RegInputType.section,
        ),
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(
          key: 'phone',
          label: 'Phone',
          type: RegInputType.phone,
          required: true,
        ),
      ],
      onSendEmailOtp: svc.sendEmailOtp,
      onVerifyEmailOtp: ({required email, required otp}) =>
          svc.verifyEmailOtp(email: email, otp: otp),
      onLoginSuccess: _openAfterLogin,
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          return svc.registerQuick({
            'fullName': extra['fullName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'category': 'WOMEN_LAWYER',
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
        }
        return svc.login(
          email: email,
          password: password,
          expectedCategory: 'WOMEN_LAWYER',
        );
      },
      dashboardBuilder: _dashboard,
    );
  }
}
