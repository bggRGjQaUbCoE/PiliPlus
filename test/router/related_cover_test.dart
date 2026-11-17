import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/common/widgets/video_card/video_card_h.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/video/related/controller.dart';
import 'package:PiliPlus/pages/video/related/view.dart';
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
    'related panel uses shared loaded cover and preserves source list',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('related-cover-');
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
      final item = HotVideoItemModel.fromJson({
        'aid': 170001,
        'cid': 1,
        'bvid': 'BV17x411w7KC',
        'title': 'related',
        'pic': '',
        'duration': 100,
        'pubdate': 0,
        'owner': {'mid': 1, 'name': 'sample'},
        'stat': <String, dynamic>{},
        'dimension': {'width': 1080, 'height': 1920, 'rotate': 0},
      });
      await tester.pumpWidget(
        GetMaterialApp(
          navigatorObservers: [MaterialApp.createMaterialHeroController()],
          getPages: [
            GetPage(
              name: '/',
              page: () => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      Get.toNamed('/source', arguments: {'bvid': item.bvid}),
                  child: const Text('source'),
                ),
              ),
            ),
            GetPage(
              name: '/source',
              page: () {
                Get.put(
                  RelatedController(autoQuery: false)
                    ..loadingState.value = Success([item]),
                  tag: 'fixture',
                );
                return const Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: SizedBox(height: 300)),
                      RelatedVideoPanel(heroTag: 'fixture'),
                      SliverToBoxAdapter(child: SizedBox(height: 900)),
                    ],
                  ),
                );
              },
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
      await tester.tap(find.text('source'));
      await tester.pumpAndSettle();
      final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
      scroll.position.jumpTo(240);
      await tester.pumpAndSettle();
      final card = find.byType(VideoCardH);
      final cardState = tester.state(card);
      tester
          .widget<NetworkImgLayer>(
            find.descendant(of: card, matching: find.byType(NetworkImgLayer)),
          )
          .onImageReady!(image);
      await tester.tap(
        find.descendant(of: card, matching: find.byType(InkWell)).first,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(Get.arguments['cid'], 1);
      expect(
        (Get.arguments['coverTransition'] as CoverTransitionData).image,
        same(image),
      );
      expect(
        (Get.arguments['coverTransition'] as CoverTransitionData)
            .contentAspectRatio,
        closeTo(9 / 16, .0001),
      );
      expect(find.byType(CoverVisual, skipOffstage: false), findsNWidgets(2));
      Get.back<void>();
      await tester.pumpAndSettle();
      expect(tester.state(card), same(cardState));
      expect(scroll.position.pixels, 240);
      expect(
        Get.find<RelatedController>(tag: 'fixture').loadingState.value.data,
        [item],
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      Get.reset();
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
