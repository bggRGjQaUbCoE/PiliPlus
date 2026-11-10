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
  static Future<int?> cleanDeletedLocalMids() async {
    if (_isRunning) return null;
    _isRunning = true;

    try {
      final localMids = GlobalData().localBlackMids.toList();
      final deletedMids = <int>{};

      for (final mid in localMids) {
        if (!GlobalData().localBlackMids.contains(mid)) continue;

        try {
          final result = await MemberHttp.memberInfo(mid: mid);
          if (isDeletedAccountResult(result)) {
            deletedMids.add(mid);
          }
        } catch (_) {
          // 网络异常、风控和解析失败均视为状态未知，不删除该 UID。
        }
      }

      if (deletedMids.isEmpty) return 0;

      final globalData = GlobalData();
      globalData.localBlackMids.removeWhere(deletedMids.contains);
      Pref.localBlackMids = globalData.localBlackMids;

      for (final mid in deletedMids) {
        if (!globalData.onlineBlackMids.contains(mid)) {
          globalData.blackMids.remove(mid);
        }
      }

      return deletedMids.length;
    } finally {
      _isRunning = false;
    }
  }
}
