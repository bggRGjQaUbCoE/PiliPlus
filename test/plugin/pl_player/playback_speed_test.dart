import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';

class FakePlayer extends Fake implements Player {
  @override
  final state = PlayerState();
  final commands = <List<String>>[];
  final rates = <double>[];
  Future<void> Function(List<String>)? onCommand;
  Future<void> Function(double)? onRate;
  Future<void>? rateGate;
  Future<void> _pendingRate = Future.value();

  @override
  Future<void> command(List<String> args) async {
    commands.add(args);
    await onCommand?.call(args);
  }

  @override
  Future<void> setRate(double rate, {bool synchronized = true}) {
    rates.add(rate);
    return _pendingRate = _pendingRate.then((_) async {
      await rateGate;
      state.rate = rate;
      await onRate?.call(rate);
    });
  }
}

class TestController extends PlPlayerController {
  Player? player;
  TestController(this.player) : super.forTesting() {
    dataSource = NetworkSource(
      videoSource: 'https://example.com/v',
      audioSource: null,
    );
    playerStatus = PlayerStatus.playing;
  }

  @override
  Player? get videoPlayerController => player;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late FakePlayer player;
  late TestController controller;
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('piliplus-speed-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.video = await Hive.openBox('video');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  setUp(() async {
    await GStorage.setting.clear();
    await GStorage.video.clear();
    player = FakePlayer();
    controller = TestController(player);
  });
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test(
    'hold scales VOD prefetch and restores the normal rate and cache',
    () async {
      await controller.setPlaybackSpeed(1.5);
      expect(controller.buffer['cache-secs'], '24.000');
      await controller.setLongPressStatus(true);
      expect(player.state.rate, 3);
      expect(controller.lastPlaybackSpeed, 1.5);
      expect(player.commands.sublist(player.commands.length - 2), [
        ['set', 'cache-secs', '48.000'],
        ['set', 'demuxer-hysteresis-secs', '32.000'],
      ]);
      await controller.setLongPressStatus(false);
      expect(player.state.rate, 1.5);
      expect(controller.playbackSpeed, 1.5);
      expect(player.commands.sublist(player.commands.length - 2), [
        ['set', 'cache-secs', '24.000'],
        ['set', 'demuxer-hysteresis-secs', '16.000'],
      ]);
      expect(player.commands.every((e) => !e[1].contains('bytes')), isTrue);
      expect(GStorage.setting.isEmpty, isTrue);
      expect(GStorage.video.isEmpty, isTrue);
    },
  );

  test(
    'automatic hold doubles the normal rate without compounding it',
    () async {
      controller.enableAutoLongPressSpeed = true;
      await controller.setPlaybackSpeed(1.25);
      await controller.setLongPressStatus(true);
      await controller.setLongPressStatus(true);
      expect(player.state.rate, 2.5);
      await controller.setLongPressStatus(false);
      expect(player.state.rate, 1.25);
    },
  );

  test('rapid hold release hold ignores superseded pending requests', () async {
    final blocked = Completer<void>();
    player.onCommand = (_) =>
        player.commands.length == 1 ? blocked.future : Future.value();
    final first = controller.setLongPressStatus(true);
    final release = controller.setLongPressStatus(false);
    final second = controller.setLongPressStatus(true);
    await Future.wait([release, second]);
    blocked.complete();
    await first;
    expect(player.rates, [3.0]);
    expect(controller.playbackSpeed, 3);
    expect(controller.lastPlaybackSpeed, 1);
    await controller.setLongPressStatus(false);
    expect(player.state.rate, 1);
  });

  test(
    'release during a native rate update wins and restores baseline',
    () async {
      final blocked = Completer<void>();
      final entered = Completer<void>();
      player.onRate = (rate) async {
        if (rate == 3) {
          entered.complete();
          await blocked.future;
        }
      };
      final hold = controller.setLongPressStatus(true);
      await entered.future;
      final release = controller.setLongPressStatus(false);
      blocked.complete();
      await Future.wait([hold, release]);
      expect(controller.playbackSpeed, 1);
      expect(player.state.rate, 1);
    },
  );

  test('local files and live do not receive VOD cache updates', () async {
    controller.dataSource = FileSource(
      dir: 'local',
      isMp4: true,
      hasDashAudio: false,
      typeTag: 'video',
    );
    await controller.setPlaybackSpeed(2);
    expect(player.commands, isEmpty);
    controller.isLive = true;
    await controller.setPlaybackSpeed(1);
    await controller.setLongPressStatus(true);
    expect(player.commands, isEmpty);
    expect(controller.longPressStatus.value, isFalse);
  });

  test('native failures propagate and allow subsequent requests', () async {
    player.onCommand = (_) =>
        Future.error(StateError('native cache command failed'));
    await expectLater(controller.setPlaybackSpeed(2), throwsStateError);
    player.onCommand = null;
    await controller.setPlaybackSpeed(1);
    expect(player.commands.last, ['set', 'demuxer-hysteresis-secs', '10.667']);
    expect(player.rates, [1.0]);
  });

  test('player replacement during await stops further changes', () async {
    player.onCommand = (_) async => controller.player = null;
    await controller.setPlaybackSpeed(3);
    expect(player.commands.length, 1);
    expect(player.rates, isEmpty);
    expect(controller.playbackSpeed, 1);
  });

  test(
    'release also wins when an older rate is queued behind native work',
    () async {
      final blocked = Completer<void>();
      player.rateGate = blocked.future;
      final hold = controller.setLongPressStatus(true);
      while (player.rates.isEmpty) {
        await Future<void>.delayed(Duration.zero);
      }
      expect(player.state.rate, 1);
      final release = controller.setLongPressStatus(false);
      blocked.complete();
      await Future.wait([hold, release]);
      expect(player.state.rate, 1);
      expect(controller.playbackSpeed, 1);
    },
  );

  test(
    'new media buffer uses latest normal rate, not a temporary hold',
    () async {
      expect(controller.buffer['cache-secs'], '16.000');
      await controller.setPlaybackSpeed(2);
      await controller.setLongPressStatus(true);
      expect(controller.buffer['cache-secs'], '32.000');
      await controller.setLongPressStatus(false);
      expect(controller.playbackSpeed, 2);
    },
  );

  test(
    'default normal rate is retained when first gesture is a hold',
    () async {
      await GStorage.video.put(VideoBoxKey.playSpeedDefault, 1.5);
      controller = TestController(player);
      player.state.rate = 1.5;
      await controller.setLongPressStatus(true);
      await controller.setLongPressStatus(false);
      expect(player.state.rate, 1.5);
    },
  );
}
