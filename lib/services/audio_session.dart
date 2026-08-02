import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:audio_session/audio_session.dart';

class AudioSessionPlayerCallbacks {
  const AudioSessionPlayerCallbacks({
    required this.isPlaying,
    required this.play,
    required this.pause,
    required this.setGain,
  });

  final bool Function() isPlaying;
  final Future<void> Function() play;
  final Future<void> Function({bool isInterrupt}) pause;
  final Future<void> Function(double gain) setGain;
}

class AudioSessionHandler {
  late AudioSession session;
  late final Future<void> _initialization;
  bool _playInterrupted = false;
  bool _isDucked = false;
  final List<AudioSessionPlayerCallbacks> _standalonePlayers = [];
  AudioSessionPlayerCallbacks? _interruptedStandalonePlayer;
  AudioSessionPlayerCallbacks? _duckedStandalonePlayer;
  bool _duckedVideoPlayer = false;

  AudioSessionPlayerCallbacks? get _standalonePlayer =>
      _standalonePlayers.isEmpty ? null : _standalonePlayers.last;

  bool isCurrentStandalonePlayer(AudioSessionPlayerCallbacks player) =>
      identical(_standalonePlayer, player);

  void registerStandalonePlayer(AudioSessionPlayerCallbacks player) {
    _standalonePlayers
      ..remove(player)
      ..add(player);
  }

  void unregisterStandalonePlayer(AudioSessionPlayerCallbacks player) {
    if (!_standalonePlayers.remove(player)) return;
    if (identical(_interruptedStandalonePlayer, player)) {
      _interruptedStandalonePlayer = null;
      _playInterrupted = false;
    }
    if (identical(_duckedStandalonePlayer, player)) {
      _duckedStandalonePlayer = null;
      _isDucked = false;
    }
  }

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
      final standalonePlayer = _standalonePlayer;
      final standaloneIsPlaying = standalonePlayer?.isPlaying() ?? false;
      final playerStatus = PlPlayerController.getPlayerStatusIfExists();
      if (event.begin) {
        if (!standaloneIsPlaying && playerStatus != PlayerStatus.playing) {
          return;
        }
        switch (event.type) {
          case AudioInterruptionType.duck:
            _isDucked = true;
            if (standaloneIsPlaying) {
              _duckedStandalonePlayer = standalonePlayer;
              standalonePlayer!.setGain(0.5);
            } else {
              _duckedVideoPlayer = true;
              PlPlayerController.setAudioFocusGainIfExists(0.5);
            }
            break;
          case AudioInterruptionType.pause:
            if (standaloneIsPlaying) {
              _interruptedStandalonePlayer = standalonePlayer;
              standalonePlayer!.pause(isInterrupt: true);
            } else {
              PlPlayerController.pauseIfExists(isInterrupt: true);
            }
            _playInterrupted = true;
            break;
          case AudioInterruptionType.unknown:
            if (standaloneIsPlaying) {
              _interruptedStandalonePlayer = standalonePlayer;
              standalonePlayer!.pause(isInterrupt: true);
            } else {
              PlPlayerController.pauseIfExists(isInterrupt: true);
            }
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
            final interruptedStandalonePlayer = _interruptedStandalonePlayer;
            _interruptedStandalonePlayer = null;
            if (shouldResume) {
              if (interruptedStandalonePlayer != null &&
                  identical(
                    interruptedStandalonePlayer,
                    _standalonePlayer,
                  )) {
                interruptedStandalonePlayer.play();
              } else {
                PlPlayerController.playIfExists();
              }
            }
            break;
          case AudioInterruptionType.unknown:
            _playInterrupted = false;
            _interruptedStandalonePlayer = null;
            break;
        }
      }
    });

    // 耳机拔出暂停
    session.becomingNoisyEventStream.listen((_) {
      final standalonePlayer = _standalonePlayer;
      if (standalonePlayer?.isPlaying() ?? false) {
        standalonePlayer!.pause();
      } else {
        PlPlayerController.pauseIfExists();
      }
    });
  }

  Future<void> _restorePlayerGain() async {
    if (!_isDucked) return;
    _isDucked = false;
    final duckedStandalonePlayer = _duckedStandalonePlayer;
    _duckedStandalonePlayer = null;
    if (duckedStandalonePlayer != null &&
        identical(duckedStandalonePlayer, _standalonePlayer)) {
      await duckedStandalonePlayer.setGain(1);
    }
    if (_duckedVideoPlayer) {
      _duckedVideoPlayer = false;
      await PlPlayerController.setAudioFocusGainIfExists(1);
    }
  }
}
