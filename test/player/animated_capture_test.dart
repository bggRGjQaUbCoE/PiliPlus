import 'dart:ui';

import 'package:PiliPlus/plugin/pl_player/models/animated_capture.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/capture_region_editor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('endpoint step preserves milliseconds and clamps to video bounds', () {
    expect(stepCaptureTime(30.7, 3, 100), closeTo(33.7, 0.000001));
    expect(stepCaptureTime(30.7, -7, 100), closeTo(23.7, 0.000001));
    expect(stepCaptureTime(1.2, -3, 100), 0);
    expect(stepCaptureTime(98.7, 3, 100), 100);
    expect(stepCaptureTime(0, 3, 1.5), 1.5);
  });
  test('crop maps outward and stays nonempty at frame edges', () {
    const crop = CaptureRegion(Rect.fromLTRB(.101, .203, .799, .887));
    expect(crop.pixels(1920, 1080), const Rect.fromLTRB(193, 219, 1535, 958));
    expect(
      const CaptureRegion(Rect.fromLTRB(1, 1, 1, 1)).pixels(10, 10),
      const Rect.fromLTRB(9, 9, 10, 10),
    );
    expect(
      CaptureRegion.full.pixels(640, 360),
      const Rect.fromLTRB(0, 0, 640, 360),
    );
  });
  test('normalized selection follows source resolution', () {
    const crop = CaptureRegion(Rect.fromLTRB(.25, .25, .75, .75));
    expect(crop.pixels(1920, 1080).size, const Size(960, 540));
    expect(crop.pixels(640, 360).size, const Size(320, 180));
  });
  testWidgets('drag creates a region, reset restores the full frame', (
    tester,
  ) async {
    final recorder = PictureRecorder();
    Canvas(recorder).drawRect(const Rect.fromLTWH(0, 0, 320, 180), Paint());
    final image = await recorder.endRecording().toImage(320, 180);
    await tester.pumpWidget(
      MaterialApp(
        home: CaptureRegionEditor(image: image, initial: CaptureRegion.full),
      ),
    );
    final paint = find.byWidgetPredicate(
      (w) =>
          w is CustomPaint &&
          w.painter.runtimeType.toString() == '_RegionPainter',
    );
    final area = tester.getRect(paint);
    final drag = await tester.startGesture(area.topLeft + const Offset(60, 40));
    await drag.moveTo(area.center);
    await drag.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
    final dynamic selectedPainter = tester.widget<CustomPaint>(paint).painter;
    expect((selectedPainter.rect as Rect).width, lessThan(1));
    expect((selectedPainter.rect as Rect).width, greaterThan(0));
    await tester.tap(find.text('重置'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    final dynamic resetPainter = tester.widget<CustomPaint>(paint).painter;
    expect(resetPainter.rect, CaptureRegion.full.rect);
    await tester.pumpWidget(const SizedBox());
    image.dispose();
  });
}
