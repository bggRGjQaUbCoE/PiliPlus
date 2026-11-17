import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/common/widgets/image_viewer/gallery_viewer.dart';
import 'package:PiliPlus/models/common/image_preview_type.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as fw show Image;
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'an asynchronous full image replaces its thumbnail in one frame',
    (
      tester,
    ) async {
      final dir = await tester.runAsync(() async {
        final dir = await Directory.systemTemp.createTemp('gallery-handoff-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        return dir;
      });
      const full = CachedNetworkImageProvider(
        'https://example.invalid/full.png',
      );
      const preview = CachedNetworkImageProvider(
        'https://example.invalid/thumbnail.png',
      );
      final cache = PaintingBinding.instance.imageCache;
      final pending = Completer<ImageInfo>();
      ImageInfo image(int width, int height) {
        final recorder = ui.PictureRecorder();
        ui.Canvas(recorder).drawColor(Colors.red, BlendMode.src);
        final picture = recorder.endRecording();
        final info = ImageInfo(image: picture.toImageSync(width, height));
        picture.dispose();
        return info;
      }

      cache
        ..putIfAbsent(full, () => OneFrameImageStreamCompleter(pending.future))
        ..putIfAbsent(
          preview,
          () => OneFrameImageStreamCompleter(Future.value(image(40, 40))),
        );
      addTearDown(() async {
        cache
          ..evict(full)
          ..evict(preview);
        Get.reset();
        await Hive.close();
        await dir!.delete(recursive: true);
      });

      await tester.pumpWidget(
        const GetMaterialApp(
          home: GalleryViewer(
            quality: 100,
            sources: [
              SourceModel(
                url: 'https://example.invalid/full.png',
                previewImageProvider: preview,
              ),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      final thumbnail = find.byWidgetPredicate(
        (widget) => widget is fw.Image && widget.image == preview,
      );
      expect(thumbnail, findsOneWidget);
      final fullFrame = find.byWidgetPredicate(
        (widget) => widget is RawImage && widget.image?.width == 120,
      );
      expect(fullFrame, findsNothing);

      pending.complete(image(120, 80));
      await tester.idle();
      await tester.pump();
      expect(fullFrame, findsOneWidget);
      expect(thumbnail, findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 250));
    },
  );
}
