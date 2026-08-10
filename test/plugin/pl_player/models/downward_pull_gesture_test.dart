import 'package:PiliPlus/plugin/pl_player/models/downward_pull_gesture.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pagePullProgressForDistance', () {
    test('keeps visual travel proportional to the pointer distance', () {
      expect(
        pagePullProgressForDistance(72, travelDistance: 1800),
        closeTo(0.04, 0.0001),
      );
      expect(
        pagePullProgressForDistance(900, travelDistance: 1800),
        0.5,
      );
    });

    test('clamps progress and handles a collapsed travel range', () {
      expect(pagePullProgressForDistance(-10, travelDistance: 100), 0);
      expect(pagePullProgressForDistance(120, travelDistance: 100), 1);
      expect(pagePullProgressForDistance(1, travelDistance: 0), 1);
      expect(pagePullProgressForDistance(0, travelDistance: 0), 0);
    });
  });

  group('isDownwardPull', () {
    test('accepts video and detail pulls at their thresholds', () {
      expect(
        isDownwardPull(
          const Offset(10, kVideoMiniPlayerPullThreshold),
          threshold: kVideoMiniPlayerPullThreshold,
          verticalBias: kPagePullVerticalBias,
        ),
        isTrue,
      );
      expect(
        isDownwardPull(
          const Offset(10, kDetailFullscreenPullThreshold),
          threshold: kDetailFullscreenPullThreshold,
          verticalBias: kPagePullVerticalBias,
        ),
        isTrue,
      );
    });

    test('rejects short, upward, and predominantly horizontal gestures', () {
      for (final delta in const [
        Offset(0, kDetailFullscreenPullThreshold - 1),
        Offset(0, -kDetailFullscreenPullThreshold),
        Offset(50, kDetailFullscreenPullThreshold),
      ]) {
        expect(
          isDownwardPull(
            delta,
            threshold: kDetailFullscreenPullThreshold,
            verticalBias: kPagePullVerticalBias,
          ),
          isFalse,
        );
      }
    });
  });

  group('isUpwardPull', () {
    test('accepts an upward portrait-full-screen exit at its threshold', () {
      expect(
        isUpwardPull(
          const Offset(10, -kPortraitFullscreenExitPullThreshold),
          threshold: kPortraitFullscreenExitPullThreshold,
          verticalBias: kPagePullVerticalBias,
        ),
        isTrue,
      );
    });

    test('rejects short, downward, and predominantly horizontal gestures', () {
      for (final delta in const [
        Offset(0, -(kPortraitFullscreenExitPullThreshold - 1)),
        Offset(0, kPortraitFullscreenExitPullThreshold),
        Offset(50, -kPortraitFullscreenExitPullThreshold),
      ]) {
        expect(
          isUpwardPull(
            delta,
            threshold: kPortraitFullscreenExitPullThreshold,
            verticalBias: kPagePullVerticalBias,
          ),
          isFalse,
        );
      }
    });
  });

  group('shouldAccumulateDetailOverscroll', () {
    test('accepts only user-driven downward overscroll at the detail top', () {
      expect(
        shouldAccumulateDetailOverscroll(
          isAtTop: true,
          isCommentTab: false,
          isUserDrag: true,
          overscroll: -12,
        ),
        isTrue,
      );
    });

    test('rejects pulls before top and every pull in the comment tab', () {
      for (final state in const [
        (isAtTop: false, isCommentTab: false),
        (isAtTop: true, isCommentTab: true),
      ]) {
        expect(
          shouldAccumulateDetailOverscroll(
            isAtTop: state.isAtTop,
            isCommentTab: state.isCommentTab,
            isUserDrag: true,
            overscroll: -12,
          ),
          isFalse,
        );
      }
    });

    test('rejects ballistic and non-downward overscroll', () {
      expect(
        shouldAccumulateDetailOverscroll(
          isAtTop: true,
          isCommentTab: false,
          isUserDrag: false,
          overscroll: -12,
        ),
        isFalse,
      );
      expect(
        shouldAccumulateDetailOverscroll(
          isAtTop: true,
          isCommentTab: false,
          isUserDrag: true,
          overscroll: 12,
        ),
        isFalse,
      );
    });
  });
}
