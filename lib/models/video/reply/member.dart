import 'package:PiliPlus/models/model_avatar.dart';

class ReplyMember {
  ReplyMember({
    this.mid,
    this.uname,
    this.sign,
    this.avatar,
    this.level,
    this.pendant,
    this.officialVerify,
    this.vip,
    this.fansDetail,
  });

  String? mid;
  String? uname;
  String? sign;
  String? avatar;
  int? level;
  Pendant? pendant;
  Map? officialVerify;
  Map? vip;
  Map? fansDetail;
  UserSailing? userSailing;

  ReplyMember.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    uname = json['uname'];
    sign = json['sign'];
    avatar = json['avatar'];
    level = json['level_info']['current_level'];
    pendant =
        json['pendant'] == null ? null : Pendant.fromJson(json['pendant']);
    officialVerify = json['official_verify'];
    vip = json['vip'];
    fansDetail = json['fans_detail'];
    userSailing = json['user_sailing'] != null
        ? UserSailing.fromJson(json['user_sailing'])
        : UserSailing();
  }
}

class UserSailing {
  UserSailing({this.pendant, this.cardbg});

  Map? pendant;
  Map? cardbg;

  UserSailing.fromJson(Map<String, dynamic> json) {
    pendant = json['pendant'];
    cardbg = json['cardbg'];
  }
}
