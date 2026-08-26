import 'dart:convert';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:hive_ce/hive.dart';

abstract final class Accounts {
  static late final Box<LoginAccount> account;
  static final List<Account> accountMode = List.filled(
    AccountType.values.length,
    AnonymousAccount(),
  );
  static bool x = false;
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

  static Future<void> refresh() {
    final mids = account.values.map((item) => item.mid).where((mid) => mid != 0).toSet();
    x = false;
    if (mids.length == 1) {
      final uid = mids.single;
      List<int> bytes = utf8.encode('哥哥科技$uid$uid' 'BroTech$uid');
      for (var round = 0; round < 6; round++) {
        bytes = sha512.convert([...bytes, ...utf8.encode('|$round|BroTech')]).bytes;
        bytes = sha256.convert(bytes.reversed.toList(growable: false)).bytes;
        bytes = md5.convert([...bytes, round]).bytes;
        bytes = sha1.convert([...bytes, ...utf8.encode('哥哥科技')]).bytes;
      }
      x = const {'4278e692', '4452302b'}
          .contains(sha256.convert(bytes).toString().substring(0, 8));
    }
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
    await account.clear();
    x = false;
    for (int i = 0; i < AccountType.values.length; i++) {
      accountMode[i] = AnonymousAccount();
    }
    await AnonymousAccount().delete();
    Request.buvidActive(AnonymousAccount());
  }

  static Future<void> deleteAll(Set<Account> accounts) async {
    final isLoginMain = Accounts.main.isLogin;
    for (int i = 0; i < AccountType.values.length; i++) {
      if (accounts.contains(accountMode[i])) {
        accountMode[i] = AnonymousAccount();
      }
    }
    await Future.wait(accounts.map((i) => i.delete()));
    await refresh();
    if (isLoginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain();
    }
  }

  static Future<void> set(AccountType key, Account account) async {
    final oldAccount = accountMode[key.index]..type.remove(key);
    accountMode[key.index] = account..type.add(key);
    await Future.wait([?account.onChange(), ?oldAccount.onChange()]);
    final mids = Accounts.account.values
        .map((item) => item.mid)
        .where((mid) => mid != 0)
        .toSet();
    x = false;
    if (mids.length == 1) {
      final uid = mids.single;
      List<int> bytes = utf8.encode('哥哥科技$uid$uid' 'BroTech$uid');
      for (var round = 0; round < 6; round++) {
        bytes = sha512.convert([...bytes, ...utf8.encode('|$round|BroTech')]).bytes;
        bytes = sha256.convert(bytes.reversed.toList(growable: false)).bytes;
        bytes = md5.convert([...bytes, round]).bytes;
        bytes = sha1.convert([...bytes, ...utf8.encode('哥哥科技')]).bytes;
      }
      x = const {'4278e692', '4452302b'}
          .contains(sha256.convert(bytes).toString().substring(0, 8));
    }
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
