import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:hive_ce/hive.dart';

/// 全局账号注册表与“账号角色”映射。
///
/// 一个 LoginAccount 可以同时承担多个角色；`accountMode` 保存每种角色当前
/// 使用的账号实例，而不是复制账号对象。Cookie 更新后会同时影响所有关联角色。
abstract final class Accounts {
  static late final Box<LoginAccount> account;
  static final List<Account> accountMode = List.filled(
    AccountType.values.length,
    AnonymousAccount(),
  );
  static bool get mainEqVideo => main == video;
  static Account get main => accountMode[AccountType.main.index];
  static Account get video => accountMode[AccountType.video.index];
  static Account get heartbeat => accountMode[AccountType.heartbeat.index];

  /// 历史记录优先跟随心跳/无痕账号；未单独设置时复用主账号。
  static Account get history {
    final heartbeat = Accounts.heartbeat;
    if (heartbeat is AnonymousAccount) {
      return Accounts.main;
    }
    return heartbeat;
  }
  // static set main(Account account) => set(AccountType.main, account);

  /// 打开登录账号 Box。由 GStorage.init() 在任何页面构建前调用。
  static Future<void> init() async {
    account = await Hive.openBox(
      'account',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 2;
      },
    );
  }

  /// 从 Hive 重建所有角色映射，并为尚未激活的账号触发 BUVID 初始化。
  static Future<void> refresh() {
    for (final a in account.values) {
      // 一个账号可声明多个角色，因此这里把同一实例写入多个槽位。
      for (final t in a.type) {
        accountMode[t.index] = a;
      }
    }
    return Future.wait(
      (accountMode.toSet()..removeWhere((i) => i.activated)).map(
        Request.buvidActive,
      ),
    );
  }

  /// 清除所有持久账号并把每个角色恢复为匿名账号。
  static Future<void> clear() async {
    await account.clear();
    for (int i = 0; i < AccountType.values.length; i++) {
      accountMode[i] = AnonymousAccount();
    }
    await AnonymousAccount().delete();
    Request.buvidActive(AnonymousAccount());
  }

  /// 删除一组账号，并修复仍引用这些账号的角色槽位。
  static Future<void> deleteAll(Set<Account> accounts) async {
    // 记录删除前主账号状态；删除导致主账号下线时需要执行完整登出流程。
    final isLoginMain = Accounts.main.isLogin;
    for (int i = 0; i < AccountType.values.length; i++) {
      if (accounts.contains(accountMode[i])) {
        accountMode[i] = AnonymousAccount();
      }
    }
    await Future.wait(accounts.map((i) => i.delete()));
    if (isLoginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain();
    }
  }

  /// 将某个角色切换到指定账号，并同步旧/新账号的角色元数据和持久化。
  static Future<void> set(AccountType key, Account account) async {
    // Set<AccountType> 是角色与账号的双向关系，切换时两边都必须更新。
    final oldAccount = accountMode[key.index]..type.remove(key);
    accountMode[key.index] = account..type.add(key);
    await Future.wait([?account.onChange(), ?oldAccount.onChange()]);
    if (!account.activated) await Request.buvidActive(account);
    switch (key) {
      case AccountType.main:
        await (account.isLogin
            ? LoginUtils.onLoginMain()
            : LoginUtils.onLogoutMain());
        break;
      case AccountType.heartbeat:
        MineController.anonymity.value = !account.isLogin;
        break;
      default:
        break;
    }
  }

  @pragma("vm:prefer-inline")
  static Account get(AccountType key) {
    return accountMode[key.index];
  }
}
