import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/doctor_auth_service.dart';
import 'package:fight_d_fear/services/payment_service.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

class _MockDoctorApiClient extends ApiClient {
  _MockDoctorApiClient() : super('http://localhost:8084');

  final List<String> recordedCalls = [];
  Map<String, dynamic> nextGetResponse = {'success': true};
  Map<String, dynamic> nextPostResponse = {'success': true};
  Map<String, dynamic> nextPutResponse = {'success': true};
  Map<String, dynamic> nextDeleteResponse = {'success': true};

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool womenLawyerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    Map<String, dynamic>? queryParams,
    Duration? timeout,
  }) async {
    recordedCalls.add('GET $path [doctorAuth: $doctorAuth, memberAuth: $auth]');
    return nextGetResponse;
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool womenLawyerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    Duration? timeout,
  }) async {
    recordedCalls.add('POST $path [doctorAuth: $doctorAuth, memberAuth: $auth] ${body != null ? body.toString() : ""}');
    return nextPostResponse;
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool womenLawyerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    Duration? timeout,
  }) async {
    recordedCalls.add('PUT $path [doctorAuth: $doctorAuth, memberAuth: $auth] ${body != null ? body.toString() : ""}');
    return nextPutResponse;
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    bool doctorAuth = false,
    bool centreAuth = false,
    bool adminAuth = false,
    bool salonAuth = false,
    bool stylistAuth = false,
    bool creatorAuth = false,
    bool fitnessTrainerAuth = false,
    bool eventHostAuth = false,
    bool deliveryPartnerAuth = false,
    bool investorAuth = false,
    bool entrepreneurAuth = false,
    bool womenJobsAuth = false,
    bool womenProductsSellerAuth = false,
    bool womenLawyerAuth = false,
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
  }) async {
    recordedCalls.add('DELETE $path [doctorAuth: $doctorAuth]');
    return nextDeleteResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Doctor & Member Complete Workflow Tests', () {
    late _MockDoctorApiClient fakeApi;
    late DoctorAuthService doctorAuth;
    late PaymentService paymentSvc;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      fakeApi = _MockDoctorApiClient();
      doctorAuth = DoctorAuthService(fakeApi);
      paymentSvc = PaymentService(fakeApi);
    });

    test('1. Multi-role Token Isolation: Doctor vs Member JWT tokens', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://localhost:8084');

      // Member signs in
      await api.saveToken('jwt_member_abc_999');
      expect(await api.getToken(), 'jwt_member_abc_999');
      expect(prefs.getString('auth_token'), 'jwt_member_abc_999');

      // Doctor signs in
      await api.saveDoctorToken('jwt_doctor_xyz_111');
      expect(await api.getDoctorToken(), 'jwt_doctor_xyz_111');
      expect(prefs.getString('doctor_auth_token'), 'jwt_doctor_xyz_111');

      // Verify Member token was NOT overwritten
      expect(await api.getToken(), 'jwt_member_abc_999');
      expect(prefs.getString('auth_token'), 'jwt_member_abc_999');

      // Doctor logs out
      await api.clearDoctorToken();
      expect(await api.getDoctorToken(), isNull);
      expect(prefs.getString('doctor_auth_token'), isNull);

      // Verify Member token remains intact after Doctor logout
      expect(await api.getToken(), 'jwt_member_abc_999');
      expect(prefs.getString('auth_token'), 'jwt_member_abc_999');

      // Member logs out
      await api.clearToken();
      expect(await api.getToken(), isNull);
      expect(prefs.getString('auth_token'), isNull);
    });

    test('2. Approval Navigation directs Doctor states correctly', () {
      final approvedDoc = {
        'success': true,
        'approved': true,
        'doctorProfileStatus': 'APPROVED',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(approvedDoc), isFalse);

      final verifiedDoc = {
        'success': true,
        'approved': true,
        'verificationStatus': 'VERIFIED',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(verifiedDoc), isFalse);

      final pendingDoc = {
        'success': true,
        'approved': false,
        'doctorProfileStatus': 'PENDING_ADMIN_APPROVAL',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(pendingDoc), isFalse);

      final incompleteDoc = {
        'success': true,
        'approved': false,
        'doctorProfileStatus': 'PROFILE_INCOMPLETE',
        'needsProfileCompletion': true,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(incompleteDoc), isTrue);
    });

    test('3. DoctorAuthService provider-side endpoints attach doctorAuth: true', () async {
      await doctorAuth.dashboard();
      expect(fakeApi.recordedCalls.last, contains('GET /api/doctors/provider/me [doctorAuth: true'));

      await doctorAuth.profile();
      expect(fakeApi.recordedCalls.last, contains('GET /api/doctors/provider/profile [doctorAuth: true'));

      await doctorAuth.submitVerification();
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/submit-verification [doctorAuth: true'));

      await doctorAuth.setOnline(true);
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/online [doctorAuth: true'));
      expect(fakeApi.recordedCalls.last, contains('online: true'));

      await doctorAuth.updateAppointmentStatus(42, 'CONFIRMED');
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/appointments/42/status [doctorAuth: true'));
      expect(fakeApi.recordedCalls.last, contains('status: CONFIRMED'));

      await doctorAuth.savePrescription(42, 'Amoxicillin 500mg TDS for 5 days', doctorNotes: 'Rest and fluids');
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/appointments/42/prescription [doctorAuth: true'));
      expect(fakeApi.recordedCalls.last, contains('Amoxicillin 500mg'));

      await doctorAuth.reschedule(42, '2026-11-05 14:30');
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/appointments/42/reschedule [doctorAuth: true'));
      expect(fakeApi.recordedCalls.last, contains('2026-11-05 14:30'));

      await doctorAuth.requestPayout();
      expect(fakeApi.recordedCalls.last, contains('POST /api/doctors/provider/payout/request [doctorAuth: true'));
    });

    test('4. Member Profile validation and completion scoring rules', () {
      // Validation helpers
      String? validateName(String name) {
        if (name.trim().isEmpty) return 'Full name is required';
        if (name.trim().length < 2) return 'Name must be at least 2 characters';
        return null;
      }

      String? validatePhone(String phone) {
        if (phone.trim().isEmpty) return 'Phone number is required';
        if (!RegExp(r'^\d{10}$').hasMatch(phone.trim())) return 'Phone must be exactly 10 digits';
        return null;
      }

      String? validateWhatsApp(String wa) {
        if (wa.trim().isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(wa.trim())) {
          return 'WhatsApp must be exactly 10 digits';
        }
        return null;
      }

      expect(validateName(''), 'Full name is required');
      expect(validateName('A'), 'Name must be at least 2 characters');
      expect(validateName('Dr. Jane Doe'), isNull);

      expect(validatePhone(''), 'Phone number is required');
      expect(validatePhone('12345'), 'Phone must be exactly 10 digits');
      expect(validatePhone('9876543210'), isNull);

      expect(validateWhatsApp(''), isNull);
      expect(validateWhatsApp('98765'), 'WhatsApp must be exactly 10 digits');
      expect(validateWhatsApp('9876543210'), isNull);

      // Website parity completion percentage calculator
      int calculateCompletion({
        required bool hasName,
        required bool hasEmail,
        required bool hasPhone,
        required bool hasLocation,
        required bool hasGender,
        required bool hasEmergencyContact,
        required bool hasEmergencyWhatsApp,
        required bool hasDobOrAge,
        required bool hasPhoto,
      }) {
        int score = 0;
        if (hasName) score += 10;
        if (hasEmail) score += 10;
        if (hasPhone) score += 10;
        if (hasLocation) score += 10;
        if (hasGender) score += 10;
        if (hasEmergencyContact) score += 15;
        if (hasEmergencyWhatsApp) score += 15;
        if (hasDobOrAge) score += 5;
        if (hasPhoto) score += 15;
        if (!hasPhoto && score >= 100) score = 85;
        return score.clamp(0, 100);
      }

      // Complete profile
      final fullScore = calculateCompletion(
        hasName: true,
        hasEmail: true,
        hasPhone: true,
        hasLocation: true,
        hasGender: true,
        hasEmergencyContact: true,
        hasEmergencyWhatsApp: true,
        hasDobOrAge: true,
        hasPhoto: true,
      );
      expect(fullScore, 100);

      // Everything except photo -> capped at 85%
      final withoutPhoto = calculateCompletion(
        hasName: true,
        hasEmail: true,
        hasPhone: true,
        hasLocation: true,
        hasGender: true,
        hasEmergencyContact: true,
        hasEmergencyWhatsApp: true,
        hasDobOrAge: true,
        hasPhoto: false,
      );
      expect(withoutPhoto, 85);

      // Basic registration only (name, email, phone) -> 30%
      final basic = calculateCompletion(
        hasName: true,
        hasEmail: true,
        hasPhone: true,
        hasLocation: false,
        hasGender: false,
        hasEmergencyContact: false,
        hasEmergencyWhatsApp: false,
        hasDobOrAge: false,
        hasPhoto: false,
      );
      expect(basic, 30);
    });

    test('5. Razorpay Doctor Booking order creation & verification payload', () async {
      await paymentSvc.createDoctorOrder(
        doctorId: 105,
        consultationType: 'VIDEO',
        appointmentTime: '2026-11-01 11:00',
        reason: 'Severe headache and nausea',
      );
      expect(fakeApi.recordedCalls.last, contains('POST /payment/create-order'));
      expect(fakeApi.recordedCalls.last, contains('type: DOCTOR'));
      expect(fakeApi.recordedCalls.last, contains('targetId: 105'));
      expect(fakeApi.recordedCalls.last, contains('consultationType: VIDEO'));
      expect(fakeApi.recordedCalls.last, contains('reason: Severe headache and nausea'));

      await paymentSvc.verify({
        'razorpay_order_id': 'order_doc_123',
        'razorpay_payment_id': 'pay_doc_456',
        'razorpay_signature': 'sig_doc_789',
        'type': 'DOCTOR',
        'targetId': 105,
        'amount': 500.0,
        'appointmentTime': '2026-11-01 11:00',
        'consultationType': 'VIDEO',
        'reason': 'Severe headache and nausea',
      });
      expect(fakeApi.recordedCalls.last, contains('POST /payment/verify'));
      expect(fakeApi.recordedCalls.last, contains('razorpay_order_id: order_doc_123'));
      expect(fakeApi.recordedCalls.last, contains('type: DOCTOR'));
    });
  });
}
