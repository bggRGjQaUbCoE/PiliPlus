// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

class CustomIcons {
  static const IconData coin = _CustomIconData(0xe800);
  static const IconData dm_off = _CustomIconData(0xe801);
  static const IconData dm_on = _CustomIconData(0xe802);
  static const IconData dm_settings = _CustomIconData(0xe803);
  static const IconData dyn = _CustomIconData(0xe804);
  static const IconData fav = _CustomIconData(0xe805);
  static const IconData live_reserve = _CustomIconData(0xe806);
  static const IconData share = _CustomIconData(0xe807);
  static const IconData share_line = _CustomIconData(0xe808);
  static const IconData share_node = _CustomIconData(0xe809);
  static const IconData star_favorite_line = _CustomIconData(0xe80a);
  static const IconData star_favorite_solid = _CustomIconData(0xe80b);
  static const IconData thumbs_down = _CustomIconData(0xe80c);
  static const IconData thumbs_down_outline = _CustomIconData(0xe80d);
  static const IconData thumbs_up = _CustomIconData(0xe80e);
  static const IconData thumbs_up_fill = _CustomIconData(0xe80f);
  static const IconData thumbs_up_line = _CustomIconData(0xe810);
  static const IconData thumbs_up_outline = _CustomIconData(0xe811);
  static const IconData topic_tag = _CustomIconData(0xe812);
  static const IconData watch_later = _CustomIconData(0xe813);
}

class _CustomIconData extends IconData {
  const _CustomIconData(super.codePoint) : super(fontFamily: 'custom_icon');
}
