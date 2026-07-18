import 'dart:async';
import 'dart:typed_data';

import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/accounts/account_manager/account_mgr.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}

LoginAccount _account(String mid) => LoginAccount(
  BiliCookieJar.fromJson({'DedeUserID': mid, 'bili_jct': 'csrf-$mid'}),
  'access-$mid',
  null,
);

class _CaptureAdapter implements HttpClientAdapter {
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
    return ResponseBody.fromString('{}', 200);
  }

  @override
  void close({bool force = false}) {}
}
