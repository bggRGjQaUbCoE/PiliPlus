import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:flutter/material.dart';

class SearchText extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onTap;
  final ValueChanged<String>? onLongPress;
  final double? fontSize;
  final Color? bgColor;
  final Color? textColor;
  final TextAlign? textAlign;
  final double? height;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  const SearchText({
    super.key,
    required this.text,
    this.onTap,
    this.onLongPress,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.textAlign,
    this.height,
    this.padding = const .symmetric(horizontal: 11, vertical: 5),
    this.borderRadius = const .all(.circular(6)),
  });

  @override
  Widget build(BuildContext context) {
    late final colorScheme = ColorScheme.of(context);
    final hasLongPress = onLongPress != null;
    return Material(
      color: bgColor ?? colorScheme.onInverseSurface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => onTap?.call(text),
        onLongPress: hasLongPress ? () => onLongPress!(text) : null,
        onSecondaryTap: hasLongPress && !PlatformUtils.isMobile
            ? () => onLongPress!(text)
            : null,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: fontSize,
              height: height,
              color: textColor ?? colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
