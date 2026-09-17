import 'dart:io' show Platform;

import 'package:PiliPlus/services/audio_handler.dart';
import 'package:PiliPlus/services/audio_session.dart';

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
  videoPlayerServiceHandler?.enableBackgroundPlay = value;
}
