import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 动态页横向滑动的作用对象
enum DynSwipeTarget implements EnumWithLabel {
  /// 左右滑动切换顶部分类（全部 / 投稿 / 番剧 / 专栏 / UP）
  tab('切换分类'),

  /// 在 UP 分类下，左右滑动逐个浏览关注的 UP 主
  up('逐个浏览UP'),

  ;
  @override
  final String label;
  const DynSwipeTarget(this.label);
}
