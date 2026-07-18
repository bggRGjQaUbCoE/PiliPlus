import 'dart:io';

import 'package:PiliPlus/models/common/account_type.dart';
import 'package:PiliPlus/pages/mine/controller.dart';
import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp('piliplus_accounts_test_');
    appSupportDirPath = testDir.path;
    await GStorage.init();
  });

  setUp(() async {
    await Accounts.account.clear();
    Accounts.rebuildAccountModes(const []);
  });

  tearDown(() => Accounts.rebuildAccountModes(const []));

  tearDownAll(() async {
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('rebuilding modes clears assignments removed by an import', () {
    final account = _account('10001', {AccountType.main});
    Accounts.rebuildAccountModes([account]);
    expect(Accounts.main, same(account));

    account.type.clear();
    Accounts.rebuildAccountModes([account]);

    expect(Accounts.main, isA<AnonymousAccount>());
  });

  test('rebuilding modes persists only one owner for each account type', () {
    final first = _account('10001', {AccountType.main});
    final last = _account('10002', {
      AccountType.main,
      AccountType.video,
    });

    final changed = Accounts.rebuildAccountModes([first, last]);

    expect(Accounts.main, same(last));
    expect(Accounts.video, same(last));
    expect(first.type, isNot(contains(AccountType.main)));
    expect(changed, contains(first));
  });

  test('same-mid import tombstones the replaced account object', () async {
    final existing = _account('10003', {AccountType.main});
    final replacement = _account('10003', {AccountType.video});
    await existing.onChange();

    await Accounts.storeImportedAccounts([replacement]);

    expect(existing.isDeleted, isTrue);
    expect(Accounts.account.get('10003'), same(replacement));
  });

  test('reset tombstones stored accounts and exits anonymity mode', () async {
    final main = _account('10004', {AccountType.main});
    final heartbeat = _account('10005', {AccountType.heartbeat});
    await Future.wait([main.onChange(), heartbeat.onChange()]);
    Accounts.rebuildAccountModes([main, heartbeat]);
    MineController.anonymity.value = true;

    await Accounts.clearAccountStorage();

    expect(main.isDeleted, isTrue);
    expect(heartbeat.isDeleted, isTrue);
    expect(Accounts.account, isEmpty);
    expect(Accounts.main, isA<AnonymousAccount>());
    expect(Accounts.heartbeat, isA<AnonymousAccount>());
    expect(MineController.anonymity.value, isFalse);
  });
}

LoginAccount _account(String mid, Set<AccountType> types) => LoginAccount(
  BiliCookieJar.fromJson({'DedeUserID': mid, 'bili_jct': 'csrf-$mid'}),
  'access-$mid',
  null,
  types,
);
