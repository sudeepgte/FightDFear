import 'package:http/http.dart' as http;

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

  Future<Map<String, dynamic>> list({
    String? q,
    String? city,
    String? specialization,
    String? language,
    double? maxFee,
    bool? online,
    bool? emergency,
    bool? instant,
    String? sort,
    int page = 0,
    int size = 50,
  }) {
    final params = <String, String>{
      'page': '$page',
      'size': '$size',
    };
    if (q != null && q.trim().isNotEmpty) params['q'] = q.trim();
    if (city != null && city.trim().isNotEmpty) params['city'] = city.trim();
    if (specialization != null && specialization.trim().isNotEmpty) {
      params['specialization'] = specialization.trim();
    }
    if (language != null && language.trim().isNotEmpty) params['language'] = language.trim();
    if (maxFee != null) params['maxFee'] = '$maxFee';
    if (online == true) params['online'] = 'true';
    if (emergency == true) params['emergency'] = 'true';
    if (instant == true) params['instant'] = 'true';
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    final query = params.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/doctors?$query');
  }

  Future<Map<String, dynamic>> detail(int id) => _api.get('/api/doctors/$id');

  Future<Map<String, dynamic>> book(
    int id, {
    String notes = '',
    String? appointmentTime,
    String? consultationType,
    String? reason,
    int? followUpOfId,
  }) =>
      _api.post('/api/doctors/$id/appointments', body: {
        'notes': notes,
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        if (appointmentTime != null && appointmentTime.isNotEmpty) 'appointmentTime': appointmentTime,
        if (consultationType != null && consultationType.isNotEmpty) 'consultationType': consultationType,
        if (followUpOfId != null) 'followUpOfId': '$followUpOfId',
      });

  Future<Map<String, dynamic>> myAppointments() => _api.get('/api/doctors/appointments/me');

  Future<Map<String, dynamic>> cancelAppointment(int id) =>
      _api.post('/api/doctors/appointments/$id/cancel', body: {});

  Future<Map<String, dynamic>> rescheduleAppointment(int id, {required String appointmentTime}) =>
      _api.post('/api/doctors/appointments/$id/reschedule', body: {
        'appointmentTime': appointmentTime,
      });

  Future<Map<String, dynamic>> receipt(int id) =>
      _api.get('/api/doctors/appointments/$id/receipt');

  Future<Map<String, dynamic>> requestInstant({String consultationType = 'VIDEO', String reason = ''}) =>
      _api.post('/api/doctors/instant/request', body: {
        'consultationType': consultationType,
        if (reason.isNotEmpty) 'reason': reason,
      });

  Future<Map<String, dynamic>> registerDeviceToken(String token, {String platform = 'android'}) =>
      _api.post('/api/doctors/device-token', body: {
        'token': token,
        'platform': platform,
      });

  Future<Map<String, dynamic>> joinAppointment(int id, {bool audioOnly = false}) =>
      _api.get('/api/doctors/appointments/$id/join?audioOnly=$audioOnly');

  Future<Map<String, dynamic>> reviews(int doctorId) => _api.get('/api/doctors/$doctorId/reviews');

  Future<Map<String, dynamic>> addReview(int doctorId, {required int rating, String comment = ''}) =>
      _api.post('/api/doctors/$doctorId/reviews', body: {
        'rating': rating,
        'comment': comment,
      });

  Future<Map<String, dynamic>> chatHistory(int doctorId, {int? userId}) {
    final q = userId == null ? '' : '?userId=$userId';
    return _api.get('/api/doctors/$doctorId/chat$q');
  }

  Future<Map<String, dynamic>> sendChat(int doctorId, {required String message, int? userId, String? attachmentPath}) =>
      _api.post('/api/doctors/$doctorId/chat', body: {
        'message': message,
        if (userId != null) 'userId': userId,
        if (attachmentPath != null) 'attachmentPath': attachmentPath,
      });

  Future<Map<String, dynamic>> instantMine() => _api.get('/api/doctors/instant/mine');

  Future<Map<String, dynamic>> addFavorite(int doctorId) =>
      _api.post('/api/doctors/favorites/$doctorId', body: {});

  Future<Map<String, dynamic>> removeFavorite(int doctorId) =>
      _api.delete('/api/doctors/favorites/$doctorId');

  Future<({List<int> bytes, int statusCode, String? filename})> prescriptionPdf(int appointmentId) =>
      _api.getBytes('/api/doctors/appointments/$appointmentId/prescription.pdf');

  Future<Map<String, dynamic>> uploadReport(int appointmentId, {required String filePath}) async {
    final name = filePath.split(RegExp(r'[\\/]')).last;
    final multipart = await http.MultipartFile.fromPath('file', filePath, filename: name);
    return _api.postMultipart(
      '/api/doctors/appointments/$appointmentId/reports',
      auth: true,
      files: [multipart],
    );
  }

  Future<Map<String, dynamic>> uploadChatFile(int doctorId, {required String filePath, int? userId}) async {
    final name = filePath.split(RegExp(r'[\\/]')).last;
    final multipart = await http.MultipartFile.fromPath('file', filePath, filename: name);
    return _api.postMultipart(
      '/api/doctors/$doctorId/chat-file',
      auth: true,
      fields: {if (userId != null) 'userId': '$userId'},
      files: [multipart],
    );
  }
}

class MarketplaceService {
  MarketplaceService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> categories() => _api.get('/api/marketplace/categories');

  Future<Map<String, dynamic>> providers({
    String? category,
    String? city,
    String? practiceArea,
    double? minFee,
    double? maxFee,
    bool? availableToday,
    bool? doorService,
    String? sort,
  }) {
    final q = <String, String>{};
    if (category != null && category.isNotEmpty) q['category'] = category;
    if (city != null && city.trim().isNotEmpty) q['city'] = city.trim();
    if (practiceArea != null && practiceArea.isNotEmpty && practiceArea != 'all') {
      q['practiceArea'] = practiceArea;
    }
    if (minFee != null) q['minFee'] = '$minFee';
    if (maxFee != null) q['maxFee'] = '$maxFee';
    if (availableToday == true) q['availableToday'] = 'true';
    if (doorService == true) q['doorService'] = 'true';
    if (sort != null && sort.isNotEmpty) q['sort'] = sort;
    final qs = q.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/marketplace/providers${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> providerDetail(int id) =>
      _api.get('/api/marketplace/providers/$id');

  Future<Map<String, dynamic>> providerSlots(int id, {String? date}) {
    final q = (date == null || date.isEmpty) ? '' : '?date=${Uri.encodeQueryComponent(date)}';
    return _api.get('/api/marketplace/providers/$id/slots$q');
  }

  Future<Map<String, dynamic>> addProviderReview(int id, {required int rating, String comment = ''}) =>
      _api.post('/api/marketplace/providers/$id/reviews', body: {'rating': rating, 'comment': comment});

  Future<Map<String, dynamic>> toggleLawyerFavorite(int id) =>
      _api.post('/api/marketplace/providers/$id/favorite');

  Future<Map<String, dynamic>> lawyerFavorites() =>
      _api.get('/api/marketplace/lawyers/favorites');

  Future<Map<String, dynamic>> cancelProviderBooking(int id) =>
      _api.post('/api/marketplace/bookings/$id/cancel');

  Future<Map<String, dynamic>> book(
    int id, {
    String note = '',
    String? requestedTime,
    double? totalAmount,
  }) =>
      _api.post('/api/marketplace/providers/$id/bookings', body: {
        'note': note,
        if (requestedTime != null && requestedTime.isNotEmpty)
          'requestedTime': requestedTime,
        if (totalAmount != null) 'totalAmount': totalAmount,
      });

  Future<Map<String, dynamic>> classDetail(int classId) =>
      _api.get('/api/marketplace/classes/$classId');

  Future<Map<String, dynamic>> enrollClass(int classId) =>
      _api.post('/api/marketplace/classes/$classId/enroll', body: {});

  Future<Map<String, dynamic>> cancelEnrollment(int enrollmentId) =>
      _api.post('/api/marketplace/enrollments/$enrollmentId/cancel', body: {});

  Future<Map<String, dynamic>> myEnrollments() =>
      _api.get('/api/marketplace/enrollments/me');

  Future<Map<String, dynamic>> myBookings() => _api.get('/api/marketplace/bookings/me');

  Future<Map<String, dynamic>> myJobApplication() =>
      _api.get('/api/marketplace/jobs/me');

  Future<Map<String, dynamic>> applyJob({
    required String category,
    required String subCategory,
    required double hourlyRate,
    String note = '',
    String? documentPath,
    String? documentName,
  }) async {
    final fields = {
      'jobCategory': category,
      'category': category,
      'jobSubCategory': subCategory,
      'subCategory': subCategory,
      'hourlyRate': hourlyRate.toString(),
      'note': note,
    };
    if (documentPath != null && documentPath.isNotEmpty) {
      final file = await http.MultipartFile.fromPath(
        'document',
        documentPath,
        filename: documentName,
      );
      return _api.postMultipart(
        '/api/marketplace/jobs/apply',
        auth: true,
        fields: fields,
        files: [file],
      );
    }
    return _api.post('/api/marketplace/jobs/apply', body: {
      ...fields,
      'hourlyRate': hourlyRate,
    });
  }

  Future<Map<String, dynamic>> workers({
    String category = 'all',
    String? city,
    double? minFee,
    double? maxFee,
    bool? availableToday,
    bool? doorService,
    String? sort,
  }) {
    final q = <String, String>{};
    if (category.isNotEmpty && category != 'all') q['category'] = category;
    if (city != null && city.trim().isNotEmpty) q['city'] = city.trim();
    if (minFee != null) q['minFee'] = '$minFee';
    if (maxFee != null) q['maxFee'] = '$maxFee';
    if (availableToday == true) q['availableToday'] = 'true';
    if (doorService == true) q['doorService'] = 'true';
    if (sort != null && sort.isNotEmpty) q['sort'] = sort;
    final qs = q.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/marketplace/workers${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> workerSlots(int id, {String? date}) {
    final q = (date == null || date.isEmpty) ? '' : '?date=${Uri.encodeQueryComponent(date)}';
    return _api.get('/api/marketplace/workers/$id/slots$q');
  }

  Future<Map<String, dynamic>> addWorkerReview(int id, {required int rating, String comment = ''}) =>
      _api.post('/api/marketplace/workers/$id/reviews', body: {'rating': rating, 'comment': comment});

  Future<Map<String, dynamic>> toggleWorkerFavorite(int id) =>
      _api.post('/api/marketplace/workers/$id/favorite');

  Future<Map<String, dynamic>> jobFavorites() =>
      _api.get('/api/marketplace/jobs/favorites');

  Future<Map<String, dynamic>> cancelWorkerBooking(int id) =>
      _api.post('/api/marketplace/workers/bookings/$id/cancel');

  Future<Map<String, dynamic>> bookingMessages(int bookingId) =>
      _api.get('/api/marketplace/bookings/$bookingId/messages');

  Future<Map<String, dynamic>> sendBookingMessage(int bookingId, String content) =>
      _api.post('/api/marketplace/bookings/$bookingId/messages', body: {
        'content': content,
      });

  Future<Map<String, dynamic>> workerDetail(int workerAppId) =>
      _api.get('/api/marketplace/workers/$workerAppId');

  Future<Map<String, dynamic>> bookWorker(
    int workerAppId, {
    required String bookingDate,
    required double totalAmount,
    int? hours,
    String note = '',
  }) =>
      _api.post('/api/marketplace/workers/$workerAppId/book', body: {
        'bookingDate': bookingDate,
        'totalAmount': totalAmount,
        'note': note,
        if (hours != null) 'hours': hours,
      });
}

class FitnessService {
  FitnessService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> trainers({String? city, String? sort}) {
    final q = <String>[];
    if (city != null && city.trim().isNotEmpty) {
      q.add('city=${Uri.encodeQueryComponent(city.trim())}');
    }
    if (sort != null && sort.isNotEmpty) {
      q.add('sort=${Uri.encodeQueryComponent(sort)}');
    }
    final qs = q.isEmpty ? '' : '?${q.join('&')}';
    return _api.get('/api/fitness/trainers$qs');
  }

  Future<Map<String, dynamic>> trainerDetail(int id) => _api.get('/api/fitness/trainers/$id');

  Future<Map<String, dynamic>> availableSlots(int id, {String? date}) {
    final qs = date != null && date.isNotEmpty ? '?date=${Uri.encodeQueryComponent(date)}' : '';
    return _api.get('/api/fitness/trainers/$id/available-slots$qs');
  }

  Future<Map<String, dynamic>> book(
    int id, {
    required String category,
    required String bookingDate,
    required String bookingTime,
    required String sessionType,
    required String duration,
    String note = '',
  }) =>
      _api.post('/api/fitness/trainers/$id/bookings', body: {
        'category': category,
        'bookingDate': bookingDate,
        'bookingTime': bookingTime,
        'sessionType': sessionType,
        'duration': duration,
        if (note.isNotEmpty) 'note': note,
      });

  Future<Map<String, dynamic>> submitReview(int bookingId, {required int rating, String comment = ''}) =>
      _api.post('/api/fitness/bookings/$bookingId/review', body: {
        'rating': rating,
        if (comment.isNotEmpty) 'comment': comment,
      });

  Future<Map<String, dynamic>> myBookings() => _api.get('/api/fitness/bookings/me');

  Future<Map<String, dynamic>> cancelBooking(int id) =>
      _api.post('/api/fitness/bookings/$id/cancel');

  Future<Map<String, dynamic>> getTrainerPackages(int trainerId) =>
      _api.get('/api/fitness/trainers/$trainerId/packages');

  Future<Map<String, dynamic>> bookPackage(int packageId) =>
      _api.post('/api/fitness/book-package', body: {'packageId': packageId});

  Future<Map<String, dynamic>> myProgress() =>
      _api.get('/api/fitness/my-progress');

  Future<Map<String, dynamic>> checkInWithQr({
    required String token,
    double? latitude,
    double? longitude,
  }) =>
      _api.post('/api/fitness/qr/check-in', body: {
        'token': token,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
}


class WomenEventsService {
  WomenEventsService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> categories() => _api.get('/api/women-events/categories');

  Future<Map<String, dynamic>> list({String? category, String? city, String? sort}) {
    final q = <String>[];
    if (category != null && category.isNotEmpty && category != 'all') {
      q.add('category=${Uri.encodeQueryComponent(category)}');
    }
    if (city != null && city.trim().isNotEmpty) {
      q.add('city=${Uri.encodeQueryComponent(city.trim())}');
    }
    if (sort != null && sort.isNotEmpty) {
      q.add('sort=${Uri.encodeQueryComponent(sort)}');
    }
    final qs = q.isEmpty ? '' : '?${q.join('&')}';
    return _api.get('/api/women-events$qs');
  }

  Future<Map<String, dynamic>> detail(int id) => _api.get('/api/women-events/$id');

  Future<Map<String, dynamic>> register(int id) =>
      _api.post('/api/women-events/$id/register', body: {});

  Future<Map<String, dynamic>> cancelRegistration(int registrationId) =>
      _api.post('/api/women-events/registrations/$registrationId/cancel');

  Future<Map<String, dynamic>> myRegistrations() => _api.get('/api/women-events/registrations/me');

  Future<Map<String, dynamic>> rateRegistration(int id, {required int rating, String review = ''}) =>
      _api.post('/api/women-events/registrations/$id/rate', body: {
        'rating': rating,
        'review': review,
      });
}

class JobBookingsService {
  JobBookingsService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> workerBookings() => _api.get('/api/job-bookings/worker/me');

  Future<Map<String, dynamic>> clientBookings() => _api.get('/api/job-bookings/client/me');

  Future<Map<String, dynamic>> updateStatus(int id, String status) =>
      _api.patch('/api/job-bookings/$id/status', body: {'status': status});

  Future<Map<String, dynamic>> updateNotes(int id, String coachNotes) =>
      _api.post('/api/job-bookings/$id/notes', body: {'coachNotes': coachNotes});

  Future<Map<String, dynamic>> cancel(int id, {String reason = ''}) =>
      _api.post('/api/job-bookings/$id/cancel', body: {'reason': reason});
}

class FinancialLiteracyService {
  FinancialLiteracyService(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> home({
    String? category,
    String? city,
    String? sort,
  }) {
    final q = <String, String>{};
    if (category != null && category.trim().isNotEmpty) q['category'] = category.trim();
    if (city != null && city.trim().isNotEmpty) q['city'] = city.trim();
    if (sort != null && sort.isNotEmpty) q['sort'] = sort;
    final qs = q.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/financial-literacy${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> video(int id) => _api.get('/api/financial-literacy/videos/$id');

  Future<Map<String, dynamic>> liveSession(int id) =>
      _api.get('/api/financial-literacy/live-sessions/$id');

  Future<Map<String, dynamic>> workshop(int id) =>
      _api.get('/api/financial-literacy/workshops/$id');

  Future<Map<String, dynamic>> registerLive(int id) =>
      _api.post('/api/financial-literacy/live-sessions/$id/register');

  Future<Map<String, dynamic>> registerWorkshop(int id) =>
      _api.post('/api/financial-literacy/workshops/$id/register');

  Future<Map<String, dynamic>> cancelEnrollment(int id) =>
      _api.post('/api/financial-literacy/enrollments/$id/cancel');

  Future<Map<String, dynamic>> myEnrollments() =>
      _api.get('/api/financial-literacy/my-enrollments');

  Future<Map<String, dynamic>> loans() => _api.get('/api/financial-literacy/loans');

  Future<Map<String, dynamic>> applyLoan(Map<String, dynamic> body) =>
      _api.post('/api/financial-literacy/loans', body: body);

  Future<Map<String, dynamic>> rateEnrollment(int id, {required int rating, String review = ''}) =>
      _api.post('/api/financial-literacy/enrollments/$id/rate', body: {
        'rating': rating,
        'review': review,
      });
}
