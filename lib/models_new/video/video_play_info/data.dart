import 'package:PiliPlus/models_new/video/video_play_info/interaction.dart';
import 'package:PiliPlus/models_new/video/video_play_info/dm_mask.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle_info.dart';
import 'package:PiliPlus/models_new/video/video_play_info/view_point.dart';

class PlayInfoData {
  int? lastPlayCid;
  int? lastPlayTime;
  SubtitleInfo? subtitle;
  List<ViewPoint>? viewPoints;
  Interaction? interaction;
  DmMask? dmMask;

  PlayInfoData({
    this.lastPlayCid,
    this.lastPlayTime,
    this.subtitle,
    this.viewPoints,
    this.interaction,
    this.dmMask,
  });

  factory PlayInfoData.fromJson(Map<String, dynamic> json) => PlayInfoData(
    lastPlayCid: json['last_play_cid'] as int?,
    lastPlayTime: (json['last_play_time'] as int?) ??
        json['play_view_business_info']?['user_status']?['watch_progress']
            ?['current_watch_progress'] as int?,
    subtitle: json['subtitle'] == null
        ? null
        : SubtitleInfo.fromJson(json['subtitle'] as Map<String, dynamic>),
    viewPoints: (json['view_points'] as List?)
        ?.map((e) => ViewPoint.fromJson(e))
        .toList(),
    interaction: json["interaction"] == null
        ? null
        : Interaction.fromJson(json["interaction"]),
    dmMask: DmMask.fromJsonOrNull(json['dm_mask']),
  );
}
