import 'package:PiliPlus/models/model_avatar.dart';

class MemberInfoModel {
  MemberInfoModel({
    this.mid,
    this.name,
    this.sex,
    this.face,
    this.sign,
    this.level,
    this.isFollowed,
    this.topPhoto,
    this.official,
    this.vip,
    this.liveRoom,
    this.isSeniorMember,
  });

  int? mid;
  String? name;
  String? sex;
  String? face;
  String? sign;
  int? level;
  bool? isFollowed;
  String? topPhoto;
  Map? official;
  Vip? vip;
  LiveRoom? liveRoom;
  int? isSeniorMember;

  MemberInfoModel.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    sex = json['sex'];
    face = json['face'];
    sign = json['sign'] == '' ? '该用户还没有签名' : json['sign'].replaceAll('\n', '');
    level = json['level'];
    isFollowed = json['is_followed'];
    topPhoto = json['top_photo'];
    official = json['official'];
    vip = Vip.fromJson(json['vip']);
    liveRoom =
        json['live_room'] != null ? LiveRoom.fromJson(json['live_room']) : null;
    isSeniorMember = json['is_senior_member'];
  }
}

class LiveRoom {
  LiveRoom({
    this.roomStatus,
    this.liveStatus,
    this.url,
    this.title,
    this.cover,
    this.roomId,
    this.roundStatus,
    this.watchedShow,
  });

  int? roomStatus;
  int? liveStatus;
  String? url;
  String? title;
  String? cover;
  int? roomId;
  int? roundStatus;
  Map? watchedShow;

  LiveRoom.fromJson(Map<String, dynamic> json) {
    roomStatus = json['roomStatus'];
    liveStatus = json['liveStatus'];
    url = json['url'];
    title = json['title'];
    cover = json['cover'];
    roomId = json['roomid'];
    roundStatus = json['roundStatus'];
    watchedShow = json['watched_show'];
  }
}
