import 'package:PiliPlus/models/common/enum_with_label.dart';

enum SkipType implements EnumWithLabel {
  alwaysSkip('总是跳过'),
  skipOnce('跳过一次'),
  skipManually('手动跳过'),
  showOnly('仅显示'),
  disable('禁用')
  ;

  @override
  final String label;
  const SkipType(this.label);
}
