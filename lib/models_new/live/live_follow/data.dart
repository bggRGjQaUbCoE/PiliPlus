import 'package:PiliPlus/models_new/live/live_follow/item.dart';

class LiveFollowData {
  String? title;
  int? pageSize;
  int? totalPage;
  List<LiveFollowItem>? list;
  int? count;
  int? liveCount;

  LiveFollowData({
    this.title,
    this.pageSize,
    this.totalPage,
    this.list,
    this.count,
    this.liveCount,
  });

  LiveFollowData.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String?;
    pageSize = json['pageSize'] as int?;
    totalPage = json['totalPage'] as int?;
    list = (json['list'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>()
        .where((i) => i['live_status'] == 1)
        .map(LiveFollowItem.fromJson)
        .toList();
    count = json['count'] as int?;
    liveCount = json['live_count'] as int?;
  }
}
