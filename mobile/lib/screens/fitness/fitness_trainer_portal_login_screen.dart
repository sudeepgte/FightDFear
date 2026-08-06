import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/fitness_trainer_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import '../portals/portal_auth_screen.dart';
import '../portals/portal_dashboard_screen.dart';

class FitnessTrainerPortalLoginScreen extends StatelessWidget {
  const FitnessTrainerPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = FitnessTrainerAuthService(api);
    return PortalAuthScreen(
      title: 'Fitness Trainer',
      defaultRegister: startRegister,
      successMessage:
          'Registration submitted successfully. Your provider profile is under verification and will be activated after approval.',
      registerFields: const [
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
        RegFieldDef(key: 'specializations', label: 'Specializations', initial: 'Yoga', required: true),
        RegFieldDef(key: 'experience', label: 'Years of experience', type: RegInputType.number),
        RegFieldDef(
          key: 'serviceType',
          label: 'Service type',
          type: RegInputType.dropdown,
          options: RegOptions.serviceTypes,
          required: true,
        ),
        RegFieldDef(key: 'city', label: 'City', required: true),
        RegFieldDef(key: 'sessionFees', label: 'Starting price / session fees (₹)', type: RegInputType.number, initial: '300'),
        RegFieldDef(
          key: 'availableTimings',
          label: 'Availability',
          type: RegInputType.chips,
          options: RegOptions.availabilitySlots,
        ),
        RegFieldDef(key: 'photo', label: 'Profile photo', type: RegInputType.file),
        RegFieldDef(key: 'certificate', label: 'Certificate', type: RegInputType.file),
      ],
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          return svc.register({
            'fullName': extra['fullName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'specializations': [
              extra['specializations'] ?? '',
              if ((extra['serviceType'] ?? '').isNotEmpty) 'Mode: ${extra['serviceType']}',
              if ((extra['city'] ?? '').isNotEmpty) 'City: ${extra['city']}',
            ].where((e) => e.trim().isNotEmpty).join(' · '),
            'experience': extra['experience'] ?? '',
            'sessionFees': extra['sessionFees'] ?? '300',
            'availableTimings': extra['availableTimings'] ?? '',
            'certificationsPath': extra['certificate'] ?? 'mobile-pending',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => PortalDashboardScreen(
        title: 'Trainer Dashboard',
        profileKey: 'trainer',
        listKey: 'bookings',
        listTitle: 'Bookings',
        statusActions: const ['APPROVED', 'REJECTED', 'COMPLETED', 'CANCELLED'],
        load: () => FitnessTrainerAuthService(api).dashboard(),
        onStatus: (id, status) => FitnessTrainerAuthService(api).updateBookingStatus(id, status),
      ),
    );
  }
}
