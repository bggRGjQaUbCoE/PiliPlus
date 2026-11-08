import 'dart:io';
import 'dart:ui' show PointerDeviceKind;

import 'package:PiliPlus/common/widgets/progress_bar/audio_video_progress_bar.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/bottom_control.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory storage;
  late PlPlayerController controller;

  setUpAll(() async {
    storage = await Directory.systemTemp.createTemp('pili_keyboard_seek_');
    appSupportDirPath = storage.path;
    await GStorage.init();
    await GStorage.setting.put(SettingBoxKey.fastForBackwardDuration, 5);
    Request();
    Request.dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'code': 0,
              'data': {'b_3': 'test-buvid3', 'b_4': 'test-buvid4'},
            },
          ),
        ),
      ),
    );
    controller = PlPlayerController.getInstance();
  });

  tearDownAll(() async {
    await Hive.close();
    await storage.delete(recursive: true);
  });

  setUp(() {
    controller
      ..isSeeking.value = false
      ..hoverDx = null
      ..seekPosition.value = 0;
  });

  test('悬停在进度条时从当前播放位置连续快退', () {
    controller
      ..position.value = 210
      ..hoverDx = 42
      ..seekPosition.value = 300
      ..multiBackwardStart();

    expect(controller.seekPosition.value, 205);
    expect(controller.isSeeking.value, isTrue);
    expect(controller.hoverDx, isNull);

    controller.position.value = 211;
    controller.multiBackwardStart();
    expect(controller.seekPosition.value, 200);
  });

  test('连续快退不会越过视频起点', () {
    controller.position.value = 8;

    controller.multiBackwardStart();
    expect(controller.seekPosition.value, 3);
    controller.multiBackwardStart();
    expect(controller.seekPosition.value, 0);
  });

  testWidgets('快退过程中移动鼠标不会改变快退位置', (tester) async {
    controller
      ..dataSource = NetworkSource(
        videoSource: 'http://127.0.0.1/video',
        audioSource: null,
      )
      ..duration.value = 400
      ..position.value = 210
      ..videoShot = LoadingState.loading()
      ..showControls.value = true;
    final animation = AnimationController(vsync: tester);
    addTearDown(animation.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomControl(
            maxWidth: 800,
            isFullScreen: false,
            animCtr: animation,
            controller: controller,
            buildBottomControl: () => const SizedBox.shrink(),
            videoDetailController: VideoDetailController(),
          ),
        ),
      ),
    );
    final bar = tester.getRect(find.byType(ProgressBar));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    await mouse.moveTo(Offset(bar.left + bar.width * .75, bar.center.dy));
    expect(controller.seekPosition.value, greaterThan(210));

    controller.multiBackwardStart();
    await tester.pump();
    await mouse.moveTo(Offset(bar.left + bar.width * .9, bar.center.dy));
    expect(controller.seekPosition.value, 205);
    await mouse.removePointer();
  });
}
