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
import 'women_products_seller_profile_completion_screen.dart';

class WomenProductsSellerDashboardScreen extends StatefulWidget {
  const WomenProductsSellerDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);
  static const Color softPink = Color(0xFFFFF1F2);
  static const Color softBg = Color(0xFFFAF7F8);

  @override
  State<WomenProductsSellerDashboardScreen> createState() => _WomenProductsSellerDashboardScreenState();
}

class _WomenProductsSellerDashboardScreenState extends State<WomenProductsSellerDashboardScreen> {
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
      final res = await WomenProductsSellerAuthService(context.read<AuthState>().api).dashboard();
      if (res['success'] == true) {
        _seller = Map<String, dynamic>.from(res['seller'] ?? {});
        _products = ModuleTheme.toList(res['products']);
        _orders = ModuleTheme.toList(res['orders']);
        _earnings = (res['totalEarnings'] is num) ? (res['totalEarnings'] as num).toDouble() : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_seller['payoutBalance'] is num)
                ? (_seller['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _seller['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? SellerCatalog.cancelPolicy;
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await context.read<AuthState>().api.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  bool get _approved => _seller['partnerProfileStatus']?.toString() == 'APPROVED';

  WomenProductsSellerAuthService get _svc =>
      WomenProductsSellerAuthService(context.read<AuthState>().api);

  void _openProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const WomenProductsSellerProfileCompletionScreen()))
        .then((_) => _load());
  }

  Future<void> _addProduct() => _editProduct();

  Future<void> _editProduct([Map<String, dynamic>? existing]) async {
    if (!_approved) {
      _toast('Complete your shop profile and wait for admin approval before listing products.');
      _openProfile();
      return;
    }
    final isEdit = existing != null;
    final name = TextEditingController(text: existing?['name']?.toString() ?? '');
    final brand = TextEditingController(
        text: existing?['brand']?.toString() ?? _seller['businessName']?.toString() ?? 'Own Brand');
    final price = TextEditingController(text: '${existing?['price'] ?? '199'}');
    final stock = TextEditingController(text: '${existing?['stock'] ?? '10'}');
    final desc = TextEditingController(text: existing?['description']?.toString() ?? '');
    final codes = SellerCatalog.categories.map((c) => c.code).toList();
    String cat = existing?['category']?.toString() ?? codes.first;
    if (!codes.contains(cat)) cat = codes.first;
    String? pickedPath;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(isEdit ? 'Edit Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Product name *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: brand, decoration: const InputDecoration(labelText: 'Brand *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: cat,
                  decoration: const InputDecoration(labelText: 'Category *', border: OutlineInputBorder()),
                  items: SellerCatalog.categories
                      .map((c) => DropdownMenuItem(value: c.code, child: Text(c.label)))
                      .toList(),
                  onChanged: (v) => setLocal(() => cat = v ?? cat),
                ),
                const SizedBox(height: 10),
                TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (Rs) *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () async {
                    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
                    if (file != null) setLocal(() => pickedPath = file.path);
                  },
                  icon: const Icon(Icons.photo_outlined),
                  label: Text(pickedPath != null ? 'Photo selected' : (existing?['imagePath'] != null ? 'Change photo' : 'Add product photo')),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: WomenProductsSellerDashboardScreen.primary),
              onPressed: () {
                      if (name.text.trim().isEmpty || brand.text.trim().isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Name and brand are required.')),
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
              child: Text(isEdit ? 'Update' : 'Save'),
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
      'stock': int.tryParse(stock.text.trim()) ?? 0,
      'description': desc.text.trim(),
    };
    Map<String, dynamic> res;
    if (isEdit) {
      final id = existing['id'] is int ? existing['id'] as int : int.tryParse('${existing['id']}');
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
            ? (isEdit ? 'Product updated' : 'Product added')
            : '${res['error']}'),
        backgroundColor: res['success'] == true ? Colors.teal : Colors.red.shade700,
      ),
    );
    if (res['success'] == true) {
      setState(() => _tab = 1);
      _load();
    }
  }

  Future<void> _deleteProduct(Map<String, dynamic> p) async {
    final id = p['id'] is int ? p['id'] as int : int.tryParse('${p['id']}');
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove product?'),
        content: Text('Remove "${p['name'] ?? 'this product'}" from your shop?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Remove')),
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
            ? (res['message']?.toString() ?? 'Requested')
            : (res['error']?.toString() ?? 'Payout failed')),
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
        title: const Text('Packing notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Packed items, gift wrap, delivery instructions…',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true) return;
    final res = await _svc.updateOrderNotes(oid, ctrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true
            ? 'Notes saved'
            : (res['error']?.toString() ?? 'Could not save notes')),
      ),
    );
    if (res['success'] == true) _load();
  }

  Future<void> _updateOrder(int id, String status) async {
    final res = await _svc.updateOrderStatus(id, status);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res['success'] == true ? 'Order updated to $status' : '${res['error']}')),
    );
    if (res['success'] == true) _load();
  }

  String get _name => _seller['fullName']?.toString() ?? 'Seller';
  String get _firstName => _name.trim().split(RegExp(r'\s+')).first;
  String get _shop => _seller['businessName']?.toString() ?? 'My Shop';
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
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
      backgroundColor: WomenProductsSellerDashboardScreen.softBg,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: WomenProductsSellerDashboardScreen.primary,
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
                    index: _tab,
                    children: [_home(), _productsTab(), _ordersTab(), _shopTab()],
                  ),
                ),
        ),
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
                    Text('${_greeting()}, $_firstName! 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
                    const Text('Seller Dashboard · manage products & orders', style: TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
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
              statusLabel: _seller['partnerProfileStatusLabel']?.toString() ?? 'Pending',
              hint: 'Complete shop details and wait for admin approval before listing products.',
              actionLabel: 'Complete profile',
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
            _empty('No products yet. Tap + to add your first product.')
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
        gradient: const LinearGradient(colors: [Color(0xFF7C1D4D), Color(0xFFD93662)], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                      child: const Text('Active', style: TextStyle(color: Color(0xFF166534), fontSize: 10, fontWeight: FontWeight.w800)),
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
      (Icons.visibility_outlined, 'Store Views', '—', const Color(0xFFFEF3C7)),
      (Icons.account_balance_wallet_outlined, 'Revenue', _money(_earnings), const Color(0xFFFFE4E6)),
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
      (Icons.inventory_2_outlined, 'Manage Products', () => setState(() => _tab = 1)),
      (Icons.receipt_long_outlined, 'Orders', () => setState(() => _tab = 2)),
      (Icons.warehouse_outlined, 'Inventory', () => setState(() => _tab = 1)),
      (Icons.payments_outlined, 'Earnings', () => setState(() => _tab = 3)),
      (Icons.people_outline, 'Customers', () => _toast('Customers coming soon')),
      (Icons.star_outline, 'Reviews', () => _toast('Reviews coming soon')),
      (Icons.campaign_outlined, 'Marketing', () => _toast('Marketing coming soon')),
      (Icons.insights_outlined, 'Analytics', () => _toast('Analytics coming soon')),
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
              const Expanded(child: Text('My Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy))),
              FilledButton.icon(
                onPressed: _addProduct,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
                style: FilledButton.styleFrom(backgroundColor: WomenProductsSellerDashboardScreen.primary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_products.isEmpty) _empty('No products yet.') else ..._products.map(_productTile),
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
          const Text('Orders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
          const SizedBox(height: 14),
          if (_orders.isEmpty) _empty('No orders yet.') else ..._orders.map(_orderTile),
        ],
      ),
    );
  }

  Widget _shopTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        const Text('Finance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined,
                color: WomenProductsSellerDashboardScreen.primary),
            title: const Text('Payout balance'),
            subtitle: Text(_upiId.isEmpty
                ? 'Add UPI in Complete Profile to withdraw'
                : 'UPI: $_upiId'),
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
            title: const Text('Confirmed earnings'),
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
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(
          _cancelPolicy.isNotEmpty
              ? _cancelPolicy
              : 'Minimum payout ₹100. Online orders credit when paid; COD credits on delivery.',
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
        ),
        const SizedBox(height: 20),
        _storeHero(),
        const SizedBox(height: 14),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.person), title: const Text('Seller'), subtitle: Text(_name)),
        const SizedBox(height: 8),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.email), title: const Text('Email'), subtitle: Text(_seller['email']?.toString() ?? '—')),
        const SizedBox(height: 8),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.phone), title: const Text('Phone'), subtitle: Text(_seller['phone']?.toString() ?? '—')),
        const SizedBox(height: 8),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), leading: const Icon(Icons.place), title: const Text('Address'), subtitle: Text(_address)),
        const SizedBox(height: 16),
        FilledButton.tonal(onPressed: _openProfile, child: const Text('Edit shop profile')),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: OutlinedButton.styleFrom(
            foregroundColor: WomenProductsSellerDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: WomenProductsSellerDashboardScreen.primary),
          ),
        ),
      ],
    );
  }

  Widget _productThumb(Map<String, dynamic> p) {
    final url = _mediaUrl(p['imagePath']?.toString());
    const size = 48.0;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _productThumb(p),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name']?.toString() ?? 'Product', style: const TextStyle(fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.navy)),
                Text('${p['category'] ?? ''} · Stock ${p['stock'] ?? 0}', style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
              ],
            ),
          ),
          Text(_money(p['price'] is num ? p['price'] as num : 0), style: const TextStyle(fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.primary)),
          IconButton(onPressed: () => _editProduct(p), icon: const Icon(Icons.edit_outlined, size: 20)),
          IconButton(onPressed: () => _deleteProduct(p), icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFBE123C))),
        ],
      ),
    );
  }

  Widget _orderTile(Map<String, dynamic> o) {
    final id = o['id'];
    final oid = id is int ? id : int.tryParse('$id');
    final status = (o['status']?.toString() ?? 'PLACED').toUpperCase();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Order #${o['id'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w800, color: WomenProductsSellerDashboardScreen.primary))),
              _statusPill(status),
            ],
          ),
          const SizedBox(height: 4),
          Text('${o['buyerName'] ?? o['customerName'] ?? 'Customer'} · ${_money(o['totalPrice'] is num ? o['totalPrice'] as num : 0)}', style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
          if ((o['coachNotes']?.toString() ?? '').isNotEmpty)
            Text('Notes: ${o['coachNotes']}', style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
          if (oid != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                if (status == 'PLACED') ...[
                  ActionChip(label: const Text('Confirm', style: TextStyle(fontSize: 10)), onPressed: () => _updateOrder(oid, 'CONFIRMED')),
                  ActionChip(label: const Text('Cancel', style: TextStyle(fontSize: 10)), onPressed: () => _updateOrder(oid, 'CANCELLED')),
                ],
                if (status == 'CONFIRMED') ...[
                  ActionChip(label: const Text('Ready for pickup', style: TextStyle(fontSize: 10)), onPressed: () => _updateOrder(oid, 'READY_FOR_PICKUP')),
                  ActionChip(label: const Text('Cancel', style: TextStyle(fontSize: 10)), onPressed: () => _updateOrder(oid, 'CANCELLED')),
                ],
                ActionChip(label: const Text('Notes', style: TextStyle(fontSize: 10)), onPressed: () => _editNotes(o)),
              ],
            ),
            if ((o['deliveryName']?.toString() ?? '').isNotEmpty)
              Text('Delivery: ${o['deliveryName']} ${o['deliveryPhone'] ?? ''}',
                  style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
            if ((o['trackingNote']?.toString() ?? '').isNotEmpty)
              Text(o['trackingNote'].toString(),
                  style: const TextStyle(fontSize: 12, color: WomenProductsSellerDashboardScreen.muted)),
            if (o['canLiveTrack'] == true ||
                status == 'ASSIGNED' ||
                status == 'OUT_FOR_DELIVERY' ||
                status == 'DELIVERED')
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => OrderLiveTrackingScreen(
                      orderId: oid,
                      title: 'Order tracking',
                      fetchTrack: () => _svc.trackOrder(oid),
                    ),
                  ));
                },
                icon: const Icon(Icons.map_outlined, size: 18),
                label: Text(status == 'DELIVERED' ? 'View route' : 'Live track'),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  Widget _footerBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: WomenProductsSellerDashboardScreen.primary, borderRadius: BorderRadius.circular(18)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: const TextStyle(color: WomenProductsSellerDashboardScreen.muted)),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      );
}
