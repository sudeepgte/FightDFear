import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

void main() {
  group('Phase 4: Approval Navigation & Location Tests', () {
    test('ApprovalNavigation redirects incomplete, unapproved partners', () {
      final res = {
        'success': true,
        'needsProfileCompletion': true,
        'status': 'PROFILE_INCOMPLETE',
        'partnerProfileStatus': 'PROFILE_INCOMPLETE',
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(res), isTrue);
    });

    test('ApprovalNavigation directs APPROVED partners straight to dashboard', () {
      final resApprovedStatus = {
        'success': true,
        'needsProfileCompletion': true, // Even if flag was stale
        'status': 'APPROVED',
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(resApprovedStatus), isFalse);

      final resApprovedPartnerStatus = {
        'success': true,
        'needsProfileCompletion': true,
        'partnerProfileStatus': 'APPROVED',
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(resApprovedPartnerStatus), isFalse);

      final resVerified = {
        'success': true,
        'needsProfileCompletion': true,
        'verificationStatus': 'VERIFIED',
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(resVerified), isFalse);

      final resApprovedFlag = {
        'success': true,
        'needsProfileCompletion': true,
        'approved': true,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(resApprovedFlag), isFalse);
    });

    test('ApprovalNavigation directs already-completed partners to dashboard', () {
      final resCompleted = {
        'success': true,
        'needsProfileCompletion': false,
        'status': 'PENDING_ADMIN_APPROVAL',
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(resCompleted), isFalse);
    });
  });
}
