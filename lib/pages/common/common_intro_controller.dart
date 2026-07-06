import 'dart:async' show FutureOr, Timer;

import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/quick_fav_item.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/list.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/bili_utils.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract class CommonIntroController extends GetxController
    with GetSingleTickerProviderStateMixin, TripleMixin, FavMixin {
  late final String heroTag;
  late String bvid;

  // 是否稍后再看
  final RxBool hasLater = false.obs;

  final Rx<List<VideoTagItem>?> videoTags = Rx<List<VideoTagItem>?>(null);

  bool isProcessing = false;
  Future<void> handleAction(FutureOr Function() action) async {
    if (!isProcessing) {
      isProcessing = true;
      await action();
      isProcessing = false;
    }
  }

  @override
  late final isLogin = Accounts.main.isLogin;

  StatDetail? getStat();

  @override
  void updateFavCount(int count) {
    getStat()?.favorite += count;
  }

  final Rx<VideoDetailData> videoDetail = VideoDetailData().obs;

  void queryVideoIntro();

  bool prevPlay();
  bool nextPlay();

  void actionShareVideo(BuildContext context);

  // 同时观看
  final bool isShowOnlineTotal = Pref.enableOnlineTotal;
  late final RxString total = '1'.obs;
  Timer? timer;

  late final RxInt cid;

  late final videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    heroTag = args['heroTag'];
    bvid = args['bvid'];
    cid = RxInt(args['cid']);
    hasLater.value = args['sourceType'] == SourceType.watchLater;

    queryVideoIntro();
    startTimer();
  }

  void startTimer() {
    if (isShowOnlineTotal) {
      queryOnlineTotal();
      timer ??= Timer.periodic(const Duration(seconds: 10), (Timer timer) {
        queryOnlineTotal();
      });
    }
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  // 查看同时在看人数
  Future<void> queryOnlineTotal() async {
    if (!isShowOnlineTotal) {
      return;
    }
    final result = await VideoHttp.onlineTotal(
      aid: IdUtils.bv2av(bvid),
      bvid: bvid,
      cid: cid.value,
    );
    if (result case Success(:final response)) {
      total.value = response;
    }
  }

  @override
  void onClose() {
    cancelTimer();
    super.onClose();
  }

  @override
  Future<void> onPayCoin(int coin, bool coinWithLike) async {
    final stat = getStat();
    if (stat == null) {
      return;
    }
    final res = await VideoHttp.coinVideo(
      bvid: bvid,
      multiply: coin,
      selectLike: coinWithLike ? 1 : 0,
    );
    if (res.isSuccess) {
      SmartDialog.showToast('投币成功');
      coinNum.value += coin;
      GlobalData().afterCoin(coin);
      stat.coin += coin;
      if (coinWithLike && !hasLike.value) {
        stat.like++;
        hasLike.value = true;
      }
    } else {
      res.toast();
    }
  }

  Future<void> queryVideoTags() async {
    final result = await UserHttp.videoTags(bvid: bvid, cid: cid.value);
    videoTags.value = result.dataOrNull;
  }

  Future<void> viewLater() async {
    final res = await (hasLater.value
        ? UserHttp.toViewDel(aids: IdUtils.bv2av(bvid).toString())
        : UserHttp.toViewLater(bvid: bvid));
    if (res.isSuccess) hasLater.value = !hasLater.value;
  }
}

mixin FavMixin on TripleMixin {
  static const int kMaxFavShortcutCount = 6;

  final Rx<Set<int>?> favIds = Rx<Set<int>?>(null);
  int? quickFavId;
  late final enableQuickFav = Pref.enableQuickFav;
  final Rx<FavFolderData> favFolderData = FavFolderData().obs;
  final RxList<QuickFavItem> favShortcutList = <QuickFavItem>[].obs;

  (Object, int) get getFavRidType;

  Future<LoadingState<FavFolderData>> queryVideoInFolder() async {
    favIds.value = null;
    final (rid, type) = getFavRidType;
    final res = await FavHttp.videoInFolder(
      mid: Accounts.main.mid,
      rid: rid,
      type: type,
    );
    if (res case Success(:final response)) {
      favFolderData.value = response;
      favIds.value = response.list
          ?.where((item) => item.favState == 1)
          .map((item) => item.id)
          .toSet();
    }
    return res;
  }

  int get favFolderId {
    if (this.quickFavId != null) {
      return this.quickFavId!;
    }
    final quickFavId = Pref.quickFavId;
    final list = favFolderData.value.list!;
    if (quickFavId != null) {
      final folderInfo = list.firstWhereOrNull((e) => e.id == quickFavId);
      if (folderInfo != null) {
        return this.quickFavId = quickFavId;
      } else {
        GStorage.setting.delete(SettingBoxKey.quickFavId);
      }
    }
    return this.quickFavId = list.first.id;
  }

  // 快捷收藏夹
  void loadFavShortcutList() {
    favShortcutList.value = Pref.favShortcutList;
    if (Pref.enableFavShortcutRow &&
        favShortcutList.isNotEmpty &&
        Accounts.main.isLogin) {
      queryVideoInFolder();
    }
  }

  void saveFavShortcutList() {
    GStorage.setting.put(
      SettingBoxKey.favShortcutList,
      favShortcutList.map((e) => e.toJson()).toList(),
    );
  }

  void addFavShortcut(FavFolderInfo folder) {
    if (favShortcutList.any((e) => e.id == folder.id)) {
      SmartDialog.showToast('该收藏夹已存在');
      return;
    }
    if (favShortcutList.length >= kMaxFavShortcutCount) {
      SmartDialog.showToast('最多只能添加$kMaxFavShortcutCount个快捷收藏夹');
      return;
    }
    favShortcutList.add(QuickFavItem(id: folder.id, title: folder.title));
    saveFavShortcutList();
  }

  void removeFavShortcut(int id) {
    favShortcutList.removeWhere((e) => e.id == id);
    saveFavShortcutList();
  }

  Future<void> showFavShortcutSelector(BuildContext context) async {
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final res = await FavHttp.allFavFolders(Accounts.main.mid);
    if (res case Success(:final response)) {
      final list = response.list;
      if (list == null || list.isEmpty) {
        SmartDialog.showToast('暂无收藏夹');
        return;
      }
      final existingIds = favShortcutList.map((e) => e.id).toSet();
      final available =
          list.where((e) => !existingIds.contains(e.id)).toList();
      if (available.isEmpty) {
        SmartDialog.showToast('已添加全部收藏夹或达到上限');
        return;
      }
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          clipBehavior: Clip.hardEdge,
          title: const Text('选择收藏夹'),
          contentPadding: const EdgeInsets.only(top: 5, bottom: 18),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: available
                  .map(
                    (item) => ListTile(
                      dense: true,
                      title: Text(item.title),
                      leading: BiliUtils.isPublicFav(item.attr)
                          ? const Icon(Icons.folder_outlined)
                          : const Icon(Icons.lock_outline),
                      onTap: () {
                        Get.back();
                        addFavShortcut(item);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
    } else {
      res.toast();
    }
  }

  Future<void> toggleFavShortcut(int folderId) async {
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final (rid, type) = getFavRidType;
    favIds.value ??= {};
    final isFaved = favIds.value!.contains(folderId);
    SmartDialog.showLoading(msg: '请求中');
    final result = await FavHttp.favVideo(
      resources: '$rid:$type',
      addIds: isFaved ? '' : folderId.toString(),
      delIds: isFaved ? folderId.toString() : '',
    );
    SmartDialog.dismiss();
    if (result.isSuccess) {
      if (isFaved) {
        favIds.value = Set<int>.from(favIds.value!)..remove(folderId);
      } else {
        favIds.value = Set<int>.from(favIds.value!)..add(folderId);
      }
      final newVal = favIds.value!.isNotEmpty;
      if (hasFav.value != newVal) {
        updateFavCount(newVal ? 1 : -1);
        hasFav.value = newVal;
      }
      SmartDialog.showToast('${isFaved ? '取消' : ''}收藏成功');
    } else {
      result.toast();
    }
  }

  // 收藏
  void showFavBottomSheet(BuildContext context, {bool isLongPress = false}) {
    if (!Accounts.main.isLogin) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    // 快速收藏 &
    // 点按 收藏至默认文件夹
    // 长按选择文件夹
    if (enableQuickFav) {
      if (!isLongPress) {
        actionFavVideo(isQuick: true);
      } else {
        PageUtils.showFavBottomSheet(context: context, ctr: this);
      }
    } else if (!isLongPress) {
      PageUtils.showFavBottomSheet(context: context, ctr: this);
    }
  }

  void updateFavCount(int count);

  Future<void> actionFavVideo({bool isQuick = false}) async {
    final (rid, type) = getFavRidType;
    // 收藏至默认文件夹
    if (isQuick) {
      SmartDialog.showLoading(msg: '请求中');
      queryVideoInFolder().then((res) async {
        if (res.isSuccess) {
          final hasFav = this.hasFav.value;
          final result = hasFav
              ? await FavHttp.unfavAll(rid: rid, type: type)
              : await FavHttp.favVideo(
                  resources: '$rid:$type',
                  addIds: favFolderId.toString(),
                );
          SmartDialog.dismiss();
          if (result.isSuccess) {
            updateFavCount(hasFav ? -1 : 1);
            this.hasFav.value = !hasFav;
            SmartDialog.showToast('${hasFav ? '取消' : ''}收藏成功');
          } else {
            res.toast();
          }
        } else {
          SmartDialog.dismiss();
        }
      });
      return;
    }

    List<int?> addMediaIdsNew = [];
    List<int?> delMediaIdsNew = [];
    try {
      for (final i in favFolderData.value.list!) {
        bool isFaved = favIds.value?.contains(i.id) == true;
        if (i.favState == 1) {
          if (!isFaved) {
            addMediaIdsNew.add(i.id);
          }
        } else {
          if (isFaved) {
            delMediaIdsNew.add(i.id);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
    }
    SmartDialog.showLoading(msg: '请求中');
    final result = await FavHttp.favVideo(
      resources: '$rid:$type',
      addIds: addMediaIdsNew.join(','),
      delIds: delMediaIdsNew.join(','),
    );
    SmartDialog.dismiss();
    if (result.isSuccess) {
      Get.back();
      final newVal =
          addMediaIdsNew.isNotEmpty || favIds.value?.length != delMediaIdsNew.length;
      if (hasFav.value != newVal) {
        updateFavCount(newVal ? 1 : -1);
        hasFav.value = newVal;
      }
      SmartDialog.showToast('${newVal ? '' : '取消'}收藏成功');
    } else {
      result.toast();
    }
  }
}
