import 'package:PiliPlus/models/model_avatar.dart';

class OfficialVerify extends BaseOfficialVerify {
  int? role;
  String? title;
  String? icon;
  String? spliceTitle;

  OfficialVerify.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    role = json['role'];
    title = json['title'];
    icon = json['icon'];
    spliceTitle = json['splice_title'];
  }
}
