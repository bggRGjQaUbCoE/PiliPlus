import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:audio_session/audio_session.dart';

class AudioSessionHandler {
  late AudioSession _session;
  bool _shouldResume = false;

  Future<bool> setActive(bool active) {
    return _session.setActive(active);
  }

  AudioSessionHandler() {
    initSession();
  }

  Future<void> initSession() async {
    _session = await AudioSession.instance;
    _session.configure(const AudioSessionConfiguration.music());

    _session.interruptionEventStream.listen(_onInterrupted);

    // 耳机拔出暂停
    _session.becomingNoisyEventStream.listen((_) {
      videoPlayerServiceHandler?.onPause?.call() ??
          PlPlayerController.pauseIfExists();
    });
  }

  void _onInterrupted(AudioInterruptionEvent event) {
    if (event.begin) {
      final player = PlPlayerController.instance;
      switch (event.type) {
        case .duck:
          if (player != null && player.playerStatus.isPlaying) {
            player.setVolume(player.volume.value * 0.5, showIndicator: false);
          }
        case .pause:
        case .unknown:
          final isAudioPlaying = videoPlayerServiceHandler?.isPlaying;
          if (isAudioPlaying != null) {
            if (isAudioPlaying()) {
              _shouldResume = true;
              videoPlayerServiceHandler?.onPause?.call();
            }
          } else if (player != null && player.playerStatus.isPlaying) {
            _shouldResume = true;
            player.pause(isInterrupt: true);
          }
      }
    } else {
      switch (event.type) {
        case .duck:
          final player = PlPlayerController.instance;
          player?.setVolume(player.volume.value * 2, showIndicator: false);
        case .pause:
          if (_shouldResume) {
            _shouldResume = false;
            videoPlayerServiceHandler?.onPlay?.call() ??
                PlPlayerController.instance?.play();
          }
        case .unknown:
      }
    }
  }
}
