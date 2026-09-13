import 'package:PiliPlus/services/download/download_resume.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DownloadResumePolicy', () {
    test('overwrites when a server ignores a range request', () {
      final plan = DownloadResumePolicy.fromResponse(
        statusCode: 200,
        localLength: 100,
        contentLength: 500,
        contentRange: null,
      );

      expect(plan.mode, DownloadWriteMode.overwrite);
      expect(plan.expectedLength, 500);
    });

    test('appends only an exactly matching partial response', () {
      final plan = DownloadResumePolicy.fromResponse(
        statusCode: 206,
        localLength: 100,
        contentLength: 400,
        contentRange: 'bytes 100-499/500',
      );

      expect(plan.mode, DownloadWriteMode.append);
      expect(plan.expectedLength, 500);
    });

    test('rejects a partial response starting at the wrong offset', () {
      expect(
        () => DownloadResumePolicy.fromResponse(
          statusCode: 206,
          localLength: 100,
          contentLength: 500,
          contentRange: 'bytes 0-499/500',
        ),
        throwsFormatException,
      );
    });

    test('accepts 416 only when the local file is already complete', () {
      final complete = DownloadResumePolicy.fromResponse(
        statusCode: 416,
        localLength: 500,
        contentLength: 0,
        contentRange: 'bytes */500',
      );
      final stale = DownloadResumePolicy.fromResponse(
        statusCode: 416,
        localLength: 600,
        contentLength: 0,
        contentRange: 'bytes */500',
      );

      expect(complete.mode, DownloadWriteMode.complete);
      expect(stale.mode, DownloadWriteMode.retryWithoutRange);
    });

    test('rejects mismatched response and final lengths', () {
      expect(
        () => DownloadResumePolicy.fromResponse(
          statusCode: 206,
          localLength: 100,
          contentLength: 399,
          contentRange: 'bytes 100-499/500',
        ),
        throwsFormatException,
      );

      const plan = DownloadResumePlan(DownloadWriteMode.append, 500);
      expect(() => plan.validateCompletedLength(499), throwsStateError);
      expect(() => plan.validateCompletedLength(500), returnsNormally);
    });
  });
}
