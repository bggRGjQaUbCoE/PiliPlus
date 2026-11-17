import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:PiliPlus/pages/member_video/widgets/video_card_h_member_video.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'UP card handles rotation, incomplete metadata, unloaded cover and custom player action',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('member-cover-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        GStorage.video = await Hive.openBox('video');
        GStorage.localCache = await Hive.openBox('localCache');
        await GStorage.setting.put(SettingBoxKey.coverPageTransition, true);
        await GStorage.video.put(
          VideoBoxKey.cacheVideoFit,
          VideoFitType.contain.index,
        );
      });
      LayeredPageTransitions.install();
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
        ),
      );
      final cases = [
        (
          uri: 'player_width=1920&player_height=1080&player_rotate=0',
          loaded: true,
          cid: 1,
          custom: false,
          motion: true,
          vertical: false,
        ),
        (
          uri: 'player_width=1080&player_height=1920&player_rotate=0',
          loaded: true,
          cid: 1,
          custom: false,
          motion: true,
          vertical: true,
        ),
        (
          uri: 'player_width=1080&player_height=1920&player_rotate=1',
          loaded: true,
          cid: 1,
          custom: false,
          motion: true,
          vertical: false,
        ),
        (
          uri: 'player_width=1920&player_height=1080&player_rotate=1',
          loaded: true,
          cid: 1,
          custom: false,
          motion: true,
          vertical: true,
        ),
        (
          uri: 'player_width=1080&player_height=1920',
          loaded: true,
          cid: 1,
          custom: false,
          motion: false,
          vertical: true,
        ),
        (
          uri: 'player_width=1920',
          loaded: true,
          cid: 1,
          custom: false,
          motion: false,
          vertical: false,
        ),
        (
          uri: 'player_width=1920&player_height=1080',
          loaded: false,
          cid: 1,
          custom: false,
          motion: false,
          vertical: false,
        ),
        (
          uri: 'player_width=1920&player_height=1080',
          loaded: true,
          cid: 1,
          custom: true,
          motion: false,
          vertical: false,
        ),
        (
          uri: 'player_width=1920&player_height=1080',
          loaded: true,
          cid: null,
          custom: false,
          motion: false,
          vertical: false,
        ),
      ];
      for (final scenario in cases) {
        var customCalled = false;
        final item = SpaceArchiveItem.fromJson({
          'title': 'sample',
          'cover': '',
          'uri': 'bilibili://video/170001?${scenario.uri}',
          'param': '170001',
          'goto': 'av',
          'bvid': 'BV17x411w7KC',
          'first_cid': scenario.cid,
          'author': 'sample',
          'duration': 100,
          'publish_time_text': '2026-11-02',
        });
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorObservers: [MaterialApp.createMaterialHeroController()],
            initialRoute: '/',
            getPages: [
              GetPage(
                name: '/',
                page: () => Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 600,
                      height: 160,
                      child: VideoCardHMemberVideo(
                        videoItem: item,
                        coverMotion: true,
                        onTap: scenario.custom
                            ? () => customCalled = true
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              GetPage(
                name: '/videoV',
                page: () => const Scaffold(body: Text('video')),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        if (scenario.loaded) {
          tester
              .widget<NetworkImgLayer>(find.byType(NetworkImgLayer))
              .onImageReady
              ?.call(image);
        }
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();
        if (scenario.custom || scenario.cid == null) {
          expect(Get.currentRoute, '/');
          expect(customCalled, scenario.custom);
        } else {
          final args = Get.arguments as Map;
          expect(args['cid'], 1);
          expect(args['isVertical'], scenario.vertical);
          expect(
            args['coverTransition'],
            scenario.motion ? isA<CoverTransitionData>() : isNull,
          );
          if (scenario.motion) {
            expect(
              (args['coverTransition'] as CoverTransitionData).image,
              same(image),
            );
            if (scenario.vertical) {
              expect(
                (args['coverTransition'] as CoverTransitionData)
                    .contentAspectRatio,
                closeTo(9 / 16, .0001),
              );
            }
          }
          Get.back<void>();
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        Get.reset();
      }
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
