import 'dart:async' show FutureOr, Timer;

import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/source_type.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/pages/video/controller.dart';
import 'package:PiliPlus/pages/video/introduction/ugc/widgets/triple_mixin.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/identity_key.dart';
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

  @override
  Object get actionResourceKey => (bvid, IdentityKey(Accounts.main));

  // 是否稍后再看
  final RxBool hasLater = false.obs;

  final Rx<List<VideoTagItem>?> videoTags = Rx<List<VideoTagItem>?>(null);

  final _actionGuard = AsyncOperationGuard();

  bool get isProcessing => _actionGuard.isProcessing;

  Future<void> handleAction(FutureOr Function() action) =>
      _actionGuard.run(() async {
        await action();
      });

  @override
  bool get isLogin => Accounts.main.isLogin;

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
  Future<void> onPayCoin(
    ActionResourceSnapshot resource,
    int coin,
    bool coinWithLike,
  ) async {
    if (!isCurrentActionResource(resource)) return;
    final targetBvid = bvid;
    final stat = getStat();
    if (stat == null) {
      return;
    }
    final res = await VideoHttp.coinVideo(
      bvid: targetBvid,
      multiply: coin,
      selectLike: coinWithLike ? 1 : 0,
      account: resource.account,
    );
    if (res.isSuccess && identical(Accounts.main, resource.account)) {
      GlobalData().afterCoin(coin);
    }
    if (!isCurrentActionResource(resource)) return;
    if (res.isSuccess) {
      SmartDialog.showToast('投币成功');
      coinNum.value += coin;
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
  Set? favIds;
  int? quickFavId;
  late final enableQuickFav = Pref.enableQuickFav;
  final Rx<FavFolderData> favFolderData = FavFolderData().obs;

  (Object, int) get getFavRidType;

  Future<LoadingState<FavFolderData>> queryVideoInFolder([
    ActionResourceSnapshot? resource,
  ]) async {
    resource ??= actionResourceSnapshot;
    if (!isCurrentActionResource(resource)) {
      return const Error('当前音视频已切换');
    }
    favIds = null;
    final (rid, type) = getFavRidType;
    final res = await FavHttp.videoInFolder(
      mid: resource.account.mid,
      rid: rid,
      type: type,
      account: resource.account,
    );
    if (!isCurrentActionResource(resource)) {
      return const Error('当前音视频已切换');
    }
    if (res case Success(:final response)) {
      favFolderData.value = response;
      favIds = response.list
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

  Future<void> actionFavVideo({
    bool isQuick = false,
    ActionResourceSnapshot? resource,
    VoidCallback? completeRoute,
  }) {
    resource ??= actionResourceSnapshot;
    final targetResource = resource;
    return runResourceAction(
      targetResource.key,
      ResourceAction.favorite,
      () => _actionFavVideo(
        targetResource,
        isQuick: isQuick,
        completeRoute: completeRoute,
      ),
    );
  }

  Future<void> _actionFavVideo(
    ActionResourceSnapshot resource, {
    required bool isQuick,
    VoidCallback? completeRoute,
  }) async {
    if (!isCurrentActionResource(resource)) {
      SmartDialog.showToast('当前音视频已切换');
      return;
    }
    final (rid, type) = getFavRidType;
    // 收藏至默认文件夹
    if (isQuick) {
      SmartDialog.showLoading(msg: '请求中');
      try {
        final res = await queryVideoInFolder(resource);
        if (res.isSuccess) {
          if (!isCurrentActionResource(resource)) return;
          final hasFav = this.hasFav.value;
          final result = hasFav
              ? await FavHttp.unfavAll(
                  rid: rid,
                  type: type,
                  account: resource.account,
                )
              : await FavHttp.favVideo(
                  resources: '$rid:$type',
                  addIds: favFolderId.toString(),
                  account: resource.account,
                );
          if (!isCurrentActionResource(resource)) return;
          if (result.isSuccess) {
            updateFavCount(hasFav ? -1 : 1);
            this.hasFav.value = !hasFav;
            SmartDialog.showToast('${hasFav ? '取消' : ''}收藏成功');
          } else {
            result.toast();
          }
        }
      } finally {
        SmartDialog.dismiss(status: SmartStatus.loading);
      }
      return;
    }

    List<int?> addMediaIdsNew = [];
    List<int?> delMediaIdsNew = [];
    try {
      for (final i in favFolderData.value.list!) {
        bool isFaved = favIds?.contains(i.id) == true;
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
      account: resource.account,
    );
    SmartDialog.dismiss(status: SmartStatus.loading);
    if (!isCurrentActionResource(resource)) return;
    if (result.isSuccess) {
      final newVal =
          addMediaIdsNew.isNotEmpty || favIds?.length != delMediaIdsNew.length;
      if (hasFav.value != newVal) {
        updateFavCount(newVal ? 1 : -1);
        hasFav.value = newVal;
      }
      completeRoute?.call();
      SmartDialog.showToast('${newVal ? '' : '取消'}收藏成功');
    } else {
      result.toast();
    }
  }
}
