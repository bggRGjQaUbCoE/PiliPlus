import 'package:PiliPlus/models_new/live/live_feed_index/watched_show.dart';

class LiveSearchRoomItemModel {
  int? roomid;
  String? cover;
  String? title;
  String? name;
  String? face;
  WatchedShow? watchedShow;

  LiveSearchRoomItemModel({
    this.roomid,
    this.cover,
    this.title,
    this.name,
    this.face,
    this.watchedShow,
  });

  factory LiveSearchRoomItemModel.fromJson(Map<String, dynamic> json) =>
      LiveSearchRoomItemModel(
        roomid: json['roomid'] as int?,
        cover: json['cover'] as String?,
        title: json['title'] as String?,
        name: json['name'] as String?,
        face: json['face'] as String?,
        watchedShow: json['watched_show'] == null
            ? null
            : WatchedShow.fromJson(
                json['watched_show'] as Map<String, dynamic>,
              ),
      );
}
