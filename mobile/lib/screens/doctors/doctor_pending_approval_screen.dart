import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/doctor_auth_service.dart';
import 'doctor_dashboard_screen.dart';
import 'doctor_portal_login_screen.dart';
import 'doctor_profile_completion_screen.dart';

/// Screen displayed when a Women Doctor profile has been submitted and is pending Admin approval.
/// Matches the verification banner logic from the website (`doctorDashboard.jsp`).
class DoctorPendingApprovalScreen extends StatefulWidget {
  const DoctorPendingApprovalScreen({
    super.key,
    this.initialProfile,
  });

  final Map<String, dynamic>? initialProfile;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF0F172A);

  @override
  State<DoctorPendingApprovalScreen> createState() =>
      _DoctorPendingApprovalScreenState();
}

class _DoctorPendingApprovalScreenState
    extends State<DoctorPendingApprovalScreen> {
  late final DoctorAuthService _auth;
  bool _checking = false;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    _auth = DoctorAuthService(context.read<AuthState>().api);
    if (widget.initialProfile != null) {
      _profile = Map<String, dynamic>.from(widget.initialProfile!);
    }
    _checkStatus(silent: true);
  }

  Future<void> _checkStatus({bool silent = false}) async {
    if (!silent) setState(() => _checking = true);
    try {
      final res = await _auth.profile();
      if (!mounted) return;
      if (res['success'] == true) {
        final profileData = res['profile'] is Map
            ? Map<String, dynamic>.from(res['profile'] as Map)
            : Map<String, dynamic>.from(res);
        setState(() => _profile = profileData);

        final status = (_profile['doctorProfileStatus'] ?? '').toString().toUpperCase();
        final verificationStatus = (_profile['verificationStatus'] ?? '').toString().toUpperCase();
        final isApproved = status == 'APPROVED' || verificationStatus == 'VERIFIED';

        if (isApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! Your doctor profile has been approved!'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const DoctorDashboardScreen(),
            ),
          );
          return;
        } else if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == 'CHANGES_REQUESTED'
                    ? 'Admin requested changes to your profile. Please update.'
                    : 'Profile is still under review. Verification usually takes 12–24 hours.',
              ),
              backgroundColor: status == 'CHANGES_REQUESTED'
                  ? const Color(0xFFEA580C)
                  : const Color(0xFF0F172A),
            ),
          );
        }
      }
    } catch (_) {
      // Ignored on silent check
    } finally {
      if (mounted && !silent) setState(() => _checking = false);
    }
  }

  Future<void> _logout() async {
    await _auth.logout();
    await _auth.clearLocalSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DoctorPortalLoginScreen()),
      (_) => false,
    );
  }

  void _openEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorProfileCompletionScreen(
          onFinished: (ctx) {
            Navigator.of(ctx).pop();
            _checkStatus(silent: false);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = (_profile['doctorProfileStatus'] ?? 'PENDING_ADMIN_APPROVAL')
        .toString()
        .toUpperCase();
    final name = _profile['fullName']?.toString() ?? 'Doctor';
    final displayName = name.startsWith('Dr') ? name : 'Dr. $name';
    final specialization = _profile['specialization']?.toString() ?? 'Specialization not set';
    final qualification = _profile['qualification']?.toString() ?? '';
    final medicalReg = _profile['medicalRegNumber']?.toString() ?? 'Not provided';
    final hospital = _profile['hospitalName']?.toString() ?? 'Clinic not set';
    final email = _profile['email']?.toString() ?? '';
    final phone = _profile['phone']?.toString() ?? '';
    final city = _profile['city']?.toString() ?? '';
    final state = _profile['state']?.toString() ?? '';
    final location = [city, state].where((s) => s.isNotEmpty).join(', ');
    final pct = _profile['profileCompletionPct'] ?? 100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Verification Pending'),
        backgroundColor: Colors.white,
        foregroundColor: DoctorPendingApprovalScreen.navy,
        elevation: 0,
        actions: [
          IconButton(
            icon: _checking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Check Status',
            onPressed: _checking ? null : () => _checkStatus(silent: false),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner matching website doctorDashboard.jsp
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(16),
                border: const Border(
                  left: BorderSide(color: Color(0xFFF59E0B), width: 6),
                  top: BorderSide(color: Color(0xFFFDE68A)),
                  right: BorderSide(color: Color(0xFFFDE68A)),
                  bottom: BorderSide(color: Color(0xFFFDE68A)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          color: Color(0xFFD97706),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Verification in Progress',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDE68A),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your profile and medical credentials have been submitted and are currently awaiting review by the admin team. Clinical services, appointments, chats, and schedule configuration will unlock once your account is verified.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF78350F),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Summary Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFFFE4E6),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          color: DoctorPendingApprovalScreen.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialization,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$pct% Done',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  _detailRow('Medical Reg No', medicalReg, icon: Icons.badge_outlined),
                  if (qualification.isNotEmpty)
                    _detailRow('Qualification', qualification, icon: Icons.school_outlined),
                  _detailRow('Hospital / Clinic', hospital, icon: Icons.local_hospital_outlined),
                  if (location.isNotEmpty)
                    _detailRow('Location', location, icon: Icons.location_on_outlined),
                  if (email.isNotEmpty)
                    _detailRow('Email', email, icon: Icons.email_outlined),
                  if (phone.isNotEmpty)
                    _detailRow('Phone', phone, icon: Icons.phone_outlined),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // What happens next card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What happens next?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _stepItem(
                    step: '1',
                    title: 'Admin Medical Credential Verification',
                    description: 'Our team verifies your medical council registration and degree certificates.',
                  ),
                  const SizedBox(height: 12),
                  _stepItem(
                    step: '2',
                    title: 'Account Approval Notification',
                    description: 'You will receive an email and in-app update once approved.',
                  ),
                  const SizedBox(height: 12),
                  _stepItem(
                    step: '3',
                    title: 'Patient Consultations Go Live',
                    description: 'Your clinic will be featured in the doctor catalog for appointments and video consults.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            ElevatedButton.icon(
              onPressed: _checking ? null : () => _checkStatus(silent: false),
              icon: _checking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_checking ? 'Checking Status...' : 'Check Verification Status'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DoctorPendingApprovalScreen.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _openEditProfile,
              icon: const Icon(Icons.edit_note_outlined),
              label: const Text('Review or Edit Profile'),
              style: OutlinedButton.styleFrom(
                foregroundColor: DoctorPendingApprovalScreen.primary,
                side: const BorderSide(color: DoctorPendingApprovalScreen.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepItem({
    required String step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE4E6),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DoctorPendingApprovalScreen.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
