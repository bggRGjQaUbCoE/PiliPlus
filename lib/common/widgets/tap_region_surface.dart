import 'package:flutter/rendering.dart' show BoxHitTestResult, HitTestEntry;
import 'package:flutter/widgets.dart';

class SelectionTapRegionSurface extends TapRegionSurface {
  const SelectionTapRegionSurface({
    super.key,
    required super.child,
    required this.isScrolling,
  });

  final ValueGetter<bool> isScrolling;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSelectionTapRegionSurface(isScrolling);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSelectionTapRegionSurface renderObject,
  ) {
    renderObject.isScrolling = isScrolling;
  }
}

class RenderSelectionTapRegionSurface extends RenderTapRegionSurface {
  RenderSelectionTapRegionSurface(this.isScrolling);

  ValueGetter<bool> isScrolling;
  bool _isScrolling = false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    _isScrolling = isScrolling();
    return super.hitTest(result, position: position);
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (_isScrolling) {
      return;
    }
    super.handleEvent(event, entry);
  }
}
