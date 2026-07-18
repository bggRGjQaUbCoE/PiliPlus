import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/music.dart';
import 'package:PiliPlus/models_new/music/bgm_detail.dart';
import 'package:PiliPlus/pages/common/dyn/common_dyn_controller.dart';
import 'package:PiliPlus/pages/music/wish_state.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/async_operation_guard.dart';
import 'package:get/get.dart';

class MusicDetailController extends CommonDynController {
  @override
  late final int oid;
  @override
  late final int replyType;

  @override
  dynamic get sourceId => oid.toString();

  final infoState = LoadingState<MusicDetail>.loading().obs;
  final _wishGuard = AsyncKeyedOperationGuard<Object>();

  late final String musicId;

  String get shareUrl =>
      'https://music.bilibili.com/h5/music-detail?music_id=$musicId';

  @override
  void onInit() {
    super.onInit();
    musicId = Get.parameters['musicId']!;
    getMusicDetail();
  }

  Future<void> getMusicDetail() async {
    final res = await MusicHttp.bgmDetail(musicId);
    if (res case Success(:final response)) {
      final comment = response.musicComment!;
      oid = comment.oid!;
      replyType = comment.pageType ?? 47;
      count.value = comment.nums ?? -1;
      queryData();
    }
    infoState.value = res;
  }

  Future<void> onWishUpdate(bool hasWish) {
    final account = Accounts.main;
    return _wishGuard.run((account, musicId), () async {
      final res = await MusicHttp.wishUpdate(musicId, hasWish, account);
      if (!res.isSuccess) {
        res.toast();
        return;
      }
      if (Accounts.main != account) return;

      final current = infoState.value.dataOrNull;
      final desired = !hasWish;
      if (current == null || (current.wishListen ?? false) == desired) {
        return;
      }

      current
        ..wishCount = reconcileWishCount(
          count: current.wishCount,
          currentStatus: current.wishListen ?? false,
          desiredStatus: desired,
        )
        ..wishListen = desired;
      infoState.refresh();
    });
  }
}
