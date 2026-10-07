// BTR proxy: a loopback HTTP server that serves Bilibili media to mpv while
// fetching each requested range as many small chunks in parallel, spread
// across several mainland CDN mirrors. Ported idea from
// https://github.com/MrTangLuyao/Bilibili-thread-ripper (MIT).
//
// Pure dart:io so it can be exercised outside Flutter (see tool/btr_bench.dart).

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class BtrProxy {
  BtrProxy._();
  static final BtrProxy instance = BtrProxy._();

  static bool enabled = true;
  static int threads = 8;
  static int chunkSize = 512 * 1024;
  static int firstChunkSize = 128 * 1024;

  static const userAgent =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';
  static const referer = 'https://www.bilibili.com/';

  // Mainland mirrors (same set BTR uses for its "大陆 CDN" mode).
  static const mirrorHosts = [
    'upos-sz-mirrorali.bilivideo.com',
    'upos-sz-mirrorhw.bilivideo.com',
    'upos-sz-mirrorcos.bilivideo.com',
    'upos-sz-mirror08c.bilivideo.com',
    'upos-sz-mirrorbos.bilivideo.com',
  ];

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

  int get port => _server?.port ?? 0;

  static bool isMediaUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.scheme.startsWith('http') &&
        _mediaHost.hasMatch(uri.host);
  }

  /// Returns a loopback URL serving [url] through the proxy, or [url] itself
  /// when disabled / not a Bilibili media URL / the server can't start.
  Future<String> wrap(String url) async {
    if (!enabled || !isMediaUrl(url)) return url;
    try {
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

  /// Sliding window: keep [threads] chunks in flight, write them in order.
  Future<void> _stream(_Source src, int start, int end, HttpResponse res) async {
    final pieces = <(int, int)>[];
    var pos = start;
    var size = firstChunkSize;
    while (pos <= end) {
      final e = (pos + size - 1).clamp(pos, end);
      pieces.add((pos, e));
      pos = e + 1;
      // ramp up quickly so playback starts fast, then use full-size chunks
      if (size < chunkSize) size *= 2;
      if (size > chunkSize) size = chunkSize;
    }

    final inflight = <Future<Uint8List>>[];
    var next = 0;
    var aborted = false;
    try {
      for (var i = 0; i < pieces.length; i++) {
        while (next < pieces.length && inflight.length < threads) {
          final (s, e) = pieces[next++];
          final f = _fetch(src, s, e);
          f.ignore(); // errors surface when awaited; avoid unhandled if aborted
          inflight.add(f);
        }
        final bytes = await inflight.removeAt(0);
        res.add(bytes);
        await res.flush(); // back-pressure + detects player disconnect (seek)
      }
    } catch (_) {
      aborted = true;
      rethrow;
    } finally {
      if (aborted) {
        for (final f in inflight) {
          f.ignore();
        }
      }
    }
  }

  Future<Uint8List> _fetch(_Source src, int s, int e) async {
    Object? lastErr;
    for (var attempt = 0; attempt < 5; attempt++) {
      final url = src.pick();
      final sw = Stopwatch()..start();
      try {
        final req = await _client.getUrl(Uri.parse(url));
        req.headers
          ..set(HttpHeaders.userAgentHeader, userAgent)
          ..set(HttpHeaders.refererHeader, referer)
          ..set(HttpHeaders.rangeHeader, 'bytes=$s-$e');
        final resp = await req.close().timeout(const Duration(seconds: 5));
        if (resp.statusCode != HttpStatus.partialContent) {
          await resp.drain<void>().catchError((_) {});
          throw HttpException('status ${resp.statusCode}', uri: Uri.parse(url));
        }
        final cr = resp.headers.value(HttpHeaders.contentRangeHeader);
        if (cr == null || !cr.startsWith('bytes $s-')) {
          await resp.drain<void>().catchError((_) {});
          throw HttpException('bad content-range $cr');
        }
        final b = BytesBuilder(copy: false);
        await for (final c in resp.timeout(const Duration(seconds: 8))) {
          b.add(c);
        }
        final bytes = b.takeBytes();
        if (bytes.length != e - s + 1) {
          throw HttpException('short read ${bytes.length}/${e - s + 1}');
        }
        src.ok(url, bytes.length, sw.elapsedMicroseconds);
        return bytes;
      } catch (err) {
        lastErr = err;
        src.fail(url);
      }
    }
    throw lastErr!;
  }
}

class _Source {
  _Source(this.url) : candidates = [url];

  final String url;
  final List<String> candidates;

  /// Probe the mainland mirrors in the background; only ones that answer a
  /// tiny range request quickly join the pool. Dead mirrors never block.
  void discover(BtrProxy p) {
    for (final c in _candidates(url).skip(1)) {
      () async {
        try {
          final req = await p._client.getUrl(Uri.parse(c));
          req.headers
            ..set(HttpHeaders.userAgentHeader, BtrProxy.userAgent)
            ..set(HttpHeaders.refererHeader, BtrProxy.referer)
            ..set(HttpHeaders.rangeHeader, 'bytes=0-0');
          final resp = await req.close().timeout(const Duration(seconds: 3));
          await resp.drain<void>();
          if (resp.statusCode == HttpStatus.partialContent) candidates.add(c);
        } catch (_) {}
      }();
    }
  }
  final Map<String, DateTime> _badUntil = {};
  final Map<String, double> speed = {}; // bytes/sec EWMA, for debugging
  int _rr = 0;
  int? _size;
  String contentType = 'application/octet-stream';
  Future<int>? _metaFuture;

  static List<String> _candidates(String url) {
    final uri = Uri.parse(url);
    final list = [url];
    if (uri.host.startsWith('upos-') && uri.path.contains('/upgcxcode/')) {
      for (final h in BtrProxy.mirrorHosts) {
        if (h != uri.host) list.add(uri.replace(host: h).toString());
      }
    }
    return list;
  }

  String pick() {
    final now = DateTime.now();
    for (var i = 0; i < candidates.length; i++) {
      final c = candidates[_rr++ % candidates.length];
      final bad = _badUntil[c];
      if (bad == null || now.isAfter(bad)) return c;
    }
    return url;
  }

  void ok(String c, int bytes, int micros) {
    _badUntil.remove(c);
    if (micros <= 0) return;
    final v = bytes * 1e6 / micros;
    speed[c] = speed[c] == null ? v : speed[c]! * 0.7 + v * 0.3;
  }

  void fail(String c) =>
      _badUntil[c] = DateTime.now().add(const Duration(seconds: 30));

  Future<int> meta(BtrProxy p) {
    if (_size != null) return Future.value(_size);
    return _metaFuture ??= _probe(p).whenComplete(() => _metaFuture = null);
  }

  Future<int> _probe(BtrProxy p) async {
    Object? lastErr;
    for (var i = 0; i < 4; i++) {
      final c = pick();
      try {
        final req = await p._client.getUrl(Uri.parse(c));
        req.headers
          ..set(HttpHeaders.userAgentHeader, BtrProxy.userAgent)
          ..set(HttpHeaders.refererHeader, BtrProxy.referer)
          ..set(HttpHeaders.rangeHeader, 'bytes=0-0');
        final resp = await req.close().timeout(const Duration(seconds: 10));
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
        fail(c);
      }
    }
    throw lastErr!;
  }
}
