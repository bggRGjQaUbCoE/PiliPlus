import 'package:PiliPlus/utils/blacklist_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('shouldUseLocalBlacklistFallback', () {
    test('only enables fallback at the configured online limit', () {
      expect(
        shouldUseLocalBlacklistFallback(onlineBlacklistMaxCount - 1),
        isFalse,
      );
      expect(shouldUseLocalBlacklistFallback(onlineBlacklistMaxCount), isTrue);
      expect(
        shouldUseLocalBlacklistFallback(onlineBlacklistMaxCount + 1),
        isTrue,
      );
    });

    test('does not enable fallback when online count is unknown', () {
      expect(shouldUseLocalBlacklistFallback(null), isFalse);
    });
  });
}
