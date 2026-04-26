part of 'package:PiliPlus/common/widgets/flutter/draggable_scrollable_sheet.dart';

class TopicDraggableScrollableSheet extends DraggableScrollableSheet {
  const TopicDraggableScrollableSheet({
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
    this.initialScrollOffset = 0.0,
  });

  final double initialScrollOffset;

  @override
  State<DraggableScrollableSheet> createState() =>
      _TopicDraggableScrollableSheetState();
}

class _TopicDraggableScrollableSheetState
    extends _DraggableScrollableSheetState {
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
    _scrollController = _TopicDraggableScrollableSheetScrollController(
      extent: _extent,
      initialScrollOffset:
          (widget as TopicDraggableScrollableSheet).initialScrollOffset,
    );
    widget.controller?._attach(_scrollController);
  }
}

class _TopicDraggableScrollableSheetScrollController
    extends _DraggableScrollableSheetScrollController {
  _TopicDraggableScrollableSheetScrollController({
    required super.extent,
    double initialScrollOffset = 0.0,
  }) : _initialScrollOffset = initialScrollOffset;

  @override
  double get initialScrollOffset => _initialScrollOffset;
  final double _initialScrollOffset;

  @override
  _DraggableScrollableSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _DraggableScrollableSheetScrollPosition(
      physics: physics.applyTo(const AlwaysScrollableScrollPhysics()),
      context: context,
      oldPosition: oldPosition,
      getExtent: () => extent,
      initialPixels: _initialScrollOffset,
    );
  }
}
