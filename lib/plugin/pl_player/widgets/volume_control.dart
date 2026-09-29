import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/flutter/vertical_slider.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox, BoxHitTestResult;
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

/// 桌面底部控制栏音量控件：
/// 默认只显示音量按钮；点击后在按钮**正上方**展开竖直音量滑块，再次点击收起；
/// 右键按钮静音 / 取消静音（同步 isMuted，与 M 键行为保持一致）。
class VolumeControl extends StatefulWidget {
  const VolumeControl({
    super.key,
    required this.plPlayerController,
    required this.width,
  });

  final PlPlayerController plPlayerController;
  final double width;

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  final OverlayPortalController _controller = OverlayPortalController();
  double _lastVolume = 1.0;

  void _togglePanel() {
    if (_controller.isShowing) {
      _controller.hide();
    } else {
      _controller.show();
    }
    setState(() {});
  }

  void _toggleMute() {
    final ctr = widget.plPlayerController;
    final volume = ctr.volume.value;
    if (volume > 0) {
      _lastVolume = volume;
      ctr
        ..setVolume(0)
        ..isMuted = true;
    } else {
      ctr
        ..setVolume(_lastVolume > 0 ? _lastVolume : 1.0)
        ..isMuted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctr = widget.plPlayerController;
    return OverlayPortal.overlayChildLayoutBuilder(
      controller: _controller,
      overlayChildBuilder: (context, info) {
        final offset = MatrixUtils.transformPoint(
          info.childPaintTransform,
          info.childSize.topCenter(const Offset(0, -6)),
        );
        return _VolumePanel(
          offset: offset,
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
            decoration: const BoxDecoration(
              color: Color(0xE6202020),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Obx(
              () {
                final volume = ctr.volume.value;
                return Column(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(volume * 100).round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: VerticalSlider(
                        year2023: true,
                        min: 0.0,
                        max: ctr.maxVolume,
                        value: volume.clamp(0.0, ctr.maxVolume).toDouble(),
                        showValueIndicator: .never,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white38,
                        onChanged: (value) {
                          ctr
                            ..setVolume(value)
                            ..isMuted = value == 0;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
      child: Obx(
        () {
          final volume = ctr.volume.value;
          return ComBtn(
            width: widget.width,
            height: 30,
            tooltip: _controller.isShowing ? '收起音量（右键静音）' : '音量（右键静音）',
            icon: Icon(
              volume <= 0
                  ? Icons.volume_off
                  : volume / ctr.maxVolume < 0.5
                  ? Icons.volume_down
                  : Icons.volume_up,
              size: 24,
              color: Colors.white,
            ),
            onTap: _togglePanel,
            onSecondaryTap: _toggleMute,
          );
        },
      ),
    );
  }
}

/// 把 overlay 子节点平移到锚点正上方（与音频页音量条同一实现）
class _VolumePanel extends SingleChildRenderObjectWidget {
  const _VolumePanel({
    required this.offset,
    required Widget super.child,
  });

  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderVolumePanel(offset: offset);
  }
}

class _RenderVolumePanel extends RenderProxyBox {
  _RenderVolumePanel({required this.offset});

  final Offset offset;
  late Offset _offset;

  @override
  void performLayout() {
    final childSize =
        (child!..layout(
              const BoxConstraints(maxWidth: 40, maxHeight: 170),
              parentUsesSize: true,
            ))
            .size;
    size = constraints.biggest;
    _offset = Offset(
      math.min(offset.dx - (childSize.width / 2), size.width - childSize.width),
      math.min(offset.dy, size.height) - childSize.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, _offset);
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return result.addWithPaintOffset(
      offset: _offset,
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        assert(transformed == position - _offset);
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  @override
  void applyPaintTransform(covariant RenderObject child, Matrix4 transform) {
    transform.translateByDouble(_offset.dx, _offset.dy, 0.0, 1.0);
  }
}
