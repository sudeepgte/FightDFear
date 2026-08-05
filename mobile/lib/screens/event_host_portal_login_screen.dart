import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/event_host_auth_service.dart';
import 'event_host_dashboard_screen.dart';
import 'event_host_register_screen.dart';
import 'portal_auth_screen.dart';

class EventHostPortalLoginScreen extends StatelessWidget {
  const EventHostPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    if (startRegister) {
      return const EventHostRegisterScreen();
    }

    final api = context.read<AuthState>().api;
    final svc = EventHostAuthService(api);
    return PortalAuthScreen(
      title: 'Event Host',
      defaultRegister: false,
      requireEmailOtp: false,
      requirePhoneOtp: false,
      loginSubtitle: 'Sign in to manage women events, attendees and registrations',
      loginIcon: Icons.event_available_rounded,
      registerFields: const [],
      onCreateAccount: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EventHostRegisterScreen()),
        );
      },
      onSubmit: ({required register, required email, required password, required extra}) {
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => const EventHostDashboardScreen(),
    );
  }
}
