import 'package:PiliPlus/models/common/enum_with_label.dart';

enum MineTabType implements EnumWithLabel {
  favorite('我的收藏'),
  history('观看记录'),
  later('稍后再看'),
  sub('我的订阅');

  static const Set<MineTabType> kDefault = {.favorite};

  @override
  final String label;

  const MineTabType(this.label);
}
