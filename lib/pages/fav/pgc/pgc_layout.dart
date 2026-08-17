import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:material_ui/material_ui.dart';

enum PgcType { toolbar, body }

class PgcLayout
    extends SlottedMultiChildRenderObjectWidget<PgcType, RenderBox> {
  const PgcLayout({
    super.key,
    required this.body,
    required this.toolbar,
  });

  final Widget body;
  final Widget toolbar;

  @override
  Iterable<PgcType> get slots => PgcType.values;

  @override
  Widget childForSlot(slot) => switch (slot) {
    .toolbar => toolbar,
    .body => body,
  };

  @override
  SlottedContainerRenderObjectMixin<PgcType, RenderBox> createRenderObject(
    BuildContext context,
  ) {
    return _RenderPgcLayout();
  }
}

class _RenderPgcLayout extends RenderBox
    with
        SlottedContainerRenderObjectMixin<PgcType, RenderBox>,
        SlottedLayoutMixin {
  RenderBox get body => childForSlot(.body)!;
  RenderBox get toolbar => childForSlot(.toolbar)!;

  @override
  Iterable<PgcType> get slots => PgcType.values;

  @override
  void performLayout() {
    final constraints = this.constraints;
    size = constraints.biggest;

    final body = this.body..layout(constraints);
    setOffset(body, .zero);

    final toolbar = this.toolbar
      ..layout(BoxConstraints.tightFor(width: constraints.maxWidth));
    setOffset(toolbar, Offset(0, constraints.maxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox child) {
      context.paintChild(child, getOffset(child) + offset);
    }

    doPaint(body);
    doPaint(toolbar);
  }
}
