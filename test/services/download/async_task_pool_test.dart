import 'dart:async';

import 'package:PiliPlus/services/download/async_task_pool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('limits concurrent work across all callers', () async {
    final pool = AsyncTaskPool(3);
    final release = Completer<void>();
    var active = 0;
    var maxActive = 0;

    final tasks = List.generate(
      20,
      (_) => pool.run(() async {
        active += 1;
        if (active > maxActive) maxActive = active;
        await release.future;
        active -= 1;
      }),
    );
    await Future<void>.delayed(Duration.zero);

    expect(maxActive, 3);
    release.complete();
    await Future.wait(tasks);
    expect(maxActive, 3);
    expect(active, 0);
  });

  test('releases a slot when a task fails', () async {
    final pool = AsyncTaskPool(1);

    await expectLater(
      pool.run<void>(() async => throw StateError('failed')),
      throwsStateError,
    );
    await expectLater(pool.run(() async => 42), completion(42));
  });
}
