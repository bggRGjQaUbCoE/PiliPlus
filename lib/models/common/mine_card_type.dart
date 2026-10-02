import 'package:PiliPlus/models/common/enum_with_label.dart';

enum MineCardType implements EnumWithLabel {
  history('观看记录'),
  fav('我的收藏'),
  toView('稍后再看'),
  ;

  @override
  final String label;
  const MineCardType(this.label);
}
