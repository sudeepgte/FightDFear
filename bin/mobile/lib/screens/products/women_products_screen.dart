import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/payment_service.dart';
import '../../services/women_products_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_payment_checkout.dart';
import 'order_live_tracking_screen.dart';
import 'women_product_detail_screen.dart';

class WomenProductsScreen extends StatefulWidget {
  const WomenProductsScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<WomenProductsScreen> createState() => _WomenProductsScreenState();
}

class _WomenProductsScreenState extends State<WomenProductsScreen>
    with SingleTickerProviderStateMixin {
  late final WomenProductsService _api;
  late final ModulePaymentCheckout _checkout;
  late final TabController _tabs;

  bool _loadingProducts = true;
  bool _loadingCart = false;
  bool _loadingOrders = false;
  String? _error;
  String _category = '';
  final _cityFilter = TextEditingController();
  bool _inStock = false;
  String _sort = 'newest';
  double? _maxPrice;
  final _categoryOptions = SellerCatalog.browseFilters;

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cartItems = [];
  double _cartTotal = 0;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    final api = context.read<AuthState>().api;
    _api = WomenProductsService(api);
    _checkout = ModulePaymentCheckout(PaymentService(api));
    _checkout.bind(
      onSuccess: (r) => _checkout.handleSuccess(context, r),
      onError: (r) => _checkout.handleError(r),
    );
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) {
        _loadCart();
      } else if (_tabs.index == 2) {
        _loadOrders();
      }
    });
    _loadProducts();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _cityFilter.dispose();
    _checkout.dispose();
    super.dispose();
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loadingProducts = true;
      _error = null;
    });
    try {
      final res = await _api.listProducts(
        category: _category.isEmpty ? null : _category,
        city: _cityFilter.text.trim().isEmpty ? null : _cityFilter.text.trim(),
        maxPrice: _maxPrice,
        inStock: _inStock ? true : null,
        sort: _sort,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['products'];
        _products = raw is List
            ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
      } else {
        _error = res['error']?.toString() ?? 'Failed to load products';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loadingProducts = false);
  }

  Future<void> _loadCart() async {
    setState(() => _loadingCart = true);
    try {
      final res = await _api.cart();
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['items'];
        _cartItems = raw is List
            ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
        _cartTotal = (res['total'] is num) ? (res['total'] as num).toDouble() : 0;
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingCart = false);
  }

  Future<void> _loadOrders() async {
    setState(() => _loadingOrders = true);
    try {
      final res = await _api.myOrders();
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['orders'];
        _orders = raw is List
            ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingOrders = false);
  }

  Future<void> _toggleWishlist(int productId) async {
    await _api.toggleWishlist(productId);
    await _loadProducts();
  }

  Future<void> _addToCart(int productId) async {
    final res = await _api.addToCart(productId: productId, quantity: 1);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Added to cart')),
    );
    await _loadProducts();
    await _loadCart();
  }

  Future<void> _placeOrder() async {
    final ctrl = TextEditingController();
    String method = 'COD';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Checkout'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: ctrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter full shipping address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'COD', label: Text('Cash on delivery')),
                    ButtonSegment(value: 'ONLINE', label: Text('Pay online')),
                  ],
                  selected: {method},
                  onSelectionChanged: (s) => setLocal(() => method = s.first),
                ),
                const Text(
                  SellerCatalog.cancelPolicy,
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(method == 'ONLINE' ? 'Place & pay' : 'Place COD'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final address = ctrl.text.trim();
    if (address.length < 8) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a complete delivery address.')),
      );
      return;
    }
    final res = await _api.placeCodOrder(shippingAddress: address, paymentMethod: method);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'Order placed')),
      );
      _tabs.animateTo(2);
      await _loadCart();
      await _loadOrders();
      if (res['paymentRequired'] == true) {
        for (final o in _orders) {
          if (o['needsPayment'] == true) {
            await _payOrder(o);
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Could not place order')),
      );
    }
  }

  Future<void> _payOrder(Map<String, dynamic> o) async {
    final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    final amount = (o['totalPrice'] is num) ? (o['totalPrice'] as num).toDouble() : 0.0;
    if (id == null || amount <= 0) return;
    await _checkout.pay(
      context: context,
      amount: amount,
      description: 'Women Products · Order #$id',
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'WOMEN_PRODUCT',
        'orderId': id,
        'targetId': id,
        'amount': amount,
      },
      onSuccess: () {
        _loadOrders();
      },
    );
  }

  Future<void> _writeReview(Map<String, dynamic> o) async {
    final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    if (id == null) return;
    int rating = 5;
    final comment = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Rate this order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: rating,
                decoration: const InputDecoration(labelText: 'Rating', border: OutlineInputBorder()),
                items: List.generate(
                  5,
                  (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1} star${i == 0 ? '' : 's'}')),
                ),
                onChanged: (v) => setLocal(() => rating = v ?? 5),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: comment,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'How was the product and delivery?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Submit')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final res = await _api.rateOrder(id, rating: rating, review: comment.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Thanks for the review'
            : (res['error']?.toString() ?? 'Could not save review')),
      ),
    );
    if (res['success'] == true) _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WomenProductsScreen.navy,
        elevation: 0.5,
        title: const Text('Women Products', style: TextStyle(fontWeight: FontWeight.w700)),
        bottom: TabBar(
          controller: _tabs,
          labelColor: WomenProductsScreen.primary,
          unselectedLabelColor: WomenProductsScreen.textGray,
          indicatorColor: WomenProductsScreen.primary,
          tabs: const [
            Tab(text: 'Shop'),
            Tab(text: 'Cart'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildShop(),
          _buildCart(),
          _buildOrders(),
        ],
      ),
    );
  }

  Widget _buildShop() {
    return Column(
      children: [
        const SizedBox(height: 10),
        CategoryPillBar(
          options: _categoryOptions,
          selected: _category,
          onSelected: (v) async {
            setState(() => _category = v);
            await _loadProducts();
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TextField(
            controller: _cityFilter,
            decoration: InputDecoration(
              hintText: 'City',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: _loadProducts),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (_) => _loadProducts(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
          child: Wrap(
            spacing: 6,
            children: [
              FilterChip(
                label: const Text('In stock'),
                selected: _inStock,
                onSelected: (v) {
                  setState(() => _inStock = v);
                  _loadProducts();
                },
              ),
              ChoiceChip(
                label: const Text('Newest'),
                selected: _sort == 'newest',
                onSelected: (_) {
                  setState(() => _sort = 'newest');
                  _loadProducts();
                },
              ),
              ChoiceChip(
                label: const Text('Top rated'),
                selected: _sort == 'rating',
                onSelected: (_) {
                  setState(() => _sort = 'rating');
                  _loadProducts();
                },
              ),
              ChoiceChip(
                label: const Text('Price'),
                selected: _sort == 'price',
                onSelected: (_) {
                  setState(() => _sort = 'price');
                  _loadProducts();
                },
              ),
              ChoiceChip(
                label: const Text('Under ₹500'),
                selected: _maxPrice == 500,
                onSelected: (on) {
                  setState(() => _maxPrice = on ? 500 : null);
                  _loadProducts();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Showing ${_products.length} products from approved shops',
              style: const TextStyle(color: WomenProductsScreen.textGray, fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadProducts,
            color: WomenProductsScreen.primary,
            child: _loadingProducts
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? ListView(
                        children: [
                          const SizedBox(height: 120),
                          Center(child: Text(_error!, style: const TextStyle(color: Colors.red))),
                        ],
                      )
                    : _products.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('No products found')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                            itemCount: _products.length,
                            itemBuilder: (context, i) {
                              final p = _products[i];
                              final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
                              final imageUrl = _mediaUrl(p['imagePath']?.toString());
                              final inWishlist = p['inWishlist'] == true;
                              final inCart = p['inCart'] == true;
                              final price = (p['price'] is num) ? (p['price'] as num).toDouble() : 0.0;
                              return DetailListingCard(
                                title: p['name']?.toString() ?? 'Product',
                                eyebrow: p['category']?.toString() ?? p['brand']?.toString() ?? 'Product',
                                location: p['brand']?.toString(),
                                photoUrl: imageUrl.isEmpty ? null : imageUrl,
                                showMediaActions: true,
                                showVideoAction: false,
                                chatLabel: inWishlist ? 'Saved' : 'Wishlist',
                                chatIcon: inWishlist ? Icons.favorite : Icons.favorite_border,
                                callLabel: inCart ? 'Add more' : 'Cart',
                                callIcon: Icons.shopping_cart_outlined,
                                onChat: id == null ? null : () => _toggleWishlist(id),
                                onCall: id == null ? null : () => _addToCart(id),
                                tags: [
                                  DetailTag(
                                    label: '₹${price.toStringAsFixed(0)}',
                                    icon: Icons.currency_rupee,
                                    background: const Color(0xFFFFE4E6),
                                    foreground: WomenProductsScreen.primary,
                                  ),
                                  if (p['rating'] != null)
                                    DetailTag(
                                      label: '${p['rating']}',
                                      icon: Icons.star,
                                      background: const Color(0xFFFEF3C7),
                                      foreground: const Color(0xFFB45309),
                                    ),
                                  if (inWishlist)
                                    const DetailTag(
                                      label: 'Wishlist',
                                      icon: Icons.favorite,
                                      background: Color(0xFFFFE4E6),
                                      foreground: Color(0xFFBE123C),
                                    ),
                                  if (inCart)
                                    const DetailTag(
                                      label: 'In cart',
                                      icon: Icons.shopping_cart_outlined,
                                      background: Color(0xFFDCFCE7),
                                      foreground: Color(0xFF166534),
                                    ),
                                ],
                                primaryLabel: 'View Product & Buy',
                                onPrimary: id == null
                                    ? null
                                    : () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => WomenProductDetailScreen(productId: id),
                                          ),
                                        );
                                        await _loadProducts();
                                        await _loadCart();
                                      },
                              );
                            },
                          ),
          ),
        ),
      ],
    );
  }

  Widget _buildCart() {
    if (_loadingCart) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_cartItems.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadCart,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text('Your cart is empty')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadCart,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final item = _cartItems[i];
                final product = item['product'] is Map ? Map<String, dynamic>.from(item['product'] as Map) : <String, dynamic>{};
                final id = item['id'] is int ? item['id'] as int : int.tryParse('${item['id']}');
                final qty = item['quantity'] is int ? item['quantity'] as int : int.tryParse('${item['quantity']}') ?? 1;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name']?.toString() ?? 'Item', style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('₹${item['subtotal'] ?? 0}', style: const TextStyle(color: WomenProductsScreen.primary, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: id == null
                            ? null
                            : () async {
                                await _api.updateCart(cartItemId: id, quantity: qty - 1);
                                await _loadCart();
                                await _loadProducts();
                              },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$qty'),
                      IconButton(
                        onPressed: id == null
                            ? null
                            : () async {
                                await _api.updateCart(cartItemId: id, quantity: qty + 1);
                                await _loadCart();
                                await _loadProducts();
                              },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      IconButton(
                        onPressed: id == null
                            ? null
                            : () async {
                                await _api.removeCart(id);
                                await _loadCart();
                                await _loadProducts();
                              },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ₹${_cartTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: WomenProductsScreen.primary),
                  onPressed: _placeOrder,
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrders() {
    if (_loadingOrders) return const Center(child: CircularProgressIndicator());
    if (_orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(child: Text('No orders yet')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = _orders[i];
          final product = o['product'] is Map ? Map<String, dynamic>.from(o['product'] as Map) : <String, dynamic>{};
          final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
          final status = (o['status']?.toString() ?? 'PLACED').toUpperCase();
          final canCancel = o['canCancel'] == true;
          final needsPayment = o['needsPayment'] == true;
          final canReview = o['canReview'] == true;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name']?.toString() ?? 'Product', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'Qty ${o['quantity'] ?? 1} · ₹${o['totalPrice'] ?? 0}',
                  style: const TextStyle(color: WomenProductsScreen.textGray),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip(status, status == 'CANCELLED' ? const Color(0xFFBE123C) : WomenProductsScreen.primary),
                    _chip(o['paymentMethod']?.toString() ?? 'COD', Colors.green),
                  ],
                ),
                const SizedBox(height: 8),
                if (status == 'CANCELLED')
                  const Text('This order was cancelled.', style: TextStyle(fontSize: 12, color: Color(0xFFBE123C)))
                else ...[
                  _trackRow('Placed', true),
                  _trackRow('Confirmed', _passed(status, const ['CONFIRMED', 'READY_FOR_PICKUP', 'ASSIGNED', 'OUT_FOR_DELIVERY', 'DELIVERED'])),
                  _trackRow('Packed for pickup', _passed(status, const ['READY_FOR_PICKUP', 'ASSIGNED', 'OUT_FOR_DELIVERY', 'DELIVERED'])),
                  _trackRow('Assigned to delivery', _passed(status, const ['ASSIGNED', 'OUT_FOR_DELIVERY', 'DELIVERED'])),
                  _trackRow('Out for delivery', _passed(status, const ['OUT_FOR_DELIVERY', 'DELIVERED'])),
                  _trackRow('Delivered', status == 'DELIVERED'),
                ],
                if ((o['deliveryName']?.toString() ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Delivery: ${o['deliveryName']} ${o['deliveryPhone'] ?? ''}',
                      style: const TextStyle(fontSize: 12, color: WomenProductsScreen.textGray)),
                ],
                if ((o['trackingNote']?.toString() ?? '').isNotEmpty)
                  Text(o['trackingNote'].toString(),
                      style: const TextStyle(fontSize: 12, color: WomenProductsScreen.textGray)),
                const SizedBox(height: 6),
                Text(
                  o['orderTime']?.toString() ?? '',
                  style: const TextStyle(fontSize: 12, color: WomenProductsScreen.textGray),
                ),
                if (id != null && (o['canLiveTrack'] == true ||
                    status == 'ASSIGNED' ||
                    status == 'OUT_FOR_DELIVERY' ||
                    status == 'DELIVERED'))
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => OrderLiveTrackingScreen(
                          orderId: id,
                          fetchTrack: () => _api.trackOrder(id),
                        ),
                      ));
                    },
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text(status == 'DELIVERED' ? 'View route' : 'Live track'),
                  ),
                if (needsPayment && id != null)
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: WomenProductsScreen.primary),
                    onPressed: () => _payOrder(o),
                    child: const Text('Pay now'),
                  ),
                if (canReview && id != null)
                  OutlinedButton(
                    onPressed: () => _writeReview(o),
                    child: const Text('Write a review'),
                  ),
                if (canCancel && id != null)
                  TextButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final res = await _api.cancelOrder(id);
                      if (!mounted) return;
                      messenger.showSnackBar(SnackBar(
                        content: Text(res['success'] == true
                            ? 'Order cancelled'
                            : (res['error']?.toString() ?? 'Cancel failed')),
                      ));
                      if (res['success'] == true) _loadOrders();
                    },
                    child: const Text('Cancel order'),
                  ),
                if ((o['cancelPolicy']?.toString() ?? '').isNotEmpty)
                  Text(
                    o['cancelPolicy'].toString(),
                    style: const TextStyle(fontSize: 11, color: WomenProductsScreen.textGray),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _passed(String status, List<String> after) => after.contains(status);

  Widget _trackRow(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 14, color: done ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: done ? const Color(0xFF166534) : WomenProductsScreen.textGray)),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}
