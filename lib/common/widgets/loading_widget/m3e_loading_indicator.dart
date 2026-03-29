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

import 'package:PiliPlus/common/widgets/loading_widget/morphs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart' show SpringSimulation;
import 'package:flutter/semantics.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

/// reimplement of https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/loading_indicator_m3e

class M3ELoadingIndicator extends StatefulWidget {
  const M3ELoadingIndicator({
    super.key,
    // this.childKey,
    this.morphs,
    this.color,
    this.size = const Size.square(40),
  });
  final List<Morph>? morphs;

  final Color? color;
  final Size size;
  // final Key? childKey;

  @override
  State<M3ELoadingIndicator> createState() => _M3ELoadingIndicatorState();
}

class _M3ELoadingIndicatorState extends State<M3ELoadingIndicator>
    with SingleTickerProviderStateMixin {
  static const int _morphIntervalMs = 650;
  static const double _fullRotation = 2 * math.pi;
  static const int _globalRotationDurationMs = 4666;
  static const double _quarterRotation = _fullRotation / 4;

  late final List<Morph> _morphs;
  late final AnimationController _controller;

  int _morphIndex = 1;

  double _morphRotationTarget = _quarterRotation;

  static final _morphAnimationSpec = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.6, stiffness: 200.0, mass: 1.0),
    0.0,
    1.0,
    5.0,
    snapToEnd: true,
    // tolerance: const Tolerance(velocity: 0.1, distance: 0.1),
  );

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _morphIndex++;
    _morphRotationTarget =
        (_morphRotationTarget + _quarterRotation) % _fullRotation;
    _controller.animateWith(_morphAnimationSpec);
  }

  @override
  void initState() {
    super.initState();
    _morphs = widget.morphs ?? Morphs.loadingMorphs;
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: _morphIntervalMs),
          )
          ..addStatusListener(_statusListener)
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
    final globalRotation =
        (elapsedInMs % _globalRotationDurationMs) /
        _globalRotationDurationMs *
        _fullRotation;

    return progress * _quarterRotation + _morphRotationTarget + globalRotation;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? ColorScheme.of(context).secondaryFixedDim;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return RawM3ELoadingIndicator(
          // key: widget.childKey,
          morph: _morphs[_morphIndex % _morphs.length],
          progress: progress,
          angle: _calcAngle(progress),
          color: color,
          size: widget.size,
        );
      },
    );
  }
}

class RawM3ELoadingIndicator extends LeafRenderObjectWidget {
  const RawM3ELoadingIndicator({
    super.key,
    required this.morph,
    required this.progress,
    required this.angle,
    required this.color,
    required this.size,
  });

  final Morph morph;
  final double progress;
  final double angle;
  final Color color;
  final Size size;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderM3ELoadingIndicator(
      morph: morph,
      progress: progress,
      angle: angle,
      color: color,
      size: size,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderM3ELoadingIndicator renderObject,
  ) {
    renderObject
      ..morph = morph
      ..progress = progress
      ..angle = angle
      ..color = color
      ..preferredSize = size;
  }
}

class RenderM3ELoadingIndicator extends RenderBox {
  RenderM3ELoadingIndicator({
    required Morph morph,
    required double progress,
    required double angle,
    required Color color,
    required Size size,
  }) : _morph = morph,
       _progress = progress,
       _angle = angle,
       _preferredSize = size,
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

  Size _preferredSize;
  set preferredSize(Size value) {
    if (_preferredSize == value) return;
    _preferredSize = size;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrain(_preferredSize);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.role = .loadingSpinner;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final width = size.width;
    final value = size.width / 2;
    final matrix =
        Matrix4.translationValues(offset.dx + value, offset.dy + value, 0.0)
          ..rotateZ(angle)
          ..translateByDouble(-value, -value, 0.0, 1.0)
          ..scaleByDouble(width, width, width, 1.0);
    final path = morph.toPath(progress: progress).transform(matrix.storage);

    context.canvas.drawPath(path, _paint);
  }
}
