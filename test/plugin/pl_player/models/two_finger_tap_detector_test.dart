import 'package:PiliPlus/plugin/pl_player/models/two_finger_tap_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TwoFingerTapDetector', () {
    test('tracks active pointer count', () {
      final detector = TwoFingerTapDetector();
      final start = DateTime(2026, 4, 13, 22, 0, 0);

      detector.onPointerDown(
        pointer: 1,
        position: const Offset(10, 10),
        timestamp: start,
      );
      expect(detector.activePointerCount, 1);

      detector.onPointerDown(
        pointer: 2,
        position: const Offset(30, 10),
        timestamp: start.add(const Duration(milliseconds: 40)),
      );
      expect(detector.activePointerCount, 2);

      expect(
        detector.onPointerUp(
          pointer: 1,
          timestamp: start.add(const Duration(milliseconds: 120)),
        ),
        isFalse,
      );
      expect(detector.activePointerCount, 1);

      expect(
        detector.onPointerUp(
          pointer: 2,
          timestamp: start.add(const Duration(milliseconds: 130)),
        ),
        isTrue,
      );
      expect(detector.activePointerCount, 0);
    });

    test('recognizes a quick two-finger tap', () {
      final detector = TwoFingerTapDetector();
      final start = DateTime(2026, 4, 13, 22, 0, 0);
      bool release(int pointer, int milliseconds) => detector.onPointerUp(
        pointer: pointer,
        timestamp: start.add(Duration(milliseconds: milliseconds)),
      );

      detector
        ..onPointerDown(
          pointer: 1,
          position: const Offset(10, 10),
          timestamp: start,
        )
        ..onPointerDown(
          pointer: 2,
          position: const Offset(30, 10),
          timestamp: start.add(const Duration(milliseconds: 40)),
        );

      expect(release(1, 120), isFalse);
      expect(release(2, 130), isTrue);
    });

    test('rejects tap when one finger moves too far', () {
      final detector = TwoFingerTapDetector();
      final start = DateTime(2026, 4, 13, 22, 0, 0);
      bool release(int pointer, int milliseconds) => detector.onPointerUp(
        pointer: pointer,
        timestamp: start.add(Duration(milliseconds: milliseconds)),
      );

      detector
        ..onPointerDown(
          pointer: 1,
          position: const Offset(10, 10),
          timestamp: start,
        )
        ..onPointerDown(
          pointer: 2,
          position: const Offset(30, 10),
          timestamp: start.add(const Duration(milliseconds: 30)),
        )
        ..onPointerMove(pointer: 2, position: const Offset(60, 10));

      expect(release(1, 100), isFalse);
      expect(release(2, 120), isFalse);
    });

    test('rejects tap when second finger arrives too late', () {
      final detector = TwoFingerTapDetector();
      final start = DateTime(2026, 4, 13, 22, 0, 0);
      bool release(int pointer, int milliseconds) => detector.onPointerUp(
        pointer: pointer,
        timestamp: start.add(Duration(milliseconds: milliseconds)),
      );

      detector
        ..onPointerDown(
          pointer: 1,
          position: const Offset(10, 10),
          timestamp: start,
        )
        ..onPointerDown(
          pointer: 2,
          position: const Offset(30, 10),
          timestamp: start.add(const Duration(milliseconds: 200)),
        );

      expect(release(1, 220), isFalse);
      expect(release(2, 230), isFalse);
    });
  });
}
