import 'dart:ui' show Offset, Rect, Size;

import 'package:PiliPlus/utils/desktop/window_bounds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nativeapi/nativeapi.dart' as nativeapi;

void main() {
  group('fitWindowSizeToWorkArea', () {
    test('小屏 1024×640：默认 1180×720 收敛到工作区', () {
      expect(
        fitWindowSizeToWorkArea(
          const Size(1180, 720),
          const Rect.fromLTWH(0, 0, 1024, 640),
        ),
        const Size(1024, 640),
      );
    });

    test('1080p 1x：默认窗口尺寸不受影响', () {
      expect(
        fitWindowSizeToWorkArea(
          const Size(1180, 720),
          const Rect.fromLTWH(0, 0, 1920, 1080),
        ),
        const Size(1180, 720),
      );
    });
  });

  group('fitMinSizeToWorkArea', () {
    test('小屏 1024×640：最小高度不再超过屏幕', () {
      expect(
        fitMinSizeToWorkArea(
          const nativeapi.Size(width: 400, height: 720),
          const Rect.fromLTWH(0, 0, 1024, 640),
        ),
        const nativeapi.Size(width: 400, height: 640),
      );
    });

    test('1080p 1x：最小尺寸保持 400×720', () {
      expect(
        fitMinSizeToWorkArea(
          const nativeapi.Size(width: 400, height: 720),
          const Rect.fromLTWH(0, 0, 1920, 1080),
        ),
        const nativeapi.Size(width: 400, height: 720),
      );
    });
  });

  group('calcWindowOffset', () {
    test('小屏上窗口正好铺满工作区', () {
      expect(
        calcWindowOffset(
          windowSize: const Size(1024, 640),
          workArea: const Rect.fromLTWH(0, 0, 1024, 640),
        ),
        Offset.zero,
      );
    });

    test('1080p 1x：窗口居中', () {
      expect(
        calcWindowOffset(
          windowSize: const Size(1180, 720),
          workArea: const Rect.fromLTWH(0, 0, 1920, 1080),
        ),
        const Offset(370, 180),
      );
    });

    test('保存的位置仍可见时保持不动', () {
      expect(
        calcWindowOffset(
          windowSize: const Size(1180, 720),
          workArea: const Rect.fromLTWH(0, 0, 1920, 1080),
          savedPosition: const Offset(100, 120),
        ),
        const Offset(100, 120),
      );
    });

    test('保存的位置完全不在工作区时重新居中', () {
      expect(
        calcWindowOffset(
          windowSize: const Size(1180, 720),
          workArea: const Rect.fromLTWH(1920, 0, 1920, 1080),
          savedPosition: Offset.zero,
        ),
        const Offset(2290, 180),
      );
    });

    test('保存的位置部分越界时拉回工作区', () {
      expect(
        calcWindowOffset(
          windowSize: const Size(1180, 720),
          workArea: const Rect.fromLTWH(0, 0, 1920, 1080),
          savedPosition: const Offset(1500, 900),
        ),
        const Offset(740, 360),
      );
    });
  });
}
