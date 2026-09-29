import 'package:PiliPlus/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart' show IconData, Icons;

enum StatType {
  view(Icons.remove_red_eye_outlined),
  danmaku(Icons.subtitles_outlined),
  like(Icons.thumb_up_outlined),
  reply(Icons.comment_outlined),
  follow(Icons.favorite_border),
  play(Icons.play_circle_outlined),
  listen(Icons.headset_outlined),
  ;

  final IconData iconData;
  String get label => switch (this) {
    view => L10n.current.statTypeViewLabel,
    danmaku => L10n.current.danmaku,
    like => L10n.current.like,
    reply => L10n.current.comments,
    follow => L10n.current.follow,
    play => L10n.current.playVideo,
    listen => L10n.current.playVideo,
  };
  const StatType(this.iconData);
}
