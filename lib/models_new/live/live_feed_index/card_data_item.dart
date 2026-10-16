import 'package:PiliPlus/models_new/live/live_feed_index/card_data_list_item.dart';

class CardDataItem {
  final List<CardLiveItem>? list;
  final ExtraInfo? extraInfo;

  const CardDataItem({
    this.list,
    this.extraInfo,
  });

  factory CardDataItem.fromJson(Map<String, dynamic> json) => CardDataItem(
    list: (json['list'] as List<dynamic>?)
        ?.map((e) => CardLiveItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    extraInfo: json['extra_info'] == null
        ? null
        : ExtraInfo.fromJson(json['extra_info'] as Map<String, dynamic>),
  );

  static const kAreaEntrance = CardDataItem(
    list: [
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 0,
        title: '人气',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 9,
        title: '虚拟主播',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 14,
        title: '聊天室',
      ),
      CardLiveItem(
        areaV2Id: 145,
        areaV2ParentId: 1,
        title: '颜值',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 1,
        title: '娱乐',
      ),
      CardLiveItem(
        areaV2Id: 86,
        areaV2ParentId: 2,
        title: '英雄联盟',
      ),
      CardLiveItem(
        areaV2Id: 35,
        areaV2ParentId: 3,
        title: '王者荣耀',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 5,
        title: '电台',
      ),
      CardLiveItem(
        areaV2Id: 89,
        areaV2ParentId: 2,
        title: 'CS2',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 15,
        title: '互动玩法',
      ),
      CardLiveItem(
        areaV2Id: 0,
        areaV2ParentId: 6,
        title: '单机游戏',
      ),
      CardLiveItem(
        areaV2Id: 21,
        areaV2ParentId: 1,
        title: '视频唱见',
      ),
      CardLiveItem(
        areaV2Id: 301000,
        areaV2ParentId: 301,
        title: '帮我玩',
      ),
      CardLiveItem(
        areaV2Id: 1013,
        areaV2ParentId: 1,
        title: '团播',
      ),
    ],
  );
}

class ExtraInfo {
  int? totalCount;

  ExtraInfo.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
  }
}
