import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ListOrder implements EnumWithLabel {
  asc('正序播放'),
  desc('倒序播放'),
  shuffle('随机播放'),
  ;

  @override
  final String label;
  const ListOrder(this.label);

  ListOrder get next => values[(index + 1) % values.length];

  bool get isShuffle => this == shuffle;
  bool get isDesc => this == desc;
}
