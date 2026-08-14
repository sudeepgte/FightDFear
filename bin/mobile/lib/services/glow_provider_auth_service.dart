import 'api_client.dart';

class GlowProviderAuthService {
  GlowProviderAuthService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> registerSalon({
    required String name,
    required String username,
    required String password,
    required String confirmPassword,
    String? phone,
    String? city,
    String? address,
    String? bio,
    String? availabilityHours,
  }) {
    return _api.post(
      '/api/glow/provider/register/salon',
      auth: false,
      body: {
        'name': name.trim(),
        'username': username.trim().toLowerCase(),
        'password': password,
        'confirmPassword': confirmPassword,
        'phone': phone?.trim() ?? '',
        'city': city?.trim() ?? '',
        'address': address?.trim() ?? '',
        'bio': bio?.trim() ?? '',
        'availabilityHours': availabilityHours?.trim() ?? '',
      },
    );
  }

  Future<Map<String, dynamic>> registerStylist({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    String? contactNumber,
    String? specialization,
    String? bio,
    String? availabilityHours,
  }) {
    return _api.post(
      '/api/glow/provider/register/stylist',
      auth: false,
      body: {
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'confirmPassword': confirmPassword,
        'contactNumber': contactNumber?.trim() ?? '',
        'specialization': specialization?.trim() ?? '',
        'bio': bio?.trim() ?? '',
        'availabilityHours': availabilityHours?.trim() ?? '',
      },
    );
  }
}
