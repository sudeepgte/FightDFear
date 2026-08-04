import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/entrepreneur_auth_service.dart';
import '../widgets/registration_form_kit.dart';
import 'entrepreneur_dashboard_screen.dart';
import 'portal_auth_screen.dart';

class EntrepreneurPortalLoginScreen extends StatelessWidget {
  const EntrepreneurPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = EntrepreneurAuthService(api);
    return PortalAuthScreen(
      title: 'Entrepreneur',
      defaultRegister: startRegister,
      requireEmailOtp: true,
      requirePhoneOtp: true,
      loginSubtitle: 'Sign in to manage proposals, funding progress & investor interest',
      loginIcon: Icons.rocket_launch_rounded,
      successMessage:
          'Entrepreneur registration submitted successfully. Your profile and first proposal are under verification at Investment Platform.',
      registerFields: const [
        RegFieldDef(key: 'sec_biz', label: 'Business details', type: RegInputType.section),
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
        RegFieldDef(key: 'businessName', label: 'Business / startup name', required: true),
        RegFieldDef(
          key: 'businessCategory',
          label: 'Business category',
          type: RegInputType.dropdown,
          options: RegOptions.businessCategories,
          required: true,
        ),
        RegFieldDef(
          key: 'businessDescription',
          label: 'Business description',
          type: RegInputType.multiline,
          maxLines: 4,
          maxLength: 500,
          required: true,
        ),
        RegFieldDef(key: 'yearsInBusiness', label: 'Years in business', type: RegInputType.number, required: true),
        RegFieldDef(
          key: 'businessAddress',
          label: 'Business address',
          type: RegInputType.multiline,
          required: true,
        ),
        RegFieldDef(key: 'city', label: 'City', required: true),
        RegFieldDef(
          key: 'state',
          label: 'State',
          type: RegInputType.dropdown,
          options: RegOptions.indianStates,
          required: true,
        ),
        RegFieldDef(key: 'website', label: 'Website (optional)'),
        RegFieldDef(key: 'linkedin', label: 'LinkedIn'),
        RegFieldDef(key: 'instagram', label: 'Instagram'),
        RegFieldDef(key: 'facebook', label: 'Facebook'),
        RegFieldDef(key: 'registrationNumber', label: 'Business registration number (optional)'),
        RegFieldDef(key: 'gstNumber', label: 'GST number (optional)'),
        RegFieldDef(
          key: 'startupStage',
          label: 'Startup stage',
          type: RegInputType.dropdown,
          options: RegOptions.startupStages,
          required: true,
        ),
        RegFieldDef(key: 'employees', label: 'Number of employees', type: RegInputType.number),
        RegFieldDef(
          key: 'fundingRequirement',
          label: 'Funding requirement (Rs)',
          type: RegInputType.number,
          required: true,
        ),
        RegFieldDef(
          key: 'expectedMonthlyIncome',
          label: 'Expected monthly income (Rs)',
          type: RegInputType.number,
        ),
        RegFieldDef(key: 'sec_docs', label: 'Documents', type: RegInputType.section),
        RegFieldDef(key: 'logo', label: 'Company logo', type: RegInputType.file),
        RegFieldDef(key: 'pitchDeck', label: 'Pitch deck (PDF/image)', type: RegInputType.file),
        RegFieldDef(key: 'govId', label: 'Government ID verification', type: RegInputType.file, required: true),
      ],
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          return svc.register({
            'fullName': extra['fullName'] ?? '',
            'businessName': extra['businessName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'businessCategory': extra['businessCategory'] ?? '',
            'businessLocation': '${extra['city'] ?? ''}, ${extra['state'] ?? ''}',
            'businessDescription': [
              extra['businessDescription'] ?? '',
              if ((extra['businessAddress'] ?? '').isNotEmpty) 'Address: ${extra['businessAddress']}',
              if ((extra['startupStage'] ?? '').isNotEmpty) 'Stage: ${extra['startupStage']}',
              if ((extra['employees'] ?? '').isNotEmpty) 'Employees: ${extra['employees']}',
              if ((extra['website'] ?? '').isNotEmpty) 'Web: ${extra['website']}',
              if ((extra['linkedin'] ?? '').isNotEmpty) 'LI: ${extra['linkedin']}',
              if ((extra['instagram'] ?? '').isNotEmpty) 'IG: ${extra['instagram']}',
              if ((extra['facebook'] ?? '').isNotEmpty) 'FB: ${extra['facebook']}',
              if ((extra['registrationNumber'] ?? '').isNotEmpty) 'Reg No: ${extra['registrationNumber']}',
              if ((extra['gstNumber'] ?? '').isNotEmpty) 'GST: ${extra['gstNumber']}',
            ].where((e) => e.trim().isNotEmpty).join('\n'),
            'yearsInBusiness': extra['yearsInBusiness'] ?? '0',
            'businessExperience': extra['yearsInBusiness'] ?? '0',
            'investmentNeeded': extra['fundingRequirement'] ?? '0',
            'fundingRequirement': extra['fundingRequirement'] ?? '0',
            'expectedMonthlyIncome': extra['expectedMonthlyIncome'] ?? '0',
            'logoPath': (extra['logo'] ?? '').isNotEmpty ? 'mobile:${extra['logo']}' : 'mobile-pending',
            'pitchDeckPath':
                (extra['pitchDeck'] ?? '').isNotEmpty ? 'mobile:${extra['pitchDeck']}' : 'mobile-pending',
            'verificationDocuments':
                (extra['govId'] ?? '').isNotEmpty ? 'mobile:${extra['govId']}' : 'mobile-pending',
            'govId': (extra['govId'] ?? '').isNotEmpty ? 'mobile:${extra['govId']}' : 'mobile-pending',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => const EntrepreneurDashboardScreen(),
    );
  }
}
