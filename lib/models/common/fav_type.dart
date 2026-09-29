import 'package:PiliPlus/l10n/l10n.dart';
import 'package:PiliPlus/pages/fav/article/view.dart';
import 'package:PiliPlus/pages/fav/cheese/view.dart';
import 'package:PiliPlus/pages/fav/note/view.dart';
import 'package:PiliPlus/pages/fav/pgc/view.dart';
import 'package:PiliPlus/pages/fav/topic/view.dart';
import 'package:PiliPlus/pages/fav/video/view.dart';
import 'package:material_ui/material_ui.dart';

enum FavTabType {
  video(FavVideoPage()),
  bangumi(FavPgcPage(type: 1)),
  cinema(FavPgcPage(type: 2)),
  article(FavArticlePage()),
  note(FavNotePage()),
  topic(FavTopicPage()),
  cheese(FavCheesePage()),
  ;

  String get title => switch (this) {
    video => L10n.current.video,
    bangumi => L10n.current.favTabTypeBangumiTitle,
    cinema => L10n.current.favTabTypeCinemaTitle,
    article => L10n.current.article,
    note => L10n.current.favTabTypeNoteTitle,
    topic => L10n.current.favTabTypeTopicTitle,
    cheese => L10n.current.favTabTypeCheeseTitle,
  };
  final Widget page;
  const FavTabType(this.page);
}
