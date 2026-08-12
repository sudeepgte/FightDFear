import 'api_client.dart';

class WomenProductsService {
  WomenProductsService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listProducts({
    String? category,
    String? city,
    double? maxPrice,
    bool? inStock,
    String? sort,
  }) {
    final q = <String, String>{};
    if (category != null && category.trim().isNotEmpty) q['category'] = category.trim();
    if (city != null && city.trim().isNotEmpty) q['city'] = city.trim();
    if (maxPrice != null) q['maxPrice'] = '$maxPrice';
    if (inStock == true) q['inStock'] = 'true';
    if (sort != null && sort.isNotEmpty) q['sort'] = sort;
    final qs = q.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return _api.get('/api/women-products${qs.isEmpty ? '' : '?$qs'}');
  }

  Future<Map<String, dynamic>> productDetail(int id) =>
      _api.get('/api/women-products/$id');

  Future<Map<String, dynamic>> cart() => _api.get('/api/women-products/cart');

  Future<Map<String, dynamic>> addToCart({
    required int productId,
    int quantity = 1,
  }) =>
      _api.post('/api/women-products/cart/add', body: {
        'productId': productId,
        'quantity': quantity,
      });

  Future<Map<String, dynamic>> updateCart({
    required int cartItemId,
    required int quantity,
  }) =>
      _api.post('/api/women-products/cart/$cartItemId/update', body: {
        'quantity': quantity,
      });

  Future<Map<String, dynamic>> removeCart(int cartItemId) =>
      _api.post('/api/women-products/cart/$cartItemId/remove', body: {});

  Future<Map<String, dynamic>> wishlist() =>
      _api.get('/api/women-products/wishlist');

  Future<Map<String, dynamic>> toggleWishlist(int productId) =>
      _api.post('/api/women-products/wishlist/toggle', body: {
        'productId': productId,
      });

  Future<Map<String, dynamic>> placeCodOrder({
    required String shippingAddress,
    String paymentMethod = 'COD',
  }) =>
      _api.post('/api/women-products/checkout/place', body: {
        'paymentMethod': paymentMethod,
        'shippingAddress': shippingAddress,
      });

  Future<Map<String, dynamic>> rateOrder(int id, {required int rating, String review = ''}) =>
      _api.post('/api/women-products/orders/$id/rate', body: {
        'rating': rating,
        'review': review,
      });

  Future<Map<String, dynamic>> myOrders() =>
      _api.get('/api/women-products/my-orders');

  Future<Map<String, dynamic>> cancelOrder(int id) =>
      _api.post('/api/women-products/orders/$id/cancel');

  Future<Map<String, dynamic>> trackOrder(int id) =>
      _api.get('/api/women-products/orders/$id/track');
}
