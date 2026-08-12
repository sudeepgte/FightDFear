import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class CreatorHubService {
  CreatorHubService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> feed({String? search, String? category, String? city, String? sort}) {
    final params = <String>[];
    if (search != null && search.isNotEmpty) params.add('search=${Uri.encodeComponent(search)}');
    if (category != null && category.isNotEmpty) params.add('category=${Uri.encodeComponent(category)}');
    if (city != null && city.isNotEmpty) params.add('city=${Uri.encodeComponent(city)}');
    if (sort != null && sort.isNotEmpty) params.add('sort=${Uri.encodeComponent(sort)}');
    final q = params.isEmpty ? '' : '?${params.join('&')}';
    return _api.get('/api/creator-hub/feed$q');
  }

  Future<Map<String, dynamic>> creatorProfile(int id) => _api.get('/api/creator-hub/creators/$id');

  Future<Map<String, dynamic>> comments(int postId) =>
      _api.get('/api/creator-hub/posts/$postId/comments');

  Future<Map<String, dynamic>> bookmarks() => _api.get('/api/creator-hub/bookmarks');

  Future<Map<String, dynamic>> dashboard() => _api.get('/api/creator-hub/dashboard');

  Future<Map<String, dynamic>> notifications() => _api.get('/api/creator-hub/notifications');

  Future<Map<String, dynamic>> like(int postId) =>
      _api.post('/api/creator-hub/posts/$postId/like', body: {});

  Future<Map<String, dynamic>> bookmark(int postId) =>
      _api.post('/api/creator-hub/posts/$postId/bookmark', body: {});

  Future<Map<String, dynamic>> view(int postId) =>
      _api.post('/api/creator-hub/posts/$postId/view', body: {});

  Future<Map<String, dynamic>> comment(int postId, String text) =>
      _api.post('/api/creator-hub/posts/$postId/comments', body: {'text': text});

  Future<Map<String, dynamic>> report(int postId, String reason) =>
      _api.post('/api/creator-hub/posts/$postId/report', body: {'reason': reason});

  Future<Map<String, dynamic>> follow(int creatorId) =>
      _api.post('/api/creator-hub/creators/$creatorId/follow', body: {});

  Future<Map<String, dynamic>> tip({required int creatorId, required double amount, String? message}) =>
      _api.post('/api/creator-hub/creators/tip', body: {
        'creatorId': creatorId,
        'amount': amount,
        if (message != null) 'message': message,
      });

  Future<Map<String, dynamic>> subscribe(int creatorId) =>
      _api.post('/api/creator-hub/creators/subscribe', body: {'creatorId': creatorId});

  Future<Map<String, dynamic>> unsubscribe(int creatorId) =>
      _api.post('/api/creator-hub/creators/$creatorId/unsubscribe', body: {});

  Future<Map<String, dynamic>> rateCreator(int creatorId, {required int rating, String review = ''}) =>
      _api.post('/api/creator-hub/creators/$creatorId/rate', body: {
        'rating': rating,
        'review': review,
      });

  Future<Map<String, dynamic>> unlock(int postId) =>
      _api.post('/api/creator-hub/posts/$postId/unlock', body: {});

  Future<Map<String, dynamic>> block(int creatorId) =>
      _api.post('/api/creator-hub/creators/$creatorId/block', body: {});

  Future<Map<String, dynamic>> cashout(int points) =>
      _api.post('/api/creator-hub/dashboard/cashout', body: {'points': points});

  Future<Map<String, dynamic>> claimAdRevenue() =>
      _api.post('/api/creator-hub/dashboard/claim-ad-revenue', body: {});

  Future<Map<String, dynamic>> togglePrivacy() =>
      _api.post('/api/creator-hub/dashboard/toggle-privacy', body: {});

  Future<Map<String, dynamic>> setSubscriptionPrice(double price) =>
      _api.post('/api/creator-hub/dashboard/subscription-price', body: {'price': price});

  Future<Map<String, dynamic>> publishDraft(int videoId) =>
      _api.post('/api/creator-hub/dashboard/publish-draft', body: {'videoId': videoId});

  Future<Map<String, dynamic>> deleteUpload(int videoId) =>
      _api.post('/api/creator-hub/dashboard/delete-upload', body: {'videoId': videoId});

  Future<Map<String, dynamic>> unblock(int blockedUserId) =>
      _api.post('/api/creator-hub/dashboard/unblock', body: {'blockedUserId': blockedUserId});

  Future<Map<String, dynamic>> applyCollab({required int campaignId, required String pitch}) =>
      _api.post('/api/creator-hub/collab/apply', body: {'campaignId': campaignId, 'pitch': pitch});

  Future<Map<String, dynamic>> upload({
    required String title,
    required String description,
    required String category,
    required String uploadType,
    required File file,
    File? thumbnail,
    String? location,
    String? hashtags,
    bool isDraft = false,
    bool isPaidContent = false,
    double price = 0,
    bool isSubscriberOnly = false,
    String? affiliateLink,
  }) async {
    final files = <http.MultipartFile>[
      await http.MultipartFile.fromPath('file', file.path),
    ];
    if (thumbnail != null) {
      files.add(await http.MultipartFile.fromPath('thumbnail', thumbnail.path));
    }
    return _api.postMultipart(
      '/api/creator-hub/upload',
      auth: true,
      fields: {
        'title': title,
        'description': description,
        'category': category,
        'uploadType': uploadType,
        'isDraft': isDraft.toString(),
        'isPaidContent': isPaidContent.toString(),
        'price': price.toString(),
        'isSubscriberOnly': isSubscriberOnly.toString(),
        if (location != null) 'location': location,
        if (hashtags != null) 'hashtags': hashtags,
        if (affiliateLink != null) 'affiliateLink': affiliateLink,
      },
      files: files,
    );
  }
}
