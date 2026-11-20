import 'package:PiliPlus/utils/desktop/window_origin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a window origin on a secondary display stays inside its work area', () {
    expect(
      isWindowOriginInWorkArea(
        dx: 2000,
        dy: 40,
        left: 1920,
        top: 0,
        width: 1920,
        height: 1080,
      ),
      isTrue,
    );
  });

  test('an origin beyond the work area is rejected', () {
    expect(
      isWindowOriginInWorkArea(
        dx: 3900,
        dy: 40,
        left: 1920,
        top: 0,
        width: 1920,
        height: 1080,
      ),
      isFalse,
    );
  });
}
