// ignore_for_file: cascade_invocations
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:PiliPlus/services/video_accelerator/local_stream_server.dart';
import 'package:PiliPlus/services/video_accelerator/range_protocol.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_session.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_probe.dart';

void main() {
  test('single ranges resolve bounded, open ended and suffix requests', () {
    expect(ByteRange.parse('bytes=2-9').resolve(8), (2, 7));
    expect(ByteRange.parse('bytes=2-').resolve(8), (2, 7));
    expect(ByteRange.parse('bytes=-3').resolve(8), (5, 7));
    expect(ByteRange.parse('bytes=-30').resolve(8), (0, 7));
    expect(ByteRange.parse('bytes=8-').resolve(8), isNull);
    expect(
      ContentRange.parse('bytes 2-7/8').matches(ByteRange.parse('bytes=2-9')),
      isTrue,
    );
  });
  for (final value in [
    'bytes=-',
    'bytes=-0',
    'bytes=7-2',
    'bytes=0-1,3-4',
    'items=0-1',
    'bytes=9999999999999999999999-',
  ]) {
    test('reject malformed range $value', () {
      expect(() => ByteRange.parse(value), throwsFormatException);
    });
  }

  group('real loopback relay', () {
    late HttpServer origin;
    late LocalStreamServer relay;
    late HttpClient consumer;
    late Uri source;
    final bytes = List<int>.generate(65536, (i) => i % 251);
    var failure = 0, hits = 0, mode = 'normal';
    String? seenRange, seenQuery, seenReferer, seenEncoding, seenPath;
    setUp(() async {
      failure = hits = 0;
      mode = 'normal';
      origin = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      source = Uri.parse('http://127.0.0.1:${origin.port}/a?sign=a%2Fb');
      origin.listen((r) async {
        try {
          hits++;
          seenRange = r.headers.value('range');
          seenQuery = r.uri.query;
          seenReferer = r.headers.value('referer');
          seenEncoding = r.headers.value('accept-encoding');
          seenPath = r.uri.path;
          if (mode == 'timeout') {
            await Future<void>.delayed(const Duration(milliseconds: 300));
          }
          final range = seenRange == null ? null : ByteRange.parse(seenRange!);
          final bounds = range?.resolve(bytes.length);
          if (range != null && bounds == null) {
            r.response.statusCode = 416;
            r.response.headers.set('content-range', 'bytes */${bytes.length}');
            r.response.contentLength = 0;
          } else {
            final (a, b) = bounds ?? (0, bytes.length - 1);
            r.response.statusCode = mode == 'ignored'
                ? 200
                : range == null
                ? 200
                : 206;
            if (range != null) {
              r.response.headers.set(
                'content-range',
                mode == 'badRange'
                    ? 'bytes 1-3/${bytes.length}'
                    : 'bytes $a-$b/${bytes.length}',
              );
            }
            r.response.headers.set('accept-ranges', 'bytes');
            r.response.headers.set('content-type', 'video/mp4');
            r.response.contentLength = b - a + 1;
            if (r.method != 'HEAD') r.response.add(bytes.sublist(a, b + 1));
          }
          await r.response.close();
        } catch (_) {
          /* Test cancellation intentionally closes origin sockets. */
        }
      });
      relay = LocalStreamServer(
        source: () => source,
        headers: {
          'referer': 'https://www.bilibili.com',
          'user-agent': 'fixture',
        },
        clientFactory: HttpClient.new,
        timeout: const Duration(milliseconds: 150),
        onFailure: () => failure++,
      );
      await relay.start();
      consumer = HttpClient();
    });
    tearDown(() async {
      consumer.close(force: true);
      await relay.close();
      await origin.close(force: true);
    });
    Future<(int, List<int>, HttpHeaders)> fetch({
      String? range,
      String method = 'GET',
      Uri? uri,
    }) async {
      final r = await consumer.openUrl(method, uri ?? relay.uri);
      if (range != null) r.headers.set('range', range);
      final response = await r.close();
      final body = await response.fold<List<int>>([], (a, b) => a..addAll(b));
      return (response.statusCode, body, response.headers);
    }

    for (final range in ['bytes=1024-2047', 'bytes=64000-', 'bytes=-1024']) {
      test(
        'exact bytes for $range, preserved remote signature and headers',
        () async {
          final (status, body, headers) = await fetch(range: range);
          final (a, b) = ByteRange.parse(range).resolve(bytes.length)!;
          expect(status, 206);
          expect(body, bytes.sublist(a, b + 1));
          expect(headers.value('content-range'), 'bytes $a-$b/${bytes.length}');
          expect(seenQuery, 'sign=a%2Fb');
          expect(seenReferer, 'https://www.bilibili.com');
          expect(seenEncoding, 'identity');
          expect(seenRange, range);
          expect(relay.forwardedBytes, body.length);
          expect(relay.throughputBps, greaterThan(0));
          expect(failure, 0);
        },
      );
    }
    test(
      'GET without range and HEAD retain content length and body semantics',
      () async {
        final full = await fetch();
        expect(full.$1, 200);
        expect(full.$2, bytes);
        final head = await fetch(method: 'HEAD');
        expect(head.$1, 200);
        expect(head.$2, isEmpty);
        expect(head.$3.contentLength, bytes.length);
        expect(relay.forwardedBytes, bytes.length);
      },
    );
    test(
      '416 preserves unsatisfied length without marking CDN failure',
      () async {
        final response = await fetch(range: 'bytes=999999-');
        expect(response.$1, 416);
        expect(response.$2, isEmpty);
        expect(response.$3.value('content-range'), 'bytes */${bytes.length}');
        expect(failure, 0);
      },
    );
    test(
      'reject unregistered route, target query, method and multipart locally',
      () async {
        expect((await fetch(uri: relay.uri.replace(path: '/invalid'))).$1, 404);
        expect(
          (await fetch(uri: relay.uri.replace(query: 'target=https://other')))
              .$1,
          404,
        );
        expect((await fetch(method: 'POST')).$1, 405);
        expect((await fetch(range: 'bytes=0-1,3-4')).$1, 400);
        expect(hits, 0);
      },
    );
    for (final bad in ['ignored', 'badRange', 'timeout']) {
      test('$bad upstream returns 502 and triggers recovery', () async {
        mode = bad;
        final result = await fetch(range: 'bytes=0-1023');
        expect(result.$1, 502);
        expect(result.$2, isEmpty);
        expect(failure, 1);
        expect(relay.forwardedBytes, 0);
      });
    }
    test(
      'session proxy failure restores original video and audio once',
      () async {
        mode = 'badRange';
        final recovered = <(String, String?)>[];
        final s = AcceleratorSession(
          config: const AcceleratorConfig(mode: AcceleratorMode.rangeProxy),
          tracks: [
            AcceleratorTrack(
              kind: 'video',
              original: source,
              candidates: [source],
            ),
            AcceleratorTrack(
              kind: 'audio',
              original: Uri.parse('https://audio/track'),
              candidates: [],
            ),
          ],
          probe: (a, b, c) async => const ProbeResult(),
        );
        s.onSwitch = (v, a) async {
          recovered.add((v, a));
          return true;
        };
        await s.startProxy(
          create: (source, failure) => LocalStreamServer(
            source: source,
            headers: const {},
            clientFactory: HttpClient.new,
            onFailure: failure,
          ),
        );
        try {
          await fetch(range: 'bytes=0-1023', uri: s.proxy!.uri);
        } catch (_) {
          /* Recovery may close the downstream before its 502. */
        }
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(s.bypassed, isTrue);
        expect(recovered, [(source.toString(), 'https://audio/track')]);
        await s.restoreOriginal();
        expect(recovered, hasLength(1));
        s.dispose();
      },
    );
    test('stable local URI routes later requests to selected source', () async {
      final local = relay.uri;
      await fetch(range: 'bytes=0-1023');
      source = source.replace(path: '/b');
      final next = await fetch(range: 'bytes=1024-2047');
      expect(relay.uri, local);
      expect(next.$2, bytes.sublist(1024, 2048));
      expect(seenPath, '/b');
    });
    test(
      'seek invalidation cancels pending source without CDN penalty',
      () async {
        mode = 'timeout';
        final pending = fetch(range: 'bytes=0-1023');
        await Future<void>.delayed(const Duration(milliseconds: 25));
        relay.cancelRequests();
        expect((await pending).$1, 502);
        expect(failure, 0);
        expect(relay.cancellations, 1);
      },
    );
  });
  test('OFF never starts a proxy or allocates its server', () async {
    final s = AcceleratorSession(
      config: const AcceleratorConfig(),
      tracks: [],
      probe: (a, b, c) async => const ProbeResult(),
    );
    await s.startProxy(
      create: (_, _) => throw StateError('unexpected factory'),
    );
    expect(s.proxy, isNull);
    s.dispose();
  });
  test(
    'proxy mode does not pretend deferred CDN selection is a source switch',
    () async {
      var probes = 0;
      var now = Duration.zero;
      final s = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.rangeProxy),
        tracks: [],
        clock: () => now,
        probe: (a, b, c) async {
          probes++;
          return const ProbeResult();
        },
      );
      await s.observe(bufferAheadSeconds: 0, throughputBps: 0, playing: true);
      now = const Duration(minutes: 1);
      await s.observe(bufferAheadSeconds: 0, throughputBps: 0, playing: true);
      expect(probes, 0);
      expect(s.switches, 0);
      expect(s.decisionReason, 'proxyObservationOnly');
      s.dispose();
    },
  );
}
