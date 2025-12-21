enum SubtitlePrefType {
  off('默认不显示字幕'),
  on('优先选择非自动生成(ai)字幕'),
  withoutAi('跳过自动生成(ai)字幕，选择第一个可用字幕'),
  auto('静音时等同第二项，非静音时等同第三项');

  final String desc;
  const SubtitlePrefType(this.desc);
}
