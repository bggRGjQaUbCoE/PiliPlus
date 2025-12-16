import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';

class CardLiveItem {
  int? roomid;
  int? uid;
  String? uname;
  String? face;
  String? cover;
  String? title;
  int? liveTime;
  String? areaName;
  int? areaV2Id;
  String? areaV2Name;
  String? areaV2ParentName;
  int? areaV2ParentId;
  WatchedShow? watchedShow;

  CardLiveItem({
    this.roomid,
    this.uid,
    this.uname,
    this.face,
    this.cover,
    this.title,
    this.liveTime,
    this.areaName,
    this.areaV2Id,
    this.areaV2Name,
    this.areaV2ParentName,
    this.areaV2ParentId,
    this.watchedShow,
  });

  factory CardLiveItem.fromJson(Map<String, dynamic> json) => CardLiveItem(
    roomid: json['roomid'] ?? json['id'],
    uid: json['uid'] as int?,
    uname: json['uname'] as String?,
    face: json['face'] as String?,
    cover: json['cover'] as String?,
    title: json['title'] as String?,
    liveTime: json['live_time'] as int?,
    areaName: json['area_name'] as String?,
    areaV2Id: json['area_v2_id'] as int?,
    areaV2Name: json['area_v2_name'] as String?,
    areaV2ParentName: json['area_v2_parent_name'] as String?,
    areaV2ParentId: json['area_v2_parent_id'] as int?,
    watchedShow: json['watched_show'] == null
        ? null
        : WatchedShow.fromJson(json['watched_show'] as Map<String, dynamic>),
  );
}
