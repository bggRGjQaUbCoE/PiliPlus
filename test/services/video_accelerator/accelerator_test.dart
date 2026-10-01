// Keep arrange/act/assert steps separate in tests instead of cascading actions.
// ignore_for_file: cascade_invocations
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_diagnostics.dart';
import 'package:PiliPlus/services/video_accelerator/accelerator_session.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_probe.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_resolver.dart';
import 'package:PiliPlus/services/video_accelerator/cdn_stats.dart';
import 'package:PiliPlus/services/video_accelerator/media_source_rewriter.dart';

void main() {
  test('default and corrupt persisted modes are OFF', () {
    expect(const AcceleratorConfig().mode, AcceleratorMode.off);
    for (final value in [null, 'bad', 1, 'multiRange']) {
      expect(AcceleratorConfig.parseMode(value), AcceleratorMode.off);
    }
    expect(AcceleratorConfig.parseMode('smartCdn'), AcceleratorMode.smartCdn);
  });
  test('EWMA is debiased, time weighted and rejects nonfinite data', () {
    final ewma = ThroughputEwma(2);
    expect(ewma.value, isNull);
    ewma.sample(1, 100);
    expect(ewma.value, closeTo(100, 0.001));
    ewma.sample(1, 200);
    expect(ewma.value, greaterThan(150));
    final before = ewma.value;
    ewma.sample(0, 0);
    ewma.sample(1, double.nan);
    expect(ewma.value, before);
  });
  test('metrics use bits/s; cooldown and TTL have exact boundaries', () {
    final stats = CdnStats();
    stats.success(
      1000,
      const Duration(seconds: 1),
      const Duration(milliseconds: 20),
      Duration.zero,
    );
    expect(stats.throughputBps, closeTo(8000, 0.001));
    stats.blockedUntil = const Duration(seconds: 30);
    expect(stats.available(const Duration(seconds: 29)), isFalse);
    expect(stats.available(const Duration(seconds: 30)), isTrue);
    expect(
      stats.fresh(const Duration(seconds: 90), const Duration(seconds: 90)),
      isFalse,
    );
  });
  test('resolver deduplicates while preserving signed query and API backups', () {
    const original =
        'https://upos-sz-mirrorali.bilivideo.com/upgcxcode/a.m4s?sign=a%2Fb&x=1';
    final urls = CdnResolver.resolve(
      original: original,
      playUrls: [original, 'https://backup.bilivideo.com/a.m4s', 'file:///bad'],
      mirrorHosts: ['upos-sz-mirrorhw.bilivideo.com', 'evil.example.com'],
    );
    expect(urls.length, 3);
    expect(urls.first.toString(), original);
    expect(urls.last.query, urls.first.query);
    expect(urls.last.path, urls.first.path);
  });
  for (final donor in [
    'https://upos-sz-302.bilivideo.com/upgcxcode/a.m4s',
    'https://upos-sz-mirrorali.bilivideo.com/upgcxcode/a.m4s?os=mcdn',
    'https://upos-hz-mirrorakam.akamaized.net/upgcxcode/a.m4s',
    'https://1.2.3.4:4483/v1/resource/a.m4s',
  ]) {
    test('resolver does not synthesize from special donor $donor', () {
      expect(
        CdnResolver.resolve(
          original: donor,
          playUrls: [donor],
          mirrorHosts: ['upos-sz-mirrorhw.bilivideo.com'],
        ),
        hasLength(1),
      );
    });
  }
  test('exact EDL rewrite preserves audio and directives; audio-only supported', () {
    const a = 'https://a/v', b = 'https://a/audio', v = 'https://longer/video';
    const edl =
        'edl://!no_chapters;%${a.length}%$a;!new_stream;!no_chapters;%${b.length}%$b';
    expect(
      rewriteMediaSource(edl, a, b, v, b),
      'edl://!no_chapters;%${v.length}%$v;!new_stream;!no_chapters;%${b.length}%$b',
    );
    expect(
      rewriteMediaSource(b, a, b, v, 'https://b/audio'),
      'https://b/audio',
    );
    expect(
      () => rewriteMediaSource('edl://wrong', a, b, v, b),
      throwsStateError,
    );
  });

  group('session policy with fake clock and transport', () {
    late Duration time;
    late int requests;
    late AcceleratorTrack video;
    late AcceleratorSession session;
    late List<(String, String?)> switches;
    late bool switchOk;
    const active = 'https://a.bilivideo.com/v?secret=abc';
    const backup = 'https://b.bilivideo.com/v?secret=abc';
    Future<ProbeResult> transport(
      Uri uri,
      AcceleratorConfig _,
      ProbeCancellation token,
    ) async {
      requests++;
      return ProbeResult(
        bytes: 262144,
        elapsed: Duration(milliseconds: uri.host.startsWith('a.') ? 1000 : 400),
        ttfb: const Duration(milliseconds: 10),
        totalBytes: 10000000,
        status: 206,
      );
    }

    Future<void> low() => session.observe(
      bufferAheadSeconds: 1,
      throughputBps: 100,
      playing: true,
    );
    setUp(() {
      time = Duration.zero;
      requests = 0;
      switches = [];
      switchOk = true;
      video = AcceleratorTrack(
        kind: 'video',
        original: Uri.parse(active),
        candidates: [Uri.parse(active), Uri.parse(backup)],
        bitrateBps: 4000000,
      );
      session = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.smartCdn),
        tracks: [video],
        probe: transport,
        clock: () => time,
      );
      session.onSwitch = (v, a) async {
        switches.add((v, a));
        return switchOk;
      };
    });
    tearDown(() => session.dispose());
    test('OFF has no traffic or switching', () async {
      session.dispose();
      session = AcceleratorSession(
        config: const AcceleratorConfig(),
        tracks: [video],
        probe: transport,
        clock: () => time,
      );
      time = const Duration(minutes: 10);
      await low();
      expect(requests, 0);
      expect(switches, isEmpty);
    });
    test('sustained low buffer triggers two bounded sequential probes and a gain switch', () async {
      await low();
      expect(requests, 0);
      time = const Duration(seconds: 5);
      await low();
      expect(requests, 2);
      expect(video.active.toString(), backup);
      expect(session.switches, 1);
      expect(session.requiredBps, 6000000);
    });
    test(
      'low-buffer duration resets when buffer leaves the low band',
      () async {
        await low();
        time = const Duration(seconds: 4);
        await session.observe(
          bufferAheadSeconds: 12,
          throughputBps: 100,
          playing: true,
        );
        time = const Duration(seconds: 5);
        await low();
        expect(requests, 0);
        time = const Duration(seconds: 10);
        await low();
        expect(requests, 2);
      },
    );
    test('switch cooldown blocks repeat probes', () async {
      await low();
      time = const Duration(seconds: 5);
      await low();
      time = const Duration(seconds: 20);
      await low();
      time = const Duration(seconds: 40);
      await low();
      expect(requests, 2);
    });
    test(
      'high-bitrate video gets three rounds before low-bitrate audio',
      () async {
        final audio = AcceleratorTrack(
          kind: 'audio',
          original: Uri.parse('https://audio/a'),
          candidates: [
            Uri.parse('https://audio/a'),
            Uri.parse('https://audio/b'),
          ],
          bitrateBps: 82618,
        );
        final probed = <String>[];
        session.dispose();
        video.bitrateBps = 29006229;
        session = AcceleratorSession(
          config: const AcceleratorConfig(mode: AcceleratorMode.auto),
          tracks: [video, audio],
          clock: () => time,
          probe: (uri, config, token) async {
            probed.add(uri.host);
            return const ProbeResult(
              bytes: 262144,
              elapsed: Duration(seconds: 1),
            );
          },
        );
        session.onSwitch = (v, a) async => true;
        await low();
        for (final second in [5, 35, 65, 95]) {
          time = Duration(seconds: second);
          await low();
        }
        expect(probed.where((host) => host == 'a.bilivideo.com'), hasLength(3));
        expect(probed.where((host) => host == 'audio'), hasLength(2));
        expect(probed.take(6), everyElement(isNot('audio')));
      },
    );
    test('telemetry ticks preserve the in-flight probing state', () async {
      final result = Completer<ProbeResult>();
      session.dispose();
      session = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.auto),
        tracks: [video],
        clock: () => time,
        probe: (uri, config, token) => result.future,
      );
      session.onSwitch = (v, a) async => true;
      await low();
      time = const Duration(seconds: 5);
      final pending = low();
      time = const Duration(seconds: 6);
      await low();
      expect(session.state, 'probing');
      session.invalidate();
      result.complete(const ProbeResult(error: 'cancelled'));
      await pending;
    });
    test('healthy buffer and sufficient throughput never probe', () async {
      await session.observe(
        bufferAheadSeconds: 25,
        throughputBps: 100,
        playing: true,
      );
      time = const Duration(seconds: 10);
      await session.observe(
        bufferAheadSeconds: 1,
        throughputBps: 7000000,
        playing: true,
      );
      expect(requests, 0);
    });
    test('speed increases throughput requirement', () async {
      await session.observe(
        bufferAheadSeconds: 1,
        throughputBps: 7000000,
        playing: true,
        speed: 2,
      );
      time = const Duration(seconds: 5);
      await session.observe(
        bufferAheadSeconds: 1,
        throughputBps: 7000000,
        playing: true,
        speed: 2,
      );
      expect(requests, 2);
    });
    test(
      'opened source is not labeled recovered while buffer stays low',
      () async {
        await low();
        time = const Duration(seconds: 5);
        await low();
        session.publish();
        expect(
          AcceleratorDiagnostics.latest['switchOutcome'],
          'awaitingBufferRecovery',
        );
        time = const Duration(seconds: 50);
        await low();
        session.publish();
        expect(
          AcceleratorDiagnostics.latest['switchOutcome'],
          'stillLowBuffer',
        );
        await session.observe(
          bufferAheadSeconds: 25,
          throughputBps: 100,
          playing: true,
        );
        session.publish();
        expect(
          AcceleratorDiagnostics.latest['switchOutcome'],
          'bufferRecovered',
        );
      },
    );
    test('insufficient improvement retains current CDN', () async {
      session.dispose();
      session = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.auto),
        tracks: [video],
        clock: () => time,
        probe: (u, c, t) async {
          requests++;
          return const ProbeResult(
            bytes: 262144,
            elapsed: Duration(seconds: 1),
          );
        },
      );
      session.onSwitch = (v, a) async {
        switches.add((v, a));
        return true;
      };
      await low();
      time = const Duration(seconds: 5);
      await low();
      expect(switches, isEmpty);
      expect(video.active.toString(), active);
    });
    test('failed switch restores original and bypasses once', () async {
      switchOk = false;
      await low();
      time = const Duration(seconds: 5);
      await low();
      expect(session.bypassed, isTrue);
      expect(video.active.toString(), active);
      expect(switches.last.$1, active);
      time = const Duration(minutes: 5);
      await low();
      expect(requests, 2);
      await session.restoreOriginal();
      expect(switches.length, 2);
    });
    test('seek cancels late probes and excludes stale measurements', () async {
      final result = Completer<ProbeResult>();
      ProbeCancellation? cancellation;
      session.dispose();
      session = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.auto),
        tracks: [video],
        clock: () => time,
        probe: (u, c, token) {
          cancellation = token;
          return result.future;
        },
      );
      session.onSwitch = (v, a) async {
        switches.add((v, a));
        return true;
      };
      await low();
      time = const Duration(seconds: 5);
      final pending = low();
      session.invalidate();
      expect(cancellation!.cancelled, isTrue);
      result.complete(
        const ProbeResult(bytes: 262144, elapsed: Duration(seconds: 1)),
      );
      await pending;
      expect(video.stats, isEmpty);
      expect(switches, isEmpty);
    });
    test(
      'network change resets old network health and cancels generation',
      () async {
        await low();
        time = const Duration(seconds: 5);
        await low();
        expect(video.stats, isNotEmpty);
        session.invalidate(networkChanged: true);
        expect(video.stats, isEmpty);
        expect(session.generation, 1);
      },
    );
    test(
      'pause cancels a pending probe without charging CDN failures',
      () async {
        final result = Completer<ProbeResult>();
        ProbeCancellation? cancellation;
        session.dispose();
        session = AcceleratorSession(
          config: const AcceleratorConfig(mode: AcceleratorMode.auto),
          tracks: [video],
          clock: () => time,
          probe: (u, c, token) {
            cancellation = token;
            return result.future;
          },
        );
        session.onSwitch = (v, a) async => true;
        await low();
        time = const Duration(seconds: 5);
        final pending = low();
        await session.observe(
          bufferAheadSeconds: 1,
          throughputBps: 0,
          playing: false,
        );
        expect(cancellation!.cancelled, isTrue);
        result.complete(const ProbeResult(error: 'cancelled'));
        await pending;
        expect(video.stats, isEmpty);
      },
    );
    test(
      'different media fingerprints never switch despite speed gain',
      () async {
        session.dispose();
        session = AcceleratorSession(
          config: const AcceleratorConfig(mode: AcceleratorMode.auto),
          tracks: [video],
          clock: () => time,
          probe: (u, c, token) async => ProbeResult(
            bytes: 262144,
            totalBytes: 10000000,
            fingerprint: u.host,
            elapsed: Duration(
              milliseconds: u.host.startsWith('a.') ? 1000 : 100,
            ),
          ),
        );
        session.onSwitch = (v, a) async {
          switches.add((v, a));
          return true;
        };
        await low();
        time = const Duration(seconds: 5);
        await low();
        expect(switches, isEmpty);
        expect(session.state, 'resourceMismatch');
      },
    );
    test(
      'unknown bitrate is estimated from length/duration and audio preserved',
      () async {
        final audio = AcceleratorTrack(
          kind: 'audio',
          original: Uri.parse('https://audio/a'),
          candidates: [Uri.parse('https://audio/a')],
          bitrateBps: 192000,
        );
        session.dispose();
        video = AcceleratorTrack(
          kind: 'video',
          original: Uri.parse(active),
          candidates: [Uri.parse(active), Uri.parse(backup)],
          durationSeconds: 100,
        );
        session = AcceleratorSession(
          config: const AcceleratorConfig(mode: AcceleratorMode.auto),
          tracks: [video, audio],
          clock: () => time,
          probe: transport,
        );
        session.onSwitch = (v, a) async {
          switches.add((v, a));
          return true;
        };
        expect(session.requiredBps, 0);
        await low();
        time = const Duration(seconds: 5);
        await low();
        expect(video.bitrateBps, 800000);
        expect(switches.single.$2, 'https://audio/a');
      },
    );
    test('diagnostics contain hosts but never signed URLs', () {
      session.publish();
      expect(
        AcceleratorDiagnostics.latest.toString(),
        isNot(contains('secret')),
      );
      expect(
        AcceleratorDiagnostics.latest.toString(),
        isNot(contains('https://')),
      );
    });
    test('two refused signatures notify upper layer once and bypass', () async {
      var refreshes = 0;
      session.dispose();
      session = AcceleratorSession(
        config: const AcceleratorConfig(mode: AcceleratorMode.auto),
        tracks: [video],
        clock: () => time,
        probe: (u, c, token) async =>
            const ProbeResult(status: 403, error: 'range-status'),
      );
      session.onSwitch = (v, a) async => true;
      session.onRefreshRequired = () => refreshes++;
      await low();
      time = const Duration(seconds: 5);
      await low();
      time = const Duration(minutes: 2);
      await low();
      expect(refreshes, 1);
      expect(session.bypassed, isTrue);
    });
  });

  group('real localhost Range probe', () {
    late HttpServer server;
    late Uri uri;
    var status = 206, total = 1000000;
    String? badRange;
    var delay = Duration.zero;
    String? rangeHeader, referer, encoding;
    const config = AcceleratorConfig(
      probeBytes: 32768,
      probeTimeout: Duration(milliseconds: 500),
    );
    setUp(() async {
      status = 206;
      total = 1000000;
      badRange = null;
      delay = Duration.zero;
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      uri = Uri.parse('http://127.0.0.1:${server.port}/v');
      server.listen((request) async {
        try {
          rangeHeader = request.headers.value('range');
          referer = request.headers.value('referer');
          encoding = request.headers.value('accept-encoding');
          await Future<void>.delayed(delay);
          final response = request.response..statusCode = status;
          if (status == 206) {
            final length = total < config.probeBytes
                ? total
                : config.probeBytes;
            response.headers.set(
              'content-range',
              badRange ?? 'bytes 0-${length - 1}/$total',
            );
            response.contentLength = length;
            response.add(List<int>.filled(length, 7));
          } else {
            response.contentLength = 0;
          }
          await response.close();
        } catch (_) {
          /* Client cancellation intentionally closes sockets. */
        }
      });
    });
    tearDown(() => server.close(force: true));
    Future<ProbeResult> run([ProbeCancellation? cancellation]) => CdnProbe(
      headers: {
        'referer': 'https://www.bilibili.com',
        'user-agent': 'PiliBoost-test',
      },
    ).run(uri, config, cancellation ?? ProbeCancellation());
    test(
      'validated 206 is bounded, has media headers and real throughput',
      () async {
        final result = await run();
        expect(result.ok, isTrue);
        expect(result.bytes, 32768);
        expect(result.totalBytes, total);
        expect(result.throughputBps, greaterThan(0));
        expect(rangeHeader, 'bytes=0-32767');
        expect(encoding, 'identity');
        expect(referer, 'https://www.bilibili.com');
      },
    );
    for (final code in [200, 403, 404, 416, 429, 500]) {
      test('rejects status $code instead of treating it as a chunk', () async {
        status = code;
        final result = await run();
        expect(result.ok, isFalse);
        expect(result.status, code);
        expect(result.bytes, 0);
      });
    }
    test('wrong Content-Range is rejected', () async {
      badRange = 'bytes 1-32768/1000000';
      expect((await run()).error, 'range-mismatch');
    });
    test('small metadata samples are rejected', () async {
      total = 100;
      expect((await run()).error, 'short-body');
    });
    test('total timeout closes the request', () async {
      delay = const Duration(seconds: 1);
      expect((await run()).timeout, isTrue);
    });
    test('cancelled probe opens no request', () async {
      final token = ProbeCancellation()..cancel();
      expect((await run(token)).error, 'cancelled');
    });
  });
}
