import 'package:PiliPlus/pages/later/child_view.dart';
import 'package:flutter/material.dart';

enum LaterViewType {
  all('全部'),
  toView('未看'),
  unfinished('未看完'),
  viewed('已看完');

  int get type => index;
  Widget get page => LaterViewChildPage(laterViewType: this);

  final String title;
  const LaterViewType(this.title);
}
