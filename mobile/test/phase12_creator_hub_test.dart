import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/config/creator_catalog.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/creator_hub_service.dart';
import 'package:fight_d_fear/services/payment_service.dart';

class MockApiClient extends ApiClient {
  MockApiClient() : super('http://localhost:8080');

  String? lastGetPath;
  String? lastPostPath;
  String? lastDeletePath;
  Map<String, dynamic>? lastBody;
  bool lastCreatorAuth = false;

  Map<String, dynamic> responseData = {'success': true};

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
    lastGetPath = path;
    lastCreatorAuth = creatorAuth;
    return responseData;
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
    lastPostPath = path;
    lastBody = body;
    lastCreatorAuth = creatorAuth;
    return responseData;
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
    lastDeletePath = path;
    lastCreatorAuth = creatorAuth;
    return responseData;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 12: Creator Hub Catalog & Policies', () {
    test('Categories contain verified safety awareness and creator domains', () {
      expect(CreatorCatalog.categories, contains('Safety Awareness'));
      expect(CreatorCatalog.categories, contains('Entrepreneurship'));
      expect(CreatorCatalog.categories, contains('Financial Literacy'));
      expect(CreatorCatalog.categories, contains('Skill Development'));
      expect(CreatorCatalog.categories, contains('Inspirational'));
      expect(CreatorCatalog.categories, contains('Entertainment'));
    });

    test('Cancellation & refund policy matches single source of truth', () {
      expect(CreatorCatalog.cancelPolicy, contains('Tips and paid unlocks are not refundable'));
    });
  });

  group('Phase 12: Creator Hub Service & Endpoints', () {
    late MockApiClient mockApi;
    late CreatorHubService service;

    setUp(() {
      mockApi = MockApiClient();
      service = CreatorHubService(mockApi);
    });

    test('feed encodes query parameters properly', () async {
      await service.feed(
        search: 'safety demo',
        category: 'Safety Awareness',
        city: 'Mumbai',
        sort: 'newest',
        page: 0,
        size: 20,
      );
      expect(mockApi.lastGetPath, contains('/api/creator-hub/feed?'));
      expect(mockApi.lastGetPath, contains('search=safety%20demo'));
      expect(mockApi.lastGetPath, contains('category=Safety%20Awareness'));
      expect(mockApi.lastGetPath, contains('city=Mumbai'));
    });

    test('video interactions: like, bookmark, view, comment, and report', () async {
      await service.like(101);
      expect(mockApi.lastPostPath, '/api/creator-hub/posts/101/like');

      await service.bookmark(101);
      expect(mockApi.lastPostPath, '/api/creator-hub/posts/101/bookmark');

      await service.view(101);
      expect(mockApi.lastPostPath, '/api/creator-hub/posts/101/view');

      await service.comment(101, 'Great presentation');
      expect(mockApi.lastPostPath, '/api/creator-hub/posts/101/comments');
      expect(mockApi.lastBody?['text'], 'Great presentation');

      await service.report(101, 'Inappropriate content');
      expect(mockApi.lastPostPath, '/api/creator-hub/posts/101/report');
      expect(mockApi.lastBody?['reason'], 'Inappropriate content');
    });

    test('creator interactions: follow, tip, subscribe, unsubscribe, and rate', () async {
      await service.follow(42);
      expect(mockApi.lastPostPath, '/api/creator-hub/creators/42/follow');

      await service.tip(creatorId: 42, amount: 150.0, message: 'Keep up the good work');
      expect(mockApi.lastPostPath, '/api/creator-hub/creators/tip');
      expect(mockApi.lastBody?['creatorId'], 42);
      expect(mockApi.lastBody?['amount'], 150.0);
      expect(mockApi.lastBody?['message'], 'Keep up the good work');

      await service.subscribe(42);
      expect(mockApi.lastPostPath, '/api/creator-hub/creators/subscribe');
      expect(mockApi.lastBody?['creatorId'], 42);

      await service.unsubscribe(42);
      expect(mockApi.lastPostPath, '/api/creator-hub/creators/42/unsubscribe');

      await service.rateCreator(42, rating: 5, review: 'Exceptional mentor');
      expect(mockApi.lastPostPath, '/api/creator-hub/creators/42/rate');
      expect(mockApi.lastBody?['rating'], 5);
      expect(mockApi.lastBody?['review'], 'Exceptional mentor');
    });

    test('story endpoints: myStories, viewStory, storyViewers, and deleteStory', () async {
      await service.myStories();
      expect(mockApi.lastGetPath, '/api/creator-hub/story/my');
      expect(mockApi.lastCreatorAuth, true);

      await service.viewStory(77);
      expect(mockApi.lastPostPath, '/api/creator-hub/story/77/view');

      await service.storyViewers(77);
      expect(mockApi.lastGetPath, '/api/creator-hub/story/77/viewers');
      expect(mockApi.lastCreatorAuth, true);

      await service.deleteStory(77);
      expect(mockApi.lastDeletePath, '/api/creator-hub/story/77');
      expect(mockApi.lastCreatorAuth, true);
    });

    test('notifications: markAllNotificationsRead', () async {
      await service.markAllNotificationsRead();
      expect(mockApi.lastPostPath, '/api/creator-hub/notifications/mark-all-read');
      expect(mockApi.lastCreatorAuth, true);
    });

    test('creator studio monetization & settings', () async {
      await service.claimAdRevenue();
      expect(mockApi.lastPostPath, '/api/creator-hub/dashboard/claim-ad-revenue');
      expect(mockApi.lastCreatorAuth, true);

      await service.cashout(250);
      expect(mockApi.lastPostPath, '/api/creator-hub/dashboard/cashout');
      expect(mockApi.lastBody?['points'], 250);
      expect(mockApi.lastCreatorAuth, true);

      await service.setSubscriptionPrice(149.0);
      expect(mockApi.lastPostPath, '/api/creator-hub/dashboard/subscription-price');
      expect(mockApi.lastBody?['price'], 149.0);
      expect(mockApi.lastCreatorAuth, true);

      await service.setAffiliateCode('CREATOR10');
      expect(mockApi.lastPostPath, '/api/creator-hub/dashboard/affiliate-code');
      expect(mockApi.lastBody?['code'], 'CREATOR10');
      expect(mockApi.lastCreatorAuth, true);

      await service.togglePrivacy();
      expect(mockApi.lastPostPath, '/api/creator-hub/dashboard/toggle-privacy');
      expect(mockApi.lastCreatorAuth, true);
    });

    test('brand collaborations: campaigns listing & application with pitch', () async {
      await service.campaigns();
      expect(mockApi.lastGetPath, '/api/creator-hub/collab/campaigns');
      expect(mockApi.lastCreatorAuth, true);

      await service.applyCollab(campaignId: 99, pitch: 'Experienced safety content creator');
      expect(mockApi.lastPostPath, '/api/creator-hub/collab/apply');
      expect(mockApi.lastBody?['campaignId'], 99);
      expect(mockApi.lastBody?['pitch'], 'Experienced safety content creator');
      expect(mockApi.lastCreatorAuth, true);
    });
  });

  group('Phase 12: PaymentService Creator Orders', () {
    late MockApiClient mockApi;
    late PaymentService paymentService;

    setUp(() {
      mockApi = MockApiClient();
      paymentService = PaymentService(mockApi);
    });

    test('createCreatorTipOrder posts to /payment/create-order with CREATOR_TIP', () async {
      await paymentService.createCreatorTipOrder(
        creatorId: 10,
        amount: 200.0,
        message: 'Great video',
      );
      expect(mockApi.lastPostPath, '/payment/create-order');
      expect(mockApi.lastBody?['type'], 'CREATOR_TIP');
      expect(mockApi.lastBody?['creatorId'], 10);
      expect(mockApi.lastBody?['targetId'], 10);
      expect(mockApi.lastBody?['amount'], 200.0);
      expect(mockApi.lastBody?['message'], 'Great video');
    });

    test('createCreatorSubOrder posts to /payment/create-order with CREATOR_SUB', () async {
      await paymentService.createCreatorSubOrder(creatorId: 10);
      expect(mockApi.lastPostPath, '/payment/create-order');
      expect(mockApi.lastBody?['type'], 'CREATOR_SUB');
      expect(mockApi.lastBody?['creatorId'], 10);
      expect(mockApi.lastBody?['targetId'], 10);
    });

    test('createCreatorUnlockOrder posts to /payment/create-order with CREATOR_UNLOCK', () async {
      await paymentService.createCreatorUnlockOrder(videoId: 55);
      expect(mockApi.lastPostPath, '/payment/create-order');
      expect(mockApi.lastBody?['type'], 'CREATOR_UNLOCK');
      expect(mockApi.lastBody?['videoId'], 55);
      expect(mockApi.lastBody?['targetId'], 55);
    });
  });
}
