import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/utils/accounts.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory testDir;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_account_manager_test_',
    );
    appSupportDirPath = testDir.path;
    await GStorage.init();
  });

  tearDownAll(() async {
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('diagnostic request URLs omit credentials and query values', () {
    const secrets = <String>[
      'user-name',
      'password-value',
      'access-key-value',
      'csrf-value',
      'auth-code-value',
      'fragment-token-value',
    ];
    final options = RequestOptions(
      path:
          'https://user-name:password-value@api.example.com:8443/v1/items'
          '#fragment-token-value',
      queryParameters: const {
        'access_key': 'access-key-value',
        'csrf': 'csrf-value',
        'auth_code': 'auth-code-value',
        'page': 2,
      },
    );

    final result = requestUrlForDiagnostics(options);

    expect(result, 'https://api.example.com:8443/v1/items');
    for (final secret in secrets) {
      expect(result, isNot(contains(secret)));
    }
  });

  test('request pins the account selected before an account switch', () async {
    final accountA = _account('10001');
    final accountB = _account('10002');
    Account currentAccount = accountA;
    final adapter = _CaptureAdapter();
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AccountManager.test(
          blockServer: 'blocked.invalid',
          accountResolver: (_) => currentAccount,
        ),
      );

    final request = dio.get<void>('https://api.bilibili.com/x/test');
    final requestOptions = await adapter.request;
    currentAccount = accountB;
    adapter.release();
    await request;

    expect(requestOptions.extra['account'], same(accountA));
  });

  test('a late response cannot persist a deleted account again', () async {
    final account = _account('10003');
    await account.onChange();
    final adapter = _CaptureAdapter(
      responseHeaders: {
        HttpHeaders.setCookieHeader: [
          'late-cookie=value; Domain=.bilibili.com; Path=/',
        ],
      },
    );
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AccountManager.test(
          blockServer: 'blocked.invalid',
          accountResolver: (_) => account,
        ),
      );

    final request = dio.get<void>('https://api.bilibili.com/x/test');
    await adapter.request;
    await account.delete();
    adapter.release();
    await request;

    expect(account.isDeleted, isTrue);
    expect(Accounts.account.containsKey('10003'), isFalse);
    expect(account.cookieJar.toList(), isEmpty);
  });

  test('a late response cannot overwrite a same-mid import', () async {
    final existing = _account('10004');
    final replacement = _account('10004');
    await existing.onChange();
    final adapter = _CaptureAdapter(
      responseHeaders: {
        HttpHeaders.setCookieHeader: [
          'late-cookie=value; Domain=.bilibili.com; Path=/',
        ],
      },
    );
    final dio = Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(
        AccountManager.test(
          blockServer: 'blocked.invalid',
          accountResolver: (_) => existing,
        ),
      );

    final request = dio.get<void>('https://api.bilibili.com/x/test');
    await adapter.request;
    await Accounts.storeImportedAccounts([replacement]);
    adapter.release();
    await request;

    expect(existing.isDeleted, isTrue);
    expect(existing.cookieJar.toList(), isEmpty);
    expect(Accounts.account.get('10004'), same(replacement));
  });
}

LoginAccount _account(String mid) => LoginAccount(
  BiliCookieJar.fromJson({'DedeUserID': mid, 'bili_jct': 'csrf-$mid'}),
  'access-$mid',
  null,
);

class _CaptureAdapter implements HttpClientAdapter {
  _CaptureAdapter({this.responseHeaders});

  final Map<String, List<String>>? responseHeaders;
  final _request = Completer<RequestOptions>();
  final _release = Completer<void>();

  Future<RequestOptions> get request => _request.future;

  void release() => _release.complete();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    _request.complete(options);
    await _release.future;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: responseHeaders,
    );
  }

  @override
  void close({bool force = false}) {}
}
