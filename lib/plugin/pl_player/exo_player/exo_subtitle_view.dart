import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:PiliPlus/plugin/pl_player/models/subtitle_style.dart';
import 'package:flutter/material.dart';

/// Flutter subtitle overlay for the Media3 backend.
///
/// Media3 parses and schedules the subtitle track, then sends active cue text,
/// bitmaps, styles and placement through [ExoPlayerController]. Keeping the
/// overlay in Flutter makes the existing subtitle padding and drag behaviour
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
  final PlayerSubtitleStyle configuration;
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
  ) {
    if (cue.verticalType != null) {
      return _verticalText(cue, style, devicePixelRatio);
    }
    return RichText(
      text: _span(cue, style, devicePixelRatio),
      textAlign:
          cue.multiRowAlignment?.textAlign ??
          cue.textAlignment?.textAlign ??
          widget.configuration.textAlign,
      textScaler: TextScaler.noScaling,
    );
  }

  Widget _verticalText(
    ExoSubtitleCue cue,
    TextStyle style,
    double devicePixelRatio,
  ) {
    final columns = <List<_VerticalGlyph>>[[]];
    var combinedSpans = <TextSpan>[];
    final verticalStyle = style.copyWith(
      fontFeatures: [
        ...?style.fontFeatures,
        const FontFeature('vert'),
        const FontFeature('vrt2'),
      ],
    );

    void flushCombinedText() {
      if (combinedSpans.isEmpty) return;
      columns.last.add(
        _VerticalGlyph(TextSpan(children: combinedSpans), sideways: false),
      );
      combinedSpans = [];
    }

    void addText(
      String text,
      TextStyle characterStyle, {
      bool combineUpright = false,
    }) {
      for (final character in text.characters) {
        if (character == '\n') {
          flushCombinedText();
          columns.add([]);
        } else if (character != '\r') {
          if (combineUpright) {
            combinedSpans.add(TextSpan(text: character, style: characterStyle));
          } else {
            flushCombinedText();
            columns.last.add(
              _VerticalGlyph(
                TextSpan(text: character, style: characterStyle),
                sideways: !_isUprightVertical(character),
              ),
            );
          }
        }
      }
    }

    if (cue.segments.isEmpty) {
      addText(cue.text, verticalStyle);
    } else {
      for (final segment in cue.segments) {
        addText(
          segment.text,
          segment.applyTo(
            verticalStyle,
            devicePixelRatio: devicePixelRatio,
          ),
          combineUpright: segment.combineUpright,
        );
      }
    }
    flushCombinedText();

    final textDirection = cue.verticalType == 1
        ? TextDirection.rtl
        : TextDirection.ltr;
    final textAlign =
        cue.multiRowAlignment?.textAlign ??
        cue.textAlignment?.textAlign ??
        widget.configuration.textAlign;
    final wrapAlignment = switch (textAlign) {
      TextAlign.center => WrapAlignment.center,
      TextAlign.end || TextAlign.right => WrapAlignment.end,
      TextAlign.justify => WrapAlignment.spaceBetween,
      _ => WrapAlignment.start,
    };
    final fontSize = verticalStyle.fontSize ?? 14.0;
    final columnSpacing = math.max(
      0.0,
      fontSize * .2 + (verticalStyle.letterSpacing ?? 0),
    );

    Widget glyph(_VerticalGlyph value) {
      final text = RichText(
        text: value.span,
        textScaler: TextScaler.noScaling,
      );
      return value.sideways ? RotatedBox(quarterTurns: 1, child: text) : text;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        if (!height.isFinite || height <= 0) return const SizedBox.shrink();

        Widget column(List<_VerticalGlyph> values) {
          if (values.isEmpty) {
            return SizedBox(
              width: fontSize + columnSpacing,
              height: cue.size == null ? 0 : height,
            );
          }
          final content = Wrap(
            direction: Axis.vertical,
            alignment: wrapAlignment,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: columnSpacing,
            textDirection: textDirection,
            children: values.map(glyph).toList(growable: false),
          );
          return cue.size == null
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: height),
                  child: content,
                )
              : SizedBox(height: height, child: content);
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: textDirection,
          children: [
            for (var index = 0; index < columns.length; index++) ...[
              if (index > 0) SizedBox(width: columnSpacing),
              column(columns[index]),
            ],
          ],
        );
      },
    );
  }

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
    final bitmap = cue.bitmap;
    final Widget child;
    if (bitmap != null) {
      child = Image.memory(
        bitmap,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      );
    } else if (strokeStyle == null) {
      child = _text(cue, textStyle, devicePixelRatio);
    } else {
      child = Stack(
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
    }
    Widget decoratedChild = child;
    if (cue.windowColor case final color?) {
      decoratedChild = ColoredBox(color: Color(color), child: decoratedChild);
    }
    if (cue.shearDegrees != 0) {
      decoratedChild = Transform(
        alignment: Alignment.center,
        transform: cue.verticalType == null
            ? Matrix4.skewX(cue.shearDegrees * math.pi / 180)
            : Matrix4.skewY(cue.shearDegrees * math.pi / 180),
        child: decoratedChild,
      );
    }
    return decoratedChild;
  }

  Widget _subtitleView(
    BuildContext context,
    List<ExoSubtitleCue> cues,
  ) {
    if (cues.isEmpty) return const SizedBox.shrink();
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return Stack(
          clipBehavior: Clip.none,
          children: cues
              .toList()
              .sortedByZIndex()
              .map(
                (cue) {
                  final cueStyle = _cueStyle(
                    cue,
                    widget.configuration.style,
                    size.height,
                    devicePixelRatio,
                  );
                  final fontSize = cueStyle.fontSize ?? 14.0;
                  final verticalLineExtent = cue.verticalType == null
                      ? null
                      : math.max(
                          1.0,
                          fontSize * 1.2 + (cueStyle.letterSpacing ?? 0),
                        );
                  return Positioned.fill(
                    child: CustomSingleChildLayout(
                      delegate: _CuePositionDelegate(
                        cue,
                        verticalLineExtent: verticalLineExtent,
                      ),
                      child: _cueView(cue, size, devicePixelRatio),
                    ),
                  );
                },
              )
              .toList(growable: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cues = _cues.toList().sortedByZIndex();
    final hasTextCue = cues.any((cue) => cue.bitmap == null);
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final cue in cues)
          Positioned.fill(
            child: cue.bitmap != null
                ? _subtitleView(context, [cue])
                : AnimatedContainer(
                    margin: _padding,
                    duration: _duration,
                    child: _subtitleView(context, [cue]),
                  ),
          ),
        if (widget.enableDragSubtitle && hasTextCue)
          Positioned.fill(
            child: AnimatedContainer(
              margin: _padding,
              duration: _duration,
              child: GestureDetector(
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
                child: const SizedBox.expand(),
              ),
            ),
          ),
      ],
    );
  }
}

bool _isUprightVertical(String character) {
  final codePoints = character.runes;
  if (codePoints.any((value) => value == 0x200D || value >= 0x1F000)) {
    return true;
  }
  final value = codePoints.first;
  return (value >= 0x2E80 && value <= 0xA4CF) ||
      (value >= 0xAC00 && value <= 0xD7AF) ||
      (value >= 0xF900 && value <= 0xFAFF) ||
      (value >= 0xFE10 && value <= 0xFE4F) ||
      (value >= 0xFF00 && value <= 0xFFEF) ||
      (value >= 0x20000 && value <= 0x3FFFF);
}

class _VerticalGlyph {
  const _VerticalGlyph(this.span, {required this.sideways});

  final TextSpan span;
  final bool sideways;
}

extension on List<ExoSubtitleCue> {
  List<ExoSubtitleCue> sortedByZIndex() {
    final indexedCues = indexed.toList()
      ..sort((a, b) {
        final byZIndex = a.$2.zIndex.compareTo(b.$2.zIndex);
        return byZIndex == 0 ? a.$1.compareTo(b.$1) : byZIndex;
      });
    return indexedCues.map((entry) => entry.$2).toList(growable: false);
  }
}

class _CuePositionDelegate extends SingleChildLayoutDelegate {
  const _CuePositionDelegate(this.cue, {this.verticalLineExtent});

  final ExoSubtitleCue cue;
  final double? verticalLineExtent;

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
    final line = cue.line;
    if (cue.verticalType != null) {
      final y =
          (cue.position ?? .5) * size.height -
          _anchor(positionAnchor) * childSize.height;
      final x = switch ((line, cue.lineType)) {
        (final double line, 0) =>
          cue.verticalType == 1
              ? (1 - line) * size.width -
                    childSize.width +
                    _anchor(cue.lineAnchor) * childSize.width
              : line * size.width - _anchor(cue.lineAnchor) * childSize.width,
        (final double line, 1) when line >= 0 =>
          cue.verticalType == 1
              ? size.width -
                    line * (verticalLineExtent ?? childSize.width) -
                    childSize.width
              : line * (verticalLineExtent ?? childSize.width),
        (final double line, 1) =>
          cue.verticalType == 1
              ? (-line - 1) * (verticalLineExtent ?? childSize.width)
              : size.width -
                    (-line - 1) * (verticalLineExtent ?? childSize.width) -
                    childSize.width,
        _ => cue.verticalType == 1 ? size.width - childSize.width : 0.0,
      };
      return Offset(x, y);
    }
    final x =
        (cue.position ?? .5) * size.width -
        _anchor(positionAnchor) * childSize.width;
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
    if (cue.bitmap != null) {
      final pixelWidth = cue.bitmapPixelWidth ?? 0;
      final pixelHeight = cue.bitmapPixelHeight ?? 0;
      final aspectRatio = pixelWidth > 0 && pixelHeight > 0
          ? pixelWidth / pixelHeight
          : 1.0;
      final relativeHeight = cue.bitmapHeight;
      final double width;
      if (cue.size case final relativeWidth?) {
        width = constraints.maxWidth * relativeWidth.clamp(.01, 1);
      } else if (relativeHeight != null) {
        width = constraints.maxHeight * relativeHeight * aspectRatio;
      } else {
        width = pixelWidth > 0 ? pixelWidth.toDouble() : constraints.maxWidth;
      }
      final height = relativeHeight == null
          ? width / aspectRatio
          : constraints.maxHeight * relativeHeight.clamp(.01, 1);
      return BoxConstraints.tightFor(
        width: width.clamp(1, constraints.maxWidth),
        height: height.clamp(1, constraints.maxHeight),
      );
    }
    if (cue.verticalType != null) {
      final height = constraints.maxHeight * (cue.size ?? 1).clamp(.01, 1);
      return BoxConstraints(
        maxWidth: constraints.maxWidth,
        maxHeight: height,
      );
    }
    final width = constraints.maxWidth * (cue.size ?? .9).clamp(.01, 1);
    return BoxConstraints(maxWidth: width, maxHeight: constraints.maxHeight);
  }

  @override
  bool shouldRelayout(covariant _CuePositionDelegate oldDelegate) =>
      oldDelegate.cue != cue;
}
