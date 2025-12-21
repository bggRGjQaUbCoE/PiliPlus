import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';
import 'package:PiliPlus/models_new/live/live_second_list/tag.dart';

class LiveSecondData {
  int? count;
  List<CardLiveItem>? cardList;
  List<LiveSecondTag>? newTags;

  LiveSecondData({this.count, this.cardList, this.newTags});

  factory LiveSecondData.fromJson(Map<String, dynamic> json) => LiveSecondData(
    count: json['count'] as int?,
    cardList: (json['list'] as List<dynamic>?)
        ?.map((e) => CardLiveItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    newTags: (json['new_tags'] as List<dynamic>?)
        ?.map((e) => LiveSecondTag.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
