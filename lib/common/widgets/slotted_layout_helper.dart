import 'package:flutter/rendering.dart'
    show Offset, RenderBox, BoxParentData, BoxHitTestResult;
import 'package:material_ui/material_ui.dart'
    show SlottedContainerRenderObjectMixin;

Offset getOffset(RenderBox child) {
  return (child.parentData as BoxParentData).offset;
}

void setOffset(RenderBox child, Offset offset) {
  (child.parentData as BoxParentData).offset = offset;
}

mixin SlottedLayoutMixin<SlotType>
    on RenderBox, SlottedContainerRenderObjectMixin<SlotType, RenderBox> {
  Iterable<SlotType> get slots;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final type in slots) {
      final child = childForSlot(type);
      if (child == null) continue;
      final bool isHit = result.addWithPaintOffset(
        offset: getOffset(child),
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
