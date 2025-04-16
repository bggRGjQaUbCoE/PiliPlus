class SearchKeywordList {
  String? keyword;
  String? icon;
  bool? showLiveIcon;

  SearchKeywordList.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'] as String?;
  }
}

class TrendingList extends SearchKeywordList {
  String? showName;
  // 4/5热 11话题 8普通 7直播
  int? wordType;
  int? hotId;
  String? isCommercial;
  int? resourceId;

  TrendingList.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    showName = json['show_name'] as String?;
    wordType = json['word_type'] as int?;
    icon = json['icon'] as String?;
    hotId = json['hot_id'] as int?;
    isCommercial = json['is_commercial'] as String?;
    resourceId = json['resource_id'] as int?;
    showLiveIcon = json['show_live_icon'] as bool?;
  }
}
