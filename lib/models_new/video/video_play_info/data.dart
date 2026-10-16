import 'package:PiliPlus/models_new/video/video_play_info/dm_mask.dart';
import 'package:PiliPlus/models_new/video/video_play_info/interaction.dart';
import 'package:PiliPlus/models_new/video/video_play_info/subtitle_info.dart';
import 'package:PiliPlus/models_new/video/video_play_info/view_point.dart';

class PlayInfoData {
  int? lastPlayCid;
  SubtitleInfo? subtitle;
  List<ViewPoint>? viewPoints;
  Interaction? interaction;
  DmMask? dmMask;

  PlayInfoData({
    this.lastPlayCid,
    this.subtitle,
    this.viewPoints,
    this.interaction,
    this.dmMask,
  });

  factory PlayInfoData.fromJson(Map<String, dynamic> json) => PlayInfoData(
    lastPlayCid: json['last_play_cid'] as int?,
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
