import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart'
    show CommonListController;
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

mixin BaseLaterController
    on
        CommonListController<LaterData, LaterItemModel>,
        CommonMultiSelectMixin<LaterItemModel>,
        DeleteItemMixin<LaterData, LaterItemModel> {
  ValueChanged<int>? updateCount;

  @override
  void onRemove() {
    showConfirmDialog(
      context: Get.context!,
      title: const Text('提示'),
      content: const Text('确认删除所选稍后再看吗？'),
      onConfirm: () async {
        final removeList = allChecked.toSet();
        SmartDialog.showLoading(msg: '请求中');
        final res = await UserHttp.toViewDel(
          aids: removeList.map((item) => item.aid).join(','),
        );
        if (res.isSuccess) {
          updateCount?.call(removeList.length);
          afterDelete(removeList);
        }
        SmartDialog.dismiss();
      },
    );
  }

  // single
  void toViewDel(BuildContext context, int index, int? aid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              final res = await UserHttp.toViewDel(aids: aid.toString());
              if (res.isSuccess) {
                loadingState
                  ..value.data!.removeAt(index)
                  ..refresh();
                updateCount?.call(1);
              }
            },
            child: const Text('确认移除'),
          ),
        ],
      ),
    );
  }
}

class LaterController extends MultiSelectController<LaterData, LaterItemModel>
    with BaseLaterController {
  LaterController(this.laterViewType) {
    _refreshedVersion = baseCtr.changeVersion;
  }
  final LaterViewType laterViewType;

  late int _refreshedVersion;
  Future<void>? _queryFuture;
  Future<void>? _changeRefreshFuture;

  late final mid = Accounts.main.mid;

  final RxBool asc = false.obs;

  final LaterBaseController baseCtr = Get.put(LaterBaseController());

  @override
  RxBool get enableMultiSelect => baseCtr.enableMultiSelect;

  @override
  RxInt get rxCount => baseCtr.checkedCount;

  @override
  Future<LoadingState<LaterData>> customGetData() => fetchLaterPage(page);

  Future<LoadingState<LaterData>> fetchLaterPage(int page) =>
      UserHttp.seeYouLater(
        page: page,
        viewed: laterViewType.type,
        asc: asc.value,
      );

  @override
  void onInit() {
    super.onInit();
    baseCtr.registerRefresh(laterViewType, refreshAfterChange);
    queryData();
  }

  @override
  void onClose() {
    baseCtr.unregisterRefresh(laterViewType, refreshAfterChange);
    super.onClose();
  }

  @override
  Future<void> queryData([bool isRefresh = true]) {
    if (isClosed || _changeRefreshFuture != null) return Future.value();
    return _queryFuture ??= _queryData(isRefresh).whenComplete(() {
      _queryFuture = null;
    });
  }

  Future<void> _queryData(bool isRefresh) async {
    final version = baseCtr.changeVersion;
    try {
      await super.queryData(isRefresh);
      if (!isClosed && isRefresh && loadingState.value.isSuccess) {
        _refreshedVersion = version;
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> onRefresh() {
    // Do not reset the page of an in-flight pagination request.
    if (_changeRefreshFuture case final future?) return future;
    if (_queryFuture case final future?) return future;
    return super.onRefresh();
  }

  Future<void> refreshAfterChange() {
    if (isClosed || _refreshedVersion == baseCtr.changeVersion) {
      return Future.value();
    }
    return _changeRefreshFuture ??= _refreshChangedData().whenComplete(() {
      _changeRefreshFuture = null;
    });
  }

  Future<void> _refreshChangedData() async {
    try {
      await _queryFuture;
      refresh:
      while (!isClosed && _refreshedVersion != baseCtr.changeVersion) {
        final version = baseCtr.changeVersion;
        final ascending = asc.value;
        final pagesToRefresh = page > 1 ? page - 1 : 1;
        final items = <LaterItemModel>[];
        int count = 0;
        int nextPage = 1;
        bool end = false;
        isLoading = true;

        // Keep the old list on screen until all previously loaded pages are
        // rebuilt. This also avoids skipping an item after a deletion shifts
        // the boundaries between server pages.
        for (int pn = 1; pn <= pagesToRefresh; pn++) {
          final res = await fetchLaterPage(pn);
          if (isClosed) return;
          if (res case Success(:final response)) {
            count = response.count ?? 0;
            items.addAll(response.list ?? const []);
            nextPage = pn + 1;
            end = response.list?.isNotEmpty != true || items.length >= count;
            if (end) break;
          } else {
            if (version != baseCtr.changeVersion) continue refresh;
            // Leave this version dirty so a later return can retry.
            return;
          }
        }

        // Another mutation may have completed while these pages were fetched.
        // Only publish a snapshot that was fetched for the current version.
        if (version != baseCtr.changeVersion || ascending != asc.value) {
          continue;
        }
        baseCtr.counts[laterViewType.index] = count;
        page = nextPage;
        isEnd = end;
        loadingState.value = Success(items);
        _refreshedVersion = version;
      }
    } catch (e) {
      debugPrint('later refresh after change: $e');
    } finally {
      isLoading = false;
    }
  }

  @override
  List<LaterItemModel>? getDataList(response) {
    baseCtr.counts[laterViewType.index] = response.count ?? 0;
    return response.list;
  }

  @override
  void checkIsEnd(int length) {
    if (length >= baseCtr.counts[laterViewType.index]) {
      isEnd = true;
    }
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
      title: const Text('确认'),
      content: Text(content),
      onConfirm: () async {
        final res = await UserHttp.toViewClear(cleanType);
        if (res.isSuccess) {
          onReload();
          final restTypes = List<LaterViewType>.from(LaterViewType.values)
            ..remove(laterViewType);
          for (final item in restTypes) {
            try {
              Get.find<LaterController>(tag: item.type.toString()).onReload();
            } catch (_) {}
          }
          SmartDialog.showToast('已清空');
        } else {
          res.toast();
        }
      },
    );
  }

  // 稍后再看播放全部
  void toViewPlayAll() {
    if (loadingState.value case Success(:final response)) {
      if (response == null || response.isEmpty) return;

      for (LaterItemModel item in response) {
        if (item.cid == null || item.pgcLabel?.isNotEmpty == true) {
          continue;
        } else {
          PageUtils.toVideoPage(
            bvid: item.bvid,
            cid: item.cid!,
            cover: item.pic,
            title: item.title,
            dimension: item.dimension,
            extraArguments: {
              'sourceType': SourceType.watchLater,
              'count': baseCtr.counts[LaterViewType.all.index],
              'favTitle': '稍后再看',
              'mediaId': mid,
              'desc': asc.value,
            },
          );
          break;
        }
      }
    }
  }

  @override
  ValueChanged<int>? get updateCount =>
      (count) => baseCtr.counts[laterViewType.index] -= count;

  @override
  Future<void> onReload() async {
    await (_changeRefreshFuture ?? _queryFuture);
    if (isClosed) return;
    scrollController.jumpToTop();
    await super.onReload();
  }
}
