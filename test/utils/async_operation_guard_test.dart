import 'dart:async';

import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:flutter_test/flutter_test.dart';

class _ReplyTarget {
  int likeCount = 0;
}

void main() {
  test(
    'rapid reply reactions issue one mutation and one count delta',
    () async {
      final response = Completer<void>();
      final guard = AsyncOperationGuard();
      var requestCount = 0;
      final firstTarget = _ReplyTarget();
      final replacementTarget = _ReplyTarget();
      var currentTarget = firstTarget;

      Future<void> likeReply() async {
        final target = currentTarget;
        requestCount += 1;
        await response.future;
        target.likeCount += 1;
      }

      final firstTap = guard.run(likeReply);
      currentTarget = replacementTarget;
      final secondTap = guard.run(likeReply);

      expect(requestCount, 1);
      expect(guard.isProcessing, isTrue);

      response.complete();
      await Future.wait([firstTap, secondTap]);

      expect(requestCount, 1);
      expect(firstTarget.likeCount, 1);
      expect(replacementTarget.likeCount, 0);
      expect(guard.isProcessing, isFalse);
    },
  );

  test('early return and failure both release the operation gate', () async {
    final guard = AsyncOperationGuard();
    var requestCount = 0;

    await guard.run(() {
      requestCount += 1;
    });
    expect(requestCount, 1);
    expect(guard.isProcessing, isFalse);

    await expectLater(
      guard.run(() {
        requestCount += 1;
        return Future<void>.error(StateError('request failed'));
      }),
      throwsStateError,
    );
    expect(requestCount, 2);
    expect(guard.isProcessing, isFalse);

    await guard.run(() {
      requestCount += 1;
    });

    expect(requestCount, 3);
    expect(guard.isProcessing, isFalse);
  });

  test(
    'keyed guard serializes only operations for the same resource',
    () async {
      final firstResponse = Completer<void>();
      final guard = AsyncKeyedOperationGuard<String>();
      final events = <String>[];

      final first = guard.run('dynamic-1', () async {
        events.add('first:start');
        await firstResponse.future;
        events.add('first:end');
      });
      final duplicate = guard.run('dynamic-1', () {
        events.add('duplicate');
      });
      final other = guard.run('dynamic-2', () {
        events.add('other');
      });

      await Future.wait([duplicate, other]);
      expect(events, ['first:start', 'other']);

      firstResponse.complete();
      await first;
      await guard.run('dynamic-1', () {
        events.add('after');
      });

      expect(events, ['first:start', 'other', 'first:end', 'after']);
      expect(guard.trackedKeyCount, 0);
    },
  );

  test('keyed guard releases failed operations before retry', () async {
    final guard = AsyncKeyedOperationGuard<String>();

    await expectLater(
      guard.run('dynamic-1', () => throw StateError('request failed')),
      throwsStateError,
    );
    expect(guard.trackedKeyCount, 0);

    var retried = false;
    await guard.run('dynamic-1', () {
      retried = true;
    });

    expect(retried, isTrue);
    expect(guard.trackedKeyCount, 0);
  });
}
