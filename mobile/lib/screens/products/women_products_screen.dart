import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/payment_service.dart';
import '../../services/women_products_service.dart';
import '../../widgets/detail_listing_card.dart';
import '../../widgets/module_payment_checkout.dart';
import 'order_live_tracking_screen.dart';
import 'women_product_detail_screen.dart';

class WomenProductsScreen extends StatefulWidget {
  const WomenProductsScreen({super.key, this.initialTab = 0});

  final int initialTab;

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
  List<Map<String, dynamic>> _wishlistItems = [];
  bool _loadingWishlist = false;
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
    _tabs = TabController(length: 4, vsync: this, initialIndex: widget.initialTab.clamp(0, 3));
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index == 1) {
        _loadCart();
      } else if (_tabs.index == 2) {
        _loadWishlist();
      } else if (_tabs.index == 3) {
        _loadOrders();
      }
    });
    if (widget.initialTab == 1) {
      _loadCart();
    } else if (widget.initialTab == 2) {
      _loadWishlist();
    } else if (widget.initialTab == 3) {
      _loadOrders();
    }
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

  Future<void> _loadWishlist() async {
    setState(() => _loadingWishlist = true);
    try {
      final res = await _api.wishlist();
      if (!mounted) return;
      if (res['success'] == true) {
        final raw = res['items'];
        _wishlistItems = raw is List
            ? raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingWishlist = false);
  }

  Future<void> _toggleWishlist(int productId) async {
    await _api.toggleWishlist(productId);
    await _loadProducts();
    if (_tabs.index == 2) {
      await _loadWishlist();
    }
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

  Future<List<Map<String, String>>> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString('fdf_user_addresses');
    List<Map<String, String>> addresses = [];
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        final List decoded = jsonDecode(rawJson);
        addresses = decoded.map((e) => Map<String, String>.from(e as Map)).toList();
      } catch (_) {}
    }

    if (addresses.isEmpty) {
      String rawHome = '';
      try {
        final res = await context.read<AuthState>().api.get('/api/auth/me');
        if (res['success'] == true && res['homeAddress'] != null) {
          rawHome = res['homeAddress'].toString().trim();
        }
      } catch (_) {}

      if (rawHome.isNotEmpty) {
        final defaultAddr = {
          'id': '${DateTime.now().millisecondsSinceEpoch}',
          'flat': 'Home Address',
          'pin': 'N/A',
          'house': '',
          'full': rawHome,
          'landmark': 'N/A',
        };
        addresses.add(defaultAddr);
        await prefs.setString('fdf_user_addresses', jsonEncode(addresses));
      }
    }
    return addresses;
  }

  Future<void> _saveAddressesList(List<Map<String, String>> addresses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fdf_user_addresses', jsonEncode(addresses));
  }

  String _formatShippingAddress(Map<String, String> addr) {
    final flat = addr['flat'] ?? 'Home Address';
    final house = addr['house'] ?? '';
    final full = addr['full'] ?? '';
    final landmark = addr['landmark'] ?? 'N/A';
    final pin = addr['pin'] ?? 'N/A';

    var out = 'Flat: $flat, ';
    if (house.isNotEmpty) out += 'House: $house, ';
    if (full.isNotEmpty) out += 'Address: $full, ';
    out += 'Landmark: $landmark, Pincode: $pin';
    return out;
  }

  Future<Map<String, String>?> _openAddressEditDialog({Map<String, String>? initial}) async {
    final flatCtrl = TextEditingController(text: initial?['flat'] ?? '');
    final pinCtrl = TextEditingController(text: initial?['pin'] ?? '');
    final houseCtrl = TextEditingController(text: initial?['house'] ?? '');
    final fullCtrl = TextEditingController(text: initial?['full'] ?? '');
    final landmarkCtrl = TextEditingController(text: initial?['landmark'] ?? '');
    String? localError;

    final isEdit = initial != null && initial['id'] != null;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEdit ? 'Edit Address' : 'Add New Address',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: WomenProductsScreen.navy,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  if (localError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFECDD3)),
                      ),
                      child: Text(
                        localError!,
                        style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  const Text('FLAT NO / BUILDING *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  TextField(
                    controller: flatCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Flat 101 / Home Address',
                      filled: true,
                      fillColor: const Color(0xFFFFF5F7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('PINCODE *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  TextField(
                    controller: pinCtrl,
                    keyboardType: TextInputType.text,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: 'e.g. 560001 or N/A',
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFFFF5F7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('HOUSE NAME (OPTIONAL)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  TextField(
                    controller: houseCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Rose Villa',
                      filled: true,
                      fillColor: const Color(0xFFFFF5F7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('FULL ADDRESS / AREA *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  TextField(
                    controller: fullCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'e.g. 12th Main, Indiranagar, Bangalore',
                      filled: true,
                      fillColor: const Color(0xFFFFF5F7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('LANDMARK *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  TextField(
                    controller: landmarkCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Near City Park',
                      filled: true,
                      fillColor: const Color(0xFFFFF5F7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: WomenProductsScreen.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      onPressed: () {
                        final flat = flatCtrl.text.trim();
                        final pin = pinCtrl.text.trim();
                        final house = houseCtrl.text.trim();
                        final full = fullCtrl.text.trim();
                        final landmark = landmarkCtrl.text.trim();

                        if (flat.isEmpty || pin.isEmpty || full.isEmpty || landmark.isEmpty) {
                          setDialogState(() => localError = 'Please fill in Flat No, Full Address, Pincode, and Landmark.');
                          return;
                        }

                        final fakePins = ['111111', '222222', '333333', '444444', '555555', '666666', '777777', '888888', '999999', '123456', '654321', '000000'];
                        if (pin.toUpperCase() != 'N/A') {
                          if (!RegExp(r'^[1-8]\d{5}$').hasMatch(pin) || fakePins.contains(pin)) {
                            setDialogState(() => localError = 'Please enter a valid 6-digit pincode.');
                            return;
                          }
                        }

                        Navigator.pop(ctx, {
                          'id': initial?['id'] ?? '${DateTime.now().millisecondsSinceEpoch}',
                          'flat': flat,
                          'pin': pin,
                          'house': house,
                          'full': full,
                          'landmark': landmark,
                        });
                      },
                      child: const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    flatCtrl.dispose();
    pinCtrl.dispose();
    houseCtrl.dispose();
    fullCtrl.dispose();
    landmarkCtrl.dispose();

    return result;
  }

  Future<void> _placeOrder() async {
    final addresses = await _loadAddresses();
    String? selectedId = addresses.isNotEmpty ? addresses.first['id'] : null;
    String method = 'COD';

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          final selectedAddr = addresses.firstWhere(
            (a) => a['id'] == selectedId,
            orElse: () => addresses.isNotEmpty ? addresses.first : <String, String>{},
          );

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              top: 20,
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenProductsScreen.navy),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx, false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: WomenProductsScreen.primary, size: 20),
                          SizedBox(width: 6),
                          Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final newAddr = await _openAddressEditDialog();
                          if (newAddr != null) {
                            setLocal(() {
                              addresses.add(newAddr);
                              selectedId = newAddr['id'];
                            });
                            await _saveAddressesList(addresses);
                          }
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add New'),
                      ),
                    ],
                  ),
                  if (addresses.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('No delivery address found. Please tap "+ Add New".'),
                    )
                  else
                    Column(
                      children: addresses.map((addr) {
                        final isSel = addr['id'] == selectedId;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFFFF1F2) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSel ? WomenProductsScreen.primary : Colors.grey.shade300,
                              width: isSel ? 1.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => setLocal(() => selectedId = addr['id']),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  value: addr['id']!,
                                  groupValue: selectedId,
                                  activeColor: WomenProductsScreen.primary,
                                  onChanged: (v) => setLocal(() => selectedId = v),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${addr['flat'] ?? ''}${addr['house'] != null && addr['house']!.isNotEmpty ? ', ' + addr['house']! : ''}',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(addr['full'] ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
                                      const SizedBox(height: 2),
                                      Text('Landmark: ${addr['landmark'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                      Text('Pincode: ${addr['pin'] ?? 'N/A'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: WomenProductsScreen.navy)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                                  onPressed: () async {
                                    final updated = await _openAddressEditDialog(initial: addr);
                                    if (updated != null) {
                                      setLocal(() {
                                        final idx = addresses.indexWhere((a) => a['id'] == addr['id']);
                                        if (idx != -1) addresses[idx] = updated;
                                      });
                                      await _saveAddressesList(addresses);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                  onPressed: () async {
                                    setLocal(() {
                                      addresses.removeWhere((a) => a['id'] == addr['id']);
                                      if (selectedId == addr['id']) {
                                        selectedId = addresses.isNotEmpty ? addresses.first['id'] : null;
                                      }
                                    });
                                    await _saveAddressesList(addresses);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'COD', label: Text('Cash on delivery')),
                      ButtonSegment(value: 'ONLINE', label: Text('Pay online')),
                    ],
                    selected: {method},
                    onSelectionChanged: (s) => setLocal(() => method = s.first),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal:'),
                            Text('₹${_cartTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery Fee:'),
                            Text('FREE', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green)),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total to Pay:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            Text('₹${_cartTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: WomenProductsScreen.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: WomenProductsScreen.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: selectedAddr.isEmpty
                          ? null
                          : () => Navigator.pop(ctx, true),
                      child: Text(
                        method == 'ONLINE' ? 'Place Order & Pay Online' : 'Place Order (COD)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (ok != true || selectedId == null) return;

    final selectedAddr = addresses.firstWhere(
      (a) => a['id'] == selectedId,
      orElse: () => <String, String>{},
    );
    if (selectedAddr.isEmpty) return;

    final formattedAddress = _formatShippingAddress(selectedAddr);

    final res = await _api.placeCodOrder(shippingAddress: formattedAddress, paymentMethod: method);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'Order placed successfully!')),
      );
      _tabs.animateTo(3);
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
      createOrderFn: () => PaymentService(context.read<AuthState>().api).createOrder(
        amount,
        type: 'WOMEN_PRODUCT',
        extra: {
          'targetId': id,
          'orderId': id,
          'orderIds': [id],
        },
      ),
      verifyPayload: (response) => {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'type': 'WOMEN_PRODUCT',
        'orderId': id,
        'targetId': id,
        'orderIds': [id],
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
            Tab(text: 'Wishlist'),
            Tab(text: 'Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildShop(),
          _buildCart(),
          _buildWishlist(),
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

  Widget _buildWishlist() {
    if (_loadingWishlist) return const Center(child: CircularProgressIndicator());
    if (_wishlistItems.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadWishlist,
        child: ListView(
          children: const [
            SizedBox(height: 140),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Your Wishlist is empty', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Tap the heart icon on any product to save it here.', style: TextStyle(color: WomenProductsScreen.textGray, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadWishlist,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _wishlistItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final p = _wishlistItems[i];
          final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
          final name = p['name']?.toString() ?? 'Product';
          final price = p['price'] ?? 0;
          final img = _mediaUrl(p['imagePath']?.toString());
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: img.isNotEmpty
                      ? Image.network(img, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.image)))
                      : Container(width: 60, height: 60, color: Colors.grey.shade200, child: const Icon(Icons.image)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text('₹$price', style: const TextStyle(fontWeight: FontWeight.w800, color: WomenProductsScreen.primary)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Add to Cart',
                  icon: const Icon(Icons.add_shopping_cart, color: WomenProductsScreen.primary),
                  onPressed: id == null
                      ? null
                      : () async {
                          await _addToCart(id);
                          await _loadCart();
                        },
                ),
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: id == null
                      ? null
                      : () async {
                          await _toggleWishlist(id);
                        },
                ),
              ],
            ),
          );
        },
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
