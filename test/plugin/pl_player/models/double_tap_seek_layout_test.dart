import 'package:PiliPlus/plugin/pl_player/models/double_tap_seek_layout.dart';
import 'package:PiliPlus/plugin/pl_player/models/double_tap_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoubleTapSeekLayout', () {
    test('normalizes side regions and keeps center at least 20 percent', () {
      final layout = DoubleTapSeekLayout.normalize(
        backwardPercent: 70,
        forwardPercent: 40,
      );

      expect(layout.backwardPercent, 40);
      expect(layout.forwardPercent, 40);
      expect(layout.centerPercent, 20);
    });

    test('resolves left center right zones from tap position', () {
      const layout = DoubleTapSeekLayout(
        backwardPercent: 25,
        forwardPercent: 25,
      );

      expect(
        layout.resolveType(tapPosition: 10, width: 100),
        DoubleTapType.left,
      );
      expect(
        layout.resolveType(tapPosition: 50, width: 100),
        DoubleTapType.center,
      );
      expect(
        layout.resolveType(tapPosition: 90, width: 100),
        DoubleTapType.right,
      );
    });
  });
}
