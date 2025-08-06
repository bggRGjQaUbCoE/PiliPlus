import 'dart:math' show pi;

import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.icon,
    this.selectIcon,
    this.onTap,
    this.onLongPress,
    this.text,
    this.selectStatus = false,
    required this.semanticsLabel,
    this.expand = true,
    this.animation,
    this.onStartTriple,
    this.onCancelTriple,
  }) : assert(!selectStatus || selectIcon != null),
       _isThumbsUp = onStartTriple != null;

  final Icon icon;
  final Icon? selectIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? text;
  final bool selectStatus;
  final String semanticsLabel;
  final bool expand;
  final Animation<double>? animation;
  final VoidCallback? onStartTriple;
  final void Function([bool])? onCancelTriple;
  final bool _isThumbsUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget child = Icon(
      selectStatus ? selectIcon!.icon! : icon.icon,
      size: 18,
      color: selectStatus
          ? theme.colorScheme.primary
          : icon.color ?? theme.colorScheme.outline,
    );

    if (animation != null) {
      child = Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: animation!,
            builder: (context, child) => CustomPaint(
              size: const Size.square(28),
              painter: _ArcPainter(
                color: theme.colorScheme.primary,
                sweepAngle: animation!.value,
              ),
            ),
          ),
          child,
        ],
      );
    } else {
      child = SizedBox.square(dimension: 28, child: child);
    }

    child = InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      onTap: _isThumbsUp ? null : onTap,
      onLongPress: _isThumbsUp ? null : onLongPress,
      onTapDown: _isThumbsUp ? (_) => onStartTriple!() : null,
      onTapUp: _isThumbsUp ? (_) => onCancelTriple!(true) : null,
      onTapCancel: _isThumbsUp ? onCancelTriple : null,
      child: expand
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [child, _buildText(theme)],
            )
          : child,
    );
    return expand
        ? Expanded(child: child)
        : Material(type: MaterialType.transparency, child: child);
  }

  Widget _buildText(ThemeData theme) {
    final hasText = text != null;
    final child = Text(
      hasText ? text! : '-',
      key: hasText ? ValueKey(text!) : null,
      style: TextStyle(
        color: selectStatus
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
        fontSize: theme.textTheme.labelSmall!.fontSize,
      ),
    );
    if (hasText) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: child,
      );
    }
    return child;
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.color,
    required this.sweepAngle,
  });
  final Color color;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    const startAngle = -pi / 2;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
