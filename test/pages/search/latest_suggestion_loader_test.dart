import 'dart:async';

import 'package:PiliPlus/pages/search/latest_suggestion_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an older response cannot replace the latest suggestions', () async {
    final first = Completer<String>();
    final second = Completer<String>();
    final loader = LatestSuggestionLoader<String>();
    final applied = <String>[];

    loader.updateQuery('old');
    final firstLoad = loader.load('old', () => first.future).then((value) {
      if (value != null) {
        applied.add(value);
      }
    });
    loader.updateQuery('new');
    final secondLoad = loader.load('new', () => second.future).then((value) {
      if (value != null) {
        applied.add(value);
      }
    });

    second.complete('new query');
    await secondLoad;
    first.complete('old query');
    await firstLoad;

    expect(applied, ['new query']);
  });

  test('clearing the field invalidates an in-flight response', () async {
    final response = Completer<String>();
    final loader = LatestSuggestionLoader<String>()..updateQuery('query');
    final load = loader.load('query', () => response.future);
    loader.updateQuery('');
    response.complete('stale query');

    expect(await load, isNull);
  });

  test(
    'a debounced request is not started after the field is cleared',
    () async {
      final loader = LatestSuggestionLoader<String>()
        ..updateQuery('query')
        ..updateQuery('');
      var requested = false;

      final result = await loader.load('query', () async {
        requested = true;
        return 'stale query';
      });

      expect(requested, isFalse);
      expect(result, isNull);
    },
  );
}
