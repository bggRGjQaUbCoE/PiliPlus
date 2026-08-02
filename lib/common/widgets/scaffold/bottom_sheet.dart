import 'package:flutter/gestures.dart' show VerticalDragGestureRecognizer;
import 'package:flutter/material.dart';

// ignore: camel_case_types
class BottomSheet_ extends BottomSheet {
  const BottomSheet_({
    super.key,
    super.animationController,
    super.enableDrag = true,
    super.onDragStart,
    super.onDragEnd,
    super.constraints,
    required super.onClosing,
    required super.builder,
  });

  @override
  BottomSheetState createState() => _MiniBottomSheetState();
}

class _MiniBottomSheetState extends BottomSheetState {
  VerticalDragGestureRecognizer? _verticalDragGestureRecognizer;

  VerticalDragGestureRecognizer get verticalDragGestureRecognizer =>
      _verticalDragGestureRecognizer ??=
          VerticalDragGestureRecognizer(debugOwner: this)
            ..onStart = handleDragStart
            ..onUpdate = handleDragUpdate
            ..onEnd = handleDragEnd
            ..gestureSettings = MediaQuery.maybeGestureSettingsOf(context)
            ..onlyAcceptDragOnThreshold = true;

  @override
  void dispose() {
    super.dispose();
    _verticalDragGestureRecognizer?.dispose();
    _verticalDragGestureRecognizer = null;
  }

  void _onPointerDown(PointerDownEvent event) {
    verticalDragGestureRecognizer.addPointer(event);
  }

  @override
  Widget build(BuildContext context) {
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    late final defaults = useMaterial3
        ? BottomSheetDefaultsM3(context)
        : const BottomSheetThemeData();
    late final bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    final BoxConstraints? constraints =
        widget.constraints ??
        bottomSheetTheme.constraints ??
        defaults.constraints;

    Widget bottomSheet = KeyedSubtree(
      key: childKey,
      child: widget.builder(context),
    );

    if (constraints != null && constraints != const BoxConstraints()) {
      bottomSheet = Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 1.0,
        child: ConstrainedBox(constraints: constraints, child: bottomSheet),
      );
    }

    if (widget.enableDrag) {
      return Listener(
        onPointerDown: _onPointerDown,
        child: bottomSheet,
      );
    }

    return bottomSheet;
  }
}
