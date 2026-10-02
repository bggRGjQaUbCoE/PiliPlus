import 'dart:math';

import 'package:PiliPlus/pages/member_video/video_filter.dart';
import 'package:PiliPlus/utils/extension/context_ext.dart';
import 'package:PiliPlus/utils/num_utils.dart';
import 'package:material_ui/material_ui.dart';

// 用户空间视频列表过滤设置弹窗：触控滑块设置播放量区间 + 显式确认按钮应用。
// 非确认关闭（下滑 / 遮罩 / 返回）撤销草稿，不写回 filter。
abstract final class MemberVideoFilterDialog {
  static Future<void> show(BuildContext context, MemberVideoFilter filter) {
    // 草稿：滑块端点为原始整数刻度（0..playSliderMax），端点值=不限制对应端。
    var draft = filter.toSliderValues();
    var hideCompleted = filter.hideCompleted;
    var hideInProgress = filter.hideInProgress;
    final max = MemberVideoFilter.playSliderMax.toDouble();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxWidth: min(640, context.mediaQueryShortestSide),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String startLabel(double v) =>
              v <= 0 ? '不限' : NumUtils.numFormat(v.round());
          String endLabel(double v) =>
              v >= max ? '不限' : NumUtils.numFormat(v.round());

          // 数字输入：解析万为单位（兼容 10.5万 / 2亿），越界/不限按端点语义处理。
          Future<void> editValue({required bool isMin}) async {
            final current =
                isMin ? draft.start : draft.end;
            final initial = isMin
                ? (current <= 0 ? '' : NumUtils.numFormat(current.round()))
                : (current >= max ? '' : NumUtils.numFormat(current.round()));
            final result = await showDialog<int>(
              context: context,
              builder: (dialogContext) => _NumberInputDialog(
                isMin: isMin,
                initial: initial,
              ),
            );
            if (result == null) return;
            setState(() {
              final clamped = _clampInput(
                value: result.toDouble(),
                isMin: isMin,
                other: isMin ? draft.end : draft.start,
                max: max,
              );
              if (isMin) {
                draft = RangeValues(clamped, draft.end);
              } else {
                draft = RangeValues(draft.start, clamped);
              }
            });
          }

          final hasActiveDraft = draft.start > 0 ||
              draft.end < max ||
              hideCompleted ||
              hideInProgress;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('播放量筛选（万）', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '左拖设最小（低于隐藏），右拖设最大（高于隐藏）；端点 = 不限制',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _PlayLabel(
                        text: startLabel(draft.start),
                        onTap: () => editValue(isMin: true),
                        colorScheme: colorScheme,
                      ),
                      _PlayLabel(
                        text: endLabel(draft.end),
                        onTap: () => editValue(isMin: false),
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: draft,
                    min: 0,
                    max: max,
                    labels: RangeLabels(
                      startLabel(draft.start),
                      endLabel(draft.end),
                    ),
                    onChanged: (v) => setState(() => draft = v),
                  ),
                  const SizedBox(height: 8),
                  const Text('已观看', style: TextStyle(fontSize: 16)),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('隐藏已看完', style: TextStyle(fontSize: 14)),
                    value: hideCompleted,
                    onChanged: (v) =>
                        setState(() => hideCompleted = v),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      '隐藏看过未看完',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: hideInProgress,
                    onChanged: (v) =>
                        setState(() => hideInProgress = v),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasActiveDraft)
                        TextButton(
                          onPressed: () => setState(() {
                            draft = RangeValues(0, max);
                            hideCompleted = false;
                            hideInProgress = false;
                          }),
                          child: const Text('清除所有过滤条件'),
                        )
                      else
                        const SizedBox.shrink(),
                      FilledButton.icon(
                        onPressed: () {
                          filter
                            ..applySliderValues(draft)
                            ..hideCompleted = hideCompleted
                            ..hideInProgress = hideInProgress;
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('确认'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 数字输入钳制：左端不能超过右端，右端不能低于左端；
  // 右端=不限(max)时左端可取任意 >0 值，左端=不限(0)时右端可取任意 <max 值。
  static double _clampInput({
    required double value,
    required bool isMin,
    required double other,
    required double max,
  }) {
    if (isMin) {
      // 左端：超过上界按不限上限；不超过右端则保留，否则钳到右端
      if (value > max) return max;
      return value.clamp(0.0, other);
    } else {
      if (value > max) return max;
      return value.clamp(other, max);
    }
  }
}

// 数字输入弹窗：控制器由本 State 持有，路由退出动画结束卸载时才释放，
// 避免 pop 瞬间 dispose 导致 exit 动画重建 TextField 时 used-after-disposed。
class _NumberInputDialog extends StatefulWidget {
  const _NumberInputDialog({required this.isMin, required this.initial});

  final bool isMin;
  final String initial;

  @override
  State<_NumberInputDialog> createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<_NumberInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 解析万为单位（兼容 10.5万 / 2亿），越界/不限按端点语义处理。
  int _parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty || text == '不限') {
      return widget.isMin ? 0 : MemberVideoFilter.playSliderMax;
    }
    final value = NumUtils.parseNum(text);
    if (value <= 0) {
      return widget.isMin ? 0 : MemberVideoFilter.playSliderMax;
    }
    return min(value, MemberVideoFilter.playSliderMax);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isMin ? '最小播放量' : '最大播放量'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: const InputDecoration(
          hintText: '万为单位，如 10.5万 / 2亿；0 或「不限」表示不限制',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_parse(_controller.text)),
          child: const Text('确定'),
        ),
      ],
    );
  }
}

// 滑块端点的可点击数字标签。
class _PlayLabel extends StatelessWidget {
  const _PlayLabel({
    required this.text,
    required this.onTap,
    required this.colorScheme,
  });

  final String text;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
