import 'package:PiliPlus/common/widgets/gesture/mouse_interactive_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('forwards pointer move up and cancel callbacks', (tester) async {
    final childKey = GlobalKey();
    final transformationController = TransformationController();
    final scaleGestureRecognizer = ScaleGestureRecognizer();
    int moveCount = 0;
    int upCount = 0;
    int cancelCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 200,
          height: 200,
          child: MouseInteractiveViewer(
            pointerSignalFallback: (_) {},
            onPointerDown: (_) {},
            onPointerMove: (_) => moveCount += 1,
            onPointerUp: (_) => upCount += 1,
            onPointerCancel: (_) => cancelCount += 1,
            onPanStart: (_) {},
            onPanUpdate: (_) {},
            onPanEnd: (_) {},
            onScaleUpdate: (_) {},
            transformationController: transformationController,
            childKey: childKey,
            scaleGestureRecognizer: scaleGestureRecognizer,
            child: SizedBox(key: childKey, width: 100, height: 100),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      const Offset(50, 50),
      kind: PointerDeviceKind.touch,
    );
    await gesture.moveBy(const Offset(5, 0));
    await gesture.up();

    expect(moveCount, greaterThanOrEqualTo(1));
    expect(upCount, 1);

    final cancelledGesture = await tester.startGesture(
      const Offset(50, 50),
      kind: PointerDeviceKind.touch,
      pointer: 2,
    );
    await cancelledGesture.cancel();

    expect(cancelCount, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    scaleGestureRecognizer.dispose();
    transformationController.dispose();
  });
}
