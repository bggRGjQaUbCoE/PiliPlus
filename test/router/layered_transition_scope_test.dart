import 'package:PiliPlus/router/layered_page_transition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'layers ordinary routes and leaves shell and fullscreen routes alone',
    () {
      expect(LayeredPageTransitions.supports('/favDetail?id=1'), isTrue);
      expect(LayeredPageTransitions.supports('/setting/styleSetting'), isTrue);
      for (final route in ['/', '/home', '/hot', '/FullScreenSc']) {
        expect(LayeredPageTransitions.supports(route), isFalse, reason: route);
      }
    },
  );

  test('uses a fixed route transition duration', () {
    const transitions = LayeredPageTransitionsBuilder();
    expect(transitions.transitionDuration, const Duration(milliseconds: 320));
  });
}
