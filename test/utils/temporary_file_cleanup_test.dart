import 'dart:io';

import 'package:PiliPlus/utils/temporary_file_cleanup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('temporary-media-test-');
  });

  tearDown(() => tempDir.delete(recursive: true));

  Future<File> createOutput(String name) =>
      File('${tempDir.path}/$name').writeAsString('temporary media');

  test('temporary output is deleted after successful save', () async {
    final output = await createOutput('success.tmp');

    final result = await withTemporaryFileCleanup(
      path: output.path,
      action: () => true,
    );

    expect(result, isTrue);
    expect(output.existsSync(), isFalse);
  });

  test('temporary output is deleted after save failure', () async {
    final output = await createOutput('failure.tmp');

    await expectLater(
      withTemporaryFileCleanup<void>(
        path: output.path,
        action: () => throw StateError('save failed'),
      ),
      throwsStateError,
    );

    expect(output.existsSync(), isFalse);
  });

  test('temporary output is deleted after cancellation', () async {
    final output = await createOutput('cancelled.tmp');
    final deletedPaths = <String>[];

    final result = await withTemporaryFileCleanup(
      path: output.path,
      action: () => false,
      delete: (path) async {
        deletedPaths.add(path);
        await File(path).delete();
      },
    );

    expect(result, isFalse);
    expect(deletedPaths, [output.path]);
    expect(output.existsSync(), isFalse);
  });
}
