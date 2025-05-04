import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/model_hot_video_item.dart';
import 'package:PiliPlus/pages/common/multi_select_controller.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/pages/later/view.dart'
    show LaterViewType, LaterViewTypeExt;
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class LaterController extends MultiSelectController<Map, HotVideoItemModel> {
  LaterController(this.laterViewType);
  final LaterViewType laterViewType;

  dynamic mid;
  final RxBool asc = false.obs;

  final LaterBaseController baseCtr = Get.put(LaterBaseController());

  @override
  Future<LoadingState<Map>> customGetData() => UserHttp.seeYouLater(
        page: currentPage,
        viewed: laterViewType.type,
        asc: asc.value,
      );

  @override
  void onSelect(int index, [bool disableSelect = true]) {
    List<HotVideoItemModel> list = (loadingState.value as Success).response;
    list[index].checked = !(list[index].checked ?? false);
    baseCtr.checkedCount.value =
        list.where((item) => item.checked == true).length;
    loadingState.refresh();
    if (baseCtr.checkedCount.value == 0) {
      baseCtr.enableMultiSelect.value = false;
    }
  }

  @override
  void handleSelect([bool checked = false, bool disableSelect = true]) {
    if (loadingState.value is Success) {
      List<HotVideoItemModel>? list = (loadingState.value as Success).response;
      if (list?.isNotEmpty == true) {
        for (HotVideoItemModel item in list!) {
          item.checked = checked;
        }
        baseCtr.checkedCount.value = checked ? list.length : 0;
        loadingState.refresh();
      }
    }
    if (checked.not) {
      baseCtr.enableMultiSelect.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    mid = Accounts.main.mid;
    queryData();
  }

  @override
  List<HotVideoItemModel>? getDataList(response) {
    return response['list'];
  }

  @override
  void checkIsEnd(int length) {
    if (length >= baseCtr.counts[laterViewType]!) {
      isEnd = true;
    }
  }

  @override
  bool customHandleResponse(bool isRefresh, Success response) {
    baseCtr.counts[laterViewType] = response.response['count'];
    return false;
  }

  // single
  Future toViewDel(BuildContext context, int index, int? aid) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('即将移除该视频，确定是否移除'),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                var res = await UserHttp.toViewDel(aids: [aid]);
                if (res['status']) {
                  loadingState.value.data!.removeAt(index);
                  baseCtr.counts[laterViewType] =
                      baseCtr.counts[laterViewType]! - 1;
                  loadingState.refresh();
                }
                SmartDialog.showToast(res['msg']);
              },
              child: const Text('确认移除'),
            )
          ],
        );
      },
    );
  }

  // 一键清空
  void toViewClear(BuildContext context, [int? cleanType]) {
    String content = switch (cleanType) {
      1 => '确定清空已失效视频吗？',
      2 => '确定清空已看完视频吗？',
      _ => '确定清空稍后再看列表吗？',
    };
    showConfirmDialog(
      context: context,
      title: '确认',
      content: content,
      onConfirm: () async {
        var res = await UserHttp.toViewClear(cleanType);
        if (res['status']) {
          onReload();
          final restTypes = List<LaterViewType>.from(LaterViewType.values)
            ..remove(laterViewType);
          for (final item in restTypes) {
            try {
              Get.find<LaterController>(tag: item.type.toString()).onReload();
            } catch (_) {}
          }
        }
        SmartDialog.showToast(res['msg']);
      },
    );
  }

  void onDelChecked(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认删除所选稍后再看吗？'),
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
                _onDelete(((loadingState.value as Success).response
                        as List<HotVideoItemModel>)
                    .where((e) => e.checked == true)
                    .toList());
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  Future<void> _onDelete(List<HotVideoItemModel> result) async {
    SmartDialog.showLoading(msg: '请求中');
    List<int?> aids = result.map((item) => item.aid).toList();
    dynamic res = await UserHttp.toViewDel(aids: aids);
    if (res['status']) {
      Set<HotVideoItemModel> remainList =
          ((loadingState.value as Success).response as List<HotVideoItemModel>)
              .toSet()
              .difference(result.toSet());
      baseCtr.counts[laterViewType] =
          baseCtr.counts[laterViewType]! - aids.length;
      loadingState.value = LoadingState.success(remainList.toList());
      if (baseCtr.enableMultiSelect.value) {
        baseCtr.checkedCount.value = 0;
        baseCtr.enableMultiSelect.value = false;
      }
    }
    SmartDialog.dismiss();
    SmartDialog.showToast(res['msg']);
  }

  // 稍后再看播放全部
  void toViewPlayAll() {
    if (loadingState.value is Success) {
      List<HotVideoItemModel>? list = (loadingState.value as Success).response;
      if (list.isNullOrEmpty) return;

      for (HotVideoItemModel item in list!) {
        if (item.cid == null || item.pgcLabel?.isNotEmpty == true) {
          continue;
        } else {
          if (item.bvid != list.first.bvid) {
            SmartDialog.showToast('已跳过不支持播放的视频');
          }
          PageUtils.toVideoPage(
            'bvid=${item.bvid}&cid=${item.cid}',
            arguments: {
              'videoItem': item,
              'heroTag': Utils.makeHeroTag(item.bvid),
              'sourceType': 'watchLater',
              'count': baseCtr.counts[LaterViewType.all],
              'favTitle': '稍后再看',
              'mediaId': mid,
              'desc': false,
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
