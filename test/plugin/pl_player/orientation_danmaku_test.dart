import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  final orientations = <Object?>[];
  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('piliplus-player-fixes-');
    Hive.init(directory.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.video = await Hive.openBox('video');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemChrome.setPreferredOrientations') {
            orientations.add(call.arguments);
          }
          return null;
        });
  });
  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });
  test(
    'locked controls reject all sensor directions; unlock resumes rotation',
    () async {
      await GStorage.setting.put(SettingBoxKey.horizontalScreen, true);
      await GStorage.setting.put(
        SettingBoxKey.fullScreenMode,
        FullScreenMode.auto.index,
      );
      final stream = StreamController<OrientationParams>();
      final controller = PlPlayerController.forTesting(
        orientationChanges: stream.stream,
      );
      controller.controlsLock.value = true;
      for (final vertical in [false, true]) {
        controller.isVertical = vertical;
        for (final orientation in DeviceOrientation.values) {
          stream.add((orientation: orientation, isAutoRotate: true));
        }
      }
      await Future<void>.delayed(Duration.zero);
      expect(orientations, isEmpty);
      controller.controlsLock.value = false;
      stream.add((
        orientation: DeviceOrientation.landscapeRight,
        isAutoRotate: true,
      ));
      await Future<void>.delayed(Duration.zero);
      expect(orientations.last, ['DeviceOrientation.landscapeRight']);
      stream.add((
        orientation: DeviceOrientation.portraitUp,
        isAutoRotate: true,
      ));
      await Future<void>.delayed(Duration.zero);
      expect(orientations.last, ['DeviceOrientation.portraitUp']);
      await stream.close();
    },
  );
  test(
    'video and live resolve independent observable danmaku switches',
    () async {
      final controller = PlPlayerController.forTesting();
      controller.enableShowDanmaku.value = true;
      controller.enableShowLiveDanmaku.value = false;
      controller.isLive = true;
      expect(controller.enableShowDanmakuAdaptive.value, isFalse);
      final changes = <bool>[];
      final subscription = controller.enableShowDanmakuAdaptive.listen(
        changes.add,
      );
      controller.enableShowDanmaku.value = false;
      await Future<void>.delayed(Duration.zero);
      expect(changes, isEmpty);
      controller.enableShowLiveDanmaku.value = true;
      await Future<void>.delayed(Duration.zero);
      expect(changes, [true]);
      controller.isLive = false;
      expect(controller.enableShowDanmakuAdaptive.value, isFalse);
      expect(controller.enableShowLiveDanmaku.value, isTrue);
      await subscription.cancel();
    },
  );
}
