import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../../widgets/profile_completion_helpers.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import 'women_products_seller_dashboard_screen.dart';
import 'women_products_seller_pending_approval_screen.dart';
import 'women_products_seller_profile_completion_screen.dart';

class WomenProductsSellerLoginScreen extends StatelessWidget {
  const WomenProductsSellerLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  Widget _dashboard(BuildContext context) =>
      const WomenProductsSellerDashboardScreen();

  Future<void> _openAfterLogin(
    BuildContext context,
    Map<String, dynamic> res,
  ) async {
    final seller = res['seller'] is Map ? Map<String, dynamic>.from(res['seller'] as Map) : res;
    final status = (seller['partnerProfileStatus'] ?? res['partnerProfileStatus'] ?? '').toString().toUpperCase();
    final verificationStatus = (seller['verificationStatus'] ?? res['verificationStatus'] ?? '').toString().toUpperCase();
    final isApproved = status == 'APPROVED' || verificationStatus == 'VERIFIED' || res['approved'] == true || seller['approved'] == true || seller['canListProducts'] == true;

    if (isApproved) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: _dashboard),
      );
      return;
    }

    if (status == 'PENDING_ADMIN_APPROVAL' || (verificationStatus == 'PENDING' && status != 'PROFILE_INCOMPLETE' && status != 'CHANGES_REQUESTED')) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WomenProductsSellerPendingApprovalScreen(
            initialProfile: seller,
          ),
        ),
      );
      return;
    }

    final needsCompletion = ApprovalNavigation.shouldRedirectToProfileCompletion(res);
    if (needsCompletion ||
        status == 'REGISTERED' ||
        status == 'PROFILE_INCOMPLETE' ||
        status == 'READY_FOR_VERIFICATION' ||
        status == 'CHANGES_REQUESTED') {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WomenProductsSellerProfileCompletionScreen(
            onFinished: (ctx) {
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => WomenProductsSellerPendingApprovalScreen(
                    initialProfile: seller,
                  ),
                ),
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
    final api = context.read<AuthState>().api;
    final svc = WomenProductsSellerAuthService(api);
    return PortalAuthScreen(
      title: 'Product Seller',
      defaultRegister: startRegister,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage products, orders and store earnings',
      loginIcon: Icons.storefront_rounded,
      successMessage:
          'Account created. Please login and complete your shop profile to submit for verification.',
      registerFields: const [
        RegFieldDef(
          key: '_role',
          label: 'Join Us as Product Seller — complete shop details after login.',
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
