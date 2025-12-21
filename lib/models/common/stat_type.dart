import 'package:flutter/material.dart' show IconData, Icons;

enum StatType {
  view(Icons.remove_red_eye_outlined, '观看'),
  danmaku(Icons.subtitles_outlined, '弹幕'),
  like(Icons.thumb_up_outlined, '点赞'),
  reply(Icons.comment_outlined, '评论'),
  follow(Icons.favorite_border, '关注'),
  play(Icons.play_circle_outlined, '播放'),
  listen(Icons.headset_outlined, '播放');

  final IconData iconData;
  final String label;
  const StatType(this.iconData, this.label);
}
