import 'dart:convert' show base64, utf8;
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:archive/archive.dart' show GZipDecoder;
import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parseFragment;

const _dataUriPrefix = 'data:image/svg+xml;base64,';
final _whitespace = RegExp(r'\s');
final _numberSeparator = RegExp(r'[\s,]+');
final _transformExpression = RegExp(r'([A-Za-z]+)\s*\(([^)]*)\)');

final class WebMaskHeader {
  const WebMaskHeader({required this.segmentCount});

  final int segmentCount;
}

final class WebMaskSegmentIndex {
  const WebMaskSegmentIndex({
    required this.timeMs,
    required this.start,
    required this.end,
  });

  final int timeMs;
  final int start;
  final int end;
}

final class WebMaskIndex {
  const WebMaskIndex({required this.segments, required this.totalLength});

  final List<WebMaskSegmentIndex> segments;
  final int totalLength;

  int segmentFor(int positionMs) {
    var low = 0;
    var high = segments.length;
    while (low < high) {
      final mid = (low + high) >> 1;
      if (segments[mid].timeMs <= positionMs) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return (low - 1).clamp(0, segments.length - 1);
  }
}

final class WebMaskPathData {
  const WebMaskPathData({required this.data, required this.transform});

  final String data;
  final List<double> transform;
}

final class WebMaskFrameData {
  const WebMaskFrameData({
    required this.timeMs,
    required this.viewBox,
    required this.paths,
  });

  const WebMaskFrameData.invalid(this.timeMs) : viewBox = null, paths = null;

  final int timeMs;
  final List<double>? viewBox;
  final List<WebMaskPathData>? paths;

  bool get isValid => viewBox != null && paths != null;
}

final class WebMaskSegmentData {
  const WebMaskSegmentData(this.frames);

  final List<WebMaskFrameData> frames;

  int frameFor(int positionMs) {
    var low = 0;
    var high = frames.length;
    while (low < high) {
      final mid = (low + high) >> 1;
      if (frames[mid].timeMs <= positionMs) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return low - 1;
  }
}

WebMaskHeader parseWebMaskHeader(Uint8List bytes) {
  if (bytes.length < 16 || utf8.decode(bytes.sublist(0, 4)) != 'MASK') {
    throw const FormatException('Invalid webmask header');
  }
  final data = ByteData.sublistView(bytes);
  if (data.getInt32(4, Endian.big) != 1) {
    throw const FormatException('Unsupported webmask version');
  }
  final segmentCount = data.getInt32(12, Endian.big);
  if (segmentCount <= 0) {
    throw const FormatException('Invalid webmask segment count');
  }
  return WebMaskHeader(segmentCount: segmentCount);
}

WebMaskIndex parseWebMaskIndex(Uint8List bytes, int totalLength) {
  final header = parseWebMaskHeader(bytes);
  final indexEnd = 16 + header.segmentCount * 16;
  if (bytes.length < indexEnd || indexEnd >= totalLength) {
    throw const FormatException('Invalid webmask index length');
  }

  final data = ByteData.sublistView(bytes);
  final times = List<int>.filled(header.segmentCount, 0);
  final offsets = List<int>.filled(header.segmentCount, 0);
  for (var i = 0; i < header.segmentCount; i++) {
    final offset = 16 + i * 16;
    final timeMs = data.getInt64(offset, Endian.big);
    final dataOffset = data.getInt64(offset + 8, Endian.big);
    if (timeMs < 0 ||
        (i != 0 && timeMs < times[i - 1]) ||
        dataOffset < indexEnd ||
        dataOffset >= totalLength ||
        (i != 0 && dataOffset <= offsets[i - 1])) {
      throw const FormatException('Invalid webmask segment index');
    }
    times[i] = timeMs;
    offsets[i] = dataOffset;
  }

  return WebMaskIndex(
    totalLength: totalLength,
    segments: List.generate(header.segmentCount, (index) {
      return WebMaskSegmentIndex(
        timeMs: times[index],
        start: offsets[index],
        end: index + 1 == header.segmentCount
            ? totalLength
            : offsets[index + 1],
      );
    }, growable: false),
  );
}

WebMaskSegmentData parseWebMaskSegment(Uint8List compressed) {
  final decoded = Uint8List.fromList(
    const GZipDecoder().decodeBytes(compressed),
  );
  final data = ByteData.sublistView(decoded);
  final frames = <WebMaskFrameData>[];
  var offset = 0;
  var lastTimeMs = -1;

  while (offset < decoded.length) {
    if (decoded.length - offset < 12) {
      throw const FormatException('Truncated webmask frame header');
    }
    final length = data.getInt32(offset, Endian.big);
    final timeMs = data.getInt32(offset + 8, Endian.big);
    final end = offset + 12 + length;
    if (length < _dataUriPrefix.length ||
        timeMs < lastTimeMs ||
        end > decoded.length) {
      throw const FormatException('Invalid webmask frame');
    }

    try {
      final uri = utf8.decode(decoded.sublist(offset + 12, end));
      if (!uri.startsWith(_dataUriPrefix)) {
        throw const FormatException('Invalid webmask SVG data URI');
      }
      final svg = utf8.decode(
        base64.decode(
          uri.substring(_dataUriPrefix.length).replaceAll(_whitespace, ''),
        ),
      );
      frames.add(_parseSvgFrame(timeMs, svg));
    } catch (_) {
      frames.add(WebMaskFrameData.invalid(timeMs));
    }

    lastTimeMs = timeMs;
    offset = end;
  }

  if (frames.isEmpty) {
    throw const FormatException('Empty webmask segment');
  }
  return WebMaskSegmentData(List.unmodifiable(frames));
}

WebMaskFrameData _parseSvgFrame(int timeMs, String source) {
  final document = parseFragment(source);
  final svg = document.querySelector('svg');
  if (svg == null) throw const FormatException('Missing SVG root');

  final viewBox = _numbers(svg.attributes['viewBox'] ?? '');
  if (viewBox.length != 4 || viewBox[2] <= 0 || viewBox[3] <= 0) {
    throw const FormatException('Invalid SVG viewBox');
  }

  final descendants = svg.querySelectorAll('*');
  if (descendants.any((element) {
    return element.localName != 'g' && element.localName != 'path';
  })) {
    throw const FormatException('Unsupported SVG element');
  }

  final paths = <WebMaskPathData>[];
  for (final path in svg.querySelectorAll('path')) {
    final pathData = path.attributes['d'];
    if (pathData == null || pathData.isEmpty) continue;
    paths.add(
      WebMaskPathData(
        data: pathData,
        transform: List.unmodifiable(_elementTransform(path, svg)),
      ),
    );
  }
  if (paths.isEmpty) throw const FormatException('Empty SVG mask');

  return WebMaskFrameData(
    timeMs: timeMs,
    viewBox: List.unmodifiable(viewBox),
    paths: List.unmodifiable(paths),
  );
}

List<double> _elementTransform(Element element, Element svg) {
  final ancestors = <Element>[];
  Element? current = element;
  while (current != null) {
    ancestors.add(current);
    if (identical(current, svg)) break;
    current = current.parent;
  }
  if (ancestors.lastOrNull != svg) {
    throw const FormatException('Invalid SVG hierarchy');
  }

  var result = _identity;
  for (final item in ancestors.reversed) {
    final transform = item.attributes['transform'];
    if (transform != null && transform.isNotEmpty) {
      result = _multiply(result, _parseTransform(transform));
    }
  }
  return result;
}

List<double> _parseTransform(String source) {
  var result = _identity;
  var end = 0;
  for (final match in _transformExpression.allMatches(source)) {
    if (source
        .substring(end, match.start)
        .trim()
        .replaceAll(',', '')
        .isNotEmpty) {
      throw const FormatException('Invalid SVG transform');
    }
    final name = match.group(1)!;
    final values = _numbers(match.group(2)!);
    final List<double> matrix = switch (name) {
      'matrix' when values.length == 6 => values,
      'translate' when values.length == 1 => [1, 0, 0, 1, values[0], 0],
      'translate' when values.length == 2 => [1, 0, 0, 1, ...values],
      'scale' when values.length == 1 => [values[0], 0, 0, values[0], 0, 0],
      'scale' when values.length == 2 => [values[0], 0, 0, values[1], 0, 0],
      'rotate' when values.length == 1 => _rotation(values[0]),
      'rotate' when values.length == 3 => _multiply(
        _multiply([1, 0, 0, 1, values[1], values[2]], _rotation(values[0])),
        [1, 0, 0, 1, -values[1], -values[2]],
      ),
      'skewX' when values.length == 1 => [
        1,
        0,
        math.tan(values[0] * math.pi / 180),
        1,
        0,
        0,
      ],
      'skewY' when values.length == 1 => [
        1,
        math.tan(values[0] * math.pi / 180),
        0,
        1,
        0,
        0,
      ],
      _ => throw const FormatException('Unsupported SVG transform'),
    };
    result = _multiply(result, matrix);
    end = match.end;
  }
  if (end == 0 || source.substring(end).trim().replaceAll(',', '').isNotEmpty) {
    throw const FormatException('Invalid SVG transform');
  }
  return result;
}

List<double> _rotation(double degrees) {
  final radians = degrees * math.pi / 180;
  final cosine = math.cos(radians);
  final sine = math.sin(radians);
  return [cosine, sine, -sine, cosine, 0, 0];
}

List<double> _multiply(List<double> left, List<double> right) {
  return [
    left[0] * right[0] + left[2] * right[1],
    left[1] * right[0] + left[3] * right[1],
    left[0] * right[2] + left[2] * right[3],
    left[1] * right[2] + left[3] * right[3],
    left[0] * right[4] + left[2] * right[5] + left[4],
    left[1] * right[4] + left[3] * right[5] + left[5],
  ];
}

List<double> _numbers(String source) {
  return source
      .trim()
      .split(_numberSeparator)
      .where((value) => value.isNotEmpty)
      .map(double.parse)
      .toList(growable: false);
}

const _identity = <double>[1, 0, 0, 1, 0, 0];
