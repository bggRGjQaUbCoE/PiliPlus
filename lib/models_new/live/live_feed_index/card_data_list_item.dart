import 'package:PiliPlus/models_new/live/live_feed_index/feedback.dart';
import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';
import 'package:PiliPlus/utils/parse_string.dart';

class CardLiveItem {
  final int? roomid;
  final int? uid;
  final String? uname;
  final String? face;
  final String? cover;
  final String? _systemCover;
  String? get systemCover => _systemCover ?? cover;
  final String? title;
  final String? areaName;
  final int? areaV2Id;
  final int? areaV2ParentId;
  final WatchedShow? watchedShow;
  final List<Feedback>? feedback;

  const CardLiveItem({
    this.roomid,
    this.uid,
    this.uname,
    this.face,
    this.cover,
    this._systemCover,
    this.title,
    this.areaName,
    this.areaV2Id,
    this.areaV2ParentId,
    this.watchedShow,
    this.feedback,
  });

  factory CardLiveItem.fromJson(Map<String, dynamic> json) => CardLiveItem(
    roomid: json['roomid'] ?? json['id'],
    uid: json['uid'] as int?,
    uname: json['uname'] as String?,
    face: json['face'] as String?,
    cover: json['cover'] as String?,
    systemCover: nonNullOrEmptyString(json['system_cover']),
    title: json['title'] as String?,
    areaName: json['area_name'] as String?,
    areaV2Id: json['area_v2_id'] as int?,
    areaV2ParentId: json['area_v2_parent_id'] as int?,
    watchedShow: json['watched_show'] == null
        ? null
        : WatchedShow.fromJson(json['watched_show'] as Map<String, dynamic>),
    feedback: (json['feedback'] as List?)
        ?.map((x) => Feedback.fromJson(x))
        .toList(),
  );
}
