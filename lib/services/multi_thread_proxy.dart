import 'dart:async';
import 'dart:convert' show base64Url;
import 'dart:io';
import 'dart:math' show Random, max, min;

import 'package:PiliPlus/models/video/play/url.dart';
import 'package:PiliPlus/services/multi_thread/cdn_resolver.dart';
import 'package:PiliPlus/services/multi_thread/range_downloader.dart';
import 'package:PiliPlus/services/multi_thread/sidx.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/video_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

/// 多线程加速
///
/// 在本地起一个 HTTP 服务，播放器请求本地地址。服务端解析 DASH 分段索引，
/// 按分段把字节范围切成子块，从多个 CDN 节点并发下载，校验后按序放入缓冲，
/// 并在播放器读取位置之前预读「缓冲时长」的内容；播放器从缓冲中读取。
abstract final class MultiThreadProxy {
  static bool enable = Pref.enableMultiThread;
  static int threads = Pref.multiThreadCount;

  static const _maxEntries = 16;
  static const _lingerTimeout = Duration(seconds: 30);
  static const _fallbackVideoRange = 2 * 1024 * 1024;
  static const _fallbackAudioRange = 256 * 1024;
  static const _keepBehindSeconds = 30;
  static const _maxVideoBufferBytes = 96 * 1024 * 1024;
  static const _maxAudioBufferBytes = 16 * 1024 * 1024;

  static HttpServer? _server;
  static Future<HttpServer>? _starting;
  static final _entries = <String, _Track>{};
  static final _random = Random.secure();
  static final _semaphore = PrioritySemaphore(threads);
  static final _downloader = RangeDownloader(_semaphore);
  static final _bans = CdnBanList();

  static Future<void> start() async {
    if (_server != null) return;
    _starting ??= HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    try {
      final server = await _starting!;
      _server = server;
      server.listen(_onRequest);
      if (kDebugMode) {
        debugPrint('MultiThreadProxy listening on ${server.port}');
      }
    } catch (e) {
      _starting = null;
      if (kDebugMode) debugPrint('MultiThreadProxy start error: $e');
    }
  }

  /// 取消所有下载、释放缓冲并作废已发出的地址（切换/退出视频时调用）
  static void cancelAll() {
    for (final track in _entries.values) {
      track.dispose();
    }
    _bans.reset();
  }

  /// 返回本地代理地址；未开启或服务未就绪时原样返回 [url]
  static String wrap(String url, BaseItem item, {bool isAudio = false}) {
    final server = _server;
    if (!enable || server == null) return url;
    if (!isAudio) cancelAll();
    final selected = isAudio && VideoUtils.disableAudioCDN
        ? item.playUrls.first
        : url;
    final resolver = CdnResolver(
      selected: selected,
      playUrls: item.playUrls,
      bans: _bans,
      overseas: isOverseasService(VideoUtils.cdnService),
    );
    final token = base64Url.encode(
      List.generate(16, (_) => _random.nextInt(256)),
    );
    _entries[token] = _Track(item, resolver, isAudio)..preload();
    while (_entries.length > _maxEntries) {
      _entries.remove(_entries.keys.first)?.dispose();
    }
    return 'http://${server.address.address}:${server.port}/$token';
  }

  static Future<void> _onRequest(HttpRequest request) async {
    final response = request.response;
    try {
      final track = _entries[request.uri.path.substring(1)];
      if (track == null) {
        response.statusCode = HttpStatus.notFound;
      } else if (track.disposed) {
        // 已作废地址：保持连接直到播放器关闭
        _linger(await response.detachSocket(writeHeaders: false));
        return;
      } else if (request.method != 'GET' && request.method != 'HEAD') {
        response.statusCode = HttpStatus.methodNotAllowed;
      } else {
        await _serve(request, track);
        return;
      }
      await response.close();
    } catch (e) {
      if (kDebugMode) debugPrint('MultiThreadProxy error: $e');
      response.statusCode = HttpStatus.badGateway;
      await response.close();
    }
  }

  static Future<void> _serve(HttpRequest request, _Track track) async {
    final response = request.response;
    int start = 0;
    int? reqEnd;
    final rangeHeader = request.headers.value(HttpHeaders.rangeHeader);
    if (rangeHeader != null) {
      final match = RegExp(r'^bytes=(\d+)-(\d*)$').firstMatch(rangeHeader);
      if (match == null) {
        response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
        await response.close();
        return;
      }
      start = int.parse(match[1]!);
      if (match[2]!.isNotEmpty) reqEnd = int.parse(match[2]!);
    }

    track.reader?.cancel();
    final reader = track.reader = CancelToken();
    final int total;
    try {
      total = await track.load();
    } on CancelledException {
      _linger(await response.detachSocket(writeHeaders: false));
      return;
    } catch (e) {
      if (kDebugMode) debugPrint('MultiThreadProxy load error: $e');
      response.statusCode = HttpStatus.badGateway;
      await response.close();
      return;
    }
    final end = reqEnd == null ? total - 1 : min(reqEnd, total - 1);
    if (start > end) {
      response.statusCode = HttpStatus.requestedRangeNotSatisfiable;
      await response.close();
      return;
    }

    response
      ..statusCode = HttpStatus.partialContent
      ..headers.set(HttpHeaders.acceptRangesHeader, 'bytes')
      ..headers.set(HttpHeaders.contentRangeHeader, 'bytes $start-$end/$total')
      ..headers.set(
        HttpHeaders.contentTypeHeader,
        track.item.mimeType ?? 'application/octet-stream',
      )
      ..persistentConnection = false
      ..contentLength = end - start + 1;
    if (request.method == 'HEAD') {
      await response.close();
      return;
    }

    // 接管 socket，读端关闭即视为播放器断开
    final socket = await response.detachSocket();
    var closedByPeer = false;
    socket.listen(
      (_) {},
      onDone: () {
        closedByPeer = true;
        reader.cancel();
      },
      onError: (_) {
        closedByPeer = true;
        reader.cancel();
      },
      cancelOnError: true,
    );
    Object? error;
    try {
      track.seek(start);
      var position = start;
      while (position <= end) {
        reader.throwIfCancelled();
        final data = track.buffer.read(position, end - position + 1);
        if (data == null) {
          await track.waitForData(reader);
          continue;
        }
        socket.add(data);
        await Future.any<void>([socket.flush(), reader.whenCancelled]);
        reader.throwIfCancelled();
        position += data.length;
        track.advance(position);
      }
      await socket.close();
    } catch (e) {
      error = e;
      if (kDebugMode && e is! CancelledException) {
        debugPrint('MultiThreadProxy serve error: $e');
      }
    } finally {
      reader.cancel();
      if (track.reader == reader) track.reader = null;
      if (error is CancelledException && !closedByPeer) {
        Future.delayed(_lingerTimeout, socket.destroy);
      } else {
        socket.destroy();
      }
    }
  }

  /// 保持连接直到播放器关闭或超时
  static void _linger(Socket socket) {
    socket.listen(
      (_) {},
      onDone: socket.destroy,
      onError: (_) => socket.destroy(),
      cancelOnError: true,
    );
    Future.delayed(_lingerTimeout, socket.destroy);
  }
}

class _Range extends ByteRange {
  final double startTime;
  final double endTime;

  const _Range(super.start, super.end, this.startTime, this.endTime);

  double get duration => endTime - startTime;
}

/// 一路媒体流：分段索引、缓冲、预读调度
class _Track {
  final BaseItem item;
  final CdnResolver resolver;
  final bool isAudio;
  final buffer = MediaBuffer();

  CancelToken? reader;
  bool disposed = false;

  final _session = CancelToken();
  Future<int>? _loading;
  int _total = 0;
  List<_Range> _ranges = const [];
  int _cursor = 0;
  int _resumeFrom = 0;

  int _generation = 0;
  CancelToken _fill = CancelToken();
  final _prefetches = <int, Future<void>>{};
  int _nextIndex = 0;
  int _startupIndex = 0;
  bool _started = false;
  bool _startupComplete = false;
  bool _filling = false;
  Object? _error;
  final _waiters = <Completer<void>>[];

  _Track(this.item, this.resolver, this.isAudio);

  int get _bandwidth => max(0, item.bandWidth ?? 0);

  /// 提前取回初始化段与分段索引
  void preload() => load().ignore();

  /// 下载初始化段与分段索引，返回文件总长度；失败后下次调用重试
  Future<int> load() => _loading ??= _load().then(
    (v) => v,
    onError: (Object e) {
      _loading = null;
      throw e;
    },
  );

  Future<int> _load() async {
    final base = item.segmentBase;
    final init = _parseRange(
      base?['initialization'] ?? base?['Initialization'],
    );
    final index = _parseRange(base?['index_range'] ?? base?['indexRange']);
    if (init != null && index != null) {
      final results = await Future.wait([
        _downloader.downloadStartupRange(init, resolver, _playUrls, _session),
        _downloader.downloadStartupRange(index, resolver, _playUrls, _session),
      ], eagerError: true);
      final segments = parseSidx(results[1].bytes!, index.start);
      final total = results[0].total ?? results[1].total;
      if (segments != null && total != null) {
        buffer
          ..add(init.start, results[0].bytes!)
          ..add(index.start, results[1].bytes!);
        _ranges = _buildRanges(segments, total);
        _total = total;
        _notify();
        return total;
      }
    }
    // 无分段索引时按固定大小分段，用码率估算时长
    final head = await _downloader.downloadStartupRange(
      ByteRange(0, minChunkBytes - 1),
      resolver,
      _playUrls,
      _session,
    );
    final total = head.total;
    if (total == null) throw const HttpException('CDN 未返回文件长度');
    buffer.add(0, head.bytes!);
    _ranges = _buildFixedRanges(total);
    _total = total;
    _notify();
    return total;
  }

  List<String> get _playUrls => item.playUrls.toList();

  static RangeDownloader get _downloader => MultiThreadProxy._downloader;

  static ByteRange? _parseRange(Object? value) {
    if (value is! String) return null;
    final match = RegExp(r'^(\d+)-(\d+)$').firstMatch(value.trim());
    if (match == null) return null;
    final start = int.parse(match[1]!);
    final end = int.parse(match[2]!);
    return end < start ? null : ByteRange(start, end);
  }

  /// 索引之前的头部与索引未覆盖的尾部也作为分段
  List<_Range> _buildRanges(List<SidxSegment> segments, int total) {
    final ranges = <_Range>[];
    final first = segments.first;
    if (first.start > 0) {
      ranges.add(_Range(0, first.start - 1, first.startTime, first.startTime));
    }
    for (final s in segments) {
      if (s.start >= total) break;
      ranges.add(
        _Range(s.start, min(s.end, total - 1), s.startTime, s.endTime),
      );
    }
    if (ranges.isEmpty) return _buildFixedRanges(total);
    final last = ranges.last;
    if (last.end < total - 1) {
      ranges.add(
        _Range(last.end + 1, total - 1, last.endTime, last.endTime),
      );
    }
    return ranges;
  }

  List<_Range> _buildFixedRanges(int total) {
    final size = isAudio
        ? MultiThreadProxy._fallbackAudioRange
        : MultiThreadProxy._fallbackVideoRange;
    final secondsPerByte = _bandwidth > 0 ? 8 / _bandwidth : 0.0;
    final ranges = <_Range>[];
    for (var start = 0; start < total; start += size) {
      final end = min(start + size - 1, total - 1);
      ranges.add(
        _Range(start, end, start * secondsPerByte, (end + 1) * secondsPerByte),
      );
    }
    return ranges;
  }

  int _rangeIndexAt(int position) {
    var low = 0;
    var high = _ranges.length - 1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      final range = _ranges[mid];
      if (position < range.start) {
        high = mid - 1;
      } else if (position > range.end) {
        low = mid + 1;
      } else {
        return mid;
      }
    }
    return min(_ranges.length - 1, low);
  }

  /// 字节位置对应的媒体时间（分段内按比例插值）
  double _secondsAt(int position) {
    if (_ranges.isEmpty) return 0;
    if (position >= _total) return _ranges.last.endTime;
    final range = _ranges[_rangeIndexAt(position)];
    return range.startTime +
        range.duration * (position - range.start) / range.length;
  }

  /// 播放器开始从 [position] 读取：位置已缓冲且之后没有空洞就继续预读，
  /// 否则从缺数据的位置重新开始
  void seek(int position) {
    _error = null;
    _cursor = position;
    if (!buffer.contains(position)) {
      _restart(position);
      return;
    }
    final bufferedEnd = buffer.bufferedEnd(position);
    if (bufferedEnd < _total - 1) {
      final gapIndex = _rangeIndexAt(bufferedEnd + 1);
      // 空洞在当前下载位置之前，或尚未开始下载
      if (_generation == 0 || gapIndex < _nextIndex) {
        _restart(bufferedEnd + 1);
        return;
      }
    }
    _ensureBuffer();
  }

  void _restart(int from) {
    _generation++;
    _fill.cancel();
    _fill = _session.child();
    _prefetches.clear();
    _error = null;
    _resumeFrom = from;
    _startupIndex = _nextIndex = _rangeIndexAt(from);
    _started = false;
    _startupComplete = false;
    _ensureBuffer();
  }

  void advance(int position) {
    _cursor = position;
    _prune();
    _ensureBuffer();
  }

  Future<void> waitForData(CancelToken cancel) {
    if (_error case final error?) return Future.error(error);
    if (cancel.isCancelled) return Future.error(const CancelledException());
    final completer = Completer<void>();
    _waiters.add(completer);
    void onCancel() {
      _waiters.remove(completer);
      if (!completer.isCompleted) {
        completer.completeError(const CancelledException());
      }
    }

    cancel.add(onCancel);
    return completer.future.whenComplete(() => cancel.remove(onCancel));
  }

  void _notify() {
    final waiters = _waiters.toList();
    _waiters.clear();
    for (final w in waiters) {
      if (!w.isCompleted) w.complete();
    }
  }

  void _fail(Object error) {
    _error = error;
    final waiters = _waiters.toList();
    _waiters.clear();
    for (final w in waiters) {
      if (!w.isCompleted) w.completeError(error);
    }
  }

  void dispose() {
    if (disposed) return;
    disposed = true;
    _session.cancel();
    _fill.cancel();
    reader?.cancel();
    _prefetches.clear();
    buffer.clear();
    _fail(const CancelledException());
  }

  /// 预读时长：跟随缓冲时长设置，受缓冲字节上限约束
  double get _aheadSeconds {
    final limit = isAudio
        ? MultiThreadProxy._maxAudioBufferBytes
        : MultiThreadProxy._maxVideoBufferBytes;
    final ahead = Pref.bufferSec;
    return _bandwidth > 0 ? min(ahead, limit * 8 / _bandwidth * 0.8) : ahead;
  }

  /// 滑动窗口预读：依次下载读取位置之后 [_aheadSeconds] 以内的分段
  void _ensureBuffer() {
    if (disposed || _filling || _ranges.isEmpty || _error != null) return;
    _filling = true;
    final generation = _generation;
    final fill = _fill;
    unawaited(() async {
      try {
        while (!fill.isCancelled && generation == _generation) {
          if (_nextIndex >= _ranges.length) break;
          final ahead = _aheadSeconds;
          final current = _secondsAt(_cursor);
          if (_secondsAt(buffer.bufferedEnd(_cursor) + 1) - current >= ahead) {
            break;
          }
          final windowSize = _started ? (isAudio ? 4 : 3) : 1;
          var projectedEnd = _secondsAt(buffer.bufferedEnd(_cursor) + 1);
          for (var offset = 0; offset < windowSize; offset++) {
            final index = _nextIndex + offset;
            if (index >= _ranges.length || projectedEnd - current >= ahead) {
              break;
            }
            final range = _ranges[index];
            projectedEnd = range.endTime;
            if (_prefetches.containsKey(index)) continue;
            final startup = !_startupComplete && index == _startupIndex;
            _prefetches[index] = _downloadRange(
              range,
              fill,
              startup: startup,
              priority: startup ? 120 : max(30, 55 - offset * 5),
            )..ignore();
          }
          final pending = _prefetches[_nextIndex];
          if (pending == null) break;
          await pending;
          if (fill.isCancelled || generation != _generation) break;
          _prefetches.remove(_nextIndex);
          if (!_startupComplete && _nextIndex == _startupIndex) {
            _startupComplete = true;
            final next = _nextIndex + 1;
            if (next < _ranges.length && !_prefetches.containsKey(next)) {
              _prefetches[next] = _downloadRange(
                _ranges[next],
                fill,
                priority: 70,
              )..ignore();
            }
          }
          _nextIndex++;
          _started = true;
        }
      } catch (e) {
        if (!fill.isCancelled && generation == _generation) {
          _prefetches.clear();
          _fail(e);
        }
      } finally {
        _filling = false;
        if (!disposed && generation != _generation) _ensureBuffer();
      }
    }());
  }

  Future<void> _downloadRange(
    _Range range,
    CancelToken cancel, {
    bool startup = false,
    int priority = 50,
  }) async {
    // 起播段从播放器读取位置开始
    final start = startup ? max(range.start, _resumeFrom) : range.start;
    var position = start;
    final token = cancel.child();
    try {
      await _downloader.downloadRange(
        ByteRange(start, range.end),
        resolver,
        token,
        concurrency: MultiThreadProxy.threads,
        isAudio: isAudio,
        startup: startup,
        priority: priority,
        onOrderedChunk: (bytes) async {
          if (token.isCancelled) return;
          buffer.add(position, bytes);
          position += bytes.length;
          _trim();
          _notify();
        },
      );
    } on CancelledException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'MultiThreadProxy ${isAudio ? 'audio' : 'video'} '
          'range ${range.start}-${range.end} failed: $e',
        );
      }
      rethrow;
    } finally {
      token.cancel();
    }
  }

  /// 丢弃读取位置之前 30 秒以外的数据
  void _prune() {
    if (_ranges.isEmpty || buffer.bytes == 0) return;
    final keepFrom = _secondsAt(_cursor) - MultiThreadProxy._keepBehindSeconds;
    if (keepFrom <= 0) return;
    var index = _rangeIndexAt(_cursor);
    while (index > 0 && _ranges[index].startTime > keepFrom) {
      index--;
    }
    buffer.prune(_ranges[index].start);
  }

  /// 缓冲超过上限时先丢离读取位置最远的数据
  void _trim() {
    final limit = isAudio
        ? MultiThreadProxy._maxAudioBufferBytes
        : MultiThreadProxy._maxVideoBufferBytes;
    if (buffer.bytes > limit) buffer.trim(_cursor, limit);
  }
}
