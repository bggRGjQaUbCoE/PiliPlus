/// Playback intent and seek requests, independent of transient player states
/// such as the pause emitted while a source is being replaced.
final class PlaybackRecoveryState {
  bool _userPaused = false;
  bool _wantsPlayback = false;
  bool _pendingForeground = false;
  int _intentRevision = 0;
  int _seekRevision = 0;
  Duration? _lastSeek;

  bool get userPaused => _userPaused;
  bool get wantsPlayback => _wantsPlayback && !_userPaused;
  bool get pendingForeground => _pendingForeground && wantsPlayback;
  int get intentRevision => _intentRevision;
  int get seekRevision => _seekRevision;

  bool canAutoplay({
    required bool requested,
    required bool recovering,
    required bool ownerCurrent,
  }) => requested && !_userPaused && !recovering && ownerCurrent;

  bool rememberBackground({
    required bool playerPlaying,
    required bool replacingSource,
  }) => playerPlaying || (replacingSource && wantsPlayback);

  bool resumeAfterBackground({
    required bool wasPlaying,
    required bool pausedByBackground,
    required bool completed,
  }) =>
      wantsPlayback &&
      (wasPlaying || pausedByBackground || pendingForeground) &&
      !completed;

  void resetForNewOwner() {
    _userPaused = false;
    _wantsPlayback = false;
    _pendingForeground = false;
    _intentRevision++;
    _seekRevision++;
    _lastSeek = null;
  }

  void requestPlay() {
    _userPaused = false;
    _wantsPlayback = true;
    _intentRevision++;
  }

  void requestAutoplay() {
    if (!_userPaused) _wantsPlayback = true;
  }

  void deferUntilForeground() {
    if (wantsPlayback) _pendingForeground = true;
  }

  void playbackStarted() => _pendingForeground = false;

  /// Invalidates an in-flight play request without changing playback intent.
  void invalidatePending() => _intentRevision++;

  void pause({required bool userInitiated}) {
    if (userInitiated) {
      _userPaused = true;
      _wantsPlayback = false;
      _pendingForeground = false;
      _intentRevision++;
    }
  }

  void complete() {
    _wantsPlayback = false;
    _pendingForeground = false;
    _intentRevision++;
  }

  void seek(Duration position) {
    _seekRevision++;
    _lastSeek = position;
  }

  Duration positionAfter(int previousRevision, Duration fallback) =>
      _seekRevision != previousRevision ? _lastSeek ?? fallback : fallback;
}
