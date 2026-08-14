import 'api_client.dart';

class BuddyService {
  BuddyService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> state() => _api.get('/api/buddy/state');

  Future<Map<String, dynamic>> matches({
    required double latitude,
    required double longitude,
    required String destination,
    double radiusKm = 3,
  }) =>
      _api.get(
        '/api/buddy/matches?latitude=$latitude&longitude=$longitude&destination=${Uri.encodeComponent(destination)}&radiusKm=$radiusKm',
      );

  Future<Map<String, dynamic>> startAvailability({
    required double latitude,
    required double longitude,
    required String destination,
    int windowMinutes = 60,
  }) =>
      _api.post('/api/buddy/availability/start', body: {
        'latitude': latitude,
        'longitude': longitude,
        'destination': destination,
        'windowMinutes': windowMinutes,
      });

  Future<Map<String, dynamic>> stopAvailability() =>
      _api.post('/api/buddy/availability/stop', body: {});

  Future<Map<String, dynamic>> sendRequest(int availabilityId) =>
      _api.post('/api/buddy/request', body: {'availabilityId': availabilityId});

  Future<Map<String, dynamic>> acceptRequest(int id) =>
      _api.post('/api/buddy/request/$id/accept', body: {});

  Future<Map<String, dynamic>> rejectRequest(int id) =>
      _api.post('/api/buddy/request/$id/reject', body: {});
}

class ReminderService {
  ReminderService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() => _api.get('/api/reminders');

  Future<Map<String, dynamic>> add({
    required String title,
    String message = '',
    required String timeOfDay,
    String? dayOfWeek,
    String? reminderDate,
  }) =>
      _api.post('/api/reminders', body: {
        'title': title,
        'message': message,
        'timeOfDay': timeOfDay,
        if (dayOfWeek != null) 'dayOfWeek': dayOfWeek,
        if (reminderDate != null) 'reminderDate': reminderDate,
      });

  Future<Map<String, dynamic>> delete(int id) => _api.delete('/api/reminders/$id');

  Future<Map<String, dynamic>> toggle(int id) => _api.patch('/api/reminders/$id/toggle');
}

class ProfileService {
  ProfileService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> getProfile() => _api.get('/api/me');

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? homeAddress,
  }) =>
      _api.put('/api/me', body: {
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (homeAddress != null) 'homeAddress': homeAddress,
      });
}

class VideoService {
  VideoService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> videos() => _api.get('/api/videos');

  Future<Map<String, dynamic>> reels() => _api.get('/api/videos/reels');

  Future<Map<String, dynamic>> creatorFeed() => _api.get('/api/creator-hub/feed');
}

class WalletService {
  WalletService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> wallet() => _api.get('/api/wallet');

  Future<Map<String, dynamic>> redeem({required int cost, required String rewardName}) =>
      _api.post('/api/wallet/redeem', body: {'cost': cost, 'rewardName': rewardName});
}

class DoctorService {
  DoctorService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() => _api.get('/api/doctors');

  Future<Map<String, dynamic>> detail(int id) => _api.get('/api/doctors/$id');

  Future<Map<String, dynamic>> book(int id, {String notes = ''}) =>
      _api.post('/api/doctors/$id/appointments', body: {'notes': notes});

  Future<Map<String, dynamic>> myAppointments() => _api.get('/api/doctors/appointments/me');
}

class MarketplaceService {
  MarketplaceService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> providers({String? category}) {
    final q = category == null || category.isEmpty ? '' : '?category=$category';
    return _api.get('/api/marketplace/providers$q');
  }

  Future<Map<String, dynamic>> providerDetail(int id) =>
      _api.get('/api/marketplace/providers/$id');

  Future<Map<String, dynamic>> book(int id, {String note = ''}) =>
      _api.post('/api/marketplace/providers/$id/bookings', body: {'note': note});

  Future<Map<String, dynamic>> myBookings() => _api.get('/api/marketplace/bookings/me');
}

class FitnessService {
  FitnessService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> trainers() => _api.get('/api/fitness/trainers');

  Future<Map<String, dynamic>> trainerDetail(int id) => _api.get('/api/fitness/trainers/$id');

  Future<Map<String, dynamic>> book(int id, {String sessionType = 'ONLINE', String note = ''}) =>
      _api.post('/api/fitness/trainers/$id/bookings', body: {
        'sessionType': sessionType,
        'category': note,
      });

  Future<Map<String, dynamic>> myBookings() => _api.get('/api/fitness/bookings/me');
}

class WomenEventsService {
  WomenEventsService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> list() => _api.get('/api/women-events');

  Future<Map<String, dynamic>> detail(int id) => _api.get('/api/women-events/$id');

  Future<Map<String, dynamic>> register(int id) =>
      _api.post('/api/women-events/$id/register', body: {});

  Future<Map<String, dynamic>> myRegistrations() => _api.get('/api/women-events/registrations/me');
}

class JobBookingsService {
  JobBookingsService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> workerBookings() => _api.get('/api/job-bookings/worker/me');

  Future<Map<String, dynamic>> clientBookings() => _api.get('/api/job-bookings/client/me');
}

class FinancialLiteracyService {
  FinancialLiteracyService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> home() => _api.get('/api/financial-literacy');
}
