import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/services/download/download_manager.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory testDir;
  late Interceptor loopbackInterceptor;

  setUpAll(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_download_manager_test_',
    );
    appSupportDirPath = testDir.path;
    await GStorage.init();
    await GStorage.setting.putAll({
      SettingBoxKey.enableHttp2: false,
      SettingBoxKey.retryCount: 0,
    });

    Request();
    loopbackInterceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        final uri = options.uri;
        if (uri.host == InternetAddress.loopbackIPv4.address &&
            uri.scheme == 'https') {
          options.path = uri.replace(scheme: 'http').toString();
        }
        handler.next(options);
      },
    );
    Request.dio.interceptors.add(loopbackInterceptor);
  });

  tearDownAll(() async {
    Request.dio
      ..interceptors.remove(loopbackInterceptor)
      ..close(force: true);
    await GStorage.close();
    await testDir.delete(recursive: true);
  });

  test('restarts instead of appending when a server ignores Range', () async {
    final payload = List<int>.generate(16, (index) => index);
    final partial = payload.sublist(0, 5);
    final output = File(path.join(testDir.path, 'range-ignored.bin'));
    await output.writeAsBytes(partial);

    final server = await _serve(statusCode: HttpStatus.ok, body: payload);

    Object? error;
    final progress = <(int, int)>[];
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: (received, total) => progress.add((received, total)),
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${partial.length}-');
    expect(error, isNull);
    expect(manager.status, DownloadStatus.completed);
    expect(await output.readAsBytes(), payload);
    expect(progress.first, (0, payload.length));
  });

  test('appends a 206 response only at the requested offset', () async {
    final payload = List<int>.generate(16, (index) => index);
    final partial = payload.sublist(0, 5);
    final output = File(path.join(testDir.path, 'valid-range.bin'));
    await output.writeAsBytes(partial);

    final server = await _serve(
      statusCode: HttpStatus.partialContent,
      body: payload.sublist(partial.length),
      contentRange:
          'bytes ${partial.length}-${payload.length - 1}/${payload.length}',
    );

    Object? error;
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: null,
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${partial.length}-');
    expect(error, isNull);
    expect(manager.status, DownloadStatus.completed);
    expect(await output.readAsBytes(), payload);
  });

  test('rejects a 206 response for a different offset', () async {
    final payload = List<int>.generate(16, (index) => index);
    final partial = payload.sublist(0, 5);
    final output = File(path.join(testDir.path, 'invalid-range.bin'));
    await output.writeAsBytes(partial);

    final server = await _serve(
      statusCode: HttpStatus.partialContent,
      body: payload.sublist(partial.length + 1),
      contentRange:
          'bytes ${partial.length + 1}-${payload.length - 1}/${payload.length}',
    );

    Object? error;
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: null,
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${partial.length}-');
    expect(error, isNotNull);
    expect(manager.status, DownloadStatus.failDownload);
    expect(await output.readAsBytes(), partial);
  });

  test('does not append an HTTP 416 response body', () async {
    final payload = List<int>.generate(16, (index) => index);
    final output = File(path.join(testDir.path, 'range-complete.bin'));
    await output.writeAsBytes(payload);

    final server = await _serve(
      statusCode: HttpStatus.requestedRangeNotSatisfiable,
      body: 'range not satisfiable'.codeUnits,
      contentRange: 'bytes */${payload.length}',
    );

    Object? error;
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: null,
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${payload.length}-');
    expect(error, isNull);
    expect(manager.status, DownloadStatus.completed);
    expect(await output.readAsBytes(), payload);
  });

  test('rejects HTTP 416 when the remote length does not match', () async {
    final payload = List<int>.generate(16, (index) => index);
    final partial = payload.sublist(0, 5);
    final output = File(path.join(testDir.path, 'range-mismatch.bin'));
    await output.writeAsBytes(partial);

    final server = await _serve(
      statusCode: HttpStatus.requestedRangeNotSatisfiable,
      body: 'range not satisfiable'.codeUnits,
      contentRange: 'bytes */${payload.length}',
    );

    Object? error;
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: null,
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${partial.length}-');
    expect(error, isNotNull);
    expect(manager.status, DownloadStatus.failDownload);
    expect(await output.readAsBytes(), partial);
  });

  test('rejects an unexpected 2xx status without changing the file', () async {
    final payload = List<int>.generate(16, (index) => index);
    final partial = payload.sublist(0, 5);
    final output = File(path.join(testDir.path, 'unexpected-status.bin'));
    await output.writeAsBytes(partial);

    final server = await _serve(
      statusCode: HttpStatus.created,
      body: payload,
    );

    Object? error;
    final manager = DownloadManager(
      url: server.url,
      path: output.path,
      onReceiveProgress: null,
      onDone: ([value]) => error = value,
    );

    await manager.task;

    expect(await server.rangeHeader, 'bytes=${partial.length}-');
    expect(error, isNotNull);
    expect(manager.status, DownloadStatus.failDownload);
    expect(await output.readAsBytes(), partial);
  });
}

Future<({String url, Future<String?> rangeHeader})> _serve({
  required int statusCode,
  required List<int> body,
  String? contentRange,
}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  addTearDown(() => server.close(force: true));
  final rangeHeader = Completer<String?>();
  server.listen((request) async {
    final response = request.response
      ..statusCode = statusCode
      ..contentLength = body.length;
    if (contentRange != null) {
      response.headers.set(HttpHeaders.contentRangeHeader, contentRange);
    }
    response.add(body);
    await response.close();
    if (!rangeHeader.isCompleted) {
      rangeHeader.complete(request.headers.value(HttpHeaders.rangeHeader));
    }
  });
  return (
    url: 'http://${server.address.address}:${server.port}/media',
    rangeHeader: rangeHeader.future,
  );
}
