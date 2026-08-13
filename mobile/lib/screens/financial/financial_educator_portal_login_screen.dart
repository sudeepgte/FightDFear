import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/financial_educator_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'financial_educator_dashboard_screen.dart';
import 'financial_educator_profile_completion_screen.dart';

class FinancialEducatorPortalLoginScreen extends StatelessWidget {
  const FinancialEducatorPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) => const FinancialEducatorDashboardScreen();

  Future<void> _openAfterLogin(BuildContext context, Map<String, dynamic> res) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => FinancialEducatorProfileCompletionScreen(
            onFinished: (ctx) {
              Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: _dashboard));
            },
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: _dashboard));
  }

  @override
  Widget build(BuildContext context) {
    final svc = FinancialEducatorAuthService(context.read<AuthState>().api);
    return PortalAuthScreen(
      title: 'Financial Educator',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to publish videos, live sessions and workshops',
      loginIcon: Icons.menu_book_outlined,
      successMessage:
          'Account created. Please login and complete your educator profile to submit for verification.',
      registerFields: const [
        RegFieldDef(
          key: '_role',
          label: 'Join Us as a Financial Educator — teach saving, investing, loans and more.',
          type: RegInputType.section,
        ),
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
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
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
