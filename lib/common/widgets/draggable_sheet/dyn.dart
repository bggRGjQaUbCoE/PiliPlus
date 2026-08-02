import 'package:flutter/gestures.dart' show Drag;
import 'package:flutter/material.dart';

class DynDraggableScrollableSheet extends DraggableScrollableSheet {
  const DynDraggableScrollableSheet({
    super.key,
    super.initialChildSize,
    super.minChildSize,
    super.maxChildSize,
    super.expand,
    super.snap,
    super.snapSizes,
    super.snapAnimationDuration,
    super.controller,
    super.shouldCloseOnMinExtent,
    required super.builder,
  });

  @override
  State<DraggableScrollableSheet> createState() =>
      _DynDraggableScrollableSheetState();
}

class _DynDraggableScrollableSheetState extends DraggableScrollableSheetState {
  @override
  void initScrollController() {
    scrollController = _DynDraggableScrollableSheetScrollController(
      extent: extent,
    );
  }
}

class _DynDraggableScrollableSheetScrollController
    extends DraggableScrollableSheetScrollController {
  _DynDraggableScrollableSheetScrollController({
    required super.extent,
  });

  @override
  DraggableScrollableSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _DynDraggableScrollableSheetScrollPosition(
      physics: physics.applyTo(const AlwaysScrollableScrollPhysics()),
      context: context,
      oldPosition: oldPosition,
      getExtent: () => extent,
    );
  }
}

class _DynDraggableScrollableSheetScrollPosition
    extends DraggableScrollableSheetScrollPosition {
  _DynDraggableScrollableSheetScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    required super.getExtent,
  });

  bool _isAtTop = true;

  @override
  bool get listShouldScroll => !_isAtTop || super.listShouldScroll;

  @override
  void applyUserOffset(double delta) {
    if (_isAtTop && pixels > 0) {
      _isAtTop = false;
    }
    super.applyUserOffset(delta);
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _isAtTop = pixels == 0;
    return super.drag(details, dragCancelCallback);
  }
}
