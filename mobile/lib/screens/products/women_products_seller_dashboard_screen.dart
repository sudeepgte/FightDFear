import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import '../landing/landing_screen.dart';
import 'order_live_tracking_screen.dart';
import 'women_products_seller_login_screen.dart';
import 'women_products_seller_profile_completion_screen.dart';

/// Full seller dashboard matching `seller-dashboard.jsp` with complete navigation drawer,
/// top bar, product management, inline stock updates, live orders, revenue analytics,
/// exchange/refund requests, customer reviews, and shop preview.
class WomenProductsSellerDashboardScreen extends StatefulWidget {
  const WomenProductsSellerDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color softBg = Color(0xFFF8FAFC);

  @override
  State<WomenProductsSellerDashboardScreen> createState() =>
      _WomenProductsSellerDashboardScreenState();
}

class _WomenProductsSellerDashboardScreenState
    extends State<WomenProductsSellerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _tab = 0;
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _seller = {};
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _orders = [];
  double _earnings = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';

  final List<String> _tabTitles = [
    'Dashboard Overview',
    'My Products',
    'Live Orders',
    'Revenue Analytics',
    'Exchange Requests',
    'Refund Requests',
    'Customer Reviews',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _svc.dashboard();
      if (res['success'] == true) {
        _seller = Map<String, dynamic>.from(res['seller'] ?? {});
        _products = ModuleTheme.toList(res['products']);
        _orders = ModuleTheme.toList(res['orders']);
        _earnings = (res['totalEarnings'] is num)
            ? (res['totalEarnings'] as num).toDouble()
            : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_seller['payoutBalance'] is num)
                ? (_seller['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _seller['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? SellerCatalog.cancelPolicy;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load seller dashboard';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await context.read<AuthState>().api.clearWomenProductsSellerToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen()),
      (_) => false,
    );
  }

  bool get _approved {
    final status = (_seller['partnerProfileStatus'] ?? '').toString().toUpperCase();
    final ver = (_seller['verificationStatus'] ?? '').toString().toUpperCase();
    return status == 'APPROVED' || ver == 'VERIFIED' || _seller['canListProducts'] == true;
  }

  WomenProductsSellerAuthService get _svc =>
      WomenProductsSellerAuthService(context.read<AuthState>().api);

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => const WomenProductsSellerProfileCompletionScreen()))
        .then((_) => _load());
  }

  Future<void> _addProduct() => _editProduct();

  Future<void> _editProduct([Map<String, dynamic>? existing]) async {
    if (!_approved) {
      _toast('Complete shop profile and await admin approval before listing products.');
      _openProfile();
      return;
    }

    final isEdit = existing != null;
    final name = TextEditingController(text: existing?['name']?.toString() ?? '');
    final brand = TextEditingController(
        text: existing?['brand']?.toString() ??
            _seller['businessName']?.toString() ??
            'Own Brand');
    final price = TextEditingController(text: '${existing?['price'] ?? '199'}');
    final origPrice = TextEditingController(text: '${existing?['originalPrice'] ?? ''}');
    final stock = TextEditingController(text: '${existing?['stock'] ?? '10'}');
    final lowStock = TextEditingController(text: '${existing?['lowStockAlertLevel'] ?? '5'}');
    final sku = TextEditingController(text: existing?['sku']?.toString() ?? '');
    final weight = TextEditingController(text: existing?['weightSize']?.toString() ?? '');
    final badge = TextEditingController(text: existing?['offerBadge']?.toString() ?? '');
    final desc = TextEditingController(text: existing?['description']?.toString() ?? '');
    final ingredients = TextEditingController(text: existing?['ingredients']?.toString() ?? '');
    final benefits = TextEditingController(text: existing?['benefits']?.toString() ?? '');
    final usage = TextEditingController(text: existing?['usageInstructions']?.toString() ?? '');

    final codes = SellerCatalog.categories.map((c) => c.code).toList();
    String cat = existing?['category']?.toString() ?? codes.first;
    if (!codes.contains(cat)) cat = codes.first;

    bool active = existing?['active'] != false;
    bool featured = existing?['featured'] == true;
    String? pickedPath;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add New Product'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                      hintText: 'e.g. Organic Rose Petal Soap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: brand,
                    decoration: const InputDecoration(
                      labelText: 'Brand *',
                      hintText: 'e.g. Namratha Handcrafts',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: cat,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      border: OutlineInputBorder(),
                    ),
                    items: SellerCatalog.categories
                        .map((c) => DropdownMenuItem(value: c.code, child: Text(c.label)))
                        .toList(),
                    onChanged: (v) => setLocal(() => cat = v ?? cat),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Selling Price (₹) *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: origPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'MRP (₹)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: stock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Initial Stock *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: lowStock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Low Stock Alert Level',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: sku,
                          decoration: const InputDecoration(
                            labelText: 'SKU Code',
                            hintText: 'e.g. SOAP-001',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: weight,
                          decoration: const InputDecoration(
                            labelText: 'Weight / Size',
                            hintText: 'e.g. 150g, Free Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: badge,
                    decoration: const InputDecoration(
                      labelText: 'Offer Badge',
                      hintText: 'e.g. HOT, 15% OFF, NEW',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: desc,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Short Description',
                      hintText: 'Brief summary for store catalog',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ingredients,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Ingredients / Materials',
                      hintText: 'Natural oils, organic shea butter, etc.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: benefits,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Key Benefits',
                      hintText: 'Hydrating, toxin-free, handmade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: usage,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Usage / Care Instructions',
                      hintText: 'Store in dry place, gentle on skin',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: active,
                        onChanged: (v) => setLocal(() => active = v ?? true),
                      ),
                      const Text('Active / Listed'),
                      const Spacer(),
                      Checkbox(
                        value: featured,
                        onChanged: (v) => setLocal(() => featured = v ?? false),
                      ),
                      const Text('Featured Product'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final file = await ImagePicker()
                          .pickImage(source: ImageSource.gallery, imageQuality: 85);
                      if (file != null) setLocal(() => pickedPath = file.path);
                    },
                    icon: const Icon(Icons.photo_camera_rounded),
                    label: Text(pickedPath != null
                        ? 'Photo selected'
                        : (existing?['imagePath'] != null
                            ? 'Change photo'
                            : 'Upload product photo')),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: WomenProductsSellerDashboardScreen.primary,
              ),
              onPressed: () {
                if (name.text.trim().isEmpty || brand.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Product name and brand are required.')),
                  );
                  return;
                }
                if ((double.tryParse(price.text.trim()) ?? 0) <= 0) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Enter a valid price.')),
                  );
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: Text(isEdit ? 'Update Product' : 'Add to Catalog'),
            ),
          ],
        ),
      ),
    );

    if (ok != true || !mounted) return;

    final payload = {
      'name': name.text.trim(),
      'brand': brand.text.trim().isEmpty ? 'Own Brand' : brand.text.trim(),
      'category': cat,
      'price': double.tryParse(price.text.trim()) ?? 0,
      'originalPrice': double.tryParse(origPrice.text.trim()),
      'stock': int.tryParse(stock.text.trim()) ?? 0,
      'lowStockAlertLevel': int.tryParse(lowStock.text.trim()) ?? 5,
      'sku': sku.text.trim(),
      'weightSize': weight.text.trim(),
      'offerBadge': badge.text.trim(),
      'description': desc.text.trim(),
      'ingredients': ingredients.text.trim(),
      'benefits': benefits.text.trim(),
      'usageInstructions': usage.text.trim(),
      'active': active,
      'featured': featured,
    };

    Map<String, dynamic> res;
    if (isEdit) {
      final id = existing['id'] is int
          ? existing['id'] as int
          : int.tryParse('${existing['id']}');
      if (id == null) return;
      res = await _svc.updateProduct(id, payload);
      if (res['success'] == true && pickedPath != null) {
        await _svc.uploadProductImage(id, pickedPath!);
      }
    } else {
      res = await _svc.addProduct(payload);
      final created = res['product'];
      final id = created is Map
          ? (created['id'] is int ? created['id'] as int : int.tryParse('${created['id']}'))
          : null;
      if (res['success'] == true && pickedPath != null && id != null) {
        await _svc.uploadProductImage(id, pickedPath!);
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? (isEdit ? 'Product updated' : 'Product deployed')
            : '${res['error']}'),
        backgroundColor: res['success'] == true ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
      ),
    );
    if (res['success'] == true) {
      setState(() => _tab = 1);
      _load();
    }
  }

  Future<void> _quickUpdateStock(Map<String, dynamic> p, int newStock) async {
    final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
    if (id == null || newStock < 0) return;
    final res = await _svc.updateStock(id, newStock);
    if (!mounted) return;
    if (res['success'] == true) {
      setState(() {
        p['stock'] = newStock;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock for "${p['name']}" updated to $newStock'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      _toast(res['error']?.toString() ?? 'Could not update stock');
    }
  }

  Future<void> _deleteProduct(Map<String, dynamic> p) async {
    final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product?'),
        content: Text('Are you sure you want to remove "${p['name']}" from your store?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final res = await _svc.deleteProduct(id);
    if (!mounted) return;
    _toast(res['success'] == true ? 'Product removed' : '${res['error']}');
    if (res['success'] == true) _load();
  }

  Future<void> _requestPayout() async {
    final res = await _svc.requestPayout();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? (res['message']?.toString() ?? 'Payout requested')
            : (res['error']?.toString() ?? 'Payout request failed')),
      ),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _editNotes(Map<String, dynamic> o) async {
    final oid = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    if (oid == null) return;
    final ctrl = TextEditingController(text: o['coachNotes']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order Packing & Dispatch Notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter dispatch remarks, packaging instructions, tracking codes…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save Notes')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await _svc.updateOrderNotes(oid, ctrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Notes saved' : (res['error']?.toString() ?? 'Could not save notes')),
      ),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _updateOrder(int id, String status) async {
    final res = await _svc.updateOrderStatus(id, status);
    if (!mounted) return;
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order #$id status updated to $status')),
      );
      _load();
    } else {
      _toast(res['error']?.toString() ?? 'Status update failed');
    }
  }

  void _openShopPreview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, scroll) => ListView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.storefront_rounded, color: WomenProductsSellerDashboardScreen.primary, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _shop,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Store Preview', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
            const Divider(height: 24),
            _storeHero(),
            const SizedBox(height: 16),
            const Text('Store Products', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            if (_products.isEmpty)
              _empty('No products active in storefront.')
            else
              ..._products.map(_productTile),
          ],
        ),
      ),
    );
  }

  String get _name => _seller['fullName']?.toString() ?? 'Seller';
  String get _firstName => _name.split(' ').first;
  String get _shop => _seller['businessName']?.toString() ?? 'My Store';
  String get _address => _seller['address']?.toString() ?? 'Address not set';
  double get _rating => (_seller['rating'] is num) ? (_seller['rating'] as num).toDouble() : 0;

  int get _inStock => _products.where((p) {
        final s = p['stock'];
        final n = s is num ? s.toInt() : int.tryParse('$s') ?? 0;
        return n > 5;
      }).length;
  int get _lowStock => _products.where((p) {
        final s = p['stock'];
        final n = s is num ? s.toInt() : int.tryParse('$s') ?? 0;
        return n > 0 && n <= 5;
      }).length;
  int get _outStock => _products.where((p) {
        final s = p['stock'];
        final n = s is num ? s.toInt() : int.tryParse('$s') ?? 0;
        return n <= 0;
      }).length;

  String _money(num v) {
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)} L';
    if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
    return '₹${v.toStringAsFixed(0)}';
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  String _mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    final base = context.read<AuthState>().api.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrdersCount = _orders.where((o) => (o['status']?.toString() ?? '') == 'PLACED').length;

    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: WomenProductsSellerDashboardScreen.softBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          foregroundColor: WomenProductsSellerDashboardScreen.navy,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _tab < _tabTitles.length ? _tabTitles[_tab] : 'Seller Portal',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              Text(
                _shop,
                style: const TextStyle(fontSize: 11, color: WomenProductsSellerDashboardScreen.muted, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Preview Shop',
              icon: const Icon(Icons.remove_red_eye_outlined),
              onPressed: _openShopPreview,
            ),
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _load,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color(0xFFFFF1F2),
                  child: Text(
                    _shop.isNotEmpty ? _shop[0].toUpperCase() : 'S',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: WomenProductsSellerDashboardScreen.primary,
                    ),
                  ),
                ),
                accountName: Text(
                  _shop,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                accountEmail: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Portal ID: FS-${_seller['id'] ?? '—'}'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _approved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _approved ? 'APPROVED' : 'PENDING REVIEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: _approved ? const Color(0xFF166534) : const Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _drawerTile(0, Icons.speed_rounded, 'Dashboard Overview'),
              _drawerTile(1, Icons.auto_awesome_rounded, 'My Products', badge: '${_products.length}'),
              _drawerTile(2, Icons.local_shipping_rounded, 'Live Orders', badge: pendingOrdersCount > 0 ? '$pendingOrdersCount' : null),
              _drawerTile(3, Icons.trending_up_rounded, 'Revenue Analytics'),
              _drawerTile(4, Icons.swap_horiz_rounded, 'Exchange Requests'),
              _drawerTile(5, Icons.currency_rupee_rounded, 'Refund Requests'),
              ListTile(
                leading: const Icon(Icons.badge_rounded, color: Color(0xFF334155)),
                title: const Text('My Shop Profile', style: TextStyle(fontWeight: FontWeight.w700)),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {
                  Navigator.pop(context);
                  _openProfile();
                },
              ),
              _drawerTile(6, Icons.rate_review_rounded, 'Customer Reviews'),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.visibility_outlined, color: WomenProductsSellerDashboardScreen.primary),
                title: const Text('Preview Storefront', style: TextStyle(fontWeight: FontWeight.w700, color: WomenProductsSellerDashboardScreen.primary)),
                onTap: () {
                  Navigator.pop(context);
                  _openShopPreview();
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                title: const Text('Sign Out', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: WomenProductsSellerDashboardScreen.primary,
          tooltip: 'Add Product',
          onPressed: _addProduct,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          elevation: 12,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _nav(0, Icons.home_outlined, Icons.home, 'Home'),
                _nav(1, Icons.inventory_2_outlined, Icons.inventory_2, 'Products'),
                const SizedBox(width: 56),
                _nav(2, Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
                _nav(3, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, 'Finance'),
              ],
            ),
          ),
        ),
        body: _loading
            ? ModuleTheme.loading()
            : _error != null
                ? ModuleTheme.errorView(_error!, _load)
                : SafeArea(
                    child: IndexedStack(
                      index: _tab > 3 ? 0 : _tab,
                      children: [
                        _home(),
                        _productsTab(),
                        _ordersTab(),
                        _shopTab(),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _drawerTile(int index, IconData icon, String title, {String? badge}) {
    final selected = _tab == index;
    return ListTile(
      leading: Icon(icon, color: selected ? WomenProductsSellerDashboardScreen.primary : const Color(0xFF334155)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? WomenProductsSellerDashboardScreen.primary : const Color(0xFF0F172A),
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: WomenProductsSellerDashboardScreen.softPink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: WomenProductsSellerDashboardScreen.primary,
                ),
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        setState(() => _tab = index);
      },
    );
  }

  Widget _nav(int i, IconData o, IconData f, String label) {
    final active = _tab == i;
    final c = active ? WomenProductsSellerDashboardScreen.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(active ? f : o, color: c, size: 22),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    return RefreshIndicator(
      color: WomenProductsSellerDashboardScreen.primary,
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${_greeting()}, $_firstName! 👋',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
                    const Text('Seller Dashboard · manage products & orders',
                        style: TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
                  ],
                ),
              ),
              IconButton(onPressed: _load, icon: const Icon(Icons.notifications_none_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          _storeHero(),
          if (!_approved) ...[
            const SizedBox(height: 12),
            ProfileCompletionCard(
              percent: (_seller['profileCompletionPct'] is num)
                  ? (_seller['profileCompletionPct'] as num).toDouble()
                  : 0,
              statusLabel: _seller['partnerProfileStatusLabel']?.toString() ?? 'Pending Review',
              hint: 'Complete shop details and wait for admin approval before listing products.',
              actionLabel: 'Complete Profile',
              onAction: _openProfile,
            ),
          ],
          const SizedBox(height: 14),
          _kpiRow(),
          const SizedBox(height: 16),
          _section('Quick Actions'),
          const SizedBox(height: 10),
          _quickActions(),
          const SizedBox(height: 16),
          _section('Recent Orders', action: 'View all', onAction: () => setState(() => _tab = 2)),
          const SizedBox(height: 8),
          if (_orders.isEmpty)
            _empty('No orders yet. Add products to start selling.')
          else
            ..._orders.take(4).map(_orderTile),
          const SizedBox(height: 16),
          _section('Top Products', action: 'Manage', onAction: () => setState(() => _tab = 1)),
          const SizedBox(height: 8),
          if (_products.isEmpty)
            _empty('No products yet. Tap + to deploy your first product.')
          else
            ..._products.take(4).map(_productTile),
          const SizedBox(height: 16),
          _inventoryCard(),
          const SizedBox(height: 16),
          _footerBanner(),
        ],
      ),
    );
  }

  Widget _storeHero() {
    final initial = _shop.isNotEmpty ? _shop[0].toUpperCase() : 'S';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF881337), Color(0xFFF43F5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Text(initial, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_shop, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                Text(_name, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14, color: Colors.white70),
                    const SizedBox(width: 2),
                    Expanded(child: Text(_address, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 11))),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _heroChip('★ ${_rating > 0 ? _rating.toStringAsFixed(1) : 'New'}'),
                    _heroChip(_money(_earnings)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                      child: Text(_approved ? 'Active' : 'Pending', style: const TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  Widget _kpiRow() {
    final sold = _orders.where((o) => (o['status']?.toString() ?? '') == 'DELIVERED').length;
    final items = [
      (Icons.payments_outlined, 'Total Sales', _money(_earnings), const Color(0xFFFCE7F3)),
      (Icons.receipt_long_outlined, 'Orders', '${_orders.length}', const Color(0xFFE0E7FF)),
      (Icons.shopping_bag_outlined, 'Products Sold', '$sold', const Color(0xFFDCFCE7)),
      (Icons.warehouse_outlined, 'In Stock', '$_inStock', const Color(0xFFFEF3C7)),
      (Icons.account_balance_wallet_outlined, 'Payout Balance', _money(_payoutBalance), const Color(0xFFFFE4E6)),
    ];
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final m = items[i];
          return Container(
            width: 128,
            padding: const EdgeInsets.all(12),
            decoration: _card(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: m.$4, borderRadius: BorderRadius.circular(10)),
                  child: Icon(m.$1, size: 18, color: WomenProductsSellerDashboardScreen.navy),
                ),
                const Spacer(),
                Text(m.$2, style: const TextStyle(fontSize: 11, color: WomenProductsSellerDashboardScreen.muted, fontWeight: FontWeight.w600)),
                Text(m.$3, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      (Icons.add_box_outlined, 'Add Product', _addProduct),
      (Icons.inventory_2_outlined, 'Products', () => setState(() => _tab = 1)),
      (Icons.receipt_long_outlined, 'Orders', () => setState(() => _tab = 2)),
      (Icons.payments_outlined, 'Finance', () => setState(() => _tab = 3)),
      (Icons.storefront_outlined, 'Store Profile', _openProfile),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) {
        final a = actions[i];
        return InkWell(
          onTap: a.$3,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(color: WomenProductsSellerDashboardScreen.softPink, shape: BoxShape.circle),
                child: Icon(a.$1, color: WomenProductsSellerDashboardScreen.primary, size: 20),
              ),
              const SizedBox(height: 6),
              Text(a.$2, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: WomenProductsSellerDashboardScreen.navy, height: 1.15)),
            ],
          ),
        );
      },
    );
  }

  Widget _inventoryCard() {
    final total = _products.isEmpty ? 1 : _products.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _inStock / total,
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFFF1F5F9),
                  color: const Color(0xFF16A34A),
                ),
                Text('${_products.length}\nTotal', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, height: 1.15)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Inventory Summary', style: TextStyle(fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
                const SizedBox(height: 8),
                _invRow('In Stock', _inStock, const Color(0xFF16A34A)),
                _invRow('Low Stock', _lowStock, const Color(0xFFF59E0B)),
                _invRow('Out of Stock', _outStock, const Color(0xFFEF4444)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _invRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted))),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _productsTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('My Products (${_products.length})',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
              ),
              FilledButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Item'),
                style: FilledButton.styleFrom(backgroundColor: WomenProductsSellerDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_products.isEmpty)
            _empty('No products in catalog. Tap "Add Item" to list products.')
          else
            ..._products.map(_productTile),
        ],
      ),
    );
  }

  Widget _ordersTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: [
          Text('Live Orders (${_orders.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
          const SizedBox(height: 14),
          if (_orders.isEmpty) _empty('No customer orders yet.') else ..._orders.map(_orderTile),
        ],
      ),
    );
  }

  Widget _shopTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text('Revenue & Finance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined,
                color: WomenProductsSellerDashboardScreen.primary),
            title: const Text('Payout Balance'),
            subtitle: Text(_upiId.isEmpty
                ? 'Add UPI in Profile to withdraw'
                : 'Payout UPI: $_upiId'),
            trailing: Text(
              '₹${_payoutBalance.round()}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text('Confirmed Earnings'),
            trailing: Text(
              '₹${_earnings.round()}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _requestPayout,
          style: FilledButton.styleFrom(
            backgroundColor: WomenProductsSellerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI Payout'),
        ),
        const SizedBox(height: 8),
        Text(
          _cancelPolicy.isNotEmpty
              ? _cancelPolicy
              : 'Minimum payout ₹100. Online orders credit when paid; COD credits upon delivery.',
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        const SizedBox(height: 20),
        _storeHero(),
        const SizedBox(height: 14),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.person),
            title: const Text('Seller / Founder'),
            subtitle: Text(_name)),
        const SizedBox(height: 8),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.email),
            title: const Text('Official Email'),
            subtitle: Text(_seller['email']?.toString() ?? '—')),
        const SizedBox(height: 8),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.phone),
            title: const Text('Official Phone'),
            subtitle: Text(_seller['phone']?.toString() ?? '—')),
        const SizedBox(height: 8),
        ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.place),
            title: const Text('Store Location'),
            subtitle: Text(_address)),
        const SizedBox(height: 16),
        FilledButton.tonal(onPressed: _openProfile, child: const Text('Edit Shop Profile')),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFDC2626),
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: Color(0xFFFCA5A5)),
          ),
        ),
      ],
    );
  }

  Widget _productThumb(Map<String, dynamic> p) {
    final url = _mediaUrl(p['imagePath']?.toString());
    const size = 52.0;
    if (url.isEmpty) {
      return Container(
        width: size,
        height: size,
        color: WomenProductsSellerDashboardScreen.softPink,
        child: const Icon(Icons.shopping_bag_outlined, color: WomenProductsSellerDashboardScreen.primary),
      );
    }
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        color: WomenProductsSellerDashboardScreen.softPink,
        child: const Icon(Icons.shopping_bag_outlined, color: WomenProductsSellerDashboardScreen.primary),
      ),
    );
  }

  Widget _productTile(Map<String, dynamic> p) {
    final stockVal = p['stock'] is num ? (p['stock'] as num).toInt() : int.tryParse('${p['stock']}') ?? 0;
    final inStock = stockVal > 5;
    final lowStock = stockVal > 0 && stockVal <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _productThumb(p),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name']?.toString() ?? 'Product',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: WomenProductsSellerDashboardScreen.navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p['category'] ?? ''} · ${p['brand'] ?? ''}',
                      style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _money(p['price'] is num ? p['price'] as num : 0),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: WomenProductsSellerDashboardScreen.primary),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: inStock
                                ? const Color(0xFFDCFCE7)
                                : (lowStock ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            inStock ? 'IN STOCK' : (lowStock ? 'LOW STOCK' : 'OUT OF STOCK'),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: inStock
                                  ? const Color(0xFF166534)
                                  : (lowStock ? const Color(0xFFB45309) : const Color(0xFF991B1B)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () => _editProduct(p), icon: const Icon(Icons.edit_outlined, size: 20)),
              IconButton(onPressed: () => _deleteProduct(p), icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFBE123C))),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),
          // Quick Inline Stock Update Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inventory Stock:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: stockVal > 0 ? () => _quickUpdateStock(p, stockVal - 1) : null,
                  ),
                  InkWell(
                    onTap: () async {
                      final ctrl = TextEditingController(text: '$stockVal');
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Update Stock Quantity'),
                          content: TextField(
                            controller: ctrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Available Units', border: OutlineInputBorder()),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        final val = int.tryParse(ctrl.text.trim()) ?? stockVal;
                        _quickUpdateStock(p, val);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$stockVal units',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () => _quickUpdateStock(p, stockVal + 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderTile(Map<String, dynamic> o) {
    final id = o['id'];
    final oid = id is int ? id : int.tryParse('$id');
    final status = (o['status']?.toString() ?? 'PLACED').toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Order #${o['id'] ?? '-'}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: WomenProductsSellerDashboardScreen.primary)),
              ),
              _statusPill(status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${o['buyerName'] ?? o['customerName'] ?? 'Customer'} · ${_money(o['totalPrice'] is num ? o['totalPrice'] as num : 0)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: WomenProductsSellerDashboardScreen.navy),
          ),
          if ((o['productName']?.toString() ?? '').isNotEmpty)
            Text('Item: ${o['productName']} (Qty: ${o['quantity'] ?? 1})',
                style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
          if ((o['shippingAddress']?.toString() ?? '').isNotEmpty)
            Text('Deliver to: ${o['shippingAddress']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
          if ((o['coachNotes']?.toString() ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Notes: ${o['coachNotes']}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFFB45309))),
            ),
          if (oid != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (status == 'PLACED') ...[
                  FilledButton.tonal(
                    onPressed: () => _updateOrder(oid, 'CONFIRMED'),
                    child: const Text('Confirm Order', style: TextStyle(fontSize: 12)),
                  ),
                  OutlinedButton(
                    onPressed: () => _updateOrder(oid, 'CANCELLED'),
                    child: const Text('Cancel', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                  ),
                ],
                if (status == 'CONFIRMED') ...[
                  FilledButton.tonal(
                    onPressed: () => _updateOrder(oid, 'SHIPPED'),
                    child: const Text('Mark Shipped', style: TextStyle(fontSize: 12)),
                  ),
                  FilledButton.tonal(
                    onPressed: () => _updateOrder(oid, 'READY_FOR_PICKUP'),
                    child: const Text('Ready for Pickup', style: TextStyle(fontSize: 12)),
                  ),
                ],
                if (status == 'SHIPPED') ...[
                  FilledButton.tonal(
                    onPressed: () => _updateOrder(oid, 'OUT_FOR_DELIVERY'),
                    child: const Text('Out for Delivery', style: TextStyle(fontSize: 12)),
                  ),
                ],
                if (status == 'OUT_FOR_DELIVERY') ...[
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF16A34A)),
                    onPressed: () => _updateOrder(oid, 'DELIVERED'),
                    child: const Text('Mark Delivered', style: TextStyle(fontSize: 12)),
                  ),
                ],
                OutlinedButton.icon(
                  onPressed: () => _editNotes(o),
                  icon: const Icon(Icons.note_alt_outlined, size: 14),
                  label: const Text('Notes', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            if ((o['deliveryName']?.toString() ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Assigned Courier: ${o['deliveryName']} ${o['deliveryPhone'] ?? ''}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0284C7))),
              ),
            if (o['canLiveTrack'] == true ||
                status == 'ASSIGNED' ||
                status == 'OUT_FOR_DELIVERY' ||
                status == 'DELIVERED')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => OrderLiveTrackingScreen(
                        orderId: oid,
                        title: 'Order Tracking #$oid',
                        fetchTrack: () => _svc.trackOrder(oid),
                      ),
                    ));
                  },
                  icon: const Icon(Icons.map_outlined, size: 18),
                  label: Text(status == 'DELIVERED' ? 'View Route History' : 'Track Delivery Live'),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0369A1);
    if (status == 'DELIVERED') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF166534);
    } else if (status == 'SHIPPED' || status == 'OUT_FOR_DELIVERY' || status == 'ASSIGNED' || status == 'READY_FOR_PICKUP') {
      bg = const Color(0xFFDBEAFE);
      fg = const Color(0xFF1D4ED8);
    } else if (status == 'CANCELLED') {
      bg = const Color(0xFFFFE4E6);
      fg = const Color(0xFFBE123C);
    } else if (status == 'CONFIRMED' || status == 'PROCESSING' || status == 'PLACED') {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFB45309);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _footerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WomenProductsSellerDashboardScreen.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sell with purpose. Support women-led businesses on Fight D Fear.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, {String? action, VoidCallback? onAction}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy))),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action, style: const TextStyle(color: WomenProductsSellerDashboardScreen.primary, fontWeight: FontWeight.w700))),
      ],
    );
  }

  Widget _empty(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: const TextStyle(color: WomenProductsSellerDashboardScreen.muted)),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
