import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fight_d_fear/services/api_client.dart';
import 'package:fight_d_fear/services/offline_location_queue.dart';
import 'package:fight_d_fear/services/background_location_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('OfflineLocationQueue Tests', () {
    test('enqueues points and enforces 50 item maximum limit per session', () async {
      final queue = OfflineLocationQueue.instance;
      await queue.clearSession('sos_999');

      for (int i = 1; i <= 55; i++) {
        await queue.enqueue(
          QueuedLocationPoint(
            sessionKey: 'sos_999',
            type: 'sos',
            latitude: 12.0 + (i * 0.001),
            longitude: 77.0 + (i * 0.001),
            timestampEpochMs: 1000 + i,
            sosId: 999,
          ),
        );
      }

      final pending = await queue.getPending('sos_999');
      expect(pending.length, 50);
      // The oldest 5 points (1..5) should have been dropped; first is 6
      expect(pending.first.timestampEpochMs, 1006);
      expect(pending.last.timestampEpochMs, 1055);
    });

    test('isolates points by sessionKey and clears cleanly', () async {
      final queue = OfflineLocationQueue.instance;
      await queue.clearSession('sos_1');
      await queue.clearSession('journey');

      await queue.enqueue(
        const QueuedLocationPoint(
          sessionKey: 'sos_1',
          type: 'sos',
          latitude: 12.9716,
          longitude: 77.5946,
          timestampEpochMs: 12345,
          sosId: 1,
        ),
      );

      await queue.enqueue(
        const QueuedLocationPoint(
          sessionKey: 'journey',
          type: 'journey',
          latitude: 12.9720,
          longitude: 77.5950,
          timestampEpochMs: 12350,
        ),
      );

      final sosPoints = await queue.getPending('sos_1');
      final journeyPoints = await queue.getPending('journey');

      expect(sosPoints.length, 1);
      expect(journeyPoints.length, 1);
      expect(sosPoints.first.sosId, 1);
      expect(journeyPoints.first.type, 'journey');

      await queue.clearSession('sos_1');
      expect((await queue.getPending('sos_1')).isEmpty, true);
      expect((await queue.getPending('journey')).length, 1);

      await queue.clearSession('journey');
      expect((await queue.getPending('journey')).isEmpty, true);
    });
  });

  group('BackgroundLocationService Lifecycle Independence Tests', () {
    test('manages SOS and Journey independently without cross-cancellation', () async {
      final service = BackgroundLocationService.instance;
      final api = ApiClient('http://10.0.2.2:8084');

      expect(service.isTracking, false);
      expect(service.isSosActive, false);
      expect(service.isJourneyActive, false);

      // Start Journey
      await service.startJourneyTracking(api);
      expect(service.isJourneyActive, true);
      expect(service.isSosActive, false);
      expect(service.isTracking, true);

      // Start SOS simultaneously
      await service.startSosTracking(101, api);
      expect(service.isJourneyActive, true);
      expect(service.isSosActive, true);
      expect(service.isTracking, true);

      // Complete / Stop SOS: Journey must remain active!
      await service.stopSosTracking();
      expect(service.isSosActive, false);
      expect(service.isJourneyActive, true); // MUST still be true!
      expect(service.isTracking, true);

      // Finally Stop Journey
      await service.stopJourneyTracking();
      expect(service.isSosActive, false);
      expect(service.isJourneyActive, false);
      expect(service.isTracking, false);
    });

    test('stopping Journey while SOS is active keeps SOS running', () async {
      final service = BackgroundLocationService.instance;
      final api = ApiClient('http://10.0.2.2:8084');

      await service.startSosTracking(202, api);
      await service.startJourneyTracking(api);

      expect(service.isSosActive, true);
      expect(service.isJourneyActive, true);

      // Stop Journey
      await service.stopJourneyTracking();
      expect(service.isJourneyActive, false);
      expect(service.isSosActive, true); // SOS must stay active!
      expect(service.isTracking, true);

      // Stop SOS
      await service.stopSosTracking();
      expect(service.isTracking, false);
    });
  });
}
