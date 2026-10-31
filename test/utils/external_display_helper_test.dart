import 'dart:async';

import 'package:PiliPlus/utils/ios/external_display_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.example.piliplus/external-display');
  const codec = StandardMethodCodec();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Completer<Object?> nativeSession;
  late List<MethodCall> calls;
  var available = true;

  Future<void> command(String value) async {
    final done = Completer<void>();
    messenger.handlePlatformMessage(
      channel.name,
      codec.encodeMethodCall(MethodCall('command', {'command': value})),
      (_) => done.complete(),
    );
    await done.future;
  }

  Future<String?> present(int cid, {bool showControls = true}) =>
      IOSExternalDisplayHelper.present(
        title: 'Video $cid',
        artwork: '',
        darkMode: false,
        cid: cid,
        showControls: showControls,
        state: () => {'textureId': cid, 'playing': true},
        onCommand: (_, _) async {},
      );

  setUp(() {
    calls = [];
    available = true;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'present':
          nativeSession = Completer<Object?>();
          return nativeSession.future;
        case 'close':
          // iOS 27 removes the external scene when its registration is lost.
          if ((call.arguments as Map?)?['keepReceiver'] != true) {
            available = false;
          }
          if (!nativeSession.isCompleted) nativeSession.complete({});
        case 'hasExternalDisplay':
          return available;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    expect(IOSExternalDisplayHelper.isActive, isFalse);
    expect(IOSExternalDisplayHelper.continuesToNextVideo, isFalse);
  });

  test(
    'video replacement retains casting but an explicit stop cancels it',
    () async {
      final first = present(1);
      await Future<void>.delayed(Duration.zero);
      expect(calls.last.arguments['state']['referenceHeight'], 400.0);
      expect(IOSExternalDisplayHelper.continuesToNextVideo, isFalse);
      await command('connected');
      expect(await IOSExternalDisplayHelper.prepareNextVideo(), isTrue);
      await first;
      expect(IOSExternalDisplayHelper.isActive, isFalse);

      final second = present(2, showControls: false);
      await Future<void>.delayed(Duration.zero);
      expect(calls.last.arguments['showControls'], isFalse);
      expect(calls.last.arguments['state']['referenceHeight'], 400.0);
      await command('connected');
      final count = calls.length;
      IOSExternalDisplayHelper.sendDanmaku(1, [
        {'text': 'old video'},
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(calls.length, count);
      await command('close');
      await IOSExternalDisplayHelper.close();
      await second;
      expect(await IOSExternalDisplayHelper.prepareNextVideo(), isFalse);
    },
  );

  test(
    'returning home releases the video but retains casting for a new page',
    () async {
      final first = present(10);
      await Future<void>.delayed(Duration.zero);
      await command('connected');

      // The old page/player is disposed before a new video page exists.
      await IOSExternalDisplayHelper.close();
      await first;
      expect(IOSExternalDisplayHelper.isActive, isFalse);
      expect(IOSExternalDisplayHelper.continuesToNextVideo, isTrue);
      expect(calls.last.arguments, {'keepReceiver': true});

      expect(await IOSExternalDisplayHelper.prepareNextVideo(), isTrue);
      final second = present(11, showControls: false);
      await Future<void>.delayed(Duration.zero);
      await command('connected');
      await command('close');
      await IOSExternalDisplayHelper.close();
      await second;
      expect(calls.last.arguments, {'keepReceiver': false});
      expect(await IOSExternalDisplayHelper.prepareNextVideo(), isFalse);
    },
  );

  test(
    'a disconnected receiver cancels automatic casting without opening UI',
    () async {
      final playback = present(3);
      await Future<void>.delayed(Duration.zero);
      await command('connected');
      available = false;
      expect(await IOSExternalDisplayHelper.prepareNextVideo(), isFalse);
      await playback;
      expect(calls.where((call) => call.method == 'present'), hasLength(1));
    },
  );
}
