import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

LoginAccount _account(String mid) => LoginAccount(
  BiliCookieJar.fromJson({'DedeUserID': mid, 'bili_jct': 'csrf-$mid'}),
  'access-$mid',
  'refresh-$mid',
);

void main() {
  test('response account remains bound when the global account changes', () {
    final accountA = _account('1');
    final accountB = _account('2');
    final options = RequestOptions(path: 'https://api.bilibili.com/x/test');

    expect(
      AccountManager.bindRequestAccount(options, accountA),
      same(accountA),
    );

    expect(
      AccountManager.bindRequestAccount(options, accountB),
      same(accountA),
    );
    expect(AccountManager.boundRequestAccount(options), same(accountA));
  });

  test('explicit request account is preserved', () {
    final explicitAccount = _account('3');
    final options = RequestOptions(
      path: 'https://api.bilibili.com/x/test',
      extra: {'account': explicitAccount},
    );

    expect(
      AccountManager.bindRequestAccount(options, _account('4')),
      same(explicitAccount),
    );
  });
}
