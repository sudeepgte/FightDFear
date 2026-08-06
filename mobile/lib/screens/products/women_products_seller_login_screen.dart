import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../portals/portal_auth_screen.dart';
import 'women_products_seller_dashboard_screen.dart';
import 'women_products_seller_register_screen.dart';

class WomenProductsSellerLoginScreen extends StatelessWidget {
  const WomenProductsSellerLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    if (startRegister) {
      return const WomenProductsSellerRegisterScreen();
    }

    final api = context.read<AuthState>().api;
    final svc = WomenProductsSellerAuthService(api);
    return PortalAuthScreen(
      title: 'Product Seller',
      defaultRegister: false,
      loginSubtitle: 'Sign in to manage products, orders and store earnings',
      loginIcon: Icons.storefront_rounded,
      registerFields: const [],
      onCreateAccount: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WomenProductsSellerRegisterScreen()),
        );
      },
      onSubmit: ({required register, required email, required password, required extra}) {
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => const WomenProductsSellerDashboardScreen(),
    );
  }
}
