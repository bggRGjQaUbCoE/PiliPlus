import 'package:PiliPlus/pages/danmaku/mask/controller.dart';
import 'package:PiliPlus/pages/danmaku/mask/geometry.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

typedef DanmakuMaskInputs = ({Size videoSize, Matrix4 videoToLayer});

/// 把遮罩帧映射为弹幕层遮挡区，只在输入变化时重算并写入 [output]。
/// 生命周期由持有者（_PLVideoPlayerState）管理：持有者负责把 [update]
/// 挂到各触发源，并在 dispose 时先解绑再 [detach]。
final class DanmakuMaskClipDriver {
  DanmakuMaskClipDriver({
    required this.frame,
    required this.output,
    required this.readInputs,
  });

  final ValueListenable<DanmakuMaskFrame?> frame;
  final ValueNotifier<Path?> output;

  /// 返回 null 表示此刻不应 / 无法计算（PiP、视频未就绪、尺寸退化）。
  /// 必须每次返回新组合出来的 Matrix4，不能直接返回 TransformationController 的矩阵对象，
  /// 否则原地修改会骗过下面的值比较。
  final DanmakuMaskInputs? Function() readInputs;

  DanmakuMaskFrame? _lastFrame;
  DanmakuMaskInputs? _lastInputs;
  bool _detached = false;

  void update() {
    if (_detached) return;
    final current = frame.value;
    final inputs = current == null ? null : readInputs();
    if (current == null || inputs == null) {
      _lastFrame = null;
      _lastInputs = null;
      output.value = null; // 已是 null 时 ValueNotifier 不通知
      return;
    }
    final last = _lastInputs;
    if (identical(current, _lastFrame) &&
        last != null &&
        last.videoSize == inputs.videoSize &&
        last.videoToLayer == inputs.videoToLayer) {
      return; // Matrix4 == 是逐元素值比较
    }
    _lastFrame = current;
    _lastInputs = inputs;
    output.value = DanmakuMaskGeometry.maskInLayer(
      frame: current,
      videoSize: inputs.videoSize,
      videoToLayer: inputs.videoToLayer,
    );
  }

  /// 解绑后不再写 output。**不**清空 output：新旧播放器视图生命周期可能重叠，
  /// 新视图首次 update 会覆盖。
  void detach() => _detached = true;
}
