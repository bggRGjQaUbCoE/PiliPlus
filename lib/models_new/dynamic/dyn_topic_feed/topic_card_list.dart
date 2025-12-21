import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/item.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/topic_sort_by_conf.dart';

class TopicCardList {
  bool? hasMore;
  List<TopicCardItem>? items;
  String? offset;
  TopicSortByConf? topicSortByConf;

  TopicCardList({this.hasMore, this.items, this.offset, this.topicSortByConf});

  factory TopicCardList.fromJson(Map<String, dynamic> json) => TopicCardList(
    hasMore: json['has_more'] as bool?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => TopicCardItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    offset: json['offset'] as String?,
    topicSortByConf: json['topic_sort_by_conf'] == null
        ? null
        : TopicSortByConf.fromJson(
            json['topic_sort_by_conf'] as Map<String, dynamic>,
          ),
  );
}
