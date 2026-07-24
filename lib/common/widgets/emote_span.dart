import 'package:flutter/widgets.dart' show WidgetSpan;

class EmoteSpan extends WidgetSpan {
  const EmoteSpan({
    required super.child,
    super.alignment,
    super.baseline,
    super.style,
    this.rawText,
  });

  @override
  // ignore: override_on_non_overriding_member
  final String? rawText;
}
