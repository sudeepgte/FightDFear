import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/marketplace_provider_auth_service.dart';
import 'women_lawyer_dashboard_screen.dart';
import 'women_lawyer_portal_login_screen.dart';
import 'women_lawyer_profile_completion_screen.dart';

/// Screen displayed when a Women Lawyer profile has been submitted and is pending Admin verification.
/// Matches the verification banner logic from the website (`lawyer/dashboard.jsp`).
class WomenLawyerPendingApprovalScreen extends StatefulWidget {
  const WomenLawyerPendingApprovalScreen({
    super.key,
    this.initialProfile,
  });

  final Map<String, dynamic>? initialProfile;

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color bgPage = Color(0xFFF8FAFC);

  @override
  State<WomenLawyerPendingApprovalScreen> createState() =>
      _WomenLawyerPendingApprovalScreenState();
}

class _WomenLawyerPendingApprovalScreenState
    extends State<WomenLawyerPendingApprovalScreen> {
  late final MarketplaceProviderAuthService _auth;
  bool _checking = false;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    _auth = MarketplaceProviderAuthService(context.read<AuthState>().api);
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

        final status =
            (_profile['partnerProfileStatus'] ?? '').toString().toUpperCase();
        final verificationStatus =
            (_profile['verificationStatus'] ?? '').toString().toUpperCase();
        final isApproved = status == 'APPROVED' || verificationStatus == 'VERIFIED';

        if (isApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! Your advocate profile has been approved!'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const WomenLawyerDashboardScreen(),
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
                  : const Color(0xFF1E1B4B),
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

  Future<void> _editProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WomenLawyerProfileCompletionScreen(
          onFinished: (ctx) {
            Navigator.of(ctx).pop();
            _checkStatus(silent: false);
          },
        ),
      ),
    );
    _checkStatus(silent: true);
  }

  Future<void> _signOut() async {
    await _auth.clearLocalSession();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const WomenLawyerPortalLoginScreen(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile['fullName']?.toString() ?? 'Advocate';
    final designation = _profile['designation']?.toString() ?? 'Advocate';
    final barCouncilId = _profile['barCouncilId']?.toString() ?? 'Pending';
    final address = _profile['address']?.toString() ?? '';
    final city = _profile['city']?.toString() ?? '';
    final state = _profile['state']?.toString() ?? '';
    final fee = _profile['consultationFee']?.toString() ?? '0';
    final status =
        (_profile['partnerProfileStatus'] ?? 'PENDING_ADMIN_APPROVAL')
            .toString()
            .toUpperCase();
    final changesNote = _profile['changesRequestedNote']?.toString() ??
        _profile['rejectionReason']?.toString();

    final isChangesRequested = status == 'CHANGES_REQUESTED';
    final isRejected = status == 'REJECTED';

    return Scaffold(
      backgroundColor: WomenLawyerPendingApprovalScreen.bgPage,
      appBar: AppBar(
        title: const Text(
          'Verification Status',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: WomenLawyerPendingApprovalScreen.navy,
        elevation: 0.5,
        actions: [
          IconButton(
            tooltip: 'Check verification status',
            icon: _checking
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: _checking ? null : () => _checkStatus(silent: false),
          ),
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _signOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _checkStatus(silent: false),
        color: WomenLawyerPendingApprovalScreen.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Status Alert Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isChangesRequested
                    ? const Color(0xFFFFFBEB)
                    : isRejected
                        ? const Color(0xFFFEF2F2)
                        : const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isChangesRequested
                      ? const Color(0xFFFDE68A)
                      : isRejected
                          ? const Color(0xFFFECACA)
                          : const Color(0xFFFED7AA),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isChangesRequested
                              ? const Color(0xFFFEF3C7)
                              : isRejected
                                  ? const Color(0xFFFEE2E2)
                                  : const Color(0xFFFFEDD5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isChangesRequested
                              ? Icons.edit_note_rounded
                              : isRejected
                                  ? Icons.cancel_outlined
                                  : Icons.hourglass_top_rounded,
                          color: isChangesRequested
                              ? const Color(0xFFD97706)
                              : isRejected
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFFEA580C),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isChangesRequested
                                  ? 'Changes Requested by Admin'
                                  : isRejected
                                      ? 'Application Rejected'
                                      : 'Verification in Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isChangesRequested
                                    ? const Color(0xFF92400E)
                                    : isRejected
                                        ? const Color(0xFF991B1B)
                                        : const Color(0xFF9A3412),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isChangesRequested
                                  ? 'Action required on your advocate profile'
                                  : isRejected
                                      ? 'Please review feedback and resubmit'
                                      : 'Estimated review time: 12–24 hours',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isChangesRequested
                                    ? const Color(0xFFB45309)
                                    : isRejected
                                        ? const Color(0xFFB91C1C)
                                        : const Color(0xFFC2410C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isChangesRequested
                        ? 'Admin has reviewed your advocate registration and requested specific updates before granting verified status.'
                        : isRejected
                            ? 'Your advocate application was not approved. You can review the admin feedback below, update your credentials, and resubmit.'
                            : 'Thank you for registering as a Women Lawyer on Fight D Fear. Our team is verifying your Bar Council registration number, identity, and practice credentials.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isChangesRequested
                          ? const Color(0xFF78350F)
                          : isRejected
                              ? const Color(0xFF7F1D1D)
                              : const Color(0xFF7C2D12),
                    ),
                  ),
                  if (changesNote != null && changesNote.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isChangesRequested
                              ? const Color(0xFFFCD34D)
                              : const Color(0xFFFCA5A5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isChangesRequested
                                ? 'Admin Instructions / Note:'
                                : 'Reason for Rejection:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isChangesRequested
                                  ? const Color(0xFF92400E)
                                  : const Color(0xFF991B1B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            changesNote,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Advocate Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x080F172A),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Advocate Profile Summary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: WomenLawyerPendingApprovalScreen.navy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4E6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFECDD3)),
                        ),
                        child: Text(
                          status.replaceAll('_', ' '),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: WomenLawyerPendingApprovalScreen.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _summaryRow(Icons.person_rounded, 'Advocate Name', name),
                  const Divider(height: 20),
                  _summaryRow(Icons.badge_rounded, 'Designation', designation),
                  const Divider(height: 20),
                  _summaryRow(Icons.card_membership_rounded, 'Bar Council ID', barCouncilId),
                  const Divider(height: 20),
                  _summaryRow(
                    Icons.location_on_rounded,
                    'Chamber Location',
                    [address, city, state].where((s) => s.isNotEmpty).join(', '),
                  ),
                  const Divider(height: 20),
                  _summaryRow(
                    Icons.currency_rupee_rounded,
                    'Consultation Fee',
                    fee == '0' ? 'Pro Bono / Free' : '₹$fee per session',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            FilledButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text(
                'Edit Profile & Credentials',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: WomenLawyerPendingApprovalScreen.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _checking ? null : () => _checkStatus(silent: false),
              icon: _checking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Check Approval Status Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: WomenLawyerPendingApprovalScreen.navy,
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: _signOut,
                icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFF64748B)),
                label: const Text(
                  'Sign Out of Lawyer Portal',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '—' : value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
