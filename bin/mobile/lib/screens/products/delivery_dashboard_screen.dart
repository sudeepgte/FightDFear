import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../services/auth_state.dart';
import '../../services/delivery_partner_auth_service.dart';
import '../../widgets/module_theme.dart';
import '../../widgets/ux_feedback.dart';
import '../landing/landing_screen.dart';
import 'delivery_profile_completion_screen.dart';
import 'order_live_tracking_screen.dart';

class DeliveryDashboardScreen extends StatefulWidget {
  const DeliveryDashboardScreen({super.key});

  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);
  static const Color muted = Color(0xFF64748B);

  @override
  State<DeliveryDashboardScreen> createState() => _DeliveryDashboardScreenState();
}

class _DeliveryDashboardScreenState extends State<DeliveryDashboardScreen> {
  int _tab = 0;
  bool _loading = true;
  int? _busyId;
  String? _error;
  Map<String, dynamic> _partner = {};
  List<Map<String, dynamic>> _available = [];
  List<Map<String, dynamic>> _assigned = [];
  List<Map<String, dynamic>> _completed = [];
  double _earnings = 0;
  double _payoutBalance = 0;
  String _upiId = '';
  String _cancelPolicy = '';
  StreamSubscription<Position>? _gpsSub;
  Timer? _gpsTimer;
  bool _gpsWarned = false;

  DeliveryPartnerAuthService get _svc =>
      DeliveryPartnerAuthService(context.read<AuthState>().api);

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
      if (!mounted) return;
      if (res['success'] == true) {
        _partner = Map<String, dynamic>.from(res['partner'] ?? {});
        _available = ModuleTheme.toList(res['available']);
        _assigned = ModuleTheme.toList(res['assigned']);
        _completed = ModuleTheme.toList(res['completed']);
        _earnings = (res['totalEarnings'] is num) ? (res['totalEarnings'] as num).toDouble() : 0;
        _payoutBalance = (res['payoutBalance'] is num)
            ? (res['payoutBalance'] as num).toDouble()
            : (_partner['payoutBalance'] is num)
                ? (_partner['payoutBalance'] as num).toDouble()
                : 0;
        _upiId = res['upiId']?.toString() ?? _partner['upiId']?.toString() ?? '';
        _cancelPolicy = res['cancelPolicy']?.toString() ?? '';
      } else {
        _error = res['error']?.toString() ?? 'Failed to load';
      }
    } catch (e) {
      _error = '$e';
    }
    if (mounted) {
      setState(() => _loading = false);
      _syncGps();
    }
  }

  @override
  void dispose() {
    _stopGps();
    super.dispose();
  }

  List<int> get _liveOrderIds {
    final ids = <int>[];
    for (final o in _assigned) {
      final status = (o['status']?.toString() ?? '').toUpperCase();
      if (status != 'ASSIGNED' && status != 'OUT_FOR_DELIVERY') continue;
      final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
      if (id != null) ids.add(id);
    }
    return ids;
  }

  Future<void> _syncGps() async {
    if (!_approved || _liveOrderIds.isEmpty) {
      _stopGps();
      return;
    }
    await _startGps();
  }

  Future<void> _startGps() async {
    if (_gpsSub != null) return;
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!_gpsWarned && mounted) {
          _gpsWarned = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enable location so customers can track your delivery.')),
          );
        }
        return;
      }
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!_gpsWarned && mounted) {
          _gpsWarned = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Turn on GPS to share live tracking.')),
          );
        }
        return;
      }
      _gpsSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
        ),
      ).listen(_pushLocation, onError: (_) {});
      _gpsTimer?.cancel();
      _gpsTimer = Timer.periodic(const Duration(seconds: 12), (_) async {
        try {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 15),
            ),
          );
          await _pushLocation(pos);
        } catch (_) {}
      });
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
        await _pushLocation(pos);
      } catch (_) {}
    } catch (_) {}
  }

  void _stopGps() {
    _gpsSub?.cancel();
    _gpsSub = null;
    _gpsTimer?.cancel();
    _gpsTimer = null;
  }

  Future<void> _pushLocation(Position pos) async {
    final ids = _liveOrderIds;
    if (ids.isEmpty) {
      _stopGps();
      return;
    }
    for (final id in ids) {
      try {
        await _svc.pingLocation(orderId: id, lat: pos.latitude, lng: pos.longitude);
      } catch (_) {}
    }
  }

  bool get _approved => _partner['partnerProfileStatus']?.toString() == 'APPROVED';

  String get _name => _partner['fullName']?.toString() ?? 'Delivery partner';
  String get _first {
    final p = _name.trim().split(RegExp(r'\s+'));
    return p.isEmpty ? 'Partner' : p.first;
  }

  Future<void> _logout() async {
    _stopGps();
    await context.read<AuthState>().api.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LandingScreen()),
      (_) => false,
    );
  }

  Future<void> _act(int id, Future<Map<String, dynamic>> Function() run, String okMsg) async {
    if (_busyId != null) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busyId = id);
    final res = await run();
    if (!mounted) return;
    setState(() => _busyId = null);
    messenger.showSnackBar(SnackBar(
      content: Text(res['success'] == true ? okMsg : (res['error']?.toString() ?? 'Failed')),
    ));
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
    final ctrl = TextEditingController(text: o['deliveryNotes']?.toString() ?? o['coachNotes']?.toString() ?? '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delivery notes'),
        content: TextField(
          controller: ctrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Gate code, COD collected, drop instructions…',
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _tab != 0) setState(() => _tab = 0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _nav(0, Icons.inventory_2_outlined, Icons.inventory_2, 'Ready', _available.length),
                _nav(1, Icons.local_shipping_outlined, Icons.local_shipping, 'Active', _assigned.length),
                _nav(2, Icons.check_circle_outline, Icons.check_circle, 'Done'),
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
                      children: [_readyTab(), _activeTab(), _doneTab(), _profileTab()],
                    ),
                  ),
      ),
    );
  }

  Widget _nav(int i, IconData o, IconData f, String label, [int badge = 0]) {
    final on = _tab == i;
    final c = on ? DeliveryDashboardScreen.primary : const Color(0xFF94A3B8);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _tab = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(on ? f : o, color: c, size: 22),
                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: DeliveryDashboardScreen.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('$badge',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            Text(label,
                style: TextStyle(fontSize: 10, fontWeight: on ? FontWeight.w700 : FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }

  Widget _readyTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Text('Hi $_first',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: DeliveryDashboardScreen.navy)),
          const Text('Packed orders waiting for pickup',
              style: TextStyle(fontSize: 12, color: DeliveryDashboardScreen.muted)),
          const SizedBox(height: 12),
          if (!_approved)
            ProfileCompletionCard(
              percent: (_partner['profileCompletionPct'] is num)
                  ? (_partner['profileCompletionPct'] as num).toDouble()
                  : 0,
              statusLabel: _partner['partnerProfileStatusLabel']?.toString() ?? 'Pending',
              hint: 'Complete your profile and wait for admin approval before accepting deliveries.',
              actionLabel: 'Complete profile',
              onAction: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const DeliveryProfileCompletionScreen()))
                    .then((_) => _load());
              },
            )
          else if (_available.isEmpty)
            _empty('No packed orders yet.')
          else
            ..._available.map((o) => _card(o, accept: true)),
        ],
      ),
    );
  }

  Widget _activeTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          const Text('Active deliveries',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: DeliveryDashboardScreen.navy)),
          const SizedBox(height: 12),
          if (_assigned.isEmpty)
            _empty('Accept a packed order to start delivering.')
          else
            ..._assigned.map((o) => _card(o, active: true)),
        ],
      ),
    );
  }

  Widget _doneTab() {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          const Text('Completed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: DeliveryDashboardScreen.navy)),
          const SizedBox(height: 12),
          if (_completed.isEmpty)
            _empty('Delivered orders appear here.')
          else
            ..._completed.map((o) => _card(o)),
        ],
      ),
    );
  }

  Widget _profileTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Text(_name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: DeliveryDashboardScreen.navy)),
        Text('${_partner['vehicleType'] ?? 'Vehicle'} · ${_partner['city'] ?? 'City not set'}',
            style: const TextStyle(color: DeliveryDashboardScreen.muted)),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined, color: DeliveryDashboardScreen.primary),
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
            title: const Text('Delivery earnings'),
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
            backgroundColor: DeliveryDashboardScreen.primary,
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Request UPI payout'),
        ),
        const SizedBox(height: 8),
        Text(
          _cancelPolicy.isNotEmpty
              ? 'Payout on delivered orders. Min ₹100. $_cancelPolicy'
              : 'Payout on delivered orders. Min ₹100 UPI.',
          style: const TextStyle(color: DeliveryDashboardScreen.muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
        FilledButton.tonal(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const DeliveryProfileCompletionScreen()))
                .then((_) => _load());
          },
          child: const Text('Edit profile'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  Widget _card(Map<String, dynamic> o, {bool accept = false, bool active = false}) {
    final id = o['id'] is int ? o['id'] as int : int.tryParse('${o['id']}');
    final status = (o['status']?.toString() ?? '').toUpperCase();
    final busy = id != null && _busyId == id;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(o['productName']?.toString() ?? 'Order #${o['id']}',
              style: const TextStyle(fontWeight: FontWeight.w800, color: DeliveryDashboardScreen.navy)),
          Text('Qty ${o['quantity'] ?? 1} · Rs ${o['totalPrice'] ?? 0}',
              style: const TextStyle(fontSize: 12, color: DeliveryDashboardScreen.muted)),
          const SizedBox(height: 6),
          Text('Pickup: ${o['pickupAddress'] ?? o['sellerName'] ?? '—'}',
              style: const TextStyle(fontSize: 12)),
          Text('Drop: ${o['shippingAddress'] ?? '—'}', style: const TextStyle(fontSize: 12)),
          Text('Buyer: ${o['buyerName'] ?? '—'} ${o['buyerPhone'] ?? ''}',
              style: const TextStyle(fontSize: 12, color: DeliveryDashboardScreen.muted)),
          if ((o['deliveryNotes']?.toString() ?? '').isNotEmpty)
            Text('Notes: ${o['deliveryNotes']}',
                style: const TextStyle(fontSize: 12, color: DeliveryDashboardScreen.muted)),
          const SizedBox(height: 8),
          Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
          TextButton(onPressed: () => _editNotes(o), child: const Text('Delivery notes')),
          if (id != null && (active || status == 'DELIVERED' || o['canLiveTrack'] == true))
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => OrderLiveTrackingScreen(
                    orderId: id,
                    title: 'Delivery map',
                    fetchTrack: () => _svc.trackOrder(id),
                  ),
                ));
              },
              icon: const Icon(Icons.map_outlined, size: 18),
              label: const Text('Open map'),
            ),
          if (accept && id != null)
            FilledButton(
              onPressed: busy || !_approved ? null : () => _act(id, () => _svc.acceptOrder(id), 'Accepted'),
              style: FilledButton.styleFrom(backgroundColor: DeliveryDashboardScreen.primary),
              child: Text(busy ? 'Updating…' : 'Accept pickup'),
            ),
          if (active && id != null) ...[
            if (status == 'ASSIGNED')
              FilledButton(
                onPressed: busy ? null : () => _act(id, () => _svc.updateOrderStatus(id, 'OUT_FOR_DELIVERY'), 'Picked up'),
                child: Text(busy ? 'Updating…' : 'Mark picked up'),
              ),
            if (status == 'OUT_FOR_DELIVERY')
              FilledButton(
                onPressed: busy ? null : () => _act(id, () => _svc.updateOrderStatus(id, 'DELIVERED'), 'Delivered'),
                style: FilledButton.styleFrom(backgroundColor: DeliveryDashboardScreen.primary),
                child: Text(busy ? 'Updating…' : 'Mark delivered'),
              ),
          ],
        ],
      ),
    );
  }

  Widget _empty(String t) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Text(t, style: const TextStyle(color: DeliveryDashboardScreen.muted)),
      );
}
