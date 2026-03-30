import 'package:PiliPlus/models_new/live/live_medal_wall/medal_info.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';

class MedalWallItem {
  MedalInfo? medalInfo;
  String? targetName;
  String? targetIcon;
  String? link;
  int? liveStatus;
  int? official;
  UinfoMedal? uinfoMedal;

  MedalWallItem({
    this.medalInfo,
    this.targetName,
    this.targetIcon,
    this.link,
    this.liveStatus,
    this.official,
    this.uinfoMedal,
  });

  factory MedalWallItem.fromJson(Map<String, dynamic> json) => MedalWallItem(
    medalInfo: json['medal_info'] == null
        ? null
        : MedalInfo.fromJson(json['medal_info'] as Map<String, dynamic>),
    targetName: json['target_name'] as String?,
    targetIcon: json['target_icon'] as String?,
    link: json['link'] as String?,
    liveStatus: json['live_status'] as int?,
    official: json['official'] as int?,
    uinfoMedal: json['uinfo_medal'] == null
        ? null
        : UinfoMedal.fromJson(json['uinfo_medal'] as Map<String, dynamic>),
  );
}
