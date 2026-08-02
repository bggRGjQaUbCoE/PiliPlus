import 'package:PiliPlus/pages/audio/exo_audio_event_tracker.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emits Media3 completion once until playback leaves ended state', () {
    final tracker = ExoAudioEventTracker();

    expect(tracker.accept(_event(completed: true)).completedNow, isTrue);
    expect(tracker.accept(_event(completed: true)).completedNow, isFalse);
    expect(tracker.accept(_event(playing: true)).statusChanged, isTrue);
    expect(tracker.accept(_event(completed: true)).completedNow, isTrue);
  });

  test('ignores stale Media3 events after disposal', () {
    final tracker = ExoAudioEventTracker()..dispose();

    final transition = tracker.accept(_event(playing: true));

    expect(transition.ignored, isTrue);
    expect(transition.statusChanged, isFalse);
    expect(transition.completedNow, isFalse);
  });
}

ExoPlayerEvent _event({bool playing = false, bool completed = false}) {
  return ExoPlayerEvent.fromMap({
    'generation': 1,
    'playing': playing,
    'buffering': false,
    'completed': completed,
  });
}
