import 'dart:math';

import 'package:characters/characters.dart';

class AirPlayComment {
  const AirPlayComment(
    this.timeMs,
    this.mode,
    this.text, [
    this.color = 0xffffff,
  ]);
  final int timeMs;
  final int mode;
  final String text;
  final int color;
}

/// A snapshot of the player's full-screen danmaku preferences. Positions and
/// font size are percentages of the video, independent of receiver resolution.
class AirPlayDanmakuStyle {
  const AirPlayDanmakuStyle({
    this.duration = 7,
    this.staticDuration = 4,
    this.area = 0.5,
    this.fontSize = 4.5,
    this.fontWeight = 4,
    this.opacity = 1,
    this.strokeWidth = 1.5,
    this.lineHeight = 1.6,
    this.aspectRatio = 16 / 9,
    this.hideScroll = false,
    this.hideTop = false,
    this.hideBottom = false,
    this.whiteOnly = false,
    this.fixedVelocity = false,
    this.static2Scroll = false,
    this.massiveMode = false,
    this.fontFamily,
  });
  final double duration, staticDuration, area, fontSize, opacity, strokeWidth;
  final double lineHeight, aspectRatio;
  final int fontWeight;
  final bool hideScroll, hideTop, hideBottom, whiteOnly;
  final bool fixedVelocity, static2Scroll, massiveMode;
  final String? fontFamily;

  Map<String, Object> get nativeStyle => {
    'fontSize': fontSize,
    'bold': fontWeight >= 5,
    'opacity': opacity,
    'outline': strokeWidth > 0,
    'fontFamily': ?fontFamily,
  };
}

typedef _Cue = ({int start, int end, String settings, String text});
typedef _Moving = ({int time, double width, double velocity});

const _captionStepMs = 50;
const _maxActiveComments = 2;

String _vtt(List<_Cue> cues, [String styles = '']) {
  final result = StringBuffer(
    'WEBVTT\nX-TIMESTAMP-MAP=LOCAL:00:00:00.000,MPEGTS:0\n\n$styles',
  );
  for (final cue in cues) {
    // RFC 8216 section 3.5 requires complete cue times in every intersecting
    // segment. Omit optional identifiers instead of changing them per segment.
    result
      ..writeln('${_time(cue.start)} --> ${_time(cue.end)} ${cue.settings}')
      ..writeln(cue.text)
      ..writeln();
  }
  return result.toString();
}

/// Plain, fixed-width WebVTT cues for receivers without CSS cue styling.
/// Native text style rules still supply the user's font size and outline.
String airPlayDanmakuCompatibleVtt(
  List<AirPlayComment> comments,
  int segment, {
  AirPlayDanmakuStyle style = const AirPlayDanmakuStyle(),
  double Function(String)? measureWidth,
  int segmentDurationMs = 360000,
}) {
  final start = segment * segmentDurationMs;
  final end = start + segmentDurationMs;
  final rowHeight = (style.fontSize * style.lineHeight).clamp(4.0, 30.0);
  final lanes = List.filled(
    max(1, (style.area.clamp(0.05, 1.0) * 94 / rowHeight).floor()),
    0,
  );
  final cues = <_Cue>[];
  final sorted = comments.toList()
    ..sort((a, b) => a.timeMs.compareTo(b.timeMs));
  for (final comment in sorted) {
    if (comment.timeMs >= end ||
        comment.mode < 1 ||
        comment.mode > 6 ||
        comment.text.trim().isEmpty ||
        style.opacity <= 0) {
      continue;
    }
    final mode = comment.mode;
    if ((mode == 4 && style.hideBottom) ||
        (mode == 5 && style.hideTop) ||
        (mode != 4 && mode != 5 && style.hideScroll)) {
      continue;
    }
    final text = _escape(comment.text.replaceAll(RegExp(r'[\r\n]+'), ' '));
    if (mode == 4 || mode == 5) {
      final until = comment.timeMs + (style.staticDuration * 1000).round();
      if (until <= start) continue;
      cues.add((
        start: comment.timeMs,
        end: until,
        settings:
            'line:${mode == 4 ? 90 : 5}% position:50% align:center size:90%',
        text: text,
      ));
      continue;
    }
    final lane = lanes.indexWhere((freeAt) => freeAt <= comment.timeMs);
    if (lane < 0) continue;
    final duration = max(1000, (style.duration * 1000).round());
    lanes[lane] = comment.timeMs + duration;
    if (comment.timeMs + duration <= start) continue;
    final width =
        (measureWidth?.call(comment.text) ?? comment.text.runes.length * 3.0)
            .clamp(15.0, 80.0);
    for (var elapsed = 0; elapsed < duration; elapsed += 50) {
      final time = comment.timeMs + elapsed;
      final until = min(comment.timeMs + duration, time + 50);
      if (until <= start || time >= end) continue;
      final position = (100 - width) * (1 - elapsed / duration);
      cues.add((
        start: time,
        end: until,
        settings:
            'line:${(5 + lane * rowHeight).toStringAsFixed(2)}% '
            'position:${position.toStringAsFixed(2)}%,line-left align:left '
            'size:${width.toStringAsFixed(2)}%',
        text: text,
      ));
    }
  }
  cues.sort((a, b) => a.start.compareTo(b.start));
  return _vtt(cues);
}

/// WebVTT has no motion or clipping command. Update all moving cues on one
/// bounded 20 Hz clock and remove whole graphemes beyond either edge. Independent
/// per-comment clocks stall the Apple TV caption renderer even at low density.
/// Limit concurrent comments to two to keep this smoother clock sustainable.
/// Receivers still control glyph rendering, so clipping is by whole grapheme.
String airPlayDanmakuVtt(
  List<AirPlayComment> comments,
  int segment, {
  AirPlayDanmakuStyle style = const AirPlayDanmakuStyle(),
  double Function(String)? measureWidth,
  int segmentDurationMs = 360000,
}) {
  final start = segment * segmentDurationMs;
  final end = start + segmentDurationMs;
  final cues = <_Cue>[];
  final fontSize = style.fontSize.clamp(1.0, 15.0);
  final rowHeight = (fontSize * style.lineHeight).clamp(fontSize, 30.0);
  final laneCount = max(
    1,
    (style.area.clamp(0.05, 1.0) * 94 / rowHeight).floor(),
  );
  final moving = List<_Moving?>.filled(laneCount, null);
  final fixed = List.filled(laneCount, 0);
  final activeUntil = List.filled(_maxActiveComments, 0);
  final sorted = comments.toList()
    ..sort((a, b) => a.timeMs.compareTo(b.timeMs));
  final colors = <int>{};
  final glyphWidths = <String, double>{};
  var overflowLane = 0;
  double measure(String text) =>
      measureWidth?.call(text) ??
      text.characters.fold<double>(
        0,
        (w, c) =>
            w + (c.runes.first < 128 ? 0.55 : 1) * fontSize / style.aspectRatio,
      );

  for (final comment in sorted) {
    if (comment.timeMs >= end ||
        comment.mode < 1 ||
        comment.mode > 6 ||
        comment.text.trim().isEmpty ||
        style.opacity <= 0) {
      continue;
    }
    final mode = comment.mode;
    if ((mode == 4 && style.hideBottom) ||
        (mode == 5 && style.hideTop) ||
        (mode != 4 && mode != 5 && style.hideScroll)) {
      continue;
    }
    final slot = activeUntil.indexWhere((until) => until <= comment.timeMs);
    if (slot < 0) continue;
    final plain = comment.text.replaceAll(RegExp(r'[\r\n]+'), ' ');
    final color = style.whiteOnly ? 0xffffff : comment.color & 0xffffff;
    final hex = color.toRadixString(16).padLeft(6, '0');
    String markup(String text) => '<c.color$hex>${_escape(text)}</c>';
    colors.add(color);

    if (mode == 4 || mode == 5) {
      final order = List.generate(
        laneCount,
        (i) => mode == 4 ? laneCount - 1 - i : i,
      );
      var lane = order.firstWhere(
        (i) => fixed[i] <= comment.timeMs,
        orElse: () => -1,
      );
      if (lane < 0 && style.massiveMode) lane = overflowLane++ % laneCount;
      if (lane >= 0) {
        final until = comment.timeMs + (style.staticDuration * 1000).round();
        fixed[lane] = until;
        activeUntil[slot] = until;
        if (until <= start) continue;
        final line = mode == 4
            ? 97 - (laneCount - 1 - lane) * rowHeight
            : 3 + lane * rowHeight;
        cues.add((
          start: comment.timeMs,
          end: until,
          settings:
              'line:${line.toStringAsFixed(2)}%,${mode == 4 ? 'end' : 'start'} '
              'position:50%,center align:center size:96%',
          text: markup(plain),
        ));
        continue;
      }
      if (!style.static2Scroll || style.hideScroll) continue;
    }

    final glyphs = plain.characters.toList();
    final offsets = <double>[0];
    for (final glyph in glyphs) {
      offsets.add(
        offsets.last + glyphWidths.putIfAbsent(glyph, () => measure(glyph)),
      );
    }
    final width = offsets.last;
    if (width <= 0) continue;
    final durationMs = max(1000, (style.duration * 1000).round());
    final velocity = (style.fixedVelocity ? 100 : 100 + width) / durationMs;
    final travelMs = ((100 + width) / velocity).ceil();
    var lane = moving.indexWhere((previous) {
      if (previous == null) return true;
      final x = 100 - previous.velocity * (comment.timeMs - previous.time);
      final right = x + previous.width;
      if (right + fontSize / style.aspectRatio > 100) return false;
      // A faster, wider comment must not catch the preceding one before exit.
      return right <= 0 ||
          velocity <= previous.velocity ||
          (100 - right) / (velocity - previous.velocity) >=
              right / previous.velocity;
    });
    if (lane < 0 && style.massiveMode) lane = overflowLane++ % laneCount;
    if (lane < 0) continue;
    activeUntil[slot] = comment.timeMs + travelMs;
    moving[lane] = (time: comment.timeMs, width: width, velocity: velocity);
    if (comment.timeMs + travelMs <= start) continue;
    for (
      var time =
          ((comment.timeMs + _captionStepMs - 1) ~/ _captionStepMs) *
          _captionStepMs;
      time < comment.timeMs + travelMs;
      time += _captionStepMs
    ) {
      final elapsed = time - comment.timeMs;
      final until = min(comment.timeMs + travelMs, time + _captionStepMs);
      if (until <= start || time >= end) continue;
      final x = 100 - elapsed * velocity;
      var first = 0;
      var last = glyphs.length;
      // Keep complete graphemes inside the viewport; do not split emoji or
      // combining marks and do not let native line-box clamping move a full row.
      while (first < last && x + offsets[first] < 0.5) {
        first++;
      }
      while (last > first && x + offsets[last] > 99.5) {
        last--;
      }
      if (first == last) continue;
      final position = (x + offsets[first]).clamp(0.5, 99.0);
      final visible = glyphs.sublist(first, last).join('\u2060');
      cues.add((
        start: time,
        end: until,
        settings:
            'line:${(3 + lane * rowHeight).toStringAsFixed(2)}%,start '
            'position:${position.toStringAsFixed(3)}%,line-left align:left '
            'size:${min(100 - position, offsets[last] - offsets[first] + 0.4).toStringAsFixed(3)}%',
        text: markup(visible),
      ));
    }
  }
  cues.sort((a, b) {
    final time = a.start.compareTo(b.start);
    if (time != 0) return time;
    final settings = a.settings.compareTo(b.settings);
    return settings != 0 ? settings : a.text.compareTo(b.text);
  });
  final result = StringBuffer('STYLE\n');
  final alpha = style.opacity.clamp(0.0, 1.0).toStringAsFixed(3);
  final stroke = style.strokeWidth.clamp(0.0, 5.0).toStringAsFixed(2);
  result.writeln(
    '::cue { background-color: transparent; '
    'font-size: ${fontSize.toStringAsFixed(3)}vh; '
    'font-weight: ${(style.fontWeight.clamp(0, 8) + 1) * 100}; '
    'text-shadow: ${style.strokeWidth <= 0 ? 'none' : '-${stroke}px 0 black, 0 ${stroke}px black, ${stroke}px 0 black, 0 -${stroke}px black'}; }',
  );
  for (final color in colors) {
    final hex = color.toRadixString(16).padLeft(6, '0');
    result.writeln(
      '::cue(.color$hex) { color: rgba(${color >> 16}, ${(color >> 8) & 255}, ${color & 255}, $alpha); }',
    );
  }
  result.writeln();
  return _vtt(cues, result.toString());
}

String _escape(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _time(int milliseconds) {
  final hours = milliseconds ~/ 3600000;
  final minutes = milliseconds ~/ 60000 % 60;
  final seconds = milliseconds ~/ 1000 % 60;
  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}.'
      '${(milliseconds % 1000).toString().padLeft(3, '0')}';
}
