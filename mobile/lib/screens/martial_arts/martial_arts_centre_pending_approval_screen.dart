import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/centre_auth_service.dart';
import 'martial_arts_centre_dashboard_screen.dart';
import 'martial_arts_centre_login_screen.dart';
import 'martial_arts_centre_profile_completion_screen.dart';

/// Screen displayed when a Martial Arts Centre profile has been submitted and is pending Admin approval.
/// Matches the verification banner logic from the website (`centreDashboard.jsp`).
class MartialArtsCentrePendingApprovalScreen extends StatefulWidget {
  const MartialArtsCentrePendingApprovalScreen({
    super.key,
    this.initialProfile,
  });

  final Map<String, dynamic>? initialProfile;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  @override
  State<MartialArtsCentrePendingApprovalScreen> createState() =>
      _MartialArtsCentrePendingApprovalScreenState();
}

class _MartialArtsCentrePendingApprovalScreenState
    extends State<MartialArtsCentrePendingApprovalScreen> {
  late final CentreAuthService _auth;
  bool _checking = false;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    _auth = CentreAuthService(context.read<AuthState>().api);
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
        setState(() => _profile = Map<String, dynamic>.from(res));
        final status = (_profile['centreProfileStatus'] ?? '').toString().toUpperCase();
        final isApproved = _profile['approved'] == true || status == 'APPROVED';
        if (isApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! Your centre has been approved!'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MartialArtsCentreDashboardScreen(),
            ),
          );
          return;
        } else if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == 'CHANGES_REQUESTED'
                    ? 'Admin requested changes to your profile. Please update.'
                    : 'Profile is still under review. Review usually takes 12–24 hours.',
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

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MartialArtsCentreLoginScreen()),
      (_) => false,
    );
  }

  void _openEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MartialArtsCentreProfileCompletionScreen(
          onFinished: (_) => _checkStatus(silent: true),
        ),
      ),
    );
  }

  void _openRestrictedHub() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MartialArtsCentreDashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile['name']?.toString() ?? 'Self-Defence Centre';
    final contact = _profile['contactPerson']?.toString() ?? '';
    final phone = _profile['phoneNumber']?.toString() ?? '';
    final city = _profile['city']?.toString() ?? '';
    final state = _profile['state']?.toString() ?? '';
    final pct = _profile['profileCompletionPct']?.toString() ?? '100';
    final status = (_profile['centreProfileStatus'] ?? 'PENDING_ADMIN_APPROVAL').toString();
    final changesNote = _profile['changesRequestedNote']?.toString();
    final rejectionReason = _profile['rejectionReason']?.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: MartialArtsCentrePendingApprovalScreen.navy,
        title: const Text(
          'Verification Status',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner Card matching website centreDashboard.jsp lines 1765-1794
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14D97706),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile Submitted',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB45309),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Wait for Admin Verification',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF78350F),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF08A),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFFACC15)),
                                  ),
                                  child: Text(
                                    status.replaceAll('_', ' '),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF854D0E),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFFCA5A5)),
                                  ),
                                  child: const Text(
                                    'Features Locked',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF991B1B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFFDE68A), height: 1),
                  const SizedBox(height: 14),
                  const Text(
                    'Your centre profile is currently under review by our administration team. Review usually takes 12–24 hours.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'While under review, your centre remains in restricted mode. Public search discovery and new batch creation are locked until your credentials are confirmed.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ),
            ),

            if (changesNote != null && changesNote.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C)),
                        SizedBox(width: 8),
                        Text(
                          'Changes Requested by Admin',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF9A3412)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      changesNote,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF7C2D12)),
                    ),
                  ],
                ),
              ),
            ],

            if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                        SizedBox(width: 8),
                        Text(
                          'Profile Needs Correction',
                          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF991B1B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      rejectionReason,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF7F1D1D)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Profile Summary Details Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Submitted Profile Details',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: MartialArtsCentrePendingApprovalScreen.navy,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _detailRow(Icons.business_outlined, 'Centre Name', name),
                  if (contact.isNotEmpty) _detailRow(Icons.person_outline, 'Contact Person', contact),
                  if (phone.isNotEmpty) _detailRow(Icons.phone_outlined, 'Phone', phone),
                  if (city.isNotEmpty || state.isNotEmpty)
                    _detailRow(
                      Icons.location_on_outlined,
                      'Location',
                      [city, state].where((s) => s.isNotEmpty).join(', '),
                    ),
                  _detailRow(
                    Icons.check_circle_outline,
                    'Completion',
                    '$pct% Completed',
                    color: const Color(0xFF16A34A),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Primary Check Status Button
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: MartialArtsCentrePendingApprovalScreen.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _checking ? null : () => _checkStatus(silent: false),
              icon: _checking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.refresh_rounded),
              label: Text(
                _checking ? 'Checking Status…' : 'Check Verification Status',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 12),

            // View / Edit Submitted Profile
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: MartialArtsCentrePendingApprovalScreen.navy,
                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _openEditProfile,
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text(
                'View / Edit Submitted Profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 12),

            // Open Restricted Hub
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF64748B),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _openRestrictedHub,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Open Centre Hub (Restricted Mode)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color ?? const Color(0xFF1E293B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
