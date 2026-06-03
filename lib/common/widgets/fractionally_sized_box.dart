import 'dart:math' as math;

import 'package:flutter/rendering.dart' show RenderFractionallySizedOverflowBox;
import 'package:flutter/widgets.dart';

class CustomFractionallySizedBox extends FractionallySizedBox {
  const CustomFractionallySizedBox({
    super.key,
    super.alignment,
    required double super.widthFactor,
    required double super.heightFactor,
    required this.maxWidth,
    super.child,
  });

  final double maxWidth;

  @override
  RenderFractionallySizedOverflowBox createRenderObject(BuildContext context) {
    return CustomRenderFractionallySizedOverflowBox(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      textDirection: Directionality.maybeOf(context),
      maxWidth: maxWidth,
    );
  }
}

class CustomRenderFractionallySizedOverflowBox
    extends RenderFractionallySizedOverflowBox {
  CustomRenderFractionallySizedOverflowBox({
    super.child,
    super.widthFactor,
    super.heightFactor,
    super.alignment,
    super.textDirection,
    required this._maxWidth,
  });

  final double _maxWidth;

  BoxConstraints _getInnerConstraints(BoxConstraints constraints) {
    double minWidth = constraints.minWidth;
    double maxWidth = constraints.maxWidth;
    if (widthFactor != null) {
      double width = maxWidth * widthFactor!;
      if (maxWidth > constraints.maxHeight) {
        width = math.min(_maxWidth, width);
      }
      minWidth = width;
      maxWidth = width;
    }
    double minHeight = constraints.minHeight;
    double maxHeight = constraints.maxHeight;
    if (heightFactor != null) {
      final double height = maxHeight * heightFactor!;
      minHeight = height;
      maxHeight = height;
    }
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (child != null) {
      final Size childSize = child!.getDryLayout(
        _getInnerConstraints(constraints),
      );
      return constraints.constrain(childSize);
    }
    return constraints.constrain(
      _getInnerConstraints(constraints).constrain(Size.zero),
    );
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final BoxConstraints childConstraints = _getInnerConstraints(constraints);
    final double? result = child.getDryBaseline(childConstraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(childConstraints);
    final Size size = getDryLayout(constraints);
    return result +
        resolvedAlignment.alongOffset(size - childSize as Offset).dy;
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(_getInnerConstraints(constraints), parentUsesSize: true);
      size = constraints.constrain(child!.size);
      alignChild();
    } else {
      size = constraints.constrain(
        _getInnerConstraints(constraints).constrain(Size.zero),
      );
    }
  }
}
