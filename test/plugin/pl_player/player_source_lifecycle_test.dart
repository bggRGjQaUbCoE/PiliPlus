import 'dart:async';

import 'package:PiliPlus/pages/video/controller.dart'
    show allowsLegacyFallbackForVideoId;
import 'package:PiliPlus/plugin/pl_player/models/data_source.dart';
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
      expect(scope.capture(), isNull);
      pending.complete();
      await autoplay;
    });
  });
  group('legacy fallback policy', () {
    test('only known SDR video IDs authorize legacy fallback', () {
      for (final id in const [6, 16, 32, 64, 74, 80, 100, 112, 116, 120]) {
        expect(allowsLegacyFallbackForVideoId(id), isTrue, reason: '$id');
      }
      for (final id in const [125, 126, 127, 129, 999]) {
        expect(allowsLegacyFallbackForVideoId(id), isFalse, reason: '$id');
      }
      expect(allowsLegacyFallbackForVideoId(null), isFalse);
    });

    test('network sources default to no legacy fallback', () {
      final source = NetworkSource(
        videoSource: 'https://example/video',
        audioSource: null,
      );
      expect(source.allowLegacyFallback, isFalse);
    });
  });
}
