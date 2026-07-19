import 'dart:typed_data';

import 'package:PiliPlus/http/init.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HTTP debug logging', () {
    const secrets = <String>[
      'ACCESS_KEY_SENTINEL',
      'CSRF_SENTINEL',
      'AUTH_CODE_SENTINEL',
    ];

    late Dio dio;
    late _ControlledAdapter adapter;
    late List<Object> logs;

    setUp(() {
      logs = [];
      adapter = _ControlledAdapter();
      dio = Dio()
        ..httpClientAdapter = adapter
        ..interceptors.add(createHttpLogInterceptor(logPrint: logs.add));
    });

    tearDown(() {
      dio.close(force: true);
    });

    test('successful requests do not log authenticated URIs', () async {
      await dio.get<void>(
        'https://example.test/login/callback',
        queryParameters: const {
          'access_key': 'ACCESS_KEY_SENTINEL',
          'csrf': 'CSRF_SENTINEL',
          'auth_code': 'AUTH_CODE_SENTINEL',
        },
      );

      _expectNoSecrets(logs, secrets);
    });

    test('failed requests do not log authenticated URIs', () async {
      adapter.fail = true;

      await expectLater(
        dio.get<void>(
          'https://example.test/login/callback',
          queryParameters: const {
            'access_key': 'ACCESS_KEY_SENTINEL',
            'csrf': 'CSRF_SENTINEL',
            'auth_code': 'AUTH_CODE_SENTINEL',
          },
        ),
        throwsA(isA<DioException>()),
      );

      _expectNoSecrets(logs, secrets);
    });
  });
}

void _expectNoSecrets(List<Object> logs, List<String> secrets) {
  final output = logs.join('\n');
  for (final secret in secrets) {
    expect(output, isNot(contains(secret)), reason: 'logged $secret');
  }
}

class _ControlledAdapter implements HttpClientAdapter {
  bool fail = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (fail) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'simulated failure',
        error: const _Failure(),
      );
    }
    return ResponseBody.fromString('', 200);
  }

  @override
  void close({bool force = false}) {}
}

class _Failure {
  const _Failure();
}
