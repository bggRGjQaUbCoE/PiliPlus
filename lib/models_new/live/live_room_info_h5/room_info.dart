class RoomInfo {
  int? uid;
  String? title;
  String? cover;
  String? appBackground;
  int? areaId;
  int? parentAreaId;

  RoomInfo({
    this.uid,
    this.title,
    this.cover,
    this.appBackground,
    this.areaId,
    this.parentAreaId,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) => RoomInfo(
    uid: json['uid'] as int?,
    title: json['title'] as String?,
    cover: json['cover'] as String?,
    appBackground: json['app_background'] as String?,
    areaId: json['area_id'] as int?,
    parentAreaId: json['parent_area_id'] as int?,
  );
}
