import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/event_host_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'event_host_dashboard_screen.dart';
import 'event_host_profile_completion_screen.dart';

class EventHostPortalLoginScreen extends StatelessWidget {
  const EventHostPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) => const EventHostDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EventHostProfileCompletionScreen(
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
    final svc = EventHostAuthService(api);
    return PortalAuthScreen(
      title: 'Event Host',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage women events, attendees and registrations',
      loginIcon: Icons.event_available_rounded,
      successMessage:
          'Account created. Sign in, complete your organizer profile, then submit for admin verification.',
      registerFields: const [
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
      ],
      onSendEmailOtp: svc.sendEmailOtp,
      onVerifyEmailOtp: ({required email, required otp}) =>
          svc.verifyEmailOtp(email: email, otp: otp),
      onLoginSuccess: _openAfterLogin,
      onSubmit: ({required register, required email, required password, required extra}) async {
        if (register) {
          final res = await svc.registerQuick({
            'fullName': extra['fullName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
          if (res['success'] == true) {
            final name = (extra['fullName'] ?? '').toString().trim();
            final phone = (extra['phone'] ?? '').toString().trim();
            res['message'] =
                'Account created.\n\n'
                'Name: ${name.isEmpty ? '—' : name}\n'
                'Email: $email\n'
                'Phone: ${phone.isEmpty ? '—' : phone}\n\n'
                'Next: sign in, complete your organizer profile, then submit for admin verification. You cannot create events until an admin approves your profile.';
          }
          return res;
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
