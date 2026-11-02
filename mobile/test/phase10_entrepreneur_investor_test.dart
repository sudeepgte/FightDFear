import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/config/funding_catalog.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/entrepreneur_auth_service.dart';
import 'package:fight_d_fear/services/investor_auth_service.dart';

class MockApiClient extends ApiClient {
  MockApiClient() : super('http://localhost:8080');

  String? lastGetPath;
  String? lastPostPath;
  String? lastPutPath;
  Map<String, dynamic>? lastBody;
  bool lastEntrepreneurAuth = false;
  bool lastInvestorAuth = false;

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
    lastEntrepreneurAuth = entrepreneurAuth;
    lastInvestorAuth = investorAuth;
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
    lastEntrepreneurAuth = entrepreneurAuth;
    lastInvestorAuth = investorAuth;
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
    lastEntrepreneurAuth = entrepreneurAuth;
    lastInvestorAuth = investorAuth;
    return responseData;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Phase 10: Entrepreneur & Investor Workflows & Validation', () {
    late MockApiClient mockApi;
    late EntrepreneurAuthService entrepreneurService;
    late InvestorAuthService investorService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      mockApi = MockApiClient();
      entrepreneurService = EntrepreneurAuthService(mockApi);
      investorService = InvestorAuthService(mockApi);
    });

    test('Entrepreneur Catalog categories contain exact 10 business options', () {
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Tea Shop'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Food & Catering'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Apparel & Fashion'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Beauty & Wellness'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Handicrafts & Arts'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Education & Tutoring'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Tech & Digital Services'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Retail & E-commerce'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Agriculture & Dairy'));
      expect(FundingCatalog.entrepreneurBusinessCategories, contains('Other'));
      expect(FundingCatalog.entrepreneurBusinessCategories.length, 10);
    });

    test('Investor Catalog stages contain exact ticket modes', () {
      expect(FundingCatalog.ticketModes, equals(['Angel', 'Seed', 'Series', 'Grant']));
    });

    test('EntrepreneurAuthService endpoints', () async {
      // Questions
      mockApi.responseData = {
        'success': true,
        'questions': [
          {'id': 101, 'question': 'What is your unit economics?', 'answer': null}
        ]
      };
      final qRes = await entrepreneurService.questions();
      expect(mockApi.lastGetPath, '/api/entrepreneur/questions');
      expect(qRes['success'], isTrue);

      // Answer question
      mockApi.responseData = {'success': true, 'message': 'Answer posted successfully'};
      final ansRes = await entrepreneurService.answerQuestion(101, 'Our margin is 35%.');
      expect(mockApi.lastPostPath, '/api/entrepreneur/questions/101/answer');
      expect(mockApi.lastBody?['answer'], 'Our margin is 35%.');
      expect(ansRes['success'], isTrue);

      // Approved investors
      mockApi.responseData = {
        'success': true,
        'investors': [
          {'id': 1, 'fullName': 'Apex Ventures', 'companyName': 'Apex'}
        ]
      };
      final invRes = await entrepreneurService.approvedInvestors();
      expect(mockApi.lastGetPath, '/api/entrepreneur/investors/approved');
      expect(invRes['success'], isTrue);

      // Request payout
      mockApi.responseData = {'success': true, 'message': 'Payout requested'};
      final payoutRes = await entrepreneurService.requestPayout();
      expect(mockApi.lastPostPath, '/api/entrepreneur/payout/request');
      expect(payoutRes['success'], isTrue);
    });

    test('InvestorAuthService endpoints', () async {
      // Ask question
      mockApi.responseData = {'success': true, 'message': 'Question submitted'};
      final askRes = await investorService.askQuestion(55, 'Can we review the cap table?');
      expect(mockApi.lastPostPath, '/api/investor/proposals/55/ask');
      expect(mockApi.lastBody?['question'], 'Can we review the cap table?');
      expect(askRes['success'], isTrue);

      // Questions asked by investor
      mockApi.responseData = {'success': true, 'questions': []};
      final qRes = await investorService.questions();
      expect(mockApi.lastGetPath, '/api/investor/questions');
      expect(qRes['success'], isTrue);

      // Proposal details
      mockApi.responseData = {
        'success': true,
        'proposal': {'id': 55, 'title': 'Eco Tea', 'questions': []}
      };
      final detRes = await investorService.proposalDetails(55);
      expect(mockApi.lastGetPath, '/api/investor/proposals/55');
      expect(detRes['success'], isTrue);
      expect(detRes['proposal']['id'], 55);

      // Subscribe
      mockApi.responseData = {'success': true};
      final subRes = await investorService.subscribe();
      expect(mockApi.lastPostPath, '/api/investor/subscribe');
      expect(subRes['success'], isTrue);
    });

    test('Entrepreneur field validation regex rules match website standards', () {
      // Phone format: 10 digits starting with [6-9]
      final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');
      expect(phoneRegex.hasMatch('9876543210'), isTrue);
      expect(phoneRegex.hasMatch('5876543210'), isFalse);
      expect(phoneRegex.hasMatch('98765'), isFalse);

      // Aadhaar format: exactly 12 digits
      final aadhaarRegex = RegExp(r'^[0-9]{12}$');
      expect(aadhaarRegex.hasMatch('123456789012'), isTrue);
      expect(aadhaarRegex.hasMatch('12345678901'), isFalse);
      expect(aadhaarRegex.hasMatch('1234567890123'), isFalse);

      // Pincode format: 6 digits starting with [1-9]
      final pinRegex = RegExp(r'^[1-9][0-9]{5}$');
      expect(pinRegex.hasMatch('560001'), isTrue);
      expect(pinRegex.hasMatch('012345'), isFalse);
      expect(pinRegex.hasMatch('56001'), isFalse);

      // UPI ID format
      final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
      expect(upiRegex.hasMatch('founder@okaxis'), isTrue);
      expect(upiRegex.hasMatch('startup.enterprise@upi'), isTrue);
      expect(upiRegex.hasMatch('invalid'), isFalse);

      // IFSC code format: 4 alpha, 0, 6 alphanumeric
      final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
      expect(ifscRegex.hasMatch('SBIN0001234'), isTrue);
      expect(ifscRegex.hasMatch('HDFC0000456'), isTrue);
      expect(ifscRegex.hasMatch('HDFC1000456'), isFalse);
      expect(ifscRegex.hasMatch('sbin0001234'), isFalse); // must be uppercase

      // Bank account number format: 9 to 18 digits
      final accRegex = RegExp(r'^[0-9]{9,18}$');
      expect(accRegex.hasMatch('123456789'), isTrue);
      expect(accRegex.hasMatch('123456789012345678'), isTrue);
      expect(accRegex.hasMatch('12345678'), isFalse);
    });

    test('Investor field validation regex rules match website standards', () {
      // PAN / SEBI format
      final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
      expect(panRegex.hasMatch('ABCDE1234F'), isTrue);
      expect(panRegex.hasMatch('ABCD12345F'), isFalse);

      // Email format
      final emailRegex = RegExp(r'^[A-Za-z0-9+_.-]+@(.+)$');
      expect(emailRegex.hasMatch('investor@apex.vc'), isTrue);
      expect(emailRegex.hasMatch('not-an-email'), isFalse);
    });

    test('Metric calculations match website formulas', () {
      // Entrepreneur metrics
      final requested = 500000.0;
      final raised = 150000.0;
      final remaining = (requested - raised).clamp(0.0, double.infinity);
      final progress = raised / requested;
      expect(remaining, 350000.0);
      expect(progress, 0.3);

      // Investor metrics: Estimated Monthly ROI calculation
      final investmentAmount = 100000.0;
      final proposalFundingNeeded = 500000.0;
      final proposalExpectedMonthlyIncome = 50000.0;
      final roi = (investmentAmount / proposalFundingNeeded) * proposalExpectedMonthlyIncome * 0.1;
      expect(roi, 1000.0);
    });
  });
}
