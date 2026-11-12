import 'package:PiliPlus/models_new/live/live_info_by_user/medal.dart';
import 'package:PiliPlus/models_new/live/live_info_by_user/shield_info.dart';

class LiveInfoByUserData {
  ShieldInfo? shieldInfo;
  Medal? medal;

  LiveInfoByUserData({
    this.shieldInfo,
    this.medal,
  });

  factory LiveInfoByUserData.fromJson(Map<String, dynamic> json) =>
      LiveInfoByUserData(
        shieldInfo: json['shield_info'] == null
            ? null
            : ShieldInfo.fromJson(json['shield_info'] as Map<String, dynamic>),
        medal: json['medal'] == null
            ? null
            : Medal.fromJson(json['medal'] as Map<String, dynamic>),
      );
}
