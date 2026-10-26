import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/android_video_output.dart';
import 'package:PiliPlus/plugin/pl_player/models/dolby_vision_profile5_mode.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class _Player extends Fake implements Player {
  @override
  final int handle = 42;

  @override
  final List<FutureOr<void> Function()> onLoadHooks = [];

  @override
  final List<FutureOr<void> Function()> onUnloadHooks = [];

  @override
  final List<Future<void> Function()> release = [];

  final properties = <String, String>{};
  final writes = <(String, String)>[];
  String? rejectedRenderer;
  String? rejectedHwdec;

  @override
  String getProperty(String property) => properties[property] ?? '';

  @override
  void setProperty(String property, String value) {
    writes.add((property, value));
    if (property == 'hwdec' && value == rejectedHwdec) return;
    if (property != 'vo' || value != rejectedRenderer) {
      properties[property] = value;
    }
  }

  Future<void> load(String? profile) async {
    properties['current-tracks/video/dolby-vision-profile'] = profile ?? '';
    for (final hook in onLoadHooks) {
      await hook();
    }
  }

  Future<void> unload() async {
    for (final hook in onUnloadHooks) {
      await hook();
    }
  }
}

class _SurfaceController extends VideoController {
  _SurfaceController(Player player)
    : super(
        player,
        const VideoControllerConfiguration(
          vo: 'null',
          androidAttachSurfaceAfterVideoParameters: false,
        ),
      );

  @override
  Future<void>? setSize({int? width, int? height}) => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.alexmercerind/media_kit_video');
  const hardwareDecoding = 'mediacodec,auto-safe';
  const landscape = Rect.fromLTWH(0, 0, 1920, 1080);
  const portrait = Rect.fromLTWH(0, 0, 1080, 1920);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late _Player player;
  late _SurfaceController surface;
  late AndroidVideoOutput output;
  late List<MethodCall> calls;
  late List<Object> errors;
  late DolbyVisionProfile5Mode profile5Mode;
  late int nativeRequests;
  Future<void>? nativeUnload;

  setUp(() {
    player = _Player();
    surface = _SurfaceController(player);
    surface.id.value = 7;
    // media-kit owns these hooks and attaches the surface before our onLoad.
    player.onLoadHooks.add(() {
      player.setProperty('wid', '123');
      player.setProperty('vo', 'null');
    });
    player.onUnloadHooks.add(() {
      player.setProperty('vo', 'null');
      player.setProperty('wid', '0');
    });
    calls = [];
    errors = [];
    profile5Mode = DolbyVisionProfile5Mode.software;
    nativeRequests = 0;
    nativeUnload = null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    output = AndroidVideoOutput(
      player,
      surface,
      hardwareDecoding: hardwareDecoding,
      profile5Mode: () => profile5Mode,
      onNativePlaybackRequested: () {
        nativeRequests++;
        // Regression: native handoff must not run under the resize lock.
        nativeUnload = player.unload();
      },
      onError: (error, _) => errors.add(error),
    );
  });

  tearDown(() async {
    for (final dispose in player.release) {
      await dispose();
    }
    surface.id.dispose();
    surface.rect.dispose();
    messenger.setMockMethodCallHandler(channel, null);
  });

  Future<void> emitSize([Rect size = landscape]) async {
    surface.rect.value = Rect.zero;
    surface.rect.value = size;
    await Future<void>.delayed(Duration.zero);
  }

  test(
    'Profile 5 uses software decoding and gpu-next with a sized surface',
    () async {
      await player.load('5');
      await emitSize();

      expect(player.getProperty('hwdec'), 'no');
      expect(player.getProperty('vo'), 'gpu-next');
      expect(player.getProperty('android-surface-size'), '1920x1080');
      expect(calls.single.method, 'VideoOutputManager.SetSurfaceTextureSize');
      expect(calls.single.arguments, {
        'handle': '42',
        'width': '1920',
        'height': '1080',
      });
      expect(output.id.value, 7);
      expect(output.rect.value, landscape);
      expect(errors, isEmpty);
    },
  );

  for (final mode in DolbyVisionProfile5Mode.values) {
    for (final profile in [null, '7', '8']) {
      test(
        'profile $profile ignores the Profile 5 ${mode.name} mode',
        () async {
          profile5Mode = mode;
          await player.load(profile);
          await emitSize();

          expect(player.getProperty('hwdec'), hardwareDecoding);
          expect(player.getProperty('vo'), 'gpu');
          expect(output.rect.value, landscape);
          expect(errors, isEmpty);
        },
      );
    }
  }

  test('Profile 5 hands off once without configuring an mpv decoder', () async {
    profile5Mode = DolbyVisionProfile5Mode.media3;
    await player.load('5');
    player.writes.clear();
    await emitSize();
    await emitSize(portrait);
    await nativeUnload!.timeout(const Duration(seconds: 1));

    expect(nativeRequests, 1);
    expect(calls, isEmpty);
    expect(player.writes, isNot(contains(('hwdec', 'no'))));
    expect(player.writes, isNot(contains(('vo', 'gpu-next'))));
    expect(output.rect.value, Rect.zero);
    expect(errors, isEmpty);

    await player.load('8');
    await emitSize();
    expect(nativeRequests, 1);
    expect(player.getProperty('vo'), 'gpu');
    expect(player.getProperty('hwdec'), hardwareDecoding);
    expect(output.rect.value, landscape);
  });

  test(
    'a subsequent Profile 5 load may request native playback again',
    () async {
      profile5Mode = DolbyVisionProfile5Mode.media3;
      await player.load('5');
      await emitSize();
      await player.load('5');
      await emitSize();
      expect(nativeRequests, 2);
      expect(errors, isEmpty);
    },
  );

  test(
    'changing Profile 5 mode applies on reload without recreating the player',
    () async {
      for (final mode in [
        DolbyVisionProfile5Mode.software,
        DolbyVisionProfile5Mode.media3,
        DolbyVisionProfile5Mode.software,
      ]) {
        profile5Mode = mode;
        await player.load('5');
        await emitSize();

        if (mode == DolbyVisionProfile5Mode.media3) {
          await nativeUnload!;
          expect(nativeRequests, 1);
        } else {
          expect(player.getProperty('hwdec'), 'no');
          expect(player.getProperty('vo'), 'gpu-next');
        }
        expect(errors, isEmpty);
        await player.unload();
      }
    },
  );

  test('Profile 8.4 restores the preferred decoder after Profile 5', () async {
    await player.load('5');
    await emitSize();
    await player.unload();
    await player.load('8');
    await emitSize();

    expect(player.getProperty('hwdec'), hardwareDecoding);
    expect(player.getProperty('vo'), 'gpu');
    expect(output.rect.value, landscape);
    expect(errors, isEmpty);
  });

  test('Profile 5 stays on gpu-next after resize and rotation', () async {
    await player.load('5');
    await emitSize();
    await emitSize(portrait);

    expect(player.getProperty('vo'), 'gpu-next');
    expect(player.getProperty('android-surface-size'), '1080x1920');
    expect(output.rect.value, portrait);
    expect(
      player.writes.where((write) => write == ('hwdec', 'no')),
      hasLength(1),
    );
  });

  test(
    'reloading the same Profile 5 source re-enables compatibility',
    () async {
      await player.load('5');
      await emitSize();
      await player.unload();
      await player.load('5');
      await emitSize();

      expect(player.getProperty('hwdec'), 'no');
      expect(player.getProperty('vo'), 'gpu-next');
      expect(errors, isEmpty);
    },
  );

  test(
    'unload waits for a pending resize without restoring stale output',
    () async {
      final resize = Completer<void>();
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        await resize.future;
        return null;
      });
      await player.load('5');
      await emitSize();

      final unloaded = player.unload();
      expect(player.getProperty('wid'), '123');
      resize.complete();
      await unloaded;

      expect(player.getProperty('vo'), 'null');
      expect(player.getProperty('wid'), '0');
      expect(output.rect.value, Rect.zero);
      expect(errors, isEmpty);
    },
  );

  test('surface failures are reported instead of displaying success', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'resize_failed');
    });
    await player.load('5');
    await emitSize();

    expect(errors.single, isA<PlatformException>());
    expect(output.rect.value, Rect.zero);
  });

  test('renderer selection failure is reported', () async {
    player.rejectedRenderer = 'gpu-next';
    await player.load('5');
    await emitSize();

    expect(errors.single, isA<StateError>());
    expect(output.rect.value, Rect.zero);
  });

  test(
    'failed software decoding never activates gpu-next on hardware frames',
    () async {
      player.rejectedHwdec = 'no';
      await player.load('5');
      await emitSize();
      await emitSize(portrait);

      expect(errors, hasLength(2));
      expect(errors, everyElement(isA<StateError>()));
      expect(player.getProperty('vo'), 'gpu');
      expect(output.rect.value, Rect.zero);
    },
  );

  test('disposal cancels pending output updates and removes hooks', () async {
    final resize = Completer<void>();
    messenger.setMockMethodCallHandler(channel, (_) async {
      await resize.future;
      return null;
    });
    await player.load('5');
    await emitSize();
    final writesBeforeDispose = player.writes.length;
    final disposed = player.release.single();
    resize.complete();
    await disposed;
    await emitSize(portrait);

    expect(player.writes, hasLength(writesBeforeDispose));
    expect(player.onLoadHooks, hasLength(1));
    expect(player.onUnloadHooks, hasLength(1));
    expect(errors, isEmpty);
  });

  test('empty video parameters do not resize or change the decoder', () async {
    await player.load('5');
    surface.rect.value = Rect.zero;
    await Future<void>.delayed(Duration.zero);

    expect(calls, isEmpty);
    expect(player.getProperty('hwdec'), hardwareDecoding);
  });
}
