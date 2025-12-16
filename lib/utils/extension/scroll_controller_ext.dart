import 'package:flutter/widgets.dart';

extension ScrollControllerExt on ScrollController {
  void animToTop() => animTo(0);

  void animTo(
    double offset, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (!hasClients) return;
    if ((offset - this.offset).abs() >= position.viewportDimension * 7) {
      jumpTo(offset);
    } else {
      animateTo(
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
