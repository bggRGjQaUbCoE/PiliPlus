import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:audio_session/audio_session.dart';

class AudioSessionHandler {
  late AudioSession _session;
  bool _shouldResume = false;

  /// 闪避前记录音量，闪避结束后精确恢复
  ///
  /// 移动端音量以系统刻度为准（见 PlPlayerController.setVolume），
  /// 用「当前音量 x2」恢复会因刻度取整而回不到原值，所以直接记住原值。
  double? _volumeBeforeDuck;

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
            final volume = _volumeBeforeDuck ??= player.volume.value;
            player.setVolume(volume * 0.5, showIndicator: false);
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
          final volume = _volumeBeforeDuck;
          _volumeBeforeDuck = null;
          if (player != null && volume != null) {
            player.setVolume(volume, showIndicator: false);
          }
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
