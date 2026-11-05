import 'dart:math' as math;
import 'dart:ui' show Offset, Rect, Size;

import 'package:nativeapi/nativeapi.dart' as nativeapi;

/// 判定上次保存的窗口位置是否还有效时，要求至少有多少像素留在工作区内
const double kWindowKeepVisible = 30.0;

/// 窗口尺寸不得超过工作区，避免恢复出一个比屏幕还大的窗口
Size fitWindowSizeToWorkArea(Size windowSize, Rect workArea) => Size(
  math.min(windowSize.width, workArea.width),
  math.min(windowSize.height, workArea.height),
);

/// 最小窗口尺寸不得超过工作区，否则小屏（如 1024×640）上窗口无法收缩到屏幕内
nativeapi.Size fitMinSizeToWorkArea(nativeapi.Size minSize, Rect workArea) =>
    nativeapi.Size(
      width: math.min(minSize.width, workArea.width),
      height: math.min(minSize.height, workArea.height),
    );

/// 计算窗口左上角坐标。
///
/// [savedPosition] 是上次退出时的位置：已经完全不在工作区内（换了显示器、
/// 换了分辨率）时重新居中；仍然可见时留在原处，但会被拉回工作区内。
Offset calcWindowOffset({
  required Size windowSize,
  required Rect workArea,
  Offset? savedPosition,
}) {
  if (savedPosition != null) {
    final dx = savedPosition.dx;
    final dy = savedPosition.dy;
    if (dx > workArea.left + kWindowKeepVisible &&
        dy > workArea.top + kWindowKeepVisible &&
        dx < workArea.right - kWindowKeepVisible &&
        dy < workArea.bottom - kWindowKeepVisible) {
      return Offset(dx, dy);
    }
  }

  return Offset(
    workArea.left + (workArea.width - windowSize.width) / 2,
    workArea.top + (workArea.height - windowSize.height) / 2,
  );
}
