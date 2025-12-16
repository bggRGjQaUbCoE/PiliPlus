class RoomInfo {
  int? uid;
  int? roomId;
  String? title;
  String? cover;
  int? liveStatus;
  int? liveStartTime;
  int? online;
  String? appBackground;
  String? subSessionKey;

  RoomInfo({
    this.uid,
    this.roomId,
    this.title,
    this.cover,
    this.liveStatus,
    this.liveStartTime,
    this.online,
    this.appBackground,
    this.subSessionKey,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) => RoomInfo(
    uid: json['uid'] as int?,
    roomId: json['room_id'] as int?,
    title: json['title'] as String?,
    cover: json['cover'] as String?,
    liveStatus: json['live_status'] as int?,
    liveStartTime: json['live_start_time'] as int?,
    online: json['online'] as int?,
    appBackground: json['app_background'] as String?,
    subSessionKey: json['sub_session_key'] as String?,
  );
}
