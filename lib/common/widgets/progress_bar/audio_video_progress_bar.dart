import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'
    show
        MouseTrackerAnnotation,
        PointerEnterEventListener,
        PointerExitEventListener;

/// https://github.com/suragch/audio_video_progress_bar

/// A progress bar widget to show or set the location of the currently
/// playing audio or video content.
///
/// This widget does not itself play audio or video content, but you can
/// use it in conjunction with an audio plugin. It is a more convenient
/// replacement for the Flutter Slider widget.
class ProgressBar extends LeafRenderObjectWidget {
  /// You must set the current audio or video duration [progress] and also
  /// the [total] duration. Optionally set the [buffered] content progress
  /// as well.
  ///
  /// When a user drags the thumb to a new location you can be notified
  /// by the [onSeek] callback so that you can update your audio/video player.
  const ProgressBar({
    super.key,
    required this.progress,
    required this.total,
    this.buffered = 0,
    this.onSeek,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.barHeight = 5.0,
    required this.baseBarColor,
    required this.progressBarColor,
    required this.bufferedBarColor,
    this.thumbRadius = 10.0,
    required this.thumbColor,
    required this.thumbGlowColor,
    this.thumbGlowRadius = 30.0,
    this.thumbCanPaintOutsideBar = true,
  });

  /// The elapsed playing time of the media.
  ///
  /// This should not be greater than the [total] time.
  /// seconds
  final int progress;

  /// The total duration of the media.
  /// seconds
  final int total;

  /// The currently buffered content of the media.
  ///
  /// This is useful for streamed content. If you are playing a local file
  /// then you can leave this out.
  /// seconds
  final int buffered;

  /// A callback when user moves the thumb.
  ///
  /// When the user moved the thumb on the progress bar this callback will
  /// run. It will not run until after the user has finished the touch event.
  ///
  /// You will get the chosen duration to start playing at which you can pass
  /// on to your media player.
  ///
  /// If you want continuous duration updates as the user moves the thumb,
  /// see [onDragUpdate], where the provided [ThumbDragDetails] has a
  /// `timeStamp` with the seek duration on it.
  final OnSeek? onSeek;

  /// A callback when the user starts to move the thumb.
  ///
  /// This will be called only once when the drag begins. This provides you
  /// with the [ThumbDragDetails].
  ///
  /// This method is useful if you are planning to do something like add a time
  /// label and/or video preview over the thumb and you need to do some
  /// initialization.
  ///
  /// Use [onSeek] if you only want to seek to a new audio position when the
  /// drag event has finished.
  final ThumbDragStartCallback? onDragStart;

  /// A callback when the user is moving the thumb.
  ///
  /// This will be called repeatedly as the thumb position changes. This
  /// provides you with the [ThumbDragDetails], which notify you of the global
  /// and local positions of the drag event as well as the current thumb
  /// duration. The current thumb duration will not go beyond [total] or less
  /// that `Duration.zero` so you can use this information to clamp the drag
  /// position values.
  ///
  /// This method is useful if you are planning to do something like add a time
  /// label and/or video preview over the thumb and need to update the position
  /// to stay in sync with the thumb position.
  ///
  /// Use [onSeek] if you only want to seek to a new audio position when the
  /// drag event has finished.
  final ThumbDragUpdateCallback? onDragUpdate;

  /// A callback when the user is finished moving the thumb.
  ///
  /// This will be called only once when the drag ends.
  ///
  /// This method is useful if you are planning to do something like add a time
  /// label and/or video preview over the thumb and you need to dispose of
  /// something when the drag is finished.
  ///
  /// This method is called directly before [onSeek].
  final VoidCallback? onDragEnd;

  /// The vertical thickness of the progress bar.
  final double barHeight;

  /// The color of the progress bar before playback has started.
  ///
  /// By default it is a transparent version of your theme's primary color.
  final Color baseBarColor;

  /// The color of the progress bar to the left of the current playing
  /// [progress].
  ///
  /// By default it is your theme's primary color.
  final Color progressBarColor;

  /// The color of the progress bar between the [progress] location and the
  /// [buffered] location.
  ///
  /// By default it is a transparent version of your theme's primary color,
  /// a shade darker than [baseBarColor].
  final Color bufferedBarColor;

  /// The radius of the circle for the moveable progress bar thumb.
  final double thumbRadius;

  /// The color of the circle for the moveable progress bar thumb.
  ///
  /// By default it is your theme's primary color.
  final Color thumbColor;

  /// The color of the pressed-down effect of the moveable progress bar thumb.
  ///
  /// By default it is [thumbColor] with an alpha value of 80.
  final Color thumbGlowColor;

  /// The radius of the circle for the pressed-down effect of the moveable
  /// progress bar thumb.
  ///
  /// By default it is 30.
  final double thumbGlowRadius;

  /// Whether the thumb radius will before the start of the bar when at the
  /// beginning or after the end of the bar when at the end.
  ///
  /// The default is `true` and this means that the thumb will be painted
  /// outside of the bounds of the widget if there are no side labels. You can
  /// wrap [ProgressBar] with a `Padding` widget if your layout needs to leave
  /// some extra room for the thumb.
  ///
  /// When set to `false` the thumb will be clamped within the width of the
  /// bar. This is nice for aligning the thumb with vertical labels at the start
  /// and end of playback. However, because of the clamping, the thumb won't
  /// move during audio/video playback when near the ends. Depending on the
  /// size of the thumb and the length of the song, this usually only lasts
  /// a few seconds. The progress label still indicates that playback
  /// is happening during this time, though.
  final bool thumbCanPaintOutsideBar;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderProgressBar(
      progress: progress,
      total: total,
      buffered: buffered,
      onSeek: onSeek,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      barHeight: barHeight,
      baseBarColor: baseBarColor,
      progressBarColor: progressBarColor,
      bufferedBarColor: bufferedBarColor,
      thumbRadius: thumbRadius,
      thumbColor: thumbColor,
      thumbGlowColor: thumbGlowColor,
      thumbGlowRadius: thumbGlowRadius,
      thumbCanPaintOutsideBar: thumbCanPaintOutsideBar,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderProgressBar renderObject,
  ) {
    renderObject
      ..total = total
      ..progress = progress
      ..buffered = buffered
      ..onSeek = onSeek
      ..onDragStart = onDragStart
      ..onDragUpdate = onDragUpdate
      ..onDragEnd = onDragEnd
      ..barHeight = barHeight
      ..baseBarColor = baseBarColor
      ..progressBarColor = progressBarColor
      ..bufferedBarColor = bufferedBarColor
      ..thumbRadius = thumbRadius
      ..thumbColor = thumbColor
      ..thumbGlowColor = thumbGlowColor
      ..thumbGlowRadius = thumbGlowRadius
      ..thumbCanPaintOutsideBar = thumbCanPaintOutsideBar;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('progress', progress.toString()))
      ..add(StringProperty('total', total.toString()))
      ..add(StringProperty('buffered', buffered.toString()))
      ..add(
        ObjectFlagProperty<OnSeek>(
          'onSeek',
          onSeek,
          ifNull: 'unimplemented',
        ),
      )
      ..add(
        ObjectFlagProperty<ThumbDragStartCallback>(
          'onDragStart',
          onDragStart,
          ifNull: 'unimplemented',
        ),
      )
      ..add(
        ObjectFlagProperty<ThumbDragUpdateCallback>(
          'onDragUpdate',
          onDragUpdate,
          ifNull: 'unimplemented',
        ),
      )
      ..add(
        ObjectFlagProperty<VoidCallback>(
          'onDragEnd',
          onDragEnd,
          ifNull: 'unimplemented',
        ),
      )
      ..add(DoubleProperty('barHeight', barHeight))
      ..add(ColorProperty('baseBarColor', baseBarColor))
      ..add(ColorProperty('progressBarColor', progressBarColor))
      ..add(ColorProperty('bufferedBarColor', bufferedBarColor))
      ..add(DoubleProperty('thumbRadius', thumbRadius))
      ..add(ColorProperty('thumbColor', thumbColor))
      ..add(ColorProperty('thumbGlowColor', thumbGlowColor))
      ..add(DoubleProperty('thumbGlowRadius', thumbGlowRadius))
      ..add(
        FlagProperty(
          'thumbCanPaintOutsideBar',
          value: thumbCanPaintOutsideBar,
          ifTrue: 'true',
          ifFalse: 'false',
          showName: true,
        ),
      );
  }
}

typedef OnSeek = void Function(int milliseconds);

/// The callback signature for when the thumb begins a horizontal drag.
typedef ThumbDragStartCallback = void Function(ThumbDragDetails details);

/// The callback signature for when the thumb is moving on horizontally and has
/// new data.
typedef ThumbDragUpdateCallback = void Function(ThumbDragDetails details);

/// Data to pass back on drag callback events
class ThumbDragDetails {
  const ThumbDragDetails({
    this.seconds = 0,
    this.globalPosition = Offset.zero,
    this.localPosition = Offset.zero,
  });

  /// The duration position of the thumb on the progress bar
  final int seconds;

  /// The global position of the drag event moving the thumb on the progress bar.
  final Offset globalPosition;

  /// The local position of the drag event moving the thumb on the progress bar.
  final Offset localPosition;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'ThumbDragDetails')}('
      'time: $seconds, '
      'global: $globalPosition, '
      'local: $localPosition)';
}

// Handles all gestures so that it will always win a the gesture arena.
// Without doing this, if you used this widget in a swipable tab layout,
// you would cause a swipe rather than a drag when trying to move the thumb.
class _EagerHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => '_EagerHorizontalDragGestureRecognizer';
}

class RenderProgressBar extends RenderBox implements MouseTrackerAnnotation {
  RenderProgressBar({
    required this._progress,
    required this._total,
    required this._buffered,
    this._onSeek,
    ThumbDragStartCallback? onDragStart,
    ThumbDragUpdateCallback? onDragUpdate,
    VoidCallback? onDragEnd,
    required this._barHeight,
    required this._baseBarColor,
    required this._progressBarColor,
    required this._bufferedBarColor,
    double thumbRadius = 20.0,
    required this._thumbColor,
    required this._thumbGlowColor,
    double thumbGlowRadius = 30.0,
    this._thumbCanPaintOutsideBar = true,
  }) : _onDragStartUserCallback = onDragStart,
       _onDragUpdateUserCallback = onDragUpdate,
       _onDragEndUserCallback = onDragEnd,
       _thumbRadius = thumbRadius,
       _thumbGlowRadius = thumbGlowRadius,
       _paintThumbGlow = thumbGlowRadius > thumbRadius,
       _hitTestSelf = onDragStart != null {
    if (onDragStart != null) {
      _drag = _EagerHorizontalDragGestureRecognizer()
        ..onStart = _onDragStart
        ..onUpdate = _onDragUpdate
        ..onEnd = _onDragEnd
        ..onCancel = _finishDrag;
    }
    if (!_userIsDraggingThumb) {
      _thumbValue = _proportionOfTotal(_progress);
    }
  }

  @override
  void dispose() {
    _drag?.dispose();
    _drag = null;
    super.dispose();
  }

  // This is the gesture recognizer used to move the thumb.
  _EagerHorizontalDragGestureRecognizer? _drag;

  // This is a value between 0.0 and 1.0 used to indicate the position on
  // the bar.
  late double _thumbValue;

  // The thumb can move for two reasons. One is that the [progress] changed.
  // The other is that the user is dragging the thumb. This variable keeps
  // track of that so that while the user is dragging the thumb at the same
  // time as a [progress] update there won't be a conflict.
  bool _userIsDraggingThumb = false;

  void _onDragStart(DragStartDetails details) {
    _userIsDraggingThumb = true;
    _updateThumbPosition(details.localPosition);
    onDragStart?.call(
      ThumbDragDetails(
        seconds: _currentThumbDuration(),
        globalPosition: details.globalPosition,
        localPosition: details.localPosition,
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _updateThumbPosition(details.localPosition);
    onDragUpdate?.call(
      ThumbDragDetails(
        seconds: _currentThumbDuration(),
        globalPosition: details.globalPosition,
        localPosition: details.localPosition,
      ),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    onDragEnd?.call();
    onSeek?.call(_currentThumbDurationInMilliseconds());
    _finishDrag();
  }

  void _finishDrag() {
    _userIsDraggingThumb = false;
    markNeedsPaint();
  }

  int _currentThumbDuration() {
    return (_thumbValue * total).round();
  }

  int _currentThumbDurationInMilliseconds() {
    return (_thumbValue * total * 1000).round();
  }

  // This needs to stay in sync with the layout. This could be a potential
  // source of bugs if there is a layout change but we forget to update this.
  // It might be a good idea to redesign the architecture so that there is
  // only one place to make changes.
  void _updateThumbPosition(Offset localPosition) {
    final dx = localPosition.dx;
    // The paint used to draw the bar line draws half of the cap before the
    // start of the line (and after the end of the line). The cap radius is
    // equal to half of the line width, which in this case is the bar height.
    final barCapRadius = _barHeight / 2;
    double barStart = barCapRadius;
    double barEnd = size.width - barCapRadius;
    final barWidth = barEnd - barStart;
    final position = (dx - barStart).clamp(0.0, barWidth);
    _thumbValue = position / barWidth;
    _progress = _currentThumbDuration();
    markNeedsPaint();
  }

  /// The play location of the media.
  ///
  /// This is used to update the thumb value and the left time label.
  int get progress => _progress;
  int _progress;
  set progress(int value) {
    final clamp = _clampDuration(value);
    if (_progress == clamp) {
      return;
    }
    if (!_userIsDraggingThumb) {
      _progress = clamp;
      _thumbValue = _proportionOfTotal(clamp);
    }
    markNeedsPaint();
  }

  /// The total time length of the media.
  int get total => _total;
  int _total;
  set total(int value) {
    final clamp = (value.isNegative) ? 0 : value;
    if (_total == clamp) {
      return;
    }
    _total = clamp;
    if (!_userIsDraggingThumb) {
      _thumbValue = _proportionOfTotal(progress);
    }
    markNeedsPaint();
  }

  /// The buffered length of the media when streaming.
  int get buffered => _buffered;
  int _buffered;
  set buffered(int value) {
    final clamp = _clampDuration(value);
    if (_buffered == clamp) {
      return;
    }
    _buffered = clamp;
    markNeedsPaint();
  }

  int _clampDuration(int value) {
    if (value.isNegative) return 0;
    if (value.compareTo(_total) > 0) return _total;
    return value;
  }

  /// A callback for the audio duration position to where the thumb was moved.
  OnSeek? get onSeek => _onSeek;
  OnSeek? _onSeek;
  set onSeek(OnSeek? value) {
    if (value == _onSeek) {
      return;
    }
    _onSeek = value;
  }

  /// A callback when the thumb starts being dragged.
  ThumbDragStartCallback? get onDragStart => _onDragStartUserCallback;
  ThumbDragStartCallback? _onDragStartUserCallback;
  set onDragStart(ThumbDragStartCallback? value) {
    if (value == _onDragStartUserCallback) {
      return;
    }
    _onDragStartUserCallback = value;
  }

  /// A callback when the thumb is being dragged.
  ThumbDragUpdateCallback? get onDragUpdate => _onDragUpdateUserCallback;
  ThumbDragUpdateCallback? _onDragUpdateUserCallback;
  set onDragUpdate(ThumbDragUpdateCallback? value) {
    if (value == _onDragUpdateUserCallback) {
      return;
    }
    _onDragUpdateUserCallback = value;
  }

  /// A callback when the thumb drag is finished.
  VoidCallback? get onDragEnd => _onDragEndUserCallback;
  VoidCallback? _onDragEndUserCallback;
  set onDragEnd(VoidCallback? value) {
    if (value == _onDragEndUserCallback) {
      return;
    }
    _onDragEndUserCallback = value;
  }

  /// The vertical thickness of the bar that the thumb moves along.
  double get barHeight => _barHeight;
  double _barHeight;
  set barHeight(double value) {
    if (_barHeight == value) return;
    _barHeight = value;
    markNeedsPaint();
  }

  /// The color of the progress bar before any playing or buffering.
  Color get baseBarColor => _baseBarColor;
  Color _baseBarColor;
  set baseBarColor(Color value) {
    if (_baseBarColor == value) return;
    _baseBarColor = value;
    markNeedsPaint();
  }

  /// The color of the played portion of the progress bar.
  Color get progressBarColor => _progressBarColor;
  Color _progressBarColor;
  set progressBarColor(Color value) {
    if (_progressBarColor == value) return;
    _progressBarColor = value;
    markNeedsPaint();
  }

  /// The color of the visible buffered portion of the progress bar.
  Color get bufferedBarColor => _bufferedBarColor;
  Color _bufferedBarColor;
  set bufferedBarColor(Color value) {
    if (_bufferedBarColor == value) return;
    _bufferedBarColor = value;
    markNeedsPaint();
  }

  /// The color of the moveable thumb.
  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  /// The length of the radius for the circular thumb.
  double get thumbRadius => _thumbRadius;
  double _thumbRadius;
  set thumbRadius(double value) {
    if (_thumbRadius == value) return;
    _thumbRadius = value;
    markNeedsLayout();
  }

  /// The color of the pressed-down effect of the moveable thumb.
  Color get thumbGlowColor => _thumbGlowColor;
  Color _thumbGlowColor;
  set thumbGlowColor(Color value) {
    if (_thumbGlowColor == value) return;
    _thumbGlowColor = value;
    if (_userIsDraggingThumb) markNeedsPaint();
  }

  /// The length of the radius of the pressed-down effect of the moveable thumb.
  bool _paintThumbGlow;
  double get thumbGlowRadius => _thumbGlowRadius;
  double _thumbGlowRadius;
  set thumbGlowRadius(double value) {
    if (_thumbGlowRadius == value) return;
    _thumbGlowRadius = value;
    _paintThumbGlow = value > _thumbRadius;
    markNeedsLayout();
  }

  /// Whether the thumb will paint before the start or after the end of the bar.
  bool get thumbCanPaintOutsideBar => _thumbCanPaintOutsideBar;
  bool _thumbCanPaintOutsideBar;
  set thumbCanPaintOutsideBar(bool value) {
    if (_thumbCanPaintOutsideBar == value) return;
    _thumbCanPaintOutsideBar = value;
    markNeedsPaint();
  }

  // The smallest that this widget would ever want to be.
  static const _minDesiredWidth = 100.0;

  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMaxIntrinsicWidth(double height) => _minDesiredWidth;

  @override
  double computeMinIntrinsicHeight(double width) => _heightWhenNoLabels();

  @override
  double computeMaxIntrinsicHeight(double width) => _heightWhenNoLabels();

  final bool _hitTestSelf;
  @override
  bool hitTestSelf(Offset position) => _hitTestSelf;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag?.addPointer(event);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = _heightWhenNoLabels();
    return constraints.constrainDimensions(desiredWidth, desiredHeight);
  }

  double _heightWhenNoLabels() {
    return max(2 * _thumbRadius, _barHeight);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);

    _drawProgressBarWithoutLabels(canvas);

    canvas.restore();
  }

  /// Draw the progress bar without labels like this:
  ///
  /// | -------O---------------- |
  ///
  void _drawProgressBarWithoutLabels(Canvas canvas) {
    final barWidth = size.width;
    final barHeight = _heightWhenNoLabels();
    _drawProgressBar(canvas, Offset.zero, Size(barWidth, barHeight));
  }

  void _drawProgressBar(Canvas canvas, Offset offset, Size localSize) {
    canvas
      ..save()
      ..translate(offset.dx, offset.dy);
    _drawBaseBar(canvas, localSize);
    _drawBufferedBar(canvas, localSize);
    _drawCurrentProgressBar(canvas, localSize);
    _drawThumb(canvas, localSize);
    canvas.restore();
  }

  void _drawBaseBar(Canvas canvas, Size localSize) {
    _drawBar(
      canvas: canvas,
      availableSize: localSize,
      widthProportion: 1.0,
      color: baseBarColor,
    );
  }

  void _drawBufferedBar(Canvas canvas, Size localSize) {
    _drawBar(
      canvas: canvas,
      availableSize: localSize,
      widthProportion: _proportionOfTotal(_buffered),
      color: bufferedBarColor,
    );
  }

  void _drawCurrentProgressBar(Canvas canvas, Size localSize) {
    _drawBar(
      canvas: canvas,
      availableSize: localSize,
      widthProportion: _thumbValue,
      color: progressBarColor,
    );
  }

  void _drawBar({
    required Canvas canvas,
    required Size availableSize,
    required double widthProportion,
    required Color color,
  }) {
    final baseBarPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _barHeight;
    final capRadius = _barHeight / 2;
    final adjustedWidth = availableSize.width - barHeight;
    final dx = widthProportion * adjustedWidth + capRadius;
    final dy = availableSize.height / 2;
    final startPoint = Offset(capRadius, dy);
    final endPoint = Offset(dx, dy);
    canvas.drawLine(startPoint, endPoint, baseBarPaint);
  }

  void _drawThumb(Canvas canvas, Size localSize) {
    final thumbPaint = Paint()..color = thumbColor;
    final barCapRadius = _barHeight / 2;
    final availableWidth = localSize.width - _barHeight;
    var thumbDx = _thumbValue * availableWidth + barCapRadius;
    if (!_thumbCanPaintOutsideBar) {
      thumbDx = thumbDx.clamp(_thumbRadius, localSize.width - _thumbRadius);
    }
    final center = Offset(thumbDx, localSize.height / 2);
    if (_userIsDraggingThumb && _paintThumbGlow) {
      final thumbGlowPaint = Paint()..color = thumbGlowColor;
      canvas.drawCircle(center, thumbGlowRadius, thumbGlowPaint);
    }
    canvas.drawCircle(center, thumbRadius, thumbPaint);
  }

  double _proportionOfTotal(int duration) {
    if (total == 0) {
      return 0.0;
    }
    return (duration / total).clamp(0.0, 1.0);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    // description
    config
      ..textDirection = TextDirection.ltr
      ..label =
          '进度条' //'Progress bar';
      ..value = '${(_thumbValue * 100).round()}%'
      // increase action
      ..onIncrease = increaseAction;
    final increased = _thumbValue + _semanticActionUnit;
    config
      ..increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%'
      // decrease action
      ..onDecrease = decreaseAction;
    final decreased = _thumbValue - _semanticActionUnit;
    config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
  }

  // This is how much to move the thumb if the move is triggered by a
  // semantic action rather than a touch event.
  static const double _semanticActionUnit = 0.05;

  void increaseAction() {
    final newValue = _thumbValue + _semanticActionUnit;
    _thumbValue = (newValue).clamp(0.0, 1.0);
    onSeek?.call(_currentThumbDuration());
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void decreaseAction() {
    final newValue = _thumbValue - _semanticActionUnit;
    _thumbValue = (newValue).clamp(0.0, 1.0);
    onSeek?.call(_currentThumbDuration());
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.click;

  @override
  PointerEnterEventListener? onEnter;

  @override
  PointerExitEventListener? onExit;

  @override
  bool get validForMouseTracker => false;
}
