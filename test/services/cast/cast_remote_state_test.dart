import 'package:PiliPlus/services/cast/cast_remote_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CastRemoteState', () {
    test('defaults to disconnected idle playback with full volume', () {
      const state = CastRemoteState();

      expect(state.connection, CastConnectionState.disconnected);
      expect(state.playback, CastPlaybackState.idle);
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
      expect(state.volume, 1.0);
      expect(state.isMuted, isFalse);
      expect(state.deviceId, isNull);
      expect(state.deviceName, isNull);
    });

    test('exposes the full connection and playback state surfaces', () {
      expect(
        CastConnectionState.values,
        const [
          CastConnectionState.disconnected,
          CastConnectionState.discovering,
          CastConnectionState.connecting,
          CastConnectionState.connected,
        ],
      );
      expect(
        CastPlaybackState.values,
        const [
          CastPlaybackState.idle,
          CastPlaybackState.loading,
          CastPlaybackState.playing,
          CastPlaybackState.paused,
          CastPlaybackState.buffering,
        ],
      );
    });

    test('clamps receiver volume into the Cast SDK range', () {
      expect(
        const CastRemoteState(volume: -0.5).volume,
        0,
      );
      expect(
        const CastRemoteState(volume: 1.5).volume,
        1,
      );
      expect(
        const CastRemoteState(volume: 0.65).volume,
        0.65,
      );
      expect(
        const CastRemoteState(volume: double.nan).volume,
        0,
      );
    });

    test('copyWith preserves current playback fields by default', () {
      const current = CastRemoteState(
        connection: CastConnectionState.connected,
        playback: CastPlaybackState.playing,
        position: Duration(seconds: 12),
        duration: Duration(minutes: 2),
        volume: 0.4,
        isMuted: true,
        deviceId: 'cast-1',
        deviceName: 'Living Room',
      );

      final updated = current.copyWith(
        playback: CastPlaybackState.paused,
      );

      expect(updated.connection, CastConnectionState.connected);
      expect(updated.playback, CastPlaybackState.paused);
      expect(updated.position, const Duration(seconds: 12));
      expect(updated.duration, const Duration(minutes: 2));
      expect(updated.volume, 0.4);
      expect(updated.isMuted, isTrue);
      expect(updated.deviceId, 'cast-1');
      expect(updated.deviceName, 'Living Room');
    });

    test(
      'preserves deviceId when copyWith is called without device params',
      () {
        const state = CastRemoteState(
          connection: CastConnectionState.connected,
          deviceId: 'cast-1',
          deviceName: 'Living Room',
        );

        final updated = state.copyWith(
          playback: CastPlaybackState.playing,
        );

        expect(updated.deviceId, 'cast-1');
        expect(updated.deviceName, 'Living Room');
      },
    );

    test('clears deviceId while preserving deviceName', () {
      const state = CastRemoteState(
        connection: CastConnectionState.connected,
        deviceId: 'cast-1',
        deviceName: 'Living Room',
      );

      final updated = state.copyWith(clearDeviceId: true);

      expect(updated.deviceId, isNull);
      expect(updated.deviceName, 'Living Room');
    });

    test('replaces deviceId via copyWith', () {
      const state = CastRemoteState(
        connection: CastConnectionState.connected,
        deviceId: 'cast-1',
        deviceName: 'Living Room',
      );

      final updated = state.copyWith(deviceId: 'cast-2');

      expect(updated.deviceId, 'cast-2');
      expect(updated.deviceName, 'Living Room');
    });

    test('null deviceId without clearDeviceId preserves existing value', () {
      const state = CastRemoteState(
        connection: CastConnectionState.connected,
        deviceId: 'cast-1',
        deviceName: 'Living Room',
      );

      final updated = state.copyWith(deviceId: null);

      expect(updated.deviceId, 'cast-1');
      expect(updated.deviceName, 'Living Room');
    });
  });
}
