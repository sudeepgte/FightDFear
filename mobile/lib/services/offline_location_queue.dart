import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class QueuedLocationPoint {
  const QueuedLocationPoint({
    required this.sessionKey,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.timestampEpochMs,
    this.sosId,
  });

  final String sessionKey; // e.g. "sos_123" or "journey"
  final String type; // "sos" or "journey"
  final double latitude;
  final double longitude;
  final int timestampEpochMs;
  final int? sosId;

  Map<String, dynamic> toJson() => {
        'sessionKey': sessionKey,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'timestampEpochMs': timestampEpochMs,
        if (sosId != null) 'sosId': sosId,
      };

  factory QueuedLocationPoint.fromJson(Map<String, dynamic> json) =>
      QueuedLocationPoint(
        sessionKey: json['sessionKey']?.toString() ?? '',
        type: json['type']?.toString() ?? 'sos',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        timestampEpochMs: json['timestampEpochMs'] is int
            ? json['timestampEpochMs'] as int
            : int.tryParse('${json['timestampEpochMs']}') ?? 0,
        sosId: json['sosId'] is int
            ? json['sosId'] as int
            : int.tryParse('${json['sosId']}'),
      );
}

class OfflineLocationQueue {
  OfflineLocationQueue._();
  static final OfflineLocationQueue instance = OfflineLocationQueue._();

  static const String _storageKey = 'offline_location_queue_v1';
  static const int maxPointsPerSession = 50;

  final List<QueuedLocationPoint> _inMemoryQueue = [];
  bool _loaded = false;

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    try {
      final raw = await ApiClient.readStorage(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _inMemoryQueue.clear();
          for (final item in decoded) {
            if (item is Map<String, dynamic>) {
              _inMemoryQueue.add(QueuedLocationPoint.fromJson(item));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading offline location queue: $e');
    } finally {
      _loaded = true;
    }
  }

  Future<void> _persist() async {
    try {
      final jsonList = _inMemoryQueue.map((p) => p.toJson()).toList();
      await ApiClient.writeStorage(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error persisting offline location queue: $e');
    }
  }

  /// Enqueue failed location point, bounding each session to at most 50 items
  Future<void> enqueue(QueuedLocationPoint point) async {
    await _ensureLoaded();

    // Check count for this session
    final sessionPoints = _inMemoryQueue
        .where((p) => p.sessionKey == point.sessionKey)
        .toList();

    if (sessionPoints.length >= maxPointsPerSession) {
      // Remove oldest for this session
      final oldest = sessionPoints.first;
      _inMemoryQueue.remove(oldest);
    }

    _inMemoryQueue.add(point);
    await _persist();
  }

  /// Get pending points for a specific session or all sessions chronologically
  Future<List<QueuedLocationPoint>> getPending([String? sessionKey]) async {
    await _ensureLoaded();
    if (sessionKey == null) {
      return List.unmodifiable(_inMemoryQueue);
    }
    return List.unmodifiable(
      _inMemoryQueue.where((p) => p.sessionKey == sessionKey).toList(),
    );
  }

  /// Clear pending points for a completed or cancelled session
  Future<void> clearSession(String sessionKey) async {
    await _ensureLoaded();
    _inMemoryQueue.removeWhere((p) => p.sessionKey == sessionKey);
    await _persist();
  }

  /// Attempt to flush all queued points to the backend
  Future<int> flush(ApiClient api) async {
    await _ensureLoaded();
    if (_inMemoryQueue.isEmpty) return 0;

    final toFlush = List<QueuedLocationPoint>.from(_inMemoryQueue);
    int flushedCount = 0;

    for (final point in toFlush) {
      try {
        if (point.type == 'sos' && point.sosId != null) {
          final res = await api.post(
            '/api/sos/location/${point.sosId}',
            body: {
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
            timeout: const Duration(seconds: 6),
          );
          if (res['success'] == true) {
            _inMemoryQueue.remove(point);
            flushedCount++;
          } else {
            // Server rejected this specific point (e.g. SOS cancelled/invalid)
            final err = res['error']?.toString() ?? '';
            if (err.contains('not active') || err.contains('not found') || res['_status'] == 404) {
              _inMemoryQueue.remove(point);
            } else {
              break; // Network / transient failure, stop loop
            }
          }
        } else if (point.type == 'journey') {
          final res = await api.post(
            '/api/journey/location',
            body: {
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
            timeout: const Duration(seconds: 6),
          );
          if (res['success'] == true) {
            _inMemoryQueue.remove(point);
            flushedCount++;
          } else {
            final err = res['error']?.toString() ?? '';
            if (err.contains('No active journey') || res['_status'] == 404) {
              _inMemoryQueue.remove(point);
            } else {
              break;
            }
          }
        }
      } catch (e) {
        // Network connection still failing — stop and retry on next cycle
        break;
      }
    }

    if (flushedCount > 0) {
      await _persist();
    }
    return flushedCount;
  }
}
