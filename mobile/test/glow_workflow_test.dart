import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/glow_provider_auth_service.dart';
import 'package:fight_d_fear/services/glow_space_service.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

class _MockApiClient extends ApiClient {
  _MockApiClient() : super('http://localhost:8084');

  final List<String> recordedCalls = [];
  Map<String, dynamic> nextGetResponse = {'success': true};
  Map<String, dynamic> nextPostResponse = {'success': true};
  String? mockSalonToken;

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
    recordedCalls.add('GET $path');
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
    recordedCalls.add('POST $path');
    if (nextPostResponse.containsKey('token')) {
      mockSalonToken = nextPostResponse['token'] as String;
    }
    return nextPostResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Glow Space Workflow Tests', () {
    late _MockApiClient mockApi;
    late GlowProviderAuthService authService;
    late GlowSpaceService spaceService;

    setUp(() {
      mockApi = _MockApiClient();
      authService = GlowProviderAuthService(mockApi);
      spaceService = GlowSpaceService(mockApi);
    });

    test('Salon Registration should call correct endpoints and use salonAuth', () async {
      mockApi.nextPostResponse = {
        'success': true,
        'token': 'salon_token_123',
        'partnerProfileStatus': 'PENDING_PROFILE',
      };

      final res = await authService.registerSalonQuick({
        'name': 'Test Salon',
        'email': 'test@salon.com',
      });

      expect(res['success'], true);
      expect(mockApi.recordedCalls, contains('POST /api/glow/provider/salon/register-quick'));
      expect(mockApi.mockSalonToken, 'salon_token_123');
    });

    test('Salon Dashboard should retrieve provider data', () async {
      mockApi.nextGetResponse = {
        'success': true,
        'salon': {'name': 'Test Salon', 'approved': true},
        'bookings': [],
      };

      final res = await authService.salonDashboard();
      expect(res['success'], true);
      expect(res['salon']['name'], 'Test Salon');
      expect(mockApi.recordedCalls, contains('GET /api/glow/salon/me'));
    });

    test('Member discovery should retrieve salons', () async {
      mockApi.nextGetResponse = {
        'success': true,
        'salons': [{'id': 1, 'name': 'Test Salon'}],
      };

      final res = await spaceService.salons(city: 'Delhi');
      expect(res['success'], true);
      expect(res['salons'].length, 1);
      expect(mockApi.recordedCalls, contains('GET /api/glow/salons?city=Delhi'));
    });

    test('Member booking should create booking order', () async {
      mockApi.nextPostResponse = {
        'success': true,
        'bookingId': 100,
        'paymentRequired': true,
      };

      final res = await spaceService.createBooking(
        itemType: 'SALON',
        itemId: 1,
        bookingDate: '2023-12-01',
        preferredTime: '10:00',
        bookingType: 'ONLINE',
        address: '',
        notes: '',
      );

      expect(res['success'], true);
      expect(res['paymentRequired'], true);
      expect(mockApi.recordedCalls, contains('POST /api/glow/bookings'));
    });

    test('ApprovalNavigation helper handles Glow Salon completion logic', () {
      final incomplete = {
        'needsProfileCompletion': true,
        'partnerProfileStatus': 'PENDING_PROFILE',
        'profileCompletionPct': 50
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(incomplete), true);

      final submitted = {
        'needsProfileCompletion': false,
        'partnerProfileStatus': 'PENDING',
        'profileCompletionPct': 100
      };
      // Even if pending approval, they have completed the profile, so they can see dashboard
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(submitted), false);
    });
  });
}
