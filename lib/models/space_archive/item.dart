import '../model_owner.dart';
import '../model_video.dart';
import 'badge.dart';
import 'cursor_attr.dart';
import 'three_point.dart';

class Item extends BaseSimpleVideoItemModel {
  String? subtitle;
  String? tname;
  String? get cover => pic; // 不知道哪里使用了cover
  String? coverIcon;
  String? uri;
  String? param;
  String? goto;
  String? length;
  bool? isPopular;
  bool? isSteins;
  bool? isUgcpay;
  bool? isCooperation;
  bool? isPgc;
  bool? isLivePlayback;
  bool? isPugv;
  bool? isFold;
  bool? isOneself;
  int? ctime;
  int? ugcPay;
  bool? state;
  int? videos;
  List<ThreePoint>? threePoint;
  CursorAttr? cursorAttr;
  int? iconType;
  String? publishTimeText;
  List<Badge>? badges;
  Map? season;
  Map? history;

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    tname = json['tname'];
    pic = json['cover'];
    coverIcon = json['cover_icon'];
    uri = json['uri'];
    param = json['param'];
    goto = json['goto'];
    length = json['length'];
    duration = json['duration'] ?? -1;
    isPopular = json['is_popular'];
    isSteins = json['is_steins'];
    isUgcpay = json['is_ugcpay'];
    isCooperation = json['is_cooperation'];
    isPgc = json['is_pgc'];
    isLivePlayback = json['is_live_playback'];
    isPugv = json['is_pugv'];
    isFold = json['is_fold'];
    isOneself = json['is_oneself'];
    ctime = json['ctime'];
    ugcPay = json['ugc_pay'];
    state = json['state'];
    bvid = json['bvid'];
    videos = json['videos'];
    threePoint = (json['three_point'] as List<dynamic>?)
        ?.map((e) => ThreePoint.fromJson(e as Map<String, dynamic>))
        .toList();
    cid = json['first_cid'];
    cursorAttr = json['cursor_attr'] == null
        ? null
        : CursorAttr.fromJson(json['cursor_attr'] as Map<String, dynamic>);
    iconType = json['icon_type'];
    publishTimeText = json['publish_time_text'];
    badges = (json['badges'] as List<dynamic>?)
        ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
        .toList();
    season = json['season'];
    history = json['history'];
    stat = PlayStat.fromJson(json);
    owner = Owner(mid: 0, name: json['author']);
  }
}

class UserStat extends PlayStat {
  String? _viewStr;

  @override
  String get viewStr => _viewStr ?? super.viewStr;

  UserStat.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    _viewStr = json['view_content'];
  }
}
