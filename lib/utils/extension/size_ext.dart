import 'dart:ui' show Size;

extension SizeExt on Size {
  bool get isPortrait => width < 600 || height >= width;
}
