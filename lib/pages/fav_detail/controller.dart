import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/fav_sort/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/iterable_ext.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/services.dart' show ValueChanged;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

mixin BaseFavController
    on
        CommonListController<FavDetailData, FavDetailItemModel>,
        DeleteItemMixin<FavDetailData, FavDetailItemModel> {
  bool get isOwner;
  int get mediaId;

  ValueChanged<int>? updateCount;

  void onViewFav(FavDetailItemModel item, int? index);

  Future<void> onCancelFav(int index, int id, int type) async {
    var result = await FavHttp.favVideo(
      resources: '$id:$type',
      delIds: mediaId.toString(),
    );
    if (result.isSuccess) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      updateCount?.call(1);
      SmartDialog.showToast('取消收藏');
    } else {
      result.toast();
    }
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      content: '确认删除所选收藏吗？',
      title: '提示',
      onConfirm: () async {
        final removeList = allChecked.toSet();
        var result = await FavHttp.favVideo(
          resources: removeList
              .map((item) => '${item.id}:${item.type}')
              .join(','),
          delIds: mediaId.toString(),
        );
        if (result.isSuccess) {
          updateCount?.call(removeList.length);
          afterDelete(removeList);
          SmartDialog.showToast('取消收藏');
        } else {
          result.toast();
        }
      },
    );
  }
}

class FavDetailController
    extends MultiSelectController<FavDetailData, FavDetailItemModel>
    with BaseFavController {
  @override
  late int mediaId;
  late String heroTag;
  final Rx<FavFolderInfo> folderInfo = FavFolderInfo().obs;
  final Rx<bool?> _isOwner = Rx<bool?>(null);
  final Rx<FavOrderType> order = FavOrderType.mtime.obs;

  @override
  bool get isOwner => _isOwner.value ?? false;

  late final account = Accounts.main;

  late double dx = 0;
  late final RxBool isPlayAll = Pref.enablePlayAll.obs;

  void setIsPlayAll(bool isPlayAll) {
    if (this.isPlayAll.value == isPlayAll) return;
    this.isPlayAll.value = isPlayAll;
    GStorage.setting.put(SettingBoxKey.enablePlayAll, isPlayAll);
  }

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
      _isOwner.value = data.info?.mid == account.mid;
    }
    return false;
  }

  @override
  ValueChanged<int>? get updateCount =>
      (count) => folderInfo
        ..value.mediaCount -= count
        ..refresh();

  @override
  Future<LoadingState<FavDetailData>> customGetData() =>
      FavHttp.userFavFolderDetail(
        pn: page,
        ps: 20,
        mediaId: mediaId,
        order: order.value,
      );

  void toViewPlayAll() {
    if (loadingState.value.isSuccess) {
      List<FavDetailItemModel>? list = loadingState.value.data;
      if (list.isNullOrEmpty) return;

      for (FavDetailItemModel element in list!) {
        if (element.ugc?.firstCid == null) {
          continue;
        } else {
          onViewFav(element, null);
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
    if (!account.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var res = isFav
        ? await FavHttp.unfavFavFolder(mediaId)
        : await FavHttp.favFavFolder(mediaId);

    if (res.isSuccess) {
      folderInfo
        ..value.favState = isFav ? 0 : 1
        ..refresh();
    }
    res.toast();
  }

  Future<void> cleanFav() async {
    var res = await FavHttp.cleanFav(mediaId: mediaId);
    if (res.isSuccess) {
      SmartDialog.showToast('清除成功');
      Future.delayed(const Duration(milliseconds: 200), onReload);
    } else {
      res.toast();
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

  @override
  void onViewFav(FavDetailItemModel item, int? index) {
    final folder = folderInfo.value;
    PageUtils.toVideoPage(
      bvid: item.bvid,
      cid: item.ugc!.firstCid!,
      cover: item.cover,
      title: item.title,
      extraArguments: isPlayAll.value
          ? {
              'sourceType': SourceType.fav,
              'mediaId': folder.id,
              'oid': item.id,
              'favTitle': folder.title,
              'count': folder.mediaCount,
              'desc': true,
              if (index != null) 'isContinuePlaying': index != 0,
              'isOwner': isOwner,
            }
          : null,
    );
  }
}
