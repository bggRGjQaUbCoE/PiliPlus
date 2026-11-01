import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:PiliPlus/plugin/pl_player/models/animated_capture.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/capture_region_editor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const frame = Size(1920, 1080);

void expectRatio(CaptureRegion region, Size size) {
  final rect = region.rect;
  expect(rect.left, greaterThanOrEqualTo(-1e-9));
  expect(rect.top, greaterThanOrEqualTo(-1e-9));
  expect(rect.right, lessThanOrEqualTo(1 + 1e-9));
  expect(rect.bottom, lessThanOrEqualTo(1 + 1e-9));
  expect(rect.width, greaterThan(0));
  expect(rect.height, greaterThan(0));
  if (!region.aspectRatio.isFree) {
    expect(
      rect.width * size.width / (rect.height * size.height),
      closeTo(
        region.aspectRatio.numerator / region.aspectRatio.denominator,
        1e-9,
      ),
    );
    final pixels = region.pixels(size.width.toInt(), size.height.toInt());
    expect(
      pixels.width.toInt() * region.aspectRatio.denominator,
      pixels.height.toInt() * region.aspectRatio.numerator,
    );
    expect(pixels.width, closeTo(rect.width * size.width, 1e-6));
    expect(pixels.height, closeTo(rect.height * size.height, 1e-6));
    expect(pixels.left, greaterThanOrEqualTo(0));
    expect(pixels.top, greaterThanOrEqualTo(0));
    expect(pixels.right, lessThanOrEqualTo(size.width));
    expect(pixels.bottom, lessThanOrEqualTo(size.height));
  }
}

void main() {
  test('presets retain requested order and reduced pixel units', () {
    expect(CaptureAspectRatio.values.map((r) => r.label).toList(), [
      '自由',
      '1:1',
      '4:3',
      '3:4',
      '3:2',
      '2:3',
      '5:4',
      '4:5',
      '16:9',
      '9:16',
      '16:10',
      '10:16',
      '2:1',
      '1:2',
      '21:9',
    ]);
    expect(CaptureAspectRatio.landscape16x10.numerator, 8);
    expect(CaptureAspectRatio.ultrawide.numerator, 7);
  });

  for (final ratio in CaptureAspectRatio.values.where((r) => !r.isFree)) {
    test('${ratio.label}: switch preserves center and area when it fits', () {
      const initial = CaptureRegion(Rect.fromLTRB(.4, .4, .6, .6));
      final selected = initial.withAspectRatio(ratio, frame);
      expectRatio(selected, frame);
      expect(selected.rect.center.dx, closeTo(initial.rect.center.dx, 1e-9));
      expect(selected.rect.center.dy, closeTo(initial.rect.center.dy, 1e-9));
      final targetUnits = math.sqrt(
        initial.rect.width *
            frame.width *
            initial.rect.height *
            frame.height /
            (ratio.numerator * ratio.denominator),
      );
      final selectedUnits = selected.rect.width * frame.width / ratio.numerator;
      expect(selectedUnits, lessThanOrEqualTo(targetUnits + 1e-6));
      expect(targetUnits - selectedUnits, lessThan(1));
    });

    for (var corner = 0; corner < 4; corner++) {
      test(
        '${ratio.label}: corner $corner locks opposite anchor and bounds',
        () {
          final selected = const CaptureRegion(
            Rect.fromLTRB(.25, .25, .75, .75),
          ).withAspectRatio(ratio, frame);
          final before = selected.rect;
          final anchor = [
            before.bottomRight,
            before.bottomLeft,
            before.topLeft,
            before.topRight,
          ][corner];
          final sx = corner == 0 || corner == 3 ? -1 : 1;
          final sy = corner == 0 || corner == 1 ? -1 : 1;
          final enlarged = selected.resizeCorner(
            corner,
            anchor + Offset(sx * 10.0, sy * 10.0),
            frame,
          );
          expectRatio(enlarged, frame);
          final after = enlarged.rect;
          expect(
            [
              after.bottomRight,
              after.bottomLeft,
              after.topLeft,
              after.topRight,
            ][corner],
            anchor,
          );
          final minimum = selected.resizeCorner(
            corner,
            anchor - Offset(sx.toDouble(), sy.toDouble()),
            frame,
          );
          expectRatio(minimum, frame);
          final minPixels = minimum.pixels(
            frame.width.toInt(),
            frame.height.toInt(),
          );
          expect(minPixels.width, ratio.numerator);
          expect(minPixels.height, ratio.denominator);
          final movingCorner = [
            minimum.rect.topLeft,
            minimum.rect.topRight,
            minimum.rect.bottomRight,
            minimum.rect.bottomLeft,
          ][corner];
          expect((movingCorner.dx - anchor.dx) * sx, greaterThan(0));
          expect((movingCorner.dy - anchor.dy) * sy, greaterThan(0));
        },
      );
    }

    test(
      '${ratio.label}: move, redraw and resolution change preserve ratio',
      () {
        final selected = const CaptureRegion(Rect.fromLTRB(.1, .2, .4, .6))
            .withAspectRatio(ratio, frame);
        final moved = selected.moved(const Offset(10, -10));
        expectRatio(moved, frame);
        expect(moved.rect.width, closeTo(selected.rect.width, 1e-9));
        expect(moved.rect.height, closeTo(selected.rect.height, 1e-9));
        expectRatio(
          selected.drawFrom(const Offset(.2, .3), const Offset(.8, .9), frame),
          frame,
        );
        expectRatio(
          selected.drawFrom(const Offset(.7, .8), const Offset(.1, .05), frame),
          frame,
        );
        const portraitFrame = Size(641, 1001);
        final changed = selected.withAspectRatio(ratio, portraitFrame);
        expectRatio(changed, portraitFrame);
        final free = selected.withAspectRatio(CaptureAspectRatio.free, frame);
        expect(free.rect, selected.rect);
        expect(free.aspectRatio, CaptureAspectRatio.free);
      },
    );
  }

  testWidgets(
    'preset selection, resize, move, reopen and reset retain expected state',
    (tester) async {
      tester.view.physicalSize = const Size(800, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final picture = ui.PictureRecorder();
      Canvas(picture).drawRect(
        const Rect.fromLTWH(0, 0, 320, 180),
        Paint()..color = Colors.blue,
      );
      final image = await picture.endRecording().toImage(320, 180);
      CaptureRegion? result;
      Future<void> open(CaptureRegion initial) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await showDialog<CaptureRegion>(
                    context: context,
                    builder: (_) =>
                        CaptureRegionEditor(image: image, initial: initial),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
      }

      Finder regionPaint() => find.byWidgetPredicate(
        (w) =>
            w is CustomPaint &&
            w.painter.runtimeType.toString() == '_RegionPainter',
      );
      Rect selection() =>
          (tester.widget<CustomPaint>(regionPaint()).painter as dynamic).rect
              as Rect;
      await open(CaptureRegion.full);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '自由'))
            .selected,
        isTrue,
      );
      await tester.tap(find.text('1:1'));
      await tester.pumpAndSettle();
      final area = tester.getRect(regionPaint());
      final before = selection();
      final corner =
          area.topLeft +
          Offset(before.left * area.width, before.top * area.height);
      await tester.dragFrom(corner, const Offset(50, 40));
      await tester.pump();
      expectRatio(
        CaptureRegion(selection(), aspectRatio: CaptureAspectRatio.square),
        const Size(320, 180),
      );
      expect(selection().bottomRight, before.bottomRight);
      final center =
          area.topLeft +
          Offset(
            selection().center.dx * area.width,
            selection().center.dy * area.height,
          );
      final sizeBeforeMove = selection().size;
      await tester.dragFrom(center, const Offset(35, 0));
      await tester.pump();
      expect(selection().width, closeTo(sizeBeforeMove.width, 1e-9));
      expect(selection().height, closeTo(sizeBeforeMove.height, 1e-9));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(result!.aspectRatio, CaptureAspectRatio.square);
      final saved = result!;
      await open(saved);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '1:1'))
            .selected,
        isTrue,
      );
      expect(selection().left, closeTo(saved.rect.left, 1e-9));
      expect(selection().top, closeTo(saved.rect.top, 1e-9));
      expect(selection().right, closeTo(saved.rect.right, 1e-9));
      expect(selection().bottom, closeTo(saved.rect.bottom, 1e-9));
      await tester.tap(find.text('重置'));
      await tester.pumpAndSettle();
      expect(selection(), CaptureRegion.full.rect);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '自由'))
            .selected,
        isTrue,
      );
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(saved.aspectRatio, CaptureAspectRatio.square);
      await tester.pumpWidget(const SizedBox());
      image.dispose();
    },
  );

  testWidgets(
    'ratio rail scrolls independently in landscape and portrait layouts',
    (tester) async {
      tester.view.physicalSize = const Size(800, 320);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final picture = ui.PictureRecorder();
      Canvas(picture).drawRect(const Rect.fromLTWH(0, 0, 320, 180), Paint());
      final image = await picture.endRecording().toImage(320, 180);
      await tester.pumpWidget(
        MaterialApp(
          home: CaptureRegionEditor(image: image, initial: CaptureRegion.full),
        ),
      );
      final scrollable = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.text('21:9'),
        200,
        scrollable: scrollable,
      );
      await tester.tap(find.text('21:9'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final finder = find.byWidgetPredicate(
        (w) =>
            w is CustomPaint &&
            w.painter.runtimeType.toString() == '_RegionPainter',
      );
      final landscape = tester.getRect(finder);
      expect(landscape.left, greaterThanOrEqualTo(80));
      tester.view.physicalSize = const Size(360, 720);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final portrait = tester.getRect(finder);
      expect(portrait.left, greaterThanOrEqualTo(80));
      final dynamic painter = tester.widget<CustomPaint>(finder).painter;
      expectRatio(
        CaptureRegion(
          painter.rect as Rect,
          aspectRatio: CaptureAspectRatio.ultrawide,
        ),
        const Size(320, 180),
      );
      await tester.pumpWidget(const SizedBox());
      image.dispose();
    },
  );
  testWidgets(
    'unsupported tiny source retains preset until another choice is made',
    (tester) async {
      final picture = ui.PictureRecorder();
      Canvas(picture).drawRect(const Rect.fromLTWH(0, 0, 8, 8), Paint());
      final image = await picture.endRecording().toImage(8, 8);
      await tester.pumpWidget(
        MaterialApp(
          home: CaptureRegionEditor(
            image: image,
            initial: const CaptureRegion(
              Rect.fromLTRB(.1, .1, .9, .9),
              aspectRatio: CaptureAspectRatio.landscape16x9,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('画面尺寸不足以使用此比例，请选择其他比例'), findsOneWidget);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, '确定'))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '16:9'))
            .selected,
        isTrue,
      );
      final scrollable = find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        find.text('自由'),
        -200,
        scrollable: scrollable,
      );
      await tester.tap(find.text('自由'));
      await tester.pumpAndSettle();
      expect(find.text('画面尺寸不足以使用此比例，请选择其他比例'), findsNothing);
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, '确定'))
            .onPressed,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox());
      image.dispose();
    },
  );
  testWidgets(
    'edge corner handles accept drags from their centers and outer margin',
    (tester) async {
      tester.view.physicalSize = const Size(800, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final picture = ui.PictureRecorder();
      Canvas(picture).drawRect(const Rect.fromLTWH(0, 0, 320, 180), Paint());
      final image = await picture.endRecording().toImage(320, 180);
      await tester.pumpWidget(
        MaterialApp(
          home: CaptureRegionEditor(
            image: image,
            initial: const CaptureRegion(
              Rect.fromLTRB(0, 0, 1, 1),
              aspectRatio: CaptureAspectRatio.landscape16x9,
            ),
          ),
        ),
      );
      Finder painted() => find.byWidgetPredicate(
        (w) =>
            w is CustomPaint &&
            w.painter.runtimeType.toString() == '_RegionPainter',
      );
      Rect selected() =>
          (tester.widget<CustomPaint>(painted()).painter as dynamic).rect
              as Rect;
      for (final outside in [4.0, 0.0]) {
        if (outside == 0) {
          await tester.tap(find.text('重置'));
          await tester.pumpAndSettle();
          final scrollable = find.descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          );
          await tester.scrollUntilVisible(
            find.text('16:9'),
            200,
            scrollable: scrollable,
          );
          await tester.tap(find.text('16:9'));
          await tester.pumpAndSettle();
        }
        final area = tester.getRect(painted());
        expect(area.bottom + 6, lessThan(tester.view.physicalSize.height));
        expect(area.right + 6, lessThan(tester.view.physicalSize.width));
        await tester.dragFrom(
          area.bottomRight + Offset(outside, outside),
          const Offset(-45, -35),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(selected().width, lessThan(1));
        expect(selected().height, lessThan(1));
        expect(selected().topLeft, Offset.zero);
        expectRatio(
          CaptureRegion(
            selected(),
            aspectRatio: CaptureAspectRatio.landscape16x9,
          ),
          const Size(320, 180),
        );
      }
      final before = selected();
      final area = tester.getRect(painted());
      await tester.dragFrom(
        Offset(area.left - 6, area.center.dy),
        const Offset(25, 15),
      );
      await tester.pump();
      expect(
        selected(),
        before,
        reason: 'Empty margin must not create or move a selection',
      );
      await tester.pumpWidget(const SizedBox());
      image.dispose();
    },
  );
}
