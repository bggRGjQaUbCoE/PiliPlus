import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Circular progress indicator for AI summary task
class AiSummaryProgressIndicator extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isComplete;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const AiSummaryProgressIndicator({
    super.key,
    required this.progress,
    this.isComplete = false,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = 36.0;

    if (isComplete) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onCancel,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surface,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
            ),
            // Progress arc
            CustomPaint(
              size: Size(size, size),
              painter: _ProgressPainter(
                progress: progress,
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            // Cancel button (square in center)
            Container(
              width: size * 0.4,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
