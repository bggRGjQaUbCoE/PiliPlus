import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:PiliPlus/common/widgets/motion/cover_motion.dart';
import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'named GetX route installs the cover transition and target Hero',
    (tester) async {
      late Directory dir;
      await tester.runAsync(() async {
        dir = await Directory.systemTemp.createTemp('cover-named-');
        Hive.init(dir.path);
        GStorage.setting = await Hive.openBox('setting');
        await GStorage.setting.put(SettingBoxKey.advancedMaterials, true);
      });
      LayeredPageTransitions.install();
      final data = CoverTransitionData(
        tag: Object(),
        image: MemoryImage(
          base64Decode(
            'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
          ),
        ),
        radius: BorderRadius.circular(12),
      );
      await tester.pumpWidget(
        GetMaterialApp(
          navigatorObservers: [MaterialApp.createMaterialHeroController()],
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => Scaffold(
                body: Hero(
                  tag: data.tag,
                  child: CoverVisual(data: data),
                ),
              ),
            ),
            GetPage(
              name: '/videoV',
              page: () => Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    CoverHandoff(data: Get.arguments['coverTransition']),
                    const Positioned(
                      bottom: 10,
                      right: 10,
                      child: SizedBox(
                        key: ValueKey('bottom-content'),
                        width: 40,
                        height: 40,
                        child: ColoredBox(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GetPage(
              name: '/videoNext',
              page: () => Scaffold(
                body: CoverHandoff(data: Get.arguments['coverTransition']),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      Get.toNamed<void>('/videoV', arguments: {'coverTransition': data});
      await tester.pump();
      final handoff = find.byType(CoverHandoff, skipOffstage: false);
      expect(
        tester
            .widget<Opacity>(
              find
                  .descendant(
                    of: handoff,
                    matching: find.byType(Opacity, skipOffstage: false),
                  )
                  .first,
            )
            .opacity,
        0,
      );
      await tester.pump(const Duration(milliseconds: 100));
      final target = tester.element(
        find.byType(CoverHandoff, skipOffstage: false),
      );
      expect(
        ModalRoute.of(target)!.settings.arguments,
        containsPair('coverTransition', same(data)),
      );
      expect(
        (ModalRoute.of(target)! as PageRoute).transitionDuration,
        const Duration(milliseconds: 320),
      );
      expect(
        (ModalRoute.of(target)! as PageRoute).reverseTransitionDuration,
        const Duration(milliseconds: 280),
      );
      expect(
        CoverTransitionData.motionCurve,
        const Cubic(0.25, 0.1, 0.25, 1),
      );
      expect(find.byType(CoverVisual, skipOffstage: false), findsNWidgets(3));
      final blur = tester.widget<ImageFiltered>(find.byType(ImageFiltered));
      expect(blur.enabled, isTrue);
      final t = ModalRoute.of(target)!.animation!.value;
      final p = t * t * (3 - 2 * t);
      expect(
        blur.imageFilter,
        ui.ImageFilter.blur(
          sigmaX: 6 * p,
          sigmaY: 6 * p,
          tileMode: ui.TileMode.clamp,
        ),
      );
      // Only the old route is inside the filter. Target and flight stay sharp.
      expect(
        find.descendant(
          of: find.byType(ImageFiltered),
          matching: find.byType(CoverHandoff, skipOffstage: false),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(ImageFiltered),
          matching: find.byType(CoverVisual, skipOffstage: false),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      final nextData = CoverTransitionData(
        tag: Object(),
        image: data.image,
        radius: BorderRadius.circular(12),
      );
      Get.toNamed<void>('/videoNext', arguments: {'coverTransition': nextData});
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final oldHandoff = find.byWidgetPredicate(
        (widget) => widget is CoverHandoff && identical(widget.data, data),
        skipOffstage: false,
      );
      final newHandoff = find.byWidgetPredicate(
        (widget) => widget is CoverHandoff && identical(widget.data, nextData),
        skipOffstage: false,
      );
      expect(
        find.ancestor(of: oldHandoff, matching: find.byType(ImageFiltered)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(ImageFiltered), matching: newHandoff),
        findsNothing,
      );
      final oldRoute = ModalRoute.of(tester.element(oldHandoff));
      final nestedBlur = tester.widget<ImageFiltered>(
        find.ancestor(of: oldHandoff, matching: find.byType(ImageFiltered)),
      );
      expect(nestedBlur.enabled, isTrue);
      final oldT = oldRoute!.secondaryAnimation!.value;
      final oldBlur = oldT * oldT * (3 - 2 * oldT);
      expect(
        nestedBlur.imageFilter,
        ui.ImageFilter.blur(
          sigmaX: 6 * oldBlur,
          sigmaY: 6 * oldBlur,
          tileMode: ui.TileMode.clamp,
        ),
      );
      Get.back<void>();
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => GStorage.setting.put(SettingBoxKey.advancedMaterials, false),
      );
      Get.toNamed<void>('/videoNext', arguments: {'coverTransition': nextData});
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final oldHandoffWithoutMaterials = find.byWidgetPredicate(
        (widget) => widget is CoverHandoff && identical(widget.data, data),
        skipOffstage: false,
      );
      final disabledBlur = tester.widget<ImageFiltered>(
        find.ancestor(
          of: oldHandoffWithoutMaterials,
          matching: find.byType(ImageFiltered),
        ),
      );
      expect(disabledBlur.enabled, isFalse);
      Get.back<void>();
      await tester.pumpAndSettle();
      // Content at the bottom is present throughout entry, not swept in by a
      // growing top-to-bottom clip. Hero still flies above the static page.
      expect(
        find.byKey(const ValueKey('bottom-content')).hitTestable(),
        findsOneWidget,
      );
      Get.back<void>();
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<ImageFiltered>(find.byType(ImageFiltered))
            .where((filter) => filter.enabled),
        isEmpty,
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
