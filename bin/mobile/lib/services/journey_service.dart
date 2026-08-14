import 'api_client.dart';

/// Journey Safety Tracker API — check-in timer with contact alerts.
class JourneyService {
  JourneyService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> getActive() => _api.get('/api/journey/active');

  Future<Map<String, dynamic>> start({
    required String destination,
    required String startFrom,
    required int expectedArrivalEpochMs,
    double? latitude,
    double? longitude,
  }) {
    final body = <String, dynamic>{
      'destination': destination,
      'startFrom': startFrom,
      'expectedArrivalEpochMs': expectedArrivalEpochMs,
    };
    if (latitude != null) body['latitude'] = latitude;
    if (longitude != null) body['longitude'] = longitude;
    return _api.post('/api/journey/start', body: body);
  }

  Future<Map<String, dynamic>> markSafe() =>
      _api.post('/api/journey/safe', body: <String, dynamic>{});

  Future<Map<String, dynamic>> cancel() =>
      _api.post('/api/journey/cancel', body: <String, dynamic>{});
}
