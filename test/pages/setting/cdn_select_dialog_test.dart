import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:PiliPlus/models/common/video/cdn_type.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/pages/setting/widgets/select_dialog.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

// Exercise the real Dio adapter and widget lifecycle without opening sockets.
class _Headers extends Fake implements HttpHeaders {
  final _values = <String, List<String>>{};

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _values[name.toLowerCase()] = [value.toString()];
  }

  @override
  void forEach(void Function(String, List<String>) action) {
    _values.forEach(action);
  }
}

class _Response extends StreamView<List<int>> implements HttpClientResponse {
  @override
  final int statusCode;

  @override
  final HttpHeaders headers = _Headers()
    ..set(HttpHeaders.contentTypeHeader, 'video/mp4');

  _Response(super.stream, this.statusCode);

  @override
  bool get isRedirect => false;

  @override
  List<RedirectInfo> get redirects => const [];

  @override
  String get reasonPhrase => statusCode == 200 ? 'OK' : 'Forbidden';

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _Request extends Fake implements HttpClientRequest {
  @override
  final Uri uri;
  final int status;
  late final StreamController<List<int>> body = StreamController<List<int>>(
    onCancel: () => sourceCancelled = true,
  );
  bool aborted = false;
  bool sourceCancelled = false;

  @override
  final HttpHeaders headers = _Headers();

  @override
  bool followRedirects = true;

  @override
  int maxRedirects = 5;

  @override
  bool persistentConnection = true;

  _Request(this.uri, this.status);

  @override
  Future<HttpClientResponse> close() async => _Response(body.stream, status);

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {
    aborted = true;
    unawaited(body.close());
  }
}

class _Client extends Fake implements HttpClient {
  final List<int> statuses;
  final requests = <_Request>[];
  bool closed = false;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = Duration.zero;

  _Client({this.statuses = const []});

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    expect(method, 'GET');
    final index = requests.length;
    final request = _Request(
      url,
      index < statuses.length ? statuses[index] : 200,
    );
    requests.add(request);
    return request;
  }

  @override
  void close({bool force = false}) {
    closed = true;
    if (force) {
      for (final request in requests) {
        request.abort();
      }
    }
  }
}

VideoItem _sample() => VideoItem(
  id: VideoQuality.high1080.code,
  quality: VideoQuality.high1080,
  baseUrl: 'https://upos-sz-mirrorali.bilivideo.com/upgcxcode/sample.m4s',
  backupUrl: [
    'https://upos-sz-mirrorcos.bilivideo.com/upgcxcode/sample.m4s',
  ],
);

double? _progress(WidgetTester tester) => tester
    .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
    .value;

// Dio schedules interceptor steps as timer events, not only microtasks.
Future<void> _flushNetwork(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

Future<void> _show(WidgetTester tester, _Client client) =>
    HttpOverrides.runZoned(
      () async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: CdnSelectDialog(sample: _sample())),
          ),
        );
        await _flushNetwork(tester);
      },
      createHttpClient: (_) => client,
    );

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'piliplus-cdn-dialog-test-',
    );
    Hive.init(tempDir.path);
    GStorage.setting = await Hive.openBox('setting');
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  testWidgets('serial queue advances after failure and short EOF', (
    tester,
  ) async {
    final client = _Client(statuses: [403]);
    await _show(tester, client);
    expect(client.requests, hasLength(1));
    expect(_progress(tester), 0);

    for (final service in CDNService.values) {
      final index = service.index;
      // A stalled node must never start the following node in the queue.
      await tester.pump(const Duration(milliseconds: 100));
      expect(client.requests, hasLength(index + 1));
      final request = client.requests[index];
      expect(
        request.uri.toString(),
        VideoUtils.getCdnUrl(_sample().playUrls, defaultCDNService: service),
      );
      expect(_progress(tester), index / CDNService.values.length);
      request.body.add(Uint8List.fromList([1, 2, 3, 4]));
      unawaited(request.body.close());
      await _flushNetwork(tester);
      expect(_progress(tester), (index + 1) / CDNService.values.length);
    }

    expect(client.requests, hasLength(CDNService.values.length));
    expect(
      find.textContaining('MB/s'),
      findsNWidgets(CDNService.values.length - 1),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await _flushNetwork(tester);
  });

  testWidgets('sample limit cancels the active request and advances once', (
    tester,
  ) async {
    final client = _Client();
    await _show(tester, client);
    final first = client.requests.single;
    first.body.add(Uint8List(8 * 1024 * 1024));
    await _flushNetwork(tester);

    expect(first.aborted, isTrue);
    expect(first.sourceCancelled, isTrue);
    expect(client.requests, hasLength(2));
    expect(_progress(tester), 1 / CDNService.values.length);
    expect(find.textContaining('MB/s'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await _flushNetwork(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposing cancels the active request without starting another', (
    tester,
  ) async {
    final client = _Client();
    await _show(tester, client);
    final first = client.requests.single;
    first.body.add(Uint8List(64));
    await _flushNetwork(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 16));

    expect(client.closed, isTrue);
    expect(first.aborted, isTrue);
    expect(first.sourceCancelled, isTrue);
    expect(client.requests, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('disabled speed tests do not start network requests', (
    tester,
  ) async {
    await tester.runAsync(
      () => GStorage.setting.put(SettingBoxKey.cdnSpeedTest, false),
    );
    final client = _Client();
    await _show(tester, client);
    expect(client.requests, isEmpty);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(
      () => GStorage.setting.put(SettingBoxKey.cdnSpeedTest, true),
    );
  });
}
