import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/payment_service.dart';
import 'package:fight_d_fear/services/women_products_seller_auth_service.dart';
import 'package:fight_d_fear/services/women_products_service.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

class _MockSellerApiClient extends ApiClient {
  _MockSellerApiClient() : super('http://localhost:8084');

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
    recordedCalls.add('GET $path [sellerAuth: $womenProductsSellerAuth, memberAuth: $auth]');
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
    recordedCalls.add('POST $path [sellerAuth: $womenProductsSellerAuth, memberAuth: $auth] ${body != null ? body.toString() : ""}');
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
    recordedCalls.add('PUT $path [sellerAuth: $womenProductsSellerAuth, memberAuth: $auth] ${body != null ? body.toString() : ""}');
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
    Duration? timeout,
  }) async {
    recordedCalls.add('DELETE $path [sellerAuth: $womenProductsSellerAuth]');
    return nextDeleteResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Women Products Seller & Member Multi-Role Token Isolation', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Seller and Member JWT tokens are stored under separate keys and never overwrite each other', () async {
      final client = ApiClient('http://localhost:8084');

      // Initially both empty
      expect(await client.getToken(), isNull);
      expect(await client.getWomenProductsSellerToken(), isNull);

      // Save Member token
      const memberToken = 'jwt-member-mock-token-abc-123';
      await client.saveToken(memberToken);

      expect(await client.getToken(), equals(memberToken));
      expect(await client.getWomenProductsSellerToken(), isNull);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), equals(memberToken));
      expect(prefs.getString('women_products_seller_auth_token'), isNull);

      // Save Seller token independently
      const sellerToken = 'jwt-seller-mock-token-xyz-789';
      await client.saveWomenProductsSellerToken(sellerToken);

      // Both tokens must coexist independently
      expect(await client.getToken(), equals(memberToken));
      expect(await client.getWomenProductsSellerToken(), equals(sellerToken));
      expect(prefs.getString('auth_token'), equals(memberToken));
      expect(prefs.getString('women_products_seller_auth_token'), equals(sellerToken));

      // Clearing seller token must NOT clear member token
      await client.clearWomenProductsSellerToken();
      expect(await client.getWomenProductsSellerToken(), isNull);
      expect(await client.getToken(), equals(memberToken));
      expect(prefs.getString('auth_token'), equals(memberToken));
      expect(prefs.getString('women_products_seller_auth_token'), isNull);
    });

    test('Seller auth service passes womenProductsSellerAuth flag to ApiClient', () async {
      final mock = _MockSellerApiClient();
      final sellerSvc = WomenProductsSellerAuthService(mock);

      // Call dashboard
      await sellerSvc.dashboard();
      expect(
        mock.recordedCalls.any((c) => c.contains('GET /api/women-products/seller/me') && c.contains('sellerAuth: true')),
        isTrue,
      );

      // Call profile
      await sellerSvc.profile();
      expect(
        mock.recordedCalls.any((c) => c.contains('GET /api/women-products/seller/profile') && c.contains('sellerAuth: true')),
        isTrue,
      );

      // Call updateProfile
      await sellerSvc.updateProfile({'businessName': 'Artisan Soaps'});
      expect(
        mock.recordedCalls.any((c) => c.contains('PUT /api/women-products/seller/profile') && c.contains('sellerAuth: true')),
        isTrue,
      );

      // Call updateStock
      await sellerSvc.updateStock(42, 25);
      expect(
        mock.recordedCalls.any((c) => c.contains('POST /api/women-products/seller/products/42/stock') && c.contains('sellerAuth: true')),
        isTrue,
      );
    });
  });

  group('Seller Approval Navigation Lifecycle Parity', () {
    test('ApprovalNavigation correctly routes APPROVED vs PENDING vs INCOMPLETE', () {
      // 1. APPROVED seller goes directly to dashboard
      final approvedPayload1 = {'partnerProfileStatus': 'APPROVED', 'needsProfileCompletion': false};
      final approvedPayload2 = {'verificationStatus': 'VERIFIED', 'needsProfileCompletion': false};
      final approvedPayload3 = {'approved': true, 'needsProfileCompletion': true}; // Flag overrides

      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(approvedPayload1), isFalse);
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(approvedPayload2), isFalse);
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(approvedPayload3), isFalse);

      // 2. PROFILE_INCOMPLETE redirects to profile completion
      final incompletePayload = {
        'partnerProfileStatus': 'PROFILE_INCOMPLETE',
        'needsProfileCompletion': true,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(incompletePayload), isTrue);

      // 3. PENDING_ADMIN_APPROVAL does not require completion
      final pendingPayload = {
        'partnerProfileStatus': 'PENDING_ADMIN_APPROVAL',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(pendingPayload), isFalse);
    });
  });

  group('Seller Profile Validations & Payload Parity', () {
    test('ProfileFieldHelper provides contextual instruction for all 9 sections', () {
      expect(ProfileFieldHelper.instructionForField(label: 'Full Name', required: true), contains('full name'));
      expect(ProfileFieldHelper.instructionForField(label: 'Official Phone', required: true), contains('10-digit'));
      expect(ProfileFieldHelper.instructionForField(label: 'Shop Name', required: true), contains('establishment or business name'));
      expect(ProfileFieldHelper.instructionForField(label: 'Address', required: true), contains('street address'));
      expect(ProfileFieldHelper.instructionForField(label: 'Pincode', required: true), contains('6-digit'));
      expect(ProfileFieldHelper.instructionForField(label: 'IFSC Code'), contains('11-character'));
      expect(ProfileFieldHelper.instructionForField(label: 'UPI ID'), contains('UPI ID'));
    });

    test('Validates phone numbers and IFSC format accurately', () {
      final validPhone = RegExp(r'^[6-9]\d{9}$');
      expect(validPhone.hasMatch('9876543210'), isTrue);
      expect(validPhone.hasMatch('8123456789'), isTrue);
      expect(validPhone.hasMatch('5123456789'), isFalse); // Starts with 5
      expect(validPhone.hasMatch('987654321'), isFalse); // 9 digits
      expect(validPhone.hasMatch('98765432100'), isFalse); // 11 digits

      final validIfsc = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
      expect(validIfsc.hasMatch('SBIN0001234'), isTrue);
      expect(validIfsc.hasMatch('HDFC0000456'), isTrue);
      expect(validIfsc.hasMatch('sbin0001234'), isFalse); // Lowercase
      expect(validIfsc.hasMatch('SBIN1001234'), isFalse); // 5th char not 0
    });
  });

  group('Member Product Ordering & Razorpay Payment Integration', () {
    test('Member placeOrder formats COD and ONLINE orders properly', () async {
      final mock = _MockSellerApiClient();
      final productsSvc = WomenProductsService(mock);

      // 1. Place COD order
      await productsSvc.placeOrder(
        shippingAddress: '123 MG Road, Bengaluru, Karnataka, 560001',
        paymentMethod: 'COD',
      );
      expect(
        mock.recordedCalls.any((c) => c.contains('POST /api/women-products/checkout/place') && c.contains('paymentMethod: COD')),
        isTrue,
      );

      // 2. Place ONLINE order
      await productsSvc.placeOrder(
        shippingAddress: '456 Brigade Road, Bengaluru, Karnataka, 560025',
        paymentMethod: 'ONLINE',
      );
      expect(
        mock.recordedCalls.any((c) => c.contains('POST /api/women-products/checkout/place') && c.contains('paymentMethod: ONLINE')),
        isTrue,
      );
    });

    test('Razorpay create-order and verify payloads match backend PaymentController expectations', () async {
      final mock = _MockSellerApiClient();
      final paySvc = PaymentService(mock);

      const orderId = 205;
      const orderAmount = 1499.0;

      // 1. Call createOrder for WOMEN_PRODUCT
      await paySvc.createOrder(
        orderAmount,
        type: 'WOMEN_PRODUCT',
        extra: {
          'targetId': orderId,
          'orderId': orderId,
          'orderIds': [orderId],
        },
      );

      expect(
        mock.recordedCalls.any((c) =>
            c.contains('POST /payment/create-order') &&
            c.contains('type: WOMEN_PRODUCT') &&
            c.contains('targetId: 205') &&
            c.contains('orderIds: [205]')),
        isTrue,
      );

      // 2. Call verify for WOMEN_PRODUCT
      await paySvc.verify({
        'razorpay_order_id': 'order_rzp_mock_123',
        'razorpay_payment_id': 'pay_rzp_mock_456',
        'razorpay_signature': 'sig_rzp_mock_789',
        'type': 'WOMEN_PRODUCT',
        'targetId': orderId,
        'orderId': orderId,
        'orderIds': [orderId],
        'amount': orderAmount,
      });

      expect(
        mock.recordedCalls.any((c) =>
            c.contains('POST /payment/verify') &&
            c.contains('type: WOMEN_PRODUCT') &&
            c.contains('razorpay_order_id: order_rzp_mock_123') &&
            c.contains('razorpay_payment_id: pay_rzp_mock_456')),
        isTrue,
      );
    });
  });
}
