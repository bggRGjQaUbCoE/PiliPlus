enum ActionType {
  skip('跳过'),
  mute('静音'),
  full('整个视频'),
  poi('精彩时刻');

  final String title;
  const ActionType(this.title);
}
