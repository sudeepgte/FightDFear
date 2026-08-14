import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'martial_arts_centre_dashboard_screen.dart';
import 'martial_arts_centre_profile_completion_screen.dart';

class MartialArtsCentreLoginScreen extends StatelessWidget {
  const MartialArtsCentreLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) => const MartialArtsCentreDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MartialArtsCentreProfileCompletionScreen(
            onFinished: (ctx) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const MartialArtsCentreDashboardScreen()),
              );
            },
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MartialArtsCentreDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final svc = CentreAuthService(context.read<AuthState>().api);
    return PortalAuthScreen(
      title: 'Self-Defence Centre',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage batches, students and your centre profile',
      loginIcon: Icons.sports_martial_arts_outlined,
      successMessage:
          'Account created. Please login and complete your centre profile to submit for verification.',
      registerFields: const [
        RegFieldDef(
          key: '_role',
          label: 'Join Us as a Self-Defence Trainer / Centre — complete details after login.',
          type: RegInputType.section,
        ),
        RegFieldDef(key: 'name', label: 'Centre / trainer name', required: true),
        RegFieldDef(key: 'contactPerson', label: 'Contact person'),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
      ],
      onSendEmailOtp: svc.sendEmailOtp,
      onVerifyEmailOtp: ({required email, required otp}) =>
          svc.verifyEmailOtp(email: email, otp: otp),
      onLoginSuccess: _openAfterLogin,
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          return svc.registerQuick({
            'name': extra['name'] ?? '',
            'contactPerson': extra['contactPerson'] ?? extra['name'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'acceptedTerms': extra['acceptedTerms'] == 'true',
            if ((extra['emailOtp'] ?? '').isNotEmpty) 'emailOtp': extra['emailOtp'],
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
