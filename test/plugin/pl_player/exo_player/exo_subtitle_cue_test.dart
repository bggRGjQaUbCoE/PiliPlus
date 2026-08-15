import 'dart:convert';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_view.dart';
import 'package:PiliPlus/plugin/pl_player/models/exo_player_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses structured Media3 cue data from the event channel', () {
    final event = ExoPlayerEvent.fromMap({
      'subtitle': 'Hello',
      'ready': true,
      'volume': .75,
      'firstVideoFrameRendered': true,
      'videoDecoder': 'c2.qti.avc.decoder',
      'tracks': [
        {
          'type': 'audio',
          'id': 'audio-aac',
          'groupIndex': 1,
          'trackIndex': 0,
          'selected': true,
          'supported': true,
          'codec': 'mp4a.40.2',
          'channelCount': 2,
          'sampleRate': 48000,
        },
      ],
      'subtitleCues': [
        {
          'text': 'Hello',
          'textAlignment': 'center',
          'line': .8,
          'lineType': 0,
          'lineAnchor': 2,
          'position': .25,
          'positionAnchor': 1,
          'size': .5,
          'windowColor': 0x80000000,
          'shearDegrees': 12,
          'zIndex': 3,
          'segments': [
            {
              'text': 'Hel',
              'bold': true,
              'combineUpright': true,
              'foregroundColor': 0xFFFF0000,
            },
            {
              'text': 'lo',
              'italic': true,
              'underline': true,
              'relativeSize': 1.5,
            },
          ],
        },
      ],
    });

    expect(event.subtitleCues, hasLength(1));
    expect(event.tracks.single.id, 'audio-aac');
    expect(event.volume, .75);
    expect(event.videoDecoder, 'c2.qti.avc.decoder');
    expect(event.firstVideoFrameRendered, isTrue);
    expect(event.ready, isTrue);
    final cue = event.subtitleCues.single;
    expect(cue.text, 'Hello');
    expect(cue.textAlignment, ExoSubtitleAlignment.center);
    expect(cue.line, .8);
    expect(cue.position, .25);
    expect(cue.size, .5);
    expect(cue.windowColor, 0x80000000);
    expect(cue.shearDegrees, 12);
    expect(cue.zIndex, 3);
    expect(cue.segments, hasLength(2));
    expect(cue.segments.first.bold, isTrue);
    expect(cue.segments.first.combineUpright, isTrue);
    expect(cue.segments.last.italic, isTrue);
  });

  testWidgets('renders bitmap cues against the full video viewport', (
    tester,
  ) async {
    final player = await _createTestPlayer(45);
    final bitmap = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=',
    );
    player.state = ExoPlayerEvent.fromMap({
      'subtitleCues': [
        {
          'bitmap': bitmap,
          'bitmapPixelWidth': 4,
          'bitmapPixelHeight': 2,
          'bitmapHeight': .2,
          'position': .5,
          'positionAnchor': 1,
          'line': .75,
          'lineType': 0,
          'lineAnchor': 2,
          'size': .25,
        },
      ],
    });

    await _pumpSubtitleView(
      tester,
      player,
      configuration: const SubtitleViewConfiguration(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
      ),
    );

    final image = find.byType(Image);
    expect(image, findsOneWidget);
    expect(tester.getSize(image), const Size(80, 36));
    expect(tester.getTopLeft(image), const Offset(120, 99));
    expect(player.state.subtitleCues.first.bitmap, bitmap);
    expect(player.state.subtitleCues.first.bitmapHeight, .2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('positions vertical-rl and vertical-lr fractional cues', (
    tester,
  ) async {
    final player = await _createTestPlayer(46);
    player.state = ExoPlayerEvent.fromMap({
      'subtitleCues': [
        {
          'text': '天',
          'segments': const [],
          'verticalType': 1,
          'position': 0,
          'positionAnchor': 0,
          'line': .25,
          'lineType': 0,
          'lineAnchor': 0,
          'size': .5,
        },
        {
          'text': '地',
          'segments': const [],
          'verticalType': 2,
          'position': 0,
          'positionAnchor': 0,
          'line': .25,
          'lineType': 0,
          'lineAnchor': 0,
          'size': .5,
        },
      ],
    });

    await _pumpSubtitleView(tester, player);

    final rtlRow = find.byWidgetPredicate(
      (widget) => widget is Row && widget.textDirection == TextDirection.rtl,
    );
    final ltrRow = find.byWidgetPredicate(
      (widget) => widget is Row && widget.textDirection == TextDirection.ltr,
    );
    expect(rtlRow, findsOneWidget);
    expect(ltrRow, findsOneWidget);
    expect(
      tester.getTopLeft(rtlRow).dx,
      closeTo(240 - tester.getSize(rtlRow).width, .01),
    );
    expect(tester.getTopLeft(ltrRow).dx, closeTo(80, .01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses one column as the vertical line-number step', (
    tester,
  ) async {
    final player = await _createTestPlayer(47);
    player.state = ExoPlayerEvent.fromMap({
      'subtitleCues': [
        {
          'text': '天地\n玄黄',
          'segments': const [],
          'verticalType': 1,
          'position': 0,
          'positionAnchor': 0,
          'line': 1,
          'lineType': 1,
          'lineAnchor': 0,
          'size': 1,
        },
      ],
    });

    await _pumpSubtitleView(tester, player);

    final row = find.byWidgetPredicate(
      (widget) => widget is Row && widget.textDirection == TextDirection.rtl,
    );
    expect(row, findsOneWidget);
    expect(
      tester.getTopLeft(row).dx,
      closeTo(320 - 24 - tester.getSize(row).width, .01),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('wraps long vertical cues and keeps combined text upright', (
    tester,
  ) async {
    final player = await _createTestPlayer(48);
    player.state = ExoPlayerEvent.fromMap({
      'subtitleCues': [
        {
          'text': '20ABC天地玄黄宇宙',
          'segments': [
            {'text': '20', 'combineUpright': true},
            {'text': 'ABC天地玄黄宇宙'},
          ],
          'verticalType': 1,
          'position': 0,
          'positionAnchor': 0,
          'line': 0,
          'lineType': 1,
          'lineAnchor': 0,
          'size': .25,
        },
      ],
    });

    await _pumpSubtitleView(tester, player);

    expect(find.byType(RotatedBox), findsNWidgets(3));
    final text = find.byType(RichText);
    final horizontalPositions = <int>{
      for (var index = 0; index < text.evaluate().length; index++)
        tester.getTopLeft(text.at(index)).dx.round(),
    };
    expect(horizontalPositions.length, greaterThan(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ignores malformed bitmap cue bytes without throwing', (
    tester,
  ) async {
    final player = await _createTestPlayer(49);
    player.state = ExoPlayerEvent.fromMap({
      'subtitleCues': [
        {
          'bitmap': Uint8List.fromList([1, 2, 3]),
          'bitmapPixelWidth': 1,
          'bitmapPixelHeight': 1,
          'position': .5,
          'positionAnchor': 1,
          'line': .5,
          'lineType': 0,
          'lineAnchor': 1,
          'size': .2,
        },
      ],
    });

    await _pumpSubtitleView(tester, player);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  test('parses structured playback diagnostics', () {
    final event = ExoPlayerEvent.fromMap({
      'type': 'error',
      'error': {
        'message': 'Unable to connect',
        'errorCode': 2001,
        'errorCodeName': 'ERROR_CODE_IO_NETWORK_CONNECTION_FAILED',
        'category': 'network',
        'phase': 'source',
        'recoverable': true,
        'positionMs': 12345,
        'playWhenReady': true,
        'httpStatus': 503,
        'uri': 'https://example.com/video.m4s',
        'mediaDescription': 'video: https://example.com/video.m4s',
        'videoDecoder': 'c2.qti.avc.decoder',
        'causeChain': [
          'PlaybackException: Source error',
          'HttpDataSourceException: Unable to connect',
        ],
      },
    });

    final failure = event.failure!;
    expect(failure.category, ExoPlayerFailureCategory.network);
    expect(failure.recoverable, isTrue);
    expect(failure.httpStatus, 503);
    expect(failure.position, const Duration(milliseconds: 12345));
    expect(failure.playWhenReady, isTrue);
    expect(failure.videoDecoder, 'c2.qti.avc.decoder');
    expect(
      failure.diagnostics(retryAttempt: 2, retryLimit: 3),
      contains('retry: 2/3'),
    );
    expect(failure.diagnosticStackTrace.toString(), contains('Caused by'));
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 1,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isTrue,
    );
    expect(
      exoPlaybackRetryDelay(baseDelayMs: 500, attempt: 2),
      const Duration(seconds: 1),
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 2,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isFalse,
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: true,
        sessionActive: true,
      ),
      isFalse,
    );
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: false,
        sessionActive: false,
      ),
      isFalse,
    );
    expect(
      exoPlaybackRetryDelay(baseDelayMs: 500, attempt: 3),
      const Duration(milliseconds: 1500),
    );
  });

  test('does not retry permanent playback failures', () {
    final failure = ExoPlayerPlaybackFailure.fromMap({
      'message': 'Not found',
      'errorCode': 2004,
      'errorCodeName': 'ERROR_CODE_IO_BAD_HTTP_STATUS',
      'category': 'source',
      'phase': 'source',
      'recoverable': false,
      'positionMs': 0,
      'playWhenReady': true,
      'httpStatus': 404,
    });

    expect(failure.userMessage, contains('HTTP 404'));
    expect(
      shouldRetryExoPlaybackFailure(
        failure,
        attempt: 0,
        limit: 2,
        localSource: false,
        sessionActive: true,
      ),
      isFalse,
    );
  });

  test('parses the native Media3 playback configuration', () {
    final event = ExoPlayerEvent.fromMap({
      'playbackConfiguration':
          'decoder=platform-default (requested=software), buffer=custom-safe, targetBuffer=8.00 MiB, minBuffer=5000 ms, maxBuffer=16000 ms, timePriority=true',
    });

    expect(
      event.playbackConfiguration,
      'decoder=platform-default (requested=software), buffer=custom-safe, targetBuffer=8.00 MiB, minBuffer=5000 ms, maxBuffer=16000 ms, timePriority=true',
    );
  });

  test('parses the active Media3 super-resolution effect', () {
    final event = ExoPlayerEvent.fromMap({
      'superResolution': 'quality lanczos 1280x720 -> 2560x1440',
    });

    expect(
      event.superResolution,
      'quality lanczos 1280x720 -> 2560x1440',
    );
  });

  test('switches Media3 super resolution without reopening media', () async {
    const channel = MethodChannel('com.example.piliplus/exo_player');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'create') return 46;
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final player = await ExoPlayerController.create();
    addTearDown(player.dispose);
    await player.setSuperResolution('quality');

    expect(calls.last.method, 'setSuperResolution');
    expect(calls.last.arguments, {'id': player.id, 'mode': 'quality'});
    expect(calls.where((call) => call.method == 'open'), isEmpty);
  });

  test('captures an ExoPlayer frame with the requested transforms', () async {
    const channel = MethodChannel('com.example.piliplus/exo_player');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'create') return 42;
          if (call.method == 'captureFrame') return Uint8List.fromList([1, 2]);
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final player = await ExoPlayerController.create();
    addTearDown(player.dispose);
    final bytes = await player.captureFrame(flipX: true, flipY: false);

    expect(bytes, [1, 2]);
    expect(calls.last.method, 'captureFrame');
    expect(calls.last.arguments, {
      'id': player.id,
      'flipX': true,
      'flipY': false,
    });
  });

  test(
    'opens Media3 live playback with explicit live-edge semantics',
    () async {
      const channel = MethodChannel('com.example.piliplus/exo_player');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            if (call.method == 'create') return 44;
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final player = await ExoPlayerController.create();
      addTearDown(player.dispose);
      await player.open(
        videoUrl: 'https://example.com/live/index.m3u8',
        headers: const {'Referer': 'https://live.bilibili.com'},
        isLive: true,
        playWhenReady: true,
      );

      expect(calls.last.method, 'open');
      final arguments = calls.last.arguments as Map;
      expect(arguments['isLive'], isTrue);
      expect(arguments['positionMs'], 0);
      expect(arguments['playWhenReady'], isTrue);
    },
  );

  test(
    'controls standalone Media3 audio with headers and start position',
    () async {
      const channel = MethodChannel('com.example.piliplus/exo_player');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            if (call.method == 'create') return 47;
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );

      final player = await ExoPlayerController.create(
        enableHardwareDecoding: true,
        targetBufferBytes: 8 * 1024 * 1024,
        bufferDurationMs: 12000,
      );
      addTearDown(player.dispose);
      await player.open(
        videoUrl: 'https://example.com/audio.m4a',
        headers: const {
          'User-Agent': 'pili++ test',
          'Referer': 'https://www.bilibili.com',
        },
        position: const Duration(seconds: 7),
        playWhenReady: true,
      );
      await player.pause();
      await player.play();
      await player.seek(const Duration(seconds: 9));
      await player.setPlaybackSpeed(1.5);
      await player.setVolume(0.8);

      final open = calls.firstWhere((call) => call.method == 'open');
      expect(open.arguments, {
        'id': player.id,
        'generation': 1,
        'videoUrl': 'https://example.com/audio.m4a',
        'audioUrl': null,
        'headers': const {
          'User-Agent': 'pili++ test',
          'Referer': 'https://www.bilibili.com',
        },
        'expectedWidth': null,
        'expectedHeight': null,
        'isLive': false,
        'positionMs': 7000,
        'playWhenReady': true,
        'preserveSubtitle': false,
        'audioNormalization': null,
      });
      expect(
        calls.map((call) => call.method),
        containsAllInOrder([
          'create',
          'open',
          'pause',
          'play',
          'seekTo',
          'setPlaybackSpeed',
          'setVolume',
        ]),
      );
      expect(calls.last.arguments, {'id': player.id, 'volume': 0.8});
    },
  );

  test('passes each media size to Media3 when reusing the player', () async {
    const channel = MethodChannel('com.example.piliplus/exo_player');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'create') return 48;
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final player = await ExoPlayerController.create();
    addTearDown(player.dispose);
    await player.open(
      videoUrl: 'https://example.com/landscape.m4s',
      headers: const {},
      expectedWidth: 1440,
      expectedHeight: 1080,
    );
    await player.open(
      videoUrl: 'https://example.com/portrait.m4s',
      headers: const {},
      expectedWidth: 1080,
      expectedHeight: 1920,
      playWhenReady: true,
    );

    final opens = calls.where((call) => call.method == 'open').toList();
    expect(opens, hasLength(2));
    expect((opens.first.arguments as Map)['expectedWidth'], 1440);
    expect((opens.first.arguments as Map)['expectedHeight'], 1080);
    expect((opens.last.arguments as Map)['generation'], 2);
    expect((opens.last.arguments as Map)['expectedWidth'], 1080);
    expect((opens.last.arguments as Map)['expectedHeight'], 1920);
  });

  test('creates Media3 with buffering and decoder preferences', () async {
    const channel = MethodChannel('com.example.piliplus/exo_player');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'create') return 45;
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final player = await ExoPlayerController.create(
      enableHardwareDecoding: false,
      decoderMode: 'mediacodec',
      targetBufferBytes: 6 * 1024 * 1024,
      bufferDurationMs: 24000,
      isLive: true,
    );
    addTearDown(player.dispose);

    expect(calls.first.method, 'create');
    expect(calls.first.arguments, {
      'id': player.id,
      'enableHardwareDecoding': false,
      'decoderMode': 'mediacodec',
      'targetBufferBytes': 6 * 1024 * 1024,
      'bufferDurationMs': 24000,
      'isLive': true,
    });
  });

  test('starts, polls, and cancels animated WebP capture', () async {
    const channel = MethodChannel('com.example.piliplus/exo_player');
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return switch (call.method) {
            'create' => 43,
            'startAnimatedWebp' => true,
            'animatedWebpProgress' => .5,
            _ => null,
          };
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );

    final player = await ExoPlayerController.create();
    addTearDown(player.dispose);
    expect(
      await player.startAnimatedWebp(
        taskId: 9,
        url: 'https://example.com/video.mp4',
        outFile: '/tmp/test.webp',
        headers: const {'Referer': 'https://www.bilibili.com'},
        start: const Duration(seconds: 2),
        end: const Duration(seconds: 4),
        preset: 'picture',
      ),
      isTrue,
    );
    expect(await player.animatedWebpProgress(9), .5);
    await player.cancelAnimatedWebp(9);

    expect(
      calls.map((call) => call.method),
      containsAllInOrder([
        'create',
        'startAnimatedWebp',
        'animatedWebpProgress',
        'cancelAnimatedWebp',
      ]),
    );
    expect((calls[1].arguments as Map)['startMs'], 2000);
    expect((calls[1].arguments as Map)['endMs'], 4000);
  });

  test('applies span styling without discarding the shared base style', () {
    const base = TextStyle(fontSize: 20, color: Colors.white);
    const segment = ExoSubtitleSegment(
      text: 'styled',
      bold: true,
      italic: true,
      underline: true,
      foregroundColor: 0xFF00FF00,
      relativeSize: 1.25,
    );

    final style = segment.applyTo(base);

    expect(style.fontSize, 25);
    expect(style.fontWeight, FontWeight.bold);
    expect(style.fontStyle, FontStyle.italic);
    expect(style.color, const Color(0xFF00FF00));
    expect(style.decoration, TextDecoration.underline);
  });
}

Future<ExoPlayerController> _createTestPlayer(int id) async {
  const channel = MethodChannel('com.example.piliplus/exo_player');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'create') return id;
        return null;
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );
  final player = await ExoPlayerController.create();
  addTearDown(player.dispose);
  return player;
}

Future<void> _pumpSubtitleView(
  WidgetTester tester,
  ExoPlayerController player, {
  SubtitleViewConfiguration configuration = const SubtitleViewConfiguration(
    style: TextStyle(fontSize: 20, color: Colors.white),
    padding: EdgeInsets.zero,
  ),
}) async {
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(devicePixelRatio: 1),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            height: 180,
            child: ExoSubtitleView(
              controller: player,
              configuration: configuration,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}
