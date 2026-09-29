import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/later/child_view.dart';
import 'package:material_ui/material_ui.dart';

enum LaterViewType {
  all(0),
  // toView(1, '未看'),
  unfinished(2),
  // viewed(3, '已看完'),
  ;

  Widget get page => LaterViewChildPage(laterViewType: this);

  final int type;
  String get title => switch (this) {
    all => L10n.current.all,
    unfinished => L10n.current.notFinished,
  };
  const LaterViewType(this.type);
}
