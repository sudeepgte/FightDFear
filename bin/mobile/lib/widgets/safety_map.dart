import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/maps_config.dart';

class MapPin {
  const MapPin({
    required this.id,
    required this.lat,
    required this.lng,
    required this.title,
    this.snippet,
    this.severity = 1,
    this.isUser = false,
  });

  final String id;
  final double lat;
  final double lng;
  final String title;
  final String? snippet;
  final int severity;
  final bool isUser;
}

/// Google Map with danger / SOS markers.
class SafetyMapView extends StatefulWidget {
  const SafetyMapView({
    super.key,
    required this.pins,
    this.userLat,
    this.userLng,
    this.height,
    this.borderRadius = 16,
    this.onMapCreated,
  });

  final List<MapPin> pins;
  final double? userLat;
  final double? userLng;
  final double? height;
  final double borderRadius;
  final void Function(GoogleMapController controller)? onMapCreated;

  @override
  State<SafetyMapView> createState() => _SafetyMapViewState();
}

class _SafetyMapViewState extends State<SafetyMapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _buildMarkers();
  }

  @override
  void didUpdateWidget(SafetyMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pins != widget.pins ||
        oldWidget.userLat != widget.userLat ||
        oldWidget.userLng != widget.userLng) {
      _buildMarkers();
      _fitBounds();
    }
  }

  LatLng get _center {
    if (widget.userLat != null && widget.userLng != null) {
      return LatLng(widget.userLat!, widget.userLng!);
    }
    if (widget.pins.isNotEmpty) {
      return LatLng(widget.pins.first.lat, widget.pins.first.lng);
    }
    return const LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng);
  }

  double _hueForSeverity(int severity) {
    if (severity >= 4) return BitmapDescriptor.hueRed;
    if (severity >= 3) return BitmapDescriptor.hueOrange;
    if (severity >= 2) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueAzure;
  }

  void _buildMarkers() {
    final markers = <Marker>{};
    if (widget.userLat != null && widget.userLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(widget.userLat!, widget.userLng!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    }
    for (final pin in widget.pins) {
      markers.add(
        Marker(
          markerId: MarkerId(pin.id),
          position: LatLng(pin.lat, pin.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            pin.isUser
                ? BitmapDescriptor.hueRed
                : _hueForSeverity(pin.severity),
          ),
          infoWindow: InfoWindow(
            title: pin.title,
            snippet: pin.snippet,
          ),
        ),
      );
    }
    setState(() => _markers = markers);
  }

  Future<void> _fitBounds() async {
    final controller = _controller;
    if (controller == null) return;

    final points = <LatLng>[];
    if (widget.userLat != null && widget.userLng != null) {
      points.add(LatLng(widget.userLat!, widget.userLng!));
    }
    for (final p in widget.pins) {
      points.add(LatLng(p.lat, p.lng));
    }
    if (points.isEmpty) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(_center, 14),
      );
      return;
    }
    if (points.length == 1) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(points.first, 15),
      );
      return;
    }

    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;
    for (final p in points.skip(1)) {
      minLat = minLat < p.latitude ? minLat : p.latitude;
      maxLat = maxLat > p.latitude ? maxLat : p.latitude;
      minLng = minLng < p.longitude ? minLng : p.longitude;
      maxLng = maxLng > p.longitude ? maxLng : p.longitude;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
  }

  @override
  Widget build(BuildContext context) {
    final map = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 14),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: false,
        onMapCreated: (c) {
          _controller = c;
          widget.onMapCreated?.call(c);
          _fitBounds();
        },
      ),
    );

    if (widget.height != null) {
      return SizedBox(height: widget.height, child: map);
    }
    return map;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
