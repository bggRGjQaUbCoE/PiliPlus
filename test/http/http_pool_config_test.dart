import 'dart:io';

import 'package:PiliPlus/http/init.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('proxy TLS configuration', () {
    final proxy = Uri.parse('http://127.0.0.1:8080');

    test('HTTP/1.1 proxy preserves certificate validation by default', () {
      final client = _RecordingHttpClient();

      configureHttp11Client(
        client,
        proxy: proxy,
        allowBadCertificates: false,
      );

      expect(
        client.proxy?.call(Uri.https('example.com', '/')),
        'PROXY 127.0.0.1:8080',
      );
      expect(client.recordedBadCertificateCallback, isNull);
    });

    test('HTTP/2 proxy preserves certificate validation by default', () {
      final config = ClientSetting();

      configureHttp2Client(
        config,
        proxy: proxy,
        allowBadCertificates: false,
      );

      expect(config.proxy, proxy);
      expect(config.onBadCertificate, isNull);
    });

    test('explicit certificate override remains available', () {
      final http11Client = _RecordingHttpClient();
      final http2Config = ClientSetting();

      configureHttp11Client(
        http11Client,
        proxy: proxy,
        allowBadCertificates: true,
      );
      configureHttp2Client(
        http2Config,
        proxy: proxy,
        allowBadCertificates: true,
      );

      expect(http11Client.recordedBadCertificateCallback, isNotNull);
      expect(http2Config.onBadCertificate, isNotNull);
    });
  });
}

class _RecordingHttpClient implements HttpClient {
  String Function(Uri)? proxy;
  bool Function(X509Certificate, String, int)? recordedBadCertificateCallback;

  @override
  set autoUncompress(bool value) {}

  @override
  set badCertificateCallback(
    bool Function(X509Certificate cert, String host, int port)? callback,
  ) {
    recordedBadCertificateCallback = callback;
  }

  @override
  set findProxy(String Function(Uri url)? callback) {
    proxy = callback;
  }

  @override
  set idleTimeout(Duration value) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
