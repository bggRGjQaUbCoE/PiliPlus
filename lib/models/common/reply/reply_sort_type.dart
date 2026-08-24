import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ReplySortType implements EnumWithLabel {
  time('最新评论', '最新', text: '按时间'),
  hot('最热评论', '最热', text: '按热度'),
  select('精选评论', '精选'),
  ;

  @override
  final String label;
  final String label2;
  final String? text;
  const ReplySortType(this.label, this.label2, {this.text});
}
