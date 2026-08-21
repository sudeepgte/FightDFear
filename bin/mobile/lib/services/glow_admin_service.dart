import 'api_client.dart';

/// Admin glow salon/stylist approval (reuses admin JWT).
class GlowAdminService {
  GlowAdminService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listSalons({String status = 'pending'}) =>
      _api.get('/api/glow/admin/salons?status=$status', auth: false, adminAuth: true);

  Future<Map<String, dynamic>> approveSalon(int id) => _api.post(
        '/api/glow/admin/salons/$id/approve',
        auth: false,
        adminAuth: true,
      );

  Future<Map<String, dynamic>> rejectSalon(int id) => _api.post(
        '/api/glow/admin/salons/$id/reject',
        auth: false,
        adminAuth: true,
      );

  Future<Map<String, dynamic>> listStylists({String status = 'pending'}) =>
      _api.get('/api/glow/admin/stylists?status=$status', auth: false, adminAuth: true);

  Future<Map<String, dynamic>> approveStylist(int id) => _api.post(
        '/api/glow/admin/stylists/$id/approve',
        auth: false,
        adminAuth: true,
      );

  Future<Map<String, dynamic>> rejectStylist(int id) => _api.post(
        '/api/glow/admin/stylists/$id/reject',
        auth: false,
        adminAuth: true,
      );
}
