import 'package:flutter/material.dart';

import 'event_host_portal_login_screen.dart';

/// Thin entry that opens the Event Host portal in register mode (quick signup).
class EventHostRegisterScreen extends StatelessWidget {
  const EventHostRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EventHostPortalLoginScreen(startRegister: true);
  }
}
