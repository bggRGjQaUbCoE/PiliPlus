import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/member.dart';
import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/login_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:hive_ce/hive.dart';

abstract final class Accounts {
  static final Map<int, ({String? name, String? face})> _profileCache = {};

  static ({String? name, String? face})? getCachedProfile(int mid) {
    if (_profileCache.containsKey(mid)) {
      return _profileCache[mid];
    }
    if (mid == Accounts.main.mid && Pref.userInfoCache != null) {
      final info = Pref.userInfoCache!;
      final profile = (name: info.uname, face: info.face);
      _profileCache[mid] = profile;
      return profile;
    }
    final cached = GStorage.localCache.get('accountProfile_$mid');
    if (cached is Map) {
      final profile = (
        name: cached['name'] as String?,
        face: cached['face'] as String?,
      );
      _profileCache[mid] = profile;
      return profile;
    }
    return null;
  }

  static Future<({String? name, String? face})> fetchProfile(int mid) async {
    final cached = getCachedProfile(mid);
    if (cached != null && cached.name != null && cached.face != null) {
      return cached;
    }
    try {
      final res = await MemberHttp.memberCardInfo(mid: mid);
      if (res case Success(:final response)) {
        final card = response.card;
        final profile = (name: card?.name, face: card?.face);
        _profileCache[mid] = profile;
        GStorage.localCache.put('accountProfile_$mid', {
          'name': card?.name,
          'face': card?.face,
        });
        return profile;
      }
    } catch (_) {}
    return cached ?? (name: null, face: null);
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
    await account.clear();
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
    if (isLoginMain && !Accounts.main.isLogin) {
      await LoginUtils.onLogoutMain();
    }
  }

  static Future<void> set(AccountType key, Account account) async {
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
