import 'package:get/get.dart';

enum PlayerStatus { completed, playing, paused }

typedef PlPlayerStatus = Rx<PlayerStatus>;

extension PlPlayerStatusExt on PlPlayerStatus {
  bool get playing {
    return value == PlayerStatus.playing;
  }

  bool get paused {
    return value == PlayerStatus.paused;
  }

  bool get completed {
    return value == PlayerStatus.completed;
  }
}
