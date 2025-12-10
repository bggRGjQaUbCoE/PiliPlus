import 'package:flutter/material.dart' show Alignment;

enum UserInfoType {
  fan('粉丝', Alignment.centerLeft),
  follow('关注', Alignment.center),
  like('获赞', Alignment.centerRight),
  ;

  final String title;
  final Alignment alignment;

  const UserInfoType(this.title, this.alignment);
}
