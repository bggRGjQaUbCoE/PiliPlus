import 'package:PiliPlus/l10n/l10n.dart';

const double kScreenRatio = 1.2;

// 全屏模式
enum FullScreenMode {
  // 根据内容自适应
  auto,
  // 不改变当前方向
  none,
  // 始终竖屏
  vertical,
  // 始终横屏
  horizontal,
  // 屏幕长宽比 < kScreenRatio 或为竖屏视频时竖屏，否则横屏
  ratio,
  // 强制重力转屏（仅安卓）
  gravity,
  ;

  String get desc => switch (this) {
    auto => L10n.current.fullScreenModeAutoDesc,
    none => L10n.current.fullScreenModeNoneDesc,
    vertical => L10n.current.fullScreenModeVerticalDesc,
    horizontal => L10n.current.fullScreenModeHorizontalDesc,
    ratio => L10n.current.fullscreenRatioDescription(kScreenRatio),
    gravity => L10n.current.fullScreenModeGravityDesc,
  };
}
