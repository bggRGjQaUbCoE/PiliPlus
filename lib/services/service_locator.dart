import 'dart:io' show Platform;

import 'package:PiliPlus/services/audio_handler.dart';
import 'package:PiliPlus/services/audio_session.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_service_mpris/audio_service_mpris.dart';

VideoPlayerServiceHandler? videoPlayerServiceHandler;
AudioSessionHandler? audioSessionHandler;

Future<void> setupServiceLocator() async {
  final audio = await initAudioService();
  videoPlayerServiceHandler = audio;
  if (!Platform.isLinux) {
    audioSessionHandler = AudioSessionHandler();
  }
}

/// 热切换后台音频服务开关
void setEnableBackgroundPlay(bool value) {
  final handler = videoPlayerServiceHandler;
  if (handler == null) return;
  handler.enableBackgroundPlay = value;
  if (!value && Platform.isLinux) {
    handler.playbackState.add(
      handler.playbackState.value.copyWith(
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }
}

void syncMprisRateRange() {
  if (!Platform.isLinux) return;
  final speeds = Pref.speedList;
  if (speeds.isEmpty) return;
  Mpris()
    ..minimumRate = speeds.first
    ..maximumRate = speeds.last;
}
