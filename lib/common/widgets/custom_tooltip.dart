import 'dart:math' as math;
import 'dart:ui' show clampDouble;

import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum TooltipType { top, right }

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({
    super.key,
    this.type = TooltipType.top,
    required this.overlayWidget,
    required this.child,
    this.indicator,
  });

  final TooltipType type;
  final Widget child;
  final Widget Function() overlayWidget;
  final Widget Function()? indicator;

  static final List<CustomTooltipState> _openedTooltips =
      <CustomTooltipState>[];

  static bool dismissAllToolTips() {
    if (_openedTooltips.isNotEmpty) {
      final List<CustomTooltipState> openedTooltips = _openedTooltips.toList();
      for (final CustomTooltipState state in openedTooltips) {
        assert(state.mounted);
        state._scheduleDismissTooltip();
      }
      return true;
    }
    return false;
  }

  @override
  State<CustomTooltip> createState() => CustomTooltipState();
}

class CustomTooltipState extends State<CustomTooltip>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);

  final OverlayPortalController _overlayController = OverlayPortalController();

  AnimationController? _backingController;
  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
  }

  CurvedAnimation? _backingOverlayAnimation;
  CurvedAnimation get _overlayAnimation {
    return _backingOverlayAnimation ??= CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  LongPressGestureRecognizer? _longPressRecognizer;

  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  void _handleStatusChanged(AnimationStatus status) {
    assert(mounted);
    switch ((_animationStatus.isDismissed, status.isDismissed)) {
      case (false, true):
        CustomTooltip._openedTooltips.remove(this);
        _overlayController.hide();
      case (true, false):
        _overlayController.show();
        CustomTooltip._openedTooltips.add(this);
      case (true, true) || (false, false):
        break;
    }
    _animationStatus = status;
  }

  void _scheduleShowTooltip() {
    _controller.forward();
  }

  void _scheduleDismissTooltip() {
    _controller.reverse();
  }

  void _handlePointerDown(PointerDownEvent event) {
    assert(mounted);
    const Set<PointerDeviceKind> triggerModeDeviceKinds = <PointerDeviceKind>{
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.stylus,
      PointerDeviceKind.touch,
      PointerDeviceKind.unknown,
      PointerDeviceKind.trackpad,
    };
    _longPressRecognizer ??= LongPressGestureRecognizer(
      debugOwner: this,
      supportedDevices: triggerModeDeviceKinds,
    );
    _longPressRecognizer!
      ..onLongPress = _scheduleShowTooltip
      ..addPointer(event);
  }

  Widget _buildCustomTooltipOverlay(BuildContext context) {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    final _CustomTooltipOverlay overlayChild = _CustomTooltipOverlay(
      verticalOffset: box.size.height / 2,
      horizontslOffset: box.size.width / 2,
      type: widget.type,
      animation: _overlayAnimation,
      target: target,
      onDismiss: _scheduleDismissTooltip,
      overlayWidget: widget.overlayWidget,
      indicator: widget.indicator,
    );

    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  @protected
  @override
  void dispose() {
    CustomTooltip._openedTooltips.remove(this);
    _longPressRecognizer?.onLongPressCancel = null;
    _longPressRecognizer?.dispose();
    _backingController?.dispose();
    _backingOverlayAnimation?.dispose();
    super.dispose();
  }

  @protected
  @override
  Widget build(BuildContext context) {
    Widget result;
    if (Utils.isMobile) {
      result = Listener(
        onPointerDown: _handlePointerDown,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      );
    } else {
      result = MouseRegion(
        cursor: MouseCursor.defer,
        onEnter: (_) => _scheduleShowTooltip(),
        onExit: (_) => _scheduleDismissTooltip(),
        child: widget.child,
      );
    }
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildCustomTooltipOverlay,
      child: result,
    );
  }
}

class _CustomTooltipOverlay extends StatelessWidget {
  const _CustomTooltipOverlay({
    required this.verticalOffset,
    required this.horizontslOffset,
    required this.type,
    required this.animation,
    required this.target,
    required this.onDismiss,
    required this.overlayWidget,
    this.indicator,
  });

  final double verticalOffset;
  final double horizontslOffset;
  final TooltipType type;
  final Animation<double> animation;
  final Offset target;
  final VoidCallback onDismiss;
  final Widget Function() overlayWidget;
  final Widget Function()? indicator;

  @override
  Widget build(BuildContext context) {
    Widget child = CustomMultiChildLayout(
      delegate: _CustomMultiTooltipPositionDelegate(
        type: type,
        target: target,
        verticalOffset: verticalOffset,
        horizontslOffset: horizontslOffset,
        preferBelow: false,
      ),
      children: [
        LayoutId(
          id: 'overlay',
          child: overlayWidget(),
        ),
        if (indicator != null)
          LayoutId(
            id: 'indicator',
            child: indicator!(),
          ),
      ],
    );
    if (Utils.isMobile) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: child,
      );
    }
    return child;
  }
}

class _CustomMultiTooltipPositionDelegate extends MultiChildLayoutDelegate {
  _CustomMultiTooltipPositionDelegate({
    required this.type,
    required this.target,
    required this.verticalOffset,
    required this.horizontslOffset,
    required this.preferBelow,
  });

  final TooltipType type;

  final Offset target;

  final double verticalOffset;

  final double horizontslOffset;

  final bool preferBelow;

  @override
  void performLayout(Size size) {
    switch (type) {
      case TooltipType.top:
        Size? indicatorSize;
        if (hasChild('indicator')) {
          indicatorSize = layoutChild('indicator', BoxConstraints.loose(size));
        }

        if (hasChild('overlay')) {
          final overlaySize = layoutChild(
            'overlay',
            BoxConstraints.loose(size),
          );
          Offset offset = positionDependentBox(
            type: type,
            size: size,
            childSize: overlaySize,
            target: target,
            verticalOffset: verticalOffset,
            horizontslOffset: horizontslOffset,
            preferBelow: preferBelow,
          );
          if (indicatorSize != null) {
            offset = Offset(offset.dx, offset.dy - indicatorSize.height + 1);
            positionChild(
              'indicator',
              Offset(
                target.dx - indicatorSize.width / 2,
                offset.dy + overlaySize.height - 1,
              ),
            );
          }
          positionChild('overlay', offset);
        }
      case TooltipType.right:
        Size? indicatorSize;
        if (hasChild('indicator')) {
          indicatorSize = layoutChild('indicator', BoxConstraints.loose(size));
        }

        if (hasChild('overlay')) {
          final overlaySize = layoutChild(
            'overlay',
            BoxConstraints.loose(size),
          );
          Offset offset = positionDependentBox(
            type: type,
            size: size,
            childSize: overlaySize,
            target: target,
            verticalOffset: verticalOffset,
            horizontslOffset: horizontslOffset,
            preferBelow: preferBelow,
          );
          if (indicatorSize != null) {
            offset = Offset(offset.dx + indicatorSize.height - 1, offset.dy);
            positionChild(
              'indicator',
              Offset(
                offset.dx - indicatorSize.width + 1,
                target.dy - indicatorSize.height / 2,
              ),
            );
          }
          positionChild('overlay', offset);
        }
    }
  }

  @override
  bool shouldRelayout(_CustomMultiTooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter(this.color, {this.type = TooltipType.top});
  final TooltipType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path;
    switch (type) {
      case TooltipType.top:
        path = Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case TooltipType.right:
        path = Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => color != oldDelegate.color;
}

Offset positionDependentBox({
  required TooltipType type,
  required Size size,
  required Size childSize,
  required Offset target,
  required bool preferBelow,
  double verticalOffset = 0.0,
  double horizontslOffset = 0.0,
  double margin = 10.0,
}) {
  switch (type) {
    case TooltipType.top:
      // VERTICAL DIRECTION
      final bool fitsBelow =
          target.dy + verticalOffset + childSize.height <= size.height - margin;
      final bool fitsAbove =
          target.dy - verticalOffset - childSize.height >= margin;
      final bool tooltipBelow = fitsAbove == fitsBelow
          ? preferBelow
          : fitsBelow;
      final double y;
      if (tooltipBelow) {
        y = math.min(target.dy + verticalOffset, size.height - margin);
      } else {
        y = math.max(target.dy - verticalOffset - childSize.height, margin);
      } // HORIZONTAL DIRECTION
      final double flexibleSpace = size.width - childSize.width;
      final double x = flexibleSpace <= 2 * margin
          // If there's not enough horizontal space for margin + child, center the
          // child.
          ? flexibleSpace / 2.0
          : clampDouble(
              target.dx - childSize.width / 2,
              margin,
              flexibleSpace - margin,
            );
      return Offset(x, y);
    case TooltipType.right:
      final double dy = math.max(margin, target.dy - childSize.height / 2);
      final double dx = math.min(
        target.dx + horizontslOffset,
        size.width - childSize.width - margin,
      );
      return Offset(dx, dy);
  }
}
