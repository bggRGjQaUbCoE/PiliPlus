import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/user.dart';

import '../../models/user/sub_detail.dart';
import '../../models/user/sub_folder.dart';

class SubDetailController
    extends CommonListController<SubDetailModelData, SubDetailMediaItem> {
  late SubFolderItemData item;

  late int id;
  late String heroTag;

  RxInt mediaCount = 0.obs;
  RxInt playCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments;
    playCount.value = item.viewCount!;
    id = int.parse(Get.parameters['id']!);
    heroTag = Get.parameters['heroTag']!;
    queryData();
  }

  @override
  List<SubDetailMediaItem>? getDataList(SubDetailModelData response) {
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= mediaCount.value) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(
      bool isRefresh, Success<SubDetailModelData> response) {
    mediaCount.value = response.response.info!.mediaCount!;
    if (item.type == 11) {
      playCount.value = response.response.info!.cntInfo!['play'];
    }
    return false;
  }

  @override
  Future<LoadingState<SubDetailModelData>> customGetData() {
    if (item.type! == 11) {
      return UserHttp.favResourceList(
        id: id,
        ps: 20,
        pn: currentPage,
      );
    } else {
      return UserHttp.favSeasonList(
        // item.type! == 21
        id: id,
        ps: 20,
        pn: currentPage,
      );
    }
  }
}
