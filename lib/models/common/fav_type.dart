import 'package:PiliPlus/pages/fav/article/view.dart';
import 'package:PiliPlus/pages/fav/note/view.dart';
import 'package:PiliPlus/pages/fav/pgc/view.dart';
import 'package:PiliPlus/pages/fav/video/view.dart';
import 'package:flutter/material.dart';

enum FavTabType {
  video('视频', FavVideoPage()),
  bangumi('追番', FavPgcPage(type: 1)),
  cinema('追剧', FavPgcPage(type: 2)),
  article('专栏', FavArticlePage()),
  note('笔记', FavNotePage());

  final String title;
  final Widget page;
  const FavTabType(this.title, this.page);
}
