import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';

class ExoAudioEventTransition {
  const ExoAudioEventTransition({
    required this.ignored,
    required this.statusChanged,
    required this.completedNow,
  });

  const ExoAudioEventTransition.ignored()
    : ignored = true,
      statusChanged = false,
      completedNow = false;

  final bool ignored;
  final bool statusChanged;
  final bool completedNow;
}

class ExoAudioEventTracker {
  bool? _lastPlaying;
  bool? _lastBuffering;
  bool _lastCompleted = false;
  bool _disposed = false;

  ExoAudioEventTransition accept(ExoPlayerEvent event) {
    if (_disposed) return const ExoAudioEventTransition.ignored();

    final completedNow = event.completed && !_lastCompleted;
    final statusChanged =
        !event.completed &&
        (_lastPlaying != event.playing ||
            _lastBuffering != event.buffering ||
            _lastCompleted);
    _lastPlaying = event.playing;
    _lastBuffering = event.buffering;
    _lastCompleted = event.completed;
    return ExoAudioEventTransition(
      ignored: false,
      statusChanged: statusChanged,
      completedNow: completedNow,
    );
  }

  void dispose() {
    _disposed = true;
  }
}
