import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

@visibleForTesting
String historyStatusAccountKey(Account account) =>
    account.isLogin ? 'mid:${account.mid}' : 'anonymous';

@visibleForTesting
bool resolveHistoryPause({
  required Object? cachedAccountKey,
  required String currentAccountKey,
  required Object? cachedPause,
}) => cachedAccountKey == currentAccountKey && cachedPause is bool
    ? cachedPause
    : true;

abstract final class HistoryStatusCache {
  static bool get pause {
    final accountKey = historyStatusAccountKey(Accounts.history);
    return resolveHistoryPause(
      cachedAccountKey: GStorage.localCache.get(
        LocalCacheKey.historyPauseAccount,
      ),
      currentAccountKey: accountKey,
      cachedPause: GStorage.localCache.get(LocalCacheKey.historyPause),
    );
  }

  static Future<void> prepare(Account account) async {
    if (!identical(account, Accounts.history)) return;
    if (!account.isLogin) return;
    final accountKey = historyStatusAccountKey(account);
    final cachedAccountKey = GStorage.localCache.get(
      LocalCacheKey.historyPauseAccount,
    );
    final cachedPause = GStorage.localCache.get(LocalCacheKey.historyPause);
    if (cachedAccountKey != accountKey || cachedPause is! bool) {
      await GStorage.localCache.putAll({
        LocalCacheKey.historyPauseAccount: accountKey,
        LocalCacheKey.historyPause: true,
      });
    }
  }

  static Future<void> store(Account account, bool pause) async {
    if (!identical(account, Accounts.history)) return;
    await GStorage.localCache.putAll({
      LocalCacheKey.historyPauseAccount: historyStatusAccountKey(account),
      LocalCacheKey.historyPause: pause,
    });
  }
}
