import 'package:flutter/widgets.dart' show Orientation;
import 'package:nativeapi/nativeapi.dart' as nativeapi show Size, Rectangle;

extension SizeExt on nativeapi.Size {
  Orientation get orientation => height > width ? .portrait : .landscape;
}

extension RectangleExt on nativeapi.Rectangle {
  nativeapi.Size get size => nativeapi.Size(width: width, height: height);
}
