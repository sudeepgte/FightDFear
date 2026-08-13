import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';
import '../services/women_products_service.dart';

class WomenProductDetailScreen extends StatefulWidget {
  const WomenProductDetailScreen({super.key, required this.productId});

  final int productId;

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color textGray = Color(0xFF64748B);

  @override
  State<WomenProductDetailScreen> createState() => _WomenProductDetailScreenState();
}

class _WomenProductDetailScreenState extends State<WomenProductDetailScreen> {
  late final WomenProductsService _api;
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _product;

  @override
  void initState() {
    super.initState();
    _api = WomenProductsService(context.read<AuthState>().api);
    _load();
  }

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _api.productDetail(widget.productId);
      if (!mounted) return;
      if (res['success'] == true && res['product'] is Map) {
        _product = Map<String, dynamic>.from(res['product'] as Map);
      } else {
        _error = res['error']?.toString() ?? 'Not found';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addToCart() async {
    final res = await _api.addToCart(productId: widget.productId, quantity: 1);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['message']?.toString() ?? 'Added to cart')),
    );
    await _load();
  }

  Future<void> _toggleWishlist() async {
    await _api.toggleWishlist(widget.productId);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final p = _product;
    final image = _mediaUrl(p?['imagePath']?.toString());
    final reviews = (p?['reviews'] is List)
        ? (p!['reviews'] as List).whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
        : <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: WomenProductDetailScreen.navy,
        title: const Text('Product', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: image.isEmpty
                            ? Container(
                                height: 220,
                                color: const Color(0xFFFFE4E6),
                                child: const Icon(Icons.shopping_bag_outlined, size: 48),
                              )
                            : Image.network(
                                image,
                                height: 220,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 220,
                                  color: const Color(0xFFFFE4E6),
                                  child: const Icon(Icons.shopping_bag_outlined, size: 48),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        p?['name']?.toString() ?? 'Product',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: WomenProductDetailScreen.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p?['brand']?.toString() ?? '',
                        style: const TextStyle(color: WomenProductDetailScreen.textGray),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '₹${((p?['price'] is num) ? (p!['price'] as num).toDouble() : 0).toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: WomenProductDetailScreen.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (p?['originalPrice'] is num)
                            Text(
                              '₹${((p!['originalPrice'] as num).toDouble()).toStringAsFixed(0)}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: WomenProductDetailScreen.textGray,
                              ),
                            ),
                        ],
                      ),
                      if (p?['offerBadge'] != null && '${p!['offerBadge']}'.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${p['offerBadge']}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        p?['fullDescription']?.toString() ??
                            p?['description']?.toString() ??
                            '',
                        style: const TextStyle(height: 1.45),
                      ),
                      const SizedBox(height: 14),
                      if (p?['ingredients'] != null && '${p!['ingredients']}'.isNotEmpty) ...[
                        const Text('Ingredients', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('${p['ingredients']}'),
                        const SizedBox(height: 10),
                      ],
                      if (p?['usageInstructions'] != null && '${p!['usageInstructions']}'.isNotEmpty) ...[
                        const Text('Usage', style: TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('${p['usageInstructions']}'),
                        const SizedBox(height: 10),
                      ],
                      const Divider(height: 26),
                      Row(
                        children: [
                          const Text('Reviews', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Text(
                            '${(p?['avgRating'] is num) ? (p!['avgRating'] as num).toStringAsFixed(1) : '0.0'} (${p?['reviewCount'] ?? 0})',
                            style: const TextStyle(color: WomenProductDetailScreen.textGray),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (reviews.isEmpty)
                        const Text('No ratings yet.', style: TextStyle(color: WomenProductDetailScreen.textGray))
                      else
                        ...reviews.take(5).map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('⭐ ${r['rating'] ?? 0}'),
                              subtitle: Text(r['review']?.toString() ?? ''),
                              trailing: Text(
                                r['userName']?.toString() ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            )),
                    ],
                  ),
                ),
      bottomNavigationBar: _loading || _error != null
          ? null
          : SafeArea(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _toggleWishlist,
                      icon: Icon(
                        p?['inWishlist'] == true ? Icons.favorite : Icons.favorite_border,
                        color: p?['inWishlist'] == true ? Colors.red : null,
                      ),
                      label: const Text('Wishlist'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: WomenProductDetailScreen.primary),
                        onPressed: _addToCart,
                        child: const Text('Add to cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
