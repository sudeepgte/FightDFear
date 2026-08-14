import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/job_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/women_jobs_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'women_jobs_profile_completion_screen.dart';
import 'women_jobs_worker_dashboard_screen.dart';

class WomenJobsPortalLoginScreen extends StatelessWidget {
  const WomenJobsPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) => const WomenJobsWorkerDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WomenJobsProfileCompletionScreen(
            onFinished: (ctx) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: _dashboard),
              );
            },
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: _dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthState>();
    final svc = WomenJobsAuthService(auth.api, auth);
    return PortalAuthScreen(
      title: 'Women Jobs',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to apply as a worker and manage job bookings',
      loginIcon: Icons.work_outline,
      successMessage:
          'Account created. Please login and complete your worker profile to submit for verification.',
      registerFields: [
        const RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        const RegFieldDef(
          key: 'phone',
          label: 'Phone',
          type: RegInputType.phone,
          required: true,
        ),
        RegFieldDef(
          key: 'jobCategory',
          label: 'Job category',
          type: RegInputType.dropdown,
          options: JobCatalog.categories,
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
            'jobCategory': extra['jobCategory'] ?? '',
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
