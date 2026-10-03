import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';

bool canEnterInAppMiniPlayer({
  required PlayerStatus status,
  required bool sourceLoaded,
  required bool hasStartedPlayback,
  required bool sourceCompleted,
}) =>
    sourceLoaded &&
    !sourceCompleted &&
    (status.isPlaying || (status.isPaused && hasStartedPlayback));
