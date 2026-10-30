import 'package:flutter_test/flutter_test.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/centre_auth_service.dart';
import 'package:fight_d_fear/widgets/profile_completion_helpers.dart';

class _MockApiClient extends ApiClient {
  _MockApiClient() : super('http://localhost:8084');

  final List<String> recordedCalls = [];
  Map<String, dynamic> nextGetResponse = {'success': true};
  Map<String, dynamic> nextPostResponse = {'success': true};
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
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
    Duration? timeout,
  }) async {
    recordedCalls.add('POST $path ${body != null ? body.toString() : ""}');
    return nextPostResponse;
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
    bool financialEducatorAuth = false,
    bool marketplaceProviderAuth = false,
  }) async {
    recordedCalls.add('DELETE $path');
    return nextDeleteResponse;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Martial Arts Centre & Member Workflow Tests', () {
    late _MockApiClient fakeApi;
    late CentreAuthService svc;

    setUp(() {
      fakeApi = _MockApiClient();
      svc = CentreAuthService(fakeApi);
    });

    test('Approval navigation directs approved and pending centres correctly', () {
      final approved = {
        'success': true,
        'approved': true,
        'centreProfileStatus': 'APPROVED',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(approved), isFalse);

      final pending = {
        'success': true,
        'approved': false,
        'centreProfileStatus': 'PENDING_ADMIN_APPROVAL',
        'needsProfileCompletion': false,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(pending), isFalse);

      final incomplete = {
        'success': true,
        'approved': false,
        'centreProfileStatus': 'PROFILE_INCOMPLETE',
        'needsProfileCompletion': true,
      };
      expect(ApprovalNavigation.shouldRedirectToProfileCompletion(incomplete), isTrue);
    });

    test('CentreAuthService QR Attendance Session endpoints', () async {
      await svc.createQrSession(batchId: 101, date: '2026-10-30', duration: 15);
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/qr-session'));
      expect(fakeApi.recordedCalls.last, contains('batchId: 101'));

      await svc.getQrSession(batchId: 101, date: '2026-10-30');
      expect(fakeApi.recordedCalls.last, equals('GET /api/martial-arts/centre/qr-session?batchId=101&date=2026-10-30'));

      await svc.closeQrSession(55);
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/qr-session/55/close'));
    });

    test('CentreAuthService Belt Grading & Assessments endpoints', () async {
      await svc.getGradingCriteria(style: 'Karate', belt: 'Yellow');
      expect(fakeApi.recordedCalls.last, contains('GET /api/martial-arts/centre/grading/criteria?style=Karate&belt=Yellow'));

      await svc.getGradings(status: 'SCHEDULED', batchId: 101);
      expect(fakeApi.recordedCalls.last, contains('GET /api/martial-arts/centre/gradings?status=SCHEDULED&batchId=101'));

      await svc.scheduleGrading({
        'traineeId': 200,
        'style': 'Karate',
        'targetBelt': 'Yellow',
        'scheduledDate': '2026-11-05',
      });
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/gradings/schedule'));

      await svc.scoreGrading(12, {'score': 85, 'passed': true});
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/gradings/12/score'));

      await svc.promoteGrading(12);
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/gradings/12/promote'));
    });

    test('CentreAuthService Instructors and Renewals endpoints', () async {
      await svc.getInstructors();
      expect(fakeApi.recordedCalls.last, equals('GET /api/martial-arts/centre/instructors'));

      await svc.createInstructor({'name': 'Sensei John', 'designation': 'Head Coach'});
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/instructors'));

      await svc.deleteInstructor(42);
      expect(fakeApi.recordedCalls.last, equals('DELETE /api/martial-arts/centre/instructors/42'));

      await svc.updateRenewal(77, renewalStatus: 'ACTIVE', nextRenewalDate: '2026-12-01');
      expect(fakeApi.recordedCalls.last, contains('POST /api/martial-arts/centre/enrollments/77/renewal'));
      expect(fakeApi.recordedCalls.last, contains('renewalStatus: ACTIVE'));
    });
  });
}
