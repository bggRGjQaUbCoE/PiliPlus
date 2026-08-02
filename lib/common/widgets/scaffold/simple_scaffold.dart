import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show BoxParentData, BoxHitTestResult, ChildLayoutHelper;

class SimpleScaffold extends StatelessWidget {
  const SimpleScaffold({
    super.key,
    this.backgroundColor,
    this.fab,
    this.appBar,
    required this.body,
  });

  final Color? backgroundColor;
  final Widget? fab;
  final Widget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: ScaffoldLayout(
        fab: fab,
        appBar: appBar,
        body: body,
      ),
    );
  }
}

enum ScaffoldType { fab, appBar, body }

class ScaffoldLayout
    extends SlottedMultiChildRenderObjectWidget<ScaffoldType, RenderBox> {
  const ScaffoldLayout({
    super.key,
    this.fab,
    this.appBar,
    required this.body,
  });

  final Widget? fab;
  final Widget? appBar;
  final Widget body;

  @override
  Iterable<ScaffoldType> get slots => ScaffoldType.values;

  @override
  Widget? childForSlot(slot) => switch (slot) {
    .fab => fab,
    .appBar => appBar,
    .body => body,
  };

  @override
  SlottedContainerRenderObjectMixin<ScaffoldType, RenderBox> createRenderObject(
    BuildContext context,
  ) {
    return _RenderScaffoldLayout();
  }
}

class _RenderScaffoldLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<ScaffoldType, RenderBox> {
  RenderBox? get fab => childForSlot(.fab);
  RenderBox? get appBar => childForSlot(.appBar);
  RenderBox get body => childForSlot(.body)!;

  Offset _getOffset(RenderBox child) {
    return (child.parentData as BoxParentData).offset;
  }

  void _setOffset(RenderBox child, Offset offset) {
    (child.parentData as BoxParentData).offset = offset;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    size = constraints.biggest;

    final Offset bodyOffset;
    final BoxConstraints bodyConstraints;

    final appBar = this.appBar;
    if (appBar != null) {
      final appBarHeight = ChildLayoutHelper.layoutChild(
        appBar,
        BoxConstraints.tightFor(width: constraints.maxWidth),
      ).height;
      _setOffset(appBar, .zero);

      bodyOffset = Offset(0, appBarHeight);
      bodyConstraints = BoxConstraints.tightFor(
        width: constraints.maxWidth,
        height: constraints.maxHeight - appBarHeight,
      );
    } else {
      bodyOffset = .zero;
      bodyConstraints = constraints;
    }

    final body = this.body..layout(bodyConstraints);
    _setOffset(body, bodyOffset);

    final fab = this.fab;
    if (fab != null) {
      final fabSize = ChildLayoutHelper.layoutChild(fab, constraints.loosen());
      _setOffset(
        fab,
        Offset(
          constraints.maxWidth - fabSize.width,
          constraints.maxHeight - fabSize.height,
        ),
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        context.paintChild(child, _getOffset(child) + offset);
      }
    }

    doPaint(appBar);
    doPaint(body);
    doPaint(fab);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final type in ScaffoldType.values) {
      final child = childForSlot(type);
      if (child == null) continue;
      final bool isHit = result.addWithPaintOffset(
        offset: _getOffset(child),
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
