import 'package:PiliPlus/models_new/live/live_fans_medal/anchor_info.dart';
import 'package:PiliPlus/models_new/live/live_fans_medal/medal.dart';
import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';

class FansMedalItem {
  Medal medal;
  AnchorInfo anchorInfo;
  UinfoMedal uinfoMedal;

  FansMedalItem({
    required this.medal,
    required this.anchorInfo,
    required this.uinfoMedal,
  });

  factory FansMedalItem.fromJson(Map<String, dynamic> json) => FansMedalItem(
    medal: Medal.fromJson(json['medal'] as Map<String, dynamic>),
    anchorInfo: AnchorInfo.fromJson(
      json['anchor_info'] as Map<String, dynamic>,
    ),
    uinfoMedal: UinfoMedal.fromJson(
      json['uinfo_medal'] as Map<String, dynamic>,
    ),
  );
}
