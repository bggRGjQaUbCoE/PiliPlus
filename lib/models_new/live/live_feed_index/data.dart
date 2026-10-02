import 'package:PiliPlus/models_new/live/live_feed_index/card_list.dart';

class LiveIndexData {
  List<LiveCardList>? cardList;
  int? hasMore;
  LiveCardList? followItem;
  LiveCardList? areaItem;

  LiveIndexData({
    this.cardList,
    this.hasMore,
  });

  LiveIndexData.fromJson(Map<String, dynamic> json) {
    if (json['card_list'] case final List list when list.isNotEmpty) {
      // banner_v2
      // my_idol_v1
      // area_entrance_v3
      // small_card_v1
      for (final json in list) {
        switch (json['card_type']) {
          case 'my_idol_v1':
            followItem = LiveCardList.fromJson(json);
            break;
          case 'area_entrance_v3':
            areaItem = LiveCardList.fromJson(json);
            break;
          case 'small_card_v1':
            (cardList ??= <LiveCardList>[]).add(LiveCardList.fromJson(json));
            break;
        }
      }
    }
    areaItem ??= LiveCardList.kAreaEntrance;
    hasMore = json['has_more'] as int?;
  }
}
