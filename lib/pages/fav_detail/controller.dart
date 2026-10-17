import 'dart:async';

import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/download/download_video_info.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/data.dart';
import 'package:PiliPlus/models_new/fav/fav_detail/media.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart';
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/common/page_order_mixin.dart';
import 'package:PiliPlus/pages/fav_sort/view.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/download_utils.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/widgets.dart' show BuildContext, Text, ValueChanged;
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
    final res = await FavHttp.favVideo(
      resources: '$id:$type',
      delIds: mediaId.toString(),
    );
    if (res.isSuccess) {
      loadingState
        ..value.data!.removeAt(index)
        ..refresh();
      updateCount?.call(1);
      SmartDialog.showToast('取消收藏');
    } else {
      res.toast();
    }
  }

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: const Text('提示'),
      content: const Text('确认删除所选收藏吗？'),
      onConfirm: () async {
        final removeList = allChecked.toSet();
        final res = await FavHttp.favVideo(
          resources: removeList
              .map((item) => '${item.id}:${item.type}')
              .join(','),
          delIds: mediaId.toString(),
        );
        if (res.isSuccess) {
          updateCount?.call(removeList.length);
          afterDelete(removeList);
          SmartDialog.showToast('取消收藏');
        } else {
          res.toast();
        }
      },
    );
  }
}

class FavDetailController
    extends MultiSelectController<FavDetailData, FavDetailItemModel>
    with BaseFavController, PageOrderMixin {
  @override
  late int mediaId;
  late String heroTag;
  final Rx<FavFolderInfo> folderInfo = FavFolderInfo().obs;
  final RxBool _isOwner = false.obs;
  final Rx<FavOrderType> order = FavOrderType.mtime.obs;

  @override
  bool get isOwner => _isOwner.value;

  late final account = Accounts.main;

  late double dx = 0;
  late final RxBool isPlayAll = Pref.enablePlayAll.obs;

  void setIsPlayAll(bool isPlayAll) {
    if (this.isPlayAll.value == isPlayAll) return;
    this.isPlayAll.value = isPlayAll;
    GStorage.setting.put(SettingBoxKey.enablePlayAll, isPlayAll);
  }

  @override
  int get count => folderInfo.value.mediaCount;

  @override
  int get ps => _ps;

  static const _ps = 20;

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
    if (pageDesc) {
      if (page == 1) {
        isEnd = true;
      }
    } else if (response.hasMore == false) {
      isEnd = true;
    }
    if (pageDesc) {
      return response.medias?.reversed.toList();
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
        ps: _ps,
        mediaId: mediaId,
        order: order.value,
      );

  void toViewPlayAll() {
    if (loadingState.value case Success(:final response)) {
      if (response == null || response.isEmpty) return;

      for (FavDetailItemModel element in response) {
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
    final res = isFav
        ? await FavHttp.unfavFavFolder(mediaId)
        : await FavHttp.favFavFolder(mediaId);

    if (res.isSuccess) {
      folderInfo
        ..value.favState = isFav ? 0 : 1
        ..refresh();
      SmartDialog.showToast('${isFav ? '取消' : ''}收藏成功');
    } else {
      res.toast();
    }
  }

  Future<void> cleanFav() async {
    final res = await FavHttp.cleanFav(mediaId: mediaId);
    if (res.isSuccess) {
      SmartDialog.showToast('清除成功');
      Timer(const Duration(milliseconds: 200), onReload);
    } else {
      res.toast();
    }
  }

  void onSort() {
    if (loadingState.value case Success(:final response)) {
      if (response != null && response.isNotEmpty) {
        if (folderInfo.value.mediaCount > 1000) {
          SmartDialog.showToast('内容太多啦！超过1000不支持排序');
          return;
        }
        Get.to(FavSortPage(favDetailController: this));
      }
    }
  }

  /// 将收藏项转换为可缓存信息，返回可缓存列表与不支持缓存的数量
  ({List<DownloadVideoInfo> items, int invalid}) toDownloadInfos(
    Iterable<FavDetailItemModel> list,
  ) {
    final items = <DownloadVideoInfo>[];
    var invalid = 0;
    for (final item in list) {
      final avid = item.id;
      final cid = item.ugc?.firstCid;
      // attr 为 1/9 表示稿件已失效，音频/番剧等无 ugc 的内容暂不支持缓存
      if (avid == null || cid == null || item.attr == 1 || item.attr == 9) {
        invalid++;
        continue;
      }
      items.add(
        DownloadVideoInfo(
          avid: avid,
          bvid: item.bvid ?? IdUtils.av2bv(avid),
          cid: cid,
          title: item.title ?? '',
          cover: item.cover ?? '',
          duration: item.duration ?? 0,
          danmaku: item.cntInfo?.danmaku ?? 0,
          ownerId: item.upper?.mid,
          ownerName: item.upper?.name,
        ),
      );
    }
    return (items: items, invalid: invalid);
  }

  /// 缓存所选视频
  Future<void> onBatchDownload(BuildContext context) async {
    final checked = allChecked.toList();
    if (checked.isEmpty) {
      SmartDialog.showToast('请先选择要缓存的内容');
      return;
    }
    final res = toDownloadInfos(checked);
    await DownloadUtils.batchDownload(
      context: context,
      items: res.items,
      invalidCount: res.invalid,
    );
  }

  /// 缓存收藏夹全部视频
  Future<void> onDownloadAll(BuildContext context) async {
    if (count <= 0) {
      SmartDialog.showToast('没有可缓存的内容');
      return;
    }
    final confirm = await showConfirmDialog(
      context: context,
      title: const Text('缓存全部'),
      content: Text('确定缓存该收藏夹的全部 $count 个视频吗？'),
    );
    if (!confirm) {
      return;
    }
    await _loadAllPages();
    if (!context.mounted) {
      return;
    }
    if (loadingState.value case Success(:final response?)) {
      final res = toDownloadInfos(response);
      await DownloadUtils.batchDownload(
        context: context,
        items: res.items,
        invalidCount: res.invalid,
      );
    }
  }

  /// 逐页加载直到全部加载完成
  Future<void> _loadAllPages() async {
    if (isEnd || isLoading) {
      return;
    }
    SmartDialog.showLoading(msg: '正在加载列表');
    try {
      var guard = 0;
      while (!isEnd && guard++ < 500) {
        final length = loadingState.value.dataOrNull?.length ?? 0;
        await queryData(false);
        // 没有加载到新内容时结束，避免死循环
        if ((loadingState.value.dataOrNull?.length ?? 0) == length) {
          break;
        }
      }
    } catch (_) {
      // 加载失败时使用已加载的内容
    } finally {
      SmartDialog.dismiss();
    }
  }

  @override
  void onViewFav(FavDetailItemModel item, int? index) {
    final folder = folderInfo.value;
    // TODO: dimension
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
              'desc': !pageDesc,
              if (index != null) 'isContinuePlaying': index != 0,
              'isOwner': isOwner,
            }
          : null,
    );
  }
}
