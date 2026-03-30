import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ArchiveOrderTypeWeb with EnumWithLabel {
  pubdate('最新发布'),
  click('最多播放'),
  stow('最多收藏'),
  ;

  @override
  final String label;
  const ArchiveOrderTypeWeb(this.label);
}
