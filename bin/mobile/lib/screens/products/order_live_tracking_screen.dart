import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/maps_config.dart';

class OrderLiveTrackingScreen extends StatefulWidget {
  const OrderLiveTrackingScreen({
    super.key,
    required this.orderId,
    required this.fetchTrack,
    this.title = 'Live tracking',
  });

  final int orderId;
  final String title;
  final Future<Map<String, dynamic>> Function() fetchTrack;

  @override
  State<OrderLiveTrackingScreen> createState() => _OrderLiveTrackingScreenState();
}

class _OrderLiveTrackingScreenState extends State<OrderLiveTrackingScreen> {
  static const Color primary = Color(0xFFF43F5E);
  static const Color navy = Color(0xFF1E1B4B);

  GoogleMapController? _map;
  Timer? _poll;
  bool _loading = true;
  bool _fitted = false;
  String? _error;
  Map<String, dynamic> _track = {};

  @override
  void initState() {
    super.initState();
    _refresh(first: true);
    _poll = Timer.periodic(const Duration(seconds: 6), (_) => _refresh());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _map?.dispose();
    super.dispose();
  }

  Future<void> _refresh({bool first = false}) async {
    try {
      final res = await widget.fetchTrack();
      if (!mounted) return;
      if (res['success'] == true) {
        setState(() {
          _track = res;
          _loading = false;
          _error = null;
        });
        if (_map != null) _fitIfNeeded(force: first && !_fitted);
      } else {
        setState(() {
          _loading = false;
          _error = res['error']?.toString() ?? 'Could not load tracking';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  double? _coord(dynamic point, String key) {
    if (point is! Map) return null;
    final v = point[key];
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  LatLng? _latLng(dynamic point) {
    final lat = _coord(point, 'lat');
    final lng = _coord(point, 'lng');
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  Set<Marker> get _markers {
    final out = <Marker>{};
    final pickup = _latLng(_track['pickup']);
    final drop = _latLng(_track['drop']);
    final courier = _latLng(_track['courier']);
    if (pickup != null) {
      out.add(Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: _track['sellerName']?.toString() ?? _track['pickupAddress']?.toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    }
    if (drop != null) {
      out.add(Marker(
        markerId: const MarkerId('drop'),
        position: drop,
        infoWindow: InfoWindow(
          title: 'Drop',
          snippet: _track['shippingAddress']?.toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ));
    }
    if (courier != null) {
      out.add(Marker(
        markerId: const MarkerId('courier'),
        position: courier,
        rotation: 0,
        infoWindow: InfoWindow(
          title: _track['deliveryName']?.toString() ?? 'Delivery partner',
          snippet: _track['deliveryVehicle']?.toString(),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }
    return out;
  }

  Set<Polyline> get _polylines {
    final raw = _track['route'];
    if (raw is! List || raw.isEmpty) return {};
    final pts = <LatLng>[];
    for (final row in raw) {
      if (row is! Map) continue;
      final p = _latLng(row);
      if (p != null) pts.add(p);
    }
    if (pts.length < 2) return {};
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: pts,
        color: primary,
        width: 5,
      ),
    };
  }

  Future<void> _fitIfNeeded({bool force = false}) async {
    final c = _map;
    if (c == null) return;
    if (_fitted && !force) return;
    final pts = <LatLng>[
      if (_latLng(_track['pickup']) != null) _latLng(_track['pickup'])!,
      if (_latLng(_track['drop']) != null) _latLng(_track['drop'])!,
      if (_latLng(_track['courier']) != null) _latLng(_track['courier'])!,
    ];
    if (pts.isEmpty) return;
    try {
      if (pts.length == 1) {
        await c.animateCamera(CameraUpdate.newLatLngZoom(pts.first, 15));
      } else {
        var minLat = pts.first.latitude;
        var maxLat = pts.first.latitude;
        var minLng = pts.first.longitude;
        var maxLng = pts.first.longitude;
        for (final p in pts) {
          minLat = minLat < p.latitude ? minLat : p.latitude;
          maxLat = maxLat > p.latitude ? maxLat : p.latitude;
          minLng = minLng < p.longitude ? minLng : p.longitude;
          maxLng = maxLng > p.longitude ? maxLng : p.longitude;
        }
        await c.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          72,
        ));
      }
      _fitted = true;
    } catch (_) {}
  }

  String get _eta {
    final m = _track['etaMinutes'];
    final km = _track['remainingKm'];
    final parts = <String>[];
    if (m is num && m > 0) parts.add('${m.round()} min');
    if (km is num && km > 0) parts.add('${km.toStringAsFixed(1)} km');
    if (parts.isEmpty) return _track['live'] == true ? 'Updating route…' : 'Waiting for live location';
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final live = _track['live'] == true;
    final status = (_track['status']?.toString() ?? '').toUpperCase();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: navy,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: () => _refresh(first: true), icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(_error!, textAlign: TextAlign.center),
                ))
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                      color: live ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _track['productName']?.toString() ?? 'Order #${widget.orderId}',
                            style: const TextStyle(fontWeight: FontWeight.w800, color: navy),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            live ? 'Live · $_eta' : '$status · $_eta',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: live ? const Color(0xFF166534) : const Color(0xFF9A3412),
                            ),
                          ),
                          if ((_track['deliveryName']?.toString() ?? '').isNotEmpty)
                            Text(
                              '${_track['deliveryName']} · ${_track['deliveryPhone'] ?? ''} ${_track['deliveryVehicle'] ?? ''}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          if ((_track['trackingNote']?.toString() ?? '').isNotEmpty)
                            Text(_track['trackingNote'].toString(),
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng),
                          zoom: 12,
                        ),
                        markers: _markers,
                        polylines: _polylines,
                        myLocationEnabled: false,
                        compassEnabled: true,
                        zoomControlsEnabled: false,
                        onMapCreated: (c) {
                          _map = c;
                          _fitIfNeeded(force: true);
                        },
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _addr('Pickup', _track['pickupAddress']?.toString() ?? _track['sellerName']?.toString()),
                            const SizedBox(height: 6),
                            _addr('Drop', _track['shippingAddress']?.toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _addr(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: primary)),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF334155)))),
      ],
    );
  }
}
