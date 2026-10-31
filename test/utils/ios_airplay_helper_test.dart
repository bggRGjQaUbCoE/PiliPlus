import 'dart:async';

import 'package:PiliPlus/utils/ios/airplay_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.example.piliplus/airplay');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    expect(IOSAirPlayHelper.isActive, isFalse);
  });

  test(
    'hands off the signed media URL and restores the returned position',
    () async {
      const path =
          'upos-hz-mirrorakam.akamaized.net/video.mp4?token=a%2Fb%2Bc&x=1&x=2';
      final closed = Completer<Map<String, Object>>();
      final called = Completer<MethodCall>();
      messenger.setMockMethodCallHandler(channel, (call) {
        called.complete(call);
        return closed.future;
      });

      final playback = IOSAirPlayHelper.present(
        url: 'http://$path',
        title: 'Example',
        position: const Duration(seconds: 42),
      );
      final call = await called.future;
      expect(call.method, 'present');
      expect(call.arguments, {
        'url': 'https://$path',
        'title': 'Example',
        'positionMs': 42000,
      });
      expect(IOSAirPlayHelper.isActive, isTrue);
      closed.complete({'positionMs': 91000});
      expect(await playback, (
        position: const Duration(seconds: 91),
        error: null,
      ));
    },
  );

  test(
    'clears ownership after a native failure so playback can be retried',
    () async {
      messenger.setMockMethodCallHandler(
        channel,
        (_) => Future<Object?>.error(PlatformException(code: 'WINDOW')),
      );
      await expectLater(
        IOSAirPlayHelper.present(
          url: 'https://example.com/video.mp4',
          title: '',
          position: Duration.zero,
        ),
        throwsA(isA<PlatformException>()),
      );
      expect(IOSAirPlayHelper.isActive, isFalse);
      messenger.setMockMethodCallHandler(
        channel,
        (_) async => {'positionMs': 12000, 'error': 'Load failed'},
      );
      expect(
        await IOSAirPlayHelper.present(
          url: 'https://example.com/video.mp4',
          title: '',
          position: Duration.zero,
        ),
        (position: const Duration(seconds: 12), error: 'Load failed'),
      );
    },
  );

  test(
    'keeps one native session and forwards transport controls to it',
    () async {
      final closed = Completer<Map<String, Object>>();
      final calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return call.method == 'present' ? await closed.future : null;
      });
      final playback = IOSAirPlayHelper.present(
        url: 'https://example.com/video.mp4',
        title: '',
        position: Duration.zero,
      );
      await expectLater(
        IOSAirPlayHelper.present(
          url: 'https://example.com/other.mp4',
          title: '',
          position: Duration.zero,
        ),
        throwsStateError,
      );
      expect(IOSAirPlayHelper.isActive, isTrue);
      await IOSAirPlayHelper.play();
      await IOSAirPlayHelper.pause();
      await IOSAirPlayHelper.seek(const Duration(seconds: 30));
      expect(calls.map((call) => call.method), [
        'present',
        'play',
        'pause',
        'seek',
      ]);
      expect(calls.last.arguments, {'positionMs': 30000});
      closed.complete({'positionMs': 30000});
      await playback;
    },
  );
}
