import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/pages/fav_sort/view.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class FavDetailController
    extends MultiSelectController<FavDetailData, FavDetailItemModel> {
  late int mediaId;
  late String heroTag;
  final Rx<FavFolderInfo> folderInfo = FavFolderInfo().obs;
  final Rx<bool?> isOwner = Rx<bool?>(null);
  final Rx<FavOrderType> order = FavOrderType.mtime.obs;

  AccountService accountService = Get.find<AccountService>();

  @override
  void onInit() {
    super.onInit();

    mediaId = int.parse(Get.parameters['mediaId']!);
    heroTag = Get.parameters['heroTag']!;

    queryData();
  }

  @override
  bool? get hasFooter => true;

  @override
  List<FavDetailItemModel>? getDataList(FavDetailData response) {
    if (response.hasMore == false) {
      isEnd = true;
    }
    return response.medias;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= folderInfo.value.mediaCount) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success<FavDetailData> response) {
    if (isRefresh) {
      FavDetailData data = response.response;
      folderInfo.value = data.info!;
      isOwner.value = data.info?.mid == accountService.mid;
    }
    return false;
  }

  Future<void> onCancelFav(int index, int id, int type) async {
    var result = await FavHttp.favVideo(
      resources: '$id:$type',
      delIds: mediaId.toString(),
    );
    if (result['status']) {
      folderInfo
        ..value.mediaCount -= 1
        ..refresh();
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      SmartDialog.showToast('取消收藏');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  @override
  Future<LoadingState<FavDetailData>> customGetData() =>
      FavHttp.userFavFolderDetail(
        pn: page,
        ps: 20,
        mediaId: mediaId,
        order: order.value,
      );

  @override
  void onConfirm() {
    showConfirmDialog(
      context: Get.context!,
      content: '确认删除所选收藏吗？',
      title: '提示',
      onConfirm: () async {
        final checked = allChecked.toSet();
        var result = await FavHttp.favVideo(
          resources: checked.map((item) => '${item.id}:${item.type}').join(','),
          delIds: mediaId.toString(),
        );
        if (result['status']) {
          afterDelete(checked);
          folderInfo
            ..value.mediaCount -= checked.length
            ..refresh();
          SmartDialog.showToast('取消收藏');
        } else {
          SmartDialog.showToast(result['msg']);
        }
      },
    );
  }

  void toViewPlayAll() {
    if (loadingState.value.isSuccess) {
      List<FavDetailItemModel>? list = loadingState.value.data;
      if (list.isNullOrEmpty) return;

      for (FavDetailItemModel element in list!) {
        if (element.ugc?.firstCid == null) {
          continue;
        } else {
          if (element.bvid != list.first.bvid) {
            SmartDialog.showToast('已跳过不支持播放的视频');
          }
          final folderInfo = this.folderInfo.value;
          PageUtils.toVideoPage(
            'bvid=${element.bvid}&cid=${element.ugc!.firstCid}',
            arguments: {
              'videoItem': element,
              'heroTag': Utils.makeHeroTag(element.bvid),
              'sourceType': SourceType.fav,
              'mediaId': folderInfo.id,
              'oid': element.id,
              'favTitle': folderInfo.title,
              'count': folderInfo.mediaCount,
              'desc': true,
              'isOwner': isOwner.value ?? false,
            },
          );
          break;
        }
      }
    }
  }

  @override
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }

  Future<void> onFav(bool isFav) async {
    if (!accountService.isLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var res = isFav
        ? await FavHttp.unfavFavFolder(mediaId)
        : await FavHttp.favFavFolder(mediaId);

    if (res['status']) {
      folderInfo
        ..value.favState = isFav ? 0 : 1
        ..refresh();
    }
    SmartDialog.showToast(res['msg']);
  }

  Future<void> cleanFav() async {
    var res = await FavHttp.cleanFav(mediaId: mediaId);
    if (res['status']) {
      SmartDialog.showToast('清除成功');
      Future.delayed(const Duration(milliseconds: 200), onReload);
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  void onSort() {
    if (loadingState.value.isSuccess &&
        loadingState.value.data?.isNotEmpty == true) {
      if (folderInfo.value.mediaCount > 1000) {
        SmartDialog.showToast('内容太多啦！超过1000不支持排序');
        return;
      }
      Get.to(FavSortPage(favDetailController: this));
    }
  }
}
