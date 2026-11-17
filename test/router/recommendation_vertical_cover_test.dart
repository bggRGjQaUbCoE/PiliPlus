import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_v.dart';
import 'package:PiliPlus/models/home/rcmd/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

RcmdVideoItemAppModel _item({
  required String uri,
}) => RcmdVideoItemAppModel.fromJson({
  'player_args': {'aid': 170001, 'cid': 1, 'duration': 90},
  'param': '170001',
  'bvid': 'BV17x411w7KC',
  'cover': '',
  'title': 'portrait sample',
  'card_goto': 'av',
  'args': {'up_name': 'sample', 'up_id': 1},
  'uri': uri,
  'cover_left_text_1': '1万',
  'cover_left_text_2': '10',
});

void main() {
  testWidgets(
    'recommend card gates portrait flight by metadata, image and supported fit',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('recommend-portrait-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        GStorage.video = await Hive.openBox('video');
        GStorage.localCache = await Hive.openBox('localCache');
        await GStorage.setting.put(SettingBoxKey.coverPageTransition, true);
      });
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
        ),
      );
      final cases = [
        (
          uri: 'bilibili://video/170001?player_width=1080&player_height=1920&player_rotate=0',
          fit: VideoFitType.contain.index,
          loaded: true,
          expectedMotion: true,
          expectedAspect: 9 / 16,
          expectedWidth: 1080,
          expectedHeight: 1920,
        ),
        (
          uri: 'bilibili://video/170001?player_width=1920&player_height=1080&player_rotate=1',
          fit: VideoFitType.fill.index,
          loaded: true,
          expectedMotion: true,
          expectedAspect: 9 / 16,
          expectedWidth: 1080,
          expectedHeight: 1920,
        ),
        (
          uri: 'bilibili://video/170001?player_width=1080&player_height=1920',
          fit: VideoFitType.contain.index,
          loaded: true,
          expectedMotion: false,
          expectedAspect: null,
          expectedWidth: null,
          expectedHeight: null,
        ),
        (
          uri: 'bilibili://video/170001?player_width=1080&player_height=1920&player_rotate=0',
          fit: VideoFitType.contain.index,
          loaded: false,
          expectedMotion: false,
          expectedAspect: null,
          expectedWidth: 1080,
          expectedHeight: 1920,
        ),
        (
          uri: 'bilibili://video/170001?player_width=1080&player_height=1920&player_rotate=0',
          fit: VideoFitType.cover.index,
          loaded: true,
          expectedMotion: false,
          expectedAspect: null,
          expectedWidth: 1080,
          expectedHeight: 1920,
        ),
        (
          uri: 'bilibili://video/170001?player_width=1920&player_height=1080&player_rotate=0',
          fit: VideoFitType.cover.index,
          loaded: true,
          expectedMotion: true,
          expectedAspect: null,
          expectedWidth: 1920,
          expectedHeight: 1080,
        ),
      ];

      for (final item in cases) {
        await tester.runAsync(
          () => GStorage.video.put(VideoBoxKey.cacheVideoFit, item.fit),
        );
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorObservers: [MaterialApp.createMaterialHeroController()],
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => Scaffold(
                  body: SizedBox(
                    width: 360,
                    height: 380,
                    child: VideoCardV(
                      coverMotion: true,
                      videoItem: _item(uri: item.uri),
                    ),
                  ),
                ),
              ),
              GetPage(
                name: '/videoV',
                page: () {
                  final data = Get.arguments['coverTransition'];
                  return Scaffold(
                    body: data is CoverTransitionData
                        ? CoverHandoff(
                            data: data,
                            viewport: const Size(406.6667, 587.6),
                          )
                        : const Text('normal transition'),
                  );
                },
              ),
            ],
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16));
        final layer = tester.widget<NetworkImgLayer>(
          find.byType(NetworkImgLayer),
        );
        if (item.loaded) layer.onImageReady?.call(image);
        await tester.tap(find.byType(InkWell).first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 120));

        final args = Get.arguments as Map;
        expect(args['cid'], 1);
        final dimension = args['dimension'] as Dimension?;
        if (item.expectedWidth == null) {
          expect(dimension, isNull);
        } else {
          expect(dimension?.width, item.expectedWidth);
          expect(dimension?.height, item.expectedHeight);
        }
        final data = args['coverTransition'];
        if (!item.expectedMotion) {
          expect(data, isNull);
        } else {
          expect(data, isA<CoverTransitionData>());
          final transition = data as CoverTransitionData;
          expect(transition.contentAspectRatio, item.expectedAspect);
          if (item.expectedAspect != null) {
            expect(
              transition.contentAspectRatio,
              closeTo(item.expectedAspect!, .0001),
            );
            expect(
              transition.contentRectFor(const Size(406.6667, 587.6))!.left,
              closeTo(.0936, .001),
            );
          } else {
            expect(
              transition.contentRectFor(const Size(406.6667, 587.6)),
              isNull,
            );
          }
        }
        if (!item.expectedMotion) {
          expect(find.text('normal transition'), findsOneWidget);
        }
        Get.back<void>();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();
        expect(find.byType(VideoCardV), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
        Get.reset();
      }

      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
