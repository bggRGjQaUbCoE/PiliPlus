import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Directory, File, FileSystemEntity, gzip;

import 'package:PiliPlus/grpc/dm.dart';
import 'package:PiliPlus/http/download.dart';
import 'package:PiliPlus/http/init.dart';
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
import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/id_utils.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:synchronized/synchronized.dart';

// ref https://github.com/10miaomiao/bilimiao2/blob/master/bilimiao-download/src/main/java/cn/a10miaomiao/bilimiao/download/DownloadService.kt

class DownloadService extends GetxService {
  static const _entryFile = 'entry.json';
  static const _indexFile = 'index.json';
  static const danmakuFile = 'danmaku.pb.gz';
  static const _coverFile = 'cover.jpg';

  final _lock = Lock();

  final downloaFlag = RxnInt();
  final waitDownloadQueue = <BiliDownloadEntryInfo>[];
  final downloadList = RxList<BiliDownloadEntryInfo>();

  final curDownload = Rxn<BiliDownloadEntryInfo>();
  void _updateCurStatus(DownloadStatus status) {
    if (curDownload.value != null) {
      curDownload
        ..value!.status = status
        ..refresh();
    }
  }

  DownloadManager? _downloadManager;
  DownloadManager? _audioDownloadManager;

  Completer? _completer;
  Future<void>? get waitForInitialization => _completer?.future;

  @override
  void onInit() {
    super.onInit();
    readDownloadList();
  }

  Future<void> readDownloadList() async {
    _completer = Completer();
    final downloadDir = Directory(await _getDownloadPath());
    final list = <BiliDownloadEntryInfo>[];
    for (final dir in downloadDir.listSync()) {
      if (dir is Directory) {
        list.addAll(await _readDownloadDirectory(dir));
      }
    }
    downloadList.value = list
      ..sort((a, b) => b.timeUpdateStamp.compareTo(a.timeUpdateStamp));
    if (!_completer!.isCompleted) {
      _completer!.complete();
    }
  }

  Future<List<BiliDownloadEntryInfo>> _readDownloadDirectory(
    FileSystemEntity pageDir,
  ) async {
    final result = <BiliDownloadEntryInfo>[];

    if (!pageDir.existsSync() || pageDir is! Directory) {
      return result;
    }

    for (final entryDir in pageDir.listSync()) {
      if (entryDir is Directory) {
        final entryFile = File(path.join(entryDir.path, _entryFile));
        if (entryFile.existsSync()) {
          try {
            final entryJson = await entryFile.readAsString();
            final entry = BiliDownloadEntryInfo.fromJson(jsonDecode(entryJson))
              ..pageDirPath = pageDir.path
              ..entryDirPath = entryDir.path;
            result.add(entry);
            if (!entry.isCompleted) {
              waitDownloadQueue.add(entry);
            }
          } catch (_) {
            if (kDebugMode) rethrow;
          }
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
      hasDashAudio: true,
      isCompleted: false,
      totalBytes: 0,
      downloadedBytes: 0,
      title: videoDetail?.title ?? videoArc!.title!,
      typeTag: videoQuality.code.toString(),
      cover: videoDetail?.pic ?? videoArc!.cover!,
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
      hasDashAudio: true,
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
    final entryJsonStr = jsonEncode(entry.toJson());
    await entryJsonFile.writeAsString(entryJsonStr);
    entry
      ..pageDirPath = entryDir.parent.path
      ..entryDirPath = entryDir.path
      ..status = DownloadStatus.wait;
    downloadList.insert(0, entry);
    downloaFlag.refresh();
    final currStatus = curDownload.value?.status?.index;
    if (currStatus == null || currStatus > 3) {
      startDownload(entry);
    } else {
      waitDownloadQueue.add(entry);
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

  Future<String> _getDownloadPath() async {
    final dir = Directory(downloadPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<void> startDownload(BiliDownloadEntryInfo entry) {
    return _lock.synchronized(() async {
      await _downloadManager?.cancel(isDelete: false);
      await _audioDownloadManager?.cancel(isDelete: false);
      _downloadManager = null;
      _audioDownloadManager = null;
      final prevStatus = curDownload.value?.status?.index;
      if (prevStatus != null && prevStatus <= 3) {
        curDownload.value?.status = DownloadStatus.pause;
      }

      curDownload.value = entry;
      await _startDownload(entry);
    });
  }

  Future<bool> downloadDanmaku({
    required BiliDownloadEntryInfo entry,
    bool isUpdate = false,
  }) async {
    final cid = entry.pageData?.cid ?? entry.source?.cid;
    if (cid == null) {
      return false;
    }
    final danmakuFile = File(
      path.join(entry.entryDirPath, DownloadService.danmakuFile),
    );
    if (isUpdate || !danmakuFile.existsSync()) {
      try {
        if (!isUpdate) {
          _updateCurStatus(DownloadStatus.getDanmaku);
        }
        final seg = PlDanmakuController.calcSegment(entry.totalTimeMilli) + 1;

        final res = await Future.wait([
          for (var i = 1; i <= seg; i++)
            DmGrpc.dmSegMobile(cid: cid, segmentIndex: i),
        ]);

        final danmaku = res.removeAt(0).data;
        for (var i in res) {
          danmaku.elems.addAll(i.data.elems);
        }
        res.clear();
        danmakuFile.writeAsBytes(gzip.encode(danmaku.writeToBuffer()));

        return true;
      } catch (e) {
        if (!isUpdate) {
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
      await Request.dio.download(
        entry.cover.http2https,
        path.join(entry.entryDirPath, _coverFile),
      );
      return true;
    } catch (_) {}
    return false;
  }

  Future<void> _startDownload(BiliDownloadEntryInfo entry) async {
    try {
      _updateCurStatus(DownloadStatus.getPlayUrl);

      final BiliDownloadMediaInfo mediaFileInfo =
          await DownloadHttp.getVideoUrl(
            entry: entry,
            ep: entry.ep,
            source: entry.source,
            pageData: entry.pageData,
          );

      final videoDir = Directory(path.join(entry.entryDirPath, entry.typeTag));
      if (!videoDir.existsSync()) {
        await videoDir.create(recursive: true);
      }

      final res = await Future.wait([
        downloadDanmaku(entry: entry),
        _downloadCover(entry: entry),
      ]);

      if (!res.first) {
        return;
      }

      final mediaJsonFile = File(path.join(videoDir.path, _indexFile));
      final mediaJsonStr = Utils.jsonEncoder.convert(mediaFileInfo.toJson());
      await mediaJsonFile.writeAsString(mediaJsonStr);

      if (curDownload.value?.cid != entry.cid) {
        return;
      }

      switch (mediaFileInfo) {
        case Type1 mediaFileInfo:
          final first = mediaFileInfo.segmentList.first;
          _downloadManager = DownloadManager(
            url: first.url,
            path: path.join(videoDir.path, PathUtils.videoNameType1),
            onTaskRunning: _onTaskRunning,
            onTaskComplete: _onTaskComplete,
            onTaskError: _onTaskError,
          )..start();
          break;
        case Type2 mediaFileInfo:
          _downloadManager = DownloadManager(
            url: mediaFileInfo.video.first.baseUrl,
            path: path.join(videoDir.path, PathUtils.videoNameType2),
            onTaskRunning: _onTaskRunning,
            onTaskComplete: _onTaskComplete,
            onTaskError: _onTaskError,
          )..start();
          final audio = mediaFileInfo.audio;
          if (audio != null && audio.isNotEmpty) {
            _audioDownloadManager = DownloadManager(
              url: audio.first.baseUrl,
              path: path.join(videoDir.path, PathUtils.audioNameType2),
              onTaskRunning: _onAudioTaskRunning,
              onTaskComplete: _onAudioTaskComplete,
              onTaskError: _onAudioTaskError,
            )..start();
          }
          late final first = mediaFileInfo.video.first;
          entry.pageData
            ?..width = first.width
            ..height = first.height;
          entry.ep
            ?..width = first.width
            ..height = first.height;
          _updateBiliDownloadEntryJson(entry);
          break;
        default:
          break;
      }
    } catch (e) {
      _updateCurStatus(DownloadStatus.failPlayUrl);
      if (kDebugMode) {
        debugPrint('get download url error: $e');
      }
    }
  }

  Future<void> _updateBiliDownloadEntryJson(BiliDownloadEntryInfo entry) async {
    final entryJsonFile = File(path.join(entry.entryDirPath, _entryFile));
    final entryJsonStr = Utils.jsonEncoder.convert(entry.toJson());
    await entryJsonFile.writeAsString(entryJsonStr);
  }

  void _onTaskRunning({required int progress, required int total}) {
    if (progress == 0 && total != 0) {
      if (curDownload.value case final curEntryInfo?) {
        _updateBiliDownloadEntryJson(curEntryInfo..totalBytes = total);
      }
    }
    if (curDownload.value case final entry?) {
      entry
        ..downloadedBytes = progress
        ..status = DownloadStatus.downloading;
      curDownload.refresh();
    }
  }

  void _onTaskComplete() {
    final audioStatus = _audioDownloadManager?.status;
    final status = switch (audioStatus) {
      DownloadStatus.downloading => DownloadStatus.audioDownloading,
      DownloadStatus.failDownload => DownloadStatus.failDownloadAudio,
      null => DownloadStatus.completed,
      _ => audioStatus,
    };
    _updateCurStatus(status);
    if (status == DownloadStatus.completed) {
      _completeDownload();
    } else {
      if (curDownload.value case final curEntryInfo?) {
        _updateBiliDownloadEntryJson(
          curEntryInfo..downloadedBytes = curEntryInfo.totalBytes,
        );
      }
    }
  }

  void _onTaskError({
    required int progress,
    required int total,
    required Object error,
  }) {
    _updateCurStatus(DownloadStatus.failDownload);
    if (curDownload.value case final curEntryInfo?) {
      curEntryInfo
        ..totalBytes = total
        ..downloadedBytes = progress;
      _updateBiliDownloadEntryJson(curEntryInfo);
    }
  }

  void _onAudioTaskRunning({required int progress, required int total}) {}

  void _onAudioTaskComplete() {
    if (_downloadManager?.status == DownloadStatus.completed) {
      _completeDownload();
    }
  }

  void _onAudioTaskError({
    required int progress,
    required int total,
    required Object error,
  }) {
    if (_downloadManager?.status == DownloadStatus.completed) {
      _updateCurStatus(DownloadStatus.failDownloadAudio);
    }
  }

  Future<void> _completeDownload() async {
    final entry = curDownload.value;
    if (entry == null) {
      return;
    }
    entry
      ..downloadedBytes = entry.totalBytes
      ..isCompleted = true;
    await _updateBiliDownloadEntryJson(entry);
    downloaFlag.refresh();
    curDownload.value = null;
    _downloadManager = null;
    _audioDownloadManager = null;
    _nextDownload();
  }

  void _nextDownload() {
    if (waitDownloadQueue.isNotEmpty) {
      final next = waitDownloadQueue.removeAt(0);
      if (downloadList.contains(next)) {
        startDownload(next);
      } else {
        _nextDownload();
      }
    }
  }

  Future<void> deleteDownload({
    required BiliDownloadEntryInfo entry,
  }) async {
    if (curDownload.value?.cid == entry.cid) {
      await cancelDownload(isDelete: true);
    }
    final downloadDir = Directory(entry.pageDirPath);
    if (downloadDir.existsSync()) {
      if (downloadDir.listSync().length <= 1) {
        await downloadDir.tryDel(recursive: true);
      } else {
        final entryDir = Directory(entry.entryDirPath);
        if (entryDir.existsSync()) {
          await entryDir.tryDel(recursive: true);
        }
      }
    }
    downloadList.remove(entry);
    waitDownloadQueue.remove(entry);
    downloaFlag.refresh();
  }

  Future<void> deletePage({required String pageDirPath}) async {
    await Directory(pageDirPath).tryDel(recursive: true);
    downloadList.removeWhere((e) => e.pageDirPath == pageDirPath);
    downloaFlag.refresh();
  }

  Future<void> cancelDownload({
    required bool isDelete,
    bool downloadNext = true,
  }) async {
    await _downloadManager?.cancel(isDelete: isDelete);
    await _audioDownloadManager?.cancel(isDelete: isDelete);
    _downloadManager = null;
    _audioDownloadManager = null;
    if (!isDelete) {
      final entry = curDownload.value;
      if (entry != null) {
        await _updateBiliDownloadEntryJson(entry);
      }
    }
    if (isDelete) {
      curDownload.value = null;
    } else {
      _updateCurStatus(DownloadStatus.pause);
    }
    if (downloadNext) {
      _nextDownload();
    }
  }
}
