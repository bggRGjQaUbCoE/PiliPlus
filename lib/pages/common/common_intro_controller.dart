import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/user.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models_new/fav/fav_folder/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/models_new/video/video_tag/data.dart';
import 'package:PiliPlus/services/account_service.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/page_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract class CommonIntroController extends GetxController {
  String bvid = Get.parameters['bvid']!;

  // 是否点赞
  final RxBool hasLike = false.obs;
  // 投币数量
  final RxNum coinNum = RxNum(0);
  // 是否投币
  bool get hasCoin => coinNum.value != 0;
  // 是否收藏
  final RxBool hasFav = false.obs;

  final Rx<List<VideoTagItem>?> videoTags = Rx<List<VideoTagItem>?>(null);

  Set? favIds;
  final Rx<FavFolderData> favFolderData = FavFolderData().obs;

  AccountService accountService = Get.find<AccountService>();

  (Object, int) getFavRidType();

  StatDetail? getStat();

  Future<LoadingState<FavFolderData>> queryVideoInFolder() async {
    favIds = null;
    final (rid, type) = getFavRidType();
    final result = await FavHttp.videoInFolder(
      mid: accountService.mid,
      rid: rid,
      type: type,
    );
    if (result.isSuccess) {
      favFolderData.value = result.data;
      favIds = result.data.list
          ?.where((item) => item.favState == 1)
          .map((item) => item.id)
          .toSet();
    }
    return result;
  }

  Future<void> actionFavVideo({bool isQuick = false}) async {
    final (rid, type) = getFavRidType();
    // 收藏至默认文件夹
    if (isQuick) {
      SmartDialog.showLoading(msg: '请求中');
      queryVideoInFolder().then((res) async {
        if (res.isSuccess) {
          final hasFav = this.hasFav.value;
          var result = hasFav
              ? await FavHttp.unfavAll(rid: rid, type: type)
              : await FavHttp.favVideo(
                  resources: '$rid:$type',
                  addIds: favFolderId.toString(),
                );
          SmartDialog.dismiss();
          if (result['status']) {
            getStat()!.favorite += hasFav ? -1 : 1;
            this.hasFav.value = !hasFav;
            SmartDialog.showToast('✅ 快速收藏/取消收藏成功');
          } else {
            SmartDialog.showToast(result['msg']);
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
      for (var i in favFolderData.value.list!) {
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
    var result = await FavHttp.favVideo(
      resources: '$rid:$type',
      addIds: addMediaIdsNew.join(','),
      delIds: delMediaIdsNew.join(','),
    );
    SmartDialog.dismiss();
    if (result['status']) {
      Get.back();
      final newVal =
          addMediaIdsNew.isNotEmpty || favIds?.length != delMediaIdsNew.length;
      if (hasFav.value != newVal) {
        getStat()!.favorite += newVal ? 1 : -1;
        hasFav.value = newVal;
      }
      SmartDialog.showToast('操作成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  Future<void> coinVideo(int coin, [bool selectLike = false]) async {
    final stat = getStat();
    if (stat == null) {
      return;
    }
    var res = await VideoHttp.coinVideo(
      bvid: bvid,
      multiply: coin,
      selectLike: selectLike ? 1 : 0,
    );
    if (res['status']) {
      SmartDialog.showToast('投币成功');
      coinNum.value += coin;
      GlobalData().afterCoin(coin);
      stat.coin += coin;
      if (selectLike && !hasLike.value) {
        stat.like++;
        hasLike.value = true;
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  late final enableQuickFav = Pref.enableQuickFav;
  int? quickFavId;

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
    if (!accountService.isLogin.value) {
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

  Future<void> queryVideoTags() async {
    var result = await UserHttp.videoTags(bvid: bvid);
    if (result['status']) {
      videoTags.value = result['data'];
    } else {
      videoTags.value = null;
    }
  }
}
