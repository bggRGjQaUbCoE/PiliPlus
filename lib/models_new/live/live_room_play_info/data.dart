import 'package:PiliPlus/models_new/live/live_room_play_info/playurl_info.dart';

class RoomPlayInfoData {
  int? roomId;
  int? shortId;
  int? uid;
  bool? isPortrait;
  int? liveStatus;
  int? liveTime;
  PlayurlInfo? playurlInfo;

  RoomPlayInfoData({
    this.roomId,
    this.shortId,
    this.uid,
    this.isPortrait,
    this.liveStatus,
    this.liveTime,
    this.playurlInfo,
  });

  factory RoomPlayInfoData.fromJson(Map<String, dynamic> json) =>
      RoomPlayInfoData(
        roomId: json['room_id'] as int?,
        shortId: json['short_id'] as int?,
        uid: json['uid'] as int?,
        isPortrait: json['is_portrait'] as bool?,
        liveStatus: json['live_status'] as int?,
        liveTime: json['live_time'] as int?,
        playurlInfo: json['playurl_info'] == null
            ? null
            : PlayurlInfo.fromJson(
                json['playurl_info'] as Map<String, dynamic>,
              ),
      );
}
