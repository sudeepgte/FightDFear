import 'api_client.dart';

/// Martial Arts — browse, enroll, journey, attendance, online classes, payment.
class MartialArtsService {
  MartialArtsService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listCentres({String? q}) {
    final query = (q == null || q.trim().isEmpty)
        ? ''
        : '?q=${Uri.encodeQueryComponent(q.trim())}';
    return _api.get('/api/martial-arts/centres$query');
  }

  Future<Map<String, dynamic>> centreDetail(int id) =>
      _api.get('/api/martial-arts/centres/$id');

  Future<Map<String, dynamic>> myEnrollments() =>
      _api.get('/api/martial-arts/my-enrollments');

  Future<Map<String, dynamic>> enroll(Map<String, dynamic> body) =>
      _api.post('/api/martial-arts/enroll', body: body);

  Future<Map<String, dynamic>> trainingJourney() =>
      _api.get('/api/martial-arts/training-journey');

  Future<Map<String, dynamic>> myAttendance() =>
      _api.get('/api/martial-arts/my-attendance');

  Future<Map<String, dynamic>> onlineClasses() =>
      _api.get('/api/martial-arts/online-classes');

  Future<Map<String, dynamic>> checkInOnlineClass({
    required int onlineClassId,
    required String date,
  }) =>
      _api.post('/api/martial-arts/online-classes/checkin', body: {
        'onlineClassId': onlineClassId,
        'date': date,
      });

  Future<Map<String, dynamic>> respondInvitation({
    required int invitationId,
    required String action,
  }) =>
      _api.post('/api/martial-arts/online-classes/invitation/respond', body: {
        'invitationId': invitationId,
        'action': action,
      });

  Future<Map<String, dynamic>> createPaymentOrder(double amount) =>
      _api.post('/payment/create-order', body: {'amount': amount});

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> body) =>
      _api.post('/payment/verify', body: body);

  Future<({List<int> bytes, int statusCode, String? filename})> downloadCertificate(
          int enrollmentId) =>
      _api.getBytes('/api/martial-arts/enrollments/$enrollmentId/certificate');
}
