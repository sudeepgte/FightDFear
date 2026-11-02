import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import 'women_products_seller_dashboard_screen.dart';
import 'women_products_seller_login_screen.dart';
import 'women_products_seller_profile_completion_screen.dart';

/// Screen displayed when a Women Products Seller profile has been submitted and is pending Admin approval.
/// Matches the verification banner logic from the website (`seller-dashboard.jsp`).
class WomenProductsSellerPendingApprovalScreen extends StatefulWidget {
  const WomenProductsSellerPendingApprovalScreen({
    super.key,
    this.initialProfile,
  });

  final Map<String, dynamic>? initialProfile;

  static const Color primary = Color(0xFFF43F5E);
  static const Color primaryHover = Color(0xFFE11D48);
  static const Color navy = Color(0xFF0F172A);
  static const Color bgPage = Color(0xFFF8FAFC);

  @override
  State<WomenProductsSellerPendingApprovalScreen> createState() =>
      _WomenProductsSellerPendingApprovalScreenState();
}

class _WomenProductsSellerPendingApprovalScreenState
    extends State<WomenProductsSellerPendingApprovalScreen> {
  late final WomenProductsSellerAuthService _auth;
  bool _checking = false;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    _auth = WomenProductsSellerAuthService(context.read<AuthState>().api);
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

        final status = (_profile['partnerProfileStatus'] ?? '').toString().toUpperCase();
        final verificationStatus = (_profile['verificationStatus'] ?? '').toString().toUpperCase();
        final isApproved = status == 'APPROVED' || verificationStatus == 'VERIFIED' || _profile['canListProducts'] == true;

        if (isApproved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! Your seller store has been approved!'),
              backgroundColor: Color(0xFF16A34A),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const WomenProductsSellerDashboardScreen(),
            ),
          );
          return;
        } else if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == 'CHANGES_REQUESTED'
                    ? 'Admin requested changes to your profile. Please update.'
                    : 'Shop is still under review. Verification usually takes 12–24 hours.',
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
      MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen()),
      (_) => false,
    );
  }

  void _openEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WomenProductsSellerProfileCompletionScreen(
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
    final status = (_profile['partnerProfileStatus'] ?? 'PENDING_ADMIN_APPROVAL')
        .toString()
        .toUpperCase();
    final changesNote = _profile['changesRequestedNote']?.toString();
    final rejectionReason = _profile['rejectionReason']?.toString();
    final businessName = _profile['businessName']?.toString() ?? 'Women Artisan Store';
    final fullName = _profile['fullName']?.toString() ?? 'Store Founder';
    final phone = _profile['phone']?.toString() ?? '';
    final email = _profile['email']?.toString() ?? '';
    final city = _profile['city']?.toString() ?? '';
    final state = _profile['state']?.toString() ?? '';
    final address = _profile['address']?.toString() ?? '';
    final category = _profile['category']?.toString() ??
        _profile['primaryCategory']?.toString() ??
        'General Goods';
    final brandType = _profile['brandType']?.toString() ?? 'Artisan Boutique';
    final completionPct = _profile['profileCompletionPct']?.toString() ?? '100';
    final hoursFrom = _profile['workingHoursFrom']?.toString() ??
        _profile['openTime']?.toString() ??
        '09:30';
    final hoursTo = _profile['workingHoursTo']?.toString() ??
        _profile['closeTime']?.toString() ??
        '20:00';
    final days = _profile['availableDays']?.toString() ??
        _profile['openDays']?.toString() ??
        'Mon–Sat';

    return Scaffold(
      backgroundColor: WomenProductsSellerPendingApprovalScreen.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        foregroundColor: WomenProductsSellerPendingApprovalScreen.navy,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: WomenProductsSellerPendingApprovalScreen.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Store Verification',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _checkStatus(silent: false),
        color: WomenProductsSellerPendingApprovalScreen.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Changes Requested Banner
              if (changesNote != null && changesNote.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFEF3C7), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0DB45309),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFB45309),
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Action Required: Changes Requested',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              changesNote,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF92400E),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: _openEditProfile,
                              child: const Text(
                                'Update Profile Now →',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: Color(0xFFB45309),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Rejection Banner
              if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0DB91C1C),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFB91C1C),
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Application Needs Revision',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Color(0xFFB91C1C),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rejectionReason,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF991B1B),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: _openEditProfile,
                              child: const Text(
                                'Revise Profile Details →',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: Color(0xFFB91C1C),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Status Banner Card matching website seller-dashboard.jsp
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
                                'Store Profile Submitted',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFB45309),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Under Admin Review',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF78350F),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD97706).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Profile $completionPct% Complete',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFB45309),
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
                      'Your seller registration has been submitted and is currently being verified by the Fight D Fear administration team. Product catalog and live sales will activate as soon as your shop credentials are verified.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF92400E),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Color(0xFFB45309),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Estimated turnaround: 12–24 business hours',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Store Summary Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Storefront Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: WomenProductsSellerPendingApprovalScreen.navy,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _openEditProfile,
                          icon: const Icon(Icons.edit_rounded, size: 16),
                          label: const Text('Edit Details'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                WomenProductsSellerPendingApprovalScreen.primary,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20, color: Color(0xFFF1F5F9)),
                    _infoRow(
                      icon: Icons.storefront_rounded,
                      label: 'Business / Shop Name',
                      value: businessName,
                    ),
                    _infoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Founder / Contact',
                      value: fullName,
                    ),
                    _infoRow(
                      icon: Icons.phone_outlined,
                      label: 'Official Phone',
                      value: phone.isNotEmpty ? phone : 'Not provided',
                    ),
                    if (email.isNotEmpty)
                      _infoRow(
                        icon: Icons.email_outlined,
                        label: 'Official Email',
                        value: email,
                      ),
                    _infoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Store Location',
                      value: [
                        if (address.isNotEmpty) address,
                        if (city.isNotEmpty) city,
                        if (state.isNotEmpty) state,
                      ].join(', ').isNotEmpty
                          ? [
                              if (address.isNotEmpty) address,
                              if (city.isNotEmpty) city,
                              if (state.isNotEmpty) state,
                            ].join(', ')
                          : 'Location pending',
                    ),
                    _infoRow(
                      icon: Icons.category_outlined,
                      label: 'Primary Category',
                      value: category,
                    ),
                    _infoRow(
                      icon: Icons.verified_outlined,
                      label: 'Brand Type',
                      value: brandType,
                    ),
                    _infoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Operating Hours',
                      value: '$days: $hoursFrom – $hoursTo',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              ElevatedButton.icon(
                onPressed: _checking ? null : () => _checkStatus(silent: false),
                icon: _checking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  _checking ? 'Checking Status…' : 'Check Verification Status',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: WomenProductsSellerPendingApprovalScreen.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _openEditProfile,
                icon: const Icon(Icons.edit_note_rounded, size: 20),
                label: const Text(
                  'Review & Edit Shop Profile',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: WomenProductsSellerPendingApprovalScreen.navy,
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFDC2626)),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFFDC2626),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WomenProductsSellerPendingApprovalScreen.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
