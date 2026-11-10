import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

/// 手动检查本地黑名单，并仅移除 B 站明确标记为不存在的 UID。
abstract final class LocalBlacklistCleanupService {
  static bool _isRunning = false;

  /// 仅业务码 -404 能证明账号不存在；其他错误均需保留 UID。
  static bool isDeletedAccountResult(LoadingState<Object?> result) =>
      result is Error && result.code == -404;

  /// 手动检查 UID 并返回移除数量；重复触发时返回 null。
  static Future<int?> cleanDeletedLocalMids({
    void Function(int checked, int total)? onProgress,
  }) async {
    if (_isRunning) return null;
    _isRunning = true;

    try {
      final globalData = GlobalData();
      final localMids = globalData.localBlackMids.toList();
      final deletedMids = <int>{};
      final total = localMids.length;
      var checked = 0;

      void reportProgress(int checked, int total) {
        try {
          onProgress?.call(checked, total);
        } catch (_) {
          // 进度回调是展示用途，异常不应中断账号检查和清理。
        }
      }

      reportProgress(checked, total);

      for (final mid in localMids) {
        if (globalData.localBlackMids.contains(mid)) {
          try {
            final result = await MemberHttp.memberInfo(mid: mid);
            if (isDeletedAccountResult(result)) {
              deletedMids.add(mid);
            }
          } catch (_) {
            // 网络异常、风控和解析失败均视为状态未知，不删除该 UID。
          }
        }

        checked++;
        reportProgress(checked, total);
      }

      for (final mid in deletedMids) {
        Pref.removeBlackMid(mid);
      }
      return deletedMids.length;
    } finally {
      _isRunning = false;
    }
  }
}
