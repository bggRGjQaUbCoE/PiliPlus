import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/common/widgets/image_viewer/gallery_viewer.dart';
import 'package:PiliPlus/common/widgets/image_viewer/hero_dialog_route.dart';
import 'package:PiliPlus/common/widgets/image_viewer/viewer.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as fw show Image;
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'gallery Hero supports loaded images, zoom, paging, long image and interrupted return',
    (tester) async {
      late Directory dir;
      late File image;
      late File longImage;
      final scroll = ScrollController();
      var single = false;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('gallery-hero-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        GStorage.video = await Hive.openBox('video');
        GStorage.localCache = await Hive.openBox('localCache');
        image = await File('${dir.path}/image.png').writeAsBytes(
          base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
          ),
        );
        final recorder = ui.PictureRecorder();
        ui.Canvas(recorder).drawColor(const Color(0xff88aaee), BlendMode.src);
        final picture = recorder.endRecording();
        final decoded = await picture.toImage(120, 1800);
        final bytes = await decoded.toByteData(format: ui.ImageByteFormat.png);
        longImage = await File('${dir.path}/long.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        decoded.dispose();
        picture.dispose();
      });
      await tester.pumpWidget(
        GetMaterialApp(
          navigatorObservers: [MaterialApp.createMaterialHeroController()],
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scroll,
              padding: const EdgeInsets.only(top: 400, bottom: 1000),
              child: Center(
                child: GestureDetector(
                  key: const ValueKey('source'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.key.currentState!.push(
                    HeroDialogRoute<void>(
                      fade: false,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          GalleryViewer(
                            quality: 100,
                            sources: [
                              SourceModel(
                                sourceType: SourceType.fileImage,
                                url: image.path,
                              ),
                              if (!single)
                                SourceModel(
                                  sourceType: SourceType.fileImage,
                                  url: longImage.path,
                                ),
                            ],
                          ),
                    ),
                  ),
                  child: Hero(
                    tag: image.path,
                    child: const SizedBox(width: 100, height: 100),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await precacheImage(FileImage(image), Get.context!);
        await precacheImage(FileImage(longImage), Get.context!);
      });
      scroll.jumpTo(300);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('source')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('1/2'), findsOneWidget);
      expect(
        tester
            .widgetList<RawImage>(find.byType(RawImage))
            .any((w) => w.image != null),
        isTrue,
      );
      final center = tester.getCenter(find.byType(GalleryViewer));
      await tester.tapAt(center);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tapAt(center);
      await tester.pumpAndSettle();
      Matrix4 transform() => tester
          .widget<Transform>(
            find
                .descendant(
                  of: find.byType(Viewer).first,
                  matching: find.byType(Transform),
                )
                .first,
          )
          .transform;
      expect(transform().storage[0], greaterThan(1));
      await tester.tapAt(center);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tapAt(center);
      await tester.pumpAndSettle();
      expect(transform().storage[0], closeTo(1, .001));
      final gesture = await tester.startGesture(center, pointer: 20);
      await gesture.moveBy(const Offset(-100, 0));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveBy(const Offset(-500, 0));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(
        tester.widget<PageView>(find.byType(PageView)).controller!.page,
        closeTo(1, .001),
      );
      expect(find.text('2/2'), findsOneWidget);
      expect(
        tester.widgetList<Viewer>(find.byType(Viewer)).any((w) => w.isLongPic),
        isTrue,
      );
      await tester.drag(
        find.byType(GalleryViewer),
        const Offset(0, -240),
        pointer: 21,
      );
      await tester.pumpAndSettle();
      expect(find.byType(GalleryViewer), findsOneWidget);
      expect(tester.takeException(), isNull);
      Get.back<void>();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));
      expect(tester.takeException(), isNull);
      expect(scroll.offset, 300);
      single = true;
      await tester.tap(find.byKey(const ValueKey('source')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('1/1'), findsOneWidget);
      final closeTap = await tester.createGesture(pointer: 30);
      await closeTap.down(center, timeStamp: const Duration(seconds: 2));
      await closeTap.up(timeStamp: const Duration(milliseconds: 2040));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(GalleryViewer), findsNothing);
      expect(scroll.offset, 300);
      await tester.tap(find.byKey(const ValueKey('source')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      Get.back<void>();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(GalleryViewer), findsNothing);
      expect(scroll.offset, 300);
      expect(tester.takeException(), isNull);
      final provider = FileImage(longImage);
      await tester.pumpWidget(
        GetMaterialApp(
          navigatorObservers: [MaterialApp.createMaterialHeroController()],
          home: Scaffold(
            body: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < 2; index++)
                    GestureDetector(
                      key: ValueKey('thumb-$index'),
                      onTap: () => Get.key.currentState!.push(
                        HeroDialogRoute<void>(
                          fade: true,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  GalleryViewer(
                                    quality: 100,
                                    tag: 'grid',
                                    indexedHeroTags: true,
                                    sources: [
                                      for (var i = 0; i < 2; i++)
                                        SourceModel(
                                          sourceType: SourceType.fileImage,
                                          url: longImage.path,
                                          width: 120,
                                          height: 1800,
                                          previewImageProvider: provider,
                                          heroBorderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                    ],
                                  ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: '${longImage.path}grid$index',
                          child: fw.Image(
                            image: provider,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await precacheImage(provider, Get.context!);
      });
      await tester.tap(find.byKey(const ValueKey('thumb-0')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));
      expect(find.byType(GalleryViewer), findsOneWidget);
      expect(
        tester
            .widgetList<fw.Image>(find.byType(fw.Image))
            .any(
              (item) => item.image == provider && item.fit == BoxFit.contain,
            ),
        isTrue,
      );
      expect(
        tester
            .widgetList<OverflowBox>(find.byType(OverflowBox))
            .any(
              (item) =>
                  item.child is fw.Image &&
                  item.minWidth != null &&
                  item.minHeight != null &&
                  (item.minHeight! / item.minWidth! - 15).abs() < .001,
            ),
        isTrue,
      );
      expect(
        tester
            .widgetList<FadeTransition>(find.byType(FadeTransition))
            .any((item) => item.opacity.value > 0 && item.opacity.value < 1),
        isTrue,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      final duplicateGesture = await tester.startGesture(
        tester.getCenter(find.byType(GalleryViewer)),
        pointer: 22,
      );
      await duplicateGesture.moveBy(const Offset(-100, 0));
      await tester.pump(const Duration(milliseconds: 50));
      await duplicateGesture.moveBy(const Offset(-500, 0));
      await tester.pump(const Duration(milliseconds: 50));
      await duplicateGesture.up();
      await tester.pumpAndSettle();
      expect(find.text('2/2'), findsOneWidget);
      await tester.drag(
        find.byType(GalleryViewer),
        const Offset(0, 800),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(GalleryViewer), findsNothing);
      expect(tester.takeException(), isNull);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      scroll.dispose();
      Get.reset();
      await tester.runAsync(() async {
        await Hive.close();
        await dir.delete(recursive: true);
      });
    },
  );
}
