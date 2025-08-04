import 'package:PiliPlus/common/constants.dart';
import 'package:flutter/material.dart';

Widget selectMask(ThemeData theme, bool checked) {
  return AnimatedOpacity(
    opacity: checked ? 1 : 0,
    duration: const Duration(milliseconds: 200),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: StyleString.mdRadius,
        color: Colors.black.withValues(alpha: 0.6),
      ),
      child: AnimatedScale(
        scale: checked ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.done_all_outlined,
            color: theme.colorScheme.primary,
            semanticLabel: '取消选择',
          ),
        ),
      ),
    ),
  );
}
