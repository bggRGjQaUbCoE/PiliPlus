import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/models/search/search_trending/trending_data.dart';
import 'package:PiliPlus/models/search/search_trending/trending_list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';

class SearchTrendingController
    extends CommonListController<TrendingData, SearchKeywordList> {
  int topCount = 0;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  List<SearchKeywordList>? getDataList(TrendingData response) {
    List<SearchKeywordList> topList = response.topList ?? <TrendingList>[];
    topCount = topList.length;
    return response.list == null ? topList : topList
      ..addAll(response.list ?? []);
  }

  @override
  Future<LoadingState<TrendingData>> customGetData() =>
      SearchHttp.searchTrending();
}
