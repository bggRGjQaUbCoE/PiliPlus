import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ReplySortType implements EnumWithLabel {
  time('最新评论', '最新', label: '按时间'),
  hot('最热评论', '最热', label: '按热度'),
  select('精选评论', '精选'),
  ;

  @override
  final String label;
  final String desc;
  final String descShort;
  const ReplySortType(this.desc, this.descShort, {this.label = ''});
}
