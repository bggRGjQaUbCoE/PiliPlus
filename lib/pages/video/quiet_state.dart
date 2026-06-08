int quietControlsEffectiveTabIndex({
  required int currentIndex,
  required int previousLength,
  required int nextLength,
  required bool previousHadReply,
  required bool nextHasReply,
  required bool showIntro,
}) {
  if (nextLength <= 0) {
    return 0;
  }
  if (previousHadReply && !nextHasReply) {
    final replyIndex = showIntro ? 1 : 0;
    if (currentIndex == replyIndex) {
      return (replyIndex - 1).clamp(0, nextLength - 1);
    }
    if (currentIndex > replyIndex) {
      return (currentIndex - 1).clamp(0, nextLength - 1);
    }
  }
  if (!previousHadReply && nextHasReply) {
    final replyIndex = showIntro ? 1 : 0;
    if (currentIndex >= replyIndex && currentIndex < previousLength) {
      return (currentIndex + 1).clamp(0, nextLength - 1);
    }
  }
  return currentIndex.clamp(0, nextLength - 1);
}

bool effectiveShowTemporaryContent({
  required bool globalShow,
  required bool temporaryHide,
}) =>
    globalShow && !temporaryHide;

/// Three-level effective visibility: global gate, persistent channel rule,
/// and temporary (per-page) override.
///
/// Global off is a hard gate that cannot be overridden by persistent or
/// temporary controls.
bool effectiveShowContent({
  required bool globalShow,
  required bool persistentRuleHide,
  required bool temporaryHide,
}) =>
    globalShow && !persistentRuleHide && !temporaryHide;
