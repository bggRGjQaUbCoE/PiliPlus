import 'dart:async';

import 'package:PiliPlus/pages/video/latest_request_runner.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _TestVideoRequest = ({
  int mediaId,
  String language,
  VideoRequestIntent intent,
});

void main() {
  test(
    'stale work is skipped and the latest request is eventually run',
    () async {
      final first = Completer<String>();
      final second = Completer<String>();
      final started = <int>[];
      final applied = <String>[];

      late final LatestRequestRunner<int> runner;
      runner = LatestRequestRunner<int>((request, isCurrent) async {
        started.add(request);
        final result = await switch (request) {
          1 => first.future,
          2 => second.future,
          _ => throw ArgumentError.value(request),
        };
        if (isCurrent()) {
          applied.add(result);
        }
      });

      final firstRun = runner.run(1);
      await Future<void>.delayed(Duration.zero);
      expect(started, [1]);
      expect(runner.isRunning, isTrue);

      final secondRun = runner.run(2);
      first.complete('first');
      await Future<void>.delayed(Duration.zero);

      expect(started, [1, 2]);
      expect(applied, isEmpty);

      second.complete('second');
      await Future.wait([firstRun, secondRun]);

      expect(applied, ['second']);
      expect(runner.isRunning, isFalse);
    },
  );

  test('a failure always resets the running state', () async {
    var shouldFail = true;
    final runner = LatestRequestRunner<void>((_, _) async {
      if (shouldFail) {
        throw StateError('request failed');
      }
    });

    await expectLater(runner.run(null), throwsStateError);
    expect(runner.isRunning, isFalse);

    shouldFail = false;
    await runner.run(null);
    expect(runner.isRunning, isFalse);
  });

  test('a stale failure does not block the pending latest request', () async {
    final first = Completer<void>();
    final started = <int>[];
    final applied = <int>[];

    late final LatestRequestRunner<int> runner;
    runner = LatestRequestRunner<int>((request, isCurrent) async {
      started.add(request);
      if (request == 1) {
        await first.future;
      }
      if (isCurrent()) {
        applied.add(request);
      }
    });

    final firstRun = runner.run(1);
    await Future<void>.delayed(Duration.zero);
    final secondRun = runner.run(2);
    first.completeError(StateError('stale request failed'));

    await Future.wait([firstRun, secondRun]);

    expect(started, [1, 2]);
    expect(applied, [2]);
    expect(runner.isRunning, isFalse);
  });

  test('multiple pending requests are coalesced to the latest one', () async {
    final first = Completer<void>();
    final started = <int>[];

    final runner = LatestRequestRunner<int>((request, _) async {
      started.add(request);
      if (request == 1) {
        await first.future;
      }
    });

    final firstRun = runner.run(1);
    await Future<void>.delayed(Duration.zero);
    final secondRun = runner.run(2);
    final thirdRun = runner.run(3);
    first.complete();

    await Future.wait([firstRun, secondRun, thirdRun]);

    expect(started, [1, 3]);
    expect(runner.isRunning, isFalse);
  });

  test('request guards remain valid for unawaited side work', () async {
    final sideWork = Completer<void>();
    final sideWorkDone = Completer<void>();
    final applied = <int>[];

    final runner = LatestRequestRunner<int>((request, isCurrent) async {
      if (request == 1) {
        unawaited(() async {
          await sideWork.future;
          if (isCurrent()) {
            applied.add(request);
          }
          sideWorkDone.complete();
        }());
      }
    });

    await runner.run(1);
    await runner.run(2);
    sideWork.complete();
    await sideWorkDone.future;

    expect(applied, isEmpty);
  });

  test(
    'same-media refresh preserves one-time initialization intent',
    () async {
      final first = Completer<void>();
      final started = <_TestVideoRequest>[];
      final runner = LatestRequestRunner<_TestVideoRequest>(
        (request, _) async {
          started.add(request);
          if (started.length == 1) {
            await first.future;
          }
        },
        merge: (previous, next) => previous.mediaId == next.mediaId
            ? (
                mediaId: next.mediaId,
                language: next.language,
                intent: mergeVideoRequestIntent(
                  previous.intent,
                  next.intent,
                ),
              )
            : next,
      );

      final initialRun = runner.run((
        mediaId: 1,
        language: 'default',
        intent: (
          fromReset: false,
          autoFullScreenFlag: true,
          initialProgress: 42000,
        ),
      ));
      await Future<void>.delayed(Duration.zero);
      final refreshRun = runner.run((
        mediaId: 1,
        language: 'updated',
        intent: (
          fromReset: true,
          autoFullScreenFlag: false,
          initialProgress: null,
        ),
      ));
      first.complete();

      await Future.wait([initialRun, refreshRun]);

      expect(started, hasLength(2));
      expect(started.last.language, 'updated');
      expect(
        started.last.intent,
        (
          fromReset: false,
          autoFullScreenFlag: true,
          initialProgress: 42000,
        ),
      );
    },
  );
}
