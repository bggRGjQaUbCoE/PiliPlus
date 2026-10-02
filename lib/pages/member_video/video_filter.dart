import 'package:PiliPlus/models_new/space/space_archive/item.dart';
import 'package:material_ui/material_ui.dart' show RangeValues;

// 用户空间视频列表的客户端本地过滤条件
class MemberVideoFilter {
  // 滑块上界，=500万；同时也是「不限制上限」的端点语义值。
  static const int playSliderMax = 5000000;

  bool enableMinPlay = false;
  int minPlay = 0;
  bool enableMaxPlay = false;
  int maxPlay = playSliderMax;
  bool hideCompleted = false;
  bool hideInProgress = false;

  bool get hasActiveFilter =>
      enableMinPlay || enableMaxPlay || hideCompleted || hideInProgress;

  // 已看完：history 存在且进度数据完整、progress == duration
  static bool isCompleted(SpaceArchiveItem item) {
    final history = item.history;
    final progress = history?.progress;
    final duration = history?.duration;
    return history != null &&
        progress != null &&
        duration != null &&
        progress == duration;
  }

  // 看过未看完：history 存在且进度数据完整、progress != duration
  static bool isInProgress(SpaceArchiveItem item) {
    final history = item.history;
    final progress = history?.progress;
    final duration = history?.duration;
    return history != null &&
        progress != null &&
        duration != null &&
        progress != duration;
  }

  bool shouldHide(SpaceArchiveItem item) {
    if (enableMinPlay) {
      final view = item.stat.view;
      if (view != null && view < minPlay) {
        return true;
      }
    }
    if (enableMaxPlay) {
      final view = item.stat.view;
      if (view != null && view > maxPlay) {
        return true;
      }
    }
    if (hideCompleted && isCompleted(item)) {
      return true;
    }
    if (hideInProgress && isInProgress(item)) {
      return true;
    }
    return false;
  }

  // 由当前过滤条件得到滑块草稿端点（double，原始整数刻度）。
  // 未启用端点时取端点语义值：最小→0（不限制下限），最大→playSliderMax（不限制上限）。
  RangeValues toSliderValues() => RangeValues(
        enableMinPlay ? minPlay.toDouble() : 0.0,
        enableMaxPlay ? maxPlay.toDouble() : playSliderMax.toDouble(),
      );

  // 把滑块草稿写回过滤条件：端点语义值 → 不启用对应阈值，中间值 → 启用并取整。
  void applySliderValues(RangeValues values) {
    final start = values.start.round();
    final end = values.end.round();
    if (start <= 0) {
      enableMinPlay = false;
    } else {
      enableMinPlay = true;
      minPlay = start;
    }
    if (end >= playSliderMax) {
      enableMaxPlay = false;
    } else {
      enableMaxPlay = true;
      maxPlay = end;
    }
  }

  void reset() {
    enableMinPlay = false;
    enableMaxPlay = false;
    hideCompleted = false;
    hideInProgress = false;
  }
}
