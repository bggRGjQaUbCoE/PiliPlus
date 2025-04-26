import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/user/fav_detail.dart';
import 'package:PiliPlus/models/user/fav_folder.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:PiliPlus/http/video.dart';

class FavDetailController
    extends MultiSelectController<FavDetailData, FavDetailItemData> {
  Rx<FavFolderItemData> item = FavFolderItemData().obs;
  late int mediaId;
  late String heroTag;
  RxBool isOwner = false.obs;
  RxBool titleCtr = false.obs;

  dynamic mid;

  @override
  void onInit() {
    super.onInit();

    mediaId = int.parse(Get.parameters['mediaId']!);
    heroTag = Get.parameters['heroTag']!;

    mid = Accounts.main.mid;

    queryData();
  }

  @override
  bool? get hasFooter => true;

  @override
  List<FavDetailItemData>? getDataList(FavDetailData response) {
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (item.value.mediaCount != null && length >= item.value.mediaCount!) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FavDetailData> response) {
    FavDetailData data = response.response;
    if (isRefresh) {
      item.value = data.info ?? FavFolderItemData();
      isOwner.value = data.info?.mid == mid;
    }
    return false;
  }

  onCancelFav(int index, int id, int type) async {
    var result = await VideoHttp.delFav(
      ids: ['$id:$type'],
      delIds: mediaId.toString(),
    );
    if (result['status']) {
      List<FavDetailItemData> dataList =
          (loadingState.value as Success).response;
      item.value.mediaCount = item.value.mediaCount! - 1;
      item.refresh();
      dataList.removeAt(index);
      loadingState.refresh();
      SmartDialog.showToast('取消收藏');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  @override
  Future<LoadingState<FavDetailData>> customGetData() =>
      UserHttp.userFavFolderDetail(
        pn: currentPage,
        ps: 20,
        mediaId: mediaId,
      );

  onDelChecked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认删除所选收藏吗？'),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                List<FavDetailItemData> list = ((loadingState.value as Success)
                        .response as List<FavDetailItemData>)
                    .where((e) => e.checked == true)
                    .toList();
                dynamic result = await VideoHttp.delFav(
                  ids: list.map((item) => '${item.id}:${item.type}').toList(),
                  delIds: mediaId.toString(),
                );
                if (result['status']) {
                  List<FavDetailItemData> dataList =
                      (loadingState.value as Success).response;
                  List<FavDetailItemData> remainList =
                      dataList.toSet().difference(list.toSet()).toList();
                  item.value.mediaCount = item.value.mediaCount! - list.length;
                  item.refresh();
                  if (remainList.isNotEmpty) {
                    loadingState.value = LoadingState.success(remainList);
                  } else {
                    onReload();
                  }
                  SmartDialog.showToast('取消收藏');
                  checkedCount.value = 0;
                  enableMultiSelect.value = false;
                } else {
                  SmartDialog.showToast(result['msg']);
                }
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  void toViewPlayAll() {
    if (loadingState.value is Success) {
      List<FavDetailItemData>? list = (loadingState.value as Success).response;
      if (list.isNullOrEmpty) return;

      for (FavDetailItemData element in list!) {
        if (element.cid == null) {
          continue;
        } else {
          if (element.bvid != list.first.bvid) {
            SmartDialog.showToast('已跳过不支持播放的视频');
          }
          PageUtils.toVideoPage(
            'bvid=${element.bvid}&cid=${element.cid}',
            arguments: {
              'videoItem': element,
              'heroTag': Utils.makeHeroTag(element.bvid),
              'sourceType': 'fav',
              'mediaId': item.value.id,
              'oid': element.id,
              'favTitle': item.value.title,
              'count': item.value.mediaCount,
              'desc': true,
              'isOwner': isOwner.value,
            },
          );
          break;
        }
      }
    }
  }

  @override
  Future onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
