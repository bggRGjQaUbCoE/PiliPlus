import 'package:flutter/rendering.dart' show RenderProxyBox;
import 'package:flutter/widgets.dart';

class SimpleColoredBox extends ColoredBox {
  const SimpleColoredBox({
    required super.color,
    super.isAntiAlias,
    super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSimpleColoredBox(color: color, isAntiAlias: isAntiAlias);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSimpleColoredBox renderObject,
  ) {
    renderObject
      ..color = color
      ..isAntiAlias = isAntiAlias;
  }
}

class RenderSimpleColoredBox extends RenderProxyBox {
  RenderSimpleColoredBox({
    required this._color,
    required this._isAntiAlias,
  });

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  bool get isAntiAlias => _isAntiAlias;
  bool _isAntiAlias;
  set isAntiAlias(bool value) {
    if (value == _isAntiAlias) {
      return;
    }
    _isAntiAlias = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size > Size.zero) {
      context.canvas.drawRect(
        offset & size,
        Paint()
          ..isAntiAlias = isAntiAlias
          ..color = color,
      );
    }
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }
}
