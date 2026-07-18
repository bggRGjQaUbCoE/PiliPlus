import 'dart:async';

import 'package:PiliPlus/utils/cancellable_batch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'cancellation during fetch prevents the completion side effect',
    () async {
      final response = Completer<int>();
      var cancelled = false;
      var saveCount = 0;

      final batch = runCancellableBatch(
        tasks: [() => response.future],
        isCancelled: () => cancelled,
        onComplete: (_) async {
          saveCount++;
        },
      );

      cancelled = true;
      response.complete(1);

      expect(await batch, isFalse);
      expect(saveCount, 0);
    },
  );

  test('pre-cancellation does not start lazy tasks', () async {
    var taskStarted = false;
    var saveCount = 0;

    final result = await runCancellableBatch(
      tasks: [
        () => Future<int>.sync(() {
          taskStarted = true;
          return 1;
        }),
      ],
      isCancelled: () => true,
      onComplete: (_) async {
        saveCount++;
      },
    );

    expect(result, isFalse);
    expect(taskStarted, isFalse);
    expect(saveCount, 0);
  });

  test('a live batch completes once with all results', () async {
    List<int>? saved;

    final result = await runCancellableBatch(
      tasks: [
        () async => 1,
        () async => 2,
      ],
      isCancelled: () => false,
      onComplete: (results) async {
        saved = results;
      },
    );

    expect(result, isTrue);
    expect(saved, [1, 2]);
  });
}
