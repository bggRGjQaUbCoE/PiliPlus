// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async' show Completer;
import 'dart:io' show Platform;

import 'package:PiliPlus/common/widgets/scroll_behavior.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    show RefreshScrollPhysics;
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart' hide RefreshIndicator;

/// The distance from the child's top or bottom [edgeOffset] where
/// the refresh indicator will settle. During the drag that exposes the refresh
/// indicator, its actual displacement may significantly exceed this value.
///
/// In most cases, [displacement] distance starts counting from the parent's
/// edges. However, if [edgeOffset] is larger than zero then the [displacement]
/// value is calculated from that offset instead of the parent's edge.
double displacement = Pref.refreshDisplacement;

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
double kDragContainerExtentPercentage = Pref.refreshDragPercentage;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// Indicates current status of Material `RefreshIndicator`.
enum RefreshIndicatorStatus {
  /// Pointer is down.
  drag,

  /// Dragged far enough that an up event will run the onRefresh callback.
  // armed,

  /// Animating to the indicator's final "displacement".
  snap,

  /// Running the refresh callback.
  refresh,

  /// Animating the indicator's fade-out after refreshing.
  done,

  /// Animating the indicator's fade-out after not arming.
  canceled,
}

/// A widget that supports the Material "swipe to refresh" idiom.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=ORApMlzwMdM}
///
/// When the child's [Scrollable] descendant overscrolls, an animated circular
/// progress indicator is faded into view. When the scroll ends, if the
/// indicator has been dragged far enough for it to become completely opaque,
/// the [onRefresh] callback is called. The callback is expected to update the
/// scrollable's contents and then complete the [Future] it returns. The refresh
/// indicator disappears after the callback's [Future] has completed.
///
/// The trigger mode is configured by [RefreshIndicator.triggerMode].
///
/// {@tool dartpad}
/// This example shows how [RefreshIndicator] can be triggered in different ways.
///
/// ** See code in examples/api/lib/material/refresh_indicator/refresh_indicator.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to trigger [RefreshIndicator] in a nested scroll view using
/// the [notificationPredicate] property.
///
/// ** See code in examples/api/lib/material/refresh_indicator/refresh_indicator.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to use [RefreshIndicator] without the spinner.
///
/// ** See code in examples/api/lib/material/refresh_indicator/refresh_indicator.2.dart **
/// {@end-tool}
///
/// ## Troubleshooting
///
/// ### Refresh indicator does not show up
///
/// The [RefreshIndicator] will appear if its scrollable descendant can be
/// overscrolled, i.e. if the scrollable's content is bigger than its viewport.
/// To ensure that the [RefreshIndicator] will always appear, even if the
/// scrollable's content fits within its viewport, set the scrollable's
/// [Scrollable.physics] property to [AlwaysScrollableScrollPhysics]:
///
/// ```dart
/// ListView(
///   physics: const AlwaysScrollableScrollPhysics(),
///   // ...
/// )
/// ```
///
/// A [RefreshIndicator] can only be used with a vertical scroll view.
///
/// See also:
///
///  * <https://material.io/design/platform-guidance/android-swipe-to-refresh.html>
///  * [RefreshIndicatorState], can be used to programmatically show the refresh indicator.
///  * [RefreshProgressIndicator], widget used by [RefreshIndicator] to show
///    the inner circular progress spinner during refreshes.
///  * [CupertinoSliverRefreshControl], an iOS equivalent of the pull-to-refresh pattern.
///    Must be used as a sliver inside a [CustomScrollView] instead of wrapping
///    around a [ScrollView] because it's a part of the scrollable instead of
///    being overlaid on top of it.
class RefreshIndicator extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  ///
  /// The [semanticsLabel] is used to specify an accessibility label for this widget.
  /// If it is null, it will be defaulted to [MaterialLocalizations.refreshIndicatorSemanticLabel].
  /// An empty string may be passed to avoid having anything read by screen reading software.
  /// The [semanticsValue] may be used to specify progress on the widget.
  const RefreshIndicator({
    super.key,
    this.edgeOffset = 0.0,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.elevation = 2.0,
    this.isClampingScrollPhysics = false,
    required this.child,
  }) : assert(elevation >= 0.0);

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// The offset where [RefreshProgressIndicator] starts to appear on drag start.
  ///
  /// Depending whether the indicator is showing on the top or bottom, the value
  /// of this variable controls how far from the parent's edge the progress
  /// indicator starts to appear. This may come in handy when, for example, the
  /// UI contains a top [Widget] which covers the parent's edge where the progress
  /// indicator would otherwise appear.
  ///
  /// By default, the edge offset is set to 0.
  ///
  /// See also:
  ///
  ///  * [displacement], can be used to change the distance from the edge that
  ///    the indicator settles.
  final double edgeOffset;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The progress indicator's foreground color. The current theme's
  /// [ColorScheme.primary] by default.
  final Color? color;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.canvasColor] by default.
  final Color? backgroundColor;

  /// A check that specifies whether a [ScrollNotification] should be
  /// handled by this widget.
  ///
  /// By default, checks whether `notification.depth == 0`. Set it to something
  /// else for more complicated layouts.
  final ScrollNotificationPredicate notificationPredicate;

  /// Defines [strokeWidth] for `RefreshIndicator`.
  ///
  /// By default, the value of [strokeWidth] is 2.0 pixels.
  final double strokeWidth;

  /// Defines the elevation of the underlying [RefreshIndicator].
  ///
  /// Defaults to 2.0.
  final double elevation;

  final bool isClampingScrollPhysics;

  @override
  RefreshIndicatorState createState() => RefreshIndicatorState();
}

/// Contains the state for a [RefreshIndicator]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class RefreshIndicatorState extends State<RefreshIndicator>
    with TickerProviderStateMixin<RefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;

  RefreshIndicatorStatus? _status;
  late Future<void> _pendingRefreshFuture;
  double? _dragOffset;
  late Color _effectiveValueColor;
  // late Color _backgroundColor;

  static final Animatable<double> _threeQuarterTween = Tween<double>(
    begin: 0.0,
    end: 0.75,
  );

  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(
    begin: 0.0,
    end: _kDragSizeFactorLimit,
  );

  static final Animatable<double> _oneToZeroTween = Tween<double>(
    begin: 1.0,
    end: 0.0,
  );

  @protected
  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);

    // The "value" of the circular progress indicator during a drag.
    _value = _positionController.drive(_threeQuarterTween);

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @protected
  @override
  void didChangeDependencies() {
    _setupColorTween();
    super.didChangeDependencies();
  }

  @protected
  @override
  void didUpdateWidget(covariant RefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _setupColorTween();
    }
  }

  @protected
  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _setupColorTween() {
    final colorScheme = ColorScheme.of(context);
    // _backgroundColor = colorScheme.surfaceContainerHighest;
    // Reset the current value color.
    _effectiveValueColor = widget.color ?? colorScheme.primary;
    final Color color = _effectiveValueColor;
    if (color.a == 0) {
      // Set an always stopped animation instead of a driven tween.
      _valueColor = AlwaysStoppedAnimation<Color>(color);
    } else {
      // Respect the alpha of the given color.
      _valueColor = _positionController.drive(
        ColorTween(
          begin: color.withValues(alpha: 0),
          end: color,
        ).chain(
          CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit)),
        ),
      );
    }
  }

  bool _shouldStart(ScrollNotification notification) {
    // If the notification.dragDetails is null, this scroll is not triggered by
    // user dragging. It may be a result of ScrollController.jumpTo or ballistic scroll.
    // In this case, we don't want to trigger the refresh indicator.
    return _status == null &&
        ((notification is ScrollStartNotification &&
                notification.dragDetails != null) ||
            (notification is ScrollUpdateNotification &&
                notification.dragDetails != null)) &&
        notification.metrics.extentBefore == 0.0 &&
        _start();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_shouldStart(notification)) {
      setState(() {
        _status = RefreshIndicatorStatus.drag;
      });
      return false;
    }
    if (notification is ScrollUpdateNotification) {
      if (_status == RefreshIndicatorStatus.drag) {
        _dragOffset = _dragOffset! - notification.scrollDelta!;
        _checkDragOffset(notification.metrics.viewportDimension);

        if (notification.dragDetails == null &&
            _valueColor.value!.a == _effectiveValueColor.a) {
          // On iOS start the refresh when the Scrollable bounces back from the
          // overscroll (ScrollNotification indicating this don't have dragDetails
          // because the scroll activity is not directly triggered by a drag).
          _show();
        }
      }
    } else if (notification is OverscrollNotification) {
      if (_status == RefreshIndicatorStatus.drag) {
        _dragOffset = _dragOffset! - notification.overscroll;
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_status) {
        case RefreshIndicatorStatus.drag:
          if (_valueColor.value!.a == _effectiveValueColor.a) {
            _show();
          } else {
            _dismiss(RefreshIndicatorStatus.canceled);
          }
        case RefreshIndicatorStatus.canceled:
        case RefreshIndicatorStatus.done:
        case RefreshIndicatorStatus.refresh:
        case RefreshIndicatorStatus.snap:
        case null:
          // do nothing
          break;
      }
    }
    return false;
  }

  bool _handleIndicatorNotification(
    OverscrollIndicatorNotification notification,
  ) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_status == RefreshIndicatorStatus.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  bool _start() {
    assert(_status == null);
    assert(_dragOffset == null);
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(
      _status == RefreshIndicatorStatus.drag,
    );
    double newValue =
        _dragOffset! / (containerExtent * kDragContainerExtentPercentage);
    _positionController.value = clampDouble(
      newValue,
      0.0,
      1.0,
    ); // This triggers various rebuilds.
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(RefreshIndicatorStatus newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(
      newMode == RefreshIndicatorStatus.canceled ||
          newMode == RefreshIndicatorStatus.done,
    );
    setState(() {
      _status = newMode;
    });
    switch (_status!) {
      case RefreshIndicatorStatus.done:
        await _scaleController.animateTo(
          1.0,
          duration: _kIndicatorScaleDuration,
        );
      case RefreshIndicatorStatus.canceled:
        await _positionController.animateTo(
          0.0,
          duration: _kIndicatorScaleDuration,
        );
      case RefreshIndicatorStatus.drag:
      case RefreshIndicatorStatus.refresh:
      case RefreshIndicatorStatus.snap:
        assert(false);
    }
    if (mounted && _status == newMode) {
      _dragOffset = null;
      setState(() {
        _status = null;
      });
    }
  }

  void _show() {
    assert(_status != RefreshIndicatorStatus.refresh);
    assert(_status != RefreshIndicatorStatus.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _status = RefreshIndicatorStatus.snap;
    _positionController
        .animateTo(
          1.0 / _kDragSizeFactorLimit,
          duration: _kIndicatorSnapDuration,
        )
        .whenComplete(() {
          if (mounted && _status == RefreshIndicatorStatus.snap) {
            setState(() {
              // Show the indeterminate progress indicator.
              _status = RefreshIndicatorStatus.refresh;
            });

            widget.onRefresh().whenComplete(() {
              if (mounted && _status == RefreshIndicatorStatus.refresh) {
                completer.complete();
                _dismiss(RefreshIndicatorStatus.done);
              }
            });
          }
        });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [RefreshIndicator] with a [GlobalKey<RefreshIndicatorState>]
  /// makes it possible to refer to the [RefreshIndicatorState].
  ///
  /// The future returned from this method completes when the
  /// [RefreshIndicator.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of any
  /// actual scroll view. It defaults to showing the indicator at the top. To
  /// show it at the bottom, set `atTop` to false.
  Future<void> show() {
    if (_status != RefreshIndicatorStatus.refresh &&
        _status != RefreshIndicatorStatus.snap) {
      if (_status == null) {
        _start();
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @protected
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );
    assert(() {
      if (_status == null) {
        assert(_dragOffset == null);
      } else {
        assert(_dragOffset != null);
      }
      return true;
    }());

    final bool showIndeterminateIndicator =
        _status == RefreshIndicatorStatus.refresh ||
        _status == RefreshIndicatorStatus.done;

    child = Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        if (_status != null)
          Positioned(
            top: widget.edgeOffset,
            left: 0.0,
            right: 0.0,
            child: SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: _positionFactor, // This is what brings it down.
              child: Padding(
                padding: EdgeInsets.only(top: displacement),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ScaleTransition(
                    scale: _scaleFactor,
                    child: AnimatedBuilder(
                      animation: _positionController,
                      builder: (context, child) => RefreshProgressIndicator(
                        value: showIndeterminateIndicator ? null : _value.value,
                        valueColor: _valueColor,
                        backgroundColor: widget.backgroundColor,
                        strokeWidth: widget.strokeWidth,
                        elevation: widget.elevation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    if (!widget.isClampingScrollPhysics &&
        (Platform.isIOS || Platform.isMacOS)) {
      return child;
    }
    return ScrollConfiguration(
      behavior: RefreshScrollBehavior(
        desktopDragDevices,
        scrollPhysics: RefreshScrollPhysics(
          parent: const RangeMaintainingScrollPhysics(),
          onDrag: _onDrag,
        ),
      ),
      child: child,
    );
  }

  bool _onDrag(double offset, double viewportDimension) {
    if (_positionController.value > 0.0 && _status == .drag) {
      _dragOffset = _dragOffset! + offset;
      _checkDragOffset(viewportDimension);
      return true;
    }
    return false;
  }

  // late final _refreshKey = GlobalKey();
  // Widget _m3eRefreshProgressIndicator(bool showIndeterminateIndicator) {
  //   const indicatorMargin = EdgeInsets.all(4);
  //   const indicatorPadding = EdgeInsets.all(6);
  //   const indicatorSize = 41.0;

  //   final progress = _value.value;
  //   return Padding(
  //     padding: indicatorMargin,
  //     child: SizedBox(
  //       width: indicatorSize,
  //       height: indicatorSize,
  //       child: Material(
  //         type: MaterialType.circle,
  //         color: _backgroundColor,
  //         elevation: widget.elevation,
  //         child: Padding(
  //           padding: indicatorPadding,
  //           child: showIndeterminateIndicator
  //               ? M3ELoadingIndicator(
  //                   childKey: _refreshKey,
  //                   color: _effectiveValueColor,
  //                   morphs: Morphs.refreshMorphs,
  //                   size: null,
  //                 )
  //               : RawM3ELoadingIndicator(
  //                   key: _refreshKey,
  //                   morph: Morphs.manualMorph,
  //                   progress: progress,
  //                   angle: -progress * math.pi,
  //                   color: _valueColor.value!,
  //                   size: null,
  //                 ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// ignore: camel_case_types
typedef refreshIndicator = RefreshIndicator;

class RefreshScrollBehavior extends CustomScrollBehavior {
  const RefreshScrollBehavior(
    super.dragDevices, {
    required this.scrollPhysics,
  });

  final RefreshScrollPhysics scrollPhysics;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return scrollPhysics;
  }
}
