import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/config/fitness_catalog.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/fitness_trainer_auth_service.dart';
import 'package:fight_d_fear/services/module_services.dart';
import 'package:fight_d_fear/services/payment_service.dart';

class MockApiClient extends ApiClient {
  MockApiClient() : super('http://localhost:8080');

  String? lastGetPath;
  String? lastPostPath;
  String? lastPutPath;
  String? lastDeletePath;
  Map<String, dynamic>? lastBody;
  bool lastFitnessTrainerAuth = false;

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
    lastFitnessTrainerAuth = fitnessTrainerAuth;
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
    lastFitnessTrainerAuth = fitnessTrainerAuth;
    return responseData;
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
    lastPutPath = path;
    lastBody = body;
    lastFitnessTrainerAuth = fitnessTrainerAuth;
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> delete(
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
    lastDeletePath = path;
    lastBody = body;
    lastFitnessTrainerAuth = fitnessTrainerAuth;
    return responseData;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Phase 11 - Fitness Catalog & Helper Verification', () {
    test('FitnessCatalog definitions and options coverage', () {
      expect(FitnessCatalog.designations, isNotEmpty);
      expect(FitnessCatalog.designations, contains('Certified Personal Trainer (CPT)'));
      expect(FitnessCatalog.designations, contains('Yoga Instructor'));

      expect(FitnessCatalog.allSpecializations, isNotEmpty);
      expect(FitnessCatalog.allSpecializations, contains('HIIT'));
      expect(FitnessCatalog.allSpecializations, contains('Yoga'));
      expect(FitnessCatalog.allSpecializations, contains('Self-Defense Fitness'));

      expect(FitnessCatalog.audiences, contains('Women Only'));
      expect(FitnessCatalog.audiences, contains('Beginners'));

      expect(FitnessCatalog.sessionModes, contains('ONLINE'));
      expect(FitnessCatalog.sessionModes, contains('STUDIO'));
    });

    test('FitnessCatalog split and match utilities', () {
      final items = FitnessCatalog.splitCsv('HIIT, Yoga, Strength Training');
      expect(items.length, equals(3));
      expect(items, contains('HIIT'));
      expect(items, contains('Yoga'));
      expect(items, contains('Strength Training'));

      expect(FitnessCatalog.matchesCategory('HIIT, Yoga', 'hiit'), isTrue);
      expect(FitnessCatalog.matchesCategory('Yoga, Pilates', 'zumba'), isFalse);
      expect(FitnessCatalog.matchesCategory('Any', 'all'), isTrue);
    });
  });

  group('Phase 11 - Fitness Trainer Service Contracts', () {
    late MockApiClient mockApi;
    late FitnessTrainerAuthService trainerAuthService;

    setUp(() {
      mockApi = MockApiClient();
      trainerAuthService = FitnessTrainerAuthService(mockApi);
    });

    test('Classes CRUD API contracts with isolated trainer auth', () async {
      // 1. Get classes
      await trainerAuthService.getClasses();
      expect(mockApi.lastGetPath, equals('/api/fitness/trainer/classes'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);

      // 2. Create class
      final classBody = {
        'className': 'Morning HIIT Blast',
        'category': 'HIIT',
        'classDate': '2026-11-05',
        'classTime': '07:30',
        'durationMinutes': 45,
        'sessionType': 'ONLINE',
        'maxCapacity': 20,
        'price': 300,
      };
      await trainerAuthService.createClass(classBody);
      expect(mockApi.lastPostPath, equals('/api/fitness/trainer/classes'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);
      expect(mockApi.lastBody?['className'], equals('Morning HIIT Blast'));
      expect(mockApi.lastBody?['price'], equals(300));

      // 3. Edit class
      await trainerAuthService.editClass(42, {'price': 350});
      expect(mockApi.lastPutPath, equals('/api/fitness/trainer/classes/42'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);
      expect(mockApi.lastBody?['price'], equals(350));

      // 4. Delete class
      await trainerAuthService.deleteClass(42);
      expect(mockApi.lastDeletePath, equals('/api/fitness/trainer/classes/42'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);
    });

    test('Trainer log client progress and mark attendance contracts', () async {
      await trainerAuthService.logProgress(
        userId: 101,
        weightKg: 62.5,
        bodyFatPct: 19.8,
        workoutsCompleted: 1,
        workoutNotes: 'Squat PR: 55kg, 3x10 reps',
      );
      expect(mockApi.lastPostPath, equals('/api/fitness/trainer/progress'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);
      expect(mockApi.lastBody?['userId'], equals(101));
      expect(mockApi.lastBody?['weightKg'], equals(62.5));
      expect(mockApi.lastBody?['bodyFatPct'], equals(19.8));
      expect(mockApi.lastBody?['workoutNotes'], contains('Squat PR'));

      await trainerAuthService.markAttendance(
        bookingId: 55,
        status: 'PRESENT',
        notes: 'Session finished on time',
      );
      expect(mockApi.lastPostPath, equals('/api/fitness/trainer/attendance'));
      expect(mockApi.lastFitnessTrainerAuth, isTrue);
      expect(mockApi.lastBody?['bookingId'], equals(55));
      expect(mockApi.lastBody?['status'], equals('PRESENT'));
    });
  });

  group('Phase 11 - Member / User Fitness Service Contracts', () {
    late MockApiClient mockApi;
    late FitnessService fitnessService;

    setUp(() {
      mockApi = MockApiClient();
      fitnessService = FitnessService(mockApi);
    });

    test('Member classes browsing and spot booking', () async {
      await fitnessService.classes();
      expect(mockApi.lastGetPath, equals('/api/fitness/classes'));

      await fitnessService.classes(trainerId: 12);
      expect(mockApi.lastGetPath, equals('/api/fitness/trainers/12/classes'));

      await fitnessService.bookClass(78, paymentMethod: 'WALLET');
      expect(mockApi.lastPostPath, equals('/api/fitness/classes/78/book'));
      expect(mockApi.lastBody?['paymentMethod'], equals('WALLET'));
    });

    test('Member self progress logging and attendance history', () async {
      await fitnessService.logMyProgress(
        weightKg: 65.0,
        bodyFatPct: 20.5,
        workoutNotes: 'Morning 5km run + core work',
      );
      expect(mockApi.lastPostPath, equals('/api/fitness/my-progress'));
      expect(mockApi.lastBody?['weightKg'], equals(65.0));
      expect(mockApi.lastBody?['bodyFatPct'], equals(20.5));
      expect(mockApi.lastBody?['workoutNotes'], equals('Morning 5km run + core work'));

      await fitnessService.myAttendance();
      expect(mockApi.lastGetPath, equals('/api/fitness/attendance/me'));
    });
  });

  group('Phase 11 - Payment Service Fitness Order Contract', () {
    late MockApiClient mockApi;
    late PaymentService paymentService;

    setUp(() {
      mockApi = MockApiClient();
      paymentService = PaymentService(mockApi);
    });

    test('createFitnessBookingOrder sends type=FITNESS and bookingId', () async {
      await paymentService.createFitnessBookingOrder(88);
      expect(mockApi.lastPostPath, equals('/payment/create-order'));
      expect(mockApi.lastBody?['type'], equals('FITNESS'));
      expect(mockApi.lastBody?['bookingId'], equals(88));
    });
  });
}
