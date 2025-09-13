import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:hive/hive.dart';

abstract class Accounts {
  static late final Box<LoginAccount> account;
  static final Map<AccountType, Account> accountMode = {};
  static Account get main => accountMode[AccountType.main]!;
  static Account get heartbeat => accountMode[AccountType.heartbeat]!;
  static Account get history {
    final heartbeat = Accounts.heartbeat;
    if (heartbeat is AnonymousAccount) {
      return Accounts.main;
    }
    return heartbeat;
  }
  // static set main(Account account) => set(AccountType.main, account);

  static Future<void> init() async {
    account = await Hive.openBox(
      'account',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 2;
      },
    );
    // await _migrate();
  }

  // static Future<void> _migrate() async {
  //   final Directory tempDir = await getApplicationSupportDirectory();
  //   final String tempPath = "${tempDir.path}/.plpl/";
  //   final Directory dir = Directory(tempPath);
  //   if (dir.existsSync()) {
  //     if (kDebugMode) debugPrint('migrating...');
  //     final cookieJar = PersistCookieJar(
  //       ignoreExpires: true,
  //       storage: FileStorage(tempPath),
  //     );
  //     await cookieJar.forceInit();
  //     final cookies = DefaultCookieJar(ignoreExpires: true)
  //       ..domainCookies.addAll(cookieJar.domainCookies);
  //     final localAccessKey = GStorage.localCache.get(
  //       'accessKey',
  //       defaultValue: {},
  //     );

  //     final isLogin =
  //         cookies.domainCookies['bilibili.com']?['/']?['SESSDATA'] != null;

  //     await Future.wait([
  //       GStorage.localCache.delete('accessKey'),
  //       GStorage.localCache.delete('danmakuFilterRule'),
  //       GStorage.localCache.delete('blackMidsList'),
  //       dir.delete(recursive: true),
  //       if (isLogin)
  //         LoginAccount(
  //           cookies,
  //           localAccessKey['value'],
  //           localAccessKey['refresh'],
  //           AccountType.values.toSet(),
  //         ).onChange(),
  //     ]);
  //     if (kDebugMode) debugPrint('migrated successfully');
  //   }
  // }

  static Future<void> refresh() async {
    for (var a in account.values) {
      for (var t in a.type) {
        accountMode[t] = a;
      }
    }
    for (var type in AccountType.values) {
      accountMode[type] ??= AnonymousAccount();
    }
    await Future.wait(
      (accountMode.values.toSet()..retainWhere((i) => !i.activited)).map(
        Request.buvidActive,
      ),
    );
  }

  static Future<void> clear() async {
    await account.clear();
    for (var i in AccountType.values) {
      accountMode[i] = AnonymousAccount();
    }
    await AnonymousAccount().delete();
    Request.buvidActive(AnonymousAccount());
  }

  static void close() {
    account
      ..compact()
      ..close();
  }

  static Future<void> deleteAll(Set<Account> accounts) async {
    var isloginMain = Accounts.main.isLogin;
    Accounts.accountMode.updateAll(
      (_, a) => accounts.contains(a) ? AnonymousAccount() : a,
    );
    await Future.wait(accounts.map((i) => i.delete()));
    if (isloginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain();
    }
  }

  static Future<void> set(AccountType key, Account account) async {
    await (accountMode[key]?..type.remove(key))?.onChange();
    accountMode[key] = account..type.add(key);
    await account.onChange();
    if (!account.activited) await Request.buvidActive(account);
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

  static Account get(AccountType key) {
    return accountMode[key]!;
  }
}
