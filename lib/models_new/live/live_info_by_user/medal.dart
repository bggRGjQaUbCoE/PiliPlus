import 'package:PiliPlus/models_new/live/live_medal_wall/uinfo_medal.dart';

class Medal {
  UinfoMedal? currShow;
  UinfoMedal? currWearedV2;
  UinfoMedal? lookupV2;
  bool hasMedal;

  Medal({
    this.currShow,
    this.currWearedV2,
    this.lookupV2,
    required this.hasMedal,
  });

  factory Medal.fromJson(Map<String, dynamic> json) => Medal(
    currShow: json['curr_show'] == null
        ? null
        : UinfoMedal.fromJson(json['curr_show'] as Map<String, dynamic>),
    currWearedV2: json['curr_weared_v2'] == null
        ? null
        : UinfoMedal.fromJson(json['curr_weared_v2'] as Map<String, dynamic>),
    lookupV2: json['lookup_v2'] == null
        ? null
        : UinfoMedal.fromJson(json['lookup_v2'] as Map<String, dynamic>),
    hasMedal: json['up_medal'] != null,
  );
}
