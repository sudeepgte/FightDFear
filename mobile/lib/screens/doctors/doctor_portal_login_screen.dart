import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import '../../widgets/registration_form_kit.dart';
import 'doctor_dashboard_screen.dart';
import '../portals/portal_auth_screen.dart';

class DoctorPortalLoginScreen extends StatelessWidget {
  const DoctorPortalLoginScreen({super.key, this.startRegister = false});

  final bool startRegister;

  @override
  Widget build(BuildContext context) {
    final api = context.read<AuthState>().api;
    final svc = DoctorAuthService(api);
    return PortalAuthScreen(
      title: 'Women Doctor',
      defaultRegister: startRegister,
      requireEmailOtp: true,
      requirePhoneOtp: true,
      successMessage:
          'Doctor registration submitted successfully. Your profile and medical documents are under verification. You will be notified once your account is approved.',
      registerFields: const [
        RegFieldDef(key: 'sec_profile', label: 'Professional information', type: RegInputType.section),
        RegFieldDef(key: 'fullName', label: 'Full name', required: true),
        RegFieldDef(key: 'phone', label: 'Phone', type: RegInputType.phone, required: true),
        RegFieldDef(key: 'specialization', label: 'Specialization', initial: 'Gynecologist', required: true),
        RegFieldDef(key: 'qualification', label: 'Qualification', initial: 'MBBS', required: true),
        RegFieldDef(key: 'medicalRegNumber', label: 'Medical registration number', required: true),
        RegFieldDef(
          key: 'medicalCouncil',
          label: 'Medical council',
          type: RegInputType.dropdown,
          options: RegOptions.medicalCouncils,
          required: true,
        ),
        RegFieldDef(
          key: 'consultationModes',
          label: 'Consultation mode',
          type: RegInputType.chips,
          options: RegOptions.consultationModes,
          required: true,
        ),
        RegFieldDef(
          key: 'languages',
          label: 'Languages spoken',
          type: RegInputType.chips,
          options: RegOptions.doctorLanguages,
          required: true,
        ),
        RegFieldDef(
          key: 'hospitalName',
          label: 'Hospital / clinic affiliation',
          hint: 'Add multiple hospitals separated by commas',
          required: true,
        ),
        RegFieldDef(
          key: 'specialServices',
          label: 'Special services',
          type: RegInputType.chips,
          options: RegOptions.doctorSpecialServices,
        ),
        RegFieldDef(
          key: 'bio',
          label: 'Profile bio (optional)',
          type: RegInputType.multiline,
          maxLines: 3,
          maxLength: 400,
        ),
        RegFieldDef(key: 'experienceYears', label: 'Years of experience', type: RegInputType.number, required: true),
        RegFieldDef(
          key: 'consultationFee',
          label: 'Consultation fee (₹)',
          type: RegInputType.number,
          initial: '500',
          required: true,
        ),
        RegFieldDef(
          key: 'gender',
          label: 'Gender',
          type: RegInputType.dropdown,
          options: ['Female', 'Male', 'Other'],
          initial: 'Female',
        ),
        RegFieldDef(key: 'sec_location', label: 'Clinic location', type: RegInputType.section),
        RegFieldDef(key: 'clinicAddress', label: 'Clinic address', type: RegInputType.multiline, required: true),
        RegFieldDef(key: 'city', label: 'City', required: true),
        RegFieldDef(
          key: 'googleMapLocation',
          label: 'Google Maps location / link',
          hint: 'Paste Maps link or area landmark',
          required: true,
        ),
        RegFieldDef(key: 'sec_avail', label: 'Availability', type: RegInputType.section),
        RegFieldDef(
          key: 'workingDays',
          label: 'Working days',
          type: RegInputType.chips,
          options: RegOptions.doctorWorkingDays,
          required: true,
        ),
        RegFieldDef(
          key: 'timeSlots',
          label: 'Available time ranges',
          type: RegInputType.chips,
          options: RegOptions.doctorAvailability,
          required: true,
        ),
        RegFieldDef(key: 'sec_docs', label: 'Documents', type: RegInputType.section),
        RegFieldDef(key: 'photo', label: 'Profile photo', type: RegInputType.file),
        RegFieldDef(
          key: 'certificates',
          label: 'Medical certificates / licenses',
          type: RegInputType.multiFile,
          required: true,
          hint: 'Upload one or more JPG/PNG/PDF certificates',
        ),
        RegFieldDef(key: 'idProof', label: 'Government ID proof', type: RegInputType.file, required: true),
      ],
      onSubmit: ({required register, required email, required password, required extra}) {
        if (register) {
          final modes = extra['consultationModes'] ?? '';
          String consultationType = 'CLINIC';
          if (modes.contains('Online') && modes.contains('In Clinic')) {
            consultationType = 'BOTH';
          } else if (modes.contains('Online')) {
            consultationType = 'ONLINE';
          } else if (modes.contains('Home Visit')) {
            consultationType = 'OFFLINE';
          }

          final slots = extra['timeSlots'] ?? '';
          String startTime = '09:00';
          String endTime = '17:00';
          if (slots.contains('9:00 AM')) startTime = '09:00';
          if (slots.contains('8:00 PM')) {
            endTime = '20:00';
          } else if (slots.contains('5:00 PM')) {
            endTime = '17:00';
          } else if (slots.contains('1:00 PM')) {
            endTime = '13:00';
          }

          return svc.register({
            'fullName': extra['fullName'] ?? '',
            'email': email,
            'phone': extra['phone'] ?? '',
            'password': password,
            'confirmPassword': extra['confirmPassword'] ?? password,
            'specialization': extra['specialization'] ?? '',
            'qualification': extra['qualification'] ?? '',
            'city': extra['city'] ?? '',
            'consultationFee': extra['consultationFee'] ?? '500',
            'medicalRegNumber': extra['medicalRegNumber'] ?? '',
            'medicalCouncil': extra['medicalCouncil'] ?? '',
            'hospitalName': extra['hospitalName'] ?? '',
            'clinicAddress': extra['clinicAddress'] ?? '',
            'googleMapLocation': extra['googleMapLocation'] ?? '',
            'experienceYears': extra['experienceYears'] ?? '',
            'gender': (extra['gender'] ?? 'Female').toUpperCase(),
            'consultationType': consultationType,
            'consultationModes': modes,
            'languages': extra['languages'] ?? '',
            'specialServices': extra['specialServices'] ?? '',
            'bio': extra['bio'] ?? '',
            'availableDays': extra['workingDays'] ?? '',
            'timeSlots': slots,
            'startTime': startTime,
            'endTime': endTime,
            'locationText': [
              extra['hospitalName'] ?? '',
              extra['clinicAddress'] ?? '',
              extra['googleMapLocation'] ?? '',
              if ((extra['languages'] ?? '').isNotEmpty) 'Languages: ${extra['languages']}',
              if ((extra['specialServices'] ?? '').isNotEmpty) 'Services: ${extra['specialServices']}',
              if ((extra['bio'] ?? '').isNotEmpty) 'Bio: ${extra['bio']}',
              if ((extra['medicalCouncil'] ?? '').isNotEmpty) 'Council: ${extra['medicalCouncil']}',
              if (modes.isNotEmpty) 'Modes: $modes',
            ].where((e) => e.trim().isNotEmpty).join('\n'),
            'profilePhotoPath': extra['photo'] ?? 'mobile-pending',
            'identityDocumentPath': extra['idProof'] ?? 'mobile-pending',
            'medicalLicensePath': extra['certificates'] ?? 'mobile-pending',
            'degreeCertificatePath': extra['certificates'] ?? 'mobile-pending',
          });
        }
        return svc.login(email: email, password: password);
      },
      dashboardBuilder: (_) => const DoctorDashboardScreen(),
    );
  }
}
