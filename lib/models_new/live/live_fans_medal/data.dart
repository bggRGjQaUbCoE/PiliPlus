import 'package:PiliPlus/models_new/live/live_fans_medal/item.dart';

class FansMedalData {
  List<FansMedalItem>? list;
  int? totalNumber;
  bool? hasMore;

  FansMedalData({
    this.list,
    this.hasMore,
  });

  FansMedalData.fromJson(Map<String, dynamic> json) {
    if (json['special_list'] case final List list when list.isNotEmpty) {
      this.list = list
          .map((e) => FansMedalItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (json['list'] case final List list when list.isNotEmpty) {
      (this.list ??= <FansMedalItem>[]).addAll(
        list.map((e) => FansMedalItem.fromJson(e as Map<String, dynamic>)),
      );
    }
    totalNumber = json['total_number'];
    hasMore = json['page_info']?['has_more'];
  }
}
