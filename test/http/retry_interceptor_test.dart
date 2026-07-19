import 'dart:typed_data';

import 'package:PiliPlus/http/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RetryInterceptor', () {
    late Dio dio;
    late _FailingAdapter adapter;

    setUp(() {
      adapter = _FailingAdapter();
      dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      dio
        ..httpClientAdapter = adapter
        ..interceptors.add(RetryInterceptor(dio, 2, 0));
    });

    tearDown(() {
      dio.close(force: true);
    });

    for (final method in const ['GET', 'HEAD']) {
      test('$method retries up to the configured count', () async {
        adapter.failuresRemaining = 2;

        final response = await dio.request<void>(
          '/resource',
          options: Options(method: method),
        );

        expect(response.statusCode, 200);
        expect(adapter.attempts, 3);
        expect(adapter.methods, everyElement(method));
      });
    }

    test('POST is not retried after an ambiguous transport failure', () async {
      adapter.failuresRemaining = 3;

      await expectLater(
        dio.post<void>('/write', data: {'value': 1}),
        throwsA(isA<DioException>()),
      );

      expect(adapter.attempts, 1);
    });

    test('multipart bodies are not replayed after transport failure', () async {
      adapter.failuresRemaining = 3;
      final formData = FormData.fromMap({'value': 'payload'});

      await expectLater(
        dio.post<void>('/upload', data: formData),
        throwsA(
          isA<DioException>().having(
            (error) => error.error,
            'underlying error',
            same(adapter.failureMarker),
          ),
        ),
      );

      expect(adapter.attempts, 1);
    });

    test('GET requests with multipart bodies are not replayed', () async {
      adapter.failuresRemaining = 3;
      final formData = FormData.fromMap({'value': 'payload'});

      await expectLater(
        dio.request<void>(
          '/upload',
          data: formData,
          options: Options(method: 'GET'),
        ),
        throwsA(
          isA<DioException>().having(
            (error) => error.error,
            'underlying error',
            same(adapter.failureMarker),
          ),
        ),
      );

      expect(adapter.attempts, 1);
    });
  });
}

class _FailingAdapter implements HttpClientAdapter {
  final Object failureMarker = Object();
  final List<String> methods = [];
  int failuresRemaining = 0;
  int attempts = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    attempts++;
    methods.add(options.method);
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'simulated ambiguous transport failure',
        error: failureMarker,
      );
    }
    return ResponseBody.fromString('', 200);
  }

  @override
  void close({bool force = false}) {}
}
