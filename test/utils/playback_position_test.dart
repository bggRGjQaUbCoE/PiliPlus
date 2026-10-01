import 'package:PiliPlus/utils/playback_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the native player position when it is available', () {
    expect(
      chooseResumePosition(
        playerPosition: const Duration(seconds: 24),
        lastReportedSeconds: 23,
        previousResumePosition: const Duration(seconds: 75),
      ),
      const Duration(seconds: 24),
    );
  });

  test('uses the last reported position when native state is zero', () {
    expect(
      chooseResumePosition(
        playerPosition: Duration.zero,
        lastReportedSeconds: 73,
        previousResumePosition: const Duration(seconds: 71),
      ),
      const Duration(seconds: 73),
    );
  });

  test('uses the last reported position when native state is unavailable', () {
    expect(
      chooseResumePosition(
        playerPosition: null,
        lastReportedSeconds: 73,
        previousResumePosition: const Duration(seconds: 71),
      ),
      const Duration(seconds: 73),
    );
  });

  test('keeps a genuine zero instead of a stale previous position', () {
    expect(
      chooseResumePosition(
        playerPosition: Duration.zero,
        lastReportedSeconds: 0,
        previousResumePosition: const Duration(seconds: 71),
      ),
      Duration.zero,
    );
  });

  test('starts at zero while the player is still loading', () {
    expect(
      chooseResumePosition(
        playerPosition: null,
        lastReportedSeconds: 0,
        previousResumePosition: null,
      ),
      Duration.zero,
    );
  });
}
