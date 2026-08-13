import 'api_client.dart';

class GlowSpaceService {
  GlowSpaceService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> salons() => _api.get('/api/glow/salons');
  Future<Map<String, dynamic>> salonDetail(int id) => _api.get('/api/glow/salons/$id');
  Future<Map<String, dynamic>> treatments() => _api.get('/api/glow/treatments');
  Future<Map<String, dynamic>> stylists() => _api.get('/api/glow/stylists');
  Future<Map<String, dynamic>> offers() => _api.get('/api/glow/offers');
  Future<Map<String, dynamic>> myBookings() => _api.get('/api/glow/bookings/me');

  Future<Map<String, dynamic>> createBooking({
    required String itemType,
    required int itemId,
    required String bookingDate, // YYYY-MM-DD
    required String preferredTime, // HH:mm
    required String bookingType, // ONLINE or DOOR
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
}
