import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';
import 'package:PiliPlus/utils/parse_string.dart';

class CardLiveItem {
  int? roomid;
  int? uid;
  String? uname;
  String? face;
  String? cover;
  String? _systemCover;
  String? get systemCover => _systemCover ?? cover;
  String? title;
  String? areaName;
  int? areaV2Id;
  int? areaV2ParentId;
  WatchedShow? watchedShow;

  CardLiveItem({
    this.roomid,
    this.uid,
    this.uname,
    this.face,
    this.cover,
    String? systemCover,
    this.title,
    this.areaName,
    this.areaV2Id,
    this.areaV2ParentId,
    this.watchedShow,
  }) : _systemCover = nonNullOrEmptyString(systemCover);

  factory CardLiveItem.fromJson(Map<String, dynamic> json) => CardLiveItem(
    roomid: json['roomid'] ?? json['id'],
    uid: json['uid'] as int?,
    uname: json['uname'] as String?,
    face: json['face'] as String?,
    cover: json['cover'] as String?,
    systemCover: json['system_cover'],
    title: json['title'] as String?,
    areaName: json['area_name'] as String?,
    areaV2Id: json['area_v2_id'] as int?,
    areaV2ParentId: json['area_v2_parent_id'] as int?,
    watchedShow: json['watched_show'] == null
        ? null
        : WatchedShow.fromJson(json['watched_show'] as Map<String, dynamic>),
  );
}
