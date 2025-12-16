import 'package:flutter/widgets.dart';

extension WidgetExt on Widget {
  Widget constraintWidth({
    BoxConstraints constraints = const BoxConstraints(maxWidth: 625),
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: constraints,
        child: this,
      ),
    );
  }
}
