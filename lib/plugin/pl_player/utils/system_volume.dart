/// 查询不到系统级数时的兜底值（AOSP 的 STREAM_MUSIC 默认 15 级）
const int kFallbackVolumeSteps = 15;

/// 第 [index] 级系统音量在界面上显示成多少百分比
///
/// 系统刻度通常除不尽，这里一律向上取整：15 级系统的第 10 级是 66.6…%，
/// 显示（同时也是滑动时的判定点）就是 67%。
int volumeStepLabel(int index, int steps) {
  if (steps <= 0) return 0;
  // 减一点再向上取整，避免 30 级系统里 3/30 算成 10.000000000000002 后变成 11
  return (index * 100 / steps - 1e-9).ceil();
}

/// 连续音量 [percent]（0~100）落在系统的第几级
///
/// 每一级的判定点就是这一级显示的百分比：15 级系统里第 10 级标 67%，
/// 连续音量到 67% 就切到这一级（系统音量设成 10/15，界面显示 67%）；
/// 往回到 66% 就退回第 9 级。
int resolveVolumeIndex({required double percent, required int steps}) {
  if (steps <= 0) return 0;
  // 判定点是整数百分比，等于「连续音量的整数部分 × 级数 / 100」下取整
  final level = (percent + 1e-9).floor().clamp(0, 100);
  final index = level * steps ~/ 100;
  return index > steps ? steps : index;
}

/// 第 [index] 级刻度的滑动起点
///
/// 起点放在这一级和下一级刻度的正中并向上取整，往上滑到下一级、往下滑回本级
/// 各约半级行程（取整会让两个方向差出不到 1 个百分点）：15 级系统的第 10 级
/// （66.6…%）起点是 70%，滑到 74% 升一级、滑到 67% 以下降一级。最高一级往上
/// 一级是 106.6…% 那一档，起点自然落在 104%，下划同样要半级行程才降级。
double volumeAnchorForIndex(int index, int steps) {
  if (steps <= 0) return index.toDouble();
  return ((index + 0.5) * 100 / steps - 1e-9).ceil() / 100;
}

/// 滑动开始的连续音量起点：系统当前刻度对应的起点
double volumeAnchor({required double volume, required int steps}) {
  if (steps <= 0) return volume;
  return volumeAnchorForIndex((volume * steps).round(), steps);
}
