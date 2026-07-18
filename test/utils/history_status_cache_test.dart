import 'dart:io';

import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/history_status_cache.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_history_status_test_',
    );
    appSupportDirPath = testDir.path;
    await GStorage.init();
  });

  tearDownAll(() async {
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('history status keys are scoped to the selected account', () {
    expect(historyStatusAccountKey(_account('10001')), 'mid:10001');
    expect(historyStatusAccountKey(_account('10002')), 'mid:10002');
    expect(historyStatusAccountKey(AnonymousAccount()), 'anonymous');
  });

  test('history reporting fails closed for stale or malformed cache data', () {
    expect(
      resolveHistoryPause(
        cachedAccountKey: 'mid:10001',
        currentAccountKey: 'mid:10002',
        cachedPause: false,
      ),
      isTrue,
    );
    expect(
      resolveHistoryPause(
        cachedAccountKey: 'mid:10002',
        currentAccountKey: 'mid:10002',
        cachedPause: 'not-a-boolean',
      ),
      isTrue,
    );
    expect(
      resolveHistoryPause(
        cachedAccountKey: 'mid:10002',
        currentAccountKey: 'mid:10002',
        cachedPause: false,
      ),
      isFalse,
    );
  });
}

LoginAccount _account(String mid) => LoginAccount(
  BiliCookieJar.fromJson({'DedeUserID': mid, 'bili_jct': 'csrf-$mid'}),
  'access-$mid',
  null,
);
