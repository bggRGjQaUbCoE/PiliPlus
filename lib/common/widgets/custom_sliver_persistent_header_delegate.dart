import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderProxyBox;

class CustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  const CustomSliverPersistentHeaderDelegate({
    required this.child,
    this.bgColor,
    this.extent = 45,
    this.needRebuild = false,
  });
  final double extent;
  final Widget child;
  final Color? bgColor;
  final bool needRebuild;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return _DecoratedBox(color: bgColor, child: child);
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => extent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(CustomSliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.bgColor != bgColor ||
        (needRebuild && oldDelegate.child != child);
  }
}

class _DecoratedBox extends SingleChildRenderObjectWidget {
  const _DecoratedBox({
    this.color,
    super.child,
  });

  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderDecoratedBox(color: color);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderDecoratedBox renderObject,
  ) {
    renderObject.color = color;
  }
}

class _RenderDecoratedBox extends RenderProxyBox {
  _RenderDecoratedBox({
    Color? color,
  }) : _color = color;

  Color? _color;
  Color? get color => _color;
  set color(Color? value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_color case final color?) {
      final size = this.size;
      context.canvas.drawRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy - 2,
          size.width,
          size.height + 2,
        ),
        Paint()..color = color,
      );
    }
    super.paint(context, offset);
  }

  @override
  bool hitTestSelf(Offset position) => true;
}
