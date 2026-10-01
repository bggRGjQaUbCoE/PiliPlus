import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:PiliPlus/services/video_accelerator/range_protocol.dart';

/// Single-upstream, video-only loopback relay. No prefetch, cache or retry.
/// Player demand drives streaming; every new request cancels the previous one.
class LocalStreamServer {
  LocalStreamServer({
    required this.source,
    required this.headers,
    required this.clientFactory,
    this.timeout = const Duration(seconds: 15),
    this.onFailure,
  });
  final Uri Function() source;
  final Map<String, String> headers;
  final HttpClient Function() clientFactory;
  final Duration timeout;
  final void Function()? onFailure;
  HttpServer? _server;
  HttpClient? _client;
  final _clock = Stopwatch()..start();
  final _buckets = <int, int>{};
  final _token = List.generate(
    24,
    (_) => Random.secure().nextInt(256),
  ).map((n) => n.toRadixString(16).padLeft(2, '0')).join();
  int _epoch = 0, upstreamBytes = 0, forwardedBytes = 0, errors = 0;
  int activeRequests = 0, requests = 0, cancellations = 0;
  String? lastFailureReason;
  bool _closed = false;
  Future<void>? _closing;
  Uri get uri => Uri.parse('http://127.0.0.1:${_server!.port}/$_token/video');

  double get throughputBps {
    final second = _clock.elapsed.inSeconds;
    _buckets.removeWhere((key, _) => key < second - 2);
    final micros = min(_clock.elapsedMicroseconds, 3000000);
    return micros == 0
        ? 0
        : _buckets.values.fold<int>(0, (a, b) => a + b) * 8e6 / micros;
  }

  Future<void> start() async {
    if (_closed) throw StateError('Closed relay');
    if (_server != null) return;
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    if (_closed) {
      await _server!.close(force: true);
      return;
    }
    _server!.listen((request) => unawaited(_handle(request)));
  }

  Future<void> _empty(HttpRequest r, int status) async {
    r.response.statusCode = status;
    r.response.contentLength = 0;
    await r.response.close();
  }

  Future<void> _handle(HttpRequest r) async {
    HttpClient? client;
    var committed = false;
    var consumerGone = false;
    var upstreamFailed = false;
    var upstreamCompleted = false;
    var epoch = -1;
    try {
      if (_closed || r.uri.path != '/$_token/video' || r.uri.hasQuery) {
        await _empty(r, 404);
        return;
      }
      if (r.method != 'GET' && r.method != 'HEAD') {
        r.response.headers.set('allow', 'GET, HEAD');
        await _empty(r, 405);
        return;
      }
      final rawRange = r.headers.value('range');
      ByteRange? range;
      try {
        range = rawRange == null ? null : ByteRange.parse(rawRange);
      } on FormatException {
        await _empty(r, 400);
        return;
      }
      final remote = source();
      if (!['http', 'https'].contains(remote.scheme) || remote.host.isEmpty) {
        throw const FormatException('Invalid media source');
      }
      cancelRequests();
      epoch = _epoch;
      requests++;
      activeRequests = 1;
      client = clientFactory()..autoUncompress = false;
      _client = client;
      final localClient = client;
      unawaited(
        r.response.done.then<void>(
          (_) => localClient.close(force: true),
          onError: (Object _) {
            consumerGone = true;
            localClient.close(force: true);
          },
        ),
      );
      final request = await client.openUrl(r.method, remote).timeout(timeout);
      // Signed remote URI is supplied internally; local clients cannot choose it.
      request.followRedirects = false;
      headers.forEach(request.headers.set);
      request.headers.set('accept-encoding', 'identity');
      if (rawRange != null) request.headers.set('range', rawRange);
      final response = await request.close().timeout(timeout);
      if (_closed || epoch != _epoch) throw StateError('Cancelled relay');
      final status = response.statusCode;
      if (status == 416) {
        final cr = response.headers.value('content-range');
        if (cr == null || !RegExp(r'^bytes \*/\d+$').hasMatch(cr)) {
          throw const FormatException('Invalid unsatisfied range');
        }
        r.response.headers.set('content-range', cr);
        await _empty(r, 416);
        return;
      }
      if (range != null) {
        if (status != 206) throw const FormatException('Range not supported');
        final cr = ContentRange.parse(
          response.headers.value('content-range') ?? '',
        );
        if (!cr.matches(range) || response.contentLength != cr.length) {
          throw const FormatException('Mismatched upstream range');
        }
      } else if (status != 200 || response.contentLength < 0) {
        throw const FormatException('Invalid upstream response');
      }
      if ((response.headers.value('content-encoding') ?? 'identity') !=
          'identity') {
        throw const FormatException('Encoded upstream content');
      }
      r.response.statusCode = status;
      r.response.contentLength = response.contentLength;
      for (final name in ['content-range', 'content-type', 'accept-ranges']) {
        final value = response.headers.value(name);
        if (value != null) r.response.headers.set(name, value);
      }
      r.response.headers.set('cache-control', 'no-store');
      committed = true;
      if (r.method != 'HEAD') {
        var received = 0;
        await r.response.addStream(
          response
              .timeout(timeout)
              .handleError((Object error) {
                upstreamFailed = true;
                throw error;
              })
              .transform(
                StreamTransformer<List<int>, List<int>>.fromHandlers(
                  handleDone: (sink) {
                    upstreamCompleted = true;
                    sink.close();
                  },
                ),
              )
              .map((chunk) {
                if (_closed || epoch != _epoch) {
                  throw StateError('Cancelled relay');
                }
                received += chunk.length;
                upstreamBytes += chunk.length;
                if (received > response.contentLength) {
                  upstreamFailed = true;
                  throw const FormatException('Oversized upstream');
                }
                // Bytes handed to the downstream stream, not unique cached goodput.
                forwardedBytes += chunk.length;
                final second = _clock.elapsed.inSeconds;
                _buckets.removeWhere((key, _) => key < second - 2);
                _buckets.update(
                  second,
                  (n) => n + chunk.length,
                  ifAbsent: () => chunk.length,
                );
                return chunk;
              }),
        );
        if (received != response.contentLength) {
          // addStream can complete early when mpv closes a demux/seek reader.
          // Only an actual upstream EOF proves a truncated representation.
          if (!upstreamCompleted) {
            cancellations++;
            return;
          }
          upstreamFailed = true;
          throw const FormatException('Truncated upstream');
        }
      }
      await r.response.close();
    } catch (error) {
      // Cancellation from seek/close is not a CDN failure.
      if (!_closed &&
          !consumerGone &&
          (!committed || upstreamFailed) &&
          epoch == _epoch &&
          epoch >= 0) {
        errors++;
        lastFailureReason = error is FormatException
            ? error.message
            : error.runtimeType.toString();
        onFailure?.call();
      }
      try {
        if (!committed) {
          await _empty(r, 502);
        } else {
          final socket = await r.response.detachSocket();
          socket.destroy();
        }
      } catch (_) {
        /* Consumer already disconnected. */
      }
    } finally {
      client?.close(force: true);
      if (identical(_client, client)) {
        _client = null;
        activeRequests = 0;
      }
    }
  }

  void cancelRequests() {
    _epoch++;
    if (_client != null) cancellations++;
    _client?.close(force: true);
    _client = null;
    activeRequests = 0;
  }

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _closed = true;
    cancelRequests();
    await _server?.close(force: true);
  }
}
