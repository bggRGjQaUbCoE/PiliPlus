import 'package:PiliPlus/models/common/enum_with_label.dart';
import 'package:flutter/material.dart' show Icon, Icons;

enum LoginType with EnumWithLabel {
  psw('密码', Icon(Icons.password)),
  qrcode('二维码', Icon(Icons.qr_code)),
  cookie('Cookie', Icon(Icons.cookie_outlined));

  @override
  final String label;
  final Icon icon;

  const LoginType(this.label, this.icon);
}
