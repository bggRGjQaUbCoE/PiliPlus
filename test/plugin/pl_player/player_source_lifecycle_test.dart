import 'dart:async';

import 'package:PiliPlus/plugin/pl_player/utils/player_source_lifecycle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerSourceLifecycle', () {
    test(
      'new source requests supersede older requests and close invalidates',
      () {
        final lifecycle = PlayerSourceLifecycle();
        final first = lifecycle.beginRequest();
        final second = lifecycle.beginRequest();

        expect(lifecycle.isCurrent(first), isFalse);
        expect(lifecycle.isCurrent(second), isTrue);

        lifecycle.close();
        expect(lifecycle.isCurrent(second), isFalse);
      },
    );

    test('callback request token ends before its future completes', () async {
      final lifecycle = PlayerSourceLifecycle();
      final scope = SourceCallbackRequestScope();
      final pending = Completer<void>();
      final requestA = lifecycle.beginRequest();
      int? autoplayRequest;

      final autoplay = scope.dispatch(requestA, () {
        // PlPlayerController.play captures this synchronously on callback entry.
        autoplayRequest = scope.capture();
        return pending.future;
      });
      expect(autoplayRequest, requestA);
      expect(scope.capture(), isNull);

      lifecycle.beginRequest();
      // A manual play during A's pending future has no inherited token.
      final manualRequest = scope.capture();
      expect(manualRequest, isNull);
      pending.complete();
      await autoplay;
    });
  });
}
