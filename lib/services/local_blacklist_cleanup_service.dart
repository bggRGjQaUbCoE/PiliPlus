import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/utils/global_data.dart';
import 'package:PiliPlus/utils/storage_pref.dart';

/// 检查本地黑名单中的账号状态，并仅移除 B 站明确标记为不存在的 UID。
abstract final class LocalBlacklistCleanupService {
  static bool _isRunning = false;

  /// 仅业务码 -404 能证明账号不存在；其他错误均需保留 UID。
  static bool isDeletedAccountResult(LoadingState<Object?> result) =>
      result is Error && result.code == -404;

  /// 启动时静默检查；所有异常都在服务内消化，不影响应用启动。
  static Future<void> runOnStartup() async {
    try {
      if (!Pref.autoCleanDeletedBlacklist) return;
      await cleanDeletedLocalMids();
    } catch (_) {
      // 启动检查失败时保留名单，避免影响应用正常使用。
    }
  }

  /// 返回移除数量；若已有检查正在运行，则返回 null。
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
