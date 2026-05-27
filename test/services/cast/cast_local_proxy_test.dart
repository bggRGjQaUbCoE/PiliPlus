import 'package:PiliPlus/services/cast/cast_local_proxy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CastLocalProxyPolicy shouldProxy', () {
    test('returns true for .m4s video segment URLs', () {
      expect(
        CastLocalProxyPolicy.shouldProxy(
          'https://example.com/video/80.m4s',
        ),
        isTrue,
      );
    });

    test('returns true for .m4s audio segment URLs', () {
      expect(
        CastLocalProxyPolicy.shouldProxy(
          'https://example.com/audio/30280.m4s',
        ),
        isTrue,
      );
    });

    test('returns true for .m4s URLs with query parameters', () {
      expect(
        CastLocalProxyPolicy.shouldProxy(
          'https://example.com/video/80.m4s?token=abc&expires=123',
        ),
        isTrue,
      );
    });

    test('returns false for .mpd manifest URLs', () {
      expect(
        CastLocalProxyPolicy.shouldProxy(
          'https://example.com/dash/manifest.mpd',
        ),
        isFalse,
      );
    });

    test('returns false for non-media HTTP URLs', () {
      expect(
        CastLocalProxyPolicy.shouldProxy('https://example.com/page.html'),
        isFalse,
      );
    });

    test('returns false for empty URL', () {
      expect(CastLocalProxyPolicy.shouldProxy(''), isFalse);
    });

    test('returns false for data URIs', () {
      expect(
        CastLocalProxyPolicy.shouldProxy('data:image/png;base64,abc'),
        isFalse,
      );
    });
  });

  group('CastLocalProxyPolicy buildProxyUrl', () {
    test('returns a localhost URL with proxy port', () {
      final proxyUrl = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/80.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );

      expect(proxyUrl.scheme, 'http');
      expect(proxyUrl.host, '127.0.0.1');
      expect(proxyUrl.port, 9999);
    });

    test('encodes the remote URL into the proxy path', () {
      final proxyUrl = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/80.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );

      final path = proxyUrl.path;
      expect(path, contains('dash'));
      expect(path, contains('proxy'));
    });

    test('produces deterministic proxy URLs for the same input', () {
      final a = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/80.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );
      final b = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/80.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );

      expect(a.toString(), b.toString());
    });

    test('produces different proxy paths for different remote URLs', () {
      final a = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/80.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );
      final b = CastLocalProxyPolicy.buildProxyUrl(
        'https://example.com/video/64.m4s',
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );

      expect(a.toString(), isNot(b.toString()));
    });
  });

  group('CastLocalProxyPolicy extractRemoteUrl', () {
    test(
      'round-trips a remote URL through buildProxyUrl and extractRemoteUrl',
      () {
        const remoteUrl = 'https://example.com/video/80.m4s';
        final proxyUrl = CastLocalProxyPolicy.buildProxyUrl(
          remoteUrl,
          proxyHost: '127.0.0.1',
          proxyPort: 9999,
        );

        final extracted = CastLocalProxyPolicy.extractRemoteUrl(proxyUrl.path);

        expect(extracted, remoteUrl);
      },
    );

    test('round-trips a remote URL with query parameters', () {
      const remoteUrl = 'https://example.com/video/80.m4s?token=abc';
      final proxyUrl = CastLocalProxyPolicy.buildProxyUrl(
        remoteUrl,
        proxyHost: '127.0.0.1',
        proxyPort: 9999,
      );

      final extracted = CastLocalProxyPolicy.extractRemoteUrl(proxyUrl.path);

      expect(extracted, remoteUrl);
    });

    test('returns null for paths not matching the proxy path shape', () {
      final extracted = CastLocalProxyPolicy.extractRemoteUrl(
        '/some/other/path',
      );

      expect(extracted, isNull);
    });

    test('returns null for an empty path', () {
      final extracted = CastLocalProxyPolicy.extractRemoteUrl('');

      expect(extracted, isNull);
    });
  });

  group('CastLocalProxyPolicy CORS headers', () {
    test('allows any origin', () {
      expect(
        CastLocalProxyPolicy.corsHeaders['Access-Control-Allow-Origin'],
        '*',
      );
    });

    test('allows GET and HEAD methods', () {
      final methods =
          CastLocalProxyPolicy.corsHeaders['Access-Control-Allow-Methods'];
      expect(methods, isNotNull);
      expect(methods, contains('GET'));
      expect(methods, contains('HEAD'));
    });

    test('exposes Content-Type header to the client', () {
      final exposed =
          CastLocalProxyPolicy.corsHeaders['Access-Control-Expose-Headers'];
      expect(exposed, isNotNull);
      expect(exposed, contains('Content-Type'));
    });

    test('allows Content-Type, Origin, and Accept in addition to Range', () {
      final allowHeaders =
          CastLocalProxyPolicy.corsHeaders['Access-Control-Allow-Headers'];
      expect(allowHeaders, isNotNull);
      expect(allowHeaders, contains('Range'));
      expect(allowHeaders, contains('Content-Type'));
      expect(allowHeaders, contains('Origin'));
      expect(allowHeaders, contains('Accept'));
    });
  });

  group('CastLocalProxyPolicy dashProxyPathPrefix', () {
    test('exposes a non-empty DASH path prefix', () {
      expect(CastLocalProxyPolicy.dashProxyPathPrefix, isNotEmpty);
    });

    test('prefix is a path segment starting with a slash', () {
      expect(
        CastLocalProxyPolicy.dashProxyPathPrefix.startsWith('/'),
        isTrue,
      );
      expect(
        CastLocalProxyPolicy.dashProxyPathPrefix.endsWith('/'),
        isFalse,
      );
    });
  });
}
