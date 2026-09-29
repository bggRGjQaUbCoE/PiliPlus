import 'package:PiliPlus/l10n/l10n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

enum ReplyOptionType {
  allow,
  close,
  choose,
  ;

  String get title => switch (this) {
    allow => L10n.current.replyOptionTypeAllowTitle,
    close => L10n.current.replyOptionTypeCloseTitle,
    choose => L10n.current.replySortTypeSelectDesc,
  };

  IconData get iconData => switch (this) {
    ReplyOptionType.allow => MdiIcons.commentTextOutline,
    ReplyOptionType.close => MdiIcons.commentOffOutline,
    ReplyOptionType.choose => MdiIcons.commentProcessingOutline,
  };
}
