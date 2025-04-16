class TrendingList {
  String? keyword;
  String? showName;
  // 4/5热 11话题 8普通 7直播
  int? wordType;
  String? icon;
  int? hotId;
  String? isCommercial;
  int? resourceId;
  bool? showLiveIcon;

  TrendingList.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'] as String?;
    showName = json['show_name'] as String?;
    wordType = json['word_type'] as int?;
    icon = json['icon'] as String?;
    hotId = json['hot_id'] as int?;
    isCommercial = (json['is_commercial'] ??
        json['stat_datas']?['is_commercial']) as String?;
    resourceId = json['resource_id'] as int?;
    showLiveIcon = json['show_live_icon'] as bool?;
  }
}
