import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/investor_auth_service.dart';
import '../widgets/registration_form_kit.dart';
import 'investor_dashboard_screen.dart';
import 'portal_auth_screen.dart';

class InvestorPortalLoginScreen extends StatelessWidget {
  const InvestorPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = InvestorAuthService(api);
    return PortalAuthScreen(
      title: 'Investor',
      defaultRegister: startRegister,
      requireEmailOtp: true,
      requirePhoneOtp: true,
      loginSubtitle: 'Sign in to browse startups and manage your portfolio',
      loginIcon: Icons.trending_up_rounded,
      successMessage:
          'Investor registration submitted successfully. Your account is under verification and will be activated after admin approval at Investment Platform.',
      registerFields: const [
        RegFieldDef(key: 'sec_profile', label: 'Investor profile', type: RegInputType.section),
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
        RegFieldDef(
          key: 'investorType',
          label: 'Investor type',
          type: RegInputType.dropdown,
          options: RegOptions.investorTypes,
          required: true,
        ),
        RegFieldDef(key: 'companyName', label: 'Company / investment firm name', required: true),
        RegFieldDef(key: 'designation', label: 'Designation'),
        RegFieldDef(key: 'city', label: 'City', required: true),
        RegFieldDef(key: 'country', label: 'Country', initial: 'India', required: true),
        RegFieldDef(key: 'linkedin', label: 'LinkedIn profile'),
        RegFieldDef(key: 'website', label: 'Website (optional)'),
        RegFieldDef(
          key: 'investmentInterests',
          label: 'Investment interests',
          type: RegInputType.chips,
          options: RegOptions.investmentInterests,
          required: true,
        ),
        RegFieldDef(
          key: 'budgetRange',
          label: 'Investment range',
          type: RegInputType.dropdown,
          options: RegOptions.investmentRanges,
          required: true,
        ),
        RegFieldDef(key: 'yearsExperience', label: 'Years of investment experience', type: RegInputType.number),
        RegFieldDef(
          key: 'bio',
          label: 'Bio / about investor',
          type: RegInputType.multiline,
          maxLines: 4,
          maxLength: 500,
        ),
        RegFieldDef(key: 'sec_docs', label: 'Verification documents', type: RegInputType.section),
        RegFieldDef(key: 'photo', label: 'Profile photo', type: RegInputType.file),
        RegFieldDef(key: 'govId', label: 'Government ID / business verification', type: RegInputType.file, required: true),
      ],
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          final interests = (extra['investmentInterests'] ?? '').trim();
          return svc.register({
            'fullName': extra['fullName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'companyName': extra['companyName'] ?? '',
            'investmentInterests': [
              if ((extra['investorType'] ?? '').isNotEmpty) 'Type: ${extra['investorType']}',
              if ((extra['designation'] ?? '').isNotEmpty) 'Designation: ${extra['designation']}',
              if (interests.isNotEmpty) interests,
              if ((extra['bio'] ?? '').isNotEmpty) 'Bio: ${extra['bio']}',
              if ((extra['linkedin'] ?? '').isNotEmpty) 'LinkedIn: ${extra['linkedin']}',
              if ((extra['website'] ?? '').isNotEmpty) 'Web: ${extra['website']}',
              if ((extra['yearsExperience'] ?? '').isNotEmpty) 'Experience: ${extra['yearsExperience']} yrs',
            ].where((e) => e.trim().isNotEmpty).join(' | '),
            'budgetRange': extra['budgetRange'] ?? '',
            'preferredLocations': '${extra['city'] ?? ''}, ${extra['country'] ?? 'India'}',
            'preferredCategories': interests,
            'photoPath': (extra['photo'] ?? '').isNotEmpty ? 'mobile:${extra['photo']}' : 'mobile-pending',
            'verificationDocuments':
                (extra['govId'] ?? '').isNotEmpty ? 'mobile:${extra['govId']}' : 'mobile-pending',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => const InvestorDashboardScreen(),
    );
  }
}
