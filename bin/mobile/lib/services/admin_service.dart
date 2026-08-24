import 'api_client.dart';

class AdminService {
  AdminService(this._api);

  final ApiClient _api;

  Future<bool> isLoggedIn() async {
    final token = await _api.getAdminToken();
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // 1. Try unified admin endpoint (/api/admin/login)
    try {
      final res = await _api.post(
        '/api/admin/login',
        body: {'email': email.trim(), 'password': password},
        auth: false,
      );
      if (res['success'] == true && res['token'] != null) {
        await _api.saveAdminToken(res['token'].toString());
        return res;
      }
    } catch (_) {}

    // 2. Fallback to /api/martial-arts/admin/login (active on both cloud and local servers)
    try {
      final res2 = await _api.post(
        '/api/martial-arts/admin/login',
        body: {'email': email.trim(), 'password': password},
        auth: false,
      );
      if (res2['success'] == true && res2['token'] != null) {
        await _api.saveAdminToken(res2['token'].toString());
        return res2;
      }
      return res2;
    } catch (e) {
      return {'success': false, 'error': 'Cannot reach server: $e'};
    }
  }

  Future<void> logout() async {
    try {
      await _api.post('/api/admin/logout', adminAuth: true);
    } catch (_) {}
    await _api.clearAdminToken();
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final res = await _api.get('/api/admin/dashboard-stats', adminAuth: true);
      if (res['success'] == true) return res;
    } catch (_) {}

    // Fallback: Aggregate from legacy endpoints if unified endpoint returned 404 on cloud
    try {
      final salonsRes = await _api.get('/api/glow/admin/salons?status=pending', adminAuth: true);
      final centresRes = await _api.get('/api/martial-arts/admin/centres?status=pending', adminAuth: true);
      final pendingSalons = (salonsRes['salons'] as List? ?? []).length;
      final pendingCentres = (centresRes['centres'] as List? ?? []).length;
      return {
        'success': true,
        'stats': {
          'totalLiveSos': 0,
          'verifiedRoutes': 0,
          'totalDoctors': 0,
          'verifiedDoctors': 0,
          'pendingDoctors': 0,
          'totalSalons': pendingSalons,
          'verifiedSalons': 0,
          'pendingSalons': pendingSalons,
          'totalStylists': 0,
          'verifiedStylists': 0,
          'pendingStylists': 0,
          'totalCentres': pendingCentres,
          'approvedCentres': 0,
          'pendingCentres': pendingCentres,
          'totalTrainers': 0,
          'verifiedTrainers': 0,
          'pendingTrainers': 0,
          'fitnessBookings': 0,
          'totalUsers': 0,
          'verifiedUsers': 0,
          'pendingUsers': 0,
          'bannedUsers': 0,
          'totalEntrepreneurs': 0,
          'verifiedEntrepreneurs': 0,
          'pendingEntrepreneurs': 0,
          'totalInvestors': 0,
          'verifiedInvestors': 0,
          'pendingInvestors': 0,
          'totalProposals': 0,
          'verifiedProposals': 0,
          'pendingProposals': 0,
          'capitalRequested': 0.0,
          'capitalInvested': 0.0,
          'platformRevenue': 0.0,
          'totalWomenEvents': 0,
          'approvedWomenEvents': 0,
          'pendingWomenEvents': 0,
          'totalEventBookings': 0,
          'totalEventRevenue': 0.0,
          'totalVideos': 0,
          'reportedVideos': 0,
          'pendingCashouts': 0,
          'brandCollabs': 0,
          'pendingCreators': 0,
          'totalCourses': 0,
          'totalEducators': 0,
          'pendingEducators': 0,
          'workshopRegs': 0,
          'totalLawyers': 0,
          'pendingLawyers': 0,
          'pendingJobs': 0,
          'verifiedJobs': 0,
          'totalSellers': 0,
          'pendingSellers': 0,
          'totalDelivery': 0,
          'pendingDelivery': 0,
          'totalOrders': 0,
          'unreadContactMessages': 0,
        },
        'activities': [],
      };
    } catch (_) {
      return {'success': false, 'stats': {}, 'activities': []};
    }
  }

  Future<Map<String, dynamic>> getApprovals({
    String category = 'DOCTORS',
    String status = 'PENDING',
    String? search,
  }) async {
    final params = <String, String>{
      'category': category,
      'status': status,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    };
    final qs = Uri(queryParameters: params).query;
    try {
      final res = await _api.get('/api/admin/approvals?$qs', adminAuth: true);
      if (res['success'] == true) return res;
    } catch (_) {}

    // Fallback for legacy cloud endpoints
    try {
      if (category == 'SALONS') {
        final res = await _api.get('/api/glow/admin/salons?status=${status.toLowerCase()}', adminAuth: true);
        final list = (res['salons'] as List? ?? []).map((s) => {
          'id': s['id'],
          'name': s['name'] ?? '',
          'email': s['email'] ?? '',
          'phone': s['phone'] ?? '',
          'category': 'SALON',
          'status': status,
          'subtitle': s['city'] ?? '',
        }).toList();
        return {'success': true, 'items': list};
      } else if (category == 'CENTRES') {
        final res = await _api.get('/api/martial-arts/admin/centres?status=${status.toLowerCase()}', adminAuth: true);
        final list = (res['centres'] as List? ?? []).map((c) => {
          'id': c['id'],
          'name': c['name'] ?? '',
          'email': c['email'] ?? '',
          'phone': c['phone'] ?? '',
          'category': 'MARTIAL_ARTS',
          'status': status,
          'subtitle': c['location'] ?? '',
        }).toList();
        return {'success': true, 'items': list};
      }
    } catch (_) {}

    return {'success': true, 'items': []};
  }

  Future<Map<String, dynamic>> approve({
    required String category,
    required dynamic id,
  }) async {
    try {
      final res = await _api.post(
        '/api/admin/approve',
        body: {'category': category, 'id': id},
        adminAuth: true,
      );
      if (res['success'] == true) return res;
    } catch (_) {}

    // Legacy fallbacks
    try {
      if (category == 'SALONS') {
        return await _api.post('/api/glow/admin/salon/$id/approve', adminAuth: true);
      } else if (category == 'CENTRES') {
        return await _api.post('/api/martial-arts/admin/centres/$id/approve', adminAuth: true);
      }
    } catch (_) {}

    return {'success': false, 'error': 'Failed to approve'};
  }

  Future<Map<String, dynamic>> reject({
    required String category,
    required dynamic id,
    String? reason,
  }) async {
    try {
      final res = await _api.post(
        '/api/admin/reject',
        body: {'category': category, 'id': id, 'reason': reason},
        adminAuth: true,
      );
      if (res['success'] == true) return res;
    } catch (_) {}

    // Legacy fallbacks
    try {
      if (category == 'SALONS') {
        return await _api.post('/api/glow/admin/salon/$id/reject', body: {'reason': reason}, adminAuth: true);
      } else if (category == 'CENTRES') {
        return await _api.post('/api/martial-arts/admin/centres/$id/reject', body: {'reason': reason}, adminAuth: true);
      }
    } catch (_) {}

    return {'success': false, 'error': 'Failed to reject'};
  }

  Future<Map<String, dynamic>> getSosAlerts() async {
    return _api.get('/api/admin/sos-alerts', adminAuth: true);
  }

  Future<Map<String, dynamic>> resolveSos(dynamic id) async {
    return _api.post('/api/admin/sos/$id/resolve', adminAuth: true);
  }

  Future<Map<String, dynamic>> getReportedVideos() async {
    return _api.get('/api/admin/reported-videos', adminAuth: true);
  }

  Future<Map<String, dynamic>> dismissReport(dynamic id) async {
    return _api.post('/api/admin/reported-videos/$id/dismiss', adminAuth: true);
  }

  Future<Map<String, dynamic>> getBroadcasts() async {
    return _api.get('/api/admin/broadcasts', adminAuth: true);
  }

  Future<Map<String, dynamic>> sendBroadcast({
    required String title,
    required String message,
    String targetAudience = 'ALL',
  }) async {
    return _api.post(
      '/api/admin/broadcast',
      body: {
        'title': title,
        'message': message,
        'targetAudience': targetAudience,
      },
      adminAuth: true,
    );
  }

  Future<Map<String, dynamic>> getContactMessages() async {
    return _api.get('/api/admin/contact-messages', adminAuth: true);
  }

  Future<Map<String, dynamic>> markContactMessageRead(dynamic id) async {
    return _api.post('/api/admin/contact-messages/$id/mark-read', adminAuth: true);
  }

  Future<Map<String, dynamic>> toggleUserBan(dynamic id) async {
    return _api.post('/api/admin/users/$id/toggle-ban', adminAuth: true);
  }
}
