import 'package:PiliPlus/models/search/search_trending/trending_list.dart';

class SearchKeywordData {
  List<SearchKeywordList>? list;

  SearchKeywordData.fromJson(Map<String, dynamic> json) {
    list =
        (json['list'] as List?)?.map((e) => TrendingList.fromJson(e)).toList();
  }
}

class TrendingData implements SearchKeywordData {
  String? trackid;
  @override
  List<SearchKeywordList>? list;
  List<SearchKeywordList>? topList;
  String? hotwordEggInfo;

  TrendingData({this.trackid, this.list, this.topList, this.hotwordEggInfo});

  factory TrendingData.fromJson(Map<String, dynamic> json) => TrendingData(
        trackid: json['trackid'] as String?,
        list: (json['list'] as List<dynamic>?)
            ?.map((e) => TrendingList.fromJson(e as Map<String, dynamic>))
            .toList(),
        topList: (json['top_list'] as List<dynamic>?)
            ?.map((e) => TrendingList.fromJson(e as Map<String, dynamic>))
            .toList(),
        hotwordEggInfo: json['hotword_egg_info'] as String?,
      );
}
