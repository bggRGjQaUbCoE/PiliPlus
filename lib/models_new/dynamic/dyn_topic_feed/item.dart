import 'package:PiliPlus/models/dynamics/result.dart';
import 'package:PiliPlus/models_new/dynamic/dyn_topic_feed/fold_card_item.dart';

class TopicCardItem {
  FoldCardItem? foldCardItem;
  DynamicItemModel? dynamicCardItem;
  String? topicType;

  TopicCardItem({this.dynamicCardItem, this.foldCardItem, this.topicType});

  factory TopicCardItem.fromJson(Map<String, dynamic> json) => TopicCardItem(
    dynamicCardItem: json['dynamic_card_item'] == null
        ? null
        : DynamicItemModel.fromJson(
            json['dynamic_card_item'] as Map<String, dynamic>,
          ),
    foldCardItem: json['fold_card_item'] == null
        ? null
        : FoldCardItem.fromJson(
            json['fold_card_item'] as Map<String, dynamic>,
          ),
    topicType: json['topic_type'] as String?,
  );
}
