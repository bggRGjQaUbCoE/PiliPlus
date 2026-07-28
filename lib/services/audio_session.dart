import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:audio_session/audio_session.dart';

class AudioSessionHandler {
  late AudioSession session;
  late final Future<void> _initialization;
  bool _playInterrupted = false;
  bool _isDucked = false;

  Future<bool> setActive(bool active) async {
    await _initialization;
    if (!active) {
      _playInterrupted = false;
      await _restorePlayerGain();
    }
    return session.setActive(active);
  }

  AudioSessionHandler() {
    _initialization = initSession();
  }

  Future<void> initSession() async {
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    session.interruptionEventStream.listen((event) {
      final playerStatus = PlPlayerController.getPlayerStatusIfExists();
      if (event.begin) {
        if (playerStatus != PlayerStatus.playing) return;
        switch (event.type) {
          case AudioInterruptionType.duck:
            _isDucked = true;
            PlPlayerController.setAudioFocusGainIfExists(0.5);
            break;
          case AudioInterruptionType.pause:
            PlPlayerController.pauseIfExists(isInterrupt: true);
            _playInterrupted = true;
            break;
          case AudioInterruptionType.unknown:
            PlPlayerController.pauseIfExists(isInterrupt: true);
            _playInterrupted = true;
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _restorePlayerGain();
            break;
          case AudioInterruptionType.pause:
            final shouldResume = _playInterrupted;
            _playInterrupted = false;
            if (shouldResume) PlPlayerController.playIfExists();
            break;
          case AudioInterruptionType.unknown:
            _playInterrupted = false;
            break;
        }
      }
    });

    // 耳机拔出暂停
    session.becomingNoisyEventStream.listen((_) {
      PlPlayerController.pauseIfExists();
    });
  }

  Future<void> _restorePlayerGain() async {
    if (!_isDucked) return;
    _isDucked = false;
    await PlPlayerController.setAudioFocusGainIfExists(1);
  }
}
