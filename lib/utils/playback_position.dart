Duration chooseResumePosition({
  required Duration? playerPosition,
  required int lastReportedSeconds,
  required Duration? previousResumePosition,
}) {
  if (playerPosition != null) {
    if (playerPosition > Duration.zero) return playerPosition;
    if (lastReportedSeconds > 0) {
      return Duration(seconds: lastReportedSeconds);
    }
    return Duration.zero;
  }

  if (lastReportedSeconds > 0) {
    return Duration(seconds: lastReportedSeconds);
  }
  return previousResumePosition ?? Duration.zero;
}
