import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchText extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onTap;
  final ValueChanged<String>? onLongPress;
  final double? fontSize;
  final Color? bgColor;
  final Color? textColor;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const SearchText({
    super.key,
    required this.text,
    this.onTap,
    this.onLongPress,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.textAlign,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    final hasLongPress = onLongPress != null;
    return Material(
      color: bgColor ?? colorScheme.onInverseSurface,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: InkWell(
        onTap: () => onTap?.call(text),
        onLongPress: hasLongPress ? () => onLongPress!(text) : null,
        onSecondaryTap: hasLongPress && !Utils.isMobile
            ? () => onLongPress!(text)
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          child: Text(
            text,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
