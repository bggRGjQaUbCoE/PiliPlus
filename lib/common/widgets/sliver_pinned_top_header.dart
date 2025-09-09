import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedTopPersistentHeader extends RenderObjectWidget {
  const SliverPinnedTopPersistentHeader({super.key, required this.child});

  final Widget child;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSliverPinnedPersistentHeaderForWidgets();
  }

  @override
  RenderObjectElement createElement() => _SliverPersistentHeaderElement(this);
}

class _SliverPersistentHeaderElement extends RenderObjectElement {
  _SliverPersistentHeaderElement(super.widget);

  @override
  _RenderSliverPinnedPersistentHeaderForWidgets get renderObject =>
      super.renderObject as _RenderSliverPinnedPersistentHeaderForWidgets;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._element = this;
  }

  @override
  void unmount() {
    renderObject._element = null;
    super.unmount();
  }

  @override
  void update(SliverPinnedTopPersistentHeader newWidget) {
    final SliverPinnedTopPersistentHeader oldWidget =
        widget as SliverPinnedTopPersistentHeader;
    super.update(newWidget);
    final newChild = newWidget.child;
    final oldChild = oldWidget.child;
    if (newChild != oldChild &&
        (newChild.runtimeType != oldChild.runtimeType ||
            newChild.key != oldChild.key)) {
      final renderObject = this.renderObject;
      _updateChild(newChild);
      renderObject.triggerRebuild();
    }
  }

  @override
  void performRebuild() {
    super.performRebuild();
    renderObject.triggerRebuild();
  }

  Element? child;

  void _updateChild(Widget widget) {
    child = updateChild(child, widget, null);
  }

  void _build() {
    owner!.buildScope(this, () {
      _updateChild((widget as SliverPinnedTopPersistentHeader).child);
    });
  }

  @override
  void forgetChild(Element child) {
    assert(child == this.child);
    this.child = null;
    super.forgetChild(child);
  }

  @override
  void insertRenderObjectChild(covariant RenderBox child, Object? slot) {
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
  }

  @override
  void moveRenderObjectChild(
    covariant RenderObject child,
    Object? oldSlot,
    Object? newSlot,
  ) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(covariant RenderObject child, Object? slot) {
    renderObject.child = null;
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (child != null) {
      visitor(child!);
    }
  }
}

abstract class RenderSliverPersistentHeader extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox>, RenderSliverHelpers {
  /// Creates a sliver that changes its size when scrolled to the start of the
  /// viewport.
  ///
  /// This is an abstract class; this constructor only initializes the [child].
  RenderSliverPersistentHeader({RenderBox? child}) {
    this.child = child;
  }

  /// The dimension of the child in the main axis.
  @protected
  double get childExtent {
    if (child == null) {
      return 0.0;
    }
    assert(child!.hasSize);
    return switch (constraints.axis) {
      Axis.vertical => child!.size.height,
      Axis.horizontal => child!.size.width,
    };
  }

  bool _needsUpdateChild = true;

  /// When this method is called by [layoutChild], the [child] can be set,
  /// mutated, or replaced. (It should not be called outside [layoutChild].)
  ///
  /// Any time this method would mutate the child, call [markNeedsLayout].
  @protected
  void updateChild() {}

  @override
  void markNeedsLayout() {
    // This is automatically called whenever the child's intrinsic dimensions
    // change, at which point we should remeasure them during the next layout.
    _needsUpdateChild = true;
    super.markNeedsLayout();
  }

  /// Lays out the [child].
  ///
  /// This is called by [performLayout]. It applies the given `scrollOffset`
  /// (which need not match the offset given by the [constraints]) and the
  /// `maxExtent` (which need not match the value returned by the [maxExtent]
  /// getter).
  ///
  /// The `overlapsContent` argument is passed to [updateChild].
  @protected
  void layoutChild() {
    if (_needsUpdateChild) {
      invokeLayoutCallback<SliverConstraints>((SliverConstraints constraints) {
        assert(constraints == this.constraints);
        updateChild();
      });
      _needsUpdateChild = false;
    }

    child?.layout(
      constraints.asBoxConstraints(
        maxExtent: constraints.viewportMainAxisExtent,
      ),
      parentUsesSize: true,
    );
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    assert(geometry!.hitTestExtent > 0.0);
    if (child != null) {
      return hitTestBoxChild(
        BoxHitTestResult.wrap(result),
        child!,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child == this.child);
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && geometry!.visible) {
      offset += switch (constraints.axisDirection) {
        AxisDirection.up => Offset(
          0.0,
          geometry!.paintExtent - childMainAxisPosition(child!) - childExtent,
        ),
        AxisDirection.left => Offset(
          geometry!.paintExtent - childMainAxisPosition(child!) - childExtent,
          0.0,
        ),
        AxisDirection.right => Offset(childMainAxisPosition(child!), 0.0),
        AxisDirection.down => Offset(0.0, childMainAxisPosition(child!)),
      };
      context.paintChild(child!, offset);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.addTagForChildren(RenderViewport.excludeFromScrolling);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DoubleProperty.lazy(
        'child position',
        () => childMainAxisPosition(child!),
      ),
    );
  }
}

abstract class RenderSliverPinnedPersistentHeader
    extends RenderSliverPersistentHeader {
  /// Creates a sliver that shrinks when it hits the start of the viewport, then
  /// stays pinned there.
  RenderSliverPinnedPersistentHeader({super.child});

  @override
  void performLayout() {
    layoutChild();
    final constraints = this.constraints;
    final maxExtent = childExtent;
    final remainExtent = constraints.remainingPaintExtent;

    final double overlap, paintExtent;
    switch (constraints.growthDirection) {
      case GrowthDirection.forward:
        overlap = constraints.overlap;
        paintExtent = math.min(
          maxExtent,
          math.max(0.0, remainExtent - overlap),
        );
        break;
      case GrowthDirection.reverse:
        overlap = math.min(0.0, remainExtent - maxExtent);
        paintExtent = math.max(
          maxExtent - constraints.scrollOffset,
          math.min(
            maxExtent,
            math.max(
              0.0,
              constraints.viewportMainAxisExtent - remainExtent - overlap,
            ),
          ),
        );
        break;
    }

    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: overlap,
      paintExtent: paintExtent,
      maxPaintExtent: maxExtent,
      maxScrollObstructionExtent: maxExtent,
      cacheExtent: calculateCacheOffset(constraints, from: 0.0, to: maxExtent),
      hasVisualOverflow:
          true, // Conservatively say we do have overflow to avoid complexity.
    );
  }

  @override
  /// [GrowthDirection.reverse] fail to pass assert, but execute as expected
  void debugAssertDoesMeetConstraints() {
    assert(
      geometry!.debugAssertIsValid(
        informationCollector: () => <DiagnosticsNode>[
          describeForError(
            'The RenderSliver that returned the offending geometry was',
          ),
        ],
      ),
    );
    // assert(() {
    //   if (geometry!.paintOrigin + geometry!.paintExtent > constraints.remainingPaintExtent) {
    //     throw FlutterError.fromParts(<DiagnosticsNode>[
    //       ErrorSummary(
    //         'SliverGeometry has a paintOffset that exceeds the remainingPaintExtent from the constraints.',
    //       ),
    //       describeForError(
    //         'The render object whose geometry violates the constraints is the following',
    //       ),
    //       ErrorDescription(
    //         'The remainingPaintExtent is ${constraints.remainingPaintExtent.toStringAsFixed(1)}, but '
    //         'the paintOrigin + paintExtent is ${(geometry!.paintOrigin + geometry!.paintExtent).toStringAsFixed(1)}.',
    //       ),
    //       ErrorDescription(
    //         'The paintOrigin and paintExtent must cause the child sliver to paint '
    //         'within the viewport, and so cannot exceed the remainingPaintExtent.',
    //       ),
    //     ]);
    //   }
    //   return true;
    // }());
  }

  @override
  double childMainAxisPosition(RenderBox child) => 0;
}

class _RenderSliverPinnedPersistentHeaderForWidgets
    extends RenderSliverPinnedPersistentHeader {
  _RenderSliverPinnedPersistentHeaderForWidgets();

  _SliverPersistentHeaderElement? _element;

  @override
  void updateChild() {
    assert(_element != null);
    _element!._build();
  }

  @protected
  void triggerRebuild() {
    markNeedsLayout();
  }
}
