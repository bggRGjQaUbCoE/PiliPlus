import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ExoSubtitleAlignment {
  normal,
  center,
  opposite;

  static ExoSubtitleAlignment? fromName(String? name) => switch (name) {
    'normal' => normal,
    'center' => center,
    'opposite' => opposite,
    _ => null,
  };

  TextAlign? get textAlign => switch (this) {
    normal => TextAlign.start,
    center => TextAlign.center,
    opposite => TextAlign.end,
  };
}

class ExoSubtitleSegment {
  const ExoSubtitleSegment({
    required this.text,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikethrough = false,
    this.combineUpright = false,
    this.foregroundColor,
    this.backgroundColor,
    this.fontFamily,
    this.absoluteSize,
    this.absoluteSizeIsDip = false,
    this.relativeSize,
  });

  factory ExoSubtitleSegment.fromMap(Map<Object?, Object?> map) {
    return ExoSubtitleSegment(
      text: map['text'] as String? ?? '',
      bold: map['bold'] as bool? ?? false,
      italic: map['italic'] as bool? ?? false,
      underline: map['underline'] as bool? ?? false,
      strikethrough: map['strikethrough'] as bool? ?? false,
      combineUpright: map['combineUpright'] as bool? ?? false,
      foregroundColor: (map['foregroundColor'] as num?)?.toInt(),
      backgroundColor: (map['backgroundColor'] as num?)?.toInt(),
      fontFamily: map['fontFamily'] as String?,
      absoluteSize: (map['absoluteSize'] as num?)?.toDouble(),
      absoluteSizeIsDip: map['absoluteSizeIsDip'] as bool? ?? false,
      relativeSize: (map['relativeSize'] as num?)?.toDouble(),
    );
  }

  final String text;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
  final bool combineUpright;
  final int? foregroundColor;
  final int? backgroundColor;
  final String? fontFamily;
  final double? absoluteSize;
  final bool absoluteSizeIsDip;
  final double? relativeSize;

  TextStyle applyTo(TextStyle base, {double devicePixelRatio = 1}) {
    final decorations = <TextDecoration>[
      if (underline) TextDecoration.underline,
      if (strikethrough) TextDecoration.lineThrough,
    ];
    var fontSize = base.fontSize;
    if (absoluteSize case final size?) {
      fontSize = absoluteSizeIsDip ? size : size / devicePixelRatio;
    }
    if (relativeSize case final scale?) {
      fontSize = (fontSize ?? 14) * scale;
    }
    return base.copyWith(
      color: foregroundColor == null ? null : Color(foregroundColor!),
      backgroundColor: backgroundColor == null ? null : Color(backgroundColor!),
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.bold : null,
      fontStyle: italic ? FontStyle.italic : null,
      decoration: decorations.isEmpty
          ? base.decoration
          : TextDecoration.combine(decorations),
    );
  }
}

class ExoSubtitleCue {
  const ExoSubtitleCue({
    required this.text,
    required this.segments,
    this.bitmap,
    this.bitmapPixelWidth,
    this.bitmapPixelHeight,
    this.bitmapHeight,
    this.textAlignment,
    this.multiRowAlignment,
    this.line,
    this.lineType,
    this.lineAnchor,
    this.position,
    this.positionAnchor,
    this.size,
    this.windowColor,
    this.textSizeType,
    this.textSize,
    this.verticalType,
    this.shearDegrees = 0,
    this.zIndex = 0,
  });

  factory ExoSubtitleCue.fromMap(Map<Object?, Object?> map) {
    final rawSegments = map['segments'];
    final rawBitmap = map['bitmap'];
    return ExoSubtitleCue(
      text: map['text'] as String? ?? '',
      segments: rawSegments is List
          ? rawSegments
                .whereType<Map>()
                .map(
                  (segment) => ExoSubtitleSegment.fromMap(
                    Map<Object?, Object?>.from(segment),
                  ),
                )
                .toList(growable: false)
          : const [],
      bitmap: switch (rawBitmap) {
        final Uint8List bytes => bytes,
        final List<int> bytes => Uint8List.fromList(bytes),
        _ => null,
      },
      bitmapPixelWidth: (map['bitmapPixelWidth'] as num?)?.toInt(),
      bitmapPixelHeight: (map['bitmapPixelHeight'] as num?)?.toInt(),
      bitmapHeight: (map['bitmapHeight'] as num?)?.toDouble(),
      textAlignment: ExoSubtitleAlignment.fromName(
        map['textAlignment'] as String?,
      ),
      multiRowAlignment: ExoSubtitleAlignment.fromName(
        map['multiRowAlignment'] as String?,
      ),
      line: (map['line'] as num?)?.toDouble(),
      lineType: (map['lineType'] as num?)?.toInt(),
      lineAnchor: (map['lineAnchor'] as num?)?.toInt(),
      position: (map['position'] as num?)?.toDouble(),
      positionAnchor: (map['positionAnchor'] as num?)?.toInt(),
      size: (map['size'] as num?)?.toDouble(),
      windowColor: (map['windowColor'] as num?)?.toInt(),
      textSizeType: (map['textSizeType'] as num?)?.toInt(),
      textSize: (map['textSize'] as num?)?.toDouble(),
      verticalType: (map['verticalType'] as num?)?.toInt(),
      shearDegrees: (map['shearDegrees'] as num?)?.toDouble() ?? 0,
      zIndex: (map['zIndex'] as num?)?.toInt() ?? 0,
    );
  }

  final String text;
  final List<ExoSubtitleSegment> segments;
  final Uint8List? bitmap;
  final int? bitmapPixelWidth;
  final int? bitmapPixelHeight;
  final double? bitmapHeight;
  final ExoSubtitleAlignment? textAlignment;
  final ExoSubtitleAlignment? multiRowAlignment;
  final double? line;
  final int? lineType;
  final int? lineAnchor;
  final double? position;
  final int? positionAnchor;
  final double? size;
  final int? windowColor;
  final int? textSizeType;
  final double? textSize;
  final int? verticalType;
  final double shearDegrees;
  final int zIndex;
}
