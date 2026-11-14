import 'package:PiliPlus/common/widgets/flutter/refresh_indicator.dart'
    as refresh show displacement, kIndicatorSize;
import 'package:PiliPlus/common/widgets/slotted_layout_helper.dart';
import 'package:flutter/rendering.dart' show BoxHitTestResult, ClipRectLayer;
import 'package:material_ui/material_ui.dart' hide RefreshIndicatorStatus;

enum RefreshType { indicator, body }

class RefreshLayout
    extends SlottedMultiChildRenderObjectWidget<RefreshType, RenderBox> {
  const RefreshLayout({
    super.key,
    required this.scale,
    required this.position,
    required this.indicator,
    required this.body,
    this.displacement,
  });

  final Animation<double> scale;
  final Animation<double> position;
  final Widget? indicator;
  final Widget body;

  /// 单个页面的下拉位移，null 时沿用全局设置
  final double? displacement;

  @override
  Iterable<RefreshType> get slots => RefreshType.values;

  @override
  Widget? childForSlot(slot) => switch (slot) {
    .indicator => indicator,
    .body => body,
  };

  @override
  RenderRefreshLayout createRenderObject(BuildContext context) {
    return RenderRefreshLayout(
      scale: scale,
      position: position,
      displacement: displacement,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderRefreshLayout renderObject,
  ) {
    renderObject
      ..scale = scale
      ..position = position
      ..displacement = displacement;
  }
}

class RenderRefreshLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<RefreshType, RenderBox> {
  RenderRefreshLayout({
    required Animation<double> scale,
    required Animation<double> position,
    double? displacement,
  }) : _scale = scale,
       _position = position,
       _displacement = displacement {
    _scale.addListener(_scaleListener);
    _position.addListener(_positionListener);
  }

  Animation<double> _scale;
  Animation<double> get scale => _scale;
  set scale(Animation<double> value) {
    if (_scale == value) return;
    _scale.removeListener(_scaleListener);
    _scale = value..addListener(_scaleListener);
    scaleFactor = value.value;
  }

  Animation<double> _position;
  Animation<double> get position => _position;
  set position(Animation<double> value) {
    if (_position == value) return;
    _position.removeListener(_positionListener);
    _position = value..addListener(_positionListener);
    heightFactor = value.value;
  }

  double? _displacement;

  /// 本实例生效的下拉位移，未指定时取全局值
  double get displacement => _displacement ?? refresh.displacement;
  set displacement(double? value) {
    if (_displacement == value) return;
    _displacement = value;
    _layoutIndicator();
    markNeedsPaint();
  }

  double _heightFactor = 0;
  double get heightFactor => _heightFactor;
  set heightFactor(double value) {
    if (_heightFactor == value) {
      return;
    }
    _heightFactor = value;
    _layoutIndicator();
    markNeedsPaint();
  }

  double _scaleFactor = 0;
  double get scaleFactor => _scaleFactor;
  set scaleFactor(double value) {
    if (_scaleFactor == value) {
      return;
    }
    _scaleFactor = value;
    _layoutIndicator();
    markNeedsPaint();
  }

  void _scaleListener() {
    scaleFactor = _scale.value;
  }

  void _positionListener() {
    heightFactor = _position.value;
  }

  @override
  void dispose() {
    _scale.removeListener(_scaleListener);
    _position.removeListener(_positionListener);
    super.dispose();
  }

  RenderBox? get indicatorChild => childForSlot(.indicator);
  RenderBox get body => childForSlot(.body)!;

  @override
  void performLayout() {
    final constraints = this.constraints;
    size = constraints.biggest;

    final body = this.body..layout(constraints);
    setOffset(body, .zero);

    _layoutIndicator();
  }

  void _layoutIndicator() {
    final box = indicatorChild;
    if (box == null) return;
    final scaleSize = refresh.kIndicatorSize * scaleFactor;
    box.layout(BoxConstraints.tightFor(width: scaleSize, height: scaleSize));
    setOffset(
      box,
      Offset(
        (constraints.maxWidth - scaleSize) / 2,
        (refresh.kIndicatorSize + displacement) * heightFactor -
            refresh.kIndicatorSize +
            (refresh.kIndicatorSize - scaleSize) / 2,
      ),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox child) {
      context.paintChild(child, getOffset(child) + offset);
    }

    doPaint(body);
    final box = indicatorChild;
    if (box != null && heightFactor > 0 && scaleFactor > 0) {
      final indicatorOffset = getOffset(box);
      if (indicatorOffset.dy > 0) {
        context.paintChild(box, indicatorOffset + offset);
        layer = null;
      } else {
        layer = context.pushClipRect(
          needsCompositing,
          offset,
          Offset.zero & size,
          (context, offset) {
            context.paintChild(box, indicatorOffset + offset);
          },
          clipBehavior: .hardEdge,
          oldLayer: layer as ClipRectLayer?,
        );
      }
    } else {
      layer = null;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final body = this.body;
    return result.addWithPaintOffset(
      offset: getOffset(body),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return body.hitTest(result, position: transformed);
      },
    );
  }
}
