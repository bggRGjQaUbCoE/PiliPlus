import 'package:PiliPlus/pages/danmaku/mask/clip_driver.dart';
import 'package:PiliPlus/pages/danmaku/mask/controller.dart';
import 'package:PiliPlus/pages/danmaku/mask/geometry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 与 RenderFittedBox 对拍：同样的 fit / alignment / 尺寸，公式必须逐元素一致
void _expectMatrixClose(Matrix4 actual, Matrix4 expected) {
  for (var i = 0; i < 16; i++) {
    expect(
      actual.storage[i],
      closeTo(expected.storage[i], 1e-9),
      reason: 'storage[$i]',
    );
  }
}

DanmakuMaskFrame _frame({Rect viewBox = const Rect.fromLTWH(0, 0, 320, 180)}) {
  return DanmakuMaskFrame(
    viewBox: viewBox,
    blockedPath: Path()..addRect(const Rect.fromLTWH(10, 20, 40, 40)),
  );
}

void main() {
  group('fittedBoxTransform 与 RenderFittedBox 对拍', () {
    const boxSize = Size(400, 300);
    const childSize = Size(160, 90);
    final alignments = <Alignment>[
      Alignment.center,
      Alignment.topLeft,
      Alignment.bottomRight,
      const Alignment(0.3, -0.7),
    ];

    for (final fit in BoxFit.values) {
      for (final alignment in alignments) {
        testWidgets('$fit / $alignment', (tester) async {
          final boxKey = GlobalKey();
          final childKey = GlobalKey();
          await tester.pumpWidget(
            MaterialApp(
              home: Center(
                child: SizedBox(
                  key: boxKey,
                  width: boxSize.width,
                  height: boxSize.height,
                  child: FittedBox(
                    fit: fit,
                    alignment: alignment,
                    child: SizedBox(
                      key: childKey,
                      width: childSize.width,
                      height: childSize.height,
                    ),
                  ),
                ),
              ),
            ),
          );

          final childRender =
              tester.renderObject<RenderBox>(find.byKey(childKey));
          final boxRender = tester.renderObject<RenderBox>(find.byKey(boxKey));
          final reference = childRender.getTransformTo(boxRender);

          final actual = DanmakuMaskGeometry.fittedBoxTransform(
            fit: fit,
            alignment: alignment,
            childSize: childSize,
            boxSize: boxSize,
          );
          expect(actual, isNotNull);
          _expectMatrixClose(actual!, reference);
        });
      }
    }
  });

  group('maskInLayer', () {
    test('contain 恒等：仅剩弹幕层的 4px 下沿偏移', () {
      final path = DanmakuMaskGeometry.maskInLayer(
        frame: _frame(),
        videoSize: const Size(1920, 1080),
        videoToLayer: Matrix4.translationValues(0, -4, 0),
      );
      expect(path, isNotNull);
      final bounds = path!.getBounds();
      expect(bounds.left, closeTo(60, 1e-6));
      expect(bounds.top, closeTo(116, 1e-6));
      expect(bounds.right, closeTo(300, 1e-6));
      expect(bounds.bottom, closeTo(356, 1e-6));
    });

    test('letterbox：黑边不裁、画面内容整体下移「居中量 − 4」', () {
      const viewport = Size(1920, 1440);
      final fit = DanmakuMaskGeometry.fittedBoxTransform(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        childSize: const Size(1920, 1080),
        boxSize: viewport,
      )!;
      final videoToLayer = Matrix4.translationValues(0, -4, 0)..multiply(fit);
      final path = DanmakuMaskGeometry.maskInLayer(
        frame: _frame(),
        videoSize: const Size(1920, 1080),
        videoToLayer: videoToLayer,
      )!;
      final bounds = path.getBounds();
      // 与 contain 恒等相比，画面整体下移 letterbox 居中量 180；弹幕层再上移 4
      expect(bounds.top, closeTo(296, 1e-6));
      expect(bounds.bottom, closeTo(536, 1e-6));
      expect(bounds.left, closeTo(60, 1e-6));
      expect(bounds.right, closeTo(300, 1e-6));
      // 遮挡区落在画面纵向区间 [176, 1256] 内，黑条上不会被误挡
      expect(bounds.top, greaterThan(176));
      expect(bounds.bottom, lessThan(1256));
    });

    test('flipX：遮挡区随画面一起镜像', () {
      const viewport = Size(1920, 1440);
      final videoToLayer = Matrix4.translationValues(0, -4, 0)
        ..multiply(
          DanmakuMaskGeometry.flipTransform(
            flipX: true,
            flipY: false,
            boxSize: viewport,
          ),
        );
      final path = DanmakuMaskGeometry.maskInLayer(
        frame: _frame(),
        videoSize: const Size(1920, 1080),
        videoToLayer: videoToLayer,
      )!;
      final bounds = path.getBounds();
      // 未翻转时 x ∈ [60, 300]，翻转过中心 960 后 → 1920 − x
      expect(bounds.left, closeTo(1620, 1e-6));
      expect(bounds.right, closeTo(1860, 1e-6));
    });

    test('2 倍缩放：遮挡区坐标翻倍', () {
      final videoToLayer = Matrix4.diagonal3Values(2, 2, 1);
      final path = DanmakuMaskGeometry.maskInLayer(
        frame: _frame(),
        videoSize: const Size(320, 180),
        videoToLayer: videoToLayer,
      )!;
      final bounds = path.getBounds();
      expect(bounds.left, closeTo(20, 1e-6));
      expect(bounds.top, closeTo(40, 1e-6));
      expect(bounds.right, closeTo(100, 1e-6));
      expect(bounds.bottom, closeTo(120, 1e-6));
    });

    test('退化输入返回 null（fail open）', () {
      expect(
        DanmakuMaskGeometry.maskInLayer(
          frame: _frame(),
          videoSize: Size.zero,
          videoToLayer: Matrix4.identity(),
        ),
        isNull,
      );
      expect(
        DanmakuMaskGeometry.maskInLayer(
          frame: _frame(viewBox: Rect.zero),
          videoSize: const Size(1920, 1080),
          videoToLayer: Matrix4.identity(),
        ),
        isNull,
      );
      expect(
        DanmakuMaskGeometry.fittedBoxTransform(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          childSize: Size.zero,
          boxSize: const Size(400, 300),
        ),
        isNull,
      );
      expect(
        DanmakuMaskGeometry.fittedBoxTransform(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          childSize: const Size(160, 90),
          boxSize: Size.zero,
        ),
        isNull,
      );
    });
  });

  group('DanmakuMaskClipDriver', () {
    test('同帧同输入不重复推送，矩阵变化才推送', () {
      final frame = ValueNotifier<DanmakuMaskFrame?>(_frame());
      final output = ValueNotifier<Path?>(null);
      var notifications = 0;
      output.addListener(() => notifications++);

      var videoToLayer = Matrix4.identity();
      final driver = DanmakuMaskClipDriver(
        frame: frame,
        output: output,
        readInputs: () =>
            (videoSize: const Size(320, 180), videoToLayer: videoToLayer),
      )..update();
      expect(notifications, 1);
      expect(output.value, isNotNull);

      // 同一帧、同一组输入：去重
      driver
        ..update()
        ..update();
      expect(notifications, 1);

      // 矩阵变化：重算并推送
      videoToLayer = Matrix4.diagonal3Values(2, 2, 1);
      driver.update();
      expect(notifications, 2);

      // 帧置 null：输出清空
      frame.value = null;
      driver.update();
      expect(notifications, 3);
      expect(output.value, isNull);

      // detach 后不再写
      frame.value = _frame();
      driver
        ..detach()
        ..update();
      expect(notifications, 3);
      expect(output.value, isNull);
    });

    test('readInputs 返回 null（PiP / 视频未就绪）时不裁剪', () {
      final frame = ValueNotifier<DanmakuMaskFrame?>(_frame());
      final output = ValueNotifier<Path?>(Path());
      DanmakuMaskClipDriver(
        frame: frame,
        output: output,
        readInputs: () => null,
      ).update();
      expect(output.value, isNull);
    });
  });
}
