import 'dart:async';

import 'package:PiliPlus/pages/dlna/search_lifecycle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('failed start releases the search gate so retry can run', () async {
    var starts = 0;
    var stops = 0;
    final lifecycle = SearchLifecycle<Object>(
      startOperation: () async {
        starts++;
        if (starts == 1) throw StateError('bind failed');
        return Object();
      },
      stopOperation: () => stops++,
    );

    await expectLater(lifecycle.start(), throwsStateError);
    expect(lifecycle.isSearching, isFalse);
    expect(stops, 1);
    expect(await lifecycle.start(), isNotNull);
    expect(starts, 2);
  });

  test('late start after disposal is stopped after it completes', () async {
    final started = Completer<Object>();
    var stopCount = 0;
    final lifecycle = SearchLifecycle<Object>(
      startOperation: () => started.future,
      stopOperation: () => stopCount++,
    );

    final search = lifecycle.start();
    await lifecycle.dispose();
    expect(stopCount, 1);

    started.complete(Object());
    expect(await search, isNull);
    expect(stopCount, 2);
    expect(lifecycle.isSearching, isFalse);
  });
}
