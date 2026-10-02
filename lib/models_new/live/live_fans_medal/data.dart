import 'package:PiliPlus/models_new/live/live_fans_medal/item.dart';

class FansMedalPanelData {
  List<FansMedalItem>? specialList;
  List<FansMedalItem>? list;
  int? totalNumber;
  bool? hasMore;
  int? nextPage;

  FansMedalPanelData({
    this.specialList,
    this.list,
    this.totalNumber,
    this.hasMore,
    this.nextPage,
  });

  factory FansMedalPanelData.fromJson(Map<String, dynamic> json) =>
      FansMedalPanelData(
        specialList: (json['special_list'] as List<dynamic>?)
            ?.map((e) => FansMedalItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        list: (json['list'] as List<dynamic>?)
            ?.map((e) => FansMedalItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalNumber: json['total_number'] as int?,
        hasMore: json['page_info']?['has_more'] as bool?,
        nextPage: json['page_info']?['next_page'] as int?,
      );
}