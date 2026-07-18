import 'dart:async';
import 'dart:collection' show HashSet;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Directory, File;

import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/http/download.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/models/common/video/video_quality.dart';
import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/bili_download_media_file_info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/episode.dart' as pgc;
import 'package:PiliPlus/models_new/pgc/pgc_info_model/result.dart';
import 'package:PiliPlus/models_new/video/video_detail/data.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart' as ugc;
import 'package:PiliPlus/models_new/video/video_detail/page.dart';
import 'package:PiliPlus/pages/danmaku/controller.dart';
import 'package:PiliPlus/services/download/download_manager.dart';
import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/extension/string_ext.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:synchronized/synchronized.dart';

// ref https://github.com/10miaomiao/bilimiao2/blob/master/bilimiao-download/src/main/java/cn/a10miaomiao/bilimiao/download/DownloadService.kt

class DownloadService extends GetxService {
  static const _entryFile = 'entry.json';
  static const _indexFile = 'index.json';

  final DownloadDanmakuCallback? _downloadDanmakuOverride;
  final DownloadMediaResolver _downloadMediaResolver;
  final DownloadManagerFactory _downloadManagerFactory;
  final Future<void> Function(BiliDownloadEntryInfo entry)?
  _persistEntryOverride;

  DownloadService()
    : _downloadDanmakuOverride = null,
      _downloadMediaResolver = DownloadHttp.getVideoUrl,
      _downloadManagerFactory = DownloadManager.new,
      _persistEntryOverride = null;

  @visibleForTesting
  DownloadService.test({
    required DownloadDanmakuCallback downloadDanmaku,
    required DownloadMediaResolver downloadMedia,
    required DownloadManagerFactory createDownloadManager,
    Future<void> Function(BiliDownloadEntryInfo entry)? persistEntry,
  }) : _downloadDanmakuOverride = downloadDanmaku,
       _downloadMediaResolver = downloadMedia,
       _downloadManagerFactory = createDownloadManager,
       _persistEntryOverride = persistEntry;

  final _lock = Lock();
  final _entryWriteLock = Lock();
  int _downloadOperation = 0;
  _DownloadIntent _latestDownloadIntent = _DownloadIntent.start;
  final _deletingEntries = HashSet<BiliDownloadEntryInfo>.identity();

  final flagNotifier = SetNotifier();
  final waitDownloadQueue = RxList<BiliDownloadEntryInfo>();
  final downloadList = <BiliDownloadEntryInfo>[];

  int? _curCid;
  int? get curCid => _curCid;
  final curDownload = Rxn<BiliDownloadEntryInfo>();
  void _updateCurStatus(DownloadStatus status) {
    if (curDownload.value != null) {
      curDownload
        ..value!.status = status
        ..refresh();
    }
  }

  DownloadTask? _downloadManager;
  DownloadTask? _audioDownloadManager;

  late Future<void> waitForInitialization;

  @override
  void onInit() {
    super.onInit();
    initDownloadList();
  }

  void initDownloadList() {
    waitForInitialization = _readDownloadList();
  }

  Future<void> _readDownloadList() async {
    downloadList.clear();
    final downloadDir = Directory(await _getDownloadPath());
    await for (final dir in downloadDir.list()) {
      if (dir is Directory) {
        downloadList.addAll(await _readDownloadDirectory(dir));
      }
    }
    downloadList.sort((a, b) => b.timeUpdateStamp.compareTo(a.timeUpdateStamp));
  }

  @pragma('vm:notify-debugger-on-exception')
  Future<List<BiliDownloadEntryInfo>> _readDownloadDirectory(
    Directory pageDir,
  ) async {
    final result = <BiliDownloadEntryInfo>[];

    if (!pageDir.existsSync()) {
      return result;
    }

    await for (final entryDir in pageDir.list()) {
      if (entryDir is Directory) {
        final entryFile = File(path.join(entryDir.path, _entryFile));
        if (entryFile.existsSync()) {
          try {
            final entryJson = await entryFile.readAsString();
            final entry = BiliDownloadEntryInfo.fromJson(jsonDecode(entryJson))
              ..pageDirPath = pageDir.path
              ..entryDirPath = entryDir.path;
            if (entry.isCompleted) {
              result.add(entry);
            } else {
              waitDownloadQueue.add(entry..status = DownloadStatus.wait);
            }
          } catch (_) {}
        }
      }
    }

    return result;
  }

  void downloadVideo(
    Part page,
    VideoDetailData? videoDetail,
    ugc.EpisodeItem? videoArc,
    VideoQuality videoQuality,
  ) {
    final cid = page.cid!;
    if (downloadList.indexWhere((e) => e.cid == cid) != -1) {
      return;
    }
    if (waitDownloadQueue.indexWhere((e) => e.cid == cid) != -1) {
      return;
    }
    final pageData = PageInfo(
      cid: cid,
      page: page.page!,
      from: page.from,
      part: page.part,
      vid: page.vid,
      hasAlias: false,
      tid: 0,
      width: 0,
      height: 0,
      rotate: 0,
      downloadTitle: '视频已缓存完成',
      downloadSubtitle: videoDetail?.title ?? videoArc!.title,
    );
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final entry = BiliDownloadEntryInfo(
      mediaType: 2,
      hasDashAudio: false,
      isCompleted: false,
      totalBytes: 0,
      downloadedBytes: 0,
      title: videoDetail?.title ?? videoArc!.title!,
      typeTag: videoQuality.code.toString(),
      cover: (videoDetail?.pic ?? videoArc!.cover!).http2https,
      preferedVideoQuality: videoQuality.code,
      qualityPithyDescription: videoQuality.desc,
      guessedTotalBytes: 0,
      totalTimeMilli: (page.duration ?? 0) * 1000,
      danmakuCount:
          videoDetail?.stat?.danmaku ?? videoArc?.arc?.stat?.danmaku ?? 0,
      timeUpdateStamp: currentTime,
      timeCreateStamp: currentTime,
      canPlayInAdvance: true,
      interruptTransformTempFile: false,
      avid: videoDetail?.aid ?? videoArc!.aid!,
      spid: 0,
      seasonId: null,
      ep: null,
      source: null,
      bvid: videoDetail?.bvid ?? videoArc!.bvid!,
      ownerId: videoDetail?.owner?.mid ?? videoArc?.arc?.author?.mid,
      ownerName: videoDetail?.owner?.name ?? videoArc?.arc?.author?.name,
      pageData: pageData,
    );
    _createDownload(entry);
  }

  void downloadBangumi(
    int index,
    PgcInfoModel pgcItem,
    pgc.EpisodeItem episode,
    VideoQuality quality,
  ) {
    final cid = episode.cid!;
    if (downloadList.indexWhere((e) => e.cid == cid) != -1) {
      return;
    }
    if (waitDownloadQueue.indexWhere((e) => e.cid == cid) != -1) {
      return;
    }
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final source = SourceInfo(
      avId: episode.aid!,
      cid: cid,
    );
    final ep = EpInfo(
      avId: source.avId,
      page: index,
      danmaku: source.cid,
      cover: episode.cover!,
      episodeId: episode.id!,
      index: episode.title!,
      indexTitle: episode.longTitle ?? '',
      showTitle: episode.showTitle,
      from: episode.from ?? 'bangumi',
      seasonType: pgcItem.type ?? (episode.from == 'pugv' ? -1 : 0),
      width: 0,
      height: 0,
      rotate: 0,
      link: episode.link ?? '',
      bvid: episode.bvid ?? IdUtils.av2bv(source.avId),
      sortIndex: index,
    );
    final entry = BiliDownloadEntryInfo(
      mediaType: 2,
      hasDashAudio: false,
      isCompleted: false,
      totalBytes: 0,
      downloadedBytes: 0,
      title: pgcItem.seasonTitle ?? pgcItem.title ?? '',
      typeTag: quality.code.toString(),
      cover: episode.cover!,
      preferedVideoQuality: quality.code,
      qualityPithyDescription: quality.desc,
      guessedTotalBytes: 0,
      totalTimeMilli:
          (episode.duration ?? 0) *
          (episode.from == 'pugv' ? 1000 : 1), // pgc millisec,, pugv sec
      danmakuCount: pgcItem.stat?.danmaku ?? 0,
      timeUpdateStamp: currentTime,
      timeCreateStamp: currentTime,
      canPlayInAdvance: true,
      interruptTransformTempFile: false,
      spid: 0,
      seasonId: pgcItem.seasonId!.toString(),
      bvid: episode.bvid ?? IdUtils.av2bv(source.avId),
      avid: source.avId,
      ep: ep,
      source: source,
      ownerId: pgcItem.upInfo?.mid,
      ownerName: pgcItem.upInfo?.uname,
      pageData: null,
    );
    _createDownload(entry);
  }

  Future<void> _createDownload(BiliDownloadEntryInfo entry) async {
    final entryDir = await _getDownloadEntryDir(entry);
    final entryJsonFile = File(path.join(entryDir.path, _entryFile));
    await entryJsonFile.writeAsString(jsonEncode(entry.toJson()));
    entry
      ..pageDirPath = entryDir.parent.path
      ..entryDirPath = entryDir.path
      ..status = DownloadStatus.wait;
    waitDownloadQueue.add(entry);
    if (curDownload.value?.status.isDownloading != true) {
      startDownload(entry);
    }
  }

  Future<Directory> _getDownloadEntryDir(BiliDownloadEntryInfo entry) async {
    late final String dirName;
    late final String pageDirName;
    if (entry.ep case final ep?) {
      dirName = 's_${entry.seasonId}';
      pageDirName = ep.episodeId.toString();
    } else if (entry.pageData case final page?) {
      dirName = entry.avid.toString();
      pageDirName = 'c_${page.cid}';
    }
    final pageDir = Directory(
      path.join(await _getDownloadPath(), dirName, pageDirName),
    );
    if (!pageDir.existsSync()) {
      await pageDir.create(recursive: true);
    }
    return pageDir;
  }

  static Future<String> _getDownloadPath() async {
    final dir = Directory(downloadPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<void> startDownload(BiliDownloadEntryInfo entry) async {
    final operation = ++_downloadOperation;
    _latestDownloadIntent = _DownloadIntent.start;
    final shouldStart = await _lock.synchronized(() async {
      if (operation != _downloadOperation || _deletingEntries.contains(entry)) {
        return false;
      }
      await _downloadManager?.cancel(isDelete: false);
      await _audioDownloadManager?.cancel(isDelete: false);
      if (operation != _downloadOperation || _deletingEntries.contains(entry)) {
        return false;
      }
      _downloadManager = null;
      _audioDownloadManager = null;
      if (curDownload.value case final curEntry?) {
        if (curEntry.status.isDownloading) {
          curEntry.status = DownloadStatus.pause;
        }
      }

      _curCid = entry.cid;
      curDownload.value = entry;
      waitDownloadQueue.refresh();
      return true;
    });
    if (shouldStart &&
        !_deletingEntries.contains(entry) &&
        _isCurrentOperation(entry, operation)) {
      await _startDownload(entry, operation);
    }
  }

  Future<bool> downloadDanmaku({
    required BiliDownloadEntryInfo entry,
    bool isUpdate = false,
  }) => _downloadDanmaku(entry: entry, isUpdate: isUpdate);

  Future<bool> _downloadDanmaku({
    required BiliDownloadEntryInfo entry,
    required bool isUpdate,
    bool Function()? canUpdateStatus,
  }) async {
    final cid = entry.pageData?.cid ?? entry.source?.cid;
    if (cid == null) {
      return false;
    }
    final danmakuFile = File(
      path.join(entry.entryDirPath, PathUtils.danmakuName),
    );
    if (isUpdate || !danmakuFile.existsSync()) {
      try {
        if (!isUpdate && (canUpdateStatus?.call() ?? true)) {
          _updateCurStatus(DownloadStatus.getDanmaku);
        }
        final seg = (entry.totalTimeMilli / PlDanmakuController.segmentLength)
            .ceil();

        final res = await Future.wait([
          for (var i = 1; i <= seg; i++)
            DmGrpc.dmSegMobile(cid: cid, segmentIndex: i),
        ]);

        final danmaku = res.removeAt(0).data;
        for (final i in res) {
          if (i case Success(:final response)) {
            danmaku.elems.addAll(response.elems);
          }
        }
        res.clear();
        await danmakuFile.writeAsBytes(danmaku.writeToBuffer());

        return true;
      } catch (e) {
        if (!isUpdate && (canUpdateStatus?.call() ?? true)) {
          _updateCurStatus(DownloadStatus.failDanmaku);
        }
        if (kDebugMode) SmartDialog.showToast(e.toString());
        return false;
      }
    }
    return true;
  }

  Future<bool> _downloadCover({
    required BiliDownloadEntryInfo entry,
  }) async {
    try {
      final filePath = path.join(entry.entryDirPath, PathUtils.coverName);
      if (File(filePath).existsSync()) {
        return true;
      }
      final file = (await CacheManager.manager.getFileFromCache(
        entry.cover,
      ))?.file;
      if (file != null) {
        await file.copy(filePath);
      } else {
        await Request.dio.download(entry.cover, filePath);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isCurrentOperation(
    BiliDownloadEntryInfo entry,
    int operation,
  ) => operation == _downloadOperation && identical(curDownload.value, entry);

  Future<void> _startDownload(
    BiliDownloadEntryInfo entry,
    int operation,
  ) async {
    try {
      final downloadDanmakuOverride = _downloadDanmakuOverride;
      if (!await (downloadDanmakuOverride != null
          ? downloadDanmakuOverride(entry)
          : _downloadDanmaku(
              entry: entry,
              isUpdate: false,
              canUpdateStatus: () => _isCurrentOperation(entry, operation),
            ))) {
        return;
      }
      if (!_isCurrentOperation(entry, operation)) {
        return;
      }

      _updateCurStatus(DownloadStatus.getPlayUrl);

      final mediaFileInfo = await _downloadMediaResolver(
        entry: entry,
        ep: entry.ep,
        source: entry.source,
        pageData: entry.pageData,
      );
      if (!_isCurrentOperation(entry, operation)) {
        return;
      }

      final videoDir = Directory(path.join(entry.entryDirPath, entry.typeTag));
      if (!videoDir.existsSync()) {
        await videoDir.create(recursive: true);
      }

      final mediaJsonFile = File(path.join(videoDir.path, _indexFile));
      await Future.wait([
        mediaJsonFile.writeAsString(jsonEncode(mediaFileInfo.toJson())),
        _downloadCover(entry: entry),
      ]);

      if (!_isCurrentOperation(entry, operation)) {
        return;
      }

      switch (mediaFileInfo) {
        case Type1 mediaFileInfo:
          final first = mediaFileInfo.segmentList.first;
          _downloadManager = _downloadManagerFactory(
            url: first.url,
            path: path.join(videoDir.path, PathUtils.videoNameType1),
            onReceiveProgress: (progress, total) =>
                _onReceive(entry, operation, progress, total),
            onDone: ([error]) => _onDone(entry, operation, error),
          );
          break;
        case Type2 mediaFileInfo:
          _downloadManager = _downloadManagerFactory(
            url: mediaFileInfo.video.first.baseUrl,
            path: path.join(videoDir.path, PathUtils.videoNameType2),
            onReceiveProgress: (progress, total) =>
                _onReceive(entry, operation, progress, total),
            onDone: ([error]) => _onDone(entry, operation, error),
          );
          final audio = mediaFileInfo.audio;
          if (audio != null && audio.isNotEmpty) {
            _audioDownloadManager = _downloadManagerFactory(
              url: audio.first.baseUrl,
              path: path.join(videoDir.path, PathUtils.audioNameType2),
              onReceiveProgress: null,
              onDone: ([error]) => _onAudioDone(entry, operation, error),
            );
          }
          late final first = mediaFileInfo.video.first;
          entry.pageData
            ?..width = first.width
            ..height = first.height;
          entry.ep
            ?..width = first.width
            ..height = first.height;
          _updateBiliDownloadEntryJson(entry).ignore();
          break;
        default:
          break;
      }
    } catch (e) {
      if (_isCurrentOperation(entry, operation)) {
        _updateCurStatus(DownloadStatus.failPlayUrl);
      }
      if (kDebugMode) {
        debugPrint('get download url error: ${e.runtimeType}');
      }
    }
  }

  Future<void> _updateBiliDownloadEntryJson(BiliDownloadEntryInfo entry) =>
      _entryWriteLock.synchronized(() {
        if (_persistEntryOverride case final persistEntry?) {
          return persistEntry(entry);
        }
        final entryJsonFile = File(path.join(entry.entryDirPath, _entryFile));
        return entryJsonFile.writeAsString(jsonEncode(entry.toJson()));
      });

  void _onReceive(
    BiliDownloadEntryInfo entry,
    int operation,
    int progress,
    int total,
  ) {
    if (!_isCurrentOperation(entry, operation) || entry.isCompleted) return;
    if (progress == 0 && total != 0) {
      _updateBiliDownloadEntryJson(entry..totalBytes = total).ignore();
    }
    entry
      ..downloadedBytes = progress
      ..status = DownloadStatus.downloading;
    curDownload.refresh();
  }

  void _onDone(
    BiliDownloadEntryInfo entry,
    int operation, [
    Object? error,
  ]) {
    if (error != null) {
      if (_isCurrentOperation(entry, operation)) {
        _updateCurStatus(_downloadManager?.status ?? DownloadStatus.pause);
      }
      return;
    }
    if (!_isCurrentOperation(entry, operation)) return;

    final status = switch (_audioDownloadManager?.status) {
      DownloadStatus.downloading => DownloadStatus.audioDownloading,
      DownloadStatus.failDownload => DownloadStatus.failDownloadAudio,
      _ => _downloadManager?.status ?? DownloadStatus.pause,
    };
    _updateCurStatus(status);

    entry.downloadedBytes = entry.totalBytes;
    if (status == DownloadStatus.completed) {
      _completeDownload(entry, operation).ignore();
    } else if (_isCurrentOperation(entry, operation)) {
      _updateBiliDownloadEntryJson(entry).ignore();
    }
  }

  void _onAudioDone(
    BiliDownloadEntryInfo entry,
    int operation, [
    Object? error,
  ]) {
    if (!_isCurrentOperation(entry, operation)) return;
    if (_downloadManager?.status == DownloadStatus.completed) {
      if (error == null) {
        _completeDownload(entry, operation).ignore();
      } else if (_isCurrentOperation(entry, operation)) {
        final status = _audioDownloadManager?.status ?? DownloadStatus.pause;
        _updateCurStatus(
          status == DownloadStatus.failDownload
              ? DownloadStatus.failDownloadAudio
              : status,
        );
      }
    }
  }

  Future<void> _completeDownload(
    BiliDownloadEntryInfo entry,
    int operation,
  ) => _lock.synchronized(() async {
    if (_deletingEntries.contains(entry) ||
        !_isCurrentOperation(entry, operation) ||
        entry.isCompleted) {
      return;
    }

    entry
      ..downloadedBytes = entry.totalBytes
      ..isCompleted = true;
    try {
      await _updateBiliDownloadEntryJson(entry);
    } catch (e) {
      entry.isCompleted = false;
      if (_isCurrentOperation(entry, operation)) {
        _updateCurStatus(DownloadStatus.failDownload);
      }
      if (kDebugMode) debugPrint('update download entry error: $e');
      return;
    }

    if (_deletingEntries.contains(entry)) {
      entry.isCompleted = false;
      return;
    }
    if (!_isCurrentOperation(entry, operation) &&
        _latestDownloadIntent == _DownloadIntent.cancel) {
      entry.isCompleted = false;
      return;
    }

    waitDownloadQueue.remove(entry);
    if (!downloadList.contains(entry)) {
      downloadList.insert(0, entry);
    }
    flagNotifier.refresh();

    if (!identical(curDownload.value, entry)) return;
    _curCid = null;
    curDownload.value = null;
    _downloadManager = null;
    _audioDownloadManager = null;
    if (operation == _downloadOperation) {
      nextDownload();
    }
  });

  void nextDownload() {
    if (waitDownloadQueue.isNotEmpty) {
      startDownload(waitDownloadQueue.first);
    }
  }

  Future<void> deleteDownload({
    required BiliDownloadEntryInfo entry,
    bool removeList = false,
    bool removeQueue = false,
    bool refresh = true,
    bool downloadNext = true,
  }) async {
    _deletingEntries.add(entry);
    try {
      if (removeList) {
        downloadList.remove(entry);
      }
      if (removeQueue) {
        waitDownloadQueue.remove(entry);
      }
      if (curDownload.value?.cid == entry.cid) {
        await cancelDownload(
          isDelete: true,
          downloadNext: downloadNext,
        );
      }
      final downloadDir = Directory(entry.pageDirPath);
      if (downloadDir.existsSync()) {
        if (!await downloadDir.lengthGte(2)) {
          await downloadDir.tryDel(recursive: true);
        } else {
          final entryDir = Directory(entry.entryDirPath);
          if (entryDir.existsSync()) {
            await entryDir.tryDel(recursive: true);
          }
        }
      }
      if (refresh) {
        flagNotifier.refresh();
      }
    } finally {
      _deletingEntries.remove(entry);
    }
  }

  Future<void> deletePage({
    required String pageDirPath,
    bool refresh = true,
  }) async {
    await Directory(pageDirPath).tryDel(recursive: true);
    downloadList.removeWhere((e) => e.pageDirPath == pageDirPath);
    if (refresh) {
      flagNotifier.refresh();
    }
  }

  Future<void> cancelDownload({
    required bool isDelete,
    bool downloadNext = true,
  }) {
    final operation = ++_downloadOperation;
    _latestDownloadIntent = _DownloadIntent.cancel;
    return _lock.synchronized(() async {
      if (operation != _downloadOperation) return;
      await _downloadManager?.cancel(isDelete: isDelete);
      await _audioDownloadManager?.cancel(isDelete: isDelete);
      if (operation != _downloadOperation) return;

      _downloadManager = null;
      _audioDownloadManager = null;
      final entry = curDownload.value;
      if (isDelete) {
        _curCid = null;
        curDownload.value = null;
      } else if (entry != null) {
        entry
          ..isCompleted = false
          ..status = DownloadStatus.pause;
        curDownload.refresh();
        await _updateBiliDownloadEntryJson(entry);
        if (operation != _downloadOperation) return;
      }
      if (downloadNext) {
        nextDownload();
      }
    });
  }
}

enum _DownloadIntent { start, cancel }

typedef DownloadDanmakuCallback =
    Future<bool> Function(BiliDownloadEntryInfo entry);

typedef DownloadMediaResolver =
    Future<BiliDownloadMediaInfo> Function({
      required BiliDownloadEntryInfo entry,
      SourceInfo? source,
      PageInfo? pageData,
      EpInfo? ep,
    });

typedef DownloadManagerFactory =
    DownloadTask Function({
      required String url,
      required String path,
      required void Function(int, int)? onReceiveProgress,
      required void Function([Object? error]) onDone,
    });

typedef SetNotifier = Set<VoidCallback>;

extension SetNotifierExt on SetNotifier {
  void refresh() {
    for (final i in this) {
      i();
    }
  }
}
