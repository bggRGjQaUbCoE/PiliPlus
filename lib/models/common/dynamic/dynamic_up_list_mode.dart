import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 控制动态页 UP 主列表范围，以及全部关注模式下红点所代表的动态类型。
enum DynamicUpListMode implements EnumWithLabel {
  frequent('常看（官方红点）'),
  all('全部关注（所有动态）'),
  video('全部关注（仅视频，含动态小视频）');

  /// 只有扩展模式才需要拉取完整关注列表并维护本地更新基线。
  bool get showAllFollowed => this != frequent;

  @override
  final String label;
  const DynamicUpListMode(this.label);
}
