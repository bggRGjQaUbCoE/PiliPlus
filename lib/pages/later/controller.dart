import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/download/download_video_info.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart'
    show CommonListController;
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/download_utils.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
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
  void toViewDel(
    BuildContext context,
    int index,
    int? aid,
  ) {
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
  LaterController(this.laterViewType);
  final LaterViewType laterViewType;

  late final mid = Accounts.main.mid;

  final RxBool asc = false.obs;

  final LaterBaseController baseCtr = Get.put(LaterBaseController());

  @override
  RxBool get enableMultiSelect => baseCtr.enableMultiSelect;

  @override
  RxInt get rxCount => baseCtr.checkedCount;

  @override
  Future<LoadingState<LaterData>> customGetData() => UserHttp.seeYouLater(
    page: page,
    viewed: laterViewType.type,
    asc: asc.value,
  );

  @override
  void onInit() {
    super.onInit();
    queryData();
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

  /// 将稍后再看项转换为可缓存信息，返回可缓存列表与不支持缓存的数量
  ({List<DownloadVideoInfo> items, int invalid}) toDownloadInfos(
    Iterable<LaterItemModel> list,
  ) {
    final items = <DownloadVideoInfo>[];
    var invalid = 0;
    for (final item in list) {
      final avid = item.aid;
      final cid = item.cid;
      // 番剧、课堂等 pgc 内容暂不支持缓存
      if (avid == null ||
          cid == null ||
          item.isPgc == true ||
          item.isPugv == true ||
          item.pgcLabel?.isNotEmpty == true) {
        invalid++;
        continue;
      }
      items.add(
        DownloadVideoInfo(
          avid: avid,
          bvid: item.bvid ?? IdUtils.av2bv(avid),
          cid: cid,
          title: item.title ?? '',
          cover: item.pic ?? '',
          duration: item.duration ?? 0,
          danmaku: item.stat?.danmaku ?? 0,
          ownerId: item.owner?.mid,
          ownerName: item.owner?.name,
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

  /// 缓存当前列表全部视频
  Future<void> onDownloadAll(BuildContext context) async {
    final total = baseCtr.counts[laterViewType.index];
    if (total <= 0) {
      SmartDialog.showToast('没有可缓存的内容');
      return;
    }
    final confirm = await showConfirmDialog(
      context: context,
      title: const Text('缓存全部'),
      content: Text('确定缓存「${laterViewType.title}」的全部 $total 个视频吗？'),
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
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
