import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderBox, ChildLayoutHelper;

enum BottomSheetType { bottomSheet, body }

class BottomSheetLayout
    extends SlottedMultiChildRenderObjectWidget<BottomSheetType, RenderBox> {
  const BottomSheetLayout({
    super.key,
    this.bottomSheet,
    required this.body,
  });

  final Widget? bottomSheet;
  final Widget body;

  @override
  Iterable<BottomSheetType> get slots => BottomSheetType.values;

  @override
  Widget? childForSlot(slot) => switch (slot) {
    .bottomSheet => bottomSheet,
    .body => body,
  };

  @override
  SlottedContainerRenderObjectMixin<BottomSheetType, RenderBox>
  createRenderObject(
    BuildContext context,
  ) {
    return _RenderScaffoldLayout();
  }
}

class _RenderScaffoldLayout extends RenderBox
    with
        SlottedContainerRenderObjectMixin<BottomSheetType, RenderBox>,
        SlottedLayoutMixin {
  RenderBox? get bottomSheet => childForSlot(.bottomSheet);
  RenderBox get body => childForSlot(.body)!;

  @override
  Iterable<BottomSheetType> get slots => BottomSheetType.values;

  @override
  void performLayout() {
    final constraints = this.constraints;
    size = constraints.biggest;

    final childConstraints = constraints.loosen();
    final body = this.body..layout(childConstraints);
    setOffset(body, .zero);

    final bottomSheet = this.bottomSheet;
    if (bottomSheet != null) {
      final size = ChildLayoutHelper.layoutChild(bottomSheet, childConstraints);
      setOffset(bottomSheet, Offset(0, constraints.maxHeight - size.height));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        context.paintChild(child, getOffset(child) + offset);
      }
    }

    doPaint(body);
    doPaint(bottomSheet);
  }
}
