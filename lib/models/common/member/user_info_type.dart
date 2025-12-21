import 'package:flutter/material.dart' show Alignment;

enum UserInfoType {
  fan('粉丝', .centerLeft),
  follow('关注', .center),
  like('获赞', .centerRight);

  final String title;
  final Alignment alignment;

  const UserInfoType(this.title, this.alignment);
}
