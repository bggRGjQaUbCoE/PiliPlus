import 'package:PiliPlus/models/common/enum_with_label.dart';

enum ReplySortType implements EnumWithLabel {
  time('最新评论', '最新', label: '按时间'),
  hot('最热评论', '最热', label: '按热度'),
  select('精选评论', '精选'),
  // keep last: sort types are stored by index
  classic('经典评论', '经典', label: '经典'),
  ;

  /// Sort types offered for the top level comment list.
  static const List<ReplySortType> mainList = [time, hot, classic];

  /// Sort types offered for replies in a thread.
  static const List<ReplySortType> thread = [time, hot];

  @override
  final String label;
  final String desc;
  final String descShort;
  const ReplySortType(this.desc, this.descShort, {this.label = ''});
}
