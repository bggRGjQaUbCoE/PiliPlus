import 'package:PiliPlus/models_new/live/live_fans_medal/medal.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';

class FansMedalItem {
  FansMedalDetail? medal;
  String? anchorName;
  String? anchorAvatar;
  String? superscript;
  UinfoMedal? uinfoMedal;

  FansMedalItem({
    this.medal,
    this.anchorName,
    this.anchorAvatar,
    this.superscript,
    this.uinfoMedal,
  });

  factory FansMedalItem.fromJson(Map<String, dynamic> json) => FansMedalItem(
        medal: json['medal'] == null
            ? null
            : FansMedalDetail.fromJson(json['medal'] as Map<String, dynamic>),
        anchorName: json['anchor_info']?['nick_name'] as String?,
        anchorAvatar: json['anchor_info']?['avatar'] as String?,
        superscript: json['superscript']?['content'] as String?,
        uinfoMedal: json['uinfo_medal'] == null
            ? null
            : UinfoMedal.fromJson(json['uinfo_medal'] as Map<String, dynamic>),
      );
}