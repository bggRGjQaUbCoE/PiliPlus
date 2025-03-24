import 'package:PiliPlus/utils/utils.dart';

import '../model_video.dart';

class MemberArchiveDataModel {
  MemberArchiveDataModel({
    this.list,
    this.page,
  });

  ArchiveListModel? list;
  Map? page;

  MemberArchiveDataModel.fromJson(Map<String, dynamic> json) {
    list = ArchiveListModel.fromJson(json['list']);
    page = json['page'];
  }
}

class ArchiveListModel {
  ArchiveListModel({
    this.tlist,
    this.vlist,
  });

  Map<String, TListItemModel>? tlist;
  List<VListItemModel>? vlist;

  ArchiveListModel.fromJson(Map<String, dynamic> json) {
    tlist = json['tlist'] != null
        ? Map.from(json['tlist']).map((k, v) =>
            MapEntry<String, TListItemModel>(k, TListItemModel.fromJson(v)))
        : {};
    vlist = (json['vlist'] as List?)
        ?.map<VListItemModel>((e) => VListItemModel.fromJson(e))
        .toList();
  }
}

class TListItemModel {
  TListItemModel({
    this.tid,
    this.count,
    this.name,
  });

  int? tid;
  int? count;
  String? name;

  TListItemModel.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    count = json['count'];
    name = json['name'];
  }
}

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
    pic = json['pic'];
    subtitle = json['subtitle'];
    desc = json['description'];
    copyright = json['copyright'];
    title = json['title'];
    review = json['review'];
    pubdate = json['created'];
    if (json['length'] != null) duration = Utils.duration(json['length']);
    aid = json['aid'];
    bvid = json['bvid'];
    hideClick = json['hide_click'];
    isChargingSrc = json['is_charging_arc'];
    stat = VListStat.fromJson(json);
    owner = VListOwner.fromJson(json);
  }

  // @override
  // int? cid = null;

  // @override
  // String? rcmdReason = null;

  // @override
  // String? goto;

  // @override
  // bool isFollowed;

  // @override
  // String? uri;
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
