import 'package:PiliPlus/utils/utils.dart';

abstract class BaseSimpleVideoItemModel {
  late String title;
  String? bvid;
  int? cid;
  String? pic;
  int duration = -1;
  late BaseOwner owner;
  late BaseStat stat;
}

abstract class BaseVideoItemModel extends BaseSimpleVideoItemModel {
  int? aid;
  String? desc;
  int? pubdate;
  bool isFollowed = false;
}

abstract class BaseOwner {
  int? mid;
  String? name;
}

abstract class BaseStat {
  int? view;
  int? like;
  int? danmu;

  String get viewStr => Utils.numFormat(view);
  String get danmuStr => Utils.numFormat(danmu);
}

class Stat extends BaseStat {
  Stat.fromJson(Map<String, dynamic> json) {
    view = json["view"];
    like = json["like"];
    danmu = json['danmaku'];
  }
}

class PlayStat extends BaseStat {
  PlayStat.fromJson(Map<String, dynamic> json) {
    view = json['play'];
    danmu = json['danmaku'];
  }
}

class Dimension {
  int? width;
  int? height;
  int? rotate;

  Dimension.fromJson(Map<String, dynamic> json) {
    width = json["width"];
    height = json["height"];
    rotate = json["rotate"];
  }
}
