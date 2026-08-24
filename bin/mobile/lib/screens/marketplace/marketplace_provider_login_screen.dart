import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/marketplace_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'marketplace_provider_dashboard_screen.dart';
import 'marketplace_provider_profile_completion_screen.dart';

class MarketplaceProviderLoginScreen extends StatelessWidget {
  const MarketplaceProviderLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) =>
      const MarketplaceProviderDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final needsCompletion = res['needsProfileCompletion'] == true;
    if (needsCompletion) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MarketplaceProviderProfileCompletionScreen(
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

  String _categoryApi(String? label) =>
      MarketplaceCatalog.codeFor(label) ?? '';

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = MarketplaceProviderAuthService(api);
    return PortalAuthScreen(
      title: 'Service Partner',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage bookings, clients & earnings',
      loginIcon: Icons.handshake_outlined,
      successMessage:
          'Account created. Please login and complete your profile to submit for verification.',
      registerFields: [
        const RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        const RegFieldDef(
          key: 'phone',
          label: 'Phone',
          type: RegInputType.phone,
          required: true,
        ),
        RegFieldDef(
          key: 'category',
          label: 'Service category',
          type: RegInputType.dropdown,
          options: RegOptions.marketplaceCategories,
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
            'category': _categoryApi(extra['category']),
            'acceptedTerms': extra['acceptedTerms'] == 'true',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: _dashboard,
    );
  }
}
