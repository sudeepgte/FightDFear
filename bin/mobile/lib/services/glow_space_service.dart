import 'api_client.dart';

class GlowSpaceService {
  GlowSpaceService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> salons({
    String? city,
    String? search,
    String? category,
    double? minFee,
    double? maxFee,
    bool? availableToday,
    bool? doorService,
    String? sort,
    double? lat,
    double? lng,
  }) {
    final params = <String, String>{};
    if (city != null && city.isNotEmpty) params['city'] = city;
    if (search != null && search.isNotEmpty) params['q'] = search;
    if (category != null && category.isNotEmpty) params['category'] = category;
    if (minFee != null) params['minFee'] = '$minFee';
    if (maxFee != null) params['maxFee'] = '$maxFee';
    if (availableToday == true) params['availableToday'] = 'true';
    if (doorService == true) params['doorService'] = 'true';
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (lat != null) params['lat'] = '$lat';
    if (lng != null) params['lng'] = '$lng';
    final qs = params.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/glow/salons${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> salonDetail(int id) => _api.get('/api/glow/salons/$id');

  Future<Map<String, dynamic>> salonSlots(int id, {String? date, int? durationMinutes}) {
    final q = <String>[];
    if (date != null && date.isNotEmpty) q.add('date=${Uri.encodeQueryComponent(date)}');
    if (durationMinutes != null) q.add('durationMinutes=$durationMinutes');
    final qs = q.isEmpty ? '' : '?${q.join('&')}';
    return _api.get('/api/glow/salons/$id/slots$qs');
  }

  Future<Map<String, dynamic>> addReview(int salonId, {required int rating, String comment = ''}) =>
      _api.post('/api/glow/salons/$salonId/reviews', body: {'rating': rating, 'comment': comment});

  Future<Map<String, dynamic>> toggleFavorite(int salonId) =>
      _api.post('/api/glow/salons/$salonId/favorite');

  Future<Map<String, dynamic>> favorites() => _api.get('/api/glow/favorites');
  Future<Map<String, dynamic>> treatments() => _api.get('/api/glow/treatments');
  Future<Map<String, dynamic>> stylists() => _api.get('/api/glow/stylists');
  Future<Map<String, dynamic>> offers() => _api.get('/api/glow/offers');
  Future<Map<String, dynamic>> categories() => _api.get('/api/glow/categories');
  Future<Map<String, dynamic>> services({String? category}) {
    final q = (category == null || category.isEmpty) ? '' : '?category=${Uri.encodeQueryComponent(category)}';
    return _api.get('/api/glow/services$q');
  }

  Future<Map<String, dynamic>> myBookings() => _api.get('/api/glow/bookings/me');

  Future<Map<String, dynamic>> cancelBooking(int id) =>
      _api.post('/api/glow/bookings/$id/cancel');

  Future<Map<String, dynamic>> rescheduleBooking(
    int id, {
    required String bookingDate,
    required String preferredTime,
  }) =>
      _api.post('/api/glow/bookings/$id/reschedule', body: {
        'bookingDate': bookingDate,
        'preferredTime': preferredTime,
      });

  Future<Map<String, dynamic>> bookingConfirmation(int id) =>
      _api.get('/api/glow/bookings/$id/confirmation');

  Future<Map<String, dynamic>> createBooking({
    required String itemType,
    required int itemId,
    required String bookingDate,
    required String preferredTime,
    required String bookingType,
    String? address,
    String? notes,
    String? emergencyContact,
    String? allergyInfo,
  }) {
    return _api.post('/api/glow/bookings', body: {
      'itemType': itemType,
      'itemId': itemId,
      'bookingDate': bookingDate,
      'preferredTime': preferredTime,
      'bookingType': bookingType,
      'address': address ?? '',
      'notes': notes ?? '',
      'emergencyContact': emergencyContact ?? '',
      'allergyInfo': allergyInfo ?? '',
    });
  }

  Future<Map<String, dynamic>> createPaymentOrder(int bookingId) =>
      _api.post('/payment/create-order', body: {
        'type': 'GLOW_BOOKING',
        'bookingId': bookingId,
      }, timeout: const Duration(seconds: 45));

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> body) =>
      _api.post('/payment/verify', body: body, timeout: const Duration(seconds: 45));
}

