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
    if ((json['list'] as List<dynamic>?)?.isNotEmpty == true) {
      list = <LiveFollowItem>[];
      for (var json in json['list']) {
        if (json['live_status'] == 1) {
          list!.add(LiveFollowItem.fromJson(json));
        }
      }
    }
    count = json['count'] as int?;
    liveCount = json['live_count'] as int?;
  }
}
