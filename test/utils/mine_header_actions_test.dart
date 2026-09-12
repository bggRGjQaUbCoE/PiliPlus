import 'package:PiliPlus/pages/mine/view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mine header global actions', () {
    test('are hidden when the sidebar already provides them', () {
      expect(
        shouldShowMineHeaderGlobalActions(
          hasHome: false,
          useBottomNav: false,
        ),
        isFalse,
      );
    });

    test('remain available when bottom navigation has no home page', () {
      expect(
        shouldShowMineHeaderGlobalActions(
          hasHome: false,
          useBottomNav: true,
        ),
        isTrue,
      );
    });

    test('are hidden when home already provides them', () {
      for (final useBottomNav in [false, true]) {
        expect(
          shouldShowMineHeaderGlobalActions(
            hasHome: true,
            useBottomNav: useBottomNav,
          ),
          isFalse,
        );
      }
    });
  });
}
