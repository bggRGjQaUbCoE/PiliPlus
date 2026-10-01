import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'package:PiliPlus/services/video_accelerator/accelerator_config.dart';

class ProbeCancellation {
  bool cancelled = false;
  void Function()? _close;
  void cancel() {
    cancelled = true;
    _close?.call();
  }
}

class ProbeResult {
  const ProbeResult({
    this.bytes = 0,
    this.elapsed = Duration.zero,
    this.ttfb = Duration.zero,
    this.totalBytes,
    this.status,
    this.timeout = false,
    this.error,
    this.fingerprint,
  });
  final int bytes;
  final Duration elapsed, ttfb;
  final int? totalBytes, status;
  final bool timeout;
  final String? error;
  final String? fingerprint;
  bool get ok => error == null && bytes > 0;
  double get throughputBps =>
      elapsed.inMicroseconds <= 0 ? 0 : bytes * 8e6 / elapsed.inMicroseconds;
}

typedef ProbeTransport = Future<ProbeResult> Function(
  Uri uri,
  AcceleratorConfig config,
  ProbeCancellation cancellation,
);

class CdnProbe {
  // One shared queue for automatic and settings probes in this app isolate.
  static Future<void> _tail = Future<void>.value();
  static int manualTesting = 0;
  CdnProbe({required this.headers, this.clientFactory = _newClient});
  final Map<String, String> headers;
  final HttpClient Function() clientFactory;
  static HttpClient _newClient() => HttpClient();

  Future<ProbeResult> run(
    Uri uri,
    AcceleratorConfig config,
    ProbeCancellation cancellation,
  ) async {
    final previous = _tail;
    final released = Completer<void>();
    _tail = released.future;
    try {
      await previous;
      return await _run(uri, config, cancellation);
    } finally {
      released.complete();
    }
  }

  Future<ProbeResult> _run(
    Uri uri,
    AcceleratorConfig config,
    ProbeCancellation cancellation,
  ) async {
    if (cancellation.cancelled) return const ProbeResult(error: 'cancelled');
    final client = clientFactory()..autoUncompress = false;
    cancellation._close = () => client.close(force: true);
    final watch = Stopwatch()..start();
    int? status;
    Future<ProbeResult> transfer() async {
      final request = await client.getUrl(uri);
      request.followRedirects = false;
      headers.forEach(request.headers.set);
      request.headers.set(HttpHeaders.acceptEncodingHeader, 'identity');
      request.headers.set(
        HttpHeaders.rangeHeader,
        'bytes=0-${config.probeBytes - 1}',
      );
      final response = await request.close();
      status = response.statusCode;
      if (status != HttpStatus.partialContent) {
        // Never drain a full video when a CDN ignores Range.
        return ProbeResult(status: status, error: 'range-status');
      }
      final match = RegExp(r'^bytes (\d+)-(\d+)/(\d+)$').firstMatch(
        response.headers.value(HttpHeaders.contentRangeHeader) ?? '',
      );
      if (match == null) {
        return ProbeResult(status: status, error: 'content-range');
      }
      final start = int.parse(match[1]!), end = int.parse(match[2]!);
      final total = int.parse(match[3]!);
      final expected = total < config.probeBytes ? total : config.probeBytes;
      if (start != 0 ||
          end != expected - 1 ||
          total <= end ||
          (response.contentLength != -1 &&
              response.contentLength != expected) ||
          (response.headers.value(HttpHeaders.contentEncodingHeader) ??
                  'identity') !=
              'identity') {
        return ProbeResult(status: status, error: 'range-mismatch');
      }
      var received = 0;
      final digest = _DigestSink();
      final hasher = sha256.startChunkedConversion(digest);
      Duration? firstByte;
      await for (final chunk in response) {
        if (cancellation.cancelled) {
          return const ProbeResult(error: 'cancelled');
        }
        firstByte ??= watch.elapsed;
        received += chunk.length;
        hasher.add(chunk);
        if (received > expected) {
          return ProbeResult(status: status, error: 'oversized');
        }
      }
      if (received != expected || received < config.minimumSampleBytes) {
        return ProbeResult(status: status, error: 'short-body');
      }
      hasher.close();
      return ProbeResult(
        bytes: received,
        elapsed: watch.elapsed,
        ttfb: firstByte ?? watch.elapsed,
        totalBytes: total,
        status: status,
        fingerprint: digest.value?.toString(),
      );
    }

    try {
      return await transfer().timeout(config.probeTimeout);
    } on TimeoutException {
      return ProbeResult(status: status, timeout: true, error: 'timeout');
    } catch (_) {
      return ProbeResult(
        status: status,
        error: cancellation.cancelled ? 'cancelled' : 'transport',
      );
    } finally {
      cancellation._close = null;
      client.close(force: true);
      watch.stop();
    }
  }
}

class _DigestSink implements Sink<Digest> {
  Digest? value;
  @override
  void add(Digest data) {
    value = data;
  }

  @override
  void close() {}
}
