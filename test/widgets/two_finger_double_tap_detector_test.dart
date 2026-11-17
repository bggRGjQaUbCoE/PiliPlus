import 'package:PiliPlus/common/widgets/gesture/two_finger_double_tap_detector.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int count;
  late TwoFingerDoubleTapDetector detector;

  setUp(() {
    count = 0;
    detector = TwoFingerDoubleTapDetector(onDoubleTap: () => count++);
  });

  tearDown(() => detector.dispose());

  void twoFingerTap({
    Duration start = Duration.zero,
    Offset center = const Offset(100, 100),
    Offset secondOffset = const Offset(30, 0),
  }) {
    final secondCenter = center + secondOffset;
    detector
      ..onPointerDown(
        PointerDownEvent(pointer: 1, position: center, timeStamp: start),
      )
      ..onPointerDown(
        PointerDownEvent(
          pointer: 2,
          position: secondCenter,
          timeStamp: start + const Duration(milliseconds: 30),
        ),
      )
      ..onPointerUp(
        PointerUpEvent(
          pointer: 1,
          position: center,
          timeStamp: start + const Duration(milliseconds: 80),
        ),
      )
      ..onPointerUp(
        PointerUpEvent(
          pointer: 2,
          position: secondCenter,
          timeStamp: start + const Duration(milliseconds: 100),
        ),
      );
  }

  testWidgets('双指双击触发一次', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 200));
    expect(count, 1);
  });

  testWidgets('单指双击不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 2; i++) {
      final start = Duration(milliseconds: i * 200);
      detector
        ..onPointerDown(
          PointerDownEvent(
            pointer: 1,
            position: const Offset(100, 100),
            timeStamp: start,
          ),
        )
        ..onPointerUp(
          PointerUpEvent(
            pointer: 1,
            position: const Offset(100, 100),
            timeStamp: start + const Duration(milliseconds: 80),
          ),
        );
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(count, 0);
  });

  testWidgets('双指单击不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    await tester.pump(const Duration(milliseconds: 600));
    expect(count, 0);
  });

  testWidgets('第二次双指点击距离过远不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(
      start: const Duration(milliseconds: 200),
      center: const Offset(300, 300),
    );
    expect(count, 0);
  });

  testWidgets('第二次双指点击超时不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    await tester.pump(const Duration(milliseconds: 600));
    twoFingerTap(start: const Duration(milliseconds: 700));
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('三指不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    for (final pointer in [1, 2, 3]) {
      detector.onPointerDown(
        PointerDownEvent(
          pointer: pointer,
          position: Offset(100.0 + pointer * 20, 100),
          timeStamp: Duration(milliseconds: pointer * 10),
        ),
      );
    }
    for (final pointer in [1, 2, 3]) {
      detector.onPointerUp(
        PointerUpEvent(
          pointer: pointer,
          position: Offset(100.0 + pointer * 20, 100),
          timeStamp: Duration(milliseconds: 100 + pointer * 10),
        ),
      );
    }
    expect(count, 0);
  });

  testWidgets('第二根手指距离等于阈值仍触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap(secondOffset: const Offset(300, 0));
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(
      start: const Duration(milliseconds: 200),
      secondOffset: const Offset(300, 0),
    );
    expect(count, 1);
  });

  testWidgets('第二根手指距离超过阈值不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap(secondOffset: const Offset(301, 0));
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(
      start: const Duration(milliseconds: 200),
      secondOffset: const Offset(301, 0),
    );
    expect(count, 0);
  });

  testWidgets('第二根手指落下间隔超过阈值不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    detector
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration.zero,
        ),
      )
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 251),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration(milliseconds: 300),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 320),
        ),
      );
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 400));
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('双指按住超过最长时间不算点击', (tester) async {
    await tester.pumpWidget(const SizedBox());
    detector
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration.zero,
        ),
      )
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 30),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration(milliseconds: 600),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 620),
        ),
      );
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 700));
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('pointer id 复用仍能识别双指双击', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 200));
    expect(count, 1);
    // 超出双击窗口后复用同样的 pointer id，重新作为第一次点击。
    await tester.pump(const Duration(milliseconds: 600));
    twoFingerTap(start: const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 1100));
    expect(count, 2);
  });

  testWidgets('双指点击中一根手指被取消，不残留第一次点击', (tester) async {
    await tester.pumpWidget(const SizedBox());
    detector
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration.zero,
        ),
      )
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 30),
        ),
      )
      ..onPointerCancel(
        const PointerCancelEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration(milliseconds: 60),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 100),
        ),
      );
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 200));
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('第一次点击的超时计时器不会清空第二次点击', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap(); // 第一次点击完成，计时器在 500ms 后触发
    await tester.pump(const Duration(milliseconds: 450));
    // 第二次点击在计时器触发前按下，抬起时已超过 500ms。
    detector
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration(milliseconds: 450),
        ),
      )
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 480),
        ),
      );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    detector
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 1,
          position: Offset(100, 100),
          timeStamp: Duration(milliseconds: 650),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 2,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 670),
        ),
      );
    expect(count, 1);
  });

  testWidgets('快速双指缩放不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    void pinch({required Duration start}) {
      detector
        ..onPointerDown(
          PointerDownEvent(
            pointer: 1,
            position: const Offset(100, 100),
            timeStamp: start,
          ),
        )
        ..onPointerDown(
          PointerDownEvent(
            pointer: 2,
            position: const Offset(200, 100),
            timeStamp: start + const Duration(milliseconds: 30),
          ),
        )
        ..onPointerUp(
          PointerUpEvent(
            pointer: 1,
            position: const Offset(60, 100),
            timeStamp: start + const Duration(milliseconds: 120),
          ),
        )
        ..onPointerUp(
          PointerUpEvent(
            pointer: 2,
            position: const Offset(240, 100),
            timeStamp: start + const Duration(milliseconds: 140),
          ),
        );
    }

    pinch(start: Duration.zero);
    await tester.pump(const Duration(milliseconds: 100));
    pinch(start: const Duration(milliseconds: 200));
    expect(count, 0);
  });

  testWidgets('三指按下后补按两根手指不触发', (tester) async {
    await tester.pumpWidget(const SizedBox());
    for (final pointer in [1, 2, 3]) {
      detector.onPointerDown(
        PointerDownEvent(
          pointer: pointer,
          position: Offset(100.0 + pointer * 20, 100),
          timeStamp: Duration(milliseconds: pointer * 10),
        ),
      );
    }
    for (final pointer in [2, 3]) {
      detector.onPointerUp(
        PointerUpEvent(
          pointer: pointer,
          position: Offset(100.0 + pointer * 20, 100),
          timeStamp: Duration(milliseconds: 100 + pointer * 10),
        ),
      );
    }
    // 第一根手指仍按下时补按两根手指。
    detector
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 4,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 150),
        ),
      )
      ..onPointerDown(
        const PointerDownEvent(
          pointer: 5,
          position: Offset(160, 100),
          timeStamp: Duration(milliseconds: 180),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 1,
          position: Offset(120, 100),
          timeStamp: Duration(milliseconds: 200),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 4,
          position: Offset(130, 100),
          timeStamp: Duration(milliseconds: 220),
        ),
      )
      ..onPointerUp(
        const PointerUpEvent(
          pointer: 5,
          position: Offset(160, 100),
          timeStamp: Duration(milliseconds: 240),
        ),
      );
    await tester.pump(const Duration(milliseconds: 100));
    twoFingerTap(start: const Duration(milliseconds: 300));
    expect(count, 0);
    await tester.pump(const Duration(milliseconds: 600));
  });

  testWidgets('dispose 后不留下待触发的计时器', (tester) async {
    await tester.pumpWidget(const SizedBox());
    twoFingerTap();
    detector.dispose();
    await tester.pump(const Duration(milliseconds: 600));
    expect(count, 0);
  });
}
