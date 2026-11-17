import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/common/widgets/image/network_img_layer.dart';
import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/ugc.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/models_new/history/history.dart';
import 'package:PiliPlus/models_new/history/list.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/fav_detail/controller.dart';
import 'package:PiliPlus/pages/fav_detail/widget/fav_video_card.dart';
import 'package:PiliPlus/pages/history/widgets/item.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

class _Selection implements MultiSelectBase<HistoryItemModel> {
  @override
  final enableMultiSelect = false.obs;
  @override
  int get checkedCount => 0;
  @override
  void handleSelect({bool checked = false, bool disableSelect = true}) =>
      throw StateError('unexpected selection');
  @override
  void onRemove() => throw StateError('unexpected delete');
  @override
  void onSelect(HistoryItemModel item) =>
      throw StateError('unexpected selection');
}

void main() {
  testWidgets(
    'favorite playlist and history part/progress survive cover routing and CID mismatch',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('library-cover-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        GStorage.video = await Hive.openBox('video');
        GStorage.localCache = await Hive.openBox('localCache');
        await GStorage.setting.putAll({
          SettingBoxKey.coverPageTransition: true,
          SettingBoxKey.enablePlayAll: true,
        });
        await GStorage.video.put(VideoBoxKey.cacheVideoFit, 1);
      });
      Request();
      var mismatch = false, portrait = false, requests = 0;
      var hold = false;
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
                    'cid': mismatch ? 999 : 11,
                    'dimension': {
                      'width': portrait ? 1080 : 1920,
                      'height': portrait ? 1920 : 1080,
                    },
                  },
                  if (!mismatch)
                    {
                      'cid': 22,
                      'dimension': {
                        'width': portrait ? 1080 : 1920,
                        'height': portrait ? 1920 : 1080,
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
      final fav = FavDetailController();
      fav.folderInfo.value = FavFolderInfo(
        id: 55,
        title: 'folder',
        mediaCount: 2,
      );
      final item = FavDetailItemModel(
        id: 170001,
        type: 2,
        title: 'sample',
        cover: '',
        attr: 0,
        bvid: 'BV17x411w7KC',
        ugc: Ugc(firstCid: 11),
      );
      final history = HistoryItemModel(
        title: 'sample',
        cover: '',
        duration: 100,
        progress: 12,
        viewAt: 1,
        videos: 2,
        history: History(
          oid: 170001,
          bvid: 'BV17x411w7KC',
          cid: 22,
          page: 2,
          business: 'archive',
        ),
      );
      for (final kind in ['fav', 'history', 'mismatch', 'leave']) {
        mismatch = kind == 'mismatch';
        portrait = kind == 'fav' || kind == 'history';
        hold = kind == 'leave';
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
                      child: kind == 'fav'
                          ? FavVideoCardH(item: item, index: 0, ctr: fav)
                          : HistoryItem(
                              item: history,
                              ctr: _Selection(),
                              onDelete: (_, _) =>
                                  throw StateError('unexpected delete'),
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
        tester
            .widget<NetworkImgLayer>(find.byType(NetworkImgLayer))
            .onImageReady!(image);
        await tester.tap(find.byType(InkWell).first);
        await tester.pumpAndSettle();
        if (hold) {
          expect(deferred, isNotNull);
          final count = requests;
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(requests, count);
          Get.toNamed('/other');
          await tester.pumpAndSettle();
          deferred!();
          await tester.pumpAndSettle();
          expect(Get.currentRoute, '/other');
          Get.back<void>();
          await tester.pumpAndSettle();
          await tester.pumpWidget(const SizedBox());
          Get.reset();
          continue;
        }
        final args = Get.arguments as Map;
        expect(args['cid'], kind == 'fav' ? 11 : 22);
        if (kind == 'fav') {
          expect(args['sourceType'], SourceType.fav);
          expect(args['mediaId'], 55);
          expect(args['favTitle'], 'folder');
          expect(args['count'], 2);
          expect(args['oid'], 170001);
        } else {
          expect(args['progress'], 12000);
        }
        expect(
          args['coverTransition'],
          mismatch ? isNull : isA<CoverTransitionData>(),
        );
        if (!mismatch) {
          expect(args['isVertical'], isTrue);
          expect(
            (args['coverTransition'] as CoverTransitionData).contentAspectRatio,
            closeTo(9 / 16, .0001),
          );
        }
        Get.back<void>();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (!mismatch) {
          final count = requests;
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(requests, count);
          expect(Get.arguments['coverTransition'], isA<CoverTransitionData>());
          expect(
            (Get.arguments['coverTransition'] as CoverTransitionData)
                .contentAspectRatio,
            closeTo(9 / 16, .0001),
          );
          Get.back<void>();
          await tester.pumpAndSettle();
        }
        await tester.pumpWidget(const SizedBox());
        Get.reset();
      }
      expect(requests, 4);
      Request.dio.close(force: true);
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
