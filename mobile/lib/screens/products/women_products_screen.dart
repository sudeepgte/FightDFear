import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/women_products_service.dart';
import '../../widgets/detail_listing_card.dart';
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
  late final TabController _tabs;

  bool _loadingProducts = true;
  bool _loadingCart = false;
  bool _loadingOrders = false;
  String? _error;
  String _category = '';
  final _categoryOptions = const [
    (value: '', label: 'All Products', icon: Icons.grid_view_rounded),
    (value: 'SKINCARE', label: 'Skincare', icon: Icons.spa_outlined),
    (value: 'HAIRCARE', label: 'Haircare', icon: Icons.content_cut),
    (value: 'HYGIENE', label: 'Hygiene', icon: Icons.clean_hands_outlined),
    (value: 'CLOTHING', label: 'Clothing', icon: Icons.checkroom_outlined),
    (value: 'ACCESSORIES', label: 'Accessories', icon: Icons.watch_outlined),
    (value: 'WELLNESS', label: 'Wellness', icon: Icons.favorite_outline),
  ];

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cartItems = [];
  double _cartTotal = 0;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _api = WomenProductsService(context.read<AuthState>().api);
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
      final res = await _api.listProducts(category: _category.isEmpty ? null : _category);
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delivery address'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter full shipping address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Place COD')),
        ],
      ),
    );
    if (ok != true) return;
    final address = ctrl.text.trim();
    if (address.isEmpty) return;
    final res = await _api.placeCodOrder(shippingAddress: address);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'Order placed')),
      );
      _tabs.animateTo(2);
      await _loadCart();
      await _loadOrders();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['error']?.toString() ?? 'Could not place order')),
      );
    }
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Showing ${_products.length} products',
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
                  child: const Text('Place COD order'),
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
                    _chip(o['status']?.toString() ?? 'PLACED', WomenProductsScreen.primary),
                    _chip(o['paymentMethod']?.toString() ?? 'COD', Colors.green),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  o['orderTime']?.toString() ?? '',
                  style: const TextStyle(fontSize: 12, color: WomenProductsScreen.textGray),
                ),
              ],
            ),
          );
        },
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
