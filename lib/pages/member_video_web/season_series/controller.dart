import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/member/archive_sort_type_app.dart';
import 'package:PiliPlus/models/common/member/web_ss_type.dart';
import 'package:PiliPlus/models_new/member/season_web/archive.dart';
import 'package:PiliPlus/models_new/member/season_web/data.dart';
import 'package:PiliPlus/pages/member_video_web/base/controller.dart';
import 'package:get/get.dart';

class MemberSSWebCtr
    extends BaseVideoWebCtr<SeasonWebData, SeasonArchive, ArchiveSortTypeApp> {
  @override
  final Rx<ArchiveSortTypeApp> order = Rx(.desc);
  late final WebSsType _type;
  late final Object _id;

  @override
  void onInit() {
    final args = Get.arguments;
    _type = args['type'];
    _id = args['id'];
    super.onInit();
  }

  @override
  List<SeasonArchive>? getDataList(SeasonWebData response) {
    return response.archives;
  }

  @override
  bool customHandleResponse(
    bool isRefresh,
    Success<SeasonWebData> response,
  ) {
    if (isRefresh) {
      final data = response.response;
      if (data.page?.total case final total?) {
        count = total;
        totalPage = (total / ps).ceil();
      }
    }
    return false;
  }

  @override
  Future<LoadingState<SeasonWebData>> customGetData() =>
      MemberHttp.seasonSeriesWeb(
        type: _type,
        mid: mid,
        id: _id,
        ps: ps,
        pn: page,
        sort: order.value,
      );
}
