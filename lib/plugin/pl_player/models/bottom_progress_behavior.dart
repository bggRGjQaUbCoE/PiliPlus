import 'package:PiliPlus/models/common/enum_with_label.dart';

enum BtmProgressBehavior implements EnumWithLabel {
  alwaysShow('始终展示'),
  alwaysHide('始终隐藏'),
  onlyShowFullScreen('仅全屏时展示'),
  onlyHideFullScreen('仅全屏时隐藏'),
  ;

  @override
  final String label;
  const BtmProgressBehavior(this.label);
}
