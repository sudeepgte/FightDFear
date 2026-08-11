import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/seller_catalog.dart';
import '../../services/auth_state.dart';
import '../../services/women_products_seller_auth_service.dart';
import '../../widgets/module_theme.dart';
import 'women_products_seller_login_screen.dart';

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
      MaterialPageRoute(builder: (_) => const WomenProductsSellerLoginScreen()),
      (_) => false,
    );
  }

  Future<void> _addProduct() async {
    final name = TextEditingController();
    final brand = TextEditingController(text: _seller['businessName']?.toString() ?? 'Own Brand');
    final price = TextEditingController(text: '199');
    final stock = TextEditingController(text: '10');
    final desc = TextEditingController();
    final categoryLabels = SellerCatalog.categories.map((c) => c.label).toList();
    String cat = categoryLabels.first;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Add Product'),
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
                  items: categoryLabels.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setLocal(() => cat = v ?? cat),
                ),
                const SizedBox(height: 10),
                TextField(controller: price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (Rs) *', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: stock, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: WomenProductsSellerDashboardScreen.primary),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final res = await WomenProductsSellerAuthService(context.read<AuthState>().api).addProduct({
      'name': name.text.trim(),
      'brand': brand.text.trim().isEmpty ? 'Own Brand' : brand.text.trim(),
      'category': cat,
      'price': double.tryParse(price.text.trim()) ?? 0,
      'stock': int.tryParse(stock.text.trim()) ?? 10,
      'description': desc.text.trim(),
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res['success'] == true ? 'Product added' : '${res['error']}'),
        backgroundColor: res['success'] == true ? Colors.teal : Colors.red.shade700,
      ),
    );
    if (res['success'] == true) {
      setState(() => _tab = 1);
      _load();
    }
  }

  Future<void> _updateOrder(int id, String status) async {
    final res = await WomenProductsSellerAuthService(context.read<AuthState>().api).updateOrderStatus(id, status);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _nav(3, Icons.storefront_outlined, Icons.storefront, 'Shop'),
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
      (Icons.payments_outlined, 'Earnings', () => _toast('Earnings: ${_money(_earnings)}')),
      (Icons.people_outline, 'Customers', () => _toast('Customers coming soon')),
      (Icons.star_outline, 'Reviews', () => _toast('Reviews coming soon')),
      (Icons.campaign_outlined, 'Marketing', () => _toast('Marketing coming soon')),
      (Icons.insights_outlined, 'Analytics', () => _toast('Analytics coming soon')),
      (Icons.storefront_outlined, 'Store Profile', () => setState(() => _tab = 3)),
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

  Widget _productTile(Map<String, dynamic> p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: WomenProductsSellerDashboardScreen.softPink, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.shopping_bag_outlined, color: WomenProductsSellerDashboardScreen.primary),
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
          if (oid != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: ['CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED']
                  .map((s) => ActionChip(
                        label: Text(s, style: const TextStyle(fontSize: 10)),
                        onPressed: () => _updateOrder(oid, s),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
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
    } else if (status == 'SHIPPED') {
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
