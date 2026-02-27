import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox;
import 'package:flutter/scheduler.dart';

typedef LayoutCallback = void Function(Size size);

class OnlyLayoutWidget extends SingleChildRenderObjectWidget {
  const OnlyLayoutWidget({
    super.key,
    super.child,
    required this.onPerformLayout,
  });

  final LayoutCallback onPerformLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      NoRenderLayoutBox(onPerformLayout: onPerformLayout);

  @override
  void updateRenderObject(
    BuildContext context,
    NoRenderLayoutBox renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

class NoRenderLayoutBox extends RenderProxyBox {
  NoRenderLayoutBox({required this.onPerformLayout});

  LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onPerformLayout(size);
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {}
}
