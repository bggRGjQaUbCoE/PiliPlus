import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:hive_ce/hive.dart';

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

  @visibleForTesting
  static Set<Account> rebuildAccountModes(Iterable<Account> accounts) {
    for (var i = 0; i < accountMode.length; i++) {
      accountMode[i] = AnonymousAccount();
    }
    final changedAccounts = <Account>{};
    for (final current in accounts) {
      for (final type in current.type.toList(growable: false)) {
        final previous = accountMode[type.index];
        if (!identical(previous, current) &&
            previous.isLogin &&
            previous.type.remove(type)) {
          changedAccounts.add(previous);
        }
        accountMode[type.index] = current;
      }
    }
    return changedAccounts;
  }

  static Future<void> refresh() async {
    final changedAccounts = rebuildAccountModes(account.values);
    for (final changed in changedAccounts) {
      await changed.onChange();
    }
    await Future.wait(
      (accountMode.toSet()..removeWhere((i) => i.activated)).map(
        Request.buvidActive,
      ),
    );
  }

  static Future<void> importAccounts(Iterable<LoginAccount> accounts) async {
    final wasMainLoggedIn = main.isLogin;
    await storeImportedAccounts(accounts);
    await refresh();
    _syncAnonymity();
    if (main.isLogin) {
      await LoginUtils.onLoginMain();
    } else if (wasMainLoggedIn) {
      await LoginUtils.onLogoutMain();
    } else {
      await LoginUtils.onHistoryAccountChanged();
    }
  }

  @visibleForTesting
  static Future<void> storeImportedAccounts(
    Iterable<LoginAccount> accounts,
  ) async {
    final importedByMid = {
      for (final imported in accounts) imported.mid.toString(): imported,
    };
    final replacedAccounts = <LoginAccount>{
      for (final entry in importedByMid.entries)
        if (account.get(entry.key) case final LoginAccount existing
            when !identical(existing, entry.value))
          existing,
    };
    await Future.wait(replacedAccounts.map((existing) => existing.delete()));
    await account.putAll(importedByMid);
  }

  static Future<void> clear() async {
    await clearAccountStorage();
    await LoginUtils.onLogoutMain();
    Request.buvidActive(AnonymousAccount());
  }

  @visibleForTesting
  static Future<void> clearAccountStorage() async {
    final storedAccounts = <LoginAccount>[
      ...account.values,
      ...accountMode.whereType<LoginAccount>(),
    ];
    rebuildAccountModes(const []);
    await Future.wait(storedAccounts.map((stored) => stored.delete()));
    await account.clear();
    await AnonymousAccount().delete();
    _syncAnonymity();
  }

  static Future<void> deleteAll(Set<Account> accounts) async {
    final isLoginMain = Accounts.main.isLogin;
    final historyAccount = Accounts.history;
    for (int i = 0; i < AccountType.values.length; i++) {
      if (accounts.contains(accountMode[i])) {
        accountMode[i] = AnonymousAccount();
      }
    }
    await Future.wait(accounts.map((i) => i.delete()));
    _syncAnonymity();
    if (isLoginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain();
    } else if (!identical(historyAccount, Accounts.history)) {
      await LoginUtils.onHistoryAccountChanged();
    }
  }

  static Future<void> set(AccountType key, Account account) async {
    final oldAccount = accountMode[key.index]..type.remove(key);
    accountMode[key.index] = account..type.add(key);
    await Future.wait([?account.onChange(), ?oldAccount.onChange()]);
    _syncAnonymity();
    if (!account.activated) await Request.buvidActive(account);
    switch (key) {
      case AccountType.main:
        await (account.isLogin
            ? LoginUtils.onLoginMain()
            : LoginUtils.onLogoutMain());
        break;
      case AccountType.heartbeat:
        await LoginUtils.onHistoryAccountChanged();
        break;
      default:
        break;
    }
  }

  @pragma("vm:prefer-inline")
  static Account get(AccountType key) {
    return accountMode[key.index];
  }

  static void _syncAnonymity() {
    MineController.anonymity.value =
        Accounts.account.isNotEmpty && !Accounts.heartbeat.isLogin;
  }
}
