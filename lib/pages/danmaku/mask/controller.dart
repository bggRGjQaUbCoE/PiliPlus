import 'dart:async' show Future, unawaited;
import 'dart:ui' as ui;

import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/models_new/video/video_play_info/dm_mask.dart';
import 'package:PiliPlus/pages/danmaku/mask/parser.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_parsing/path_parsing.dart';

final class DanmakuMaskRange {
  const DanmakuMaskRange({required this.bytes, required this.totalLength});

  final Uint8List bytes;
  final int totalLength;
}

typedef DanmakuMaskRangeLoader = Future<DanmakuMaskRange> Function(
  String url,
  int start,
  int end,
  CancelToken cancelToken,
);

typedef DanmakuMaskEnabledReader = bool Function();

final class DanmakuMaskTransientException implements Exception {
  const DanmakuMaskTransientException(this.statusCode);

  final int? statusCode;

  @override
  String toString() => 'Transient webmask request failure: $statusCode';
}

final class DanmakuMaskFrame {
  const DanmakuMaskFrame({required this.viewBox, required this.allowedPath});

  final ui.Rect viewBox;
  final ui.Path allowedPath;
}

final class DanmakuMaskController {
  DanmakuMaskController({
    DanmakuMaskRangeLoader? rangeLoader,
    DanmakuMaskEnabledReader? enabledReader,
    @visibleForTesting bool? enabled,
    @visibleForTesting this.retryDelay = const Duration(seconds: 2),
  }) : _rangeLoader = rangeLoader ?? _loadRange,
       _enabledReader = enabledReader ?? _readEnabled,
       _enabled = enabled ?? (enabledReader ?? _readEnabled)();

  final DanmakuMaskRangeLoader _rangeLoader;
  final DanmakuMaskEnabledReader _enabledReader;
  @visibleForTesting
  final Duration retryDelay;
  final ValueNotifier<DanmakuMaskFrame?> frame = ValueNotifier(null);

  final Map<int, WebMaskSegmentData> _segments = {};
  final Map<int, Future<void>> _segmentLoads = {};
  final Map<int, CancelToken> _segmentTokens = {};
  final Set<int> _failedSegments = {};

  DmMask? _source;
  WebMaskIndex? _index;
  Future<void>? _indexLoad;
  CancelToken? _indexToken;
  bool _indexFailed = false;
  bool _enabled;
  bool _disposed = false;
  int _generation = 0;
  int _positionMs = 0;
  int? _selectedSegment;
  int? _selectedFrame;

  bool get enabled => _enabled;
  bool get available => _source != null;

  void setSource(DmMask? source) {
    if (_source?.cid == source?.cid && _source?.maskUrl == source?.maskUrl) {
      return;
    }
    _reset(keepSource: false);
    _source = source;
    if (_enabled && source != null) {
      unawaited(_ensurePosition());
    }
  }

  void setEnabled(bool value, int positionMs) {
    _applyEnabled(value, positionMs, persist: true);
  }

  void syncEnabledFromPreference(int positionMs) {
    _applyEnabled(_enabledReader(), positionMs, persist: false);
  }

  void _applyEnabled(
    bool value,
    int positionMs, {
    required bool persist,
  }) {
    _positionMs = positionMs;
    if (_enabled == value) return;
    _enabled = value;
    if (persist) {
      unawaited(
        GStorage.setting.put(SettingBoxKey.enableDanmakuMask, value),
      );
    }
    if (value) {
      unawaited(_ensurePosition());
    } else {
      _reset(keepSource: true);
    }
  }

  void updatePosition(Duration position) {
    _positionMs = position.inMilliseconds;
    if (!_enabled || _source == null || _disposed) return;
    final index = _index;
    if (index == null) {
      if (!_indexFailed) unawaited(_ensurePosition());
      return;
    }

    final segmentIndex = index.segmentFor(_positionMs);
    _cancelUnneededLoads(segmentIndex);
    final segment = _segments[segmentIndex];
    if (segment == null) {
      _clearFrame();
      if (!_failedSegments.contains(segmentIndex)) {
        unawaited(_loadSegment(segmentIndex, _generation));
      }
      return;
    }

    _selectFrame(segmentIndex, segment);
    _prefetchNextIfNeeded(segmentIndex, _generation);
  }

  Future<void> _ensurePosition() async {
    if (!_enabled || _source == null || _disposed || _indexFailed) return;
    final generation = _generation;
    await _ensureIndex(generation);
    if (!_isCurrent(generation) || _index == null) return;
    final segmentIndex = _index!.segmentFor(_positionMs);
    await _loadSegment(segmentIndex, generation);
  }

  Future<void> _ensureIndex(int generation) async {
    if (_index != null || _indexFailed) return;
    final existing = _indexLoad;
    if (existing != null) return existing;

    final future = _readIndex(generation);
    _indexLoad = future;
    try {
      await future;
    } finally {
      if (identical(_indexLoad, future)) _indexLoad = null;
    }
  }

  Future<void> _readIndex(int generation) async {
    final source = _source;
    if (source == null) return;
    final token = _indexToken = CancelToken();
    try {
      final headerRange = await _loadRangeWithRetry(
        source.maskUrl,
        0,
        15,
        token,
        generation,
      );
      if (!_isCurrent(generation)) return;
      final header = parseWebMaskHeader(headerRange.bytes);
      final indexEnd = 16 + header.segmentCount * 16 - 1;
      if (indexEnd >= headerRange.totalLength) {
        throw const FormatException('Invalid webmask index range');
      }
      final indexRange = await _loadRangeWithRetry(
        source.maskUrl,
        16,
        indexEnd,
        token,
        generation,
      );
      if (!_isCurrent(generation)) return;
      if (indexRange.totalLength != headerRange.totalLength) {
        throw const FormatException('Inconsistent webmask total length');
      }
      _index = parseWebMaskIndex(
        Uint8List.fromList([...headerRange.bytes, ...indexRange.bytes]),
        indexRange.totalLength,
      );
    } catch (error) {
      if (_isCurrent(generation) && !token.isCancelled) {
        _indexFailed = true;
        _debugError('load index', error);
      }
    } finally {
      if (identical(_indexToken, token)) _indexToken = null;
    }
  }

  Future<void> _loadSegment(int segmentIndex, int generation) {
    if (!_isCurrent(generation) ||
        _segments.containsKey(segmentIndex) ||
        _failedSegments.contains(segmentIndex)) {
      return Future.value();
    }
    final existing = _segmentLoads[segmentIndex];
    if (existing != null) return existing;

    final future = _readSegment(segmentIndex, generation);
    _segmentLoads[segmentIndex] = future;
    future.whenComplete(() {
      if (identical(_segmentLoads[segmentIndex], future)) {
        _segmentLoads.remove(segmentIndex);
        _segmentTokens.remove(segmentIndex);
      }
    });
    return future;
  }

  Future<void> _readSegment(int segmentIndex, int generation) async {
    final source = _source;
    final index = _index;
    if (source == null || index == null) return;
    final segmentIndexData = index.segments[segmentIndex];
    final token = CancelToken();
    _segmentTokens[segmentIndex] = token;
    try {
      final range = await _loadRangeWithRetry(
        source.maskUrl,
        segmentIndexData.start,
        segmentIndexData.end - 1,
        token,
        generation,
      );
      if (!_isCurrent(generation) || token.isCancelled) return;
      if (range.totalLength != index.totalLength) {
        throw const FormatException('Inconsistent webmask total length');
      }
      final segment = await compute(parseWebMaskSegment, range.bytes);
      if (!_isCurrent(generation) || token.isCancelled) return;
      _segments[segmentIndex] = segment;
      _trimCache(segmentIndex);
      if (_index?.segmentFor(_positionMs) == segmentIndex) {
        _selectFrame(segmentIndex, segment);
        _prefetchNextIfNeeded(segmentIndex, generation);
      }
    } catch (error) {
      if (_isCurrent(generation) && !token.isCancelled) {
        _failedSegments.add(segmentIndex);
        if (_index?.segmentFor(_positionMs) == segmentIndex) {
          _clearFrame();
        }
        _debugError('load segment', error);
      }
    }
  }

  void _selectFrame(int segmentIndex, WebMaskSegmentData segment) {
    final frameIndex = segment.frameFor(_positionMs);
    if (_selectedSegment == segmentIndex && _selectedFrame == frameIndex) {
      return;
    }
    _selectedSegment = segmentIndex;
    _selectedFrame = frameIndex;
    if (frameIndex < 0) {
      frame.value = null;
      return;
    }
    frame.value = _buildFrame(segment.frames[frameIndex]);
  }

  DanmakuMaskFrame? _buildFrame(WebMaskFrameData data) {
    try {
      return buildDanmakuMaskFrame(data);
    } catch (error) {
      _debugError('parse path', error);
      return null;
    }
  }

  void _prefetchNextIfNeeded(int segmentIndex, int generation) {
    final index = _index;
    if (index != null &&
        segmentIndex + 1 < index.segments.length &&
        _positionMs >= index.segments[segmentIndex + 1].timeMs - 1000) {
      unawaited(_loadSegment(segmentIndex + 1, generation));
    }
  }

  void _cancelUnneededLoads(int current) {
    for (final entry in _segmentTokens.entries.toList()) {
      if (entry.key != current && entry.key != current + 1) {
        entry.value.cancel();
        _segmentTokens.remove(entry.key);
        _segmentLoads.remove(entry.key);
      }
    }
  }

  void _trimCache(int current) {
    if (_segments.length <= 3) return;
    final keys = _segments.keys.toList()
      ..sort((a, b) => (a - current).abs().compareTo((b - current).abs()));
    for (final key in keys.skip(3)) {
      _segments.remove(key);
    }
  }

  bool _isCurrent(int generation) {
    return !_disposed && _enabled && generation == _generation;
  }

  void _clearFrame() {
    _selectedSegment = null;
    _selectedFrame = null;
    frame.value = null;
  }

  void _reset({required bool keepSource}) {
    _generation++;
    _indexToken?.cancel();
    _indexToken = null;
    for (final token in _segmentTokens.values) {
      token.cancel();
    }
    _segmentTokens.clear();
    _segmentLoads.clear();
    _segments.clear();
    _failedSegments.clear();
    _index = null;
    _indexLoad = null;
    _indexFailed = false;
    if (!keepSource) _source = null;
    _clearFrame();
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _reset(keepSource: false);
    frame.dispose();
  }

  Future<DanmakuMaskRange> _loadRangeWithRetry(
    String url,
    int start,
    int end,
    CancelToken cancelToken,
    int generation,
  ) async {
    try {
      return await _rangeLoader(url, start, end, cancelToken);
    } on DanmakuMaskTransientException {
      await Future.any<void>([
        Future<void>.delayed(retryDelay),
        cancelToken.whenCancel.then<void>((_) {}),
      ]);
      if (!_isCurrent(generation) || cancelToken.isCancelled) {
        throw const _DanmakuMaskCancelledException();
      }
      return _rangeLoader(url, start, end, cancelToken);
    }
  }

  static Future<DanmakuMaskRange> _loadRange(
    String url,
    int start,
    int end,
    CancelToken cancelToken,
  ) async {
    final response = await Request().get<List<int>>(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'range': 'bytes=$start-$end',
          'accept-encoding': 'identity',
        },
        extra: {'account': const NoAccount()},
      ),
      cancelToken: cancelToken,
    );
    final statusCode = response.statusCode;
    if (statusCode == -1 ||
        statusCode == 408 ||
        statusCode == 429 ||
        (statusCode != null && statusCode >= 500 && statusCode < 600)) {
      throw DanmakuMaskTransientException(statusCode);
    }
    if (statusCode != 206 || response.data is! List<int>) {
      throw const FormatException('Webmask server did not return a byte range');
    }

    final value = response.headers.value('content-range');
    final match = value == null
        ? null
        : RegExp(r'^bytes (\d+)-(\d+)/(\d+)$').firstMatch(value);
    if (match == null ||
        int.parse(match.group(1)!) != start ||
        int.parse(match.group(2)!) != end) {
      throw const FormatException('Invalid webmask Content-Range');
    }
    final bytes = Uint8List.fromList(response.data!);
    if (bytes.length != end - start + 1) {
      throw const FormatException('Invalid webmask range length');
    }
    return DanmakuMaskRange(
      bytes: bytes,
      totalLength: int.parse(match.group(3)!),
    );
  }

  static void _debugError(String action, Object error) {
    if (kDebugMode) debugPrint('danmaku mask $action: $error');
  }

  static bool _readEnabled() => Pref.enableDanmakuMask;
}

final class _DanmakuMaskCancelledException implements Exception {
  const _DanmakuMaskCancelledException();
}

@visibleForTesting
DanmakuMaskFrame? buildDanmakuMaskFrame(WebMaskFrameData data) {
  final viewBox = data.viewBox;
  final paths = data.paths;
  if (viewBox == null || paths == null) return null;

  final result = ui.Path();
  for (final pathData in paths) {
    final proxy = _UiPathProxy();
    writeSvgPathDataToPath(pathData.data, proxy);
    result.addPath(
      proxy.path.transform(_toMatrix4(pathData.transform)),
      ui.Offset.zero,
    );
  }
  return DanmakuMaskFrame(
    viewBox: ui.Rect.fromLTWH(
      viewBox[0],
      viewBox[1],
      viewBox[2],
      viewBox[3],
    ),
    allowedPath: result,
  );
}

final class _UiPathProxy implements PathProxy {
  final ui.Path path = ui.Path();

  @override
  void close() => path.close();

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) => path.cubicTo(x1, y1, x2, y2, x3, y3);

  @override
  void lineTo(double x, double y) => path.lineTo(x, y);

  @override
  void moveTo(double x, double y) => path.moveTo(x, y);
}

Float64List _toMatrix4(List<double> value) {
  return Float64List.fromList([
    value[0],
    value[1],
    0,
    0,
    value[2],
    value[3],
    0,
    0,
    0,
    0,
    1,
    0,
    value[4],
    value[5],
    0,
    1,
  ]);
}
