import '../model_hot_video_item.dart';

class MemberCoinsDataModel extends HotVideoItemModel {
  String? subtitle;
  int? coins;
  int? time;
  // int? get view => stat.view;
  // int? get danmaku => stat.danmu;

  MemberCoinsDataModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    coins = json['coins'];
    subtitle = json['subtitle'];
    time = json['time'];
    // view = json['stat']['view'];
    // danmaku = json['stat']['danmaku'];
  }
  // @override
  // String? goto;
  // @override
  // bool isFollowed;
  // @override
  // String? rcmdReason;
  // @override
  // String? uri;
}
