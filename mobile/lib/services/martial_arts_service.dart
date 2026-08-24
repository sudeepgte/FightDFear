import 'api_client.dart';

/// Martial Arts — browse, enroll, journey, attendance, online classes, payment.
class MartialArtsService {
  MartialArtsService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listCentres({
    String? q,
    String? city,
    String? style,
    double? feeMax,
    bool? batchToday,
    bool? online,
    String? sort,
    double? lat,
    double? lng,
  }) {
    final params = <String, String>{};
    if (q != null && q.trim().isNotEmpty) params['q'] = q.trim();
    if (city != null && city.trim().isNotEmpty) params['city'] = city.trim();
    if (style != null && style.trim().isNotEmpty) params['style'] = style.trim();
    if (feeMax != null) params['feeMax'] = feeMax.toStringAsFixed(0);
    if (batchToday == true) params['batchToday'] = 'true';
    if (online == true) params['online'] = 'true';
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (lat != null) params['lat'] = lat.toString();
    if (lng != null) params['lng'] = lng.toString();
    final query = params.isEmpty
        ? ''
        : '?${params.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
    return _api.get('/api/martial-arts/centres$query');
  }

  Future<Map<String, dynamic>> centreDetail(int id) =>
      _api.get('/api/martial-arts/centres/$id');

  Future<Map<String, dynamic>> myEnrollments() =>
      _api.get('/api/martial-arts/my-enrollments');

  Future<Map<String, dynamic>> enroll(Map<String, dynamic> body) =>
      _api.post('/api/martial-arts/enroll', body: body);

  Future<Map<String, dynamic>> addFavorite(int centreId) =>
      _api.post('/api/martial-arts/favorites/$centreId');

  Future<Map<String, dynamic>> removeFavorite(int centreId) =>
      _api.delete('/api/martial-arts/favorites/$centreId');

  Future<Map<String, dynamic>> listReviews(int centreId) =>
      _api.get('/api/martial-arts/centres/$centreId/reviews');

  Future<Map<String, dynamic>> addReview(int centreId, {required int rating, String comment = ''}) =>
      _api.post('/api/martial-arts/centres/$centreId/reviews', body: {
        'rating': rating,
        'comment': comment,
      });

  Future<Map<String, dynamic>> cancelEnrollment(int id, {String? reason}) =>
      _api.post('/api/martial-arts/enrollments/$id/cancel', body: {'reason': reason ?? ''});

  Future<Map<String, dynamic>> transferEnrollment(int id, int batchId) =>
      _api.post('/api/martial-arts/enrollments/$id/transfer', body: {'batchId': batchId});

  Future<Map<String, dynamic>> joinOnlineClass(int id) =>
      _api.get('/api/martial-arts/online-classes/$id/join');

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

  Future<Map<String, dynamic>> createPaymentOrder(double amount, {int? enrollmentId}) =>
      _api.post('/payment/create-order', body: {
        if (enrollmentId != null) 'type': 'MARTIAL_ARTS',
        if (enrollmentId != null) 'enrollmentId': enrollmentId,
        if (enrollmentId == null) 'amount': amount,
      }, timeout: const Duration(seconds: 45));

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> body) =>
      _api.post('/payment/verify', body: body, timeout: const Duration(seconds: 45));

  Future<Map<String, dynamic>> qrCheckIn(String token) =>
      _api.post('/api/attendance/qr-checkin', body: {'token': token});

  Future<Map<String, dynamic>> myProgress() =>
      _api.get('/api/progress/my-progress');

  Future<Map<String, dynamic>> beltHierarchy() =>
      _api.get('/api/progress/belt-hierarchy');

  Future<Map<String, dynamic>> gradingHistory() =>
      _api.get('/api/progress/grading-history');

  Future<({List<int> bytes, int statusCode, String? filename})> downloadCertificate(
          int enrollmentId) =>
      _api.getBytes('/api/martial-arts/enrollments/$enrollmentId/certificate');
}

