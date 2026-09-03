import 'package:PiliPlus/pages/later/child_view.dart';
import 'package:material_ui/material_ui.dart';

enum LaterViewType {
  all(0, '全部'),
  // toView(1, '未看'),
  unfinished(2, '未看完'),
  // viewed(3, '已看完'),
  ;

  Widget get page => LaterViewChildPage(laterViewType: this);

  final int type;
  final String title;
  const LaterViewType(this.type, this.title);
}
