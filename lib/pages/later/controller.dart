import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/later_view_type.dart';
import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/later/data.dart';
import 'package:PiliPlus/models_new/later/list.dart';
import 'package:PiliPlus/pages/common/common_list_controller.dart'
    show CommonListController;
import 'package:PiliPlus/pages/common/multi_select/base.dart';
import 'package:PiliPlus/pages/common/multi_select/multi_select_controller.dart';
import 'package:PiliPlus/pages/later/base_controller.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/extension/scroll_controller_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
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
  void toViewDel(BuildContext context, int index, int aid) {
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
              final res = await UserHttp.toViewDel(aids: aid);
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

  Future<void> cacheAll() async {
    if (baseCtr.isCachingAll.value) return;
    final account = Accounts.main;
    if (!account.isLogin) {
      SmartDialog.showToast('请先登录添加「稍后再看」视频的 B 站账号');
      return;
    }

    baseCtr.isCachingAll.value = true;
    try {
      final items = <LaterItemModel>[];
      for (var page = 1; ; page++) {
        if (Accounts.main.mid != account.mid) return;
        final data = (await UserHttp.seeYouLater(page: page)).data;
        final list = data.list;
        if (list == null || list.isEmpty) break;
        items.addAll(list);
        final count = data.count;
        if (count != null && items.length >= count) break;
        if (count == null && list.length < 20) break;
      }
      if (items.isEmpty) {
        SmartDialog.showToast('稍后再看列表为空');
        return;
      }

      final downloadService = Get.find<DownloadService>();
      await downloadService.waitForInitialization;
      final quality = VideoQuality.fromCode(Pref.defaultVideoQa);
      final audioQuality = AudioQuality.fromCode(Pref.defaultAudioQa);
      var added = 0;
      var unavailable = 0;
      for (final item in items) {
        if (Accounts.main.mid != account.mid) return;
        try {
          added += await _cacheItem(
            downloadService,
            item,
            quality,
            audioQuality,
          );
        } catch (_) {
          unavailable++;
        }
      }
      SmartDialog.showToast(
        '已安排 $added 个缓存任务'
        '${unavailable == 0 ? '' : '，$unavailable 项暂不可缓存'}。'
        '可在「离线缓存」查看进度',
      );
    } catch (_) {
      SmartDialog.showToast('读取稍后再看列表失败，请检查网络后重试');
    } finally {
      baseCtr.isCachingAll.value = false;
    }
  }

  Future<int> _cacheItem(
    DownloadService service,
    LaterItemModel item,
    VideoQuality quality,
    AudioQuality audioQuality,
  ) async {
    if (item.isPgc == true || item.isPugv == true || item.bangumi != null) {
      final redirect = RegExp(r'/(ep|ss)(\d+)(?:[/?#]|$)')
          .firstMatch(item.redirectUrl ?? '');
      final id = int.tryParse(redirect?.group(2) ?? '');
      final epId = item.bangumi?.epId ?? (redirect?.group(1) == 'ep' ? id : null);
      final seasonId = redirect?.group(1) == 'ss' ? id : null;
      final response = item.isPugv == true
          ? await SearchHttp.pugvInfo(
              seasonId: seasonId ?? (epId == null ? item.aid : null),
              epId: epId,
            )
          : await SearchHttp.pgcInfo(seasonId: seasonId, epId: epId);
      final data = response.data;
      final episodes = [
        ...?data.episodes,
        for (final section in data.sections ?? []) ...?section.episodes,
      ];
      var index = epId != null
          ? episodes.indexWhere((e) => e.epId == epId || e.id == epId)
          : episodes.indexWhere((e) => item.cid != null && e.cid == item.cid);
      if (index < 0 && epId == null && item.cid == null) {
        final (episode, _) = data.findEpisode();
        if (episode != null) index = episodes.indexOf(episode);
      }
      if (index < 0) throw StateError('Missing watch-later episode');
      final added = await service.downloadBangumi(
        index: index,
        pgcItem: data,
        episode: episodes[index],
        quality: quality,
        audioQuality: audioQuality,
        forceCachePlayInfo: true,
      );
      return added ? 1 : 0;
    }

    final bvid = item.bvid;
    final aid = item.aid;
    final detail = (await VideoHttp.videoIntro(
      bvid: bvid != null && bvid.isNotEmpty ? bvid : IdUtils.av2bv(aid!),
    )).data;
    final parts = detail.pages;
    if (parts == null || parts.isEmpty) throw StateError('Missing video parts');
    var added = 0;
    for (final part in parts) {
      if (await service.downloadVideo(
        page: part,
        videoDetail: detail,
        videoQuality: quality,
        audioQuality: audioQuality,
        forceCachePlayInfo: true,
      )) {
        added++;
      }
    }
    return added;
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
  Future<void> onReload() {
    scrollController.jumpToTop();
    return super.onReload();
  }
}
