import 'package:flutter/material.dart';

Widget iconButton({
  BuildContext? context,
  String? tooltip,
  required Widget icon,
  required VoidCallback? onPressed,
  double size = 36,
  double? iconSize,
  Color? bgColor,
  Color? iconColor,
}) {
  Color? backgroundColor = bgColor;
  Color? foregroundColor = iconColor;
  if (context != null) {
    final colorScheme = ColorScheme.of(context);
    backgroundColor = colorScheme.secondaryContainer;
    foregroundColor = colorScheme.onSecondaryContainer;
  }
  return SizedBox(
    width: size,
    height: size,
    child: IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        iconSize: iconSize ?? size / 2,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    ),
  );
}
