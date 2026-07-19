import 'package:PiliPlus/models/common/home_tab_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolveHomeTabs', () {
    test('falls back to defaults for missing, malformed, or empty values', () {
      expect(resolveHomeTabs(null), HomeTabType.values);
      expect(resolveHomeTabs('invalid'), HomeTabType.values);
      expect(resolveHomeTabs(const []), HomeTabType.values);
    });

    test('preserves valid order while filtering invalid indices', () {
      expect(
        resolveHomeTabs([
          HomeTabType.hot.index,
          -1,
          999,
          HomeTabType.live.index,
        ]),
        [HomeTabType.hot, HomeTabType.live],
      );
    });

    test('falls back when filtering leaves no valid tabs', () {
      expect(resolveHomeTabs([-1, 'invalid', 999]), HomeTabType.values);
    });
  });
}
