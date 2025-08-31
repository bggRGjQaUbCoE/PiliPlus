import 'dart:math';

import 'package:PiliPlus/pages/video/introduction/ugc/widgets/action_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.msg = 'loading...',
    required this.progress,
  });

  ///loading msg
  final String msg;
  final RxDouble progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurfaceVariant = theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: theme.dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //loading animation
          RepaintBoundary.wrap(
            Obx(
              () => CustomPaint(
                size: const Size.square(40),
                painter: ArcPainter(
                  color: onSurfaceVariant,
                  strokeWidth: 3,
                  sweepAngle: progress.value * 2 * pi,
                ),
              ),
            ),
            0,
          ),
          //msg
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(msg, style: TextStyle(color: onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
