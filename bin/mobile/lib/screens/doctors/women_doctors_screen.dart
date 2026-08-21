import 'package:flutter/material.dart';

import '../marketplace/provider_catalog_screen.dart';

/// Dedicated Women Doctor patient entry — browse, book, pay, manage appointments.
class WomenDoctorsScreen extends StatelessWidget {
  const WomenDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderCatalogScreen(
      title: 'Women Doctors',
      kind: CatalogKind.doctors,
    );
  }
}
