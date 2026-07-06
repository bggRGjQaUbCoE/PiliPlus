import 'package:PiliPlus/models_new/search/search_rcmd/data.dart';
import 'package:PiliPlus/models_new/search/search_trending/list.dart';

class SearchTrendingData extends SearchRcmdData {
  late int topCount;

  SearchTrendingData.fromJson(
    Map<String, dynamic> json, {
    bool needsTop = false,
  }) {
    list = (json['list'] as List<dynamic>?)
        ?.map((e) => SearchTrendingItemModel.fromJson(e))
        .toList();
    if (needsTop) {
      final topList = (json['top_list'] as List<dynamic>?)
          ?.map((e) => SearchTrendingItemModel.fromJson(e))
          .toList();
      topCount = topList?.length ?? 0;
      if (topList != null && topList.isNotEmpty) {
        if (list != null) {
          list!.insertAll(0, topList);
        } else {
          list = topList;
        }
      }
    }
  }
}
