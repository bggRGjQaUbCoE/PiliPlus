part of 'package:PiliPlus/common/widgets/flutter/draggable_scrollable_sheet.dart';

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

class _DynDraggableScrollableSheetState extends _DraggableScrollableSheetState {
  @override
  void initState() {
    super.initState();
    _extent = _DraggableSheetExtent(
      minSize: widget.minChildSize,
      maxSize: widget.maxChildSize,
      snap: widget.snap,
      snapSizes: _impliedSnapSizes(),
      snapAnimationDuration: widget.snapAnimationDuration,
      initialSize: widget.initialChildSize,
      shouldCloseOnMinExtent: widget.shouldCloseOnMinExtent,
    );
    _scrollController = _DynDraggableScrollableSheetScrollController(
      extent: _extent,
    );
    widget.controller?._attach(_scrollController);
  }
}

class _DynDraggableScrollableSheetScrollController
    extends _DraggableScrollableSheetScrollController {
  _DynDraggableScrollableSheetScrollController({
    required super.extent,
  });

  @override
  _DraggableScrollableSheetScrollPosition createScrollPosition(
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
    extends _DraggableScrollableSheetScrollPosition {
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
