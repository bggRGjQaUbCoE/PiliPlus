import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Flutter subtitle overlay for the Media3 backend.
///
/// Media3 parses and schedules the subtitle track, then sends active cue text,
/// styles and placement through [ExoPlayerController]. Keeping the overlay in
/// Flutter makes the existing subtitle padding and drag behaviour
/// backend-neutral.
class ExoSubtitleView extends StatefulWidget {
  const ExoSubtitleView({
    required this.controller,
    required this.configuration,
    this.enableDragSubtitle = false,
    this.onUpdatePadding,
    super.key,
  });

  final ExoPlayerController controller;
  final SubtitleViewConfiguration configuration;
  final bool enableDragSubtitle;
  final ValueChanged<EdgeInsets>? onUpdatePadding;

  @override
  State<ExoSubtitleView> createState() => _ExoSubtitleViewState();
}

class _ExoSubtitleViewState extends State<ExoSubtitleView> {
  StreamSubscription<ExoPlayerEvent>? _subscription;
  late List<ExoSubtitleCue> _cues = widget.controller.state.subtitleCues;
  late EdgeInsets _padding = widget.configuration.padding;
  static const _duration = Duration(milliseconds: 100);

  @override
  void initState() {
    super.initState();
    _listenToPlayer();
  }

  void _listenToPlayer() {
    _cues = widget.controller.state.subtitleCues;
    _subscription = widget.controller.events.listen((event) {
      if (!mounted || identical(event.subtitleCues, _cues)) {
        return;
      }
      setState(() => _cues = event.subtitleCues);
    });
  }

  @override
  void didUpdateWidget(covariant ExoSubtitleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _padding = widget.configuration.padding;
    if (oldWidget.controller.id != widget.controller.id) {
      _subscription?.cancel();
      _listenToPlayer();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  TextStyle _cueStyle(
    ExoSubtitleCue cue,
    TextStyle base,
    double height,
    double devicePixelRatio,
  ) {
    final cueSize = cue.textSize;
    if (cueSize == null) return base;
    final fontSize = switch (cue.textSizeType) {
      0 || 1 => cueSize * height,
      2 => cueSize / devicePixelRatio,
      _ => null,
    };
    return fontSize == null ? base : base.copyWith(fontSize: fontSize);
  }

  InlineSpan _span(
    ExoSubtitleCue cue,
    TextStyle base,
    double devicePixelRatio,
  ) {
    if (cue.segments.isEmpty) {
      return TextSpan(text: cue.text, style: base);
    }
    return TextSpan(
      children: cue.segments
          .map(
            (segment) => TextSpan(
              text: segment.text,
              style: segment.applyTo(
                base,
                devicePixelRatio: devicePixelRatio,
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _text(
    ExoSubtitleCue cue,
    TextStyle style,
    double devicePixelRatio,
  ) => RichText(
    text: _span(cue, style, devicePixelRatio),
    textAlign:
        cue.multiRowAlignment?.textAlign ??
        cue.textAlignment?.textAlign ??
        widget.configuration.textAlign,
    textScaler: TextScaler.noScaling,
  );

  Widget _cueView(
    ExoSubtitleCue cue,
    Size size,
    double devicePixelRatio,
  ) {
    final textStyle = _cueStyle(
      cue,
      widget.configuration.style,
      size.height,
      devicePixelRatio,
    );
    final strokeStyle = widget.configuration.strokeStyle;
    Widget child = strokeStyle == null
        ? _text(cue, textStyle, devicePixelRatio)
        : Stack(
            clipBehavior: Clip.none,
            children: [
              _text(
                cue,
                _cueStyle(cue, strokeStyle, size.height, devicePixelRatio),
                devicePixelRatio,
              ),
              _text(cue, textStyle, devicePixelRatio),
            ],
          );
    if (cue.windowColor case final color?) {
      child = ColoredBox(color: Color(color), child: child);
    }
    if (cue.shearDegrees != 0) {
      child = Transform(
        alignment: Alignment.center,
        transform: Matrix4.skewX(cue.shearDegrees * math.pi / 180),
        child: child,
      );
    }
    return child;
  }

  Widget _subtitleView(BuildContext context) {
    if (_cues.isEmpty) return const SizedBox.shrink();
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Stack(
          clipBehavior: Clip.none,
          children: _cues
              .toList()
              .sortedByZIndex()
              .map(
                (cue) => Positioned.fill(
                  child: CustomSingleChildLayout(
                    delegate: _CuePositionDelegate(cue),
                    child: _cueView(cue, size, devicePixelRatio),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtitleView = _subtitleView(context);
    return AnimatedContainer(
      margin: _padding,
      duration: _duration,
      child: widget.enableDragSubtitle
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: (details) {
                setState(() {
                  _padding = _padding.copyWith(
                    bottom: clampDouble(
                      _padding.bottom - details.delta.dy,
                      0,
                      200,
                    ),
                  );
                });
              },
              onVerticalDragEnd: (_) {
                widget.onUpdatePadding?.call(_padding);
              },
              child: subtitleView,
            )
          : subtitleView,
    );
  }
}

extension on List<ExoSubtitleCue> {
  List<ExoSubtitleCue> sortedByZIndex() =>
      this..sort((a, b) => a.zIndex.compareTo(b.zIndex));
}

class _CuePositionDelegate extends SingleChildLayoutDelegate {
  const _CuePositionDelegate(this.cue);

  final ExoSubtitleCue cue;

  double _anchor(int? anchor) => switch (anchor) {
    0 => 0,
    2 => 1,
    _ => .5,
  };

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final positionAnchor =
        cue.positionAnchor ??
        switch (cue.textAlignment) {
          ExoSubtitleAlignment.normal => 0,
          ExoSubtitleAlignment.opposite => 2,
          _ => 1,
        };
    final x =
        (cue.position ?? .5) * size.width -
        _anchor(positionAnchor) * childSize.width;
    final line = cue.line;
    final y = switch ((line, cue.lineType)) {
      (final double line, 0) =>
        line * size.height - _anchor(cue.lineAnchor) * childSize.height,
      (final double line, 1) when line >= 0 => line * childSize.height,
      (final double line, 1) => size.height + line * childSize.height,
      _ => size.height - childSize.height,
    };
    return Offset(x, y);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final width = constraints.maxWidth * (cue.size ?? .9).clamp(.01, 1);
    return BoxConstraints(maxWidth: width, maxHeight: constraints.maxHeight);
  }

  @override
  bool shouldRelayout(covariant _CuePositionDelegate oldDelegate) =>
      oldDelegate.cue != cue;
}
