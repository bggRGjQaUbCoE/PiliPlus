import 'package:PiliPlus/models/common/badge_type.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PBadge extends StatelessWidget {
  final String? text;

  final bool isStack;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final EdgeInsets? padding;

  final PBadgeType type;
  final PBadgeSize size;

  final double fontSize;
  final bool isBold;
  final double? textScaleFactor;

  const PBadge({
    super.key,
    required this.text,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.type = PBadgeType.primary,
    this.size = PBadgeSize.medium,
    this.isStack = true,
    this.fontSize = 11,
    this.isBold = true,
    this.textScaleFactor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isNullOrEmpty) {
      return const SizedBox.shrink();
    }

    ColorScheme theme = Theme.of(context).colorScheme;

    Color bgColor;
    Color color;
    Color borderColor = Colors.transparent;

    switch (type) {
      case PBadgeType.primary:
        bgColor = theme.primary;
        color = theme.onPrimary;
      case PBadgeType.secondary:
        bgColor = theme.secondaryContainer.withValues(alpha: 0.5);
        color = theme.onSecondaryContainer;
      case PBadgeType.gray:
        bgColor = Colors.black45;
        color = Colors.white;
      case PBadgeType.error:
        if (Get.isDarkMode) {
          bgColor = theme.errorContainer;
          color = theme.onErrorContainer;
        } else {
          bgColor = theme.error;
          color = theme.onError;
        }
      case PBadgeType.line_primary:
        color = theme.primary;
        bgColor = Colors.transparent;
        borderColor = theme.primary;
      case PBadgeType.line_secondary:
        color = theme.secondary;
        bgColor = Colors.transparent;
        borderColor = theme.secondary;
      case PBadgeType.free:
        bgColor = theme.freeColor;
        color = Colors.white;
      case PBadgeType.shop:
        bgColor = theme.secondaryContainer.withValues(alpha: 0.5);
        color = theme.onSurfaceVariant;
    }

    late EdgeInsets paddingStyle = const EdgeInsets.symmetric(
      vertical: 2,
      horizontal: 3,
    );
    BorderRadius br = size == PBadgeSize.small
        ? const BorderRadius.all(Radius.circular(3))
        : const BorderRadius.all(Radius.circular(4));

    Widget content = Container(
      padding: padding ?? paddingStyle,
      decoration: BoxDecoration(
        borderRadius: br,
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text!,
        textScaler: textScaleFactor != null
            ? TextScaler.linear(textScaleFactor!)
            : null,
        style: TextStyle(
          height: 1,
          fontSize: fontSize,
          color: color,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
        strutStyle: StrutStyle(
          leading: 0,
          height: 1,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : null,
        ),
      ),
    );
    if (isStack) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: content,
      );
    } else {
      return content;
    }
  }
}
