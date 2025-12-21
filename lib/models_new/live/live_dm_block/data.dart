import 'package:PiliPlus/models_new/live/live_dm_block/shield_info.dart';

class LiveDmBlockData {
  ShieldInfo? shieldInfo;

  LiveDmBlockData({this.shieldInfo});

  factory LiveDmBlockData.fromJson(Map<String, dynamic> json) =>
      LiveDmBlockData(
        shieldInfo: json['shield_info'] == null
            ? null
            : ShieldInfo.fromJson(json['shield_info'] as Map<String, dynamic>),
      );
}
