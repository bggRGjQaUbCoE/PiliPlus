import 'dart:ui' show Offset, clampDouble;

const double kVideoMiniPlayerPullThreshold = 48;
const double kDetailFullscreenPullThreshold = 72;
const double kPortraitFullscreenExitPullThreshold = 72;
const double kPagePullVerticalBias = 1.5;

double pagePullProgressForDistance(
  double distance, {
  required double travelDistance,
}) {
  if (travelDistance <= 0) return distance > 0 ? 1 : 0;
  return clampDouble(distance / travelDistance, 0, 1);
}

bool isDownwardPull(
  Offset delta, {
  required double threshold,
  required double verticalBias,
}) => delta.dy >= threshold && delta.dy > delta.dx.abs() * verticalBias;

bool isUpwardPull(
  Offset delta, {
  required double threshold,
  required double verticalBias,
}) => -delta.dy >= threshold && -delta.dy > delta.dx.abs() * verticalBias;

bool shouldAccumulateDetailOverscroll({
  required bool isAtTop,
  required bool isCommentTab,
  required bool isUserDrag,
  required double overscroll,
}) => isAtTop && !isCommentTab && isUserDrag && overscroll < 0;
