// BTR proxy: a loopback HTTP server that serves Bilibili media to mpv while
// fetching each requested range as many small chunks in parallel, spread
// across several CDN mirrors. Ported idea from
// https://github.com/MrTangLuyao/Bilibili-thread-ripper (MIT).
//
// Pure dart:io so it can be exercised outside Flutter (see tool/btr_bench.dart).

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

enum BtrCdnMode {
  mainland('大陆'),
  overseas('海外'),
  custom('自定义');

  final String label;
  const BtrCdnMode(this.label);
}

enum BtrTakeover {
  full('全接管'),
  compat('兼容模式');

  final String label;
  const BtrTakeover(this.label);
}

/// Runtime config. The app fills this from settings (see BtrSettings);
/// the bench tool leaves the defaults.
class BtrConfig {
  static bool enabled = true;
  static BtrCdnMode mode = BtrCdnMode.mainland;
  static List<String> customHosts = const [];
  static BtrTakeover takeover = BtrTakeover.full;
  static bool autoThreads = true;
  static int threads = 8;
  static bool liveBoost = true;

  static const threadOptions = [2, 4, 6, 8, 12, 16, 24, 32];

  static const mainlandHosts = [
    'upos-sz-mirrorali.bilivideo.com',
    'upos-sz-mirrorhw.bilivideo.com',
    'upos-sz-mirrorbos.bilivideo.com',
    'upos-sz-mirror08c.bilivideo.com',
    'upos-sz-mirrorbd.bilivideo.com',
    'upos-sz-mirror14b.bilivideo.com',
    'upos-sz-estgoss.bilivideo.com',
    'upos-sz-mirrorcos.bilivideo.com',
  ];

  static const overseasHosts = [
    'upos-sz-mirrorcosov.bilivideo.com',
    'upos-sz-mirroraliov.bilivideo.com',
    'upos-sz-mirrorhwov.bilivideo.com',
    'cn-hk-eq-01-01.bilivideo.com',
    'cn-hk-eq-01-03.bilivideo.com',
  ];

  static List<String> get hosts => switch (mode) {
    BtrCdnMode.mainland => mainlandHosts,
    BtrCdnMode.overseas => overseasHosts,
    BtrCdnMode.custom => customHosts.isEmpty ? mainlandHosts : customHosts,
  };
}

class BtrProxy {
  BtrProxy._();
  static final BtrProxy instance = BtrProxy._();

  static const chunkSize = 512 * 1024;
  static const firstChunkSize = 128 * 1024;
  static const probeBytes = 256 * 1024;

  static const userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';
  static const referer = 'https://www.bilibili.com/';

  static final _mediaHost = RegExp(
    r'(?:^|\.)(?:bilivideo\.(?:com|cn|net)|akamaized\.net)$',
    caseSensitive: false,
  );

  HttpServer? _server;
  Future<HttpServer>? _starting;
  final Map<String, _Source> _sources = {};
  int _seq = 0;

  final HttpClient _client = HttpClient()
    ..maxConnectionsPerHost = 32
    ..connectionTimeout = const Duration(seconds: 4)
    ..idleTimeout = const Duration(seconds: 20)
    ..autoUncompress = false;

  /// Live stats for the settings page.
  int get activeThreads =>
      _sources.values.fold(0, (s, e) => s + e.inflightTotal);

  static bool isMediaUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.scheme.startsWith('http') &&
        _mediaHost.hasMatch(uri.host);
  }

  static bool _isUpos(Uri uri) =>
      uri.host.startsWith('upos-') && uri.path.contains('/upgcxcode/');

  /// VOD entry point. Full takeover: returns a loopback URL served by the
  /// multi-thread proxy. Compat: returns a direct URL on the fastest mirror,
  /// mpv downloads it itself. Falls back to [url] on any problem.
  Future<String> wrap(String url) async {
    if (!BtrConfig.enabled || !isMediaUrl(url)) return url;
    try {
      if (BtrConfig.takeover == BtrTakeover.compat) {
        return await _fastestMirror(url);
      }
      await _ensureServer();
    } catch (_) {
      return url;
    }
    final id = (++_seq).toString();
    _sources[id] = _Source(url)..discover(this);
    while (_sources.length > 16) {
      _sources.remove(_sources.keys.first);
    }
    return 'http://127.0.0.1:${_server!.port}/v/$id';
  }

  /// Live entry point: race all hosts the API offered (plus nothing else —
  /// live signatures are host-bound) and keep the fastest one.
  /// Skips P2P-style mcdn hosts unless they're the only option.
  Future<String> pickLive(List<String> urls) async {
    if (!BtrConfig.enabled || !BtrConfig.liveBoost || urls.length < 2) {
      return urls.first;
    }
    final official = urls
        .where((u) => !RegExp(r'mcdn|szbdyd').hasMatch(Uri.parse(u).host))
        .toList();
    final pool = official.isEmpty ? urls : official;
    try {
      return await _race(pool, liveBytes: true);
    } catch (_) {
      return pool.first;
    }
  }

  Future<String> _fastestMirror(String url) async {
    final uri = Uri.parse(url);
    if (!_isUpos(uri)) return url;
    final pool = {
      url,
      for (final h in BtrConfig.hosts) uri.replace(host: h).toString(),
    }.toList();
    return _race(pool);
  }

  /// Fires a small download at every candidate, returns the first to finish.
  Future<String> _race(List<String> pool, {bool liveBytes = false}) {
    final done = Completer<String>();
    var left = pool.length;
    for (final c in pool) {
      () async {
        try {
          final req = await _client.getUrl(Uri.parse(c));
          _headers(req);
          if (!liveBytes) {
            req.headers.set(
              HttpHeaders.rangeHeader,
              'bytes=0-${probeBytes - 1}',
            );
          }
          final resp = await req.close().timeout(const Duration(seconds: 3));
          if (resp.statusCode >= 300) throw HttpException('${resp.statusCode}');
          var got = 0;
          await for (final b in resp.timeout(const Duration(seconds: 3))) {
            got += b.length;
            if (got >= probeBytes) break; // live streams never end
          }
          if (!done.isCompleted) done.complete(c);
        } catch (_) {
        } finally {
          if (--left == 0 && !done.isCompleted) done.complete(pool.first);
        }
      }();
    }
    return done.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => pool.first,
    );
  }

  static void _headers(HttpClientRequest req) => req.headers
    ..set(HttpHeaders.userAgentHeader, userAgent)
    ..set(HttpHeaders.refererHeader, referer);

  Future<HttpServer> _ensureServer() {
    if (_server != null) return Future.value(_server);
    return _starting ??= HttpServer.bind(InternetAddress.loopbackIPv4, 0)
        .then((s) {
          _server = s;
          s.listen(_handle, onError: (_) {});
          return s;
        })
        .whenComplete(() => _starting = null);
  }

  Future<void> close() async {
    await _server?.close(force: true);
    _server = null;
    _sources.clear();
  }

  Future<void> _handle(HttpRequest req) async {
    final res = req.response;
    try {
      final m = RegExp(r'^/v/(\d+)$').firstMatch(req.uri.path);
      final src = m == null ? null : _sources[m[1]];
      if (src == null) {
        res.statusCode = HttpStatus.notFound;
        await res.close();
        return;
      }
      final size = await src.meta(this);

      var start = 0, end = size - 1;
      var partial = false;
      final range = req.headers.value(HttpHeaders.rangeHeader);
      final rm = range == null
          ? null
          : RegExp(r'bytes=(\d*)-(\d*)').firstMatch(range);
      if (rm != null) {
        partial = true;
        if (rm[1]!.isEmpty) {
          start = size - int.parse(rm[2]!);
        } else {
          start = int.parse(rm[1]!);
          if (rm[2]!.isNotEmpty) end = int.parse(rm[2]!).clamp(0, size - 1);
        }
      }
      if (start < 0 || start >= size || end < start) {
        res.statusCode = HttpStatus.requestedRangeNotSatisfiable;
        res.headers.set(HttpHeaders.contentRangeHeader, 'bytes */$size');
        await res.close();
        return;
      }

      res.statusCode = partial ? HttpStatus.partialContent : HttpStatus.ok;
      res.headers
        ..set(HttpHeaders.acceptRangesHeader, 'bytes')
        ..set(HttpHeaders.contentTypeHeader, src.contentType);
      if (partial) {
        res.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes $start-$end/$size',
        );
      }
      res.contentLength = end - start + 1;
      if (req.method == 'HEAD') {
        await res.close();
        return;
      }
      await res.flush(); // send headers now so mpv doesn't time out waiting
      await _stream(src, start, end, res);
      await res.close();
    } catch (_) {
      try {
        res.statusCode = HttpStatus.badGateway;
      } catch (_) {}
      try {
        await res.close();
      } catch (_) {}
    }
  }

  /// Sliding window, written strictly in order. The head piece is what the
  /// player is waiting on: if it runs late, a second copy is raced on the
  /// fastest other host (BTR's "rescue").
  Future<void> _stream(
    _Source src,
    int start,
    int end,
    HttpResponse res,
  ) async {
    final pieces = <(int, int)>[];
    var pos = start;
    var size = firstChunkSize;
    while (pos <= end) {
      final e = math.min(pos + size - 1, end);
      pieces.add((pos, e));
      pos = e + 1;
      if (size < chunkSize) size = math.min(size * 2, chunkSize);
    }

    final inflight = <_Job>[];
    var next = 0;
    for (var i = 0; i < pieces.length; i++) {
      final limit = src.threadLimit;
      while (next < pieces.length && inflight.length < limit) {
        final (s, e) = pieces[next++];
        inflight.add(_Job(s, e, _fetch(src, s, e)));
      }
      final head = inflight.removeAt(0);
      final bytes = await _awaitWithRescue(src, head);
      res.add(bytes);
      await res.flush(); // back-pressure + detects player disconnect (seek)
    }
  }

  Future<Uint8List> _awaitWithRescue(_Source src, _Job job) async {
    final first = job.result;
    final delay = src.rescueDelay(job.e - job.s + 1);
    final quick = await Future.any<Uint8List?>([
      first,
      Future<Uint8List?>.delayed(delay, () => null),
    ]).catchError((_) => null);
    if (quick != null) return quick;
    // Late (or failed): race a second copy, take whichever lands first.
    final rescue = _fetch(src, job.s, job.e, rescue: true);
    final winner = Completer<Uint8List>();
    var failures = 0;
    for (final f in [first, rescue]) {
      f.then(
        (b) {
          if (!winner.isCompleted) winner.complete(b);
        },
        onError: (Object e) {
          if (++failures == 2 && !winner.isCompleted) winner.completeError(e);
        },
      );
    }
    return winner.future;
  }

  Future<Uint8List> _fetch(_Source src, int s, int e, {bool rescue = false}) {
    final f = _fetchInner(src, s, e, rescue);
    f.ignore(); // surfaced when awaited; avoids unhandled errors after a seek
    return f;
  }

  Future<Uint8List> _fetchInner(_Source src, int s, int e, bool rescue) async {
    Object? lastErr;
    String? avoid;
    for (var attempt = 0; attempt < 5; attempt++) {
      final host = src.pick(avoid: avoid, best: rescue);
      final url = src.urlFor(host);
      src.begin(host);
      final sw = Stopwatch()..start();
      try {
        final req = await _client.getUrl(Uri.parse(url));
        _headers(req);
        req.headers.set(HttpHeaders.rangeHeader, 'bytes=$s-$e');
        final resp = await req.close().timeout(const Duration(seconds: 4));
        if (resp.statusCode != HttpStatus.partialContent) {
          await resp.drain<void>().catchError((_) {});
          throw HttpException('status ${resp.statusCode}');
        }
        final cr = resp.headers.value(HttpHeaders.contentRangeHeader);
        if (cr == null || !cr.startsWith('bytes $s-')) {
          await resp.drain<void>().catchError((_) {});
          throw HttpException('bad content-range $cr');
        }
        final b = BytesBuilder(copy: false);
        // a stalled body counts as a failure after 3s of silence
        await for (final c in resp.timeout(const Duration(seconds: 3))) {
          b.add(c);
        }
        final bytes = b.takeBytes();
        if (bytes.length != e - s + 1) {
          throw HttpException('short read ${bytes.length}/${e - s + 1}');
        }
        src.ok(host, bytes.length, sw.elapsedMicroseconds);
        return bytes;
      } catch (err) {
        lastErr = err;
        src.fail(host);
        avoid = host;
      } finally {
        src.end(host);
      }
    }
    throw lastErr!;
  }
}

class _Job {
  _Job(this.s, this.e, this.result);
  final int s, e;
  final Future<Uint8List> result;
}

class _Host {
  double? speed; // bytes/sec EWMA
  int inflight = 0;
  DateTime? badUntil;
}

class _Source {
  _Source(this.url) : origin = Uri.parse(url) {
    hosts[origin.host] = _Host();
  }

  final String url;
  final Uri origin;
  final Map<String, _Host> hosts = {};
  int? _size;
  String contentType = 'application/octet-stream';
  Future<int>? _metaFuture;

  int get inflightTotal => hosts.values.fold(0, (s, h) => s + h.inflight);

  String urlFor(String host) =>
      host == origin.host ? url : origin.replace(host: host).toString();

  /// Probe the configured mirrors in the background with a real 256 KB
  /// download; mirrors that answer join the pool with a measured speed.
  void discover(BtrProxy p) {
    if (!BtrProxy._isUpos(origin)) return;
    for (final h in BtrConfig.hosts) {
      if (h == origin.host) continue;
      () async {
        final sw = Stopwatch()..start();
        try {
          final req = await p._client.getUrl(Uri.parse(urlFor(h)));
          BtrProxy._headers(req);
          req.headers.set(
            HttpHeaders.rangeHeader,
            'bytes=0-${BtrProxy.probeBytes - 1}',
          );
          final resp = await req.close().timeout(const Duration(seconds: 3));
          if (resp.statusCode != HttpStatus.partialContent) {
            await resp.drain<void>().catchError((_) {});
            return;
          }
          var got = 0;
          await for (final c in resp.timeout(const Duration(seconds: 4))) {
            got += c.length;
          }
          if (got == BtrProxy.probeBytes) {
            (hosts[h] ??= _Host()).speed = got * 1e6 / sw.elapsedMicroseconds;
          }
        } catch (_) {}
      }();
    }
  }

  double get _best => hosts.values.map((h) => h.speed ?? 0).fold(0.0, math.max);

  bool _usable(String name, _Host h, DateTime now) {
    if (h.badUntil != null && now.isBefore(h.badUntil!)) return false;
    final best = _best;
    // drop hosts far slower than the best one (once we know speeds)
    if (best > 0 && h.speed != null && h.speed! < best * 0.3) return false;
    return true;
  }

  /// Greedy: the host with the best expected throughput given its current
  /// load. Unknown-speed hosts get a modest guess so they get sampled.
  String pick({String? avoid, bool best = false}) {
    final now = DateTime.now();
    String? choice;
    var score = -1.0;
    for (final MapEntry(key: name, value: h) in hosts.entries) {
      if (name == avoid || !_usable(name, h, now)) continue;
      final sp = h.speed ?? (_best > 0 ? _best * 0.5 : 1);
      final s = best ? sp : sp / (h.inflight + 1);
      if (s > score) {
        score = s;
        choice = name;
      }
    }
    return choice ??
        hosts.keys.firstWhere((k) => k != avoid, orElse: () => origin.host);
  }

  /// Auto: about 3 connections per healthy host, 4..16.
  int get threadLimit {
    if (!BtrConfig.autoThreads) return BtrConfig.threads;
    final now = DateTime.now();
    final healthy = hosts.entries
        .where((e) => _usable(e.key, e.value, now))
        .length;
    return (healthy * 3).clamp(4, 16);
  }

  Duration rescueDelay(int bytes) {
    final best = _best;
    if (best <= 0) return const Duration(milliseconds: 2500);
    final ms = (bytes / best * 1000 * 2.5).round();
    return Duration(milliseconds: ms.clamp(800, 3000));
  }

  void begin(String h) => hosts[h]?.inflight++;
  void end(String h) => hosts[h]?.inflight--;

  void ok(String name, int bytes, int micros) {
    final h = hosts[name];
    if (h == null || micros <= 0) return;
    h.badUntil = null;
    final v = bytes * 1e6 / micros;
    h.speed = h.speed == null ? v : h.speed! * 0.7 + v * 0.3;
  }

  void fail(String name) {
    final h = hosts[name];
    if (h == null) return;
    h.badUntil = DateTime.now().add(const Duration(seconds: 30));
    if (h.speed != null) h.speed = h.speed! * 0.5;
  }

  Future<int> meta(BtrProxy p) {
    if (_size != null) return Future.value(_size);
    return _metaFuture ??= _probe(p).whenComplete(() => _metaFuture = null);
  }

  Future<int> _probe(BtrProxy p) async {
    Object? lastErr;
    String? avoid;
    for (var i = 0; i < 4; i++) {
      final h = pick(avoid: avoid);
      try {
        final req = await p._client.getUrl(Uri.parse(urlFor(h)));
        BtrProxy._headers(req);
        req.headers.set(HttpHeaders.rangeHeader, 'bytes=0-0');
        final resp = await req.close().timeout(const Duration(seconds: 5));
        await resp.drain<void>();
        final cr = resp.headers.value(HttpHeaders.contentRangeHeader);
        final total = cr == null ? null : int.tryParse(cr.split('/').last);
        if (resp.statusCode == HttpStatus.partialContent && total != null) {
          contentType =
              resp.headers.value(HttpHeaders.contentTypeHeader) ?? contentType;
          return _size = total;
        }
        throw HttpException('probe status ${resp.statusCode}');
      } catch (e) {
        lastErr = e;
        fail(h);
        avoid = h;
      }
    }
    throw lastErr!;
  }
}
