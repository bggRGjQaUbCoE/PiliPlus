import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/models_new/popular/popular_series_list/list.dart';
import 'package:PiliPlus/models_new/popular/popular_series_one/config.dart';
import 'package:PiliPlus/models_new/popular/popular_series_one/data.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:get/get.dart';

class PopularSeriesController
    extends CommonListController<PopularSeriesOneData, HotVideoItemModel> {
  late int number;

  final Rx<PopularSeriesConfig?> config = Rx<PopularSeriesConfig?>(null);
  String? reminder;
  List<PopularSeriesListItem>? seriesList;

  @override
  void onInit() {
    super.onInit();
    _getSeriesList();
  }

  Future<void> _getSeriesList() async {
    final res = await VideoHttp.popularSeriesList();
    if (res.isSuccess) {
      final list = res.data;
      if (list != null && list.isNotEmpty) {
        number = list.first.number!;
        seriesList = list;
        queryData();
      } else {
        loadingState.value = const Success(null);
      }
    } else {
      loadingState.value = res as Error;
    }
  }

  @override
  List<HotVideoItemModel>? getDataList(PopularSeriesOneData response) {
    config.value = response.config;
    reminder = response.reminder;
    return response.list;
  }

  @override
  Future<LoadingState<PopularSeriesOneData>> customGetData() =>
      VideoHttp.popularSeriesOne(number: number);

  @override
  Future<void> onReload() {
    if (seriesList.isNullOrEmpty) {
      return _getSeriesList();
    }
    return super.onReload();
  }
}
