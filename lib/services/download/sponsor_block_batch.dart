import 'package:PiliPlus/models_new/sponsor_block/snapshot.dart';
import 'package:PiliPlus/services/download/sponsor_block_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class SponsorBlockBatch extends ChangeNotifier {
  SponsorBlockBatch(this.cache, Iterable<SponsorBlockTarget?> targets) {
    final seen = <(String, String, int)>{};
    for (final target in targets) {
      if (target == null) {
        unsupported++;
      } else if (seen.add((
        path.normalize(path.absolute(target.directory)),
        target.bvid,
        target.cid,
      ))) {
        _targets.add(target);
      }
    }
  }

  final SponsorBlockCache cache;
  final _targets = <SponsorBlockTarget>[];
  CancelToken? _token;
  bool _disposed = false;
  bool running = false;
  bool finished = false;
  int saved = 0;
  int empty = 0;
  int reused = 0;
  int failed = 0;
  int unsupported = 0;
  String? reason;
  int get total => _targets.length + unsupported;
  int get processed => saved + empty + reused + failed + unsupported;
  int get remaining => total - processed;
  String get summary =>
      '保存有标记 $saved，保存空标记 $empty，已有有效信息 $reused，'
      '内容不适用 $unsupported，失败 $failed，尚未处理 $remaining';

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void cancel() => _token?.cancel();

  Future<void> run({required bool refresh}) async {
    if (running || finished || _disposed) return;
    if (cache.batchRunning) {
      reason = '已有空降更新正在进行，请稍后重试';
      _notify();
      return;
    }
    cache.batchRunning = running = true;
    final token = _token = CancelToken();
    final generation = cache.generation;
    var failures = 0;
    _notify();
    try {
      for (final target in _targets) {
        if (token.isCancelled || generation != cache.generation) {
          reason = '更新已取消，已保存的结果保留';
          break;
        }
        // 每个请求单独取消，超时不会取消整批操作。
        final request = CancelToken();
        token.whenCancel.then((_) => request.cancel());
        final result = await cache.update(
          target,
          refresh: refresh,
          cancelToken: request,
        );
        if (_disposed) break;
        switch (result.status) {
          case .ready:
            if (result.snapshot!.segments.isEmpty) {
              empty++;
            } else {
              saved++;
            }
            failures = 0;
          case .reused:
            reused++;
            failures = 0;
          case .cancelled:
            reason = '更新已取消，已保存的结果保留';
            token.cancel();
          default:
            failed++;
            failures = result.code == -1 || (result.code ?? 0) >= 500
                ? failures + 1
                : 0;
            if (result.code == 429 || failures >= 3) {
              reason = '服务器限流或连续网络故障，已停止后续请求';
              token.cancel();
            }
        }
        _notify();
        if (token.isCancelled) break;
        if (result.status != SponsorBlockCacheStatus.reused) {
          await Future.any([
            Future<void>.delayed(const Duration(milliseconds: 300)),
            token.whenCancel,
          ]);
        }
      }
    } finally {
      cache.batchRunning = running = false;
      finished = true;
      // 释放本批请求绑定的取消回调。
      token.cancel();
      _notify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    cancel();
    super.dispose();
  }
}
