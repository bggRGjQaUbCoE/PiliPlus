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

import 'dart:collection' show HashSet;
import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        MultiChildLayoutParentData,
        RenderBoxContainerDefaultsMixin,
        RenderObjectWithLayoutCallbackMixin,
        Constraints,
        LayoutCallback,
        BoxHitTestResult,
        ContainerParentDataMixin,
        InformationCollector,
        DiagnosticsDebugCreator,
        RenderObjectVisitor,
        SemanticsConfiguration;
import 'package:material_ui/material_ui.dart';

/// ref [LayoutBuilder]

const kFooterId = Object();

typedef OpusGridInfo = ({
  int crossAxisCount,
  double childCrossAxisExtent,
  double childMainAxisExtent,
});

class OpusGridDelegate {
  const OpusGridDelegate({
    required this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    required this.childAspectRatio,
    this.mainAxisExtent = 0,
  });

  final double maxCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double mainAxisExtent;

  OpusGridInfo calcCrossAxisCount(BoxConstraints constraints) {
    final crossAxisCount = math.max(
      1,
      (constraints.maxWidth / (maxCrossAxisExtent + crossAxisSpacing)).ceil(),
    );
    final double usableCrossAxisExtent = math.max(
      0.0,
      constraints.maxWidth - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent =
        mainAxisExtent + childCrossAxisExtent / childAspectRatio;
    return (
      crossAxisCount: crossAxisCount,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
    );
  }

  bool shouldRelayout(OpusGridDelegate oldDelegate) {
    return oldDelegate.maxCrossAxisExtent != maxCrossAxisExtent ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio ||
        oldDelegate.mainAxisExtent != mainAxisExtent;
  }
}

class OpusGridDelegateFixedMainAxisExtent extends OpusGridDelegate {
  const OpusGridDelegateFixedMainAxisExtent({
    required super.maxCrossAxisExtent,
    super.mainAxisSpacing,
    super.crossAxisSpacing,
    required super.mainAxisExtent,
  }) : super(childAspectRatio: 1);

  @override
  OpusGridInfo calcCrossAxisCount(BoxConstraints constraints) {
    final crossAxisCount = math.max(
      1,
      (constraints.maxWidth / (maxCrossAxisExtent + crossAxisSpacing)).ceil(),
    );
    final double usableCrossAxisExtent = math.max(
      0.0,
      constraints.maxWidth - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    return (
      crossAxisCount: crossAxisCount,
      childMainAxisExtent: mainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
    );
  }
}

class OpusGridBuilder extends RenderObjectWidget {
  const OpusGridBuilder({
    super.key,
    this.expand = false,
    required this.childCount,
    required this.gridDelegate,
    required this.builder,
  });

  final bool expand;
  final int childCount;
  final OpusGridDelegate gridDelegate;
  final List<Widget> Function(BuildContext context, OpusGridInfo opusGridInfo)
  builder;

  @protected
  bool updateShouldRebuild(OpusGridBuilder oldWidget) => true;

  @override
  OpusGridRenderObjectElement createElement() =>
      OpusGridRenderObjectElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderOpusGrid(
      expand: expand,
      childCount: childCount,
      gridDelegate: gridDelegate,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderOpusGrid renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      .._expand = expand
      .._childCount = childCount
      ..gridDelegate = gridDelegate;
  }
}

class RenderOpusGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>,
        RenderObjectWithLayoutCallbackMixin {
  RenderOpusGrid({
    required this._expand,
    required this._childCount,
    required this._gridDelegate,
  });

  bool _expand;
  int _childCount;
  OpusGridInfo? _opusGridInfo;

  OpusGridDelegate _gridDelegate;
  OpusGridDelegate get gridDelegate => _gridDelegate;
  set gridDelegate(OpusGridDelegate value) {
    if (_gridDelegate == value) return;
    final shouldRelayout = value.shouldRelayout(_gridDelegate);
    _gridDelegate = value;
    if (shouldRelayout) markNeedsLayout();
  }

  bool noNeedsRebuild(OpusGridInfo opusGridInfo, bool? lastExpand) {
    return lastExpand == _expand &&
        _opusGridInfo != null &&
        ((opusGridInfo.crossAxisCount == _opusGridInfo!.crossAxisCount) ||
            (opusGridInfo.crossAxisCount >= _childCount &&
                _opusGridInfo!.crossAxisCount >= _childCount));
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  LayoutCallback<Constraints>? _callback;

  void _updateCallback(LayoutCallback<Constraints> value) {
    if (value == _callback) {
      return;
    }
    _callback = value;
    scheduleLayoutCallback();
  }

  @override
  void layoutCallback() => _callback!(constraints);

  @protected
  BoxConstraints get layoutInfo => constraints;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    runLayoutCallback();
    final info = _opusGridInfo!;
    final crossAxisCount = info.crossAxisCount;
    final childWidth = info.childCrossAxisExtent;
    final childHeight = info.childMainAxisExtent;
    final childConstraints = BoxConstraints.tightFor(
      width: childWidth,
      height: childHeight,
    );
    RenderBox? child = firstChild;

    bool hasFooter = false;
    double gridHeight = 0;
    double footerHeight = 0;

    void calcGridHeight() {
      final row = ((hasFooter ? childCount - 1 : childCount) / crossAxisCount)
          .ceil();
      gridHeight =
          row * childHeight + gridDelegate.crossAxisSpacing * (row - 1);
    }

    int index = 0;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      if (childParentData.id == kFooterId) {
        hasFooter = true;
        calcGridHeight();
        footerHeight =
            (child..layout(constraints.loosen(), parentUsesSize: true))
                .size
                .height;
        childParentData.offset = Offset(0, gridHeight);
        break;
      } else {
        child.layout(childConstraints);
        childParentData.offset = Offset(
          (childWidth + gridDelegate.mainAxisSpacing) *
              (index % crossAxisCount),
          (childHeight + gridDelegate.crossAxisSpacing) *
              (index ~/ crossAxisCount),
        );
      }
      child = childParentData.nextSibling;
      index++;
    }
    if (!hasFooter) calcGridHeight();
    size = constraints.constrainDimensions(
      constraints.maxWidth,
      gridHeight + footerHeight,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    RenderBox? child = firstChild;
    while (child != null) {
      visitor(child);
      child = (child.parentData as MultiChildLayoutParentData).nextSibling;
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config
      ..explicitChildNodes = true
      ..isSemanticBoundary = true;
  }
}

class OpusGridRenderObjectElement extends RenderObjectElement {
  OpusGridRenderObjectElement(OpusGridBuilder super.widget);

  @override
  RenderOpusGrid get renderObject {
    return super.renderObject as RenderOpusGrid;
  }

  @protected
  @visibleForTesting
  Iterable<Element> get children =>
      _children!.where((Element child) => !_forgottenChildren.contains(child));

  List<Element>? _children;
  // We keep a set of forgotten children to avoid O(n^2) work walking _children
  // repeatedly to remove children.
  final Set<Element> _forgottenChildren = HashSet<Element>();

  @override
  void insertRenderObjectChild(RenderObject child, IndexedSlot<Element?> slot) {
    final ContainerRenderObjectMixin<
      RenderObject,
      ContainerParentDataMixin<RenderObject>
    >
    renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child, after: slot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(
    RenderObject child,
    IndexedSlot<Element?> oldSlot,
    IndexedSlot<Element?> newSlot,
  ) {
    final ContainerRenderObjectMixin<
      RenderObject,
      ContainerParentDataMixin<RenderObject>
    >
    renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.move(child, after: newSlot.value?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void removeRenderObjectChild(RenderObject child, Object? slot) {
    final ContainerRenderObjectMixin<
      RenderObject,
      ContainerParentDataMixin<RenderObject>
    >
    renderObject = this.renderObject;
    assert(child.parent == renderObject);
    renderObject.remove(child);
    assert(renderObject == this.renderObject);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_children == null) return;
    for (final Element child in _children!) {
      if (!_forgottenChildren.contains(child)) {
        visitor(child);
      }
    }
  }

  @override
  void forgetChild(Element child) {
    if (_children == null) return;
    assert(_children!.contains(child));
    assert(!_forgottenChildren.contains(child));
    _forgottenChildren.add(child);
    super.forgetChild(child);
  }

  bool _debugCheckHasAssociatedRenderObject(Element newChild) {
    assert(() {
      if (newChild.renderObject == null) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary(
                'The children of `MultiChildRenderObjectElement` must each has an associated render object.',
              ),
              ErrorHint(
                'This typically means that the `${newChild.widget}` or its children\n'
                'are not a subtype of `RenderObjectWidget`.',
              ),
              newChild.describeElement(
                'The following element does not have an associated render object',
              ),
              DiagnosticsDebugCreator(DebugCreator(newChild)),
            ]),
          ),
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Element inflateWidget(Widget newWidget, Object? newSlot) {
    final Element newChild = super.inflateWidget(newWidget, newSlot);
    assert(_debugCheckHasAssociatedRenderObject(newChild));
    return newChild;
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    renderObject._updateCallback(_rebuildWithConstraints);
  }

  @override
  void update(OpusGridBuilder newWidget) {
    super.update(newWidget);
    final multiChildRenderObjectWidget = widget as OpusGridBuilder;
    assert(widget == newWidget);
    renderObject._updateCallback(_rebuildWithConstraints);
    if (newWidget.updateShouldRebuild(multiChildRenderObjectWidget)) {
      _needsBuild = true;
      renderObject.scheduleLayoutCallback();
    }
  }

  @override
  void markNeedsBuild() {
    // Calling super.markNeedsBuild is not needed. This Element does not need
    // to performRebuild since this call already does what performRebuild does,
    // So the element is clean as soon as this method returns and does not have
    // to be added to the dirty list or marked as dirty.
    renderObject.scheduleLayoutCallback();
    _needsBuild = true;
  }

  @override
  void performRebuild() {
    // This gets called if markNeedsBuild() is called on us.
    // That might happen if, e.g., our builder uses Inherited widgets.

    // Force the callback to be called, even if the layout constraints are the
    // same. This is because that callback may depend on the updated widget
    // configuration, or an inherited widget.
    renderObject.scheduleLayoutCallback();
    _needsBuild = true;
    super.performRebuild(); // Calls widget.updateRenderObject (a no-op in this case).
  }

  @override
  void unmount() {
    renderObject._callback = null;
    super.unmount();
  }

  // The LayoutInfoType that was used to invoke the layout callback with last time,
  // during layout. The `_previousLayoutInfo` value is compared to the new one
  // to determine whether [LayoutBuilderBase.builder] needs to be called.
  BoxConstraints? _previousLayoutInfo;
  bool _needsBuild = true;

  bool? expand;
  void _rebuildWithConstraints(Constraints _) {
    final BoxConstraints layoutInfo = renderObject.layoutInfo;
    final widget = this.widget as OpusGridBuilder;
    final opusGridInfo = widget.gridDelegate.calcCrossAxisCount(layoutInfo);
    if (renderObject.noNeedsRebuild(opusGridInfo, expand)) {
      renderObject._opusGridInfo = opusGridInfo;
      return;
    }
    expand = renderObject._expand;

    @pragma('vm:notify-debugger-on-exception')
    void updateChildCallback() {
      List<Widget> built;
      try {
        assert(layoutInfo == renderObject.layoutInfo);
        built = widget.builder(this, renderObject._opusGridInfo = opusGridInfo);
      } catch (e, stack) {
        built = [
          ErrorWidget.builder(
            _reportException(
              ErrorDescription('building $widget'),
              e,
              stack,
              informationCollector: () => <DiagnosticsNode>[
                if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
              ],
            ),
          ),
        ];
      }
      try {
        if (_children == null) {
          final children = List<Element>.filled(
            built.length,
            _NullElement.instance,
          );
          Element? previousChild;
          for (var i = 0; i < children.length; i += 1) {
            final Element newChild = inflateWidget(
              built[i],
              IndexedSlot<Element?>(i, previousChild),
            );
            children[i] = newChild;
            previousChild = newChild;
          }
          _children = children;
        } else {
          _children = updateChildren(
            _children!,
            built,
            forgottenChildren: _forgottenChildren,
          );
        }
      } catch (e, stack) {
        built = [
          ErrorWidget.builder(
            _reportException(
              ErrorDescription('building $widget'),
              e,
              stack,
              informationCollector: () => <DiagnosticsNode>[
                if (kDebugMode) DiagnosticsDebugCreator(DebugCreator(this)),
              ],
            ),
          ),
        ];
        _children = updateChildren([], built);
      } finally {
        _needsBuild = false;
        _previousLayoutInfo = layoutInfo;
        _forgottenChildren.clear();
      }
    }

    final VoidCallback? callback =
        _needsBuild || (layoutInfo != _previousLayoutInfo)
        ? updateChildCallback
        : null;
    owner!.buildScope(this, callback);
  }
}

FlutterErrorDetails _reportException(
  DiagnosticsNode context,
  Object exception,
  StackTrace stack, {
  InformationCollector? informationCollector,
}) {
  final details = FlutterErrorDetails(
    exception: exception,
    stack: stack,
    library: 'widgets library',
    context: context,
    informationCollector: informationCollector,
  );
  FlutterError.reportError(details);
  return details;
}

class _NullElement extends Element {
  _NullElement() : super(const _NullWidget());

  static _NullElement instance = _NullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();
}

class _NullWidget extends Widget {
  const _NullWidget();

  @override
  Element createElement() => throw UnimplementedError();
}
