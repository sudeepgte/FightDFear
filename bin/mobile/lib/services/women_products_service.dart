import 'api_client.dart';

class WomenProductsService {
  WomenProductsService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> listProducts({String? category}) {
    final c = category == null || category.trim().isEmpty
        ? ''
        : '?category=${Uri.encodeQueryComponent(category.trim())}';
    return _api.get('/api/women-products$c');
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
  }) =>
      _api.post('/api/women-products/checkout/place', body: {
        'paymentMethod': 'COD',
        'shippingAddress': shippingAddress,
      });

  Future<Map<String, dynamic>> myOrders() =>
      _api.get('/api/women-products/my-orders');
}
