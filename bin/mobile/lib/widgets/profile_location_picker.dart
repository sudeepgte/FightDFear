import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config/maps_config.dart';

/// Safe location pin for profile forms.
/// Does not embed GoogleMap inside a ListView (that freezes System UI on emulators).
class ProfileLocationPicker extends StatefulWidget {
  const ProfileLocationPicker({
    super.key,
    required this.lat,
    required this.lng,
    required this.mapLinkController,
    required this.onPinned,
    this.onError,
    this.pinLabel = 'Pin on map',
  });

  final double? lat;
  final double? lng;
  final TextEditingController mapLinkController;
  final void Function(double lat, double lng) onPinned;
  final void Function(String message)? onError;
  final String pinLabel;

  @override
  State<ProfileLocationPicker> createState() => _ProfileLocationPickerState();
}

class _ProfileLocationPickerState extends State<ProfileLocationPicker> {
  bool _locating = false;

  Future<void> _useCurrent() async {
    if (_locating) return;
    setState(() => _locating = true);
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        widget.onError?.call('Turn on location services to pin your place.');
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        widget.onError?.call('Location permission is needed to pin your place.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      ).timeout(const Duration(seconds: 10));
      if (!mounted) return;
      _apply(pos.latitude, pos.longitude);
    } on TimeoutException {
      widget.onError?.call('Location timed out. Try “Open map” or paste a Maps link.');
    } catch (e) {
      widget.onError?.call('Could not read location. Try “Open map” or paste a Maps link.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _openMap() async {
    final picked = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (_) => ProfileMapPinScreen(
          initialLat: widget.lat ?? MapsConfig.defaultLat,
          initialLng: widget.lng ?? MapsConfig.defaultLng,
          title: widget.pinLabel,
        ),
      ),
    );
    if (!mounted || picked == null) return;
    _apply(picked.latitude, picked.longitude);
  }

  void _apply(double lat, double lng) {
    widget.mapLinkController.text = 'https://maps.google.com/?q=$lat,$lng';
    widget.onPinned(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final pinned = widget.lat != null && widget.lng != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.pinLabel, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _locating ? null : _useCurrent,
                icon: _locating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location, size: 18),
                label: Text(_locating ? 'Locating…' : 'Use current location'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _openMap,
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('Open map'),
              ),
            ),
          ],
        ),
        if (pinned)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Pinned: ${widget.lat!.toStringAsFixed(5)}, ${widget.lng!.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Optional: pin a point or paste a Google Maps link above.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ),
      ],
    );
  }
}

class ProfileMapPinScreen extends StatefulWidget {
  const ProfileMapPinScreen({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.title,
  });

  final double initialLat;
  final double initialLng;
  final String title;

  @override
  State<ProfileMapPinScreen> createState() => _ProfileMapPinScreenState();
}

class _ProfileMapPinScreenState extends State<ProfileMapPinScreen> {
  late LatLng _pin;

  @override
  void initState() {
    super.initState();
    _pin = LatLng(widget.initialLat, widget.initialLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(_pin),
            child: const Text('Use pin', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _pin, zoom: 15),
        markers: {
          Marker(
            markerId: const MarkerId('pin'),
            position: _pin,
            draggable: true,
            onDragEnd: (pos) => setState(() => _pin = pos),
          ),
        },
        onTap: (pos) => setState(() => _pin = pos),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
      ),
    );
  }
}
