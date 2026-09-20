import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' show max, min;
import 'dart:typed_data';

import 'package:PiliPlus/http/browser_ua.dart';
import 'package:PiliPlus/http/constants.dart';
import 'package:PiliPlus/services/multi_thread/cdn_resolver.dart';

const _pieceRounds = 3;
const _pieceRetryWindow = Duration(seconds: 25);
const _firstByteTimeout = Duration(milliseconds: 5500);
const _stallTimeout = Duration(seconds: 4);
const _attemptTimeout = Duration(seconds: 15);
const _hedgeDelay = Duration(milliseconds: 900);
const _startupHedgeDelay = Duration(milliseconds: 250);
const minChunkBytes = 64 * 1024;
const _totalMismatch = '不同 CDN 返回的文件总长度不一致';

class CancelledException implements Exception {
  const CancelledException();

  @override
  String toString() => 'cancelled';
}

class CancelToken {
  bool _cancelled = false;
  final _callbacks = <void Function()>[];
  final _completer = Completer<void>();

  bool get isCancelled => _cancelled;

  Future<void> get whenCancelled => _completer.future;

  void add(void Function() callback) => _callbacks.add(callback);

  void remove(void Function() callback) => _callbacks.remove(callback);

  /// 随父级一同取消，子级取消后从父级注销
  CancelToken child() {
    final token = CancelToken();
    if (_cancelled) return token..cancel();
    void relay() => token.cancel();
    add(relay);
    token.add(() => remove(relay));
    return token;
  }

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _completer.complete();
    for (final callback in _callbacks.toList()) {
      callback();
    }
    _callbacks.clear();
  }

  void throwIfCancelled() {
    if (_cancelled) throw const CancelledException();
  }
}

class ByteRange {
  final int start;
  final int end;

  const ByteRange(this.start, this.end);

  int get length => end - start + 1;
}

class _Piece extends ByteRange {
  final int index;

  const _Piece(this.index, super.start, super.end);
}

class PieceResult {
  final Uint8List bytes;
  final int? total;
  final String url;

  const PieceResult(this.bytes, this.total, this.url);
}

class RangeResult {
  final Uint8List? bytes;
  final int? total;

  const RangeResult(this.bytes, this.total);
}

class _Waiter {
  final Completer<void> completer = Completer();
  final CancelToken? cancel;
  final int priority;
  final int sequence;

  _Waiter(this.cancel, this.priority, this.sequence);
}

/// 带优先级的全局并发信号量：起播、救援等紧急请求排在前面
class PrioritySemaphore {
  int _limit;
  int _active = 0;
  int _sequence = 0;
  final _queue = <_Waiter>[];

  PrioritySemaphore(int limit) : _limit = _clamp(limit);

  static int _clamp(int limit) => max(1, min(512, limit));

  set limit(int value) {
    _limit = _clamp(value);
    _drain();
  }

  void _drain() {
    while (_active < _limit && _queue.isNotEmpty) {
      final waiter = _queue.removeAt(0);
      if (waiter.cancel?.isCancelled == true) {
        waiter.completer.completeError(const CancelledException());
        continue;
      }
      _active++;
      waiter.completer.complete();
    }
  }

  Future<void> acquire(CancelToken? cancel, int priority) {
    cancel?.throwIfCancelled();
    if (_active < _limit && _queue.isEmpty) {
      _active++;
      return Future.value();
    }
    final waiter = _Waiter(cancel, priority, _sequence++);
    _queue
      ..add(waiter)
      ..sort(
        (a, b) => b.priority != a.priority
            ? b.priority - a.priority
            : a.sequence - b.sequence,
      );
    _drain();
    return waiter.completer.future;
  }

  void release() {
    _active = max(0, _active - 1);
    _drain();
  }
}

/// 分块下载器：把一个字节范围切成子块，从多个节点并发下载并按序交付
class RangeDownloader {
  final PrioritySemaphore semaphore;
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 6)
    ..idleTimeout = const Duration(seconds: 30)
    ..autoUncompress = false;

  RangeDownloader(this.semaphore);

  /// 单次请求：校验 206 与 Content-Range，长度不符即失败
  Future<PieceResult> _attempt(
    _Piece piece,
    String url,
    CancelToken cancel,
    CdnResolver resolver,
    int priority,
  ) async {
    await semaphore.acquire(cancel, priority);
    var received = 0;
    final stopwatch = Stopwatch()..start();
    try {
      cancel.throwIfCancelled();
      final request = await _client.getUrl(Uri.parse(url));
      request.headers
        ..set(HttpHeaders.rangeHeader, 'bytes=${piece.start}-${piece.end}')
        ..set(HttpHeaders.userAgentHeader, BrowserUa.pc)
        ..set(HttpHeaders.refererHeader, HttpString.baseUrl);
      void abort() => request.abort(const CancelledException());
      cancel.add(abort);
      final HttpClientResponse response;
      try {
        response = await request.close().timeout(
          _firstByteTimeout,
          onTimeout: () {
            request.abort();
            throw TimeoutException('CDN 首字节超时', _firstByteTimeout);
          },
        );
      } finally {
        cancel.remove(abort);
      }
      final contentRange = _parseContentRange(
        response.headers.value(HttpHeaders.contentRangeHeader),
      );
      if (response.statusCode != HttpStatus.partialContent ||
          contentRange == null ||
          contentRange.$1 != piece.start ||
          contentRange.$2 != piece.end) {
        throw CdnHttpException(
          response.statusCode,
          'Range 校验失败：HTTP ${response.statusCode}',
          uri: request.uri,
        );
      }
      final bytes = await _readBody(
        response,
        piece.length,
        cancel,
        stopwatch,
        (n) => received += n,
      );
      final seconds = max(0.001, stopwatch.elapsedMicroseconds / 1e6);
      resolver.success(url, bytes.length / seconds);
      return PieceResult(bytes, contentRange.$3, url);
    } catch (e) {
      if (e is! CancelledException) resolver.failure(url, e, received);
      rethrow;
    } finally {
      semaphore.release();
    }
  }

  static (int, int, int?)? _parseContentRange(String? value) {
    if (value == null) return null;
    final match = RegExp(r'^bytes\s+(\d+)-(\d+)/(\d+|\*)$').firstMatch(value);
    if (match == null) return null;
    final start = int.parse(match[1]!);
    final end = int.parse(match[2]!);
    final total = match[3] == '*' ? null : int.parse(match[3]!);
    if (end < start || (total != null && total <= end)) return null;
    return (start, end, total);
  }

  Future<Uint8List> _readBody(
    HttpClientResponse response,
    int expected,
    CancelToken cancel,
    Stopwatch stopwatch,
    void Function(int) onProgress,
  ) async {
    final builder = BytesBuilder(copy: false);
    final completer = Completer<void>();
    late final StreamSubscription<List<int>> subscription;
    void fail(Object error) {
      if (completer.isCompleted) return;
      completer.completeError(error);
      subscription.cancel();
    }

    subscription = response.timeout(_stallTimeout).listen(
      (chunk) {
        builder.add(chunk);
        onProgress(chunk.length);
        if (builder.length > expected) {
          fail(const HttpException('子块长度超出'));
        } else if (stopwatch.elapsed > _attemptTimeout) {
          fail(TimeoutException('子块总耗时超限', _attemptTimeout));
        }
      },
      onError: fail,
      onDone: () {
        if (!completer.isCompleted) completer.complete();
      },
      cancelOnError: true,
    );
    void stop() => fail(const CancelledException());
    cancel.add(stop);
    try {
      await completer.future;
    } finally {
      cancel.remove(stop);
    }
    if (builder.length != expected) {
      throw HttpException('子块长度不符：${builder.length}/$expected');
    }
    return builder.takeBytes();
  }

  static Future<void> _pause(Duration delay, CancelToken cancel) {
    return Future.any<void>([Future.delayed(delay), cancel.whenCancelled])
        .then((_) => cancel.throwIfCancelled());
  }

  /// 候选顺序：优先地址（按块轮转）与救援地址交错，再补上其余全部
  List<String> _pieceCandidates(
    _Piece piece,
    CdnResolver resolver,
    List<String> preferred,
    int round,
  ) {
    final offset = preferred.isEmpty
        ? 0
        : (piece.index + round) % preferred.length;
    final rotated = [...preferred.skip(offset), ...preferred.take(offset)];
    final rescue = resolver
        .rescueCandidates()
        .where((url) => !rotated.contains(url))
        .toList();
    final candidates = <String>[];
    final width = max(rotated.length, rescue.length);
    for (var i = 0; i < width; i++) {
      if (i < rotated.length) candidates.add(rotated[i]);
      if (i < rescue.length) candidates.add(rescue[i]);
    }
    for (final url in resolver.ordered(piece.index)) {
      if (!candidates.contains(url)) candidates.add(url);
    }
    return candidates;
  }

  /// 下载一个子块：每轮把候选按 2 路对冲逐批尝试（探测模式则全部同时发出），
  /// 第一路失败立即放出第二路；一轮全败后退避再来，最多三轮
  Future<PieceResult> _downloadPiece(
    _Piece piece,
    CdnResolver resolver,
    CancelToken cancel,
    List<String> preferred, {
    bool startup = false,
    bool probe = false,
    int priority = 0,
  }) async {
    final stopwatch = Stopwatch()..start();
    Object? lastError;
    for (var round = 0; round < _pieceRounds; round++) {
      if (round > 0) {
        if (stopwatch.elapsed > _pieceRetryWindow) break;
        await _pause(
          Duration(milliseconds: min(2000, 500 * (1 << (round - 1)))),
          cancel,
        );
      }
      final candidates = _pieceCandidates(piece, resolver, preferred, round);
      final limit = min(8, candidates.length);
      final batchWidth = probe ? limit : 2;
      final tried = <String>{};
      while (tried.length < limit) {
        cancel.throwIfCancelled();
        // 跳过已封禁节点，除非只剩封禁节点
        final untried = candidates
            .where((url) => !tried.contains(url))
            .toList();
        final open = untried.where(resolver.allows).toList();
        final batch = (open.isEmpty ? untried : open).take(batchWidth).toList();
        if (batch.isEmpty) break;
        tried.addAll(batch);
        final hedgeDelay = probe
            ? Duration.zero
            : startup
            ? _startupHedgeDelay
            : _hedgeDelay;
        try {
          return await _hedged(
            batch,
            hedgeDelay,
            cancel,
            (url, token, i) => _attempt(
              piece,
              url,
              token,
              resolver,
              priority + (i > 0 ? 20 : 0),
            ),
          );
        } on CancelledException {
          rethrow;
        } catch (e) {
          lastError = e;
        }
      }
    }
    throw lastError ?? const HttpException('没有可用 CDN');
  }

  /// 对冲：第一路立即发出，后续各路等待 [delay] 或第一路失败后发出，
  /// 任一成功即取消其余；全部失败抛出最后一个错误
  Future<PieceResult> _hedged(
    List<String> urls,
    Duration delay,
    CancelToken cancel,
    Future<PieceResult> Function(String url, CancelToken token, int index) run,
  ) async {
    final tokens = [for (final _ in urls) cancel.child()];
    final completer = Completer<PieceResult>();
    final firstFailed = Completer<void>();
    var failures = 0;
    for (var i = 0; i < urls.length; i++) {
      final token = tokens[i];
      Future(() async {
        if (i > 0) {
          await Future.any<void>([
            Future.delayed(delay * i),
            firstFailed.future,
            token.whenCancelled,
          ]);
        }
        token.throwIfCancelled();
        return run(urls[i], token, i);
      }).then(
        (result) {
          if (!completer.isCompleted) completer.complete(result);
        },
        onError: (Object e) {
          if (i == 0 && !firstFailed.isCompleted) firstFailed.complete();
          if (++failures == urls.length && !completer.isCompleted) {
            completer.completeError(
              cancel.isCancelled ? const CancelledException() : e,
            );
          }
        },
      );
    }
    try {
      return await completer.future;
    } finally {
      for (final token in tokens) {
        token.cancel();
      }
    }
  }

  /// 元数据范围（初始化段、索引）：最多三个候选错峰抢跑，三轮重试
  Future<RangeResult> downloadStartupRange(
    ByteRange range,
    CdnResolver resolver,
    List<String> playUrls,
    CancelToken cancel,
  ) async {
    final piece = _Piece(0, range.start, range.end);
    final stopwatch = Stopwatch()..start();
    Object? lastError;
    for (var round = 0; round < _pieceRounds; round++) {
      if (round > 0) {
        if (stopwatch.elapsed > _pieceRetryWindow) break;
        await _pause(
          Duration(milliseconds: min(2000, 500 * (1 << (round - 1)))),
          cancel,
        );
      }
      var candidates = resolver.startupCandidates(playUrls).take(3).toList();
      if (candidates.isEmpty && round > 0) {
        candidates = resolver.ordered(round).take(3).toList();
      }
      if (candidates.isEmpty) break;
      try {
        final tokens = [for (final _ in candidates) cancel.child()];
        final completer = Completer<PieceResult>();
        var failures = 0;
        for (var i = 0; i < candidates.length; i++) {
          final token = tokens[i];
          Future(() async {
            if (i > 0) {
              await Future.any<void>([
                Future.delayed(Duration(milliseconds: i == 1 ? 120 : 300)),
                token.whenCancelled,
              ]);
            }
            token.throwIfCancelled();
            return _attempt(piece, candidates[i], token, resolver, 220);
          }).then(
            (result) {
              if (!completer.isCompleted) completer.complete(result);
            },
            onError: (Object e) {
              if (++failures == candidates.length && !completer.isCompleted) {
                completer.completeError(
                  cancel.isCancelled ? const CancelledException() : e,
                );
              }
            },
          );
        }
        final winner = await completer.future.whenComplete(() {
          for (final token in tokens) {
            token.cancel();
          }
        });
        return RangeResult(winner.bytes, winner.total);
      } on CancelledException {
        rethrow;
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? const HttpException('没有可用 CDN');
  }

  List<_Piece> _split(int start, int end, int count, int minChunk) {
    final length = end - start + 1;
    final pieces = max(1, min(max(1, count), (length / minChunk).ceil()));
    final base = length ~/ pieces;
    final remainder = length % pieces;
    final result = <_Piece>[];
    var cursor = start;
    for (var i = 0; i < pieces; i++) {
      final size = base + (i < remainder ? 1 : 0);
      result.add(_Piece(i, cursor, cursor + size - 1));
      cursor += size;
    }
    return result;
  }

  /// 起播分段：先用一个小头块向全部候选同时探测，谁先回来就用谁的节点
  /// 下载其余子块，子块按序逐个交给 [onOrderedChunk]
  Future<RangeResult> _downloadStartupMediaRange(
    ByteRange range,
    CdnResolver resolver,
    CancelToken cancel,
    bool isAudio,
    int concurrency,
    Future<void> Function(Uint8List bytes) onOrderedChunk,
  ) async {
    semaphore.limit = concurrency;
    final candidateUrls = resolver.rangeCandidates();
    final headLength = min(range.length, minChunkBytes);
    final head = _Piece(0, range.start, range.start + headLength - 1);
    final headResult = await _downloadPiece(
      head,
      resolver,
      cancel,
      candidateUrls,
      probe: true,
      priority: 220,
    );
    await onOrderedChunk(headResult.bytes);
    if (head.end >= range.end) return RangeResult(null, headResult.total);
    final rescueReserve = max(1, min(16, (concurrency / 8).ceil()));
    final mediaBudget = max(1, concurrency - rescueReserve);
    final audioBudget = max(1, min(mediaBudget, (concurrency / 8).ceil()));
    final pieceBudget = isAudio
        ? audioBudget
        : max(1, mediaBudget - audioBudget);
    final pieces = _split(head.end + 1, range.end, pieceBudget, minChunkBytes)
        .map((p) => _Piece(p.index + 1, p.start, p.end))
        .toList();
    final ordered = List<PieceResult?>.filled(pieces.length, null);
    var next = 0;
    var flushing = Future<void>.value();
    Future<void> flush() => flushing = flushing.then((_) async {
      while (next < ordered.length && ordered[next] != null) {
        final item = ordered[next]!;
        ordered[next] = null;
        next++;
        await onOrderedChunk(item.bytes);
      }
    });
    final pending = <Future<PieceResult>>[
      for (var i = 0; i < pieces.length; i++)
        _downloadPiece(
          pieces[i],
          resolver,
          cancel,
          [headResult.url],
          startup: true,
          priority: 120 - min(30, pieces[i].index),
        ).then((result) async {
          ordered[i] = result;
          await flush();
          return result;
        }),
    ];
    final results = await Future.wait(pending, eagerError: true);
    await flushing;
    final totals = [headResult, ...results]
        .map((e) => e.total)
        .nonNulls
        .toSet();
    if (totals.length > 1) throw const HttpException(_totalMismatch);
    return RangeResult(null, totals.firstOrNull);
  }

  /// 下载一个分段：切成（并发数 - 救援预留）个子块并发下载，按序交付
  Future<RangeResult> downloadRange(
    ByteRange range,
    CdnResolver resolver,
    CancelToken cancel, {
    required int concurrency,
    bool isAudio = false,
    bool startup = false,
    int priority = 50,
    Future<void> Function(Uint8List bytes)? onOrderedChunk,
  }) async {
    if (startup && onOrderedChunk != null) {
      return _downloadStartupMediaRange(
        range,
        resolver,
        cancel,
        isAudio,
        concurrency,
        onOrderedChunk,
      );
    }
    final preferred = resolver.rangeCandidates();
    semaphore.limit = concurrency;
    final rescueReserve = concurrency >= 8
        ? min(8, max(1, (concurrency / 8).ceil()))
        : 0;
    final pieceConcurrency = max(1, concurrency - rescueReserve);
    final pieces = _split(
      range.start,
      range.end,
      pieceConcurrency,
      minChunkBytes,
    );
    final progressive = onOrderedChunk != null;
    final ordered = List<PieceResult?>.filled(pieces.length, null);
    var next = 0;
    var flushing = Future<void>.value();
    Future<void> flush() => flushing = flushing.then((_) async {
      while (next < ordered.length && ordered[next] != null) {
        final item = ordered[next]!;
        ordered[next] = null;
        next++;
        await onOrderedChunk!(item.bytes);
      }
    });
    final results = await Future.wait([
      for (final piece in pieces)
        _downloadPiece(
          piece,
          resolver,
          cancel,
          preferred,
          startup: startup,
          priority: priority - min(20, piece.index),
        ).then((result) async {
          if (progressive) {
            ordered[piece.index] = result;
            await flush();
          }
          return result;
        }),
    ], eagerError: true);
    if (progressive) await flushing;
    final totals = results.map((e) => e.total).nonNulls.toSet();
    if (totals.length > 1) throw const HttpException(_totalMismatch);
    Uint8List? bytes;
    if (!progressive) {
      final builder = BytesBuilder(copy: false);
      for (final result in results) {
        builder.add(result.bytes);
      }
      bytes = builder.takeBytes();
      if (bytes.length != range.length) {
        throw HttpException(
          '分段长度不符：${bytes.length}/${range.length}',
        );
      }
    }
    return RangeResult(bytes, totals.firstOrNull);
  }
}

/// 按起始偏移存放的媒体字节块：调度器写入，HTTP 服务端按播放器请求位置读取
class MediaBuffer {
  final _chunks = SplayTreeMap<int, Uint8List>();
  int _bytes = 0;

  int get bytes => _bytes;

  void add(int start, Uint8List data) {
    if (data.isEmpty) return;
    final old = _chunks[start];
    if (old != null) _bytes -= old.length;
    _chunks[start] = data;
    _bytes += data.length;
  }

  /// 从 [position] 起连续可读的数据，没有则返回 null
  Uint8List? read(int position, int maxLength) {
    final key = _chunks.lastKeyBefore(position + 1);
    if (key == null) return null;
    final chunk = _chunks[key]!;
    final offset = position - key;
    if (offset >= chunk.length) return null;
    final end = min(chunk.length, offset + maxLength);
    return Uint8List.sublistView(chunk, offset, end);
  }

  /// [position] 起连续缓存到的末尾字节（含），没有则为 position - 1
  int bufferedEnd(int position) {
    var cursor = position;
    while (true) {
      final key = _chunks.lastKeyBefore(cursor + 1);
      if (key == null) return cursor - 1;
      final chunk = _chunks[key]!;
      final end = key + chunk.length;
      if (end <= cursor) return cursor - 1;
      cursor = end;
    }
  }

  bool contains(int position) => bufferedEnd(position) >= position;

  /// 丢弃 [before] 之前的整块数据
  void prune(int before) {
    final keys = _chunks.keys.takeWhile((key) {
      return key + _chunks[key]!.length <= before;
    }).toList();
    for (final key in keys) {
      _bytes -= _chunks.remove(key)!.length;
    }
  }

  /// 超过 [limit] 时先丢离 [position] 最远的块
  void trim(int position, int limit) {
    while (_bytes > limit && _chunks.length > 1) {
      final first = _chunks.firstKey()!;
      final last = _chunks.lastKey()!;
      final key = (position - first).abs() >= (last - position).abs()
          ? first
          : last;
      _bytes -= _chunks.remove(key)!.length;
    }
  }

  void clear() {
    _chunks.clear();
    _bytes = 0;
  }
}
