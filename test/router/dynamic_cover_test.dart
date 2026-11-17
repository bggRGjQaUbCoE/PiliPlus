import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/pages/dynamics/widgets/video_panel.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'dynamic video reuses metadata query and gates cover motion without stale navigation',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('dynamic-cover-');
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
      Request();
      var requests = 0, portrait = false, unknown = false, hold = false;
      VoidCallback? deferred;
      Request.dio.interceptors.clear();
      Request.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests++;
            final response = Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'code': 0,
                'data': [
                  {
                    'cid': 11,
                    if (!unknown)
                      'dimension': {
                        'width': portrait ? 1080 : 1920,
                        'height': portrait ? 1920 : 1080,
                        'rotate': 0,
                      },
                  },
                ],
              },
            );
            if (hold) {
              deferred = () => handler.resolve(response);
            } else {
              handler.resolve(response);
            }
          },
        ),
      );
      LayeredPageTransitions.install();
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
        ),
      );
      for (final scenario in [
        (
          loaded: true,
          portrait: false,
          unknown: false,
          hold: false,
          reduced: false,
        ),
        (
          loaded: false,
          portrait: false,
          unknown: false,
          hold: false,
          reduced: false,
        ),
        (
          loaded: true,
          portrait: true,
          unknown: false,
          hold: false,
          reduced: false,
        ),
        (
          loaded: true,
          portrait: false,
          unknown: true,
          hold: false,
          reduced: false,
        ),
        (
          loaded: true,
          portrait: false,
          unknown: false,
          hold: false,
          reduced: true,
        ),
        (
          loaded: true,
          portrait: false,
          unknown: false,
          hold: true,
          reduced: false,
        ),
      ]) {
        requests = 0;
        portrait = scenario.portrait;
        unknown = scenario.unknown;
        hold = scenario.hold;
        final item = DynamicItemModel.fromJson({
          'id_str': 'test',
          'type': 'DYNAMIC_TYPE_AV',
          'modules': {
            'module_dynamic': {
              'major': {
                'type': 'MAJOR_TYPE_ARCHIVE',
                'archive': {
                  'bvid': 'BV17x411w7KC',
                  'cover': '',
                  'title': 'dynamic video',
                  'type': 1,
                },
              },
            },
          },
        });
        await tester.pumpWidget(
          GetMaterialApp(
            navigatorObservers: [MaterialApp.createMaterialHeroController()],
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(disableAnimations: scenario.reduced),
              child: child!,
            ),
            getPages: [
              GetPage(
                name: '/',
                page: () => Scaffold(
                  body: Builder(
                    builder: (context) => SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 200),
                          SizedBox(
                            width: 400,
                            child: VideoSeasonPanel(
                              floor: 1,
                              theme: Theme.of(context),
                              item: item,
                              isSave: false,
                              isDetail: false,
                            ),
                          ),
                          const SizedBox(height: 900),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GetPage(
                name: '/other',
                page: () => const Scaffold(body: Text('other')),
              ),
              GetPage(
                name: '/videoV',
                page: () => const Scaffold(body: Text('video')),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();
        final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
        scroll.position.jumpTo(180);
        await tester.pumpAndSettle();
        if (scenario.loaded) {
          tester
              .widget<NetworkImgLayer>(find.byType(NetworkImgLayer))
              .onImageReady!(image);
        }
        await tester.tap(find.text('dynamic video'));
        await tester.pumpAndSettle();
        if (hold) {
          expect(deferred, isNotNull);
          await tester.tap(find.text('dynamic video'));
          await tester.pumpAndSettle();
          expect(requests, 1);
          Get.toNamed('/other');
          await tester.pumpAndSettle();
          deferred!();
          await tester.pumpAndSettle();
          expect(Get.currentRoute, '/other');
          Get.back<void>();
          await tester.pumpAndSettle();
        } else {
          expect(requests, 1);
          expect(Get.arguments['cid'], 11);
          final motion = scenario.loaded && !unknown && !scenario.reduced;
          expect(
            Get.arguments['coverTransition'],
            motion ? isA<CoverTransitionData>() : isNull,
          );
          if (motion) {
            expect(
              (Get.arguments['coverTransition'] as CoverTransitionData).image,
              same(image),
            );
            final aspectRatio =
                (Get.arguments['coverTransition'] as CoverTransitionData)
                    .contentAspectRatio;
            if (portrait) {
              expect(aspectRatio, closeTo(9 / 16, .0001));
            } else {
              expect(aspectRatio, isNull);
            }
          }
          Get.back<void>();
          await tester.pumpAndSettle();
        }
        expect(scroll.position.pixels, 180);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        Get.reset();
      }
      Request.dio.interceptors.clear();
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
