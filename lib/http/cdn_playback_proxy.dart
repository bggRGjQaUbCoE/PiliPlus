import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

// This transport is also exercised without Flutter package resolution.
// ignore: always_use_package_imports
import 'cdn_origin_policy.dart';
// Keep transport timing available to standalone Dart protocol checks.
// ignore: always_use_package_imports
import '../utils/cdn_startup_trace.dart';

/// A bounded, session-local Range transport for DASH media. This is independent
/// of Flutter so the HTTP contract can be tested against a deterministic origin.
/// Inspired by Bilibili-thread-ripper; no browser/Electron code is executed.
final class CdnPlaybackProxy {
  CdnPlaybackProxy._(
    this._server,
    this.concurrency,
    this.chunkSize,
    this.timeout,
    this._allowOrigin,
    this._originResolver,
    this._trace,
    this.autoSelect,
    this.adaptive,
    this.parallel,
    this.durationSeconds,
    this._isBaselineOrigin,
  );

  static Future<CdnPlaybackProxy> start({
    int concurrency = 8,
    int chunkSize = 1024 * 1024,
    Duration timeout = const Duration(seconds: 10),
    bool Function(Uri)? allowOrigin,
    CdnOriginResolver? originResolver,
    CdnStartupTrace? trace,
    bool autoSelect = false,
    bool adaptive = false,
    bool parallel = true,
    double? durationSeconds,
    bool Function(Uri)? isBaselineOrigin,
    bool enableDiagnostics = false,
    int diagnosticEventLimit = 12000,
  }) async {
    if (concurrency < 1 ||
        concurrency > 32 ||
        chunkSize < 64 * 1024 ||
        chunkSize > 4 * 1024 * 1024 ||
        timeout <= Duration.zero ||
        diagnosticEventLimit < 1 ||
        diagnosticEventLimit > 12000) {
      throw ArgumentError('Invalid CDN transport limits');
    }
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final proxy = CdnPlaybackProxy._(
      server,
      concurrency,
      chunkSize,
      timeout,
      allowOrigin ?? CdnOriginPolicy.isMedia,
      originResolver ??
          (autoSelect ? CdnOriginPolicy.measured : CdnOriginPolicy.resolve),
      trace,
      autoSelect,
      adaptive,
      parallel,
      durationSeconds != null && durationSeconds.isFinite && durationSeconds > 0
          ? durationSeconds
          : null,
      isBaselineOrigin ?? (uri) => uri.host == 'upos-sz-mirrorhw.bilivideo.com',
    );
    if (enableDiagnostics) {
      proxy._requestDiagnostics = _RequestDiagnostics(
        diagnosticEventLimit,
        () => {
          'active_origin_requests': proxy._inFlight,
          'buffered_payload_bytes': proxy._bufferedBytes,
          'hedge_buffered_payload_bytes': proxy._hedgeBufferedBytes,
        },
      );
    }
    server.listen((request) {
      unawaited(
        proxy._handle(request).catchError((Object _) {
          // Malformed headers or a disconnect during an early rejection must not
          // escape the server callback and become an unhandled application error.
          request.response.deadline = Duration.zero;
        }),
      );
    }, onError: (Object _) {});
    return proxy;
  }

  final HttpServer _server;
  final int concurrency;
  final bool autoSelect;
  final bool adaptive;
  final bool parallel;
  final double? durationSeconds;
  final int chunkSize;
  final Duration timeout;
  final bool Function(Uri) _allowOrigin;
  final CdnOriginResolver _originResolver;
  final CdnStartupTrace? _trace;
  final bool Function(Uri) _isBaselineOrigin;
  _RequestDiagnostics? _requestDiagnostics;
  static const _maxBufferedBytes = 64 * 1024 * 1024;
  static const _startupChunkSize = 64 * 1024;
  int _bufferedBytes = 0;
  int _peakBufferedBytes = 0;
  int _hedgeBufferedBytes = 0;
  int _peakHedgeBufferedBytes = 0;
  final Map<String, _Media> _media = {};
  final Set<_Transfer> _transfers = {};
  final List<Completer<void>> _waiters = [];
  final Queue<_SlotWaiter> _urgentWaiters = Queue();
  final Queue<_SlotWaiter> _normalWaiters = Queue();
  final Queue<_SlotWaiter> _backgroundWaiters = Queue();
  final Set<_Transfer> _backgroundTransfers = {};
  int _inFlight = 0;
  int _normalInFlight = 0;
  int _nextRequestId = 0;
  bool _closed = false;
  int _observedUpstreamBytes = 0;
  int _upstreamRequests = 0;
  final List<Map<String, Object?>> _rangeFailures = [];
  final List<Map<String, Object>> _failures = [];
  void _failure(Uri origin, String phase, Object error) {
    if (_failures.length >= 20) return;
    const messages = {
      'CDN range metadata mismatch',
      'CDN range length mismatch',
      'CDN range truncated',
      'CDN resource identity mismatch',
      'CDN request cancelled',
      'CDN range too long',
      'All CDN origins failed for this range',
    };
    _failures.add({
      'host': origin.host,
      'phase': phase,
      'kind': error is HttpException && messages.contains(error.message)
          ? error.message
          : '${error.runtimeType}',
    });
  }

  void _originInvalidated(
    _Transfer transfer,
    CdnOrigin origin,
    String phase,
    Object error,
  ) => _requestDiagnostics?.event(
    'origin_invalidated',
    transfer: transfer,
    domain: origin.uri.host,
    originId:
        transfer.media.origins.indexWhere((value) => value.uri == origin.uri) +
        1,
    phase: phase,
    kind: _RequestDiagnostic.errorKind(error),
  );

  Map<String, Object> get diagnostics => {
    'observed_upstream_body_bytes': _observedUpstreamBytes,
    'upstream_requests': _upstreamRequests,
    'buffered_payload_bytes': _bufferedBytes,
    'peak_buffered_payload_bytes': _peakBufferedBytes,
    'hedge_buffered_payload_bytes': _hedgeBufferedBytes,
    'peak_hedge_buffered_payload_bytes': _peakHedgeBufferedBytes,
    'active_origin_requests': _inFlight,
    'failures': _failures,
    'range_failures': _rangeFailures,
    'selected_hosts': _media.values
        .map((m) => m.preferred?.uri.host)
        .whereType<String>()
        .toSet()
        .toList(),
    'diagnostics_enabled': _requestDiagnostics != null,
    if (_requestDiagnostics case final diagnostic?) ...diagnostic.snapshot,
  };

  /// Retains the exact signed origin URL in memory; it is never exposed through
  /// the loopback URL. Unrecognized media stays on the existing native path.
  String register(
    String url, {
    Iterable<String> alternatives = const [],
    Map<String, String> headers = const {},
    CdnStartupTrack track = CdnStartupTrack.unknown,
  }) {
    if (_closed) return url;
    final originals = <Uri>[];
    for (final value in [url, ...alternatives]) {
      final uri = Uri.tryParse(value);
      if (uri != null &&
          _allowOrigin(uri) &&
          (originals.isEmpty || uri.path == originals.first.path) &&
          !originals.contains(uri)) {
        originals.add(uri);
      }
      if (originals.length == 4) break;
    }
    if (originals.isEmpty || _media.length >= 8) return url;
    final seen = <Uri>{};
    final origins = _originResolver(List.unmodifiable(originals))
        .where(
          (origin) =>
              _allowOrigin(origin.uri) &&
              origin.uri.path == originals.first.path &&
              seen.add(origin.uri),
        )
        .take(40)
        .toList();
    if (origins.isEmpty) return url;
    final orderedOrigins = [
      ...origins.where((origin) => origin.mainland),
      ...origins.where((origin) => !origin.mainland),
    ];
    final random = Random.secure();
    final token = base64Url.encode(
      List.generate(24, (_) => random.nextInt(256)),
    );
    final safeHeaders = <String, String>{};
    for (final entry in headers.entries) {
      final name = entry.key.toLowerCase();
      if (const ['user-agent', 'referer', 'origin'].contains(name)) {
        safeHeaders[name] = entry.value;
      }
    }
    _media['/$token'] = _Media(
      originals.first,
      safeHeaders,
      orderedOrigins,
      track,
      _requestDiagnostics,
    );
    return 'http://127.0.0.1:${_server.port}/$token';
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    for (final transfer in _transfers.toList()) {
      transfer.cancel(reason: 'proxy_closed');
    }
    for (final transfer in _backgroundTransfers.toList()) {
      transfer.cancel(reason: 'proxy_closed');
    }
    for (final media in _media.values) {
      media.close();
    }
    _media.clear();
    _wakeWaiters();
    await _server.close(force: true);
  }

  void _wakeWaiters() {
    _drainSlotWaiters();
    for (final waiter in _waiters.toList()) {
      if (!waiter.isCompleted) waiter.complete();
    }
    _waiters.clear();
  }

  int get _normalLimit => max(1, concurrency - 1);

  void _drainSlotWaiters() {
    for (final queue in [_urgentWaiters, _normalWaiters, _backgroundWaiters]) {
      final count = queue.length;
      for (var index = 0; index < count; index++) {
        final waiter = queue.removeFirst();
        if (waiter.transfer.cancelled) {
          waiter.completer.complete();
        } else {
          queue.addLast(waiter);
        }
      }
    }
    while (_inFlight < concurrency) {
      _SlotWaiter? waiter;
      if (_urgentWaiters.isNotEmpty) {
        waiter = _urgentWaiters.removeFirst();
      } else if (_normalInFlight < _normalLimit && _normalWaiters.isNotEmpty) {
        waiter = _normalWaiters.removeFirst();
      } else if (_backgroundWaiters.isNotEmpty) {
        waiter = _backgroundWaiters.removeFirst();
      }
      if (waiter == null) break;
      if (waiter.transfer.cancelled) {
        waiter.completer.complete();
        continue;
      }
      _inFlight++;
      waiter.transfer.activeSlots++;
      if (!waiter.urgent && !waiter.transfer.background) _normalInFlight++;
      waiter.granted = true;
      if (!waiter.transfer.reportedSlot) {
        waiter.transfer.reportedSlot = true;
        _trace?.mark(
          CdnStartupStage.originSlotGranted,
          track: waiter.transfer.track,
          requestId: waiter.transfer.requestId,
        );
      }
      waiter.completer.complete();
    }
  }

  void _preemptBackground() {
    for (final transfer in _backgroundTransfers.toList()) {
      if (!transfer.cancelled && transfer.activeSlots > 0) {
        transfer
          ..preempted = true
          ..cancel();
        return;
      }
    }
  }

  Future<T> _slot<T>(
    _Transfer transfer,
    Future<T> Function() action, {
    bool urgent = false,
    _RequestDiagnostic? diagnostic,
  }) async {
    transfer.pendingWork++;
    var reserved = false;
    try {
      transfer.check();
      if (_inFlight < concurrency &&
          _urgentWaiters.isEmpty &&
          (urgent ||
              (transfer.background
                  ? _normalWaiters.isEmpty
                  : _normalInFlight < _normalLimit))) {
        _inFlight++;
        transfer.activeSlots++;
        if (!urgent && !transfer.background) _normalInFlight++;
        reserved = true;
        if (!transfer.reportedSlot) {
          transfer.reportedSlot = true;
          _trace?.mark(
            CdnStartupStage.originSlotGranted,
            track: transfer.track,
            requestId: transfer.requestId,
          );
        }
      } else {
        diagnostic?.event('queued');
        final waiter = _SlotWaiter(transfer, urgent);
        (urgent
                ? _urgentWaiters
                : transfer.background
                ? _backgroundWaiters
                : _normalWaiters)
            .add(waiter);
        if (!transfer.reportedQueue && !transfer.reportedSlot) {
          transfer.reportedQueue = true;
          _trace?.mark(
            CdnStartupStage.originQueueEnter,
            track: transfer.track,
            requestId: transfer.requestId,
          );
        }
        if (!transfer.background &&
            _inFlight >= concurrency &&
            (urgent || _normalInFlight < _normalLimit)) {
          _preemptBackground();
        }
        _drainSlotWaiters();
        await waiter.completer.future;
        reserved = waiter.granted;
      }
      // Waiting for our own semaphore is not silence from a CDN. Start the
      // upstream watchdog only once this request is allowed to perform I/O.
      transfer
        ..check()
        ..beginOriginWork();
      diagnostic?.event('slot_granted');
      try {
        return await action();
      } catch (error) {
        diagnostic?.fail(error);
        rethrow;
      } finally {
        transfer.endOriginWork();
      }
    } finally {
      if (reserved) {
        _inFlight--;
        transfer.activeSlots--;
        if (!urgent && !transfer.background) _normalInFlight--;
        _wakeWaiters();
      }
      transfer.pendingWork--;
      diagnostic?.event(
        'request_released',
        kind: reserved ? 'slot_released' : 'not_granted',
      );
      transfer.diagnosticRequests.remove(diagnostic);
    }
  }

  Future<void> _handle(HttpRequest request) async {
    final output = request.response;
    // Native playback supplies no browser Origin. Require the exact loopback
    // authority as well as an unguessable registered token (no open URL proxy).
    if (_closed ||
        request.headers.value(HttpHeaders.hostHeader) !=
            '127.0.0.1:${_server.port}' ||
        request.headers.value('origin') != null ||
        request.uri.hasQuery ||
        !_media.containsKey(request.uri.path)) {
      output.statusCode = HttpStatus.notFound;
      await output.close();
      return;
    }
    if (request.method != 'GET' && request.method != 'HEAD') {
      output.statusCode = HttpStatus.methodNotAllowed;
      output.headers.set(HttpHeaders.allowHeader, 'GET, HEAD');
      await output.close();
      return;
    }
    final rawRange = request.headers.value(HttpHeaders.rangeHeader);
    if (rawRange != null &&
        !RegExp(r'^bytes=(\d+-\d*|-\d+)$').hasMatch(rawRange)) {
      output.statusCode = HttpStatus.requestedRangeNotSatisfiable;
      await output.close();
      return;
    }
    // Bounds memory even if a native player issues overlapping seeks.
    if (_transfers.length >= 8) {
      output.statusCode = HttpStatus.serviceUnavailable;
      await output.close();
      return;
    }
    // Detach before any CDN work. HttpResponse.done does not reliably observe
    // a peer disconnect until close(); a socket read subscription does, including
    // cancellation while a CDN probe is still waiting for its first byte.
    final media = _media[request.uri.path]!;
    final transfer = _Transfer(timeout, _wakeWaiters, media, ++_nextRequestId);
    _transfers.add(transfer);
    _requestDiagnostics?.event(
      'proxy_request',
      transfer: transfer,
      range: rawRange,
    );
    _trace?.mark(
      CdnStartupStage.proxyRequest,
      track: media.track,
      requestId: transfer.requestId,
    );
    var reply = _MediaResponse.pending();
    try {
      final socket = await output.detachSocket(writeHeaders: false);
      transfer.attach(socket);
      reply = _MediaResponse(socket, transfer);
      transfer.check();
      if ((autoSelect || adaptive) &&
          (adaptive || !parallel) &&
          request.method == 'GET') {
        try {
          await _serveMeasuredStream(transfer, media, rawRange, reply);
          transfer.markOutputComplete();
          await reply.close();
          transfer.finish();
        } catch (_) {
          transfer.check();
          if (reply.started) rethrow;
          await _passthrough(transfer, media, request, reply);
        }
        return;
      }
      _Plan plan;
      try {
        plan = await _prepare(transfer, media);
        _trace?.mark(
          CdnStartupStage.candidateReady,
          track: media.track,
          requestId: transfer.requestId,
        );
      } catch (error) {
        transfer.check();
        // No response body has been sent: reissue the player's original request
        // as one stream. Never append a full response to partially emitted data.
        await _passthrough(transfer, media, request, reply);
        return;
      }
      final probe = plan.reference;
      final total = probe.total;
      final range = _range(rawRange, total);
      if (range == null) {
        reply.statusCode = HttpStatus.requestedRangeNotSatisfiable;
        reply.headers.set(HttpHeaders.contentRangeHeader, 'bytes */$total');
        transfer.markOutputComplete();
        await reply.close();
        transfer.finish();
        return;
      }
      final (start, end) = range;
      _ensureCurrent(transfer, plan);
      _BufferedChunk? first;
      if (request.method == 'GET') {
        if (!autoSelect && concurrency >= 4) _warmPeers(transfer, plan);
        try {
          // Startup bytes cannot wait behind speculative data from another
          // track: mpv may need both initial headers before draining either.
          first = _BufferedChunk(
            start == 0 && probe.bytes.length > 1
                ? _Chunk(
                    Uint8List.sublistView(
                      probe.bytes,
                      0,
                      min(end + 1, probe.bytes.length),
                    ),
                    min(end, probe.end),
                    probe.total,
                    probe.contentType,
                    probe.etag,
                    probe.modified,
                  )
                : await _chunk(
                    transfer,
                    plan,
                    start,
                    min<int>(
                      end,
                      start + min<int>(chunkSize, _startupChunkSize) - 1,
                    ),
                    true,
                  ),
            _BufferedChunk._noop,
          );
          _trace?.mark(
            CdnStartupStage.firstRangeValidated,
            track: media.track,
            requestId: transfer.requestId,
          );
        } catch (_) {
          transfer.check();
          await _passthrough(transfer, media, request, reply);
          return;
        }
      }
      reply
        ..statusCode = rawRange == null
            ? HttpStatus.ok
            : HttpStatus.partialContent
        ..contentLength = end - start + 1;
      reply.headers.set(HttpHeaders.acceptRangesHeader, 'bytes');
      reply.headers.set(
        HttpHeaders.contentTypeHeader,
        probe.contentType ?? 'application/octet-stream',
      );
      reply.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
      // ETags are CDN-specific. Do not expose one origin's validator as if it
      // identified bytes subsequently served by other origins.
      if (rawRange != null) {
        reply.headers.set(
          HttpHeaders.contentRangeHeader,
          'bytes $start-$end/$total',
        );
      }
      if (first != null) {
        try {
          _ensureCurrent(transfer, plan);
          reply.add(first.chunk!.bytes);
          await reply.flush();
          _trace?.mark(
            CdnStartupStage.proxyFirstFlush,
            track: media.track,
            requestId: transfer.requestId,
          );
        } finally {
          first.release();
        }
        await _drainChunks(transfer, plan, reply, first.chunk!.end + 1, end);
      }
      transfer.markOutputComplete();
      await reply.close();
      transfer.finish();
    } catch (_) {
      if (!reply.started) {
        reply
          ..statusCode = HttpStatus.badGateway
          ..contentLength = 0;
        try {
          await reply.close();
        } catch (_) {}
      }
      // cancel() destroys the socket after a committed failure; the client
      // receives a truncated Content-Length response, never substituted bytes.
    } finally {
      transfer.cancel();
      _transfers.remove(transfer);
    }
  }

  Future<void> _drainChunks(
    _Transfer transfer,
    _Plan plan,
    _MediaResponse reply,
    int next,
    int end,
  ) async {
    final pending = Queue<Future<_BufferedChunk>>();
    var smallTransitionPieces = adaptive ? 2 : 0;
    void enqueue() {
      if (next > end) return;
      // A stream that has just slowed must not make its next useful byte wait
      // for a whole large block. Only the transition uses these small pieces.
      final size = smallTransitionPieces > 0
          ? min<int>(chunkSize, _startupChunkSize)
          : adaptive
          ? min<int>(chunkSize, 512 * 1024)
          : chunkSize;
      if (smallTransitionPieces > 0) smallTransitionPieces--;
      final chunkEnd = min<int>(end, next + size - 1);
      pending.add(
        _buffered(
          transfer,
          plan,
          next,
          chunkEnd,
          urgent: plan.media.track == CdnStartupTrack.audio,
        ),
      );
      next = chunkEnd + 1;
    }

    // Leave room for the other DASH track even at the largest settings.
    var window = min(
      parallel ? (adaptive ? 1 : concurrency) : 1,
      max(1, _maxBufferedBytes ~/ 2 ~/ chunkSize),
    );
    _requestDiagnostics?.event('window', transfer: transfer, window: window);
    for (var i = 0; i < window; i++) {
      enqueue();
    }
    if (!autoSelect && concurrency < 4) _warmPeers(transfer, plan);
    var completed = 0;
    var lastRate = 0.0;
    var epochBytes = 0;
    final epoch = Stopwatch()..start();
    try {
      while (pending.isNotEmpty) {
        transfer.check();
        final item = await pending.removeFirst();
        try {
          item.check();
          _ensureCurrent(transfer, plan);
          epochBytes += item.chunk!.bytes.length;
          epoch.stop();
          reply.add(item.chunk!.bytes);
          await reply.flush();
        } finally {
          item.release();
          epoch.start();
        }
        // A sliding window keeps other connections busy as soon as the
        // next ordered piece is consumed; no whole-batch barrier.
        completed++;
        if (adaptive && parallel && completed >= window * 2) {
          final precedingWindow = window;
          final rate = epochBytes / max(0.001, epoch.elapsedMicroseconds / 1e6);
          // Trial increases must earn their extra sockets in ordered useful
          // output. Plateau/loss returns to the preceding smaller window.
          if (lastRate > 0 && rate < lastRate * 1.1 && window > 1) {
            window = max(1, window ~/ 2);
            plan.rampFinished = true;
          } else if (!plan.rampFinished &&
              rate <
                  (durationSeconds == null
                      ? 4 * 1024 * 1024
                      : max(
                          128 * 1024,
                          plan.reference.total / durationSeconds! * 3,
                        ))) {
            window = min(min(concurrency, 8), window * 2);
          }
          lastRate = rate;
          if (window != precedingWindow) {
            _requestDiagnostics?.event(
              'window',
              transfer: transfer,
              window: window,
              rateBytesPerSecond: rate.toInt(),
            );
          }
          epochBytes = 0;
          completed = 0;
          epoch.reset();
        }
        while (pending.length < window && next <= end) {
          enqueue();
        }
      }
    } finally {
      for (final future in pending) {
        unawaited(future.then((item) => item.release()));
      }
    }
  }

  static (int, int)? _range(String? value, int total) {
    if (total <= 0) return null;
    if (value == null) return (0, total - 1);
    final parts = value.substring(6).split('-');
    if (parts[0].isEmpty) {
      final suffix = int.tryParse(parts[1]);
      if (suffix == null || suffix <= 0) return null;
      return (max(0, total - suffix), total - 1);
    }
    final start = int.tryParse(parts[0]);
    final requestedEnd = parts[1].isEmpty ? total - 1 : int.tryParse(parts[1]);
    if (start == null ||
        requestedEnd == null ||
        start >= total ||
        requestedEnd < start) {
      return null;
    }
    return (start, min(requestedEnd, total - 1));
  }

  /// Observe the original I/O future even after cancellation/timeout so late
  /// request/response objects are disposed and late errors remain handled.
  /// Removable callbacks avoid one retained cancellation listener per chunk.
  Future<T> _originIo<T>(
    _Transfer transfer,
    Future<T> pending, {
    required void Function(T) discard,
    void Function()? interrupt,
    String timeoutMessage = 'CDN request timed out',
  }) {
    final completed = Completer<T>();
    var settled = false;
    Timer? timer;
    late void Function() cancel;
    void cleanup(T value) {
      try {
        discard(value);
      } catch (_) {}
    }

    void reject(Object error) {
      if (settled) return;
      settled = true;
      timer?.cancel();
      transfer.originIoCancels.remove(cancel);
      try {
        interrupt?.call();
      } catch (_) {}
      completed.completeError(error);
    }

    cancel = () => reject(const HttpException('CDN request cancelled'));
    transfer.originIoCancels.add(cancel);
    unawaited(
      pending.then<void>(
        (value) {
          if (settled || transfer.cancelled) {
            cleanup(value);
            cancel();
            return;
          }
          settled = true;
          timer?.cancel();
          transfer.originIoCancels.remove(cancel);
          completed.complete(value);
        },
        onError: (Object error, StackTrace stack) {
          if (settled) return;
          settled = true;
          timer?.cancel();
          transfer.originIoCancels.remove(cancel);
          completed.completeError(error, stack);
        },
      ),
    );
    if (transfer.cancelled) {
      cancel();
    } else {
      timer = Timer(timeout, () => reject(TimeoutException(timeoutMessage)));
    }
    return completed.future;
  }

  static void _discardOriginResponse(HttpClientResponse response) {
    try {
      unawaited(
        response
            .listen((_) {}, onError: (Object _) {})
            .cancel()
            .catchError((Object _) {}),
      );
    } catch (_) {}
  }

  Future<HttpClientResponse> _open(
    _Transfer transfer,
    _Media media,
    String method,
    String? range, {
    Uri? origin,
    bool mainland = false,
    _RequestDiagnostic? diagnostic,
  }) async {
    var uri = origin ?? media.uri;
    for (var redirects = 0; redirects <= 3; redirects++) {
      transfer.check();
      _upstreamRequests++;
      diagnostic?.open(uri, redirects);
      final request = await _originIo(
        transfer,
        transfer.client.openUrl(method, uri),
        discard: (request) => request.abort(),
      );
      HttpClientResponse? received;
      late HttpClientResponse response;
      try {
        transfer.check();
        request.followRedirects = false;
        media.headers.forEach(request.headers.set);
        request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
        if (range != null) request.headers.set(HttpHeaders.rangeHeader, range);
        response = await _originIo<HttpClientResponse>(
          transfer,
          request.close(),
          interrupt: request.abort,
          discard: _discardOriginResponse,
          timeoutMessage: 'CDN response timed out',
        );
        received = response;
        transfer.check();
      } catch (_) {
        try {
          request.abort();
        } catch (_) {}
        if (received != null) _discardOriginResponse(received);
        rethrow;
      }
      if (diagnostic != null) {
        final observedRange = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$').firstMatch(
          response.headers.value(HttpHeaders.contentRangeHeader) ?? '',
        );
        diagnostic.event(
          'headers',
          http: response.statusCode,
          actualStart: observedRange == null
              ? null
              : int.tryParse(observedRange[1]!),
          actualEnd: observedRange == null
              ? null
              : int.tryParse(observedRange[2]!),
          total: observedRange == null ? null : int.tryParse(observedRange[3]!),
          contentLength: response.contentLength >= 0
              ? response.contentLength
              : null,
        );
      }
      if (!const [301, 302, 303, 307, 308].contains(response.statusCode)) {
        return response;
      }
      final location = response.headers.value(HttpHeaders.locationHeader);
      await response.listen((_) {}).cancel();
      if (location == null || redirects == 3) {
        throw const HttpException('Invalid CDN redirect');
      }
      uri = uri.resolve(location);
      diagnostic?.event('redirect');
      if (!_allowOrigin(uri) ||
          (mainland &&
              !media.origins.any(
                (candidate) =>
                    candidate.mainland &&
                    candidate.uri.host == uri.host &&
                    candidate.uri.port == uri.port,
              ))) {
        throw const HttpException('Unsupported CDN redirect');
      }
    }
    throw const HttpException('Too many CDN redirects');
  }

  Future<_Chunk> _readChunk(
    _Transfer transfer,
    _Media media,
    CdnOrigin origin,
    int start,
    int end, [
    _Chunk? expected,
    bool urgent = false,
    Duration? bodyBudget,
    String phase = 'chunk',
  ]) {
    final diagnostic = _requestDiagnostics?.request(
      transfer,
      origin.uri,
      'bytes=$start-$end',
      phase,
      urgent,
    );
    return _slot(
      transfer,
      () async {
        final response = await _open(
          transfer,
          media,
          'GET',
          'bytes=$start-$end',
          origin: origin.uri,
          mainland: origin.mainland,
          diagnostic: diagnostic,
        );
        if (!transfer.reportedHeaders) {
          transfer.reportedHeaders = true;
          _trace?.mark(
            CdnStartupStage.originHeaders,
            track: media.track,
            requestId: transfer.requestId,
          );
        }
        final contentRange =
            response.headers.value(HttpHeaders.contentRangeHeader) ?? '';
        final match = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$')
            .firstMatch(contentRange);
        final actualStart = match == null ? null : int.tryParse(match[1]!);
        final actualEnd = match == null ? null : int.tryParse(match[2]!);
        final total = match == null ? null : int.tryParse(match[3]!);
        final encoding = response.headers.value(
          HttpHeaders.contentEncodingHeader,
        );
        final etag = response.headers.value(HttpHeaders.etagHeader);
        final modified = response.headers.value(HttpHeaders.lastModifiedHeader);
        if (response.statusCode != HttpStatus.partialContent ||
            actualStart != start ||
            (actualEnd != end &&
                !(expected == null &&
                    actualEnd == (total ?? 0) - 1 &&
                    actualEnd! < end)) ||
            total == null ||
            total <= (actualEnd ?? end) ||
            (encoding != null && encoding != 'identity') ||
            (expected != null &&
                (total != expected.total ||
                    etag != expected.etag ||
                    modified != expected.modified))) {
          diagnostic?.validation(
            false,
            'range_metadata',
            expected: expected,
            etag: etag,
            modified: modified,
            encoding: encoding,
          );
          if (_rangeFailures.length < 12) {
            _rangeFailures.add({
              'host': origin.uri.host,
              'http': response.statusCode,
              'start': start,
              'end': end,
              'actual_start': actualStart,
              'actual_end': actualEnd,
              'total': total,
              'expected_total': expected?.total,
              'etag_equal': expected == null || etag == expected.etag,
              'modified_equal':
                  expected == null || modified == expected.modified,
              'encoding_identity': encoding == null || encoding == 'identity',
            });
          }
          await response.listen((_) {}).cancel();
          throw const HttpException('CDN range metadata mismatch');
        }
        final bytes = BytesBuilder(copy: false);
        final length = actualEnd! - start + 1;
        if (response.contentLength != -1 && response.contentLength != length) {
          diagnostic?.validation(
            false,
            'range_length',
            expected: expected,
            etag: etag,
            modified: modified,
            encoding: encoding,
          );
          await response.listen((_) {}).cancel();
          throw const HttpException('CDN range length mismatch');
        }
        diagnostic?.validation(
          true,
          'range_metadata',
          expected: expected,
          etag: etag,
          modified: modified,
          encoding: encoding,
        );
        final bodyWatch = Stopwatch()..start();
        final deadline = DateTime.now().add(bodyBudget ?? timeout);
        await for (final data in response.timeout(
          bodyBudget == null
              ? timeout
              : (timeout < bodyBudget ? timeout : bodyBudget),
        )) {
          _observedUpstreamBytes += data.length;
          diagnostic?.progress(data.length);
          transfer
            ..originProgress()
            ..check();
          if (data.isNotEmpty && !transfer.reportedFirstByte) {
            transfer.reportedFirstByte = true;
            _trace?.mark(
              CdnStartupStage.originFirstByte,
              track: media.track,
              requestId: transfer.requestId,
            );
          }
          if (DateTime.now().isAfter(deadline)) {
            throw TimeoutException('CDN chunk timed out');
          }
          if (bytes.length + data.length > length) {
            throw const HttpException('CDN range too long');
          }
          bytes.add(data);
        }
        if (bytes.length != length) {
          throw const HttpException('CDN range truncated');
        }
        transfer.lastBodySeconds = bodyWatch.elapsedMicroseconds / 1e6;
        diagnostic?.end('body_complete');
        return _Chunk(
          bytes.takeBytes(),
          actualEnd,
          total,
          response.headers.value(HttpHeaders.contentTypeHeader),
          etag,
          modified,
        );
      },
      urgent: urgent,
      diagnostic: diagnostic,
    );
  }

  double _supplyTarget(int total) => durationSeconds == null
      ? 2 * 1024 * 1024
      // Mean bitrate cannot describe short VBR peaks. Require useful headroom
      // and a floor instead of treating barely-average delivery as healthy.
      : max(1024 * 1024, total / durationSeconds! * 2);

  double _playbackSupplyTarget(int total) => durationSeconds == null
      ? 512 * 1024
      : max(256 * 1024, total / durationSeconds! * 1.25);

  static _Chunk _headerReference(_Chunk value) => _Chunk(
    Uint8List(0),
    value.end,
    value.total,
    value.contentType,
    value.etag,
    value.modified,
  );

  static bool _smallRange(String? value, _Media media) {
    if (value == null) return false;
    final explicit = RegExp(r'^bytes=(\d+)-(\d+)$').firstMatch(value);
    if (explicit != null) {
      final start = int.tryParse(explicit[1]!);
      final end = int.tryParse(explicit[2]!);
      return start != null &&
          end != null &&
          end >= start &&
          end - start + 1 <= _startupChunkSize;
    }
    final suffix = RegExp(r'^bytes=-(\d+)$').firstMatch(value);
    if (suffix != null) {
      final size = int.tryParse(suffix[1]!);
      return size != null && size > 0 && size <= _startupChunkSize;
    }
    final total = media.observed?.reference.total;
    final known = total == null ? null : _range(value, total);
    return known != null && known.$2 - known.$1 + 1 <= _startupChunkSize;
  }

  Future<(_Chunk?, bool)> _qualifySupply(
    _Transfer parent,
    _Media media,
    CdnOrigin origin,
    String? rawRange,
  ) async {
    // Probe before acquiring the long-lived stream slot. This also works with
    // one shared connection; no continuous response waits for its own probe.
    final probe = _Transfer(
      timeout,
      _wakeWaiters,
      media,
      parent.requestId,
      originIdleTimeout: const Duration(seconds: 2),
    );
    parent.children.add(probe);
    const reserved = 256 * 1024 + 1;
    if (_bufferedBytes + reserved > _maxBufferedBytes) {
      probe.cancel();
      parent.children.remove(probe);
      return (null, false);
    }
    _bufferedBytes += reserved;
    _peakBufferedBytes = max(_peakBufferedBytes, _bufferedBytes);
    var sampling = false;
    try {
      final prefix = await _readChunk(
        probe,
        media,
        origin,
        0,
        0,
        null,
        true,
        null,
        'qualification_prefix',
      );
      final wanted = _range(rawRange, prefix.total);
      if (wanted == null) return (null, false);
      final span = wanted.$2 - wanted.$1 + 1;
      if (span <= _startupChunkSize) {
        // An initially unknown open-ended tail Range can only be identified
        // after its total is known. There is no steady supply to score here.
        return (_headerReference(prefix), false);
      }
      final offset = wanted.$1 == 0
          ? max<int>(wanted.$1, wanted.$2 ~/ 2)
          : wanted.$1 + min<int>(1024 * 1024, span ~/ 2);
      final sampleStart = min<int>(
        offset,
        max<int>(wanted.$1, wanted.$2 - 262143),
      );
      final sampleEnd = min<int>(wanted.$2, sampleStart + 262143);
      sampling = true;
      final sample = await _readChunk(
        probe,
        media,
        origin,
        sampleStart,
        sampleEnd,
        prefix,
        true,
        const Duration(seconds: 2),
        'qualification_sample',
      );
      parent.check();
      if (sample.bytes.length / max(.001, probe.lastBodySeconds) <
          _supplyTarget(sample.total)) {
        _requestDiagnostics?.event(
          'admission',
          transfer: probe,
          domain: origin.uri.host,
          phase: 'qualification',
          kind: 'weak_supply',
        );
        return (null, true);
      }
      _requestDiagnostics?.event(
        'admission',
        transfer: probe,
        domain: origin.uri.host,
        phase: 'qualification',
        kind: 'qualified',
      );
      // Do not retain scratch bytes after their reservation is released.
      return (_headerReference(sample), false);
    } catch (error) {
      parent.check();
      // Qualification does not admit cross-origin bytes or blacklist an origin.
      // Metadata changes, slow supply, or probe failure leave a bounded single
      // complete-response fallback, never weaker chunk identity guards.
      return (null, sampling && (error is TimeoutException || probe.cancelled));
    } finally {
      _bufferedBytes -= reserved;
      _wakeWaiters();
      probe.cancel();
      parent.children.remove(probe);
    }
  }

  Future<void> _serveMeasuredStream(
    _Transfer parent,
    _Media media,
    String? rawRange,
    _MediaResponse output,
  ) async {
    final origins = [
      ...media.origins.where((o) => _isBaselineOrigin(o.uri)),
      if (media.preferred != null && !_isBaselineOrigin(media.preferred!.uri))
        media.preferred!,
      ...media.origins.where(
        (o) => !_isBaselineOrigin(o.uri) && o.uri != media.preferred?.uri,
      ),
    ].take(6).toList();
    final raceWatch = Stopwatch()..start();
    final winner = Completer<_StreamingOrigin>();
    final jobs = <_Transfer>[];
    var finished = 0;
    for (var i = 0; i < origins.length; i++) {
      final index = i;
      unawaited(() async {
        if (index > 0) {
          await Future<void>.delayed(Duration(milliseconds: 250 * index));
        }
        if (winner.isCompleted || parent.cancelled) return;
        final job = _Transfer(
          timeout,
          _wakeWaiters,
          media,
          parent.requestId,
          originIdleTimeout: const Duration(seconds: 3),
        );
        jobs.add(job);
        parent.children.add(job);
        StreamIterator<List<int>>? body;
        try {
          _Chunk? qualification;
          if (media.track == CdnStartupTrack.video &&
              origins.length > 1 &&
              !_smallRange(rawRange, media) &&
              !_isBaselineOrigin(origins[index].uri)) {
            final result = await _qualifySupply(
              job,
              media,
              origins[index],
              rawRange,
            );
            qualification = result.$1;
            // A usable but weak/unmeasurable candidate remains an independent
            // full-stream fallback. It cannot beat a qualified or baseline
            // stream during this bounded initial selection interval. Retain
            // candidate order for weak fallbacks so a timed-out source's fast
            // prefix does not restart an all-weak first-byte race.
            // Measured inadequate body supply ranks behind unavailable
            // measurements (e.g. a metadata transition). Both use independent
            // complete responses; neither relaxes mixed-body identity checks.
            final weakDeadline = (result.$2 ? 4000 : 2500) + index * 250;
            if (qualification == null &&
                raceWatch.elapsedMilliseconds < weakDeadline) {
              await Future<void>.delayed(
                Duration(
                  milliseconds: weakDeadline - raceWatch.elapsedMilliseconds,
                ),
              );
            }
            if (winner.isCompleted || parent.cancelled) return;
          }
          final diagnostic = _requestDiagnostics?.request(
            job,
            origins[index].uri,
            rawRange ?? 'bytes=0-',
            'stream',
            true,
          );
          await _slot(
            job,
            () async {
              final response = await _open(
                job,
                media,
                'GET',
                rawRange ?? 'bytes=0-',
                origin: origins[index].uri,
                diagnostic: diagnostic,
              );
              if (!parent.reportedHeaders) {
                parent.reportedHeaders = true;
                _trace?.mark(
                  CdnStartupStage.originHeaders,
                  track: media.track,
                  requestId: parent.requestId,
                );
              }
              final match = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$')
                  .firstMatch(response.headers.value('content-range') ?? '');
              final total = match == null ? 0 : int.parse(match[3]!);
              final wanted = _range(rawRange, total);
              if (response.statusCode != 206 ||
                  match == null ||
                  wanted == null ||
                  wanted.$1 != int.parse(match[1]!) ||
                  wanted.$2 != int.parse(match[2]!) ||
                  (response.headers.value('content-encoding') ?? 'identity') !=
                      'identity' ||
                  (response.contentLength != -1 &&
                      response.contentLength != wanted.$2 - wanted.$1 + 1) ||
                  (qualification != null &&
                      (total != qualification.total ||
                          response.headers.value('etag') !=
                              qualification.etag ||
                          response.headers.value('last-modified') !=
                              qualification.modified))) {
                diagnostic?.validation(
                  false,
                  'range_metadata',
                  expected: qualification,
                  etag: response.headers.value('etag'),
                  modified: response.headers.value('last-modified'),
                  encoding: response.headers.value('content-encoding'),
                );
                await response.listen((_) {}).cancel();
                throw const HttpException('CDN range metadata mismatch');
              }
              diagnostic?.validation(
                true,
                'range_metadata',
                expected: qualification,
                etag: response.headers.value('etag'),
                modified: response.headers.value('last-modified'),
                encoding: response.headers.value('content-encoding'),
              );
              body = StreamIterator(response);
              while (await body!.moveNext()) {
                job.check();
                if (body!.current.isEmpty) continue;
                if (!parent.reportedFirstByte) {
                  parent.reportedFirstByte = true;
                  _trace?.mark(
                    CdnStartupStage.originFirstByte,
                    track: media.track,
                    requestId: parent.requestId,
                  );
                }
                final first = Uint8List.fromList(body!.current);
                _observedUpstreamBytes += first.length;
                diagnostic?.progress(first.length);
                if (first.length > wanted.$2 - wanted.$1 + 1) {
                  throw const HttpException('CDN range too long');
                }
                final stream = _StreamingOrigin(
                  job,
                  origins[index],
                  body!,
                  first,
                  wanted.$1,
                  wanted.$2,
                  _Chunk(
                    first,
                    wanted.$1 + first.length - 1,
                    total,
                    response.headers.value('content-type'),
                    response.headers.value('etag'),
                    response.headers.value('last-modified'),
                  ),
                  diagnostic,
                );
                // The ongoing stream has its own moveNext idle deadline. Its
                // consumer may stop reading while mpv's buffer is full.
                job.endOriginWatchdog();
                if (!winner.isCompleted) {
                  winner.complete(stream);
                  await stream.release.future;
                }
                return;
              }
              throw const HttpException('CDN range truncated');
            },
            urgent: true,
            diagnostic: diagnostic,
          );
        } catch (error) {
          if (!winner.isCompleted && !parent.cancelled) {
            _failure(origins[index].uri, 'stream_probe', error);
          }
        } finally {
          await body?.cancel();
          job.finish();
          parent.children.remove(job);
          finished++;
          if (finished == origins.length && !winner.isCompleted) {
            winner.completeError(
              const HttpException('No usable CDN range origin'),
            );
          }
        }
      }());
    }
    _StreamingOrigin? selected;
    try {
      selected = await winner.future.timeout(const Duration(seconds: 6));
      parent.check();
      for (final job in jobs) {
        if (!identical(job, selected.job)) job.cancel(reason: 'lost_race');
      }
      selected.diagnostic?.event('selected');
      final previous = media.observed;
      if (previous != null &&
          (previous.anchor.uri != selected.origin.uri ||
              !_sameObservedVersion(previous.reference, selected.reference))) {
        _requestDiagnostics?.event(
          'resource_changed',
          transfer: parent,
          domain: selected.origin.uri.host,
          etagEqual: previous.reference.etag == selected.reference.etag,
          modifiedEqual:
              previous.reference.modified == selected.reference.modified,
          expectedTotal: previous.reference.total,
          total: selected.reference.total,
        );
        media.identityEpoch++;
        media.identity = null;
      }
      media
        ..preferred = selected.origin
        ..observed = _ObservedVersion(selected.origin, selected.reference);
      final plan = _Plan(
        media,
        selected.origin,
        selected.reference,
        {},
        null,
        media.identityEpoch,
      );
      _trace?.mark(
        CdnStartupStage.candidateReady,
        track: media.track,
        requestId: parent.requestId,
      );
      _trace?.mark(
        CdnStartupStage.firstRangeValidated,
        track: media.track,
        requestId: parent.requestId,
      );
      output
        ..statusCode = rawRange == null ? 200 : 206
        ..contentLength = selected.end - selected.start + 1;
      output.headers.set('accept-ranges', 'bytes');
      output.headers.set('cache-control', 'no-store');
      output.headers.set(
        'content-type',
        selected.reference.contentType ?? 'application/octet-stream',
      );
      if (rawRange != null) {
        output.headers.set(
          'content-range',
          'bytes ${selected.start}-${selected.end}/${selected.reference.total}',
        );
      }
      var next = selected.start;
      final supply = _OriginSupply();
      double? warmStartedAt;
      var supplied = 0;
      var data = selected.first;
      var fallback = false;
      var fallbackKind = 'unknown';
      while (true) {
        _ensureCurrent(parent, plan);
        if (next + data.length > selected.end + 1) {
          throw const HttpException('CDN range too long');
        }
        output.add(data);
        final flush = Stopwatch()..start();
        await output.flush();
        if (flush.elapsedMilliseconds >= 500) {
          // A paused/full consumer makes older upstream samples stale. Resume
          // with fresh I/O observations instead of judging the pre-pause rate.
          supply.resetWindow();
        }
        if (supplied == 0) {
          _trace?.mark(
            CdnStartupStage.proxyFirstFlush,
            track: media.track,
            requestId: parent.requestId,
          );
        }
        next += data.length;
        supplied += data.length;
        if (next > selected.end) {
          selected.diagnostic?.end('body_complete');
          break;
        }
        // The initial gate asks for extra peak headroom. An already selected
        // continuous response is judged by actual playback supply instead;
        // adequate sustained delivery must not be split just for a probe score.
        final target = media.track == CdnStartupTrack.video
            ? _playbackSupplyTarget(selected.reference.total)
            : durationSeconds == null
            ? 4 * 1024 * 1024
            : max(128 * 1024, selected.reference.total / durationSeconds! * 3);
        if ((parallel ||
                (autoSelect && media.track == CdnStartupTrack.video)) &&
            adaptive &&
            supply.hasWindow &&
            supply.rate < target &&
            _hasValidator(selected.reference)) {
          // Keep useful bytes flowing while peers pass both identity samples.
          // Closing first used to create an eight-second whole-block barrier.
          plan.costs[selected.origin.uri] = 1 / max(1, supply.rate);
          if (!plan.warmed) {
            plan.warmed = true;
            warmStartedAt = supply.totalWait;
            _warmPeersAtTwo(parent, plan);
          }
          if (plan.ready.keys.any((uri) => uri != selected!.origin.uri) ||
              supply.totalWait - (warmStartedAt ?? supply.totalWait) >= 2) {
            fallback = true;
            fallbackKind = 'low_supply';
            break;
          }
        }
        try {
          final receive = Stopwatch()..start();
          if (!await selected.body.moveNext().timeout(
            const Duration(seconds: 3),
          )) {
            fallback = true;
            fallbackKind = 'stream_eof';
            break;
          }
          data = Uint8List.fromList(selected.body.current);
          // Measure origin I/O only. flush() and a paused/full player are not
          // congestion at the CDN and must not force splitting a healthy stream.
          supply.record(data.length, receive.elapsedMicroseconds / 1e6);
          _observedUpstreamBytes += data.length;
          selected.diagnostic?.progress(data.length);
        } catch (error) {
          _ensureCurrent(parent, plan);
          _failure(selected.origin.uri, 'stream_continuation', error);
          selected.diagnostic?.fail(error);
          fallback = true;
          fallbackKind = _RequestDiagnostic.errorKind(error);
          break;
        }
      }
      if (fallback) {
        _requestDiagnostics?.event(
          'stream_to_chunks',
          transfer: parent,
          domain: selected.origin.uri.host,
          range: 'bytes=$next-${selected.end}',
          kind: fallbackKind,
          rateBytesPerSecond: supply.rate.toInt(),
        );
        if (autoSelect && !plan.warmed) {
          plan.warmed = true;
          _warmPeersAtTwo(parent, plan);
        }
        selected.job.cancel(reason: 'stream_to_chunks');
        selected.release.complete();
        // Continue from the first byte not delivered. Cross-origin fallbacks
        // still pass the original two-sample identity checks.
        await _drainChunks(parent, plan, output, next, selected.end);
      }
    } finally {
      if (selected != null && !selected.release.isCompleted) {
        selected.release.complete();
      }
      if (!winner.isCompleted) {
        winner.completeError(const HttpException('CDN race cancelled'));
      }
      for (final job in jobs) {
        job.cancel();
      }
    }
  }

  Future<_Plan> _prepareMeasured(_Transfer parent, _Media media) async {
    final candidates = [
      if (media.preferred != null) media.preferred!,
      ...media.origins.where((o) => o.uri != media.preferred?.uri),
    ].take(6).toList();
    final done = Completer<(CdnOrigin, _Chunk)>();
    final jobs = <_Transfer>[];
    final failed = <Uri>{};
    var finished = 0;
    Future<void> probe(CdnOrigin origin, int index) async {
      // Fast healthy anchors need no competing request. Slow anchors get a
      // bounded hedge; there is no fixed-order wait for their timeout.
      if (index > 0) {
        await Future<void>.delayed(Duration(milliseconds: 250 * index));
      }
      if (done.isCompleted || parent.cancelled) return;
      final job = _Transfer(
        timeout,
        _wakeWaiters,
        media,
        parent.requestId,
        originIdleTimeout: const Duration(seconds: 3),
      );
      jobs.add(job);
      parent.children.add(job);
      try {
        final chunk = await _readChunk(
          job,
          media,
          origin,
          0,
          _startupChunkSize - 1,
          null,
          true,
          null,
          'startup_probe',
        );
        parent.check();
        if (!done.isCompleted) done.complete((origin, chunk));
      } catch (error) {
        // Losing a startup race is cancellation, not an unavailable CDN.
        // Keep the runner-up available for later verified failover.
        if (!done.isCompleted && !parent.cancelled) {
          _originInvalidated(job, origin, 'startup_probe', error);
          failed.add(origin.uri);
        }
      } finally {
        job.finish();
        parent.children.remove(job);
        finished++;
        if (finished == candidates.length && !done.isCompleted) {
          done.completeError(const HttpException('No usable CDN range origin'));
        }
      }
    }

    for (var i = 0; i < candidates.length; i++) {
      unawaited(probe(candidates[i], i));
    }
    try {
      final (anchor, reference) = await done.future.timeout(
        const Duration(seconds: 6),
      );
      parent.check();
      final previous = media.observed;
      if (previous != null &&
          (previous.anchor.uri != anchor.uri ||
              !_sameObservedVersion(previous.reference, reference))) {
        _requestDiagnostics?.event(
          'resource_changed',
          transfer: parent,
          domain: anchor.uri.host,
          etagEqual: previous.reference.etag == reference.etag,
          modifiedEqual: previous.reference.modified == reference.modified,
          expectedTotal: previous.reference.total,
          total: reference.total,
        );
        media.identityEpoch++;
        media.identity = null;
      }
      media
        ..preferred = anchor
        ..observed = _ObservedVersion(anchor, reference);
      final cache = media.identity;
      final validCache =
          cache != null &&
              DateTime.now().isBefore(cache.expiresAt) &&
              cache.anchor.uri == anchor.uri &&
              _sameVersion(cache.reference, reference)
          ? cache
          : null;
      _requestDiagnostics?.event(
        'admission',
        transfer: parent,
        domain: anchor.uri.host,
        phase: 'identity_cache',
        kind: validCache == null ? 'cache_miss' : 'cache_hit',
      );
      return _Plan(
        media,
        anchor,
        reference,
        failed,
        validCache,
        media.identityEpoch,
      );
    } finally {
      // Complete on cancel/timeout as well, so delayed hedges never outlive it.
      if (!done.isCompleted) {
        done.completeError(const HttpException('CDN race cancelled'));
      }
      for (final job in jobs) {
        job.cancel();
      }
    }
  }

  Future<_Plan> _prepare(_Transfer transfer, _Media media) async {
    if (autoSelect) return _prepareMeasured(transfer, media);
    final failed = <Uri>{};
    for (final mainland in [true, false]) {
      final tier = media.origins
          .where((origin) => origin.mainland == mainland)
          .toList();
      // Keep only one window of metadata checks ahead. Queuing the whole pool
      // can starve a healthy anchor's samples behind unused failing mirrors.
      // Consume in configured order; response time never determines priority.
      final probes = Queue<Future<_Chunk?>>();
      var nextProbe = 0;
      Future<_Chunk?> probe(CdnOrigin origin, {required bool urgent}) async {
        try {
          return await _readChunk(
            transfer,
            media,
            origin,
            0,
            0,
            null,
            urgent,
            null,
            'metadata',
          );
        } catch (error) {
          _originInvalidated(transfer, origin, 'metadata', error);
          failed.add(origin.uri);
          return null;
        }
      }

      void enqueue() {
        if (nextProbe < tier.length) {
          final index = nextProbe++;
          probes.add(probe(tier[index], urgent: index == 0));
        }
      }

      // A second probe overlaps a failed anchor, without filling every slot
      // before the anchor can send its first media bytes.
      for (
        var index = 0;
        index < min(concurrency >= 3 ? 2 : 1, tier.length);
        index++
      ) {
        enqueue();
      }
      for (var index = 0; index < tier.length; index++) {
        transfer.check();
        final reference = await probes.removeFirst();
        transfer.check();
        if (reference == null) {
          enqueue();
          continue;
        }
        final observed = media.observed;
        if (observed != null &&
            (observed.anchor.uri != tier[index].uri ||
                !_sameObservedVersion(observed.reference, reference))) {
          _requestDiagnostics?.event(
            'resource_changed',
            transfer: transfer,
            domain: tier[index].uri.host,
            etagEqual: observed.reference.etag == reference.etag,
            modifiedEqual: observed.reference.modified == reference.modified,
            expectedTotal: observed.reference.total,
            total: reference.total,
          );
          media.identityEpoch++;
          media.identity = null;
          for (final job in _backgroundTransfers.toList()) {
            if (identical(job.media, media)) job.cancel();
          }
        }
        media.observed = _ObservedVersion(tier[index], reference);
        final previous = media.identity;
        final cached =
            previous != null &&
                DateTime.now().isBefore(previous.expiresAt) &&
                previous.anchor.uri == tier[index].uri &&
                _sameVersion(previous.reference, reference)
            ? previous
            : null;
        if (cached == null) media.identity = null;
        _requestDiagnostics?.event(
          'admission',
          transfer: transfer,
          domain: tier[index].uri.host,
          phase: 'identity_cache',
          kind: cached == null ? 'cache_miss' : 'cache_hit',
        );
        // The anchor may serve immediately. Other origins still need both
        // samples before they are allowed to contribute media bytes.
        return _Plan(
          media,
          tier[index],
          reference,
          failed,
          cached,
          media.identityEpoch,
        );
      }
    }
    throw const HttpException('No usable CDN range origin');
  }

  Future<List<_Chunk>> _samples(
    _Transfer transfer,
    _Plan plan, [
    bool urgent = false,
  ]) {
    final existing = plan.samples;
    if (existing != null) return existing;
    final future = _loadSamples(transfer, plan, urgent);
    if (transfer.background) {
      return future.then((samples) {
        if (!transfer.cancelled &&
            plan.media.identityEpoch == plan.identityEpoch) {
          plan.samples ??= Future.value(samples);
        }
        return samples;
      });
    }
    plan.samples = future;
    unawaited(
      future.then<void>(
        (_) {},
        onError: (Object _, StackTrace _) {
          if (identical(plan.samples, future)) plan.samples = null;
        },
      ),
    );
    return future;
  }

  Future<List<_Chunk>> _loadSamples(
    _Transfer transfer,
    _Plan plan,
    bool urgent,
  ) async {
    _ensureCurrent(transfer, plan);
    if (plan.cached case final cached?) {
      _requestDiagnostics?.event(
        'admission',
        transfer: transfer,
        domain: plan.anchor.uri.host,
        phase: 'identity_anchor',
        kind: 'cache_hit',
      );
      return cached.samples;
    }
    _requestDiagnostics?.event(
      'admission',
      transfer: transfer,
      domain: plan.anchor.uri.host,
      phase: 'identity_anchor',
      kind: 'cache_miss',
    );
    final total = plan.reference.total;
    final prefix = await _readChunk(
      transfer,
      plan.media,
      plan.anchor,
      0,
      min(4095, total - 1),
      plan.reference,
      urgent,
      null,
      'identity_anchor_prefix',
    );
    final middleStart = total ~/ 2;
    final middle = await _readChunk(
      transfer,
      plan.media,
      plan.anchor,
      middleStart,
      min(middleStart + 4095, total - 1),
      plan.reference,
      urgent,
      null,
      'identity_anchor_middle',
    );
    final samples = [prefix, middle];
    _ensureCurrent(transfer, plan);
    if (_hasValidator(plan.reference)) {
      plan.media.identity = _IdentityCache(
        plan.anchor,
        plan.reference,
        samples,
      );
    }
    return samples;
  }

  Future<_Chunk> _admit(
    _Transfer transfer,
    _Plan plan,
    CdnOrigin origin, [
    bool urgent = false,
  ]) => plan.admitted.putIfAbsent(
    origin.uri,
    () => _verifyPeer(transfer, plan, origin, urgent),
  );

  Future<_Chunk> _verifyPeer(
    _Transfer transfer,
    _Plan plan,
    CdnOrigin origin,
    bool urgent,
  ) async {
    _requestDiagnostics?.event(
      'admission',
      transfer: transfer,
      domain: origin.uri.host,
      phase: 'identity',
      kind: 'started',
    );
    _ensureCurrent(transfer, plan);
    final cached = plan.cached?.admitted[origin.uri];
    _requestDiagnostics?.event(
      'admission',
      transfer: transfer,
      domain: origin.uri.host,
      phase: 'identity_peer_cache',
      kind: cached == null ? 'cache_miss' : 'cache_hit',
    );
    if (cached != null && _hasValidator(cached)) {
      try {
        final current = await _readChunk(
          transfer,
          plan.media,
          origin,
          0,
          0,
          null,
          urgent,
          null,
          'identity_cached_validator',
        );
        _ensureCurrent(transfer, plan);
        if (_sameVersion(cached, current)) {
          plan.ready[origin.uri] = cached;
          _requestDiagnostics?.event(
            'admission',
            transfer: transfer,
            domain: origin.uri.host,
            phase: 'identity',
            kind: 'cached_validated',
          );
          return cached;
        }
      } catch (_) {
        _ensureCurrent(transfer, plan);
      }
    }
    final samples = await _samples(transfer, plan, urgent);
    _ensureCurrent(transfer, plan);
    late _Chunk prefix;
    for (var attempt = 0; ; attempt++) {
      prefix = await _readChunk(
        transfer,
        plan.media,
        origin,
        0,
        samples[0].end,
        null,
        urgent,
        null,
        'identity_prefix',
      );
      if (prefix.total != plan.reference.total ||
          !_sameBytes(prefix.bytes, samples[0].bytes)) {
        throw const HttpException('CDN resource identity mismatch');
      }
      try {
        final middle = await _readChunk(
          transfer,
          plan.media,
          origin,
          plan.reference.total ~/ 2,
          samples[1].end,
          prefix,
          urgent,
          null,
          'identity_middle',
        );
        if (!_sameBytes(middle.bytes, samples[1].bytes)) {
          throw const HttpException('CDN resource identity mismatch');
        }
        break;
      } on HttpException catch (error) {
        // A CDN may update metadata between the two admission samples. Retry
        // the complete pair once; never accept mismatched validators or bytes.
        _ensureCurrent(transfer, plan);
        if (attempt != 0 || error.message != 'CDN range metadata mismatch') {
          rethrow;
        }
        _requestDiagnostics?.event(
          'retry',
          transfer: transfer,
          domain: origin.uri.host,
          phase: 'identity',
          kind: 'metadata_changed',
        );
      }
    }
    _ensureCurrent(transfer, plan);
    final activeCache = plan.media.identity;
    if (activeCache != null &&
        activeCache.anchor.uri == plan.anchor.uri &&
        _sameVersion(activeCache.reference, plan.reference) &&
        _hasValidator(prefix)) {
      activeCache.admitted[origin.uri] = prefix;
    }
    plan.ready[origin.uri] = prefix;
    _requestDiagnostics?.event(
      'admission',
      transfer: transfer,
      domain: origin.uri.host,
      phase: 'identity',
      kind: 'validated',
    );
    if (!transfer.reportedIdentity) {
      transfer.reportedIdentity = true;
      _trace?.mark(
        CdnStartupStage.identityValidated,
        track: plan.media.track,
        requestId: transfer.requestId,
      );
    }
    return prefix;
  }

  void _warmPeers(_Transfer transfer, _Plan plan) {
    if (concurrency == 2) {
      _warmPeersAtTwo(transfer, plan);
      return;
    }
    // Preserve one foreground and one urgent connection while candidates are
    // checked. A slow peer must never become the ordered response's next byte.
    // With four or more connections, an unused speculative metadata request
    // may still occupy one normal slot. Keep another for ordered data.
    final workers = min(
      2,
      max(0, concurrency >= 4 ? concurrency - 3 : concurrency - 2),
    );
    if (workers == 0) return;
    final peers = Queue<CdnOrigin>.from(
      plan.media.origins.where(
        (origin) =>
            origin.mainland == plan.anchor.mainland &&
            origin.uri != plan.anchor.uri &&
            !plan.failed.contains(origin.uri),
      ),
    );
    for (var index = 0; index < min(workers, peers.length); index++) {
      unawaited(() async {
        while (peers.isNotEmpty &&
            !transfer.cancelled &&
            plan.media.identityEpoch == plan.identityEpoch) {
          final origin = peers.removeFirst();
          try {
            await _admit(transfer, plan, origin);
          } catch (error) {
            if (!transfer.cancelled &&
                plan.media.identityEpoch == plan.identityEpoch) {
              _originInvalidated(transfer, origin, 'identity', error);
              plan.failed.add(origin.uri);
            }
          }
        }
      }());
    }
  }

  void _warmPeersAtTwo(_Transfer parent, _Plan plan) {
    final peers = plan.media.origins
        .take(autoSelect ? 4 : 40)
        .where(
          (origin) =>
              origin.mainland == plan.anchor.mainland &&
              origin.uri != plan.anchor.uri &&
              !plan.failed.contains(origin.uri),
        );
    if (peers.isEmpty) return;
    unawaited(() async {
      for (final origin in peers) {
        // Preemption is not an origin failure. Retry with a fresh client once
        // the urgent audio or foreground operation has used the slot.
        while (!parent.cancelled &&
            plan.media.identityEpoch == plan.identityEpoch &&
            !plan.ready.containsKey(origin.uri)) {
          final job = _Transfer(
            timeout,
            _wakeWaiters,
            plan.media,
            parent.requestId,
            background: true,
          );
          parent.children.add(job);
          _backgroundTransfers.add(job);
          var retry = false;
          try {
            await _verifyPeer(job, plan, origin, false);
          } catch (error) {
            retry = job.preempted && !parent.cancelled;
            if (!retry &&
                !parent.cancelled &&
                plan.media.identityEpoch == plan.identityEpoch) {
              _originInvalidated(job, origin, 'identity', error);
              plan.failed.add(origin.uri);
            }
          } finally {
            job.cancel();
            parent.children.remove(job);
            _backgroundTransfers.remove(job);
          }
          if (!retry) break;
        }
      }
    }());
  }

  static bool _hasValidator(_Chunk value) =>
      value.etag != null && !value.etag!.startsWith('W/');

  static bool _sameVersion(_Chunk before, _Chunk after) =>
      before.total == after.total &&
      before.etag == after.etag &&
      before.modified == after.modified &&
      _hasValidator(before);

  static bool _sameObservedVersion(_Chunk before, _Chunk after) =>
      before.total == after.total &&
      before.etag == after.etag &&
      before.modified == after.modified;

  static void _ensureCurrent(_Transfer transfer, _Plan plan) {
    transfer.check();
    if (plan.media.identityEpoch != plan.identityEpoch) {
      throw const HttpException('CDN resource version changed');
    }
  }

  static bool _sameBytes(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<_Chunk> _chunk(
    _Transfer transfer,
    _Plan plan,
    int start,
    int end, [
    bool urgent = false,
  ]) async {
    _ensureCurrent(transfer, plan);
    if (autoSelect) return _measuredChunk(transfer, plan, start, end, urgent);
    final offset = plan.cursor++;
    // Geography is a strict tier, not a speed score. Only availability and
    // content validation can remove an origin from the current request.
    for (final mainland in [true, false]) {
      final tier = plan.media.origins
          .where((o) => o.mainland == mainland)
          .toList();
      for (var index = 0; index < tier.length; index++) {
        final origin = tier[(offset + index) % tier.length];
        if (plan.failed.contains(origin.uri)) continue;
        final ownValidator = plan.ready[origin.uri];
        if (ownValidator == null) continue;
        _ensureCurrent(transfer, plan);
        try {
          final chunk = await _readChunk(
            transfer,
            plan.media,
            origin,
            start,
            end,
            ownValidator,
            urgent,
          );
          _ensureCurrent(transfer, plan);
          return chunk;
        } catch (error) {
          _ensureCurrent(transfer, plan);
          _originInvalidated(transfer, origin, 'chunk', error);
          plan.failed.add(origin.uri);
        }
      }
    }
    // Every previously admitted source failed. Only now may the foreground
    // wait for another origin to pass cross-source identity checks.
    for (final mainland in [true, false]) {
      for (final origin in plan.media.origins.where(
        (candidate) => candidate.mainland == mainland,
      )) {
        if (plan.failed.contains(origin.uri)) continue;
        _ensureCurrent(transfer, plan);
        try {
          final ownValidator = await _admit(transfer, plan, origin, urgent);
          _ensureCurrent(transfer, plan);
          final chunk = await _readChunk(
            transfer,
            plan.media,
            origin,
            start,
            end,
            ownValidator,
            urgent,
          );
          _ensureCurrent(transfer, plan);
          return chunk;
        } catch (error) {
          _ensureCurrent(transfer, plan);
          _originInvalidated(transfer, origin, 'chunk_or_admission', error);
          plan.failed.add(origin.uri);
        }
      }
    }
    throw const HttpException('All CDN origins failed for this range');
  }

  Future<_Chunk> _measuredChunk(
    _Transfer transfer,
    _Plan plan,
    int start,
    int end,
    bool urgent,
  ) async {
    final available =
        plan.media.origins
            .where(
              (o) =>
                  plan.ready.containsKey(o.uri) && !plan.failed.contains(o.uri),
            )
            .toList()
          ..sort((a, b) => plan.cost(a.uri).compareTo(plan.cost(b.uri)));
    for (final origin in available) {
      if (plan.failed.contains(origin.uri)) continue;
      try {
        final result = await _hedgedMeasuredChunk(
          transfer,
          plan,
          origin,
          start,
          end,
          urgent,
        );
        _ensureCurrent(transfer, plan);
        final cost = result.seconds / result.chunk.bytes.length;
        plan.costs[result.origin.uri] =
            (plan.costs[result.origin.uri] ?? cost) * .5 + cost * .5;
        if (result.seconds > .7 && !plan.warmed) {
          plan.warmed = true;
          _warmPeersAtTwo(transfer, plan);
        }
        return result.chunk;
      } catch (error) {
        _ensureCurrent(transfer, plan);
        if (!plan.failed.contains(origin.uri)) {
          _failure(origin.uri, 'chunk_or_admission', error);
        }
        _originInvalidated(transfer, origin, 'chunk_or_admission', error);
        plan.failed.add(origin.uri);
      }
    }
    for (final origin in plan.media.origins.take(6)) {
      if (plan.failed.contains(origin.uri)) continue;
      final job = _Transfer(
        timeout,
        _wakeWaiters,
        plan.media,
        transfer.requestId,
        originIdleTimeout: const Duration(seconds: 3),
      );
      transfer.children.add(job);
      try {
        await _admit(job, plan, origin, true);
        return await _measuredChunk(transfer, plan, start, end, urgent);
      } catch (error) {
        _ensureCurrent(transfer, plan);
        _failure(origin.uri, 'chunk_or_admission', error);
        _originInvalidated(job, origin, 'chunk_or_admission', error);
        plan.failed.add(origin.uri);
      } finally {
        job.finish();
        transfer.children.remove(job);
      }
    }
    throw const HttpException('All CDN origins failed for this range');
  }

  Future<({CdnOrigin origin, _Chunk chunk, double seconds})>
  _hedgedMeasuredChunk(
    _Transfer parent,
    _Plan plan,
    CdnOrigin primary,
    int start,
    int end,
    bool urgent,
  ) async {
    final winner =
        Completer<({CdnOrigin origin, _Chunk chunk, double seconds})>();
    final jobs = <Uri, _Transfer>{};
    var active = 0;
    var hedged = false;
    void Function()? releaseExtra;
    Object? lastError;
    StackTrace? lastStack;
    late void Function(CdnOrigin) launch;
    bool hedge() {
      if (hedged || !parallel || concurrency < 2 || winner.isCompleted) {
        return false;
      }
      final peers =
          plan.media.origins
              .where(
                (o) =>
                    o.uri != primary.uri &&
                    plan.ready.containsKey(o.uri) &&
                    !plan.failed.contains(o.uri),
              )
              .toList()
            ..sort((a, b) => plan.cost(a.uri).compareTo(plan.cost(b.uri)));
      if (peers.isEmpty) return false;
      final size = end - start + 1;
      // Reserve the second BytesBuilder immediately or skip this hedge. Waiting
      // for our own first piece to release memory would create a deadlock.
      if (_bufferedBytes + size > _maxBufferedBytes) return false;
      _bufferedBytes += size;
      _hedgeBufferedBytes += size;
      _peakHedgeBufferedBytes = max(
        _peakHedgeBufferedBytes,
        _hedgeBufferedBytes,
      );
      _peakBufferedBytes = max(_peakBufferedBytes, _bufferedBytes);
      var released = false;
      releaseExtra = () {
        if (released) return;
        released = true;
        _bufferedBytes -= size;
        _hedgeBufferedBytes -= size;
        _wakeWaiters();
      };
      hedged = true;
      launch(peers.first);
      return true;
    }

    launch = (origin) {
      final job = _Transfer(
        timeout,
        _wakeWaiters,
        plan.media,
        parent.requestId,
        originIdleTimeout: const Duration(seconds: 3),
      );
      jobs[origin.uri] = job;
      parent.children.add(job);
      plan.active[origin.uri] = (plan.active[origin.uri] ?? 0) + 1;
      active++;
      unawaited(() async {
        try {
          final chunk = await _readChunk(
            job,
            plan.media,
            origin,
            start,
            end,
            plan.ready[origin.uri],
            urgent,
          );
          _ensureCurrent(parent, plan);
          if (!winner.isCompleted) {
            winner.complete((
              origin: origin,
              chunk: chunk,
              seconds: max(.001, job.originWatch.elapsedMicroseconds / 1e6),
            ));
          }
        } catch (error, stack) {
          if (!winner.isCompleted) {
            lastError = error;
            lastStack = stack;
            try {
              _ensureCurrent(parent, plan);
              _failure(origin.uri, 'chunk_or_admission', error);
              _originInvalidated(job, origin, 'chunk', error);
              plan.failed.add(origin.uri);
              hedge();
            } catch (sessionError, sessionStack) {
              winner.completeError(sessionError, sessionStack);
            }
          }
        } finally {
          job.finish();
          parent.children.remove(job);
          plan.active[origin.uri] = (plan.active[origin.uri] ?? 1) - 1;
          active--;
          if (active == 0) releaseExtra?.call();
          if (active == 0 && !winner.isCompleted) {
            winner.completeError(
              lastError ?? const HttpException('CDN range truncated'),
              lastStack,
            );
          }
        }
      }());
    };
    launch(primary);
    // At most one duplicate, exclusively from an already verified origin.
    // Queue time does not trigger the hedge; the global slot limit still holds.
    final timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      final first = jobs[primary.uri]!;
      if (first.activeSlots > 0 &&
          first.originWatch.elapsedMilliseconds >= 500) {
        hedge();
      }
    });
    Uri? won;
    try {
      final result = await winner.future;
      won = result.origin.uri;
      return result;
    } finally {
      timer.cancel();
      for (final entry in jobs.entries) {
        if (entry.key != won) entry.value.cancel();
      }
    }
  }

  Future<_BufferedChunk> _buffered(
    _Transfer transfer,
    _Plan plan,
    int start,
    int end, {
    bool urgent = false,
  }) async {
    final size = end - start + 1;
    void Function()? release;
    try {
      while (_bufferedBytes + size > _maxBufferedBytes) {
        transfer.check();
        final waiter = Completer<void>();
        _waiters.add(waiter);
        await waiter.future;
      }
      transfer.check();
      _bufferedBytes += size;
      _peakBufferedBytes = max(_peakBufferedBytes, _bufferedBytes);
      var released = false;
      void free() {
        if (released) return;
        released = true;
        _bufferedBytes -= size;
        transfer.buffers.remove(free);
        _wakeWaiters();
      }

      release = free;
      transfer.buffers.add(free);
      return _BufferedChunk(
        await _chunk(transfer, plan, start, end, urgent),
        free,
      );
    } catch (error, stack) {
      release?.call();
      return _BufferedChunk.error(error, stack);
    }
  }

  Future<void> _passthrough(
    _Transfer transfer,
    _Media media,
    HttpRequest request,
    _MediaResponse output,
  ) {
    final diagnostic = _requestDiagnostics?.request(
      transfer,
      media.uri,
      request.headers.value(HttpHeaders.rangeHeader),
      'fallback',
      true,
    );
    return _slot(
      transfer,
      () async {
        _trace?.mark(
          CdnStartupStage.fallback,
          track: media.track,
          requestId: transfer.requestId,
        );
        final upstream = await _open(
          transfer,
          media,
          request.method,
          request.headers.value(HttpHeaders.rangeHeader),
          diagnostic: diagnostic,
        );
        output.statusCode = upstream.statusCode;
        for (final name in const [
          HttpHeaders.contentTypeHeader,
          HttpHeaders.contentRangeHeader,
          HttpHeaders.acceptRangesHeader,
          HttpHeaders.contentEncodingHeader,
          HttpHeaders.etagHeader,
          HttpHeaders.lastModifiedHeader,
        ]) {
          final value = upstream.headers.value(name);
          if (value != null) output.headers.set(name, value);
        }
        output.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
        output.contentLength = upstream.contentLength;
        if (request.method == 'HEAD') {
          await upstream.listen((_) {}).cancel();
        } else {
          await for (final data in upstream.timeout(timeout)) {
            transfer.check();
            _observedUpstreamBytes += data.length;
            diagnostic?.progress(data.length);
            output.add(data);
            await output.flush();
          }
        }
        diagnostic?.end('body_complete');
        await output.close();
      },
      urgent: true,
      diagnostic: diagnostic,
    );
  }
}

/// Opt-in, bounded observations only. Never retain URLs, headers, validators,
/// payloads, exception text, or account data. No I/O is performed by observers.
final class _RequestDiagnostics {
  _RequestDiagnostics(this.limit, this.state);
  final int limit;
  final Map<String, int> Function() state;
  final Stopwatch clock = Stopwatch()..start();
  final int clockOriginUnixMs = DateTime.now().millisecondsSinceEpoch;
  final List<Map<String, Object>> events = [];
  final Map<String, int> hostRequests = {};
  final Map<String, int> trackFlushedBytes = {};
  int dropped = 0;
  int nextRequestId = 0;
  int nextTransferId = 0;
  int observedBodyBytes = 0;
  int hostRequestsDropped = 0;
  static const hostCountsLimit = 128;

  Map<String, Object> get snapshot => {
    'event_clock': 'proxy_monotonic',
    'clock_origin_unix_ms': clockOriginUnixMs,
    'elapsed_ms': clock.elapsedMilliseconds,
    'request_events_limit': limit,
    'request_events_dropped': dropped,
    'request_events': List<Map<String, Object>>.of(events),
    'host_request_counts': Map<String, int>.of(hostRequests),
    'host_request_counts_limit': hostCountsLimit,
    'host_request_counts_dropped': hostRequestsDropped,
    // Counts bytes accepted by a successful socket flush, not decoded media.
    'track_flushed_body_bytes': Map<String, int>.of(trackFlushedBytes),
    'diagnostic_upstream_body_bytes': observedBodyBytes,
  };

  _RequestDiagnostic request(
    _Transfer transfer,
    Uri uri,
    String? range,
    String phase,
    bool urgent,
  ) {
    final value = _RequestDiagnostic(
      this,
      transfer,
      ++nextRequestId,
      uri.host,
      transfer.media.origins.indexWhere((value) => value.uri == uri) + 1,
      range,
      phase,
      urgent
          ? 'urgent'
          : transfer.background
          ? 'background'
          : 'normal',
    );
    transfer.diagnosticRequests.add(value);
    value.event('request_created');
    return value;
  }

  void event(
    String name, {
    required _Transfer transfer,
    _RequestDiagnostic? request,
    String? domain,
    String? range,
    String? phase,
    String? kind,
    int? http,
    int? window,
    int? rateBytesPerSecond,
    int? targetBytesPerSecond,
    int? flushedBytes,
    int? actualStart,
    int? actualEnd,
    int? total,
    int? contentLength,
    int? originId,
    bool? accepted,
    bool? validatorChecked,
    bool? etagEqual,
    bool? modifiedEqual,
    bool? encodingIdentity,
    int? expectedTotal,
  }) {
    if (events.length >= limit) {
      dropped++;
      return;
    }
    // Range text is accepted only by the numeric grammar; no raw string escapes.
    final parsed = RegExp(r'^bytes=(\d*)-(\d*)$')
        .firstMatch(range ?? request?.range ?? '');
    final start = parsed == null ? null : int.tryParse(parsed[1]!);
    final end = parsed == null ? null : int.tryParse(parsed[2]!);
    events.add({
      't_ms': clock.elapsedMilliseconds,
      'event': name,
      'parent_id': transfer.requestId,
      'transfer_id': transfer.diagnosticId,
      'track': transfer.track.name,
      if (request != null) 'request_id': request.id,
      if (request != null) 'attempt': request.attempt,
      if (request != null) 'priority': request.priority,
      if (request != null || originId != null)
        'origin_id': originId ?? request!.originId,
      if (domain != null || request != null)
        'domain': domain ?? request!.domain,
      if (phase != null || request != null) 'phase': phase ?? request!.phase,
      'kind': ?kind,
      'http': ?http,
      'range_start': ?start,
      if (end != null && start != null) 'range_end': end,
      if (end != null && start == null) 'range_suffix': end,
      if (request != null) 'upstream_bytes': request.bytes,
      'flushed_body_bytes': ?flushedBytes,
      'window': ?window,
      'rate_bytes_per_second': ?rateBytesPerSecond,
      'target_bytes_per_second': ?targetBytesPerSecond,
      'actual_range_start': ?actualStart,
      'actual_range_end': ?actualEnd,
      'resource_total': ?total,
      'content_length': ?contentLength,
      'accepted': ?accepted,
      'validator_checked': ?validatorChecked,
      'etag_equal': ?etagEqual,
      'modified_equal': ?modifiedEqual,
      'encoding_identity': ?encodingIdentity,
      'expected_resource_total': ?expectedTotal,
      ...state(),
    });
  }
}

final class _RequestDiagnostic {
  _RequestDiagnostic(
    this.owner,
    this.transfer,
    this.id,
    this.domain,
    this.originId,
    this.range,
    this.phase,
    this.priority,
  );
  final _RequestDiagnostics owner;
  final _Transfer transfer;
  final int id;
  String domain;
  final String? range;
  final String phase;
  final String priority;
  final int originId;
  int attempt = 0;
  int bytes = 0;
  int lastBytes = 0;
  int lastMs = 0;
  bool ended = false;
  bool first = true;

  void event(
    String name, {
    int? http,
    String? kind,
    int? actualStart,
    int? actualEnd,
    int? total,
    int? contentLength,
  }) => owner.event(
    name,
    transfer: transfer,
    request: this,
    http: http,
    kind: kind,
    actualStart: actualStart,
    actualEnd: actualEnd,
    total: total,
    contentLength: contentLength,
  );

  void open(Uri uri, int number) {
    domain = uri.host;
    attempt = number;
    if (owner.hostRequests.containsKey(domain)) {
      owner.hostRequests[domain] = owner.hostRequests[domain]! + 1;
    } else if (owner.hostRequests.length <
        _RequestDiagnostics.hostCountsLimit) {
      owner.hostRequests[domain] = 1;
    } else {
      owner.hostRequestsDropped++;
    }
    event('request_open');
  }

  void progress(int count) {
    bytes += count;
    owner.observedBodyBytes += count;
    final now = owner.clock.elapsedMilliseconds;
    if (first && count > 0) {
      first = false;
      lastMs = now;
      lastBytes = bytes;
      event('body_first');
    } else if (now - lastMs >= 500 &&
        (bytes - lastBytes >= 256 * 1024 || now - lastMs >= 1000)) {
      lastMs = now;
      lastBytes = bytes;
      event('body_progress');
    }
  }

  void validation(
    bool accepted,
    String kind, {
    required _Chunk? expected,
    required String? etag,
    required String? modified,
    required String? encoding,
  }) => owner.event(
    'range_validation',
    transfer: transfer,
    request: this,
    kind: kind,
    accepted: accepted,
    validatorChecked: expected != null,
    etagEqual: expected == null ? null : etag == expected.etag,
    modifiedEqual: expected == null ? null : modified == expected.modified,
    encodingIdentity: encoding == null || encoding == 'identity',
    expectedTotal: expected?.total,
  );

  static String errorKind(Object error) {
    if (error is TimeoutException) return 'timeout';
    if (error is SocketException) return 'socket';
    if (error is HttpException) {
      return switch (error.message) {
        'CDN request cancelled' => 'cancelled',
        'CDN range metadata mismatch' => 'range_metadata',
        'CDN range length mismatch' => 'range_length',
        'CDN range truncated' => 'truncated',
        'CDN range too long' => 'range_overflow',
        'CDN resource identity mismatch' => 'identity',
        'CDN resource version changed' => 'resource_changed',
        'Invalid CDN redirect' ||
        'Unsupported CDN redirect' ||
        'Too many CDN redirects' => 'redirect',
        _ => 'http',
      };
    }
    return 'other';
  }

  void fail(Object error) => end('failure', kind: errorKind(error));

  void end(String name, {String? kind}) {
    if (ended) return;
    ended = true;
    event(name, kind: kind);
  }
}

final class _Media {
  _Media(this.uri, this.headers, this.origins, this.track, this.diagnostics);
  final Uri uri;
  final Map<String, String> headers;
  final List<CdnOrigin> origins;
  final CdnStartupTrack track;
  final _RequestDiagnostics? diagnostics;
  final Queue<HttpClient> _idleClients = Queue();
  CdnOrigin? preferred;
  _IdentityCache? identity;
  _ObservedVersion? observed;
  int identityEpoch = 0;
  bool _closed = false;

  HttpClient acquire(Duration timeout) {
    if (_idleClients.isNotEmpty) return _idleClients.removeFirst();
    return HttpClient()
      ..autoUncompress = false
      ..connectionTimeout = timeout
      ..idleTimeout = const Duration(seconds: 5)
      ..findProxy = ((_) => 'DIRECT');
  }

  void release(HttpClient client) {
    if (_closed || _idleClients.length >= 2) {
      client.close(force: true);
    } else {
      _idleClients.add(client);
    }
  }

  void close() {
    _closed = true;
    identityEpoch++;
    identity = null;
    observed = null;
    for (final client in _idleClients) {
      client.close(force: true);
    }
    _idleClients.clear();
  }
}

final class _ObservedVersion {
  const _ObservedVersion(this.anchor, this.reference);
  final CdnOrigin anchor;
  final _Chunk reference;
}

final class _IdentityCache {
  _IdentityCache(this.anchor, this.reference, this.samples);
  final CdnOrigin anchor;
  final _Chunk reference;
  final List<_Chunk> samples;
  final Map<Uri, _Chunk> admitted = {};
  final DateTime expiresAt = DateTime.now().add(const Duration(seconds: 30));
}

/// Recent upstream wait and bytes. Player flush/backpressure is never sampled.
final class _OriginSupply {
  final Queue<(double, int)> _samples = Queue();
  double _wait = 0;
  double _observedWait = 0;
  double _totalWait = 0;
  int _bytes = 0;
  bool get hasWindow => _observedWait >= 1.5;
  double get rate => _bytes / max(.001, _wait);
  double get totalWait => _totalWait;
  void resetWindow() {
    _samples.clear();
    _wait = 0;
    _observedWait = 0;
    _bytes = 0;
  }

  void record(int bytes, double seconds) {
    final elapsed = max(.000001, seconds);
    _samples.add((elapsed, bytes));
    _wait += elapsed;
    _observedWait += elapsed;
    _totalWait += elapsed;
    _bytes += bytes;
    while (_samples.length > 128 ||
        (_samples.length > 1 && _wait - _samples.first.$1 > 2)) {
      final removed = _samples.removeFirst();
      _wait -= removed.$1;
      _bytes -= removed.$2;
    }
  }
}

final class _Plan {
  _Plan(
    this.media,
    this.anchor,
    this.reference,
    this.failed,
    this.cached,
    this.identityEpoch,
  ) {
    admitted[anchor.uri] = Future.value(reference);
    ready[anchor.uri] = reference;
  }
  final _Media media;
  final CdnOrigin anchor;
  final _Chunk reference;
  final Set<Uri> failed;
  final _IdentityCache? cached;
  final int identityEpoch;
  final Map<Uri, Future<_Chunk>> admitted = {};
  final Map<Uri, _Chunk> ready = {};
  Future<List<_Chunk>>? samples;
  int cursor = 0;
  bool warmed = false;
  bool rampFinished = false;
  final Map<Uri, double> costs = {};
  final Map<Uri, int> active = {};
  double cost(Uri uri) => (costs[uri] ?? 0) * (1 + (active[uri] ?? 0));
}

final class _BufferedChunk {
  _BufferedChunk(this.chunk, this.release) : error = null, stack = null;
  _BufferedChunk.error(this.error, this.stack) : chunk = null, release = _noop;
  final _Chunk? chunk;
  final Object? error;
  final StackTrace? stack;
  final void Function() release;
  static void _noop() {}
  void check() {
    if (error != null) Error.throwWithStackTrace(error!, stack!);
  }
}

final class _Chunk {
  const _Chunk(
    this.bytes,
    this.end,
    this.total,
    this.contentType,
    this.etag,
    this.modified,
  );
  final Uint8List bytes;
  final int end;
  final int total;
  final String? contentType;
  final String? etag;
  final String? modified;
}

final class _Transfer {
  _Transfer(
    Duration timeout,
    this._onCancel,
    this._media,
    this.requestId, {
    this.background = false,
    this.originIdleTimeout,
  }) : client = _media.acquire(timeout),
       track = _media.track,
       diagnosticId = _media.diagnostics == null
           ? 0
           : ++_media.diagnostics!.nextTransferId;
  final _Media _media;
  _Media get media => _media;
  final HttpClient client;
  final CdnStartupTrack track;
  final int requestId;
  final int diagnosticId;
  final List<_RequestDiagnostic> diagnosticRequests = [];
  final bool background;
  final Duration? originIdleTimeout;
  final Stopwatch originWatch = Stopwatch();
  Timer? _originIdleTimer;
  final void Function() _onCancel;
  bool _cancelled = false;
  final cancellation = Completer<void>();
  double lastBodySeconds = 0;
  bool _outputComplete = false;
  bool preempted = false;
  int activeSlots = 0;
  bool get cancelled => _cancelled;
  int pendingWork = 0;
  bool reportedHeaders = false;
  bool reportedFirstByte = false;
  bool reportedIdentity = false;
  bool reportedQueue = false;
  bool reportedSlot = false;
  final Set<void Function()> buffers = {};
  final Set<_Transfer> children = {};
  final Set<void Function()> originIoCancels = {};
  Socket? _socket;
  StreamSubscription<Uint8List>? _subscription;
  void beginOriginWork() {
    originWatch.start();
    originProgress();
  }

  void originProgress() {
    final idle = originIdleTimeout;
    if (idle == null || _cancelled) return;
    _originIdleTimer?.cancel();
    _originIdleTimer = Timer(idle, () => cancel(reason: 'origin_idle_timeout'));
  }

  void endOriginWatchdog() {
    _originIdleTimer?.cancel();
    _originIdleTimer = null;
  }

  void endOriginWork() {
    originWatch.stop();
    endOriginWatchdog();
  }

  void attach(Socket socket) {
    _socket = socket;
    if (_cancelled) {
      socket.destroy();
      return;
    }
    _subscription = socket.listen(
      (_) {},
      onDone: () {
        if (!_outputComplete) cancel(reason: 'downstream_closed');
      },
      onError: (Object _) => cancel(reason: 'downstream_error'),
    );
    unawaited(
      socket.done.then<void>(
        (_) {},
        onError: (Object _) => cancel(reason: 'downstream_error'),
      ),
    );
  }

  void check() {
    if (_cancelled) throw const HttpException('CDN request cancelled');
  }

  void markOutputComplete() => _outputComplete = true;

  void cancel({String reason = 'cancelled'}) {
    if (_cancelled) return;
    if (preempted && reason == 'cancelled') reason = 'preempted';
    _media.diagnostics?.event('cancel', transfer: this, kind: reason);
    for (final request in diagnosticRequests) {
      request.end('cancel', kind: reason);
    }
    _cancelled = true;
    cancellation.complete();
    for (final cancel in originIoCancels.toList()) {
      cancel();
    }
    endOriginWork();
    for (final child in children.toList()) {
      child.cancel(reason: 'parent_cancelled');
    }
    client.close(force: true);
    for (final release in buffers.toList()) {
      release();
    }
    _socket?.destroy();
    unawaited(_subscription?.cancel());
    _onCancel();
  }

  void finish() {
    if (_cancelled) return;
    if (pendingWork != 0) {
      cancel(reason: 'unfinished_work');
      return;
    }
    _media.diagnostics?.event('transfer_complete', transfer: this);
    _cancelled = true;
    cancellation.complete();
    for (final cancel in originIoCancels.toList()) {
      cancel();
    }
    endOriginWork();
    for (final child in children.toList()) {
      child.cancel(reason: 'parent_finished');
    }
    for (final release in buffers.toList()) {
      release();
    }
    _media.release(client);
    unawaited(_subscription?.cancel());
    _onCancel();
  }
}

final class _SlotWaiter {
  _SlotWaiter(this.transfer, this.urgent);
  final _Transfer transfer;
  final bool urgent;
  final Completer<void> completer = Completer<void>();
  bool granted = false;
}

/// Minimal close-delimited HTTP/1.1 writer for the detached media connection.
/// Known lengths are advertised for seeking; unknown fallback bodies terminate
/// on close. HTTP parsing remains the responsibility of dart:io's HttpServer.
final class _MediaResponse {
  _MediaResponse(this._socket, this._transfer) {
    // One cancellation observer per response, rather than one retained Future
    // listener for every data block during a long-running playback session.
    unawaited(
      _transfer!.cancellation.future.then((_) {
        final pending = _pendingWrite;
        if (pending != null && !pending.isCompleted) {
          pending.completeError(const HttpException('CDN request cancelled'));
        }
      }),
    );
  }
  _MediaResponse.pending() : _socket = null, _transfer = null;
  final Socket? _socket;
  final _Transfer? _transfer;
  int _pendingBodyBytes = 0;
  int _flushedBodyBytes = 0;
  int _lastDiagnosticMs = 0;
  int _lastDiagnosticBytes = 0;
  Completer<void>? _pendingWrite;
  final headers = _MediaHeaders();
  int statusCode = HttpStatus.ok;
  bool started = false;
  set contentLength(int value) {
    if (value >= 0) {
      headers.set(HttpHeaders.contentLengthHeader, value.toString());
    } else {
      headers.values.remove(HttpHeaders.contentLengthHeader);
    }
  }

  void _commit() {
    if (started) return;
    final socket = _socket;
    if (socket == null) throw const HttpException('Missing media connection');
    final text = StringBuffer('HTTP/1.1 $statusCode Media response\r\n');
    headers.values.forEach((name, value) {
      if (name.contains(RegExp(r'[\r\n]')) ||
          value.contains(RegExp(r'[\r\n]'))) {
        throw const HttpException('Invalid media header');
      }
      text.write('$name: $value\r\n');
    });
    text.write('connection: close\r\n\r\n');
    socket.add(latin1.encode(text.toString()));
    started = true;
  }

  void add(List<int> bytes) {
    _commit();
    _socket!.add(bytes);
    if (_transfer?.media.diagnostics != null) _pendingBodyBytes += bytes.length;
  }

  Future<void> _waitForWrite(Future<void> Function() write) async {
    _transfer!.check();
    final pending = Completer<void>();
    _pendingWrite = pending;
    unawaited(
      write().then(
        (_) {
          if (!pending.isCompleted) pending.complete();
        },
        onError: (Object error, StackTrace stack) {
          if (!pending.isCompleted) pending.completeError(error, stack);
        },
      ),
    );
    try {
      await pending.future;
      _transfer.check();
    } finally {
      if (identical(_pendingWrite, pending)) _pendingWrite = null;
    }
  }

  Future<void> flush() async {
    _commit();
    // A full/paused player may hold this socket longer than an upstream idle
    // timeout. Cancellation still ends the wait and destroys the socket.
    await _waitForWrite(() => _socket!.flush());
    final diagnostic = _transfer?.media.diagnostics;
    if (diagnostic != null && _pendingBodyBytes > 0) {
      final first = _flushedBodyBytes == 0;
      _flushedBodyBytes += _pendingBodyBytes;
      diagnostic.trackFlushedBytes.update(
        _transfer!.track.name,
        (count) => count + _pendingBodyBytes,
        ifAbsent: () => _pendingBodyBytes,
      );
      _pendingBodyBytes = 0;
      final now = diagnostic.clock.elapsedMilliseconds;
      if (first ||
          (now - _lastDiagnosticMs >= 500 &&
              (_flushedBodyBytes - _lastDiagnosticBytes >= 256 * 1024 ||
                  now - _lastDiagnosticMs >= 1000))) {
        _lastDiagnosticMs = now;
        _lastDiagnosticBytes = _flushedBodyBytes;
        diagnostic.event(
          'output_progress',
          transfer: _transfer,
          flushedBytes: _flushedBodyBytes,
        );
      }
    }
  }

  Future<void> close() async {
    await flush();
    await _waitForWrite(() => _socket!.close().then<void>((_) {}));
    _transfer?.media.diagnostics?.event(
      'output_complete',
      transfer: _transfer,
      flushedBytes: _flushedBodyBytes,
    );
  }
}

final class _MediaHeaders {
  final Map<String, String> values = {};
  void set(String name, Object value) => values[name] = value.toString();
}

final class _StreamingOrigin {
  _StreamingOrigin(
    this.job,
    this.origin,
    this.body,
    this.first,
    this.start,
    this.end,
    this.reference,
    this.diagnostic,
  );
  final _Transfer job;
  final CdnOrigin origin;
  final StreamIterator<List<int>> body;
  final Uint8List first;
  final int start;
  final int end;
  final _Chunk reference;
  final _RequestDiagnostic? diagnostic;
  final release = Completer<void>();
}
