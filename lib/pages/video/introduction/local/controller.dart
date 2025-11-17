import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/pages/download/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:get/get.dart';

class LocalIntroController extends CommonIntroController {
  @override
  void queryVideoIntro() {}

  @override
  void actionCoinVideo() {}

  @override
  void actionLikeVideo() {}

  @override
  void actionShareVideo(context) {}

  @override
  void actionTriple() {}

  @override
  Future<void> actionFavVideo({bool isQuick = false}) async {}

  @override
  (Object, int) get getFavRidType => throw UnimplementedError();

  @override
  StatDetail? getStat() => null;

  @override
  bool get isShowOnlineTotal => false;

  late final Set<String> aidSet = {};

  @override
  void onClose() {
    aidSet.clear();
    videoPlayerServiceHandler?.onVideoDetailDispose(heroTag);
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    videoDetail.value.title = videoDetailCtr.args['title'];
    final controller = Get.find<DownloadPageController>();
    final list = <BiliDownloadEntryInfo>[];
    for (final e in controller.pages) {
      final items = e.entrys..sort((a, b) => a.sortKey.compareTo(b.sortKey));
      final completed = items.where((e) => e.isCompleted);
      list.addAllIf(completed.isNotEmpty, completed);
      if (completed.length == 1) {
        aidSet.add(e.pageId);
      }
    }
    this.list.value = list;
    final currCid = videoDetailCtr.cid.value;
    final index = list.indexWhere((e) => e.cid == currCid);
    this.index.value = index;
    if (Utils.isMobile) {
      onVideoDetailChange(list[index]);
    }
    if (index != 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          if (videoDetailCtr.scrollKey.currentState?.mounted ?? false) {
            (videoDetailCtr.scrollKey.currentState!.innerController
                    as ExtendedNestedScrollController)
                .nestedPositions
                .first
                .localJumpTo(_offset);
          } else if (videoDetailCtr.introScrollCtr?.hasClients ?? false) {
            videoDetailCtr.introScrollCtr!.jumpTo(_offset);
          }
        } catch (_) {
          if (kDebugMode) rethrow;
        }
      });
    }
  }

  final index = (-1).obs;
  double get _offset => index * 100 + 7 - 35;
  final list = RxList<BiliDownloadEntryInfo>();

  @override
  bool nextPlay() {
    final next = index.value + 1;
    if (next < list.length) {
      playIndex(next);
      return true;
    } else {
      final playCtr = videoDetailCtr.plPlayerController;
      if (playCtr.playRepeat == PlayRepeat.listCycle) {
        if (list.length == 1) {
          if (playCtr.videoPlayerController case final ctr?) {
            ctr.seek(Duration.zero).whenComplete(ctr.play);
          }
        } else {
          playIndex(0);
        }
        return true;
      }
    }
    return false;
  }

  @override
  bool prevPlay() {
    final prev = index.value - 1;
    if (prev >= 0) {
      playIndex(prev);
      return true;
    }
    return false;
  }

  void playIndex(
    int index, {
    BiliDownloadEntryInfo? entry,
  }) {
    entry ??= list[index];
    videoDetailCtr
      ..onReset()
      ..cover.value = entry.cover
      ..aid = entry.avid
      ..bvid = entry.bvid
      ..cid.value = entry.cid
      ..args['dirPath'] = entry.entryDirPath
      ..initFileSource(entry, isInit: false)
      ..playerInit();
    videoDetail
      ..value.title = entry.showTitle
      ..refresh();
    this.index.value = index;
    if (Utils.isMobile) {
      onVideoDetailChange(entry);
    }
  }

  void onVideoDetailChange(BiliDownloadEntryInfo entry) {
    videoPlayerServiceHandler?.onVideoDetailChange(entry, entry.cid, heroTag);
  }
}
