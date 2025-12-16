import 'package:PiliPlus/models_new/live/live_room_info_h5/base_info.dart';

class AnchorInfo {
  BaseInfo? baseInfo;

  AnchorInfo({this.baseInfo});

  factory AnchorInfo.fromJson(Map<String, dynamic> json) => AnchorInfo(
    baseInfo: json['base_info'] == null
        ? null
        : BaseInfo.fromJson(json['base_info'] as Map<String, dynamic>),
  );
}
