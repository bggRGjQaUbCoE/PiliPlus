import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/horizontal_video_model.dart';
import 'package:PiliPlus/models/model_owner.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _Item extends HorizontalVideoModel {
  _Item(Dimension? size, {int? cid = 1}) {
    title = 'sample';
    bvid = 'BV17x411w7KC';
    this.cid = cid;
    pubdate = 0;
    cover = '';
    dimension = size;
    owner = Owner(mid: 0, name: 'sample');
    stat = Stat.fromJson({});
  }
}

void main() {
  testWidgets(
    'shared search card gates motion by loaded cover and known video dimensions',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('search-cover-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        GStorage.video = await Hive.openBox('video');
        GStorage.localCache = await Hive.openBox('localCache');
        await GStorage.setting.put(SettingBoxKey.coverPageTransition, true);
        await GStorage.video.put(VideoBoxKey.cacheVideoFit, 1);
      });
      Request();
      Request.dio.interceptors.clear();
      Request.dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {
                'code': 0,
                'data': [
                  {
                    'cid': 2,
                    'dimension': {
                      'width': 1080,
                      'height': 1920,
                      'rotate': 0,
                    },
                  },
                ],
              },
            ),
          ),
        ),
      );
      LayeredPageTransitions.install();
      final image = MemoryImage(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
        ),
      );
      for (final loaded in [false, true]) {
        for (final size in [
          Dimension(width: 1920, height: 1080),
          Dimension(width: 1080, height: 1920),
          null,
        ]) {
          final item = _Item(size);
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
                        width: 500,
                        height: 150,
                        child: VideoCardH(videoItem: item, coverMotion: true),
                      ),
                    ),
                  ),
                ),
                GetPage(
                  name: '/videoV',
                  page: () => Scaffold(
                    body: switch (Get.arguments['coverTransition']) {
                      final CoverTransitionData data => CoverHandoff(
                        data: data,
                      ),
                      _ => const Text('fallback'),
                    },
                  ),
                ),
              ],
            ),
          );
          await tester.pumpAndSettle();
          // Exercise the real loaded-image notification, then the card's tap path.
          if (loaded) {
            tester
                .widget<NetworkImgLayer>(find.byType(NetworkImgLayer))
                .onImageReady!(image);
          }
          await tester.tap(find.byType(InkWell).first);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 100));
          final args = Get.arguments as Map;
          expect(args['cid'], 1);
          if (size != null && size.width != size.height && loaded) {
            expect(args['coverTransition'], isA<CoverTransitionData>());
            final transition = args['coverTransition'] as CoverTransitionData;
            expect(
              transition.image,
              same(image),
            );
            if (size.width! < size.height!) {
              expect(transition.contentAspectRatio, closeTo(9 / 16, .0001));
            } else {
              expect(transition.contentAspectRatio, isNull);
            }
            expect(
              find.byType(CoverVisual, skipOffstage: false),
              findsNWidgets(2),
            );
          } else {
            expect(args['coverTransition'], isNull);
            expect(find.text('fallback'), findsOneWidget);
          }
          Get.back<void>();
          await tester.pumpAndSettle();
          expect(find.byType(VideoCardH), findsOneWidget);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox());
          Get.reset();
        }
      }
      final item = _Item(null, cid: null);
      await tester.pumpWidget(
        GetMaterialApp(
          navigatorObservers: [MaterialApp.createMaterialHeroController()],
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => Scaffold(
                body: SizedBox(
                  width: 500,
                  height: 150,
                  child: VideoCardH(videoItem: item, coverMotion: true),
                ),
              ),
            ),
            GetPage(
              name: '/videoV',
              page: () => Scaffold(
                body: CoverHandoff(data: Get.arguments['coverTransition']),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      tester
          .widget<NetworkImgLayer>(find.byType(NetworkImgLayer))
          .onImageReady!(image);
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      expect(Get.arguments['cid'], 2);
      expect(
        (Get.arguments['coverTransition'] as CoverTransitionData)
            .contentAspectRatio,
        closeTo(9 / 16, .0001),
      );
      Get.back<void>();
      await tester.pumpAndSettle();
      Request.dio.interceptors.clear();
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
