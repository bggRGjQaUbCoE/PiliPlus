import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/download_collection.dart';
import 'package:PiliPlus/models_new/video/video_detail/stat_detail.dart';
import 'package:PiliPlus/pages/common/common_intro_controller.dart';
import 'package:PiliPlus/services/download/download_collection_service.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_repeat.dart';
import 'package:PiliPlus/services/service_locator.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:get/get.dart';

class LocalIntroController extends CommonIntroController {
  @override
  void queryVideoIntro() {}

  @override
  int get copyright => throw UnimplementedError();

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

  // 是否正在进入应用内小窗
  bool isEnteringPip = false;

  @override
  void onClose() {
    if (isEnteringPip) return;
    aidSet.clear();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    videoDetail.value.title = videoDetailCtr.args['title'];
    final downloadService = Get.find<DownloadService>();
    final collectionService = Get.find<DownloadCollectionService>();
    final playContext = DownloadVideoPlayContext.fromArguments(
      videoDetailCtr.args,
    );
    final list = switch (playContext?.scope) {
      DownloadPlaylistScope.folder => collectionService.resolveFolderEntries(
        playContext!.folderId!,
        downloadService.downloadList,
      ),
      DownloadPlaylistScope.all => collectionService.resolveAllEntries(
        downloadService.downloadList,
      ),
      null => List<BiliDownloadEntryInfo>.from(downloadService.downloadList)
        ..sort((a, b) => b.timeUpdateStamp.compareTo(a.timeUpdateStamp)),
    };
    for (final entry in list) {
      aidSet.add(entry.pageId);
    }
    this.list.value = list;
    final currCid = videoDetailCtr.cid.value;
    final index = list.indexWhere((e) => e.cid == currCid);
    this.index.value = index == -1 ? 0 : index;
    if (list.isNotEmpty && PlatformUtils.isMobile) {
      onVideoDetailChange(list[this.index.value]);
    }
    if (this.index.value != 0) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        try {
          final state = videoDetailCtr.scrollKey.currentState;
          if (state != null && state.mounted) {
            (state.innerController as ExtendedNestedScrollController)
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
  double get _offset => index * 112 + 7 - 35;
  final list = RxList<BiliDownloadEntryInfo>();

  @override
  bool nextPlay({bool manual = false}) {
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
  bool prevPlay({bool manual = false}) {
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
    if (PlatformUtils.isMobile) {
      onVideoDetailChange(entry);
    }
  }

  void onVideoDetailChange(BiliDownloadEntryInfo entry) {
    videoPlayerServiceHandler?.onVideoDetailChange(entry, entry.cid, heroTag);
  }
}
