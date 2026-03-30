import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/utils/duration_utils.dart';

class VListItemModel extends BaseVideoItemModel {
  VListItemModel.fromJson(Map<String, dynamic> json) {
    cover = json['pic'];
    desc = json['description'];
    title = json['title'];
    pubdate = json['created'];
    if (json['length'] != null) {
      duration = DurationUtils.parseDuration(json['length']);
    }
    aid = json['aid'];
    bvid = json['bvid'];
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
