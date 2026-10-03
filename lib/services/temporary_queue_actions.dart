import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/model_video.dart';
import 'package:PiliPlus/services/temporary_queue_service.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract final class TemporaryQueueActions {
  static Future<TemporaryQueueEntry?> resolveVideo({
    required String bvid,
    int? cid,
    int? aid,
    required String title,
    String? cover,
    bool silent = false,
  }) async {
    if (cid != null) {
      return TemporaryQueueEntry(
        bvid: bvid,
        cid: cid,
        aid: aid,
        title: title,
        cover: cover,
      );
    }
    try {
      final result = await VideoHttp.videoIntro(bvid: bvid);
      if (result case Success(:final response)) {
        final resolvedCid = response.cid ?? response.pages?.firstOrNull?.cid;
        if (resolvedCid != null) {
          return TemporaryQueueEntry(
            bvid: bvid,
            cid: resolvedCid,
            aid: response.aid ?? aid,
            title: title.isNotEmpty ? title : response.title ?? bvid,
            cover: cover ?? response.pic,
          );
        }
      }
    } catch (_) {
      // A failed lookup must not enqueue an item that can never be played.
    }
    if (!silent) SmartDialog.showToast('无法获取视频分 P，未加入临时播放列表');
    return null;
  }

  static Future<void> addVideo(
    BaseSimpleVideoItemModel video, {
    required bool next,
  }) async {
    if (!TemporaryQueueService.instance.enabled) return;
    final bvid = video.bvid;
    if (bvid == null || bvid.isEmpty) return;
    final item = await resolveVideo(
      bvid: bvid,
      cid: video.cid,
      aid: video is BaseVideoItemModel ? video.aid : null,
      title: video.title,
      cover: video.cover,
    );
    if (item == null) return;
    final change = next
        ? TemporaryQueueService.instance.addNext(item)
        : TemporaryQueueService.instance.addLast(item);
    SmartDialog.showToast(
      change.alreadyPlaying
          ? '正在播放，未重复添加'
          : '${change.moved ? '已移动' : '已添加'}到临时列表第 ${change.position + 1} 条，共 ${change.length} 条',
    );
  }
}
