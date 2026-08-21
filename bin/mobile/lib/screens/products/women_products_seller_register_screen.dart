import 'package:flutter/material.dart';

import 'women_products_seller_login_screen.dart';

/// Compatibility entry — Join Us opens the quick PortalAuth registration flow.
class WomenProductsSellerRegisterScreen extends StatelessWidget {
  const WomenProductsSellerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WomenProductsSellerLoginScreen(startRegister: true);
  }
}
