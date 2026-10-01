/// A single HTTP byte range. Multipart requests are deliberately not supported.
class ByteRange {
  const ByteRange(this.start, this.end, this.suffix);
  final int? start, end, suffix;

  static ByteRange parse(String value) {
    final match = RegExp(r'^bytes=(\d*)-(\d*)$').firstMatch(value);
    if (match == null || (match[1]!.isEmpty && match[2]!.isEmpty)) {
      throw const FormatException('Invalid single byte range');
    }
    final start = int.tryParse(match[1]!);
    final end = int.tryParse(match[2]!);
    if ((match[1]!.isNotEmpty && start == null) ||
        (match[2]!.isNotEmpty && end == null) ||
        (start == null && (end ?? 0) <= 0) ||
        (start != null && end != null && end < start)) {
      throw const FormatException('Invalid byte range bounds');
    }
    return ByteRange(
      start,
      start == null ? null : end,
      start == null ? end : null,
    );
  }

  (int, int)? resolve(int total) {
    if (total <= 0 || (start != null && start! >= total)) return null;
    final first = start ?? (total > suffix! ? total - suffix! : 0);
    final last = end == null || end! >= total ? total - 1 : end!;
    return (first, last);
  }
}

class ContentRange {
  const ContentRange(this.start, this.end, this.total);
  final int start, end, total;
  int get length => end - start + 1;

  static ContentRange parse(String value) {
    final m = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$').firstMatch(value);
    if (m == null) throw const FormatException('Invalid content range');
    final a = int.parse(m[1]!), b = int.parse(m[2]!), n = int.parse(m[3]!);
    if (a > b || b >= n) throw const FormatException('Invalid content bounds');
    return ContentRange(a, b, n);
  }

  bool matches(ByteRange request) => request.resolve(total) == (start, end);
}
