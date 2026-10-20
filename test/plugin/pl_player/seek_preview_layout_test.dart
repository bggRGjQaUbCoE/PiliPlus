import 'dart:math' as math;

import 'package:PiliPlus/plugin/pl_player/view/view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'preview follows either track, clears charts and stays inside small players',
    (tester) async {
      const normal = Size(640, 360), small = Size(120, 90);
      final player = GlobalKey(), bar = GlobalKey(), panel = GlobalKey();
      for (final (size, fraction, height, bottom, chart, slide) in [
        (normal, 0.0, 14.0, 50.0, 0.0, 0.0),
        (normal, 0.5, 14.0, 50.0, 35.75, 0.0),
        (normal, 1.0, 14.0, 50.0, 35.75, 0.0),
        (normal, 0.5, 14.0, 50.0, 35.75, 0.5),
        (normal, 0.5, 5.0, 0.0, 31.25, 0.0),
        (small, 0.0, 5.0, 0.0, 31.25, 0.0),
        (small, 1.0, 5.0, 0.0, 31.25, 0.0),
      ]) {
        await tester.pumpWidget(
          Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                key: player,
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottom,
                    height: height,
                    child: FractionalTranslation(
                      translation: Offset(0, slide),
                      child: SizedBox(key: bar),
                    ),
                  ),
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final target =
                            bar.currentContext!.findRenderObject()!
                                as RenderBox;
                        final rect =
                            target.localToGlobal(
                              Offset.zero,
                              ancestor: player.currentContext!
                                  .findRenderObject(),
                            ) &
                            target.size;
                        return CustomSingleChildLayout(
                          delegate: SeekPreviewLayout(rect, fraction, chart),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              key: panel,
                              width: 192,
                              height: 146,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final bounds = tester.getRect(find.byKey(player));
        final track = tester.getRect(find.byKey(bar));
        final preview = tester.getRect(find.byKey(panel));
        expect(preview.left, greaterThanOrEqualTo(bounds.left + 8));
        expect(preview.right, lessThanOrEqualTo(bounds.right - 8));
        expect(preview.top, greaterThanOrEqualTo(bounds.top + 8));
        expect(
          preview.bottom,
          closeTo(math.min(track.top, track.bottom - chart) - 8, 0.001),
        );
        if (fraction == 0.5) {
          expect(preview.center.dx, closeTo(track.center.dx, 0.001));
        }
        if (size == small) expect(preview.height, lessThan(146));
      }
    },
  );
}
