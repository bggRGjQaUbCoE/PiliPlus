enum DownloadWriteMode { append, overwrite, complete, retryWithoutRange }

final class DownloadResumePlan {
  const DownloadResumePlan(this.mode, this.expectedLength);

  final DownloadWriteMode mode;
  final int? expectedLength;

  void validateCompletedLength(int actualLength) {
    if (expectedLength case final expected? when expected != actualLength) {
      throw StateError(
        'Incomplete download: expected $expected bytes, got $actualLength',
      );
    }
  }
}

abstract final class DownloadResumePolicy {
  static final RegExp _partialRange = RegExp(
    r'^bytes\s+(\d+)-(\d+)/(\d+)$',
    caseSensitive: false,
  );
  static final RegExp _unsatisfiedRange = RegExp(
    r'^bytes\s+\*/(\d+)$',
    caseSensitive: false,
  );

  static DownloadResumePlan fromResponse({
    required int statusCode,
    required int localLength,
    required int contentLength,
    required String? contentRange,
  }) {
    switch (statusCode) {
      case 200:
        return DownloadResumePlan(
          DownloadWriteMode.overwrite,
          contentLength >= 0 ? contentLength : null,
        );
      case 206:
        final match = contentRange == null
            ? null
            : _partialRange.firstMatch(contentRange.trim());
        if (match == null) {
          throw const FormatException('Missing or invalid Content-Range');
        }
        final start = int.parse(match.group(1)!);
        final end = int.parse(match.group(2)!);
        final total = int.parse(match.group(3)!);
        if (start != localLength || end < start || end >= total) {
          throw FormatException(
            'Unexpected Content-Range: $contentRange for $localLength bytes',
          );
        }
        final responseLength = end - start + 1;
        if (contentLength >= 0 && contentLength != responseLength) {
          throw FormatException(
            'Content-Length $contentLength does not match range length '
            '$responseLength',
          );
        }
        return DownloadResumePlan(
          localLength == 0
              ? DownloadWriteMode.overwrite
              : DownloadWriteMode.append,
          total,
        );
      case 416:
        final match = contentRange == null
            ? null
            : _unsatisfiedRange.firstMatch(contentRange.trim());
        if (match == null) {
          throw const FormatException(
            'Missing or invalid unsatisfied Content-Range',
          );
        }
        final total = int.parse(match.group(1)!);
        return DownloadResumePlan(
          total == localLength
              ? DownloadWriteMode.complete
              : DownloadWriteMode.retryWithoutRange,
          total,
        );
      default:
        throw StateError('Unexpected download status: $statusCode');
    }
  }
}
