import 'package:flutter/material.dart';

/// Backend-neutral subtitle appearance and placement configuration.
///
/// Player adapters are responsible for converting this model to backend-specific
/// types. Flutter/Media3 subtitle rendering consumes it directly.
class PlayerSubtitleStyle {
  const PlayerSubtitleStyle({
    this.visible = true,
    this.style = const TextStyle(
      height: 1.4,
      fontSize: 32,
      color: Color(0xffffffff),
      fontWeight: FontWeight.normal,
      backgroundColor: Color(0xaa000000),
    ),
    this.strokeStyle,
    this.textAlign = TextAlign.center,
    this.textScaleFactor,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
  });

  final bool visible;
  final TextStyle style;
  final TextStyle? strokeStyle;
  final TextAlign textAlign;
  final double? textScaleFactor;
  final EdgeInsets padding;

  PlayerSubtitleStyle copyWith({
    bool? visible,
    TextStyle? style,
    TextStyle? strokeStyle,
    TextAlign? textAlign,
    double? textScaleFactor,
    EdgeInsets? padding,
  }) {
    return PlayerSubtitleStyle(
      visible: visible ?? this.visible,
      style: style ?? this.style,
      strokeStyle: strokeStyle ?? this.strokeStyle,
      textAlign: textAlign ?? this.textAlign,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerSubtitleStyle &&
          other.visible == visible &&
          other.style == style &&
          other.strokeStyle == strokeStyle &&
          other.textAlign == textAlign &&
          other.textScaleFactor == textScaleFactor &&
          other.padding == padding;

  @override
  int get hashCode => Object.hash(
    visible,
    style,
    strokeStyle,
    textAlign,
    textScaleFactor,
    padding,
  );
}
