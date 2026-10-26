import 'package:PiliPlus/plugin/pl_player/media3_player.dart';
import 'package:PiliPlus/plugin/pl_player/models/dolby_vision_profile5_mode.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(Media3Player.channel, null);
  });

  test('Profile 5 offers only software and native playback', () {
    expect(DolbyVisionProfile5Mode.values, [
      DolbyVisionProfile5Mode.software,
      DolbyVisionProfile5Mode.media3,
    ]);
    for (final mode in DolbyVisionProfile5Mode.values) {
      expect(DolbyVisionProfile5Mode.fromPreference(mode.name), mode);
    }
    for (final retired in ['mediacodec', 'mediacodecCopy']) {
      expect(
        DolbyVisionProfile5Mode.fromPreference(retired),
        DolbyVisionProfile5Mode.software,
      );
    }
    expect(
      () => DolbyVisionProfile5Mode.fromPreference('unknown'),
      throwsArgumentError,
    );
  });

  test('only explicit DV Profile 5 codecs select the native backend', () {
    for (final codec in ['dvhe.05.06', 'dvh1.05.09', 'DVHE.5.06']) {
      expect(DolbyVisionProfile5Mode.isProfile5Codec(codec), isTrue);
    }
    for (final codec in [
      null,
      '',
      'hevc',
      'hvc1.2.4',
      'avc1.640028',
      'av01.0.08M.08',
      'dvhe.08.04',
      'dvh1.07.06',
      'dvhe.50.06',
      'dvhe.05',
    ]) {
      expect(DolbyVisionProfile5Mode.isProfile5Codec(codec), isFalse);
    }
    expect(() => DolbyVisionProfile5Mode.media3.hwdec, throwsStateError);
    expect(DolbyVisionProfile5Mode.software.hwdec, 'no');
  });

  test('passes separate streams, headers, resume position and speed', () async {
    late MethodCall request;
    messenger.setMockMethodCallHandler(Media3Player.channel, (call) async {
      request = call;
      return {
        'positionMs': 23456,
        'durationMs': 60000,
        'speed': 1.25,
        'completed': false,
      };
    });
    final result = await Media3Player.open(
      video: 'https://video.example/video.m4s?token=a%26b',
      audio: 'https://audio.example/audio.m4s',
      headers: {
        'User-Agent': 'PiliPlus',
        'Referer': 'https://www.bilibili.com',
      },
      position: const Duration(milliseconds: 12345),
      speed: 1.5,
      title: '测试标题 / Episode 2',
      speeds: [0.75, 1, 2.5],
      seekStep: const Duration(seconds: 15),
      controlsTimeout: const Duration(seconds: 30),
      quickDoubleTap: false,
      longPressSpeed: 0,
      accentColor: 0xFFABCDEF,
    );
    expect(request.method, 'open');
    expect(request.arguments, {
      'video': 'https://video.example/video.m4s?token=a%26b',
      'audio': 'https://audio.example/audio.m4s',
      'headers': {
        'User-Agent': 'PiliPlus',
        'Referer': 'https://www.bilibili.com',
      },
      'positionMs': 12345,
      'speed': 1.5,
      'title': '测试标题 / Episode 2',
      'speeds': [0.75, 1.0, 2.5],
      'seekStepMs': 15000,
      'controlsTimeoutMs': 30000,
      'quickDoubleTap': false,
      'longPressSpeed': 0.0,
      'accentColor': 0xFFABCDEF,
    });
    expect(result.position.inMilliseconds, 23456);
    expect(result.duration.inMilliseconds, 60000);
    expect(result.speed, 1.25);
    expect(result.completed, isFalse);
  });

  test('local muxed files omit empty audio and preserve completion', () async {
    messenger.setMockMethodCallHandler(Media3Player.channel, (call) async {
      expect(call.arguments['video'], '/downloads/测试/video.mp4');
      expect(call.arguments.containsKey('audio'), isFalse);
      expect(call.arguments['title'], '');
      expect(call.arguments['speeds'], [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3]);
      expect(call.arguments['seekStepMs'], 10000);
      expect(call.arguments['controlsTimeoutMs'], 3000);
      expect(call.arguments['quickDoubleTap'], isTrue);
      expect(call.arguments['longPressSpeed'], 3);
      return {
        'positionMs': 60000,
        'durationMs': 60000,
        'speed': 1.0,
        'completed': true,
      };
    });
    final result = await Media3Player.open(
      video: '/downloads/测试/video.mp4',
      audio: '',
      position: Duration.zero,
      speed: 1,
      headers: {},
    );
    expect(result.completed, isTrue);
  });

  test('native errors preserve progress without reporting success', () {
    final result = Media3PlaybackResult.fromMap({
      'positionMs': 1234,
      'durationMs': 60000,
      'speed': 1.0,
      'completed': false,
      'error': 'Decoder unavailable',
    });
    expect(result.error, 'Decoder unavailable');
    expect(result.position.inMilliseconds, 1234);
    for (final invalid in <Map<Object?, Object?>>[
      {},
      {'positionMs': -1, 'durationMs': 1, 'speed': 1.0, 'completed': false},
      {
        'positionMs': 1,
        'durationMs': 1,
        'speed': double.nan,
        'completed': false,
      },
    ]) {
      expect(
        () => Media3PlaybackResult.fromMap(invalid),
        throwsFormatException,
      );
    }
  });

  test(
    'missing native result and platform failures are not swallowed',
    () async {
      messenger.setMockMethodCallHandler(
        Media3Player.channel,
        (_) async => null,
      );
      Future<Media3PlaybackResult> open() => Media3Player.open(
        video: '/video.mp4',
        position: Duration.zero,
        speed: 1,
        headers: {},
      );
      await expectLater(open(), throwsFormatException);
      messenger.setMockMethodCallHandler(Media3Player.channel, (_) async {
        throw PlatformException(code: 'busy', message: 'Already open');
      });
      await expectLater(open(), throwsA(isA<PlatformException>()));
    },
  );

  test('pause and close use the native lifecycle channel', () async {
    final methods = <String>[];
    messenger.setMockMethodCallHandler(Media3Player.channel, (call) async {
      methods.add(call.method);
      return null;
    });
    await Media3Player.pause();
    await Media3Player.close();
    expect(methods, ['pause', 'close']);
  });
}
