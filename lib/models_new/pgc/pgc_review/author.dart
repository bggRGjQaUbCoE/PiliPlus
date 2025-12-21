import 'package:PiliPlus/models/model_avatar.dart' show Vip;

class Author {
  String? avatar;
  int? level;
  int? mid;
  String? uname;
  Vip? vip;

  Author({this.avatar, this.level, this.mid, this.uname, this.vip});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    avatar: json['avatar'] as String?,
    level: json['level'] as int?,
    mid: json['mid'] as int?,
    uname: json['uname'] as String?,
    vip: json['vip'] == null
        ? null
        : Vip.fromJson(json['vip'] as Map<String, dynamic>),
  );
}
