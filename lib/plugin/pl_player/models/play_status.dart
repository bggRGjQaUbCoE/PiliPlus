enum PlayerStatus {
  completed,
  playing,
  paused,
  ;

  bool get isCompleted => this == PlayerStatus.completed;
  bool get isPlaying => this == PlayerStatus.playing;
  bool get isPaused => this == PlayerStatus.paused;
}
