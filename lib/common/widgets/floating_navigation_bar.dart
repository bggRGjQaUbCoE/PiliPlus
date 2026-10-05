// Adapted from FlClash's navigation_dock.dart (GPL-3.0).
import 'dart:math' as math;

import 'package:PiliPlus/utils/extension/theme_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

const double _barHeight = 62;
const double _barPadding = 4;
const double _edgeMargin = 21;
const double _shadowRoom = 8;
const double _hitSlop = 8;
const double _maxItemExtent = 72;
const _fullWidthCount = 5;
const double _iconSize = 24;
const double _labelGap = 2;
const double _labelInset = 2;
const double _labelSize = 10;
const double _minLabelSize = 9;
const double _pressGrowth = 1 / 8;
const double _maxPressGrowth = 16;
const double _lensGrowth = 14;
const double _lensMagnify = 0.12;
const double _hoverMagnet = 0.2;
const double _hoverParallax = 0.5;
const double _hoverAlpha = 0.08;
const double _hoverSwell = 0.4;
const double _jellySpeed = 8;
const double _jellyStretch = 0.25;
const double _overdrag = 0.35;
const double _pullLimit = 7 / 32;
const double _pullStretch = 0.5;
const _flingProjection = Duration(milliseconds: 100);
final _trackSpring = SpringDescription.withDurationAndBounce(
  duration: const Duration(milliseconds: 120),
);
final _liftSpring = SpringDescription.withDurationAndBounce(
  duration: const Duration(milliseconds: 280),
  bounce: 0.2,
);
final _settleSpring = SpringDescription.withDurationAndBounce(
  duration: const Duration(milliseconds: 500),
  bounce: 0.32,
);
final _hoverSpring = SpringDescription.withDurationAndBounce(
  duration: const Duration(milliseconds: 260),
  bounce: 0.18,
);
final _fadeSpring = SpringDescription.withDurationAndBounce(
  duration: const Duration(milliseconds: 200),
);

double _rubberBand(double overshoot, double limit) {
  final pull = 1 - 1 / (overshoot.abs() * 0.55 / limit + 1);
  return limit * pull * overshoot.sign;
}

/// The lens's box, measured from the start edge of the destination at 0.
Rect _lensRect({
  required double position,
  required double velocity,
  required double extent,
  required double height,
  required double lift,
}) {
  final stretch =
      (velocity.abs() / _jellySpeed).clamp(0.0, 1.0) * _jellyStretch;
  final growth = _lensGrowth * 2 * lift;
  final width = (extent + growth) * (1 + stretch);
  final lensHeight = (height + growth) * (1 - stretch / 2);
  return Rect.fromLTWH(
    (position + 0.5) * extent - width / 2,
    (height - lensHeight) / 2,
    width,
    lensHeight,
  );
}

/// A value that springs toward a target the finger may move every frame.
///
/// [AnimationController.animateWith] restarts its ticker, whose first frame
/// reads no elapsed time, so retargeting it on every pointer move holds the
/// value still for as long as the finger keeps moving.
class _Spring extends ChangeNotifier implements ValueListenable<double> {
  _Spring(TickerProvider vsync, this._value) {
    _ticker = vsync.createTicker(_tick);
  }

  late final Ticker _ticker;
  double _value;
  double _target = 0;
  SpringSimulation? _simulation;
  bool reduceMotion = false;
  double? reducedValue;
  double _now = 0;
  double _start = 0;

  @override
  double get value => _value;

  double get target => _simulation == null ? _value : _target;

  double get velocity => _simulation?.dx(_now - _start) ?? 0;

  void springTo(double target, SpringDescription spring) {
    if (reduceMotion) {
      jumpTo(reducedValue ?? target);
      return;
    }
    _simulation = SpringSimulation(spring, _value, target, velocity);
    _target = target;
    if (_ticker.isActive) {
      _start = _now;
      return;
    }
    _now = _start = 0;
    _ticker.start();
  }

  void jumpTo(double value) {
    _simulation = null;
    _ticker.stop();
    _value = value;
    notifyListeners();
  }

  void _tick(Duration elapsed) {
    _now = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    final simulation = _simulation!;
    final time = _now - _start;
    if (simulation.isDone(time)) {
      _value = _target;
      _simulation = null;
      _ticker.stop();
    } else {
      _value = simulation.x(time);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

// A soft, wide drop in the manner of iOS rather than a Material elevation.
List<BoxShadow> _dockShadows(ColorScheme colorScheme) {
  final strength = colorScheme.isDark ? 3.0 : 1.0;
  return [
    BoxShadow(
      color: colorScheme.shadow.withValues(alpha: 0.08 * strength),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: colorScheme.shadow.withValues(alpha: 0.04 * strength),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
}

({double width, double height}) _measureLabel(
  BuildContext context,
  String label,
  TextStyle? style,
) {
  final painter = TextPainter(
    text: TextSpan(text: label, style: style),
    textScaler: MediaQuery.textScalerOf(context),
    textDirection: Directionality.of(context),
    maxLines: 1,
  )..layout();
  final size = (width: painter.width, height: painter.height);
  painter.dispose();
  return size;
}

const _pillShape = RoundedSuperellipseBorder(
  borderRadius: BorderRadius.all(Radius.circular(1000)),
);

class FloatingNavigationDestination {
  const FloatingNavigationDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.enabled = true,
    this.badge,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final String? tooltip;
  final bool enabled;
  final Widget? badge;
}

class FloatingNavigationBar extends StatelessWidget {
  const FloatingNavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  }) : assert(destinations.length >= 2),
       assert(selectedIndex >= 0 && selectedIndex < destinations.length);

  final List<FloatingNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.viewPaddingOf(context);
    final height =
        _barHeight +
        MediaQuery.textScalerOf(context).scale(_labelSize) -
        _labelSize;
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          safe.left + _edgeMargin,
          _shadowRoom,
          safe.right + _edgeMargin,
          math.max(_edgeMargin, safe.bottom),
        ),
        child: _HitSlop(
          child: SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: _HitSlop(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: destinations.length >= _fullWidthCount
                            ? double.infinity
                            : destinations.length * _maxItemExtent +
                                  _barPadding * 2,
                      ),
                      child: _FloatingBar(
                        destinations: destinations,
                        selectedIndex: selectedIndex,
                        onSelected: onDestinationSelected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HitSlop extends SingleChildRenderObjectWidget {
  const _HitSlop({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderHitSlop();
}

class _RenderHitSlop extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position)) {
      return super.hitTest(result, position: position);
    }
    if (size.isEmpty ||
        !(Offset.zero & size).inflate(_hitSlop).contains(position)) {
      return false;
    }
    if (!hitTestChildren(result, position: _onSpine(position))) {
      return false;
    }
    result.add(BoxHitTestEntry(this, position));
    return true;
  }

  // A pill's rounded ends clip hit tests; its straight core never does.
  Offset _onSpine(Offset position) {
    final radius = size.shortestSide / 2;
    return Offset(
      position.dx.clamp(radius, size.width - radius),
      size.height / 2,
    );
  }
}

class _PressTransform extends SingleChildRenderObjectWidget {
  const _PressTransform({required this.lift, required this.pull, super.child});

  final double lift;
  final Offset pull;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPressTransform(lift: lift, pull: pull);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPressTransform renderObject,
  ) {
    renderObject
      ..lift = lift
      ..pull = pull;
  }
}

class _RenderPressTransform extends RenderProxyBox {
  _RenderPressTransform({required this._lift, required this._pull});

  double _lift;
  Offset _pull;

  set lift(double value) {
    if (value == _lift) {
      return;
    }
    _lift = value;
    markNeedsPaint();
  }

  set pull(Offset value) {
    if (value == _pull) {
      return;
    }
    _pull = value;
    markNeedsPaint();
  }

  Matrix4 get _transform {
    final swell =
        1 +
        _lift * math.min(_pressGrowth * 2, _maxPressGrowth / size.longestSide);
    final scaleX = swell * (1 + _pull.dx.abs() / size.width * _pullStretch);
    final scaleY = swell * (1 + _pull.dy.abs() / size.height * _pullStretch);
    final center = size.center(Offset.zero);
    return Matrix4.diagonal3Values(scaleX, scaleY, 1)..setTranslationRaw(
      center.dx * (1 - scaleX) + _pull.dx,
      center.dy * (1 - scaleY) + _pull.dy,
      0,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || size.isEmpty || (_lift == 0 && _pull == .zero)) {
      layer = null;
      super.paint(context, offset);
      return;
    }
    layer = context.pushTransform(
      needsCompositing,
      offset,
      _transform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer as TransformLayer? : null,
    );
  }
}

/// A floating pill of destinations whose selection is a lens that springs
/// between them, after iOS's tab bar. Pressing swells the bar and lifts
/// the lens under the finger; dragging slides
/// the lens across the bar, selecting where it is let go, and stretches the
/// bar past either end.
class _FloatingBar extends StatefulWidget {
  const _FloatingBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<FloatingNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  @override
  State<_FloatingBar> createState() => _FloatingNavigationBarState();
}

class _FloatingNavigationBarState extends State<_FloatingBar>
    with TickerProviderStateMixin {
  late final _Spring _lens = _Spring(this, _selectedIndex.toDouble());
  late final _Spring _lift = _Spring(this, 0)..reducedValue = 0;
  late final _Spring _hover = _Spring(this, 0);
  late final _Spring _hoverShow = _Spring(this, 0);
  late final _Spring _swell = _Spring(this, 0)..reducedValue = 0;
  late final _Spring _stretch = _Spring(this, 0)..reducedValue = 0;
  late final Listenable _barMotion = Listenable.merge([_swell, _stretch]);
  late final Listenable _motion = Listenable.merge([_lens, _lift]);
  late final Listenable _hoverMotion = Listenable.merge([_hover, _hoverShow]);
  int? _pointer;
  int? _pressedIndex;
  double _pressX = 0;
  bool _dragging = false;
  VelocityTracker? _tracker;
  Offset? _cursor;
  final ValueNotifier<double?> _hoverAt = ValueNotifier(null);

  int get _lastIndex => math.max(0, widget.destinations.length - 1);

  int get _selectedIndex => widget.selectedIndex.clamp(0, _lastIndex);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduce = MediaQuery.disableAnimationsOf(context);
    for (final spring in [_lens, _lift, _hover, _hoverShow, _swell, _stretch]) {
      spring.reduceMotion = reduce;
      if (reduce) spring.jumpTo(spring.reducedValue ?? spring.target);
    }
  }

  @override
  void didUpdateWidget(covariant _FloatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rest = _lensRest;
    if (_pressedIndex == null && _lens.target != rest) {
      _lens.springTo(rest, _settleSpring);
    }
  }

  @override
  void dispose() {
    _lens.dispose();
    _lift.dispose();
    _hover.dispose();
    _hoverShow.dispose();
    _swell.dispose();
    _stretch.dispose();
    _hoverAt.dispose();
    super.dispose();
  }

  double _positionAt(Offset localPosition) {
    final width = context.size!.width;
    final dx = Directionality.of(context) == TextDirection.ltr
        ? localPosition.dx
        : width - localPosition.dx;
    final extent = (width - _barPadding * 2) / widget.destinations.length;
    final position = (dx - _barPadding) / extent - 0.5;
    if (position < 0) {
      return _rubberBand(position, _overdrag);
    }
    if (position > _lastIndex) {
      return _lastIndex + _rubberBand(position - _lastIndex, _overdrag);
    }
    return position;
  }

  int _indexAt(double position) => position.round().clamp(0, _lastIndex);

  double _leanAt(double position) {
    final index = _indexAt(position);
    return index + (position - index) * _hoverMagnet;
  }

  double get _lensRest {
    final hoverAt = _hoverAt.value;
    if (hoverAt == null || _indexAt(hoverAt) != _selectedIndex) {
      return _selectedIndex.toDouble();
    }
    return _leanAt(hoverAt);
  }

  // A lens headed to a just-tapped destination is left for didUpdateWidget.
  void _leanLens() {
    if (_pressedIndex != null || _indexAt(_lens.target) != _selectedIndex) {
      return;
    }
    final rest = _lensRest;
    if (_lens.target != rest) {
      _lens.springTo(rest, _hoverSpring);
    }
  }

  void _showHover() {
    final cursor = _cursor;
    if (cursor == null || _pointer != null || widget.destinations.isEmpty) {
      return;
    }
    final position = _positionAt(cursor);
    final target = _leanAt(position);
    _hoverAt.value = position;
    if (_hoverShow.target == 0 && _hoverShow.value == 0) {
      _hover.jumpTo(target);
    } else {
      _hover.springTo(target, _hoverSpring);
    }
    _hoverShow.springTo(1, _fadeSpring);
    _leanLens();
  }

  void _settleSwell() {
    final target = _cursor == null ? 0.0 : _hoverSwell;
    if (_pointer == null && _swell.target != target) {
      _swell.springTo(target, _settleSpring);
    }
  }

  void _handleHover(PointerHoverEvent event) {
    // The engine synthesizes a hover before a touch lands, and the touch
    // pointer lingers until removed, so a tap would leave the highlight on.
    if (event.kind == PointerDeviceKind.touch) {
      return;
    }
    _cursor = event.localPosition;
    _showHover();
    _settleSwell();
  }

  void _handleExit(PointerExitEvent event) {
    _cursor = null;
    _hoverShow.springTo(0, _fadeSpring);
    _hoverAt.value = null;
    _leanLens();
    _settleSwell();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_pointer != null || event.buttons & kPrimaryButton == 0) {
      return;
    }
    if (widget.onSelected == null ||
        !widget
            .destinations[_indexAt(_positionAt(event.localPosition))]
            .enabled) {
      return;
    }
    _pointer = event.pointer;
    _tracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.localPosition);
    _hoverShow.springTo(0, _fadeSpring);
    _hoverAt.value = null;
    _swell.springTo(1, _liftSpring);
    _press(event.localPosition);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer == _pointer) {
      _tracker?.addPosition(event.timeStamp, event.localPosition);
      _slide(event.localPosition);
    }
  }

  void _handlePointerEnd(PointerEvent event) {
    if (event.pointer != _pointer) {
      return;
    }
    _pointer = null;
    final tracker = _tracker;
    _tracker = null;
    if (event is PointerUpEvent && tracker != null) {
      _fling(tracker.getVelocity().pixelsPerSecond.dx);
    }
    _release(commit: event is PointerUpEvent);
    _stretch.springTo(0, _settleSpring);
    if (_cursor != null) {
      _cursor = event.localPosition;
      _showHover();
    }
    _settleSwell();
  }

  void _press(Offset localPosition) {
    if (widget.destinations.isEmpty) {
      return;
    }
    final index = _indexAt(_positionAt(localPosition));
    _pressedIndex = index;
    _pressX = localPosition.dx;
    _dragging = false;
    _lift.springTo(1, _liftSpring);
    _lens.springTo(index.toDouble(), _settleSpring);
  }

  void _slide(Offset localPosition) {
    if (_pressedIndex == null) {
      return;
    }
    if (!_dragging) {
      if ((localPosition.dx - _pressX).abs() < kTouchSlop) {
        return;
      }
      _dragging = true;
    }
    final size = context.size!;
    final overshoot =
        localPosition.dx - localPosition.dx.clamp(0.0, size.width);
    _stretch.springTo(
      _rubberBand(overshoot, size.shortestSide * _pullLimit),
      _trackSpring,
    );
    final position = _positionAt(localPosition);
    _lens.springTo(position, _trackSpring);
    final index = _indexAt(position);
    if (index != _pressedIndex) {
      HapticFeedback.selectionClick();
      _pressedIndex = index;
    }
  }

  /// Carries a drag let go mid-flick on to the next destination, at most one
  /// past the one under the finger.
  void _fling(double velocityX) {
    final pressed = _pressedIndex;
    if (!_dragging || pressed == null) {
      return;
    }
    final extent =
        (context.size!.width - _barPadding * 2) / widget.destinations.length;
    final direction = Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    final lead =
        velocityX /
        extent *
        direction *
        _flingProjection.inMicroseconds /
        Duration.microsecondsPerSecond;
    final index = (_lens.target + lead)
        .round()
        .clamp(pressed - 1, pressed + 1)
        .clamp(0, _lastIndex);
    if (index != pressed) {
      HapticFeedback.selectionClick();
      _pressedIndex = index;
    }
  }

  void _release({required bool commit}) {
    final index = _pressedIndex;
    if (index == null) {
      return;
    }
    _pressedIndex = null;
    _dragging = false;
    _lift.springTo(0, _settleSpring);
    if (!commit) {
      _lens.springTo(_selectedIndex.toDouble(), _settleSpring);
      return;
    }
    _lens.springTo(_selectedIndex.toDouble(), _settleSpring);
    if (widget.destinations[index].enabled) {
      widget.onSelected?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontSize: _labelSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    );
    final labels = [
      for (final destination in widget.destinations)
        _measureLabel(context, destination.label, labelStyle),
    ];
    final widest = labels.fold(
      0.0,
      (width, label) => math.max(width, label.width),
    );
    final lineHeight = labels.fold(
      0.0,
      (height, label) => math.max(height, label.height),
    );
    final bar = DecoratedBox(
      decoration: ShapeDecoration(
        shape: _pillShape,
        shadows: _dockShadows(colorScheme),
      ),
      child: Material(
        color: colorScheme.surfaceContainer,
        shape: _pillShape,
        // Raw pointers rather than recognizers: a drag has nothing to win the
        // arena from, and a tap waiting on one lifts the lens late.
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: _handlePointerDown,
          onPointerMove: _handlePointerMove,
          onPointerUp: _handlePointerEnd,
          onPointerCancel: _handlePointerEnd,
          child: MouseRegion(
            onHover: _handleHover,
            onExit: _handleExit,
            child: Padding(
              padding: const EdgeInsets.all(_barPadding),
              // Above the LayoutBuilder: rebuilding anything under one relays
              // it out, and that repaint would otherwise reach the whole dock.
              child: RepaintBoundary(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final extent =
                        constraints.maxWidth /
                        math.max(1, widget.destinations.length);
                    final room = extent - _labelInset * 2;
                    final labelScale = widest <= room
                        ? 1.0
                        : math.max(room / widest, _minLabelSize / _labelSize);
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        if (widget.destinations.isNotEmpty)
                          AnimatedBuilder(
                            animation: _motion,
                            builder: (_, _) => _Lens(
                              position: _lens.value,
                              velocity: _lens.velocity,
                              extent: extent,
                              height: constraints.maxHeight,
                              lift: _lift.value,
                            ),
                          ),
                        if (widget.destinations.isNotEmpty)
                          AnimatedBuilder(
                            animation: _hoverMotion,
                            builder: (_, _) => _HoverHighlight(
                              position: _hover.value,
                              extent: extent,
                              opacity: _hoverShow.value,
                            ),
                          ),
                        Row(
                          children: [
                            for (final (index, destination)
                                in widget.destinations.indexed)
                              Expanded(
                                child: _FloatingBarItem(
                                  destination: destination,
                                  selected: index == _selectedIndex,
                                  index: index,
                                  lens: _lens,
                                  hoverAt: _hoverAt,
                                  lift: _lift,
                                  labelStyle: labelStyle?.copyWith(
                                    fontSize: _labelSize * labelScale,
                                  ),
                                  labelHeight: lineHeight,
                                  labelOverflows:
                                      labels[index].width * labelScale > room,
                                  onActivate: () {
                                    if (destination.enabled) {
                                      widget.onSelected?.call(index);
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return AnimatedBuilder(
      animation: _barMotion,
      builder: (_, child) => _PressTransform(
        lift: _swell.value,
        pull: Offset(_stretch.value, 0),
        child: child,
      ),
      child: bar,
    );
  }
}

/// The pointer's highlight, drawn to the destination under it and leaning a
/// little toward the cursor, as iPadOS highlights a tab bar item; the item
/// under it follows the cursor half as far.
class _HoverHighlight extends StatelessWidget {
  const _HoverHighlight({
    required this.position,
    required this.extent,
    required this.opacity,
  });

  final double position;
  final double extent;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final alpha = _hoverAlpha * opacity.clamp(0.0, 1.0);
    if (alpha == 0) {
      return const SizedBox.shrink();
    }
    return Positioned.directional(
      textDirection: Directionality.of(context),
      start: position * extent,
      top: 0,
      bottom: 0,
      width: extent,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: ColorScheme.of(context).onSurface.withValues(alpha: alpha),
          shape: _pillShape,
        ),
      ),
    );
  }
}

class _Lens extends StatelessWidget {
  const _Lens({
    required this.position,
    required this.velocity,
    required this.extent,
    required this.height,
    required this.lift,
  });

  final double position;
  final double velocity;
  final double extent;
  final double height;
  final double lift;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final rect = _lensRect(
      position: position,
      velocity: velocity,
      extent: extent,
      height: height,
      lift: lift,
    );
    return PositionedDirectional(
      start: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: DecoratedBox(
        key: const ValueKey('floating-nav-lens'),
        decoration: ShapeDecoration(
          color: Color.alphaBlend(
            colorScheme.onSecondaryContainer.withValues(
              alpha: 0.08 * lift.clamp(0.0, 1.0),
            ),
            colorScheme.secondaryContainer,
          ),
          shape: _pillShape,
        ),
      ),
    );
  }
}

class _FloatingBarItem extends StatefulWidget {
  const _FloatingBarItem({
    required this.destination,
    required this.selected,
    required this.index,
    required this.lens,
    required this.hoverAt,
    required this.lift,
    required this.labelStyle,
    required this.labelHeight,
    required this.labelOverflows,
    required this.onActivate,
  });

  final FloatingNavigationDestination destination;
  final bool selected;
  final int index;
  final _Spring lens;

  /// Where the pointer hovers, in destinations from the first one's center.
  final ValueListenable<double?> hoverAt;
  final ValueListenable<double> lift;
  final TextStyle? labelStyle;
  final double labelHeight;
  final bool labelOverflows;
  final VoidCallback onActivate;

  @override
  State<_FloatingBarItem> createState() => _FloatingBarItemState();
}

class _FloatingBarItemState extends State<_FloatingBarItem>
    with SingleTickerProviderStateMixin {
  late final Map<Type, Action<Intent>> _actions = {
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) {
        widget.onActivate();
        return null;
      },
    ),
  };
  late final _Spring _parallax = _Spring(this, 0);
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.hoverAt.addListener(_followPointer);
  }

  @override
  void didUpdateWidget(covariant _FloatingBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hoverAt != widget.hoverAt) {
      oldWidget.hoverAt.removeListener(_followPointer);
      widget.hoverAt.addListener(_followPointer);
    }
    _followPointer();
  }

  @override
  void dispose() {
    widget.hoverAt.removeListener(_followPointer);
    _parallax.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parallax.reduceMotion = MediaQuery.disableAnimationsOf(context);
    _parallax.reducedValue = 0;
    if (_parallax.reduceMotion) _parallax.jumpTo(0);
  }

  void _followPointer() {
    final hoverAt = widget.hoverAt.value;
    final offset = hoverAt == null ? 0.0 : hoverAt - widget.index;
    final target = offset.abs() > 0.5
        ? 0.0
        : offset * _hoverMagnet * _hoverParallax;
    if (target != _parallax.target) {
      _parallax.springTo(target, _hoverSpring);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    final color = widget.destination.enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface.withValues(alpha: 0.38);
    Widget buildContent(Widget icon) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: _labelInset),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(size: _iconSize, color: color),
            child: icon,
          ),
          const SizedBox(height: _labelGap),
          SizedBox(
            height: widget.labelHeight,
            child: Center(
              child: Text(
                widget.destination.label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: widget.labelStyle?.copyWith(color: color),
              ),
            ),
          ),
        ],
      ),
    );
    final content = Stack(
      fit: StackFit.expand,
      children: [
        for (final inside in [false, true])
          _LensTint(
            lens: widget.lens,
            lift: widget.lift,
            parallax: _parallax,
            index: widget.index,
            inside: inside,
            color: widget.destination.enabled
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.38),
            textDirection: Directionality.of(context),
            child: buildContent(
              inside
                  ? widget.destination.selectedIcon ?? widget.destination.icon
                  : widget.destination.icon,
            ),
          ),
      ],
    );
    final badgedContent = widget.destination.badge == null
        ? content
        : Stack(
            alignment: Alignment.center,
            children: [
              content,
              IgnorePointer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.destination.badge!,
                    SizedBox(height: _labelGap + widget.labelHeight),
                  ],
                ),
              ),
            ],
          );
    return FocusableActionDetector(
      enabled: widget.destination.enabled,
      actions: _actions,
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      child: Semantics(
        container: true,
        button: true,
        enabled: widget.destination.enabled,
        selected: widget.selected,
        label: widget.destination.label,
        excludeSemantics: true,
        onTap: widget.destination.enabled ? widget.onActivate : null,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: _focused
                ? colorScheme.onSurface.withValues(alpha: 0.1)
                : Colors.transparent,
            shape: _pillShape.copyWith(
              side: _focused
                  ? BorderSide(color: colorScheme.secondary, width: 2)
                  : BorderSide.none,
            ),
          ),
          child: widget.labelOverflows
              ? Tooltip(
                  message:
                      widget.destination.tooltip ?? widget.destination.label,
                  child: badgedContent,
                )
              : badgedContent,
        ),
      ),
    );
  }
}

/// Paints one content variant inside or outside the lens's exact shape.
/// The inside variant is tinted in [color]; the outside retains its colors.
/// The content swells under a lifted lens and leans after the [parallax], in
/// destinations, while layout and hit testing see it at rest.
class _LensTint extends SingleChildRenderObjectWidget {
  const _LensTint({
    required this.lens,
    required this.lift,
    required this.parallax,
    required this.index,
    required this.color,
    required this.textDirection,
    required this.inside,
    super.child,
  });

  final bool inside;
  final _Spring lens;
  final ValueListenable<double> lift;
  final ValueListenable<double> parallax;
  final int index;
  final Color color;
  final TextDirection textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLensTint(
      lens: lens,
      lift: lift,
      parallax: parallax,
      index: index,
      color: color,
      textDirection: textDirection,
      insideOnly: inside,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderLensTint renderObject) {
    renderObject
      ..lens = lens
      ..lift = lift
      ..parallax = parallax
      ..index = index
      ..color = color
      ..textDirection = textDirection
      ..inside = inside;
  }
}

class _RenderLensTint extends RenderProxyBox {
  _RenderLensTint({
    required this._lens,
    required this._lift,
    required this._parallax,
    required this._index,
    required this._color,
    required this._textDirection,
    required this._insideOnly,
  });

  bool _insideOnly;
  set inside(bool value) {
    if (value == _insideOnly) return;
    _insideOnly = value;
    markNeedsPaint();
  }

  final _outside = LayerHandle<ClipPathLayer>();
  final _inside = LayerHandle<ClipPathLayer>();
  final _tint = LayerHandle<ColorFilterLayer>();
  final _outsideMotion = LayerHandle<TransformLayer>();
  final _insideMotion = LayerHandle<TransformLayer>();

  _Spring _lens;
  set lens(_Spring value) {
    if (value == _lens) {
      return;
    }
    if (attached) {
      _lens.removeListener(markNeedsPaint);
      value.addListener(markNeedsPaint);
    }
    _lens = value;
    markNeedsPaint();
  }

  ValueListenable<double> _lift;
  set lift(ValueListenable<double> value) {
    if (value == _lift) {
      return;
    }
    if (attached) {
      _lift.removeListener(markNeedsPaint);
      value.addListener(markNeedsPaint);
    }
    _lift = value;
    markNeedsPaint();
  }

  ValueListenable<double> _parallax;
  set parallax(ValueListenable<double> value) {
    if (value == _parallax) {
      return;
    }
    if (attached) {
      _parallax.removeListener(markNeedsPaint);
      value.addListener(markNeedsPaint);
    }
    _parallax = value;
    markNeedsPaint();
  }

  int _index;
  set index(int value) {
    if (value == _index) {
      return;
    }
    _index = value;
    markNeedsPaint();
  }

  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) {
      return;
    }
    _textDirection = value;
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _lens.addListener(markNeedsPaint);
    _lift.addListener(markNeedsPaint);
    _parallax.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _lens.removeListener(markNeedsPaint);
    _lift.removeListener(markNeedsPaint);
    _parallax.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void dispose() {
    _outside.layer = null;
    _inside.layer = null;
    _tint.layer = null;
    _outsideMotion.layer = null;
    _insideMotion.layer = null;
    super.dispose();
  }

  Rect get _lensBounds {
    final rect = _lensRect(
      position: _lens.value - _index,
      velocity: _lens.velocity,
      extent: size.width,
      height: size.height,
      lift: _lift.value,
    );
    return _textDirection == TextDirection.ltr
        ? rect
        : Rect.fromLTRB(
            size.width - rect.right,
            rect.top,
            size.width - rect.left,
            rect.bottom,
          );
  }

  Matrix4? get _motion {
    final emphasis = (1 - (_lens.value - _index).abs()).clamp(0.0, 1.0);
    final scale = 1 + _lensMagnify * emphasis * _lift.value;
    final direction = _textDirection == TextDirection.ltr ? 1 : -1;
    final shift = _parallax.value * size.width * direction;
    if (scale == 1 && shift == 0) {
      return null;
    }
    final center = size.center(Offset.zero);
    return Matrix4.diagonal3Values(scale, scale, 1)..setTranslationRaw(
      center.dx * (1 - scale) + shift,
      center.dy * (1 - scale),
      0,
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    final motion = _motion;
    if (motion != null) {
      transform.multiply(motion);
    }
  }

  void _paintMoved(
    PaintingContext context,
    Offset offset,
    Matrix4? motion,
    LayerHandle<TransformLayer> handle,
  ) {
    if (motion == null) {
      handle.layer = null;
      super.paint(context, offset);
      return;
    }
    handle.layer = context.pushTransform(
      needsCompositing,
      offset,
      motion,
      super.paint,
      oldLayer: handle.layer,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    final motion = _motion;
    final bounds = Offset.zero & size;
    final content = motion == null
        ? bounds
        : MatrixUtils.transformRect(motion, bounds);
    final lensBounds = _lensBounds;
    // Touching edges do not overlap, so a lens at rest on a neighbour leaves
    // this destination unclipped.
    if (!lensBounds.overlaps(content)) {
      _outside.layer = null;
      _inside.layer = null;
      _tint.layer = null;
      _insideMotion.layer = null;
      if (!_insideOnly) {
        _paintMoved(context, offset, motion, _outsideMotion);
      }
      return;
    }
    final reach = content.expandToInclude(bounds).inflate(_labelInset);
    final lens = _pillShape.getOuterPath(lensBounds);
    if (!_insideOnly) {
      _outside.layer = context.pushClipPath(
        needsCompositing,
        offset,
        reach,
        Path()
          ..fillType = PathFillType.evenOdd
          ..addRect(reach)
          ..addPath(lens, Offset.zero),
        (context, offset) =>
            _paintMoved(context, offset, motion, _outsideMotion),
        oldLayer: _outside.layer,
      );
      return;
    }
    _inside.layer = context.pushClipPath(
      needsCompositing,
      offset,
      lensBounds,
      lens,
      (context, offset) => _paintTinted(context, offset, lensBounds, motion),
      oldLayer: _inside.layer,
    );
  }

  void _paintTinted(
    PaintingContext context,
    Offset offset,
    Rect lensBounds,
    Matrix4? motion,
  ) {
    final filter = ColorFilter.mode(_color, BlendMode.srcIn);
    if (needsCompositing) {
      _tint.layer = context.pushColorFilter(
        offset,
        filter,
        (context, offset) =>
            _paintMoved(context, offset, motion, _insideMotion),
        oldLayer: _tint.layer,
      );
      return;
    }
    _tint.layer = null;
    final canvas = context.canvas
      ..saveLayer(lensBounds.shift(offset), Paint()..colorFilter = filter);
    _paintMoved(context, offset, motion, _insideMotion);
    canvas.restore();
  }
}
