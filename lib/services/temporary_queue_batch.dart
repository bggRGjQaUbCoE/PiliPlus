import 'package:PiliPlus/http/fav.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/fav_order_type.dart';
import 'package:PiliPlus/services/temporary_queue_actions.dart';
import 'package:PiliPlus/services/temporary_queue_service.dart';

class TemporaryQueueBatchProgress {
  final int scanned;
  final int? total;
  final int added;
  final int moved;
  final int skipped;
  final String? error;
  final bool cancelled;

  const TemporaryQueueBatchProgress({
    this.scanned = 0,
    this.total,
    this.added = 0,
    this.moved = 0,
    this.skipped = 0,
    this.error,
    this.cancelled = false,
  });

  bool get incomplete => error != null || cancelled;
}

abstract final class TemporaryQueueBatch {
  static Future<TemporaryQueueBatchProgress> addFavoriteFolder({
    required int mediaId,
    required int count,
    required FavOrderType order,
    required bool reversePages,
    required bool Function() cancelled,
    required void Function(TemporaryQueueBatchProgress) onProgress,
  }) async {
    const pageSize = 20;
    final pageCount = (count / pageSize).ceil();
    var scanned = 0;
    var added = 0;
    var moved = 0;
    var skipped = 0;
    String? error;
    final queue = TemporaryQueueService.instance;

    for (var offset = 0; offset < pageCount; offset++) {
      if (cancelled()) break;
      final page = reversePages ? pageCount - offset : offset + 1;
      try {
        final result = await FavHttp.userFavFolderDetail(
          mediaId: mediaId,
          pn: page,
          ps: pageSize,
          order: order,
        );
        if (result case Success(:final response)) {
          final entries = reversePages
              ? (response.medias ?? const []).reversed
              : response.medias ?? const [];
          if (entries.isEmpty) {
            error = '第 $page 页为空，未能确认全部内容';
            break;
          }
          for (final entry in entries) {
            if (cancelled()) break;
            scanned++;
            final bvid = entry.bvid;
            final cid = entry.ugc?.firstCid;
            if (bvid == null ||
                bvid.isEmpty ||
                cid == null ||
                entry.type != 2) {
              skipped++;
            } else {
              final change = queue.addLast(
                TemporaryQueueEntry(
                  bvid: bvid,
                  cid: cid,
                  aid: entry.id,
                  title: entry.title ?? bvid,
                  cover: entry.cover,
                ),
              );
              if (change.alreadyPlaying) {
                skipped++;
              } else if (change.moved) {
                moved++;
              } else {
                added++;
              }
            }
            onProgress(
              TemporaryQueueBatchProgress(
                scanned: scanned,
                total: count,
                added: added,
                moved: moved,
                skipped: skipped,
              ),
            );
          }
        } else {
          error = '第 $page 页读取失败：$result';
          break;
        }
      } catch (e) {
        error = '第 $page 页读取结果未知：$e';
        break;
      }
    }
    final result = TemporaryQueueBatchProgress(
      scanned: scanned,
      total: count,
      added: added,
      moved: moved,
      skipped: skipped,
      error: error,
      cancelled: cancelled(),
    );
    onProgress(result);
    return result;
  }

  static Future<TemporaryQueueBatchProgress> addSubscription({
    required int seasonId,
    required int count,
    required bool Function() cancelled,
    required void Function(TemporaryQueueBatchProgress) onProgress,
  }) async {
    const pageSize = 20;
    var scanned = 0;
    var added = 0;
    var moved = 0;
    var skipped = 0;
    String? error;
    final queue = TemporaryQueueService.instance;
    for (var page = 1; scanned < count; page++) {
      if (cancelled()) break;
      try {
        final result = await FavHttp.favSeasonList(
          id: seasonId,
          pn: page,
          ps: pageSize,
        );
        if (result case Success(:final response)) {
          final entries = response.medias ?? const [];
          if (entries.isEmpty) {
            error = '第 $page 页为空，未能确认全部内容';
            break;
          }
          for (final entry in entries) {
            if (cancelled()) break;
            scanned++;
            final bvid = entry.bvid;
            if (bvid == null || bvid.isEmpty) {
              skipped++;
            } else {
              final item = await TemporaryQueueActions.resolveVideo(
                bvid: bvid,
                aid: entry.id,
                title: entry.title ?? bvid,
                cover: entry.cover,
                silent: true,
              );
              if (item == null) {
                skipped++;
              } else {
                final change = queue.addLast(item);
                if (change.alreadyPlaying) {
                  skipped++;
                } else if (change.moved) {
                  moved++;
                } else {
                  added++;
                }
              }
            }
            onProgress(
              TemporaryQueueBatchProgress(
                scanned: scanned,
                total: count,
                added: added,
                moved: moved,
                skipped: skipped,
              ),
            );
          }
        } else {
          error = '第 $page 页读取失败：$result';
          break;
        }
      } catch (e) {
        error = '第 $page 页读取结果未知：$e';
        break;
      }
    }
    final result = TemporaryQueueBatchProgress(
      scanned: scanned,
      total: count,
      added: added,
      moved: moved,
      skipped: skipped,
      error: error,
      cancelled: cancelled(),
    );
    onProgress(result);
    return result;
  }
}
