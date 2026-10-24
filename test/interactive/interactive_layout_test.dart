import 'dart:ui' show Rect, Size;

import 'package:PiliPlus/pages/video/interactive/interactive_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('互动浮层跟随播放控件', () {
    test('底部选项：控件收起时贴近视频底边', () {
      final Rect videoRect = Offset.zero & const Size(800, 450);
      final double offset = bottomChoicesOffset(
        areaHeight: 450,
        videoRect: videoRect,
        controlsVisible: false,
      );
      expect(offset, closeTo(450 * 0.045, 0.01));
    });

    test('底部选项：控件展开时上移让开进度条', () {
      final Rect videoRect = Offset.zero & const Size(800, 450);
      final double hidden = bottomChoicesOffset(
        areaHeight: 450,
        videoRect: videoRect,
        controlsVisible: false,
      );
      final double shown = bottomChoicesOffset(
        areaHeight: 450,
        videoRect: videoRect,
        controlsVisible: true,
      );
      expect(shown - hidden, kControlsBarHeight);
      expect(shown, greaterThan(kControlsBarHeight));
    });

    test('底部选项：黑边（画面未填满）也按控件让位', () {
      // 画面 16:9 放在更高区域里，上下有黑边。
      const Rect videoRect = Rect.fromLTWH(0, 100, 800, 450);
      final double base = bottomChoicesOffset(
        areaHeight: 650,
        videoRect: videoRect,
        controlsVisible: false,
      );
      expect(base, closeTo(100 + 450 * 0.045, 0.01));
      expect(
        bottomChoicesOffset(
          areaHeight: 650,
          videoRect: videoRect,
          controlsVisible: true,
        ),
        closeTo(base + kControlsBarHeight, 0.01),
      );
    });

    test('进度回溯入口：控件展开时让开「返回 / 返回主页」按钮', () {
      expect(backtrackEntryLeft(controlsVisible: false), 10);
      final double shown = backtrackEntryLeft(controlsVisible: true);
      expect(shown, greaterThanOrEqualTo(kHeaderButtonsWidth));
      expect(shown, greaterThan(backtrackEntryLeft(controlsVisible: false)));
    });

    test('倒计时浮层：控件展开时下移到头部按钮行之下', () {
      expect(countdownChipTop(controlsVisible: false), 12);
      expect(countdownChipTop(controlsVisible: true), kHeaderBarHeight);
    });
  });
}
