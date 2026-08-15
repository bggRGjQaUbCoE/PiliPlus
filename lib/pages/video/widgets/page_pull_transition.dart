import 'package:flutter/material.dart';

class PagePullVideoExpansion extends StatelessWidget {
  const PagePullVideoExpansion({
    required this.animation,
    required this.normalHeight,
    required this.expandedHeight,
    required this.builder,
    super.key,
  });

  final Animation<double> animation;
  final double normalHeight;
  final double expandedHeight;
  final Widget Function(BuildContext context, double height) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = animation.value;
        final height = expandedHeight <= normalHeight
            ? normalHeight
            : normalHeight + (expandedHeight - normalHeight) * progress;
        final child = builder(context, height);
        if (height == normalHeight) return child;
        return OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: height,
          maxHeight: height,
          child: SizedBox(
            height: height,
            child: ColoredBox(
              color: Colors.black,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class PagePullBodyTranslation extends StatelessWidget {
  const PagePullBodyTranslation({
    required this.animation,
    required this.travelDistance,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final double travelDistance;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final offset = travelDistance * animation.value;
        if (offset == 0) return child!;
        return Transform.translate(offset: Offset(0, offset), child: child);
      },
    );
  }
}
