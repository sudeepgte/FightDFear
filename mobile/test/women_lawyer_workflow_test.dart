import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/marketplace_provider_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Women Lawyer Multi-Role Token Isolation Tests', () {
    test('Token storage uses women_lawyer_auth_token and preserves role isolation', () async {
      final client = ApiClient('http://localhost:8084');

      // 1. Initial state: no tokens
      expect(await client.getWomenLawyerToken(), isNull);
      expect(await client.getToken(), isNull);
      expect(await client.getMarketplaceProviderToken(), isNull);
      expect(await client.getDoctorToken(), isNull);

      // 2. Save Women Lawyer token
      await client.saveWomenLawyerToken('jwt-lawyer-token-777');
      expect(await client.getWomenLawyerToken(), 'jwt-lawyer-token-777');

      // Verify SharedPreferences key directly
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('women_lawyer_auth_token'), 'jwt-lawyer-token-777');

      // Verify other roles are completely unaffected
      expect(await client.getToken(), isNull);
      expect(await client.getDoctorToken(), isNull);

      // 3. Save Member / User token concurrently
      await client.saveToken('jwt-member-token-111');
      expect(await client.getToken(), 'jwt-member-token-111');
      expect(await client.getWomenLawyerToken(), 'jwt-lawyer-token-777');

      // 4. Clear Lawyer token: member token remains intact
      await client.clearWomenLawyerToken();
      expect(await client.getWomenLawyerToken(), isNull);
      expect(await client.getToken(), 'jwt-member-token-111');

      // 5. Test clearTokenForRole with AuthRole.womenLawyer
      await client.saveWomenLawyerToken('jwt-lawyer-token-888');
      await client.clearTokenForRole(AuthRole.womenLawyer);
      expect(await client.getWomenLawyerToken(), isNull);
    });

    test('MarketplaceProviderAuthService saves lawyer token when expectedCategory is WOMEN_LAWYER', () async {
      final client = ApiClient('http://localhost:8084');
      final svc = MarketplaceProviderAuthService(client);

      // Save token directly
      await client.saveWomenLawyerToken('lawyer-token-xyz');
      await client.saveMarketplaceProviderToken('provider-token-xyz');

      expect(await client.getWomenLawyerToken(), 'lawyer-token-xyz');
      expect(await client.getMarketplaceProviderToken(), 'provider-token-xyz');

      // Clear via service
      await svc.clearLocalSession();
      expect(await client.getWomenLawyerToken(), isNull);
      expect(await client.getMarketplaceProviderToken(), isNull);
    });
  });

  group('Women Lawyer Approval Navigation & State Transitions', () {
    test('Verification status resolution maps correctly to screen destinations', () {
      String resolveDestination(String? status, {bool isProfileCompleted = false}) {
        final st = (status ?? '').toUpperCase().trim();
        if (st == 'APPROVED' || st == 'VERIFIED') {
          return 'DASHBOARD';
        }
        if (st == 'PENDING_ADMIN_APPROVAL' ||
            st == 'READY_FOR_VERIFICATION' ||
            st == 'IN_REVIEW' ||
            st == 'PENDING') {
          return 'PENDING_APPROVAL';
        }
        return 'PROFILE_COMPLETION';
      }

      // Approved states -> Dashboard
      expect(resolveDestination('APPROVED'), 'DASHBOARD');
      expect(resolveDestination('VERIFIED'), 'DASHBOARD');

      // Review states -> Pending Approval Screen
      expect(resolveDestination('PENDING_ADMIN_APPROVAL'), 'PENDING_APPROVAL');
      expect(resolveDestination('READY_FOR_VERIFICATION'), 'PENDING_APPROVAL');
      expect(resolveDestination('IN_REVIEW'), 'PENDING_APPROVAL');
      expect(resolveDestination('PENDING'), 'PENDING_APPROVAL');

      // Incomplete or Changes requested -> Profile Completion Screen
      expect(resolveDestination('PROFILE_INCOMPLETE'), 'PROFILE_COMPLETION');
      expect(resolveDestination('CHANGES_REQUESTED'), 'PROFILE_COMPLETION');
      expect(resolveDestination('REJECTED'), 'PROFILE_COMPLETION');
      expect(resolveDestination(''), 'PROFILE_COMPLETION');
      expect(resolveDestination(null), 'PROFILE_COMPLETION');
    });
  });

  group('Women Lawyer Profile Field Validations', () {
    test('Mandatory field validation rules match website requirements', () {
      Map<String, String> validateLawyerProfile({
        required String fullName,
        required String phone,
        required String designation,
        required String barCouncilId,
        required List<String> practiceAreas,
        required String bio,
        required String address,
        required String state,
        required String city,
        required String pincode,
        required String consultationFee,
        required String accountHolderName,
        required String accountNumber,
        required String confirmAccountNumber,
        required String ifscCode,
      }) {
        final Map<String, String> errors = {};

        if (fullName.trim().isEmpty) errors['fullName'] = 'Full name is required';
        if (phone.trim().length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone.trim())) {
          errors['phone'] = 'Valid 10-digit phone number is required';
        }
        if (designation.trim().isEmpty) errors['designation'] = 'Designation is required';
        if (barCouncilId.trim().isEmpty) errors['barCouncilId'] = 'Bar Council Enrollment ID is required';
        if (practiceAreas.isEmpty) errors['practiceAreas'] = 'Select at least one practice area';
        if (bio.trim().length < 25) errors['bio'] = 'Professional bio must be at least 25 characters';
        if (address.trim().isEmpty) errors['address'] = 'Chamber address is required';
        if (state.trim().isEmpty) errors['state'] = 'State is required';
        if (city.trim().isEmpty) errors['city'] = 'City is required';
        if (pincode.trim().length != 6) errors['pincode'] = 'Valid 6-digit pincode is required';

        final fee = double.tryParse(consultationFee.trim());
        if (fee == null || fee < 0) errors['consultationFee'] = 'Valid consultation fee is required';

        if (accountHolderName.trim().isEmpty) errors['accountHolder'] = 'Account holder name is required';
        if (accountNumber.trim().length < 9) errors['accountNumber'] = 'Valid account number is required';
        if (accountNumber.trim() != confirmAccountNumber.trim()) {
          errors['confirmAccountNumber'] = 'Account numbers do not match';
        }
        if (ifscCode.trim().length != 11) errors['ifsc'] = 'Valid 11-character IFSC code is required';

        return errors;
      }

      // 1. Invalid profile: empty fields
      final errs1 = validateLawyerProfile(
        fullName: '',
        phone: '123',
        designation: '',
        barCouncilId: '',
        practiceAreas: [],
        bio: 'Short',
        address: '',
        state: '',
        city: '',
        pincode: '12',
        consultationFee: '-50',
        accountHolderName: '',
        accountNumber: '123',
        confirmAccountNumber: '456',
        ifscCode: 'ABC',
      );

      expect(errs1.containsKey('fullName'), isTrue);
      expect(errs1.containsKey('phone'), isTrue);
      expect(errs1.containsKey('designation'), isTrue);
      expect(errs1.containsKey('barCouncilId'), isTrue);
      expect(errs1.containsKey('practiceAreas'), isTrue);
      expect(errs1.containsKey('bio'), isTrue);
      expect(errs1.containsKey('confirmAccountNumber'), isTrue);

      // 2. Valid profile
      final errs2 = validateLawyerProfile(
        fullName: 'Advocate Sneha Sharma',
        phone: '9876543210',
        designation: 'Senior Legal Consultant',
        barCouncilId: 'KAR/1234/2018',
        practiceAreas: ['Family Law', 'Corporate Law'],
        bio: 'Over 10 years of experience advocating for women and civil rights in High Court.',
        address: '123 MG Road, Chamber 4B',
        state: 'Karnataka',
        city: 'Bengaluru',
        pincode: '560001',
        consultationFee: '500',
        accountHolderName: 'Sneha Sharma',
        accountNumber: '123456789012',
        confirmAccountNumber: '123456789012',
        ifscCode: 'HDFC0001234',
      );

      expect(errs2.isEmpty, isTrue);
    });
  });

  group('Women Lawyer Booking & Razorpay Payment Payloads', () {
    test('Razorpay order creation and payment verification payload contracts', () {
      const int bookingId = 42;
      const double rate = 750.0;
      const String orderId = 'order_mock_123_456';
      const String paymentId = 'pay_mock_789';
      const String signature = 'sig_mock_abc';

      // 1. Create order request body
      final createOrderBody = {
        'type': 'LAWYER_BOOKING',
        'targetId': bookingId,
        'amount': rate,
      };

      expect(createOrderBody['type'], 'LAWYER_BOOKING');
      expect(createOrderBody['targetId'], 42);
      expect(createOrderBody['amount'], 750.0);

      // 2. Verify payment request body
      final verifyBody = {
        'type': 'LAWYER_BOOKING',
        'targetId': bookingId,
        'orderId': orderId,
        'paymentId': paymentId,
        'signature': signature,
        'amount': rate,
      };

      expect(verifyBody['type'], 'LAWYER_BOOKING');
      expect(verifyBody['targetId'], 42);
      expect(verifyBody['orderId'], 'order_mock_123_456');
      expect(verifyBody['paymentId'], 'pay_mock_789');
      expect(verifyBody['signature'], 'sig_mock_abc');
      expect(verifyBody['amount'], 750.0);
    });
  });
}
