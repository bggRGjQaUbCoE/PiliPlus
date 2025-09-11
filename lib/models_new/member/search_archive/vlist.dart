import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/duration_utils.dart';

class VListItemModel extends BaseVideoItemModel {
  int? comment;
  int? typeid;
  String? subtitle;
  String? copyright;
  int? review;
  bool? hideClick;
  bool? isChargingSrc;

  VListItemModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    typeid = json['typeid'];
    cover = json['pic'];
    subtitle = json['subtitle'];
    desc = json['description'];
    copyright = json['copyright'];
    title = json['title'];
    review = json['review'];
    pubdate = json['created'];
    if (json['length'] != null) {
      duration = DurationUtils.parseDuration(json['length']);
    }
    aid = json['aid'];
    bvid = json['bvid'];
    hideClick = json['hide_click'];
    isChargingSrc = json['is_charging_arc'];
    stat = VListStat.fromJson(json);
    owner = VListOwner.fromJson(json);
  }
}

class VListOwner extends BaseOwner {
  VListOwner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["author"];
  }
}

class VListStat extends BaseStat {
  VListStat.fromJson(Map<String, dynamic> json) {
    view = json["play"];
    danmu = json['video_review'];
  }
}
