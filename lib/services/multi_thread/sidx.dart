import 'dart:typed_data';

class SidxSegment {
  final int start;
  final int end;
  final double startTime;
  final double endTime;

  const SidxSegment({
    required this.start,
    required this.end,
    required this.startTime,
    required this.endTime,
  });
}

/// 解析 DASH 分段索引（sidx box），返回每个媒体分段的字节范围与时间范围。
/// [absoluteStart] 为 [bytes] 在文件中的起始偏移。
List<SidxSegment>? parseSidx(Uint8List bytes, int absoluteStart) {
  final view = ByteData.sublistView(bytes);
  var boxOffset = 0;
  while (boxOffset + 8 <= bytes.length) {
    var boxSize = view.getUint32(boxOffset);
    final type = String.fromCharCodes(bytes, boxOffset + 4, boxOffset + 8);
    var headerSize = 8;
    if (boxSize == 1) {
      if (boxOffset + 16 > bytes.length) return null;
      boxSize = view.getUint64(boxOffset + 8);
      headerSize = 16;
    } else if (boxSize == 0) {
      boxSize = bytes.length - boxOffset;
    }
    if (boxSize < headerSize || boxOffset + boxSize > bytes.length) return null;

    if (type == 'sidx') {
      final boxEnd = boxOffset + boxSize;
      var cursor = boxOffset + headerSize;
      if (cursor + 12 > boxEnd) return null;
      final version = view.getUint8(cursor);
      cursor += 4; // version + flags
      cursor += 4; // reference_ID
      final timescale = view.getUint32(cursor);
      cursor += 4;
      if (timescale == 0) return null;

      final int earliestPresentationTime;
      final int firstOffset;
      if (version == 0) {
        if (cursor + 8 > boxEnd) return null;
        earliestPresentationTime = view.getUint32(cursor);
        firstOffset = view.getUint32(cursor + 4);
        cursor += 8;
      } else if (version == 1) {
        if (cursor + 16 > boxEnd) return null;
        earliestPresentationTime = view.getUint64(cursor);
        firstOffset = view.getUint64(cursor + 8);
        cursor += 16;
      } else {
        return null;
      }

      cursor += 2; // reserved
      if (cursor + 2 > boxEnd) return null;
      final referenceCount = view.getUint16(cursor);
      cursor += 2;
      if (referenceCount < 1 ||
          referenceCount > 10000 ||
          cursor + referenceCount * 12 > boxEnd) {
        return null;
      }

      var byteCursor = absoluteStart + boxEnd + firstOffset;
      var timeCursor = earliestPresentationTime;
      final segments = <SidxSegment>[];
      for (var i = 0; i < referenceCount; i++) {
        final reference = view.getUint32(cursor);
        final referenceType = reference >> 31;
        final referencedSize = reference & 0x7fffffff;
        final duration = view.getUint32(cursor + 4);
        cursor += 12;
        if (referencedSize == 0) return null;
        if (referenceType == 0) {
          segments.add(
            SidxSegment(
              start: byteCursor,
              end: byteCursor + referencedSize - 1,
              startTime: timeCursor / timescale,
              endTime: (timeCursor + duration) / timescale,
            ),
          );
        }
        byteCursor += referencedSize;
        timeCursor += duration;
      }
      return segments.isEmpty ? null : segments;
    }
    boxOffset += boxSize;
  }
  return null;
}
