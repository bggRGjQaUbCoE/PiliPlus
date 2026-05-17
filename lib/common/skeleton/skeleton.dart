import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final Widget child;

  const Skeleton({super.key, required this.child});

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Color color;
  final matrix = Matrix4.identity();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000))
      ..addListener(_setState);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setState() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    color = ColorScheme.of(context).surface.withAlpha(10);
  }

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.transparent, color, color, Colors.transparent];
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
        final width = bounds.width;
        final height = bounds.height;
        matrix[12] = width * _controller.value;
        return ui.Gradient.linear(
          Offset(0, 0.35 * height),
          Offset(width, 0.95 * height),
          colors,
          const [0.1, 0.3, 0.5, 0.7],
          TileMode.clamp,
          matrix.storage,
        );
      },
      child: widget.child,
    );
  }
}
