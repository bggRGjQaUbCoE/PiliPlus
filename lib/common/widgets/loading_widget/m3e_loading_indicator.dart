/*
 * This file is part of PiliPlus
 *
 * PiliPlus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * PiliPlus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PiliPlus.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringSimulation;
import 'package:material_new_shapes/material_new_shapes.dart';

/// reimplement of https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/loading_indicator_m3e

class M3ELoadingIndicator extends StatefulWidget {
  const M3ELoadingIndicator({super.key});

  @override
  State<M3ELoadingIndicator> createState() => _M3ELoadingIndicatorState();
}

class _M3ELoadingIndicatorState extends State<M3ELoadingIndicator>
    with SingleTickerProviderStateMixin {
  static final List<Morph> _morphs = () {
    final List<RoundedPolygon> shapes = [
      MaterialShapes.softBurst,
      MaterialShapes.cookie9Sided,
      MaterialShapes.pentagon,
      MaterialShapes.pill,
      MaterialShapes.sunny,
      MaterialShapes.cookie4Sided,
      MaterialShapes.oval,
    ];
    return [
      for (var i = 0; i < shapes.length; i++)
        Morph(
          shapes[i],
          shapes[(i + 1) % shapes.length],
        ),
    ];
  }();

  static const int _morphIntervalMs = 650;
  static const double _fullRotation = 360.0;
  static const int _globalRotationDurationMs = 4666;
  static const double _quarterRotation = _fullRotation / 4;

  late final AnimationController _controller;

  int _morphIndex = 1;

  double _morphRotationTargetAngle = _quarterRotation;

  final _morphAnimationSpec = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.6, stiffness: 200.0, mass: 1.0),
    0.0,
    1.0,
    5.0,
    snapToEnd: true,
  );

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _morphIndex++;
    _morphRotationTargetAngle =
        (_morphRotationTargetAngle + _quarterRotation) % _fullRotation;
    _controller
      ..value = 0.0
      ..animateWith(_morphAnimationSpec);
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: _morphIntervalMs),
          )
          ..addStatusListener(_statusListener)
          ..value = 0.0
          ..animateWith(_morphAnimationSpec);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_statusListener)
      ..dispose();
    super.dispose();
  }

  double _calcAngle(double progress) {
    final elapsedInMs =
        _morphIntervalMs * (_morphIndex - 1) +
        (_controller.lastElapsedDuration?.inMilliseconds ?? 0);
    final globalRotationControllerValue =
        (elapsedInMs % _globalRotationDurationMs) / _globalRotationDurationMs;
    final globalRotationDegrees = globalRotationControllerValue * _fullRotation;
    final totalRotationDegrees =
        progress * _quarterRotation +
        _morphRotationTargetAngle +
        globalRotationDegrees;
    return totalRotationDegrees * (math.pi / 180.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondaryFixedDim;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return _M3ELoadingIndicator(
          morph: _morphs[_morphIndex % _morphs.length],
          progress: progress,
          angle: _calcAngle(progress),
          color: color,
        );
      },
    );
  }
}

class _M3ELoadingIndicator extends LeafRenderObjectWidget {
  const _M3ELoadingIndicator({
    required this.morph,
    required this.progress,
    required this.angle,
    required this.color,
  });

  final Morph morph;

  final double progress;

  final double angle;

  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderM3ELoadingIndicator(
      morph: morph,
      progress: progress,
      angle: angle,
      color: color,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderM3ELoadingIndicator renderObject,
  ) {
    renderObject
      ..morph = morph
      ..progress = progress
      ..angle = angle
      ..color = color;
  }
}

class _RenderM3ELoadingIndicator extends RenderBox {
  _RenderM3ELoadingIndicator({
    required Morph morph,
    required double progress,
    required double angle,
    required Color color,
  }) : _morph = morph,
       _progress = progress,
       _angle = angle,
       _color = color,
       _paint = Paint()
         ..style = PaintingStyle.fill
         ..color = color;

  Morph _morph;
  Morph get morph => _morph;
  set morph(Morph value) {
    if (_morph == value) return;
    _morph = value;
    markNeedsPaint();
  }

  double _progress;
  double get progress => _progress;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsPaint();
  }

  double _angle;
  double get angle => _angle;
  set angle(double value) {
    if (_angle == value) return;
    _angle = value;
    markNeedsPaint();
  }

  Color _color;
  final Paint _paint;
  set color(Color value) {
    if (_color == value) return;
    _paint.color = _color = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = constraints.constrainDimensions(40, 40);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final width = size.width;
    final value = size.width / 2;
    final matrix = Matrix4.identity()
      ..translateByDouble(offset.dx + value, offset.dy + value, 0.0, 1.0)
      ..rotateZ(angle)
      ..translateByDouble(-value, -value, 0.0, 1.0)
      ..scaleByDouble(width, width, width, 1.0);
    final path = morph.toPath(progress: progress).transform(matrix.storage);

    context.canvas.drawPath(path, _paint);
  }
}
