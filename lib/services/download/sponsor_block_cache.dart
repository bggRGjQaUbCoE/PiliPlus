import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/models_new/sponsor_block/snapshot.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:synchronized/synchronized.dart';

typedef SponsorBlockFetcher = Future<List<SegmentItemModel>> Function(
  SponsorBlockTarget target,
  String server,
  CancelToken cancelToken,
);

class SponsorBlockCache {
  SponsorBlockCache({
    required this.server,
    required this.fetch,
    this.requestTimeout = const Duration(seconds: 5),
    this.readTimeout = const Duration(seconds: 1),
    this.replaceFile = _replaceFile,
  });

  final String Function() server;
  final SponsorBlockFetcher fetch;
  final Duration requestTimeout;
  final Duration readTimeout;
  final void Function(File source, String destination) replaceFile;
  final _files = Lock();
  final _active = <String, CancelToken>{};
  int _serial = 0;
  int _generation = 0;
  int get generation => _generation;
  bool batchRunning = false;

  static void _replaceFile(File source, String destination) =>
      source.renameSync(destination);

  String _key(String directory) => path.normalize(path.absolute(directory));

  String _source(SponsorBlockTarget target) => target.source == .pgc
      ? 'https://www.bilibili.com'
      : normalizeSponsorServer(server());

  String _fileName(SponsorBlockTarget target) => target.source == .pgc
      ? PathUtils.pgcSkipName
      : PathUtils.sponsorBlockName;

  Future<SponsorBlockCacheResult> read(SponsorBlockTarget target) async {
    final source = _source(target);
    try {
      return await _read(target, source).timeout(readTimeout);
    } catch (_) {
      return const SponsorBlockCacheResult(.invalid);
    }
  }

  Future<SponsorBlockCacheResult> _read(
    SponsorBlockTarget target,
    String source,
  ) async {
    final file = File(path.join(target.directory, _fileName(target)));
    try {
      final snapshot = SponsorBlockSnapshot.fromJson(
        jsonDecode(await file.readAsString()),
      );
      if (snapshot.bvid != target.bvid ||
          snapshot.cid != target.cid.toString()) {
        return const SponsorBlockCacheResult(.invalid);
      }
      if (snapshot.source != target.source ||
          normalizeSponsorServer(snapshot.server) != source) {
        return const SponsorBlockCacheResult(.differentSource);
      }
      return SponsorBlockCacheResult(.ready, snapshot: snapshot);
    } on PathNotFoundException {
      return const SponsorBlockCacheResult(.missing);
    } catch (_) {
      return const SponsorBlockCacheResult(.invalid);
    }
  }

  void cancel(String directory) => _active[_key(directory)]?.cancel();

  void invalidateAll() {
    _generation++;
    for (final token in _active.values) {
      token.cancel();
    }
  }

  Future<T> withFiles<T>(Future<T> Function() action) =>
      _files.synchronized(action);

  Future<T> remove<T>(String directory, Future<T> Function() action) {
    final key = _key(directory);
    for (final item in _active.entries) {
      if (item.key == key || path.isWithin(key, item.key)) item.value.cancel();
    }
    return withFiles(action);
  }

  Future<SponsorBlockCacheResult> update(
    SponsorBlockTarget target, {
    bool refresh = false,
    CancelToken? cancelToken,
    List<SegmentItemModel>? segments,
  }) async {
    final key = _key(target.directory);
    final token = cancelToken ?? CancelToken();
    _active[key]?.cancel();
    _active[key] = token;
    final source = _source(target);
    final serial = ++_serial;
    bool valid() =>
        !token.isCancelled &&
        identical(_active[key], token) &&
        source == _source(target);
    var timedOut = false;
    final timer = Timer(requestTimeout, () {
      timedOut = true;
      token.cancel('获取空降信息超时');
    });
    final operation = () async {
      if (!refresh) {
        final existing = await read(target);
        if (!valid()) return const SponsorBlockCacheResult(.cancelled);
        if (existing.isUsable) {
          return SponsorBlockCacheResult(.reused, snapshot: existing.snapshot);
        }
      }
      if (!valid()) return const SponsorBlockCacheResult(.cancelled);
      final items = segments ?? await fetch(target, source, token);
      // 重新解析确保调用方提供的数据可以完整保存，异常响应不能清除旧文件。
      final parsedSegments = SponsorBlockSnapshot.parseSegments([
        for (final item in items) item.toJson(),
      ]);
      if (parsedSegments.any(
        (e) => e.cid != null && e.cid != target.cid.toString(),
      )) {
        throw const FormatException('空降响应包含其他视频的片段');
      }
      final snapshot = SponsorBlockSnapshot(
        bvid: target.bvid,
        cid: target.cid.toString(),
        server: source,
        fetchedAt: DateTime.now().toUtc(),
        mediaDurationMs: target.durationMs,
        segments: parsedSegments,
        source: target.source,
      );
      return withFiles(() async {
        if (!valid()) return const SponsorBlockCacheResult(.cancelled);
        final entry = jsonDecode(
          await File(path.join(key, 'entry.json')).readAsString(),
        );
        if (entry['bvid'] != target.bvid ||
            (entry['source']?['cid'] ?? entry['page_data']?['cid']) !=
                target.cid ||
            entry['ep']?['episode_id'] != target.epid ||
            entry['time_create_stamp'] != target.createdAt) {
          return const SponsorBlockCacheResult(.cancelled);
        }
        final destination = path.join(key, _fileName(target));
        final temporary = File('$destination.$serial.tmp');
        try {
          if (!valid()) return const SponsorBlockCacheResult(.cancelled);
          await temporary.writeAsString(
            jsonEncode(snapshot.toJson()),
            flush: true,
          );
          if (!valid()) return const SponsorBlockCacheResult(.cancelled);
          // 同步替换与代次检查之间没有异步间隔，删除也使用同一文件锁。
          replaceFile(temporary, destination);
          return SponsorBlockCacheResult(.ready, snapshot: snapshot);
        } finally {
          if (temporary.existsSync()) {
            try {
              await temporary.delete();
            } catch (_) {}
          }
        }
      });
    }();
    try {
      return await Future.any([
        operation,
        token.whenCancel.then(
          (_) => timedOut
              ? const SponsorBlockCacheResult(.failed, code: -1)
              : const SponsorBlockCacheResult(.cancelled),
        ),
      ]);
    } on SponsorBlockFetchException catch (e) {
      return SponsorBlockCacheResult(.failed, code: e.code);
    } catch (_) {
      return const SponsorBlockCacheResult(.failed);
    } finally {
      timer.cancel();
      if (identical(_active[key], token)) _active.remove(key);
    }
  }
}
