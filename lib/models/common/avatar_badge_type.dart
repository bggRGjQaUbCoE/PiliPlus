import 'package:PiliPlus/utils/bili_colors.dart';
import 'package:flutter/material.dart';

enum BadgeType {
  none(),
  vip('大会员'),
  person('认证个人', BiliColors.yellow),
  institution('认证机构', Colors.lightBlueAccent),
  ;

  final String? desc;
  final Color? color;
  const BadgeType([this.desc, this.color]);
}
