import 'package:flutter/rendering.dart' show RenderProxyBox, BoxHitTestResult;
import 'package:flutter/widgets.dart';

class ExtraHitTestWidget extends SingleChildRenderObjectWidget {
  const ExtraHitTestWidget({
    super.key,
    required this.width,
    required Widget super.child,
  });

  final double width;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderExtraHitTestWidget(width: width);
  }
}

class RenderExtraHitTestWidget extends RenderProxyBox {
  RenderExtraHitTestWidget({
    required double width,
  }) : _width = width;

  final double _width;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return super.hitTestChildren(result, position: position) ||
        position.dx <= _width;
  }
}
