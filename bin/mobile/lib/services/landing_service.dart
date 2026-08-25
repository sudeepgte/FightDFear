import 'api_client.dart';

class LandingService {
  LandingService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> feed() =>
      _api.get('/api/landing/feed', auth: false);

  Future<Map<String, dynamic>> notifications() =>
      _api.get('/api/landing/notifications', auth: true);

  Future<Map<String, dynamic>> markNotificationsRead() =>
      _api.post('/api/landing/notifications/read', auth: true, body: {});
}
