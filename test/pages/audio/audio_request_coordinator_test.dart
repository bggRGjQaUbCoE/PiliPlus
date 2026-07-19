import 'dart:async';

import 'package:PiliPlus/pages/audio/audio_request_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only the latest audio response can be applied', () async {
    final first = Completer<String>();
    final second = Completer<String>();
    final applied = <String>[];
    final coordinator = LatestAudioRequestCoordinator();

    Future<bool> request(Completer<String> response) {
      return coordinator.run((isCurrent) async {
        final value = await response.future;
        if (!isCurrent()) return false;
        applied.add(value);
        return true;
      });
    }

    final firstRequest = request(first);
    final secondRequest = request(second);
    second.complete('second');
    expect(await secondRequest, isTrue);
    first.complete('first');
    expect(await firstRequest, isFalse);
    expect(applied, ['second']);
  });

  test(
    'a request invalidated during player creation cannot open media',
    () async {
      final playerReady = Completer<void>();
      final opened = <String>[];
      final coordinator = LatestAudioRequestCoordinator();

      final firstRequest = coordinator.run((isCurrent) async {
        await playerReady.future;
        if (!isCurrent()) return false;
        opened.add('first');
        return true;
      });
      final secondRequest = coordinator.run((isCurrent) async {
        if (!isCurrent()) return false;
        opened.add('second');
        return true;
      });

      expect(await secondRequest, isTrue);
      playerReady.complete();
      expect(await firstRequest, isFalse);
      expect(opened, ['second']);
    },
  );

  test('concurrent player initialization callers share the result', () async {
    final created = Completer<Object>();
    final initializer = SharedAsyncInitializer<Object>();
    var createCount = 0;

    Future<Object> create() {
      createCount++;
      return created.future;
    }

    final first = initializer.getOrCreate(create);
    final second = initializer.getOrCreate(create);
    final player = Object();
    created.complete(player);

    expect(await first, same(player));
    expect(await second, same(player));
    expect(createCount, 1);
  });

  test('a successful response without a playable URL is rejected', () async {
    var openCount = 0;

    for (final url in <String?>[null, '', '   ']) {
      final opened = await openCurrentAudioUrl(
        url: url,
        isCurrent: () => true,
        open: (_) async {
          openCount++;
          return true;
        },
      );

      expect(opened, isFalse);
    }
    expect(openCount, 0);
  });

  test(
    'a player created after invalidation is disposed instead of leaked',
    () async {
      final created = Completer<Object>();
      final disposed = <Object>[];
      final initializer = SharedAsyncInitializer<Object>(
        disposeDiscarded: (value) async => disposed.add(value),
      );
      final initializing = initializer.getOrCreate(() => created.future);
      await initializer.clear();
      final player = Object();
      created.complete(player);

      expect(await initializing, isNull);
      expect(disposed, [player]);
    },
  );

  test('closing invalidates outstanding audio work', () async {
    final response = Completer<void>();
    final coordinator = LatestAudioRequestCoordinator();
    final request = coordinator.run((isCurrent) async {
      await response.future;
      return isCurrent();
    });

    coordinator.close();
    response.complete();

    expect(await request, isFalse);
  });

  test('overlapping opens are serialized and the newest media wins', () async {
    final firstStarted = Completer<void>();
    final firstOpen = Completer<void>();
    final coordinator = LatestAudioRequestCoordinator();
    final opener = SerializedAudioOpener();
    final started = <String>[];
    String? nativeMedia;
    var playing = false;

    Future<bool> request(String media) {
      return coordinator.run(
        (isCurrent) => opener.run(
          isCurrent: isCurrent,
          open: () async {
            started.add(media);
            if (media == 'first') {
              firstStarted.complete();
              await firstOpen.future;
            }
            nativeMedia = media;
            if (!isCurrent()) return false;
            playing = true;
            return true;
          },
          onStale: () async => playing = false,
        ),
      );
    }

    final first = request('first');
    await firstStarted.future;
    final second = request('second');
    expect(started, ['first']);
    firstOpen.complete();

    expect(await first, isFalse);
    expect(await second, isTrue);
    expect(started, ['first', 'second']);
    expect(nativeMedia, 'second');
    expect(playing, isTrue);
  });

  test(
    'a failed newest request cannot leave a stale open autoplaying',
    () async {
      final firstStarted = Completer<void>();
      final firstOpen = Completer<void>();
      final secondResponse = Completer<void>();
      final coordinator = LatestAudioRequestCoordinator();
      final opener = SerializedAudioOpener();
      var playing = false;

      final first = coordinator.run(
        (isCurrent) => opener.run(
          isCurrent: isCurrent,
          open: () async {
            firstStarted.complete();
            await firstOpen.future;
            if (!isCurrent()) return false;
            playing = true;
            return true;
          },
          onStale: () async => playing = false,
        ),
      );
      await firstStarted.future;
      final second = coordinator.run((_) async {
        await secondResponse.future;
        return false;
      });
      firstOpen.complete();
      secondResponse.complete();

      expect(await first, isFalse);
      expect(await second, isFalse);
      expect(playing, isFalse);
    },
  );

  test('a failed media open runs cleanup before the next open', () async {
    final coordinator = LatestAudioRequestCoordinator();
    final opener = SerializedAudioOpener();
    final firstStarted = Completer<void>();
    final failOpen = Completer<void>();
    final events = <String>[];

    final failed = coordinator.run(
      (isCurrent) => opener.run(
        isCurrent: isCurrent,
        open: () async {
          events.add('open:first');
          firstStarted.complete();
          await failOpen.future;
          throw StateError('open failed');
        },
        onStale: () async => events.add('cleanup:first'),
      ),
    );
    final failedExpectation = expectLater(failed, throwsStateError);
    await firstStarted.future;
    final succeeded = coordinator.run(
      (isCurrent) => opener.run(
        isCurrent: isCurrent,
        open: () async {
          events.add('open:second');
          return true;
        },
        onStale: () async => events.add('cleanup:second'),
      ),
    );
    failOpen.complete();

    await failedExpectation;
    expect(await succeeded, isTrue);
    expect(events, ['open:first', 'cleanup:first', 'open:second']);
  });
}
