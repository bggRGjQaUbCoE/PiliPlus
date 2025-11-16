// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: uri_does_not_exist_in_doc_import

/// @docImport 'package:flutter/material.dart';
///
/// @docImport 'page_storage.dart';
/// @docImport 'page_view.dart';
/// @docImport 'scroll_metrics.dart';
/// @docImport 'scroll_notification.dart';
/// @docImport 'scroll_view.dart';
/// @docImport 'single_child_scroll_view.dart';
/// @docImport 'two_dimensional_scroll_view.dart';
/// @docImport 'two_dimensional_viewport.dart';
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Scrollable, ScrollableState;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

export 'package:flutter/physics.dart' show Tolerance;

// The return type of _performEnsureVisible.
//
// The list of futures represents each pending ScrollPosition call to
// ensureVisible. The returned ScrollableState's context is used to find the
// next potential ancestor Scrollable.
typedef _EnsureVisibleResults = (List<Future<void>>, CustomScrollableState);

/// A widget that manages scrolling in one dimension and informs the [Viewport]
/// through which the content is viewed.
///
/// [CustomScrollable] implements the interaction model for a scrollable widget,
/// including gesture recognition, but does not have an opinion about how the
/// viewport, which actually displays the children, is constructed.
///
/// It's rare to construct a [CustomScrollable] directly. Instead, consider [ListView]
/// or [GridView], which combine scrolling, viewporting, and a layout model. To
/// combine layout models (or to use a custom layout mode), consider using
/// [CustomScrollView].
///
/// The static [CustomScrollable.of] and [CustomScrollable.ensureVisible] functions are
/// often used to interact with the [CustomScrollable] widget inside a [ListView] or
/// a [GridView].
///
/// To further customize scrolling behavior with a [CustomScrollable]:
///
/// 1. You can provide a [viewportBuilder] to customize the child model. For
///    example, [SingleChildScrollView] uses a viewport that displays a single
///    box child whereas [CustomScrollView] uses a [Viewport] or a
///    [ShrinkWrappingViewport], both of which display a list of slivers.
///
/// 2. You can provide a custom [ScrollController] that creates a custom
///    [ScrollPosition] subclass. For example, [PageView] uses a
///    [PageController], which creates a page-oriented scroll position subclass
///    that keeps the same page visible when the [CustomScrollable] resizes.
///
/// ## Persisting the scroll position during a session
///
/// Scrollables attempt to persist their scroll position using [PageStorage].
/// This can be disabled by setting [ScrollController.keepScrollOffset] to false
/// on the [controller]. If it is enabled, using a [PageStorageKey] for the
/// [key] of this widget (or one of its ancestors, e.g. a [ScrollView]) is
/// recommended to help disambiguate different [CustomScrollable]s from each other.
///
/// See also:
///
///  * [ListView], which is a commonly used [ScrollView] that displays a
///    scrolling, linear list of child widgets.
///  * [PageView], which is a scrolling list of child widgets that are each the
///    size of the viewport.
///  * [GridView], which is a [ScrollView] that displays a scrolling, 2D array
///    of child widgets.
///  * [CustomScrollView], which is a [ScrollView] that creates custom scroll
///    effects using slivers.
///  * [SingleChildScrollView], which is a scrollable widget that has a single
///    child.
///  * [ScrollNotification] and [NotificationListener], which can be used to watch
///    the scroll position without using a [ScrollController].
class CustomScrollable extends StatefulWidget {
  /// Creates a widget that scrolls.
  const CustomScrollable({
    super.key,
    this.axisDirection = AxisDirection.down,
    this.controller,
    this.physics,
    required this.viewportBuilder,
    this.incrementCalculator,
    this.excludeFromSemantics = false,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
    this.scrollBehavior,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.enableSlide,
    this.header,
    this.bgColor = Colors.transparent,
  }) : assert(semanticChildCount == null || semanticChildCount >= 0);

  final Widget? header;
  final bool? enableSlide;
  final Color bgColor;

  /// {@template flutter.widgets.Scrollable.axisDirection}
  /// The direction in which this widget scrolls.
  ///
  /// For example, if the [CustomScrollable.axisDirection] is [AxisDirection.down],
  /// increasing the scroll position will cause content below the bottom of the
  /// viewport to become visible through the viewport. Similarly, if the
  /// axisDirection is [AxisDirection.right], increasing the scroll position
  /// will cause content beyond the right edge of the viewport to become visible
  /// through the viewport.
  ///
  /// Defaults to [AxisDirection.down].
  /// {@endtemplate}
  final AxisDirection axisDirection;

  /// {@template flutter.widgets.Scrollable.controller}
  /// An object that can be used to control the position to which this widget is
  /// scrolled.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  ///
  /// If null, a [ScrollController] will be created internally by [CustomScrollable]
  /// in order to create and manage the [ScrollPosition].
  ///
  /// See also:
  ///
  ///  * [CustomScrollable.ensureVisible], which animates the scroll position to
  ///    reveal a given [BuildContext].
  /// {@endtemplate}
  final ScrollController? controller;

  /// {@template flutter.widgets.Scrollable.physics}
  /// How the widgets should respond to user input.
  ///
  /// For example, determines how the widget continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions via the physics provided from
  /// the ambient [ScrollConfiguration].
  ///
  /// If an explicit [ScrollBehavior] is provided to
  /// [CustomScrollable.scrollBehavior], the [ScrollPhysics] provided by that behavior
  /// will take precedence after [CustomScrollable.physics].
  ///
  /// The physics can be changed dynamically, but new physics will only take
  /// effect if the _class_ of the provided object changes. Merely constructing
  /// a new instance with a different configuration is insufficient to cause the
  /// physics to be reapplied. (This is because the final object used is
  /// generated dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  ///
  /// See also:
  ///
  ///  * [AlwaysScrollableScrollPhysics], which can be used to indicate that the
  ///    scrollable should react to scroll requests (and possible overscroll)
  ///    even if the scrollable's contents fit without scrolling being necessary.
  /// {@endtemplate}
  final ScrollPhysics? physics;

  /// Builds the viewport through which the scrollable content is displayed.
  ///
  /// A typical viewport uses the given [ViewportOffset] to determine which part
  /// of its content is actually visible through the viewport.
  ///
  /// See also:
  ///
  ///  * [Viewport], which is a viewport that displays a list of slivers.
  ///  * [ShrinkWrappingViewport], which is a viewport that displays a list of
  ///    slivers and sizes itself based on the size of the slivers.
  final ViewportBuilder viewportBuilder;

  /// {@template flutter.widgets.Scrollable.incrementCalculator}
  /// An optional function that will be called to calculate the distance to
  /// scroll when the scrollable is asked to scroll via the keyboard using a
  /// [ScrollAction].
  ///
  /// If not supplied, the [CustomScrollable] will scroll a default amount when a
  /// keyboard navigation key is pressed (e.g. pageUp/pageDown, control-upArrow,
  /// etc.), or otherwise invoked by a [ScrollAction].
  ///
  /// If [incrementCalculator] is null, the default for
  /// [ScrollIncrementType.page] is 80% of the size of the scroll window, and
  /// for [ScrollIncrementType.line], 50 logical pixels.
  /// {@endtemplate}
  final ScrollIncrementCalculator? incrementCalculator;

  /// {@template flutter.widgets.scrollable.excludeFromSemantics}
  /// Whether the scroll actions introduced by this [CustomScrollable] are exposed
  /// in the semantics tree.
  ///
  /// Text fields with an overflow are usually scrollable to make sure that the
  /// user can get to the beginning/end of the entered text. However, these
  /// scrolling actions are generally not exposed to the semantics layer.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [GestureDetector.excludeFromSemantics], which is used to accomplish the
  ///    exclusion.
  final bool excludeFromSemantics;

  /// {@template flutter.widgets.scrollable.hitTestBehavior}
  /// Defines the behavior of gesture detector used in this [CustomScrollable].
  ///
  /// This defaults to [HitTestBehavior.opaque] which means it prevents targets
  /// behind this [CustomScrollable] from receiving events.
  /// {@endtemplate}
  ///
  /// See also:
  ///
  ///  * [HitTestBehavior], for an explanation on different behaviors.
  final HitTestBehavior hitTestBehavior;

  /// The number of children that will contribute semantic information.
  ///
  /// The value will be null if the number of children is unknown or unbounded.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided.
  ///
  /// See also:
  ///
  ///  * [CustomScrollView], for an explanation of scroll semantics.
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics property.
  final int? semanticChildCount;

  // TODO(jslavitz): Set the DragStartBehavior default to be start across all widgets.
  /// {@template flutter.widgets.scrollable.dragStartBehavior}
  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], scrolling drag behavior will
  /// begin at the position where the drag gesture won the arena. If set to
  /// [DragStartBehavior.down] it will begin at the position where a down
  /// event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for
  ///    the different behaviors.
  ///
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.widgets.scrollable.restorationId}
  /// Restoration ID to save and restore the scroll offset of the scrollable.
  ///
  /// If a restoration id is provided, the scrollable will persist its current
  /// scroll offset and restore it during state restoration.
  ///
  /// The scroll offset is persisted in a [RestorationBucket] claimed from
  /// the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  /// {@endtemplate}
  final String? restorationId;

  /// {@template flutter.widgets.scrollable.scrollBehavior}
  /// A [ScrollBehavior] that will be applied to this widget individually.
  ///
  /// Defaults to null, wherein the inherited [ScrollBehavior] is copied and
  /// modified to alter the viewport decoration, like [Scrollbar]s.
  ///
  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  /// {@endtemplate}
  final ScrollBehavior? scrollBehavior;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  ///
  /// This is passed to decorators in [ScrollableDetails], and does not directly affect
  /// clipping of the [CustomScrollable]. This reflects the same [Clip] that is provided
  /// to [ScrollView.clipBehavior] and is supplied to the [Viewport].
  final Clip clipBehavior;

  /// The axis along which the scroll view scrolls.
  ///
  /// Determined by the [axisDirection].
  Axis get axis => axisDirectionToAxis(axisDirection);

  @override
  CustomScrollableState createState() => CustomScrollableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<AxisDirection>('axisDirection', axisDirection))
      ..add(DiagnosticsProperty<ScrollPhysics>('physics', physics))
      ..add(StringProperty('restorationId', restorationId));
  }

  /// The state from the closest instance of this class that encloses the given
  /// context, or null if none is found.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ScrollableState? scrollable = Scrollable.maybeOf(context);
  /// ```
  ///
  /// Calling this method will create a dependency on the [CustomScrollableState]
  /// that is returned, if there is one. This is typically the closest
  /// [CustomScrollable], but may be a more distant ancestor if [axis] is used to
  /// target a specific [CustomScrollable].
  ///
  /// Using the optional [Axis] is useful when Scrollables are nested and the
  /// target [CustomScrollable] is not the closest instance. When [axis] is provided,
  /// the nearest enclosing [CustomScrollableState] in that [Axis] is returned, or
  /// null if there is none.
  ///
  /// This finds the nearest _ancestor_ [CustomScrollable] of the `context`. This
  /// means that if the `context` is that of a [CustomScrollable], it will _not_ find
  /// _that_ [CustomScrollable].
  ///
  /// See also:
  ///
  /// * [CustomScrollable.of], which is similar to this method, but asserts
  ///   if no [CustomScrollable] ancestor is found.
  static CustomScrollableState? maybeOf(BuildContext context, {Axis? axis}) {
    // This is the context that will need to establish the dependency.
    final BuildContext originalContext = context;
    InheritedElement? element = context
        .getElementForInheritedWidgetOfExactType<_ScrollableScope>();
    while (element != null) {
      final CustomScrollableState scrollable =
          (element.widget as _ScrollableScope).scrollable;
      if (axis == null ||
          axisDirectionToAxis(scrollable.axisDirection) == axis) {
        // Establish the dependency on the correct context.
        originalContext.dependOnInheritedElement(element);
        return scrollable;
      }
      context = scrollable.context;
      element = context
          .getElementForInheritedWidgetOfExactType<_ScrollableScope>();
    }
    return null;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ScrollableState scrollable = Scrollable.of(context);
  /// ```
  ///
  /// Calling this method will create a dependency on the [CustomScrollableState]
  /// that is returned, if there is one. This is typically the closest
  /// [CustomScrollable], but may be a more distant ancestor if [axis] is used to
  /// target a specific [CustomScrollable].
  ///
  /// Using the optional [Axis] is useful when Scrollables are nested and the
  /// target [CustomScrollable] is not the closest instance. When [axis] is provided,
  /// the nearest enclosing [CustomScrollableState] in that [Axis] is returned.
  ///
  /// This finds the nearest _ancestor_ [CustomScrollable] of the `context`. This
  /// means that if the `context` is that of a [CustomScrollable], it will _not_ find
  /// _that_ [CustomScrollable].
  ///
  /// If no [CustomScrollable] ancestor is found, then this method will assert in
  /// debug mode, and throw an exception in release mode.
  ///
  /// See also:
  ///
  /// * [CustomScrollable.maybeOf], which is similar to this method, but returns null
  ///   if no [CustomScrollable] ancestor is found.
  static CustomScrollableState of(BuildContext context, {Axis? axis}) {
    final CustomScrollableState? scrollableState = maybeOf(context, axis: axis);
    assert(() {
      if (scrollableState == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'Scrollable.of() was called with a context that does not contain a '
            'Scrollable widget.',
          ),
          ErrorDescription(
            'No Scrollable widget ancestor could be found '
            '${axis == null ? '' : 'for the provided Axis: $axis '}'
            'starting from the context that was passed to Scrollable.of(). This '
            'can happen because you are using a widget that looks for a Scrollable '
            'ancestor, but no such ancestor exists.\n'
            'The context used was:\n'
            '  $context',
          ),
          if (axis != null)
            ErrorHint(
              'When specifying an axis, this method will only look for a Scrollable '
              'that matches the given Axis.',
            ),
        ]);
      }
      return true;
    }());
    return scrollableState!;
  }

  /// Provides a heuristic to determine if expensive frame-bound tasks should be
  /// deferred for the [context] at a specific point in time.
  ///
  /// Calling this method does _not_ create a dependency on any other widget.
  /// This also means that the value returned is only good for the point in time
  /// when it is called, and callers will not get updated if the value changes.
  ///
  /// The heuristic used is determined by the [physics] of this [CustomScrollable]
  /// via [ScrollPhysics.recommendDeferredLoading]. That method is called with
  /// the current [ScrollPosition.activity]'s [ScrollActivity.velocity].
  ///
  /// The optional [Axis] allows targeting of a specific [CustomScrollable] of that
  /// axis, useful when Scrollables are nested. When [axis] is provided,
  /// [ScrollPosition.recommendDeferredLoading] is called for the nearest
  /// [CustomScrollable] in that [Axis].
  ///
  /// If there is no [CustomScrollable] in the widget tree above the [context], this
  /// method returns false.
  static bool recommendDeferredLoadingForContext(
    BuildContext context, {
    Axis? axis,
  }) {
    _ScrollableScope? widget = context
        .getInheritedWidgetOfExactType<_ScrollableScope>();
    while (widget != null) {
      if (axis == null ||
          axisDirectionToAxis(widget.scrollable.axisDirection) == axis) {
        return widget.position.recommendDeferredLoading(context);
      }
      context = widget.scrollable.context;
      widget = context.getInheritedWidgetOfExactType<_ScrollableScope>();
    }
    return false;
  }

  /// Scrolls all scrollables that enclose the given context so as to make the
  /// given context visible.
  ///
  /// If a [CustomScrollable] enclosing the provided [BuildContext] is a
  /// [TwoDimensionalScrollable], both vertical and horizontal axes will ensure
  /// the target is made visible.
  static Future<void> ensureVisible(
    BuildContext context, {
    double alignment = 0.0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  }) {
    final List<Future<void>> futures = <Future<void>>[];

    // The targetRenderObject is used to record the first target renderObject.
    // If there are multiple scrollable widgets nested, the targetRenderObject
    // is made to be as visible as possible to improve the user experience. If
    // the targetRenderObject is already visible, then let the outer
    // renderObject be as visible as possible.
    //
    // Also see https://github.com/flutter/flutter/issues/65100
    RenderObject? targetRenderObject;
    CustomScrollableState? scrollable = CustomScrollable.maybeOf(context);
    while (scrollable != null) {
      final List<Future<void>> newFutures;
      (newFutures, scrollable) = scrollable._performEnsureVisible(
        context.findRenderObject()!,
        alignment: alignment,
        duration: duration,
        curve: curve,
        alignmentPolicy: alignmentPolicy,
        targetRenderObject: targetRenderObject,
      );
      futures.addAll(newFutures);

      targetRenderObject ??= context.findRenderObject();
      context = scrollable.context;
      scrollable = CustomScrollable.maybeOf(context);
    }

    if (futures.isEmpty || duration == Duration.zero) {
      return Future<void>.value();
    }
    if (futures.length == 1) {
      return futures.single;
    }
    return Future.wait<void>(futures).then<void>((List<void> _) => null);
  }
}

// Enable Scrollable.of() to work as if ScrollableState was an inherited widget.
// ScrollableState.build() always rebuilds its _ScrollableScope.
class _ScrollableScope extends InheritedWidget {
  const _ScrollableScope({
    required this.scrollable,
    required this.position,
    required super.child,
  });

  final CustomScrollableState scrollable;
  final ScrollPosition position;

  @override
  bool updateShouldNotify(_ScrollableScope old) {
    return position != old.position;
  }
}

/// State object for a [CustomScrollable] widget.
///
/// To manipulate a [CustomScrollable] widget's scroll position, use the object
/// obtained from the [position] property.
///
/// To be informed of when a [CustomScrollable] widget is scrolling, use a
/// [NotificationListener] to listen for [ScrollNotification] notifications.
///
/// This class is not intended to be subclassed. To specialize the behavior of a
/// [CustomScrollable], provide it with a [ScrollPhysics].
class CustomScrollableState extends State<CustomScrollable>
    with TickerProviderStateMixin, RestorationMixin
    implements ScrollContext {
  // GETTERS

  /// The manager for this [CustomScrollable] widget's viewport position.
  ///
  /// To control what kind of [ScrollPosition] is created for a [CustomScrollable],
  /// provide it with custom [ScrollController] that creates the appropriate
  /// [ScrollPosition] in its [ScrollController.createScrollPosition] method.
  ScrollPosition get position => _position!;
  ScrollPosition? _position;

  /// The resolved [ScrollPhysics] of the [CustomScrollableState].
  ScrollPhysics? get resolvedPhysics => _physics;
  ScrollPhysics? _physics;

  /// An [Offset] that represents the absolute distance from the origin, or 0,
  /// of the [ScrollPosition] expressed in the associated [Axis].
  ///
  /// Used by [EdgeDraggingAutoScroller] to progress the position forward when a
  /// drag gesture reaches the edge of the [Viewport].
  Offset get deltaToScrollOrigin => switch (axisDirection) {
    AxisDirection.up => Offset(0, -position.pixels),
    AxisDirection.down => Offset(0, position.pixels),
    AxisDirection.left => Offset(-position.pixels, 0),
    AxisDirection.right => Offset(position.pixels, 0),
  };

  ScrollController get _effectiveScrollController =>
      widget.controller ?? _fallbackScrollController!;

  @override
  AxisDirection get axisDirection => widget.axisDirection;

  @override
  TickerProvider get vsync => this;

  @override
  double get devicePixelRatio => _devicePixelRatio;
  late double _devicePixelRatio;

  @override
  BuildContext? get notificationContext => _gestureDetectorKey.currentContext;

  @override
  BuildContext get storageContext => context;

  @override
  String? get restorationId => widget.restorationId;
  final _RestorableScrollOffset _persistedScrollOffset =
      _RestorableScrollOffset();

  late ScrollBehavior _configuration;
  ScrollController? _fallbackScrollController;
  DeviceGestureSettings? _mediaQueryGestureSettings;

  // Only call this from places that will definitely trigger a rebuild.
  void _updatePosition() {
    _configuration = widget.scrollBehavior ?? ScrollConfiguration.of(context);
    final ScrollPhysics? physicsFromWidget =
        widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context);
    _physics = _configuration.getScrollPhysics(context);
    _physics = physicsFromWidget?.applyTo(_physics) ?? _physics;

    final ScrollPosition? oldPosition = _position;
    if (oldPosition != null) {
      _effectiveScrollController.detach(oldPosition);
      // It's important that we not dispose the old position until after the
      // viewport has had a chance to unregister its listeners from the old
      // position. So, schedule a microtask to do it.
      scheduleMicrotask(oldPosition.dispose);
    }

    _position = _effectiveScrollController.createScrollPosition(
      _physics!,
      this,
      oldPosition,
    );
    assert(_position != null);
    _effectiveScrollController.attach(position);
  }

  @protected
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_persistedScrollOffset, 'offset');
    assert(_position != null);
    if (_persistedScrollOffset.value != null) {
      position.restoreOffset(
        _persistedScrollOffset.value!,
        initialRestore: initialRestore,
      );
    }
  }

  @protected
  @override
  void saveOffset(double offset) {
    assert(debugIsSerializableForRestoration(offset));
    _persistedScrollOffset.value = offset;
    // [saveOffset] is called after a scrolling ends and it is usually not
    // followed by a frame. Therefore, manually flush restoration data.
    ServicesBinding.instance.restorationManager.flushData();
  }

  @protected
  @override
  void initState() {
    if (widget.controller == null) {
      _fallbackScrollController = ScrollController();
    }
    super.initState();
    _animController = AnimationController(
      vsync: this,
      reverseDuration: const Duration(milliseconds: 500),
    );
  }

  @protected
  @override
  void didChangeDependencies() {
    _mediaQueryGestureSettings = MediaQuery.maybeGestureSettingsOf(context);
    _devicePixelRatio =
        MediaQuery.maybeDevicePixelRatioOf(context) ??
        View.of(context).devicePixelRatio;
    _updatePosition();
    super.didChangeDependencies();
  }

  bool _shouldUpdatePosition(CustomScrollable oldWidget) {
    if ((widget.scrollBehavior == null) != (oldWidget.scrollBehavior == null)) {
      return true;
    }
    if (widget.scrollBehavior != null &&
        oldWidget.scrollBehavior != null &&
        widget.scrollBehavior!.shouldNotify(oldWidget.scrollBehavior!)) {
      return true;
    }
    ScrollPhysics? newPhysics =
        widget.physics ?? widget.scrollBehavior?.getScrollPhysics(context);
    ScrollPhysics? oldPhysics =
        oldWidget.physics ??
        oldWidget.scrollBehavior?.getScrollPhysics(context);
    do {
      if (newPhysics?.runtimeType != oldPhysics?.runtimeType) {
        return true;
      }
      newPhysics = newPhysics?.parent;
      oldPhysics = oldPhysics?.parent;
    } while (newPhysics != null || oldPhysics != null);

    return widget.controller?.runtimeType != oldWidget.controller?.runtimeType;
  }

  @protected
  @override
  void didUpdateWidget(CustomScrollable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        // The old controller was null, meaning the fallback cannot be null.
        // Dispose of the fallback.
        assert(_fallbackScrollController != null);
        assert(widget.controller != null);
        _fallbackScrollController!.detach(position);
        _fallbackScrollController!.dispose();
        _fallbackScrollController = null;
      } else {
        // The old controller was not null, detach.
        oldWidget.controller?.detach(position);
        if (widget.controller == null) {
          // If the new controller is null, we need to set up the fallback
          // ScrollController.
          _fallbackScrollController = ScrollController();
        }
      }
      // Attach the updated effective scroll controller.
      _effectiveScrollController.attach(position);
    }

    if (_shouldUpdatePosition(oldWidget)) {
      _updatePosition();
    }
  }

  @protected
  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.detach(position);
    } else {
      _fallbackScrollController?.detach(position);
      _fallbackScrollController?.dispose();
    }

    position.dispose();
    _persistedScrollOffset.dispose();

    _animController.dispose();
    super.dispose();
  }

  // SEMANTICS

  final GlobalKey _scrollSemanticsKey = GlobalKey();

  @override
  @protected
  void setSemanticsActions(Set<SemanticsAction> actions) {
    if (_gestureDetectorKey.currentState != null) {
      _gestureDetectorKey.currentState!.replaceSemanticsActions(actions);
    }
  }

  // GESTURE RECOGNITION AND POINTER IGNORING

  final GlobalKey<RawGestureDetectorState> _gestureDetectorKey =
      GlobalKey<RawGestureDetectorState>();
  final GlobalKey _ignorePointerKey = GlobalKey();

  // This field is set during layout, and then reused until the next time it is set.
  Map<Type, GestureRecognizerFactory> _gestureRecognizers =
      const <Type, GestureRecognizerFactory>{};
  bool _shouldIgnorePointer = false;

  bool? _lastCanDrag;
  Axis? _lastAxisDirection;

  late bool _isRTL = false;
  Offset? _downPos;
  bool? _isSliding;

  late AnimationController _animController;

  @override
  @protected
  void setCanDrag(bool value) {
    if (value == _lastCanDrag &&
        (!value || widget.axis == _lastAxisDirection)) {
      return;
    }
    if (!value) {
      _gestureRecognizers = const <Type, GestureRecognizerFactory>{};
      // Cancel the active hold/drag (if any) because the gesture recognizers
      // will soon be disposed by our RawGestureDetector, and we won't be
      // receiving pointer up events to cancel the hold/drag.
      _handleDragCancel();
    } else {
      switch (widget.axis) {
        case Axis.vertical:
          _gestureRecognizers = <Type, GestureRecognizerFactory>{
            VerticalDragGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  VerticalDragGestureRecognizer
                >(
                  () => VerticalDragGestureRecognizer(
                    supportedDevices: _configuration.dragDevices,
                  ),
                  (VerticalDragGestureRecognizer instance) {
                    instance
                      ..onDown = _handleDragDown
                      ..onStart = _handleDragStart
                      ..onUpdate = _handleDragUpdate
                      ..onEnd = _handleDragEnd
                      ..onCancel = _handleDragCancel
                      ..minFlingDistance = _physics?.minFlingDistance
                      ..minFlingVelocity = _physics?.minFlingVelocity
                      ..maxFlingVelocity = _physics?.maxFlingVelocity
                      ..velocityTrackerBuilder = _configuration
                          .velocityTrackerBuilder(context)
                      ..dragStartBehavior = widget.dragStartBehavior
                      ..multitouchDragStrategy = _configuration
                          .getMultitouchDragStrategy(context)
                      ..gestureSettings = _mediaQueryGestureSettings
                      ..supportedDevices = _configuration.dragDevices;
                  },
                ),
          };
        case Axis.horizontal:
          _gestureRecognizers = <Type, GestureRecognizerFactory>{
            HorizontalDragGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  HorizontalDragGestureRecognizer
                >(
                  () => HorizontalDragGestureRecognizer(
                    supportedDevices: _configuration.dragDevices,
                  ),
                  (HorizontalDragGestureRecognizer instance) {
                    instance
                      ..onDown = _handleDragDown
                      ..onStart = _handleDragStart
                      ..onUpdate = _handleDragUpdate
                      ..onEnd = _handleDragEnd
                      ..onCancel = _handleDragCancel
                      ..minFlingDistance = _physics?.minFlingDistance
                      ..minFlingVelocity = _physics?.minFlingVelocity
                      ..maxFlingVelocity = _physics?.maxFlingVelocity
                      ..velocityTrackerBuilder = _configuration
                          .velocityTrackerBuilder(context)
                      ..dragStartBehavior = widget.dragStartBehavior
                      ..multitouchDragStrategy = _configuration
                          .getMultitouchDragStrategy(context)
                      ..gestureSettings = _mediaQueryGestureSettings
                      ..supportedDevices = _configuration.dragDevices;
                  },
                ),
          };
      }
    }
    _lastCanDrag = value;
    _lastAxisDirection = widget.axis;
    if (_gestureDetectorKey.currentState != null) {
      _gestureDetectorKey.currentState!.replaceGestureRecognizers(
        _gestureRecognizers,
      );
    }
  }

  @override
  @protected
  void setIgnorePointer(bool value) {
    if (_shouldIgnorePointer == value) {
      return;
    }
    _shouldIgnorePointer = value;
    if (_ignorePointerKey.currentContext != null) {
      final RenderIgnorePointer renderBox =
          _ignorePointerKey.currentContext!.findRenderObject()!
              as RenderIgnorePointer;
      renderBox.ignoring = _shouldIgnorePointer;
    }
  }

  // TOUCH HANDLERS

  Drag? _drag;
  ScrollHoldController? _hold;

  void _handleDragDown(DragDownDetails details) {
    final dx = details.localPosition.dx;
    const offset = 30;
    final isLTR = dx <= offset;
    final isRTL = dx >= _maxWidth - offset;
    if (isLTR || isRTL) {
      _isRTL = isRTL;
      _downPos = details.localPosition;
      return;
    }
    assert(_drag == null);
    assert(_hold == null);
    _hold = position.hold(_disposeHold);
  }

  void _onPan(Offset localPosition) {
    if (_isSliding == false) {
      return;
    } else if (_isSliding == null) {
      if (_downPos != null) {
        Offset cumulativeDelta = localPosition - _downPos!;
        if (cumulativeDelta.dx.abs() >= cumulativeDelta.dy.abs()) {
          _downPos = localPosition;
          _isSliding = true;
        } else {
          _downPos = null;
          _isSliding = false;
        }
      } else {
        _downPos = null;
        _isSliding = false;
      }
    } else if (_isSliding == true) {
      final from = _downPos!.dx;
      final to = localPosition.dx;
      _animController.value =
          math.max(0, _isRTL ? from - to : to - from) / _maxWidth;
    }
  }

  void _onDismiss() {
    if (_isSliding == true) {
      final dx = _downPos!.dx;
      if (_animController.value * _maxWidth +
              (_isRTL ? (_maxWidth - dx) : dx) >=
          100) {
        Get.back();
      } else {
        _animController.reverse();
      }
    }
    _downPos = null;
    _isSliding = null;
  }

  void _handleDragStart(DragStartDetails details) {
    if (_downPos != null) {
      _onPan(details.localPosition);
      return;
    }
    // It's possible for _hold to become null between _handleDragDown and
    // _handleDragStart, for example if some user code calls jumpTo or otherwise
    // triggers a new activity to begin.
    assert(_drag == null);
    _drag = position.drag(details, _disposeDrag);
    assert(_drag != null);
    // _hold might be non-null if the scroll position is currently animating.
    if (_hold != null) {
      _disposeHold();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_downPos != null) {
      _onPan(details.localPosition);
      return;
    }
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_downPos != null) {
      _onDismiss();
      return;
    }
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    _drag?.end(details);
    assert(_drag == null);
  }

  void _handleDragCancel() {
    if (_downPos != null) {
      _onDismiss();
      return;
    }
    if (_gestureDetectorKey.currentContext == null) {
      // The cancel was caused by the GestureDetector getting disposed, which
      // means we will get disposed momentarily as well and shouldn't do
      // any work.
      return;
    }
    // _hold might be null if the drag started.
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    _hold?.cancel();
    _drag?.cancel();
    assert(_hold == null);
    assert(_drag == null);
  }

  void _disposeHold() {
    _hold = null;
  }

  void _disposeDrag() {
    _drag = null;
  }

  // SCROLL WHEEL

  // Returns the offset that should result from applying [event] to the current
  // position, taking min/max scroll extent into account.
  double _targetScrollOffsetForPointerScroll(double delta) {
    return math.min(
      math.max(position.pixels + delta, position.minScrollExtent),
      position.maxScrollExtent,
    );
  }

  // Returns the delta that should result from applying [event] with axis,
  // direction, and any modifiers specified by the ScrollBehavior taken into
  // account.
  double _pointerSignalEventDelta(PointerScrollEvent event) {
    final Set<LogicalKeyboardKey> pressed =
        HardwareKeyboard.instance.logicalKeysPressed;
    final bool flipAxes =
        pressed.any(_configuration.pointerAxisModifiers.contains) &&
        // Axes are only flipped for physical mouse wheel input.
        // On some platforms, like web, trackpad input is handled through pointer
        // signals, but should not be included in this axis modifying behavior.
        // This is because on a trackpad, all directional axes are available to
        // the user, while mouse scroll wheels typically are restricted to one
        // axis.
        event.kind == PointerDeviceKind.mouse;

    final Axis axis = flipAxes ? flipAxis(widget.axis) : widget.axis;
    final double delta = switch (axis) {
      Axis.horizontal => event.scrollDelta.dx,
      Axis.vertical => event.scrollDelta.dy,
    };

    return axisDirectionIsReversed(widget.axisDirection) ? -delta : delta;
  }

  void _receivedPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent && _position != null) {
      if (_physics != null && !_physics!.shouldAcceptUserOffset(position)) {
        // The handler won't use the `event`, so allow the platform to trigger
        // any default native actions.
        event.respond(allowPlatformDefault: true);
        return;
      }
      final double delta = _pointerSignalEventDelta(event);
      final double targetScrollOffset = _targetScrollOffsetForPointerScroll(
        delta,
      );
      // Only express interest in the event if it would actually result in a scroll.
      if (delta != 0.0 && targetScrollOffset != position.pixels) {
        GestureBinding.instance.pointerSignalResolver.register(
          event,
          _handlePointerScroll,
        );
        return;
      }
      // The `event` won't result in a scroll, so allow the platform to trigger
      // any default native actions.
      event.respond(allowPlatformDefault: true);
    } else if (event is PointerScrollInertiaCancelEvent) {
      position.pointerScroll(0);
      // Don't use the pointer signal resolver, all hit-tested scrollables should stop.
    }
  }

  void _handlePointerScroll(PointerEvent event) {
    assert(event is PointerScrollEvent);
    final double delta = _pointerSignalEventDelta(event as PointerScrollEvent);
    final double targetScrollOffset = _targetScrollOffsetForPointerScroll(
      delta,
    );
    if (delta != 0.0 && targetScrollOffset != position.pixels) {
      position.pointerScroll(delta);
    }
  }

  bool _handleScrollMetricsNotification(
    ScrollMetricsNotification notification,
  ) {
    if (notification.depth == 0) {
      final RenderObject? scrollSemanticsRenderObject = _scrollSemanticsKey
          .currentContext
          ?.findRenderObject();
      if (scrollSemanticsRenderObject != null) {
        scrollSemanticsRenderObject.markNeedsSemanticsUpdate();
      }
    }
    return false;
  }

  late double _maxWidth;

  Widget _buildChrome(BuildContext context, Widget child) {
    final ScrollableDetails details = ScrollableDetails(
      direction: widget.axisDirection,
      controller: _effectiveScrollController,
      decorationClipBehavior: widget.clipBehavior,
    );

    return _configuration.buildScrollbar(
      context,
      _configuration.buildOverscrollIndicator(context, child, details),
      details,
    );
  }

  // DESCRIPTION

  @protected
  @override
  Widget build(BuildContext context) {
    assert(_position != null);
    // _ScrollableScope must be placed above the BuildContext returned by notificationContext
    // so that we can get this ScrollableState by doing the following:
    //
    // ScrollNotification notification;
    // Scrollable.of(notification.context)
    //
    // Since notificationContext is pointing to _gestureDetectorKey.context, _ScrollableScope
    // must be placed above the widget using it: RawGestureDetector
    Widget result = _ScrollableScope(
      scrollable: this,
      position: position,
      child: Listener(
        onPointerSignal: _receivedPointerSignal,
        child: RawGestureDetector(
          key: _gestureDetectorKey,
          gestures: _gestureRecognizers,
          behavior: widget.hitTestBehavior,
          excludeFromSemantics: widget.excludeFromSemantics,
          child: Semantics(
            explicitChildNodes: !widget.excludeFromSemantics,
            child: IgnorePointer(
              key: _ignorePointerKey,
              ignoring: _shouldIgnorePointer,
              child: widget.viewportBuilder(context, position),
            ),
          ),
        ),
      ),
    );

    if (!widget.excludeFromSemantics) {
      result = NotificationListener<ScrollMetricsNotification>(
        onNotification: _handleScrollMetricsNotification,
        child: _ScrollSemantics(
          key: _scrollSemanticsKey,
          position: position,
          allowImplicitScrolling: _physics!.allowImplicitScrolling,
          axis: widget.axis,
          semanticChildCount: widget.semanticChildCount,
          child: result,
        ),
      );
    }

    result = _buildChrome(context, result);

    // Selection is only enabled when there is a parent registrar.
    final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);
    if (registrar != null) {
      result = _ScrollableSelectionHandler(
        state: this,
        position: position,
        registrar: registrar,
        child: result,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _maxWidth = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              heightFactor: 1 - _animController.value,
              child: child,
            );
          },
          child: Material(
            color: widget.bgColor,
            child: widget.header != null
                ? Column(
                    children: [
                      widget.header!,
                      Expanded(child: result),
                    ],
                  )
                : result,
          ),
        );
      },
    );
  }

  // Returns the Future from calling ensureVisible for the ScrollPosition, as
  // as well as this ScrollableState instance so its context can be used to
  // check for other ancestor Scrollables in executing ensureVisible.
  _EnsureVisibleResults _performEnsureVisible(
    RenderObject object, {
    double alignment = 0.0,
    Duration duration = Duration.zero,
    Curve curve = Curves.ease,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
    RenderObject? targetRenderObject,
  }) {
    final Future<void> ensureVisibleFuture = position.ensureVisible(
      object,
      alignment: alignment,
      duration: duration,
      curve: curve,
      alignmentPolicy: alignmentPolicy,
      targetRenderObject: targetRenderObject,
    );
    return (<Future<void>>[ensureVisibleFuture], this);
  }

  @protected
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ScrollPosition>('position', _position))
      ..add(DiagnosticsProperty<ScrollPhysics>('effective physics', _physics));
  }
}

/// A widget to handle selection for a scrollable.
///
/// This widget registers itself to the [registrar] and uses
/// [SelectionContainer] to collect selectables from its subtree.
class _ScrollableSelectionHandler extends StatefulWidget {
  const _ScrollableSelectionHandler({
    required this.state,
    required this.position,
    required this.registrar,
    required this.child,
  });

  final CustomScrollableState state;
  final ScrollPosition position;
  final Widget child;
  final SelectionRegistrar registrar;

  @override
  _ScrollableSelectionHandlerState createState() =>
      _ScrollableSelectionHandlerState();
}

class _ScrollableSelectionHandlerState
    extends State<_ScrollableSelectionHandler> {
  late _ScrollableSelectionContainerDelegate _selectionDelegate;

  @override
  void initState() {
    super.initState();
    _selectionDelegate = _ScrollableSelectionContainerDelegate(
      state: widget.state,
      position: widget.position,
    );
  }

  @override
  void didUpdateWidget(_ScrollableSelectionHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _selectionDelegate.position = widget.position;
    }
  }

  @override
  void dispose() {
    _selectionDelegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionContainer(
      registrar: widget.registrar,
      delegate: _selectionDelegate,
      child: widget.child,
    );
  }
}

/// This updater handles the case where the selectables change frequently, and
/// it optimizes toward scrolling updates.
///
/// It keeps track of the drag start offset relative to scroll origin for every
/// selectable. The records are used to determine whether the selection is up to
/// date with the scroll position when it sends the drag update event to a
/// selectable.
class _ScrollableSelectionContainerDelegate
    extends MultiSelectableSelectionContainerDelegate {
  _ScrollableSelectionContainerDelegate({
    required this.state,
    required ScrollPosition position,
  }) : _position = position,
       _autoScroller = EdgeDraggingAutoScroller(
         state,
         velocityScalar: _kDefaultSelectToScrollVelocityScalar,
       ) {
    _position.addListener(_scheduleLayoutChange);
  }

  // Pointer drag is a single point, it should not have a size.
  static const double _kDefaultDragTargetSize = 0;

  // An eye-balled value for a smooth scrolling speed.
  static const double _kDefaultSelectToScrollVelocityScalar = 30;

  final CustomScrollableState state;
  final EdgeDraggingAutoScroller _autoScroller;
  bool _scheduledLayoutChange = false;
  Offset? _currentDragStartRelatedToOrigin;
  Offset? _currentDragEndRelatedToOrigin;

  // The scrollable only auto scrolls if the selection starts in the scrollable.
  bool _selectionStartsInScrollable = false;

  ScrollPosition get position => _position;
  ScrollPosition _position;
  set position(ScrollPosition other) {
    if (other == _position) {
      return;
    }
    _position.removeListener(_scheduleLayoutChange);
    _position = other;
    _position.addListener(_scheduleLayoutChange);
  }

  // The layout will only be updated a frame later than position changes.
  // Schedule PostFrameCallback to capture the accurate layout.
  void _scheduleLayoutChange() {
    if (_scheduledLayoutChange) {
      return;
    }
    _scheduledLayoutChange = true;
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (!_scheduledLayoutChange) {
        return;
      }
      _scheduledLayoutChange = false;
      layoutDidChange();
    }, debugLabel: 'ScrollableSelectionContainer.layoutDidChange');
  }

  /// Stores the scroll offset when a scrollable receives the last
  /// [SelectionEdgeUpdateEvent].
  ///
  /// The stored scroll offset may be null if a scrollable never receives a
  /// [SelectionEdgeUpdateEvent].
  ///
  /// When a new [SelectionEdgeUpdateEvent] is dispatched to a selectable, this
  /// updater checks the current scroll offset against the one stored in these
  /// records. If the scroll offset is different, it synthesizes an opposite
  /// [SelectionEdgeUpdateEvent] and dispatches the event before dispatching the
  /// new event.
  ///
  /// For example, if a selectable receives an end [SelectionEdgeUpdateEvent]
  /// and its scroll offset in the records is different from the current value,
  /// it synthesizes a start [SelectionEdgeUpdateEvent] and dispatches it before
  /// dispatching the original end [SelectionEdgeUpdateEvent].
  final Map<Selectable, double> _selectableStartEdgeUpdateRecords =
      <Selectable, double>{};
  final Map<Selectable, double> _selectableEndEdgeUpdateRecords =
      <Selectable, double>{};

  @override
  void didChangeSelectables() {
    final Set<Selectable> selectableSet = selectables.toSet();
    _selectableStartEdgeUpdateRecords.removeWhere(
      (Selectable key, double value) => !selectableSet.contains(key),
    );
    _selectableEndEdgeUpdateRecords.removeWhere(
      (Selectable key, double value) => !selectableSet.contains(key),
    );
    super.didChangeSelectables();
  }

  @override
  SelectionResult handleClearSelection(ClearSelectionEvent event) {
    _selectableStartEdgeUpdateRecords.clear();
    _selectableEndEdgeUpdateRecords.clear();
    _currentDragStartRelatedToOrigin = null;
    _currentDragEndRelatedToOrigin = null;
    _selectionStartsInScrollable = false;
    return super.handleClearSelection(event);
  }

  @override
  SelectionResult handleSelectionEdgeUpdate(SelectionEdgeUpdateEvent event) {
    if (_currentDragEndRelatedToOrigin == null &&
        _currentDragStartRelatedToOrigin == null) {
      assert(!_selectionStartsInScrollable);
      _selectionStartsInScrollable = _globalPositionInScrollable(
        event.globalPosition,
      );
    }
    final Offset deltaToOrigin = _getDeltaToScrollOrigin(state);
    if (event.type == SelectionEventType.endEdgeUpdate) {
      _currentDragEndRelatedToOrigin = _inferPositionRelatedToOrigin(
        event.globalPosition,
      );
      final Offset endOffset = _currentDragEndRelatedToOrigin!.translate(
        -deltaToOrigin.dx,
        -deltaToOrigin.dy,
      );
      event = SelectionEdgeUpdateEvent.forEnd(
        globalPosition: endOffset,
        granularity: event.granularity,
      );
    } else {
      _currentDragStartRelatedToOrigin = _inferPositionRelatedToOrigin(
        event.globalPosition,
      );
      final Offset startOffset = _currentDragStartRelatedToOrigin!.translate(
        -deltaToOrigin.dx,
        -deltaToOrigin.dy,
      );
      event = SelectionEdgeUpdateEvent.forStart(
        globalPosition: startOffset,
        granularity: event.granularity,
      );
    }
    final SelectionResult result = super.handleSelectionEdgeUpdate(event);

    // Result may be pending if one of the selectable child is also a scrollable.
    // In that case, the parent scrollable needs to wait for the child to finish
    // scrolling.
    if (result == SelectionResult.pending) {
      _autoScroller.stopAutoScroll();
      return result;
    }
    if (_selectionStartsInScrollable) {
      _autoScroller.startAutoScrollIfNecessary(_dragTargetFromEvent(event));
      if (_autoScroller.scrolling) {
        return SelectionResult.pending;
      }
    }
    return result;
  }

  Offset _inferPositionRelatedToOrigin(Offset globalPosition) {
    final RenderBox box = state.context.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    if (!_selectionStartsInScrollable) {
      // If the selection starts outside of the scrollable, selecting across the
      // scrollable boundary will act as selecting the entire content in the
      // scrollable. This logic move the offset to the 0.0 or infinity to cover
      // the entire content if the input position is outside of the scrollable.
      if (localPosition.dy < 0 || localPosition.dx < 0) {
        return box.localToGlobal(Offset.zero);
      }
      if (localPosition.dy > box.size.height ||
          localPosition.dx > box.size.width) {
        return Offset.infinite;
      }
    }
    final Offset deltaToOrigin = _getDeltaToScrollOrigin(state);
    return box.localToGlobal(
      localPosition.translate(deltaToOrigin.dx, deltaToOrigin.dy),
    );
  }

  /// Infers the [_currentDragStartRelatedToOrigin] and
  /// [_currentDragEndRelatedToOrigin] from the geometry.
  ///
  /// This method is called after a select word and select all event where the
  /// selection is triggered by none drag events. The
  /// [_currentDragStartRelatedToOrigin] and [_currentDragEndRelatedToOrigin]
  /// are essential to handle future [SelectionEdgeUpdateEvent]s.
  void _updateDragLocationsFromGeometries({
    bool forceUpdateStart = true,
    bool forceUpdateEnd = true,
  }) {
    final Offset deltaToOrigin = _getDeltaToScrollOrigin(state);
    final RenderBox box = state.context.findRenderObject()! as RenderBox;
    final Matrix4 transform = box.getTransformTo(null);
    if (currentSelectionStartIndex != -1 &&
        (_currentDragStartRelatedToOrigin == null || forceUpdateStart)) {
      final SelectionGeometry geometry =
          selectables[currentSelectionStartIndex].value;
      assert(geometry.hasSelection);
      final SelectionPoint start = geometry.startSelectionPoint!;
      final Matrix4 childTransform = selectables[currentSelectionStartIndex]
          .getTransformTo(box);
      final Offset localDragStart = MatrixUtils.transformPoint(
        childTransform,
        start.localPosition + Offset(0, -start.lineHeight / 2),
      );
      _currentDragStartRelatedToOrigin = MatrixUtils.transformPoint(
        transform,
        localDragStart + deltaToOrigin,
      );
    }
    if (currentSelectionEndIndex != -1 &&
        (_currentDragEndRelatedToOrigin == null || forceUpdateEnd)) {
      final SelectionGeometry geometry =
          selectables[currentSelectionEndIndex].value;
      assert(geometry.hasSelection);
      final SelectionPoint end = geometry.endSelectionPoint!;
      final Matrix4 childTransform = selectables[currentSelectionEndIndex]
          .getTransformTo(box);
      final Offset localDragEnd = MatrixUtils.transformPoint(
        childTransform,
        end.localPosition + Offset(0, -end.lineHeight / 2),
      );
      _currentDragEndRelatedToOrigin = MatrixUtils.transformPoint(
        transform,
        localDragEnd + deltaToOrigin,
      );
    }
  }

  @override
  SelectionResult handleSelectAll(SelectAllSelectionEvent event) {
    assert(!_selectionStartsInScrollable);
    final SelectionResult result = super.handleSelectAll(event);
    assert(
      (currentSelectionStartIndex == -1) == (currentSelectionEndIndex == -1),
    );
    if (currentSelectionStartIndex != -1) {
      _updateDragLocationsFromGeometries();
    }
    return result;
  }

  @override
  SelectionResult handleSelectWord(SelectWordSelectionEvent event) {
    _selectionStartsInScrollable = _globalPositionInScrollable(
      event.globalPosition,
    );
    final SelectionResult result = super.handleSelectWord(event);
    _updateDragLocationsFromGeometries();
    return result;
  }

  @override
  SelectionResult handleGranularlyExtendSelection(
    GranularlyExtendSelectionEvent event,
  ) {
    final SelectionResult result = super.handleGranularlyExtendSelection(event);
    // The selection geometry may not have the accurate offset for the edges
    // that are outside of the viewport whose transform may not be valid. Only
    // the edge this event is updating is sure to be accurate.
    _updateDragLocationsFromGeometries(
      forceUpdateStart: !event.isEnd,
      forceUpdateEnd: event.isEnd,
    );
    if (_selectionStartsInScrollable) {
      _jumpToEdge(event.isEnd);
    }
    return result;
  }

  @override
  SelectionResult handleDirectionallyExtendSelection(
    DirectionallyExtendSelectionEvent event,
  ) {
    final SelectionResult result = super.handleDirectionallyExtendSelection(
      event,
    );
    // The selection geometry may not have the accurate offset for the edges
    // that are outside of the viewport whose transform may not be valid. Only
    // the edge this event is updating is sure to be accurate.
    _updateDragLocationsFromGeometries(
      forceUpdateStart: !event.isEnd,
      forceUpdateEnd: event.isEnd,
    );
    if (_selectionStartsInScrollable) {
      _jumpToEdge(event.isEnd);
    }
    return result;
  }

  void _jumpToEdge(bool isExtent) {
    final Selectable selectable;
    final double? lineHeight;
    final SelectionPoint? edge;
    if (isExtent) {
      selectable = selectables[currentSelectionEndIndex];
      edge = selectable.value.endSelectionPoint;
      lineHeight = selectable.value.endSelectionPoint!.lineHeight;
    } else {
      selectable = selectables[currentSelectionStartIndex];
      edge = selectable.value.startSelectionPoint;
      lineHeight = selectable.value.startSelectionPoint?.lineHeight;
    }
    if (lineHeight == null || edge == null) {
      return;
    }
    final RenderBox scrollableBox =
        state.context.findRenderObject()! as RenderBox;
    final Matrix4 transform = selectable.getTransformTo(scrollableBox);
    final Offset edgeOffsetInScrollableCoordinates = MatrixUtils.transformPoint(
      transform,
      edge.localPosition,
    );
    final Rect scrollableRect = Rect.fromLTRB(
      0,
      0,
      scrollableBox.size.width,
      scrollableBox.size.height,
    );
    switch (state.axisDirection) {
      case AxisDirection.up:
        final double edgeBottom = edgeOffsetInScrollableCoordinates.dy;
        final double edgeTop =
            edgeOffsetInScrollableCoordinates.dy - lineHeight;
        if (edgeBottom >= scrollableRect.bottom &&
            edgeTop <= scrollableRect.top) {
          return;
        }
        if (edgeBottom > scrollableRect.bottom) {
          position.jumpTo(position.pixels + scrollableRect.bottom - edgeBottom);
          return;
        }
        if (edgeTop < scrollableRect.top) {
          position.jumpTo(position.pixels + scrollableRect.top - edgeTop);
        }
        return;
      case AxisDirection.right:
        final double edge = edgeOffsetInScrollableCoordinates.dx;
        if (edge >= scrollableRect.right && edge <= scrollableRect.left) {
          return;
        }
        if (edge > scrollableRect.right) {
          position.jumpTo(position.pixels + edge - scrollableRect.right);
          return;
        }
        if (edge < scrollableRect.left) {
          position.jumpTo(position.pixels + edge - scrollableRect.left);
        }
        return;
      case AxisDirection.down:
        final double edgeBottom = edgeOffsetInScrollableCoordinates.dy;
        final double edgeTop =
            edgeOffsetInScrollableCoordinates.dy - lineHeight;
        if (edgeBottom >= scrollableRect.bottom &&
            edgeTop <= scrollableRect.top) {
          return;
        }
        if (edgeBottom > scrollableRect.bottom) {
          position.jumpTo(position.pixels + edgeBottom - scrollableRect.bottom);
          return;
        }
        if (edgeTop < scrollableRect.top) {
          position.jumpTo(position.pixels + edgeTop - scrollableRect.top);
        }
        return;
      case AxisDirection.left:
        final double edge = edgeOffsetInScrollableCoordinates.dx;
        if (edge >= scrollableRect.right && edge <= scrollableRect.left) {
          return;
        }
        if (edge > scrollableRect.right) {
          position.jumpTo(position.pixels + scrollableRect.right - edge);
          return;
        }
        if (edge < scrollableRect.left) {
          position.jumpTo(position.pixels + scrollableRect.left - edge);
        }
        return;
    }
  }

  bool _globalPositionInScrollable(Offset globalPosition) {
    final RenderBox box = state.context.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    final Rect rect = Rect.fromLTWH(0, 0, box.size.width, box.size.height);
    return rect.contains(localPosition);
  }

  Rect _dragTargetFromEvent(SelectionEdgeUpdateEvent event) {
    return Rect.fromCenter(
      center: event.globalPosition,
      width: _kDefaultDragTargetSize,
      height: _kDefaultDragTargetSize,
    );
  }

  @override
  SelectionResult dispatchSelectionEventToChild(
    Selectable selectable,
    SelectionEvent event,
  ) {
    switch (event.type) {
      case SelectionEventType.startEdgeUpdate:
        _selectableStartEdgeUpdateRecords[selectable] = state.position.pixels;
        ensureChildUpdated(selectable);
      case SelectionEventType.endEdgeUpdate:
        _selectableEndEdgeUpdateRecords[selectable] = state.position.pixels;
        ensureChildUpdated(selectable);
      case SelectionEventType.granularlyExtendSelection:
      case SelectionEventType.directionallyExtendSelection:
        ensureChildUpdated(selectable);
        _selectableStartEdgeUpdateRecords[selectable] = state.position.pixels;
        _selectableEndEdgeUpdateRecords[selectable] = state.position.pixels;
      case SelectionEventType.clear:
        _selectableEndEdgeUpdateRecords.remove(selectable);
        _selectableStartEdgeUpdateRecords.remove(selectable);
      case SelectionEventType.selectAll:
      case SelectionEventType.selectWord:
      case SelectionEventType.selectParagraph:
        _selectableEndEdgeUpdateRecords[selectable] = state.position.pixels;
        _selectableStartEdgeUpdateRecords[selectable] = state.position.pixels;
    }
    return super.dispatchSelectionEventToChild(selectable, event);
  }

  @override
  void ensureChildUpdated(Selectable selectable) {
    final double newRecord = state.position.pixels;
    final double? previousStartRecord =
        _selectableStartEdgeUpdateRecords[selectable];
    if (_currentDragStartRelatedToOrigin != null &&
        (previousStartRecord == null ||
            (newRecord - previousStartRecord).abs() >
                precisionErrorTolerance)) {
      // Make sure the selectable has up to date events.
      final Offset deltaToOrigin = _getDeltaToScrollOrigin(state);
      final Offset startOffset = _currentDragStartRelatedToOrigin!.translate(
        -deltaToOrigin.dx,
        -deltaToOrigin.dy,
      );
      selectable.dispatchSelectionEvent(
        SelectionEdgeUpdateEvent.forStart(globalPosition: startOffset),
      );
      // Make sure we track that we have synthesized a start event for this selectable,
      // so we don't synthesize events unnecessarily.
      _selectableStartEdgeUpdateRecords[selectable] = state.position.pixels;
    }
    final double? previousEndRecord =
        _selectableEndEdgeUpdateRecords[selectable];
    if (_currentDragEndRelatedToOrigin != null &&
        (previousEndRecord == null ||
            (newRecord - previousEndRecord).abs() > precisionErrorTolerance)) {
      // Make sure the selectable has up to date events.
      final Offset deltaToOrigin = _getDeltaToScrollOrigin(state);
      final Offset endOffset = _currentDragEndRelatedToOrigin!.translate(
        -deltaToOrigin.dx,
        -deltaToOrigin.dy,
      );
      selectable.dispatchSelectionEvent(
        SelectionEdgeUpdateEvent.forEnd(globalPosition: endOffset),
      );
      // Make sure we track that we have synthesized an end event for this selectable,
      // so we don't synthesize events unnecessarily.
      _selectableEndEdgeUpdateRecords[selectable] = state.position.pixels;
    }
  }

  @override
  void dispose() {
    _selectableStartEdgeUpdateRecords.clear();
    _selectableEndEdgeUpdateRecords.clear();
    _scheduledLayoutChange = false;
    _autoScroller.stopAutoScroll();
    super.dispose();
  }
}

Offset _getDeltaToScrollOrigin(CustomScrollableState scrollableState) {
  return switch (scrollableState.axisDirection) {
    AxisDirection.up => Offset(0, -scrollableState.position.pixels),
    AxisDirection.down => Offset(0, scrollableState.position.pixels),
    AxisDirection.left => Offset(-scrollableState.position.pixels, 0),
    AxisDirection.right => Offset(scrollableState.position.pixels, 0),
  };
}

/// With [_ScrollSemantics] certain child [SemanticsNode]s can be
/// excluded from the scrollable area for semantics purposes.
///
/// Nodes, that are to be excluded, have to be tagged with
/// [RenderViewport.excludeFromScrolling] and the [RenderAbstractViewport] in
/// use has to add the [RenderViewport.useTwoPaneSemantics] tag to its
/// [SemanticsConfiguration] by overriding
/// [RenderObject.describeSemanticsConfiguration].
///
/// If the tag [RenderViewport.useTwoPaneSemantics] is present on the viewport,
/// two semantics nodes will be used to represent the [CustomScrollable]: The outer
/// node will contain all children, that are excluded from scrolling. The inner
/// node, which is annotated with the scrolling actions, will house the
/// scrollable children.
class _ScrollSemantics extends SingleChildRenderObjectWidget {
  const _ScrollSemantics({
    super.key,
    required this.position,
    required this.allowImplicitScrolling,
    required this.axis,
    required this.semanticChildCount,
    super.child,
  }) : assert(semanticChildCount == null || semanticChildCount >= 0);

  final ScrollPosition position;
  final bool allowImplicitScrolling;
  final int? semanticChildCount;
  final Axis axis;

  @override
  _RenderScrollSemantics createRenderObject(BuildContext context) {
    return _RenderScrollSemantics(
      position: position,
      allowImplicitScrolling: allowImplicitScrolling,
      semanticChildCount: semanticChildCount,
      axis: axis,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderScrollSemantics renderObject,
  ) {
    renderObject
      ..allowImplicitScrolling = allowImplicitScrolling
      ..axis = axis
      ..position = position
      ..semanticChildCount = semanticChildCount;
  }
}

class _RenderScrollSemantics extends RenderProxyBox {
  _RenderScrollSemantics({
    required ScrollPosition position,
    required bool allowImplicitScrolling,
    required this.axis,
    required int? semanticChildCount,
    RenderBox? child,
  }) : _position = position,
       _allowImplicitScrolling = allowImplicitScrolling,
       _semanticChildCount = semanticChildCount,
       super(child) {
    position.addListener(markNeedsSemanticsUpdate);
  }

  /// Whether this render object is excluded from the semantic tree.
  ScrollPosition get position => _position;
  ScrollPosition _position;
  set position(ScrollPosition value) {
    if (value == _position) {
      return;
    }
    _position.removeListener(markNeedsSemanticsUpdate);
    _position = value;
    _position.addListener(markNeedsSemanticsUpdate);
    markNeedsSemanticsUpdate();
  }

  /// Whether this node can be scrolled implicitly.
  bool get allowImplicitScrolling => _allowImplicitScrolling;
  bool _allowImplicitScrolling;
  set allowImplicitScrolling(bool value) {
    if (value == _allowImplicitScrolling) {
      return;
    }
    _allowImplicitScrolling = value;
    markNeedsSemanticsUpdate();
  }

  Axis axis;

  int? get semanticChildCount => _semanticChildCount;
  int? _semanticChildCount;
  set semanticChildCount(int? value) {
    if (value == semanticChildCount) {
      return;
    }
    _semanticChildCount = value;
    markNeedsSemanticsUpdate();
  }

  void _onScrollToOffset(Offset targetOffset) {
    final double offset = switch (axis) {
      Axis.horizontal => targetOffset.dx,
      Axis.vertical => targetOffset.dy,
    };
    _position.jumpTo(offset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isSemanticBoundary = true;
    if (position.haveDimensions) {
      config
        ..hasImplicitScrolling = allowImplicitScrolling
        ..scrollPosition = _position.pixels
        ..scrollExtentMax = _position.maxScrollExtent
        ..scrollExtentMin = _position.minScrollExtent
        ..scrollChildCount = semanticChildCount;
      if (position.maxScrollExtent > position.minScrollExtent &&
          allowImplicitScrolling) {
        config.onScrollToOffset = _onScrollToOffset;
      }
    }
  }

  SemanticsNode? _innerNode;

  @override
  void assembleSemanticsNode(
    SemanticsNode node,
    SemanticsConfiguration config,
    Iterable<SemanticsNode> children,
  ) {
    if (children.isEmpty ||
        !children.first.isTagged(RenderViewport.useTwoPaneSemantics)) {
      _innerNode = null;
      super.assembleSemanticsNode(node, config, children);
      return;
    }

    (_innerNode ??= SemanticsNode(showOnScreen: showOnScreen)).rect = node.rect;

    int? firstVisibleIndex;
    final List<SemanticsNode> excluded = <SemanticsNode>[_innerNode!];
    final List<SemanticsNode> included = <SemanticsNode>[];
    for (final SemanticsNode child in children) {
      assert(child.isTagged(RenderViewport.useTwoPaneSemantics));
      if (child.isTagged(RenderViewport.excludeFromScrolling)) {
        excluded.add(child);
      } else {
        if (!child.hasFlag(SemanticsFlag.isHidden)) {
          firstVisibleIndex ??= child.indexInParent;
        }
        included.add(child);
      }
    }
    config.scrollIndex = firstVisibleIndex;
    node.updateWith(config: null, childrenInInversePaintOrder: excluded);
    _innerNode!.updateWith(
      config: config,
      childrenInInversePaintOrder: included,
    );
  }

  @override
  void clearSemantics() {
    super.clearSemantics();
    _innerNode = null;
  }
}

// Not using a RestorableDouble because we want to allow null values and override
// [enabled].
class _RestorableScrollOffset extends RestorableValue<double?> {
  @override
  double? createDefaultValue() => null;

  @override
  void didUpdateValue(double? oldValue) {
    notifyListeners();
  }

  @override
  double fromPrimitives(Object? data) {
    return data! as double;
  }

  @override
  Object? toPrimitives() {
    return value;
  }

  @override
  bool get enabled => value != null;
}

// 2D SCROLLING

/// Specifies how to configure the [DragGestureRecognizer]s of a
/// [TwoDimensionalScrollable].
// TODO(Piinks): Add sample code, https://github.com/flutter/flutter/issues/126298
enum DiagonalDragBehavior {
  /// This behavior will not allow for any diagonal scrolling.
  ///
  /// Drag gestures in one direction or the other will lock the input axis until
  /// the gesture is released.
  none,

  /// This behavior will only allow diagonal scrolling on a weighted
  /// scale per gesture event.
  ///
  /// This means that after initially evaluating the drag gesture, the weighted
  /// evaluation (based on [kTouchSlop]) stands until the gesture is released.
  weightedEvent,

  /// This behavior will only allow diagonal scrolling on a weighted
  /// scale that is evaluated throughout a gesture event.
  ///
  /// This means that during each update to the drag gesture, the scrolling
  /// axis will be allowed to scroll diagonally if it exceeds the
  /// [kTouchSlop].
  weightedContinuous,

  /// This behavior allows free movement in any and all directions when
  /// dragging.
  free,
}

/// An auto scroller that scrolls the [scrollable] if a drag gesture drags close
/// to its edge.
///
/// The scroll velocity is controlled by the [velocityScalar]:
///
/// velocity = (distance of overscroll) * [velocityScalar].
class EdgeDraggingAutoScroller {
  /// Creates a auto scroller that scrolls the [scrollable].
  EdgeDraggingAutoScroller(
    this.scrollable, {
    this.onScrollViewScrolled,
    required this.velocityScalar,
  });

  /// The [CustomScrollable] this auto scroller is scrolling.
  final CustomScrollableState scrollable;

  /// Called when a scroll view is scrolled.
  ///
  /// The scroll view may be scrolled multiple times in a row until the drag
  /// target no longer triggers the auto scroll. This callback will be called
  /// in between each scroll.
  final VoidCallback? onScrollViewScrolled;

  /// {@template flutter.widgets.EdgeDraggingAutoScroller.velocityScalar}
  /// The velocity scalar per pixel over scroll.
  ///
  /// It represents how the velocity scale with the over scroll distance. The
  /// auto-scroll velocity = (distance of overscroll) * velocityScalar.
  /// {@endtemplate}
  final double velocityScalar;

  late Rect _dragTargetRelatedToScrollOrigin;

  /// Whether the auto scroll is in progress.
  bool get scrolling => _scrolling;
  bool _scrolling = false;

  double _offsetExtent(Offset offset, Axis scrollDirection) {
    return switch (scrollDirection) {
      Axis.horizontal => offset.dx,
      Axis.vertical => offset.dy,
    };
  }

  double _sizeExtent(Size size, Axis scrollDirection) {
    return switch (scrollDirection) {
      Axis.horizontal => size.width,
      Axis.vertical => size.height,
    };
  }

  AxisDirection get _axisDirection => scrollable.axisDirection;
  Axis get _scrollDirection => axisDirectionToAxis(_axisDirection);

  /// Starts the auto scroll if the [dragTarget] is close to the edge.
  ///
  /// The scroll starts to scroll the [scrollable] if the target rect is close
  /// to the edge of the [scrollable]; otherwise, it remains stationary.
  ///
  /// If the scrollable is already scrolling, calling this method updates the
  /// previous dragTarget to the new value and continues scrolling if necessary.
  void startAutoScrollIfNecessary(Rect dragTarget) {
    final Offset deltaToOrigin = scrollable.deltaToScrollOrigin;
    _dragTargetRelatedToScrollOrigin = dragTarget.translate(
      deltaToOrigin.dx,
      deltaToOrigin.dy,
    );
    if (_scrolling) {
      // The change will be picked up in the next scroll.
      return;
    }
    assert(!_scrolling);
    _scroll();
  }

  /// Stop any ongoing auto scrolling.
  void stopAutoScroll() {
    _scrolling = false;
  }

  Future<void> _scroll() async {
    final RenderBox scrollRenderBox =
        scrollable.context.findRenderObject()! as RenderBox;
    final Rect globalRect = MatrixUtils.transformRect(
      scrollRenderBox.getTransformTo(null),
      Rect.fromLTWH(
        0,
        0,
        scrollRenderBox.size.width,
        scrollRenderBox.size.height,
      ),
    );
    assert(
      globalRect.size.width >= _dragTargetRelatedToScrollOrigin.size.width &&
          globalRect.size.height >=
              _dragTargetRelatedToScrollOrigin.size.height,
      'Drag target size is larger than scrollable size, which may cause bouncing',
    );
    _scrolling = true;
    double? newOffset;
    const double overDragMax = 20.0;

    final Offset deltaToOrigin = scrollable.deltaToScrollOrigin;
    final Offset viewportOrigin = globalRect.topLeft.translate(
      deltaToOrigin.dx,
      deltaToOrigin.dy,
    );
    final double viewportStart = _offsetExtent(
      viewportOrigin,
      _scrollDirection,
    );
    final double viewportEnd =
        viewportStart + _sizeExtent(globalRect.size, _scrollDirection);

    final double proxyStart = _offsetExtent(
      _dragTargetRelatedToScrollOrigin.topLeft,
      _scrollDirection,
    );
    final double proxyEnd = _offsetExtent(
      _dragTargetRelatedToScrollOrigin.bottomRight,
      _scrollDirection,
    );
    switch (_axisDirection) {
      case AxisDirection.up:
      case AxisDirection.left:
        if (proxyEnd > viewportEnd &&
            scrollable.position.pixels > scrollable.position.minScrollExtent) {
          final double overDrag = math.min(proxyEnd - viewportEnd, overDragMax);
          newOffset = math.max(
            scrollable.position.minScrollExtent,
            scrollable.position.pixels - overDrag,
          );
        } else if (proxyStart < viewportStart &&
            scrollable.position.pixels < scrollable.position.maxScrollExtent) {
          final double overDrag = math.min(
            viewportStart - proxyStart,
            overDragMax,
          );
          newOffset = math.min(
            scrollable.position.maxScrollExtent,
            scrollable.position.pixels + overDrag,
          );
        }
      case AxisDirection.right:
      case AxisDirection.down:
        if (proxyStart < viewportStart &&
            scrollable.position.pixels > scrollable.position.minScrollExtent) {
          final double overDrag = math.min(
            viewportStart - proxyStart,
            overDragMax,
          );
          newOffset = math.max(
            scrollable.position.minScrollExtent,
            scrollable.position.pixels - overDrag,
          );
        } else if (proxyEnd > viewportEnd &&
            scrollable.position.pixels < scrollable.position.maxScrollExtent) {
          final double overDrag = math.min(proxyEnd - viewportEnd, overDragMax);
          newOffset = math.min(
            scrollable.position.maxScrollExtent,
            scrollable.position.pixels + overDrag,
          );
        }
    }

    if (newOffset == null ||
        (newOffset - scrollable.position.pixels).abs() < 1.0) {
      // Drag should not trigger scroll.
      _scrolling = false;
      return;
    }
    final Duration duration = Duration(
      milliseconds: (1000 / velocityScalar).round(),
    );
    await scrollable.position.animateTo(
      newOffset,
      duration: duration,
      curve: Curves.linear,
    );
    onScrollViewScrolled?.call();
    if (_scrolling) {
      await _scroll();
    }
  }
}
