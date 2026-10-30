import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/creator_auth_service.dart';
import 'package:fight_d_fear/services/delivery_partner_auth_service.dart';
import 'package:fight_d_fear/services/entrepreneur_auth_service.dart';
import 'package:fight_d_fear/services/event_host_auth_service.dart';
import 'package:fight_d_fear/services/financial_educator_auth_service.dart';
import 'package:fight_d_fear/services/fitness_trainer_auth_service.dart';
import 'package:fight_d_fear/services/investor_auth_service.dart';
import 'package:fight_d_fear/services/marketplace_provider_auth_service.dart';
import 'package:fight_d_fear/services/women_jobs_auth_service.dart';
import 'package:fight_d_fear/services/women_products_seller_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Multi-Role Authentication Token Isolation Tests', () {
    test('Saving provider tokens does not overwrite Member auth_token', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      // 1. Establish Member session
      await api.saveToken('member-token-111');
      expect(await api.getToken(), 'member-token-111');
      expect(prefs.getString('auth_token'), 'member-token-111');

      // 2. Save all provider tokens
      await api.saveCreatorToken('creator-token-222');
      await api.saveFitnessTrainerToken('trainer-token-333');
      await api.saveEventHostToken('host-token-444');
      await api.saveDeliveryPartnerToken('delivery-token-555');
      await api.saveInvestorToken('investor-token-666');
      await api.saveEntrepreneurToken('entrepreneur-token-777');
      await api.saveWomenJobsToken('jobs-token-888');
      await api.saveWomenProductsSellerToken('seller-token-999');
      await api.saveFinancialEducatorToken('educator-token-101');
      await api.saveMarketplaceProviderToken('marketplace-token-202');

      // 3. Verify Member token is STILL completely intact
      expect(await api.getToken(), 'member-token-111');
      expect(prefs.getString('auth_token'), 'member-token-111');

      // 4. Verify each provider token is stored under its own dedicated key
      expect(await api.getCreatorToken(), 'creator-token-222');
      expect(prefs.getString('creator_auth_token'), 'creator-token-222');

      expect(await api.getFitnessTrainerToken(), 'trainer-token-333');
      expect(prefs.getString('fitness_trainer_auth_token'), 'trainer-token-333');

      expect(await api.getEventHostToken(), 'host-token-444');
      expect(prefs.getString('event_host_auth_token'), 'host-token-444');

      expect(await api.getDeliveryPartnerToken(), 'delivery-token-555');
      expect(prefs.getString('delivery_partner_auth_token'), 'delivery-token-555');

      expect(await api.getInvestorToken(), 'investor-token-666');
      expect(prefs.getString('investor_auth_token'), 'investor-token-666');

      expect(await api.getEntrepreneurToken(), 'entrepreneur-token-777');
      expect(prefs.getString('entrepreneur_auth_token'), 'entrepreneur-token-777');

      expect(await api.getWomenJobsToken(), 'jobs-token-888');
      expect(prefs.getString('women_jobs_auth_token'), 'jobs-token-888');

      expect(await api.getWomenProductsSellerToken(), 'seller-token-999');
      expect(prefs.getString('women_products_seller_auth_token'), 'seller-token-999');

      expect(await api.getFinancialEducatorToken(), 'educator-token-101');
      expect(prefs.getString('financial_educator_auth_token'), 'educator-token-101');

      expect(await api.getMarketplaceProviderToken(), 'marketplace-token-202');
      expect(prefs.getString('marketplace_provider_auth_token'), 'marketplace-token-202');
    });

    test('Clearing provider tokens does not clear or affect Member token', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      await api.saveToken('member-token-111');
      await api.saveCreatorToken('creator-token-222');
      await api.saveFitnessTrainerToken('trainer-token-333');
      await api.saveEventHostToken('host-token-444');
      await api.saveDeliveryPartnerToken('delivery-token-555');
      await api.saveInvestorToken('investor-token-666');
      await api.saveEntrepreneurToken('entrepreneur-token-777');
      await api.saveWomenJobsToken('jobs-token-888');
      await api.saveWomenProductsSellerToken('seller-token-999');
      await api.saveFinancialEducatorToken('educator-token-101');
      await api.saveMarketplaceProviderToken('marketplace-token-202');

      // Clear creator
      await api.clearCreatorToken();
      expect(await api.getCreatorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear trainer
      await api.clearFitnessTrainerToken();
      expect(await api.getFitnessTrainerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear event host
      await api.clearEventHostToken();
      expect(await api.getEventHostToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear delivery
      await api.clearDeliveryPartnerToken();
      expect(await api.getDeliveryPartnerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear investor
      await api.clearInvestorToken();
      expect(await api.getInvestorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear entrepreneur
      await api.clearEntrepreneurToken();
      expect(await api.getEntrepreneurToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear jobs
      await api.clearWomenJobsToken();
      expect(await api.getWomenJobsToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear seller
      await api.clearWomenProductsSellerToken();
      expect(await api.getWomenProductsSellerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear educator
      await api.clearFinancialEducatorToken();
      expect(await api.getFinancialEducatorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Clear marketplace
      await api.clearMarketplaceProviderToken();
      expect(await api.getMarketplaceProviderToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      // Final check: Member token is still intact
      expect(await api.getToken(), 'member-token-111');
      expect(prefs.getString('auth_token'), 'member-token-111');
    });

    test('Clearing Member token does not wipe Provider tokens', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      await api.saveToken('member-token-111');
      await api.saveFitnessTrainerToken('trainer-token-333');
      await api.saveCreatorToken('creator-token-222');

      // Member logs out
      await api.clearToken();
      expect(await api.getToken(), isNull);
      expect(prefs.getString('auth_token'), isNull);

      // Provider tokens remain intact
      expect(await api.getFitnessTrainerToken(), 'trainer-token-333');
      expect(await api.getCreatorToken(), 'creator-token-222');
    });

    test('Provider AuthService logout() methods clear only their dedicated token', () async {
      final prefs = await SharedPreferences.getInstance();
      ApiClient.setPreferences(prefs);
      final api = ApiClient('http://10.0.2.2:8084');

      await api.saveToken('member-token-111');
      await api.saveCreatorToken('creator-token-222');
      await api.saveFitnessTrainerToken('trainer-token-333');
      await api.saveEventHostToken('host-token-444');
      await api.saveDeliveryPartnerToken('delivery-token-555');
      await api.saveInvestorToken('investor-token-666');
      await api.saveEntrepreneurToken('entrepreneur-token-777');
      await api.saveWomenJobsToken('jobs-token-888');
      await api.saveWomenProductsSellerToken('seller-token-999');
      await api.saveFinancialEducatorToken('educator-token-101');
      await api.saveMarketplaceProviderToken('marketplace-token-202');

      // Test each service logout
      await FitnessTrainerAuthService(api).logout();
      expect(await api.getFitnessTrainerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await EventHostAuthService(api).logout();
      expect(await api.getEventHostToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await CreatorAuthService(api).logout();
      expect(await api.getCreatorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await DeliveryPartnerAuthService(api).logout();
      expect(await api.getDeliveryPartnerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await InvestorAuthService(api).logout();
      expect(await api.getInvestorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await EntrepreneurAuthService(api).logout();
      expect(await api.getEntrepreneurToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await WomenJobsAuthService(api).logout();
      expect(await api.getWomenJobsToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await WomenProductsSellerAuthService(api).logout();
      expect(await api.getWomenProductsSellerToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await FinancialEducatorAuthService(api).logout();
      expect(await api.getFinancialEducatorToken(), isNull);
      expect(await api.getToken(), 'member-token-111');

      await MarketplaceProviderAuthService(api).logout();
      expect(await api.getMarketplaceProviderToken(), isNull);
      expect(await api.getToken(), 'member-token-111');
    });
  });
}
