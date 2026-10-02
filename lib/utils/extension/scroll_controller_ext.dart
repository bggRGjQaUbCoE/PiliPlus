import 'package:flutter/widgets.dart' show ScrollController, Curves;

extension ScrollControllerExt on ScrollController {
  Future<void> animToTop() => animTo(0);

  Future<void> animTo(
    double offset, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (!hasClients) return Future<void>.value();
    if ((offset - this.offset).abs() >= position.viewportDimension * 7) {
      jumpTo(offset);
      return Future<void>.value();
    } else {
      return animateTo(
        offset,
        duration: duration,
        curve: Curves.easeInOut,
      );
    }
  }

  void jumpToTop() {
    if (!hasClients) return;
    jumpTo(0);
  }
}
