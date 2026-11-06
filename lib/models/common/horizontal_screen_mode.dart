import 'package:PiliPlus/models/common/enum_with_label.dart';

enum HorizontalScreenMode with EnumWithLabel {
  auto('自动（折叠屏展开时开启）'),
  on('开启'),
  off('关闭'),
  ;

  @override
  final String label;
  const HorizontalScreenMode(this.label);
}
