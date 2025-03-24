import 'package:get/get.dart';
import 'package:PiliPlus/http/user.dart';

import '../../models/user/sub_detail.dart';
import '../../models/user/sub_folder.dart';

class SubDetailController extends GetxController {
  late SubFolderItemData item;

  late int id;
  late String heroTag;
  int currentPage = 1;
  bool isLoadingMore = false;
  Rx<DetailInfo> subInfo = DetailInfo().obs;
  RxList<SubDetailMediaItem> subList = <SubDetailMediaItem>[].obs;
  RxString loadingText = '加载中...'.obs;
  int mediaCount = 0;
  RxInt playCount = 0.obs;

  @override
  void onInit() {
    item = Get.arguments;
    if (playCount.value == 0) playCount.value = item.viewCount!;
    if (Get.parameters.keys.isNotEmpty) {
      id = int.parse(Get.parameters['id']!);
      heroTag = Get.parameters['heroTag']!;
    }
    super.onInit();
  }

  Future<dynamic> queryUserSubFolderDetail({type = 'init'}) async {
    if (type == 'onLoad' && subList.length >= mediaCount) {
      loadingText.value = '没有更多了';
      return;
    }
    isLoadingMore = true;
    late Map<String, dynamic> res;
    if (item.type! == 11) {
      res = await UserHttp.favResourceList(
        id: id,
        ps: 20,
        pn: currentPage,
      );
    } else {
      res = await UserHttp.favSeasonList(
        // item.type! == 21
        id: id,
        ps: 20,
        pn: currentPage,
      );
    }
    if (res['status']) {
      SubDetailModelData data = res['data'];
      subInfo.value = data.info!;
      if (currentPage == 1 && type == 'init') {
        subList.value = data.list!;
        mediaCount = data.info!.mediaCount!;
        if (item.type == 11) {
          playCount.value = data.info!.cntInfo!['play'];
        }
      } else if (type == 'onLoad') {
        subList.addAll(data.list!);
      }
      if (subList.length >= mediaCount) {
        loadingText.value = '没有更多了';
      }
      currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  onLoad() {
    queryUserSubFolderDetail(type: 'onLoad');
  }
}
