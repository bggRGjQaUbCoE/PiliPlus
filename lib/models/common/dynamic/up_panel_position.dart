import 'package:PiliPlus/models/common/enum_with_label.dart';

enum UpPanelPosition implements EnumWithLabel {
  top('顶部'),
  leftFixed('左侧常驻'),
  rightFixed('右侧常驻'),
  leftDrawer('左侧抽屉'),
  rightDrawer('右侧抽屉'),
  ;

  @override
  final String label;
  const UpPanelPosition(this.label);
}
