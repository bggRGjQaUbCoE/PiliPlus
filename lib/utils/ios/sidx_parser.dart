// Adapted from nishuodedui1145-del/PiliPlus (GPL-3.0),
// lib/services/btr_proxy/sidx_parser.dart; only MP4 index parsing is retained.
import 'dart:typed_data';

/// SIDX 数据分片信息
class SidxSegment {
  final int index;
  final int start;
  final int end;
  final int length;
  final int time;
  final int duration;
  final double startTime;
  final double endTime;
  final double durationSeconds;

  SidxSegment({
    required this.index,
    required this.start,
    required this.end,
    required this.length,
    required this.time,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
  });
}

/// SIDX 解析结果
class SidxResult {
  final List<SidxSegment> segments;
  final int timescale;
  final int earliestPresentationTime;
  final int firstOffset;

  SidxResult({
    required this.segments,
    required this.timescale,
    required this.earliestPresentationTime,
    required this.firstOffset,
  });
}

/// SIDX 解析器
abstract final class SidxParser {
  /// 读取 64位无符号整型
  static int? _readUint64(ByteData view, int offset) {
    final high = view.getUint32(offset);
    final low = view.getUint32(offset + 4);
    // 组合高低位，Dart 的 int 支持 64位
    final value = (high * 4294967296) + low;
    return value;
  }

  /// 读取 Box 类型
  static String _readType(Uint8List bytes, int offset) {
    return String.fromCharCodes(bytes.sublist(offset, offset + 4));
  }

  /// 解析 SIDX box
  static SidxResult? parseSidx(Uint8List bytes, [int absoluteStart = 0]) {
    final view = ByteData.sublistView(bytes);
    int boxOffset = 0;

    while (boxOffset + 8 <= bytes.length) {
      int boxSize = view.getUint32(boxOffset);
      final type = _readType(bytes, boxOffset + 4);
      int headerSize = 8;

      if (boxSize == 1) {
        if (boxOffset + 16 > bytes.length) return null;
        boxSize = _readUint64(view, boxOffset + 8) ?? 0;
        headerSize = 16;
      } else if (boxSize == 0) {
        boxSize = bytes.length - boxOffset;
      }

      if (boxSize == 0 ||
          boxSize < headerSize ||
          boxOffset + boxSize > bytes.length) {
        return null;
      }

      if (type == 'sidx') {
        int cursor = boxOffset + headerSize;
        if (cursor + 12 > boxOffset + boxSize) return null;

        final version = view.getUint8(cursor);
        cursor += 4; // skip version & flags
        cursor += 4; // skip reference_ID

        final timescale = view.getUint32(cursor);
        cursor += 4;
        if (timescale == 0) return null;

        int earliestPresentationTime;
        int firstOffset;

        if (version == 0) {
          if (cursor + 8 > boxOffset + boxSize) return null;
          earliestPresentationTime = view.getUint32(cursor);
          firstOffset = view.getUint32(cursor + 4);
          cursor += 8;
        } else if (version == 1) {
          if (cursor + 16 > boxOffset + boxSize) return null;
          earliestPresentationTime = _readUint64(view, cursor) ?? 0;
          firstOffset = _readUint64(view, cursor + 8) ?? 0;
          cursor += 16;
        } else {
          return null;
        }

        cursor += 2; // skip reserved
        if (cursor + 2 > boxOffset + boxSize) return null;
        final referenceCount = view.getUint16(cursor);
        cursor += 2;

        if (referenceCount < 1 ||
            referenceCount > 10000 ||
            cursor + referenceCount * 12 > boxOffset + boxSize) {
          return null;
        }

        int byteCursor = absoluteStart + boxOffset + boxSize + firstOffset;
        int timeCursor = earliestPresentationTime;
        final segments = <SidxSegment>[];

        for (int index = 0; index < referenceCount; index += 1) {
          final reference = view.getUint32(cursor);
          final referenceType = (reference >> 31) & 1;
          final referencedSize = reference & 0x7fffffff;
          final duration = view.getUint32(cursor + 4);
          cursor += 12;

          if (referencedSize == 0) return null;

          // Hierarchical indexes need recursive fetches; reject them instead
          // of generating an incomplete HLS media playlist.
          if (referenceType != 0) {
            return null;
          }

          segments.add(
            SidxSegment(
              index: segments.length,
              start: byteCursor,
              end: byteCursor + referencedSize - 1,
              length: referencedSize,
              time: timeCursor,
              duration: duration,
              startTime: timeCursor / timescale,
              endTime: (timeCursor + duration) / timescale,
              durationSeconds: duration / timescale,
            ),
          );
          byteCursor += referencedSize;
          timeCursor += duration;
        }

        if (segments.isEmpty) return null;

        return SidxResult(
          earliestPresentationTime: earliestPresentationTime,
          firstOffset: firstOffset,
          segments: segments,
          timescale: timescale,
        );
      }
      boxOffset += boxSize;
    }
    return null;
  }
}
