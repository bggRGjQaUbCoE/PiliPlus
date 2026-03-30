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

import 'package:PiliPlus/common/style.dart';
import 'package:PiliPlus/common/widgets/image_grid/image_grid_view.dart'
    show ImageModel;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, LongPressGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show
        ContainerRenderObjectMixin,
        MultiChildLayoutParentData,
        RenderBoxContainerDefaultsMixin,
        RenderObjectWithLayoutCallbackMixin,
        Constraints,
        LayoutCallback,
        BoxHitTestResult,
        BoxHitTestEntry,
        ContainerParentDataMixin,
        InformationCollector,
        DiagnosticsDebugCreator;

/// ref [LayoutBuilder]

const space = 5.0;
typedef ImageGridInfo = ({int column, int row, Size size});

class ImageGridBuilder extends RenderObjectWidget {
  const ImageGridBuilder({
    super.key,
    required this.picArr,
    required this.onTap,
    required this.onSecondaryTapUp,
    required this.onLongPressStart,
    required this.builder,
  });

  final List<ImageModel> picArr;
  final ValueChanged<int> onTap;
  final OnShowMenu? onSecondaryTapUp;
  final OnShowMenu? onLongPressStart;
  final List<Widget> Function(BuildContext context, ImageGridInfo imageGridInfo)
  builder;

  @protected
  bool updateShouldRebuild(ImageGridBuilder oldWidget) => true;

  @override
  ImageGridRenderObjectElement createElement() =>
      ImageGridRenderObjectElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderImageGrid(
      onTap: onTap,
      onSecondaryTapUp: onSecondaryTapUp,
      onLongPressStart: onLongPressStart,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderImageGrid renderObject) {
    renderObject
      ..onTap = onTap
      ..onSecondaryTapUp = onSecondaryTapUp
      ..onLongPressStart = onLongPressStart;
  }
}

typedef OnShowMenu = Function(int index, Offset offset);

class RenderImageGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>,
        RenderObjectWithLayoutCallbackMixin {
  RenderImageGrid({
    required ValueChanged<int> onTap,
    required OnShowMenu? onSecondaryTapUp,
    required OnShowMenu? onLongPressStart,
  }) : _onTap = onTap,
       _onSecondaryTapUp = onSecondaryTapUp,
       _onLongPressStart = onLongPressStart {
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleOnTap;
    if (onSecondaryTapUp != null) {
      _tapGestureRecognizer.onSecondaryTapUp = _handleSecondaryTapUp;
    }
    if (onLongPressStart != null) {
      _longPressGestureRecognizer = LongPressGestureRecognizer()
        ..onLongPressStart = _handleLongPressStart;
    }
  }

  ValueChanged<int> _onTap;
  set onTap(ValueChanged<int> value) {
    _onTap = value;
  }

  OnShowMenu? _onSecondaryTapUp;
  set onSecondaryTapUp(OnShowMenu? value) {
    _onSecondaryTapUp = value;
  }

  OnShowMenu? _onLongPressStart;
  set onLongPressStart(OnShowMenu? value) {
    _onLongPressStart = value;
  }

  int? _index;

  void _handleOnTap() {
    _onTap(_index!);
  }

  void _handleSecondaryTapUp(TapUpDetails details) {
    _onSecondaryTapUp!(_index!, details.globalPosition);
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _onLongPressStart!(_index!, details.globalPosition);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  ImageGridInfo? imageGridInfo;
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
    final info = imageGridInfo!;
    final row = info.row;
    final column = info.column;
    final width = info.size.width;
    final height = info.size.height;
    final childConstraints = BoxConstraints.tightFor(
      width: width,
      height: height,
    );
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(childConstraints);
      final childParentData = child.parentData as MultiChildLayoutParentData;
      final index = childParentData.id as int;
      childParentData.offset = Offset(
        (space + width) * (index % column),
        (space + height) * (index ~/ column),
      );
      child = childParentData.nextSibling;
    }
    size = constraints.constrainDimensions(
      width * column + space * (column - 1),
      height * row + space * (row - 1),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final childParentData = child.parentData as MultiChildLayoutParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          if (child!.size.contains(transformed)) {
            result.add(BoxHitTestEntry(child, transformed));
            return true;
          }
          return false;
        },
      );
      if (isHit) {
        _index = childParentData.id as int;
        return true;
      }
      child = childParentData.previousSibling;
    }
    _index = null;
    return false;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
      _longPressGestureRecognizer?.addPointer(event);
    }
  }

  late final TapGestureRecognizer _tapGestureRecognizer;
  LongPressGestureRecognizer? _longPressGestureRecognizer;

  @override
  void dispose() {
    _tapGestureRecognizer
      ..onTap = null
      ..onSecondaryTapUp = null
      ..dispose();
    _longPressGestureRecognizer
      ?..onLongPressStart = null
      ..dispose();
    _longPressGestureRecognizer = null;
    _onSecondaryTapUp = null;
    _onLongPressStart = null;
    super.dispose();
  }

  @override
  bool get isRepaintBoundary => true; // gif repaint
}

class ImageGridRenderObjectElement extends RenderObjectElement {
  ImageGridRenderObjectElement(ImageGridBuilder super.widget);

  @override
  RenderImageGrid get renderObject {
    return super.renderObject as RenderImageGrid;
  }

  @protected
  @visibleForTesting
  Iterable<Element> get children =>
      _children!.where((Element child) => !_forgottenChildren.contains(child));

  List<Element>? _children;
  // We keep a set of forgotten children to avoid O(n^2) work walking _children
  // repeatedly to remove children.
  final Set<Element> _forgottenChildren = HashSet<Element>();

  // @override
  // BuildScope get buildScope => _buildScope;

  // late final BuildScope _buildScope = BuildScope(
  //   scheduleRebuild: _scheduleRebuild,
  // );

  // bool _deferredCallbackScheduled = false;
  // void _scheduleRebuild() {
  //   if (_deferredCallbackScheduled) {
  //     return;
  //   }

  //   final bool deferMarkNeedsLayout =
  //       switch (SchedulerBinding.instance.schedulerPhase) {
  //         SchedulerPhase.idle || SchedulerPhase.postFrameCallbacks => true,
  //         SchedulerPhase.transientCallbacks ||
  //         SchedulerPhase.midFrameMicrotasks ||
  //         SchedulerPhase.persistentCallbacks => false,
  //       };
  //   if (!deferMarkNeedsLayout) {
  //     renderObject.scheduleLayoutCallback();
  //     return;
  //   }
  //   _deferredCallbackScheduled = true;
  //   SchedulerBinding.instance.scheduleFrameCallback(_frameCallback);
  // }

  // void _frameCallback(Duration timestamp) {
  //   _deferredCallbackScheduled = false;
  //   // This method is only called when the render tree is stable, if the Element
  //   // is deactivated it will never be reincorporated back to the tree.
  //   if (mounted) {
  //     renderObject.scheduleLayoutCallback();
  //   }
  // }

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
    // final multiChildRenderObjectWidget = widget as MultiChildRenderObjectWidget;
    // final children = List<Element>.filled(
    //   multiChildRenderObjectWidget.children.length,
    //   _NullElement.instance,
    // );
    // Element? previousChild;
    // for (var i = 0; i < children.length; i += 1) {
    //   final Element newChild = inflateWidget(
    //     multiChildRenderObjectWidget.children[i],
    //     IndexedSlot<Element?>(i, previousChild),
    //   );
    //   children[i] = newChild;
    //   previousChild = newChild;
    // }
    // _children = children;
  }

  @override
  void update(ImageGridBuilder newWidget) {
    super.update(newWidget);
    final multiChildRenderObjectWidget = widget as ImageGridBuilder;
    assert(widget == newWidget);
    // _children = updateChildren(
    //   _children,
    //   multiChildRenderObjectWidget.children,
    //   forgottenChildren: _forgottenChildren,
    // );
    // _forgottenChildren.clear();
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
    super
        .performRebuild(); // Calls widget.updateRenderObject (a no-op in this case).
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

  static ImageGridInfo _calcGridInfo(
    List<ImageModel> picArr,
    BoxConstraints layoutInfo,
  ) {
    final maxWidth = layoutInfo.maxWidth;
    double imageWidth;
    double imageHeight;
    final length = picArr.length;
    final isSingle = length == 1;
    final isFour = length == 4;
    if (length == 2) {
      imageWidth = imageHeight = (maxWidth - space) / 2;
    } else {
      imageHeight = imageWidth = (maxWidth - 2 * space) / 3;
      if (isSingle) {
        final img = picArr.first;
        final width = img.width;
        final height = img.height;
        final ratioWH = width / height;
        final ratioHW = height / width;
        imageWidth = ratioWH > 1.5
            ? maxWidth
            : (ratioWH >= 1 || (height > width && ratioHW < 1.5))
            ? 2 * imageWidth
            : 1.5 * imageWidth;
        if (width != 1) {
          imageWidth = math.min(imageWidth, width.toDouble());
        }
        imageHeight = imageWidth * math.min(ratioHW, Style.imgMaxRatio);
      }
    }

    final int column = isFour ? 2 : 3;
    final int row = isFour ? 2 : (length / 3).ceil();

    return (
      row: row,
      column: column,
      size: Size(imageWidth, imageHeight),
    );
  }

  void _rebuildWithConstraints(Constraints _) {
    final BoxConstraints layoutInfo = renderObject.layoutInfo;
    @pragma('vm:notify-debugger-on-exception')
    void updateChildCallback() {
      List<Widget> built;
      try {
        assert(layoutInfo == renderObject.layoutInfo);
        built = (widget as ImageGridBuilder).builder(
          this,
          renderObject.imageGridInfo = _calcGridInfo(
            (widget as ImageGridBuilder).picArr,
            layoutInfo,
          ),
        );
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
