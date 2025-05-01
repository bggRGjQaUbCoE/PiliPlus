class RoomInfoH5Model {
  RoomInfoH5Model({
    this.roomInfo,
    this.anchorInfo,
    this.isRoomFeed,
    this.watchedShow,
    this.likeInfoV3,
    this.blockInfo,
  });

  RoomInfo? roomInfo;
  AnchorInfo? anchorInfo;
  int? isRoomFeed;
  Map? watchedShow;
  LikeInfoV3? likeInfoV3;
  Map? blockInfo;

  RoomInfoH5Model.fromJson(Map<String, dynamic> json) {
    roomInfo =
        json['room_info'] == null ? null : RoomInfo.fromJson(json['room_info']);
    anchorInfo = json['anchor_info'] == null
        ? null
        : AnchorInfo.fromJson(json['anchor_info']);
    isRoomFeed = json['is_room_feed'];
    watchedShow = json['watched_show'];
    likeInfoV3 = json['like_info_v3'] == null
        ? null
        : LikeInfoV3.fromJson(json['like_info_v3']);
    blockInfo = json['block_info'];
  }
}

class RoomInfo {
  RoomInfo({
    this.uid,
    this.roomId,
    this.title,
    this.cover,
    this.description,
    this.liveStatus,
    this.liveStartTime,
    this.areaId,
    this.areaName,
    this.parentAreaId,
    this.parentAreaName,
    this.online,
    this.background,
    this.appBackground,
    this.liveId,
  });

  int? uid;
  int? roomId;
  String? title;
  String? cover;
  String? description;
  int? liveStatus;
  int? liveStartTime;
  int? areaId;
  String? areaName;
  int? parentAreaId;
  String? parentAreaName;
  int? online;
  String? background;
  String? appBackground;
  String? liveId;

  RoomInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    roomId = json['room_id'];
    title = json['title'];
    cover = json['cover'];
    description = json['description'];
    liveStatus = json['liveS_satus'];
    liveStartTime = json['live_start_time'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    parentAreaId = json['parent_area_id'];
    parentAreaName = json['parent_area_name'];
    online = json['online'];
    background = json['background'];
    appBackground = json['app_background'];
    liveId = json['live_id'];
  }
}

class AnchorInfo {
  AnchorInfo({
    this.baseInfo,
    // this.relationInfo,
  });

  BaseInfo? baseInfo;
  // RelationInfo? relationInfo;

  AnchorInfo.fromJson(Map<String, dynamic> json) {
    baseInfo =
        json['base_info'] == null ? null : BaseInfo.fromJson(json['base_info']);
    // relationInfo = json['relation_info'] == null
    //     ? null
    //     : RelationInfo.fromJson(json['relation_info']);
  }
}

class BaseInfo {
  BaseInfo({
    this.uname,
    this.face,
  });

  String? uname;
  String? face;

  BaseInfo.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    face = json['face'];
  }
}

class RelationInfo {
  RelationInfo({this.attention});

  int? attention;

  RelationInfo.fromJson(Map<String, dynamic> json) {
    attention = json['attention'];
  }
}

class LikeInfoV3 {
  LikeInfoV3({this.totalLikes});

  int? totalLikes;

  LikeInfoV3.fromJson(Map<String, dynamic> json) {
    totalLikes = json['total_likes'];
  }
}
