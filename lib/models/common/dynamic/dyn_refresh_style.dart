import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 动态页下拉刷新的样式
enum DynRefreshStyle implements EnumWithLabel {
  /// Material 风格：指示器离顶部较远，跟随拖拽
  material('默认'),

  /// 官方风格：指示器贴在顶栏下方、阻尼更轻，松开即刷新并提示结果
  official('官方风格'),

  ;
  @override
  final String label;
  const DynRefreshStyle(this.label);
}
