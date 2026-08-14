import 'api_client.dart';

/// SOS API wrapper — mirrors web sos-dashboard.jsp flow.
class SosService {
  SosService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> getActive() => _api.get('/api/sos/active');

  Future<Map<String, dynamic>> trigger({
    required double latitude,
    required double longitude,
  }) {
    return _api.post('/api/sos/trigger', body: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });
  }

  Future<Map<String, dynamic>> getStatus(int sosId) =>
      _api.get('/api/sos/status/$sosId');

  Future<Map<String, dynamic>> cancel(int sosId) =>
      _api.post('/api/sos/cancel/$sosId', body: <String, dynamic>{});

  Future<Map<String, dynamic>> history() => _api.get('/api/sos/history');
}
