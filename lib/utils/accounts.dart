import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:hive_ce/hive.dart';

abstract final class Accounts {
  /// An active media session can be stopped before its owning main account
  /// changes. Kept as a callback to avoid coupling account storage to UI.
  static Future<void> Function()? beforeMainIdentityChange;
  static final Set<Future<void> Function()> _mainIdentityChangeListeners = {};
  static int _mainChangeGeneration = 0;
  static int get mainChangeGeneration => _mainChangeGeneration;

  static void addMainIdentityChangeListener(Future<void> Function() listener) =>
      _mainIdentityChangeListeners.add(listener);

  static void removeMainIdentityChangeListener(
    Future<void> Function() listener,
  ) => _mainIdentityChangeListeners.remove(listener);

  static Future<void> _beforeMainChange() async {
    await beforeMainIdentityChange?.call();
    for (final listener in _mainIdentityChangeListeners.toList()) {
      await listener();
    }
  }

  static late final Box<LoginAccount> account;
  static final List<Account> accountMode = List.filled(
    AccountType.values.length,
    AnonymousAccount(),
  );
  static bool get mainEqVideo => main == video;
  static Account get main => accountMode[AccountType.main.index];
  static Account get video => accountMode[AccountType.video.index];
  static Account get heartbeat => accountMode[AccountType.heartbeat.index];
  static bool mainIdentityChanged(Account previous, Account next) =>
      !identical(previous, next);
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
  }

  static Future<void> refresh() {
    for (final a in account.values) {
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

  static Future<void> clear() async {
    ++_mainChangeGeneration;
    final previousMain = main;
    if (previousMain.isLogin) {
      await _beforeMainChange();
      await LoginUtils.clearWebCookiesBeforeMainSwitch(previousMain);
    }
    await account.clear();
    for (int i = 0; i < AccountType.values.length; i++) {
      accountMode[i] = AnonymousAccount();
    }
    await AnonymousAccount().delete();
    Request.buvidActive(AnonymousAccount());
    await LoginUtils.clearWebCookiesOnAccountReset();
  }

  static Future<void> deleteAll(Set<Account> accounts) async {
    final previousMain = Accounts.main;
    final isLoginMain = previousMain.isLogin;
    bool containsIdentity(Account target) =>
        accounts.any((account) => identical(account, target));
    if (isLoginMain && containsIdentity(previousMain)) {
      ++_mainChangeGeneration;
      await _beforeMainChange();
      await LoginUtils.clearWebCookiesBeforeMainSwitch(previousMain);
    }
    for (int i = 0; i < AccountType.values.length; i++) {
      if (containsIdentity(accountMode[i])) {
        accountMode[i] = AnonymousAccount();
      }
    }
    await Future.wait(accounts.map((i) => i.delete()));
    if (isLoginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain(Accounts.main);
    }
  }

  static Future<void> set(AccountType key, Account account) async {
    final previousMain = key == AccountType.main ? main : null;
    final changingMain =
        previousMain != null && mainIdentityChanged(previousMain, account);
    final mainGeneration = changingMain ? ++_mainChangeGeneration : null;
    if (changingMain) {
      await _beforeMainChange();
      if (mainGeneration != _mainChangeGeneration) return;
      await LoginUtils.clearWebCookiesBeforeMainSwitch(previousMain);
      if (mainGeneration != _mainChangeGeneration) return;
    }
    final oldAccount = accountMode[key.index]..type.remove(key);
    accountMode[key.index] = account..type.add(key);
    if (key == AccountType.main) {
      await LoginUtils.syncSelectedMainWebCookies(account);
      if (mainGeneration != null && mainGeneration != _mainChangeGeneration) {
        return;
      }
    }
    await Future.wait([?account.onChange(), ?oldAccount.onChange()]);
    if (!account.activated) await Request.buvidActive(account);
    if (key == AccountType.main &&
        (mainGeneration != null && mainGeneration != _mainChangeGeneration ||
            !identical(main, account))) {
      return;
    }
    switch (key) {
      case AccountType.main:
        await (account.isLogin
            ? LoginUtils.onLoginMain(account)
            : LoginUtils.onLogoutMain(account));
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
