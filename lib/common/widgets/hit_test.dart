import 'package:flutter/rendering.dart' show RenderProxyBox;
import 'package:material_ui/material_ui.dart';

class HitTestWidget extends SingleChildRenderObjectWidget {
  const HitTestWidget({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => RenderHitTest();
}

class RenderHitTest extends RenderProxyBox {
  @override
  bool hitTestSelf(Offset position) => true;
}
