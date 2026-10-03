import 'package:PiliPlus/models/common/enum_with_label.dart';

/// 控制列表范围和提醒类型；全部关注使用本地跟踪，避免暗示官方全量已读同步。
enum DynamicUpListMode implements EnumWithLabel {
  frequent('常看（官方红点）'),
  all('全部关注（所有动态，本地跟踪）'),
  video('全部关注（仅视频，本地跟踪）');

  /// 只有扩展模式才需要拉取完整关注列表并维护本地更新基线。
  bool get showAllFollowed => this != frequent;

  @override
  final String label;
  const DynamicUpListMode(this.label);
}

extension DynamicUpListModeBadge on DynamicUpListMode {
  /// 该模式是否展示某个红点。
  ///
  /// 「仅视频」展示仍有未读视频的红点；由官方列表带入的红点没有动态
  /// 类型信息（[isVideo] 为 null），因此不会被该模式展示，避免把只发图文的 UP 标红。
  bool showsBadge(bool? isVideo) =>
      this != DynamicUpListMode.video || isVideo == true;
}
