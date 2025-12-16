class LiveFollowItem {
  int? roomid;
  int? uid;
  String? uname;
  String? title;
  String? face;
  int? liveStatus;
  String? areaName;
  String? areaNameV2;
  String? textSmall;
  String? roomCover;

  LiveFollowItem({
    this.roomid,
    this.uid,
    this.uname,
    this.title,
    this.face,
    this.liveStatus,
    this.areaName,
    this.areaNameV2,
    this.textSmall,
    this.roomCover,
  });

  factory LiveFollowItem.fromJson(Map<String, dynamic> json) => LiveFollowItem(
    roomid: json['roomid'] as int?,
    uid: json['uid'] as int?,
    uname: json['uname'] as String?,
    title: json['title'] as String?,
    face: json['face'] as String?,
    liveStatus: json['live_status'] as int?,
    areaName: json['area_name'] as String?,
    areaNameV2: json['area_name_v2'] as String?,
    textSmall: json['text_small'] as String?,
    roomCover: json['room_cover'] as String?,
  );
}
