import 'package:PiliPlus/models_new/live/live_feed_index/card_data.dart';

class LiveCardList {
  final String? cardType;
  final CardData? cardData;

  const LiveCardList({this.cardType, this.cardData});

  factory LiveCardList.fromJson(Map<String, dynamic> json) => LiveCardList(
    cardType: json['card_type'] as String?,
    cardData: json['card_data'] == null
        ? null
        : CardData.fromJson(json['card_data'] as Map<String, dynamic>),
  );

  static const kAreaEntrance = LiveCardList(cardData: CardData.kAreaEntrance);
}
