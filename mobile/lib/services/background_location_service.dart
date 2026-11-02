import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import 'api_client.dart';
import 'offline_location_queue.dart';

@pragma('vm:entry-point')
void trackingCallback() {
  FlutterForegroundTask.setTaskHandler(BackgroundLocationTaskHandler());
}

class BackgroundLocationTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}

class BackgroundLocationService {
  BackgroundLocationService._();
  static final BackgroundLocationService instance = BackgroundLocationService._();

  bool _initialized = false;
  int? _activeSosId;
  bool _isJourneyActive = false;
  ApiClient? _api;

  StreamSubscription<Position>? _positionSub;
  Timer? _fallbackTimer;
  Position? _lastKnownPosition;
  DateTime? _lastTransmissionTime;

  bool get isSosActive => _activeSosId != null;
  bool get isJourneyActive => _isJourneyActive;
  bool get isTracking => isSosActive || isJourneyActive;
  Position? get lastKnownPosition => _lastKnownPosition;

  /// Initialize foreground notification channels and task options.
  Future<void> init() async {
    if (_initialized) return;
    try {
      FlutterForegroundTask.init(
        androidNotificationOptions: AndroidNotificationOptions(
          channelId: 'fight_d_fear_safety_tracking',
          channelName: 'Emergency & Safety Tracking',
          channelDescription:
              'Continuous location updates for active SOS emergency alerts and Journey check-ins.',
          channelImportance: NotificationChannelImportance.HIGH,
          priority: NotificationPriority.HIGH,
          enableVibration: false,
          playSound: false,
        ),
        iosNotificationOptions: const IOSNotificationOptions(),
        foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(5000),
          autoRunOnBoot: false,
          allowWakeLock: true,
          allowWifiLock: true,
        ),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing FlutterForegroundTask: $e');
    }
  }

  /// Request runtime location and Android 13+ notification permissions.
  Future<bool> checkAndRequestPermissions() async {
    try {
      // 1. Notification permission for Android 13+ (API 33+)
      if (Platform.isAndroid) {
        final notifPerm = await FlutterForegroundTask.checkNotificationPermission();
        if (notifPerm != NotificationPermission.granted) {
          await FlutterForegroundTask.requestNotificationPermission();
        }
      }

      // 2. Location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting location permissions: $e');
      return false;
    }
  }

  /// Start high-priority SOS emergency tracking.
  Future<void> startSosTracking(int sosId, ApiClient api) async {
    _activeSosId = sosId;
    _api = api;
    await init();
    await _applyTrackingLifecycle();
  }

  /// Stop SOS emergency tracking without stopping active Journey tracking.
  Future<void> stopSosTracking() async {
    final sosId = _activeSosId;
    _activeSosId = null;
    if (sosId != null) {
      unawaited(OfflineLocationQueue.instance.clearSession('sos_$sosId'));
    }
    await _applyTrackingLifecycle();
  }

  /// Start Journey safety tracking.
  Future<void> startJourneyTracking(ApiClient api) async {
    _isJourneyActive = true;
    _api = api;
    await init();
    await _applyTrackingLifecycle();
  }

  /// Stop Journey safety tracking without stopping active SOS emergency tracking.
  Future<void> stopJourneyTracking() async {
    _isJourneyActive = false;
    unawaited(OfflineLocationQueue.instance.clearSession('journey'));
    await _applyTrackingLifecycle();
  }

  /// Manage foreground service state and GPS listener based on active sessions.
  Future<void> _applyTrackingLifecycle() async {
    if (!isTracking) {
      // Stop all background tracking
      await _positionSub?.cancel();
      _positionSub = null;
      _fallbackTimer?.cancel();
      _fallbackTimer = null;
      try {
        if (await FlutterForegroundTask.isRunningService) {
          await FlutterForegroundTask.stopService();
        }
      } catch (e) {
        debugPrint('Error stopping foreground service: $e');
      }
      return;
    }

    // Determine tracking profile
    final bool sosPriority = isSosActive;
    final String notifTitle = sosPriority
        ? 'Fight D Fear – SOS Emergency Active'
        : 'Fight D Fear – Journey Safety Active';
    final String notifText = sosPriority
        ? 'Live emergency location is actively being shared with your contacts and responders.'
        : 'Journey check-in location is actively being monitored.';

    // Start or update Android foreground service
    try {
      final running = await FlutterForegroundTask.isRunningService;
      if (running) {
        await FlutterForegroundTask.updateService(
          notificationTitle: notifTitle,
          notificationText: notifText,
        );
      } else {
        await FlutterForegroundTask.startService(
          serviceId: 256,
          notificationTitle: notifTitle,
          notificationText: notifText,
          callback: trackingCallback,
        );
      }
    } catch (e) {
      debugPrint('Foreground service start/update warning: $e');
    }

    // Configure adaptive location stream
    final LocationSettings locationSettings;
    if (sosPriority) {
      // SOS: High precision, interval 5-10s, distanceFilter 10m
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    } else {
      // Journey: Medium precision, interval 30-60s, distanceFilter 50m
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
      );
    }

    // Restart position stream with updated profile
    await _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      _onPositionUpdate,
      onError: (err) {
        debugPrint('Location stream error: $err');
      },
    );

    // Initial immediate location fix
    unawaited(_captureImmediateFix());

    // Fallback periodic timer in case device is static (ensures heartbeats to backend)
    _fallbackTimer?.cancel();
    final fallbackInterval = sosPriority
        ? const Duration(seconds: 10)
        : const Duration(seconds: 45);

    _fallbackTimer = Timer.periodic(fallbackInterval, (_) async {
      final now = DateTime.now();
      if (_lastTransmissionTime == null ||
          now.difference(_lastTransmissionTime!) >= fallbackInterval) {
        await _captureImmediateFix();
      }
    });
  }

  Future<void> _captureImmediateFix() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: isSosActive ? LocationAccuracy.high : LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 10),
        ),
      );
      await _onPositionUpdate(pos);
    } catch (e) {
      debugPrint('Immediate GPS fix error: $e');
    }
  }

  Future<void> _onPositionUpdate(Position pos) async {
    _lastKnownPosition = pos;
    _lastTransmissionTime = DateTime.now();
    final api = _api;
    if (api == null) return;

    // 1. Transmit for active SOS
    final sosId = _activeSosId;
    if (sosId != null) {
      await _sendSosLocation(api, sosId, pos);
    }

    // 2. Transmit for active Journey
    if (_isJourneyActive) {
      await _sendJourneyLocation(api, pos);
    }
  }

  Future<void> _sendSosLocation(ApiClient api, int sosId, Position pos) async {
    try {
      final res = await api.post(
        '/api/sos/location/$sosId',
        body: {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
        },
        timeout: const Duration(seconds: 8),
      );
      if (res['success'] == true) {
        // Network is good, flush any queued historical points
        unawaited(OfflineLocationQueue.instance.flush(api));
      } else {
        final err = res['error']?.toString() ?? '';
        if (err.contains('not active') || res['_status'] == 404) {
          // SOS was cancelled/resolved on server
          stopSosTracking();
        }
      }
    } catch (_) {
      // Network failure / offline — enqueue point
      await OfflineLocationQueue.instance.enqueue(
        QueuedLocationPoint(
          sessionKey: 'sos_$sosId',
          type: 'sos',
          latitude: pos.latitude,
          longitude: pos.longitude,
          timestampEpochMs: DateTime.now().millisecondsSinceEpoch,
          sosId: sosId,
        ),
      );
    }
  }

  Future<void> _sendJourneyLocation(ApiClient api, Position pos) async {
    try {
      final res = await api.post(
        '/api/journey/location',
        body: {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
        },
        timeout: const Duration(seconds: 8),
      );
      if (res['success'] == true) {
        unawaited(OfflineLocationQueue.instance.flush(api));
      } else {
        final err = res['error']?.toString() ?? '';
        if (err.contains('No active journey') || res['_status'] == 404) {
          stopJourneyTracking();
        }
      }
    } catch (_) {
      await OfflineLocationQueue.instance.enqueue(
        QueuedLocationPoint(
          sessionKey: 'journey',
          type: 'journey',
          latitude: pos.latitude,
          longitude: pos.longitude,
          timestampEpochMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
