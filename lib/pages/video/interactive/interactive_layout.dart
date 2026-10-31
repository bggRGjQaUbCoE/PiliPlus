import 'dart:ui' show Rect;

/// 互动浮层的布局参数。
///
/// 播放器控件（顶部按钮行、底部进度条+按钮行）会随 [PlPlayerController.showControls]
/// 滑入滑出，互动浮层必须跟着让位，否则会盖住控件或被控件盖住。
/// 这里的数值与 `AppBarAni`（顶部 12 内边距 + 34 按钮高）和
/// `BottomControl`（12 内边距 + 进度条 ≈ 11 + 按钮行 30）保持一致。

/// 顶部控件行（返回 / 返回主页 / 标题 / 图标）大致占用的高度。
const double kHeaderBarHeight = 58;

/// 顶部「返回」+「返回主页」两个按钮占用的宽度（2 × 42）。
const double kHeaderButtonsWidth = 84;

/// 底部控件条（进度条 + 底部按钮行，含内边距）大致占用的高度。
const double kControlsBarHeight = 58;

/// 控件显隐动画时长，与播放器 `AppBarAni` 的 100ms 保持同量级。
const Duration kOverlayFollowDuration = Duration(milliseconds: 150);

/// 进度回溯入口的左边距。
///
/// 控件可见时顶部会显示「返回 / 返回主页」按钮，入口必须右移让开，
/// 否则会挡住返回按钮（用户反馈 issue）。
double backtrackEntryLeft({required bool controlsVisible}) =>
    controlsVisible ? kHeaderButtonsWidth + 12 : 10;

/// 倒计时浮层的顶部偏移：控件可见时下移到头部按钮行之下。
double countdownChipTop({required bool controlsVisible}) =>
    controlsVisible ? kHeaderBarHeight : 12;

/// 底部选项的 bottom 偏移。
///
/// 基准位置是视频画面底边之上 [fraction] 比例处；播放控件可见时再上移
/// [kControlsBarHeight]，让选项停在进度条上方（官方行为：选项随控件显隐移动）。
double bottomChoicesOffset({
  required double areaHeight,
  required Rect videoRect,
  required bool controlsVisible,
  double fraction = 0.045,
}) {
  final double base =
      areaHeight - videoRect.bottom + videoRect.height * fraction;
  return controlsVisible ? base + kControlsBarHeight : base;
}
