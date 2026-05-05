import 'dart:async' show Timer;
import 'dart:math' as math;

import 'package:PiliPlus/common/widgets/flutter/vertical_slider.dart';
import 'package:PiliPlus/pages/audio/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox, BoxHitTestResult;
import 'package:get/get.dart';

class VolumeButton extends StatefulWidget {
  const VolumeButton({
    super.key,
    required this.controller,
  });

  final AudioController controller;

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  final _controller = OverlayPortalController();
  Timer? _timer;
  late CardThemeData cardTheme;
  late ColorScheme theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = ColorScheme.of(context);
    cardTheme = CardTheme.of(context);
  }

  void _stopTimer([_]) {
    _timer?.cancel();
    _timer = null;
  }

  void _show([_]) {
    _stopTimer();
    _controller.show();
  }

  void _scheduleDismiss([_]) {
    _timer ??= Timer(const Duration(milliseconds: 100), () {
      _controller.hide();
      _timer = null;
    });
  }

  @override
  void dispose() {
    _stopTimer();
    if (_controller.isShowing) {
      _controller.hide();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _show,
      onExit: _scheduleDismiss,
      cursor: SystemMouseCursors.click,
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: _controller,
        overlayChildBuilder: _overlayChildBuilder,
        child: Obx(() {
          final volume = widget.controller.desktopVolume.value;
          return InkWell(
            onTapUp: _onTapUp,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const .all(10.0),
              child: Icon(
                volume == 0.0
                    ? Icons.volume_off
                    : volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
                color: theme.onSurfaceVariant,
                size: 22.0,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _overlayChildBuilder(
    BuildContext context,
    OverlayChildLayoutInfo info,
  ) {
    final offset = MatrixUtils.transformPoint(
      info.childPaintTransform,
      info.childSize.topCenter(const Offset(0, -6)),
    );
    return _volumeSlider(offset);
  }

  Widget _volumeSlider(Offset offset) {
    return _VolumeWidget(
      offset: offset,
      child: MouseRegion(
        onEnter: _stopTimer,
        onExit: _scheduleDismiss,
        child: Container(
          padding: const .fromLTRB(6, 8, 6, 2),
          decoration: BoxDecoration(
            color: ElevationOverlay.applySurfaceTint(
              cardTheme.color ?? theme.surfaceContainerLow,
              cardTheme.surfaceTintColor,
              2,
            ),
            borderRadius: const .all(.circular(6)),
          ),
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 4,
              overlayColor: Colors.transparent,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6,
              ),
            ),
            child: Obx(
              () {
                final volume = widget.controller.desktopVolume.value;
                return Column(
                  spacing: 2,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      '${(volume * 100).round()}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Expanded(
                      child: VerticalSlider(
                        year2023: true,
                        min: 0.0,
                        max: 2.0,
                        value: volume,
                        showValueIndicator: .never,
                        onChanged: widget.controller.setVolume,
                        onChangeEnd: widget.controller.syncVolume,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details) {
    switch (details.kind) {
      case .mouse:
        widget.controller.toggleVolume();
      case _:
        _showVolumeDialog();
    }
  }

  void _showVolumeDialog() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(
      renderBox.size.topCenter(const Offset(0, -6)),
    );
    Get.key.currentState!.push(
      DialogRoute(
        context: context,
        useSafeArea: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          return _volumeSlider(offset);
        },
      ),
    );
  }
}

class _VolumeWidget extends SingleChildRenderObjectWidget {
  const _VolumeWidget({
    required this.offset,
    required Widget super.child,
  });

  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderVolumeWidget(offset: offset);
  }
}

class _RenderVolumeWidget extends RenderProxyBox {
  _RenderVolumeWidget({required this.offset});

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
