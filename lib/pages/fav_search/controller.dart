import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/pages/common/common_controller.dart';
import 'package:PiliPlus/pages/fav_search/view.dart' show SearchType;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/user.dart';

import '../../http/video.dart';

class FavSearchController extends CommonController {
  final controller = TextEditingController();
  final searchFocusNode = FocusNode();

  int? type;
  int? mediaId;
  int? mid;
  late SearchType searchType;

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments['type'];
    mediaId = Get.arguments['mediaId'];
    mid = Get.arguments['mid'];
    searchType = Get.arguments['searchType'];
  }

  // 清空搜索
  void onClear() {
    if (controller.text.isNotEmpty) {
      controller.clear();
    } else {
      Get.back();
    }
  }

  @override
  Future onRefresh() {
    if (controller.value.text.isEmpty) {
      return Future.value();
    }
    return super.onRefresh();
  }

  @override
  bool customHandleResponse(Success response) {
    late List currentList = loadingState.value is Success
        ? (loadingState.value as Success).response
        : [];
    List? dataList = currentPage == 1
        ? response.response.list
        : response.response.list != null
            ? currentList + response.response.list
            : currentList;
    isEnd = searchType == SearchType.fav
        ? response.response.hasMore == false
        : response.response.list == null || response.response.list.isEmpty;
    loadingState.value = LoadingState.success(dataList);
    return true;
  }

  onCancelFav(int id, int type) async {
    var result = await VideoHttp.favVideo(
      aid: id,
      addIds: '',
      delIds: mediaId.toString(),
      type: type,
    );
    if (result['status']) {
      List dataList = (loadingState.value as Success).response;
      dataList.removeWhere((item) => item.id == id);
      loadingState.value = LoadingState.success(dataList);
      SmartDialog.showToast('取消收藏');
    }
  }

  @override
  Future<LoadingState> customGetData() => switch (searchType) {
        SearchType.fav => UserHttp.userFavFolderDetail(
            pn: currentPage,
            ps: 20,
            mediaId: mediaId!,
            keyword: controller.text,
            type: type!,
          ),
        SearchType.follow => MemberHttp.getfollowSearch(
            mid: mid!,
            ps: 20,
            pn: currentPage,
            name: controller.value.text,
          ),
        SearchType.history => UserHttp.searchHistory(
            pn: currentPage,
            keyword: controller.value.text,
          ),
      };

  @override
  void onClose() {
    searchFocusNode.dispose();
    controller.dispose();
    super.onClose();
  }

  Future delHistory(kid, business) async {
    String resKid = 'archive_$kid';
    if (business == 'live') {
      resKid = 'live_$kid';
    } else if (business.contains('article')) {
      resKid = 'article_$kid';
    }

    var res = await UserHttp.delHistory([resKid]);
    if (res['status']) {
      List historyList = (loadingState.value as Success).response;
      historyList.removeWhere((e) => e.kid == kid);
      loadingState.value = LoadingState.success(historyList);
      SmartDialog.showToast(res['msg']);
    }
  }
}
