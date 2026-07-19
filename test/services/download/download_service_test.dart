import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/bili_download_media_file_info.dart';
import 'package:PiliPlus/services/download/download_manager.dart';
import 'package:PiliPlus/services/download/download_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory testDir;

  setUp(() async {
    testDir = await Directory.systemTemp.createTemp(
      'piliplus_download_service_test_',
    );
  });

  tearDown(() => testDir.delete(recursive: true));

  test('pause during danmaku preflight does not resolve media', () async {
    final entry = await _createEntry(testDir);
    final danmakuStarted = Completer<void>();
    final releaseDanmaku = Completer<bool>();
    var mediaResolveCount = 0;
    var transferStartCount = 0;
    final service = DownloadService.test(
      downloadDanmaku: (_) {
        danmakuStarted.complete();
        return releaseDanmaku.future;
      },
      downloadMedia: ({required entry, source, pageData, ep}) async {
        mediaResolveCount++;
        return _mediaInfo;
      },
      createDownloadManager:
          ({
            required url,
            required path,
            required onReceiveProgress,
            required onDone,
          }) {
            transferStartCount++;
            throw StateError('media transfer must not start after pause');
          },
    );

    final start = service.startDownload(entry);
    await danmakuStarted.future;
    await service.cancelDownload(isDelete: false, downloadNext: false);
    expect(entry.status, DownloadStatus.pause);

    releaseDanmaku.complete(true);
    await start;

    expect(mediaResolveCount, 0);
    expect(transferStartCount, 0);
    expect(service.curDownload.value, same(entry));
    expect(entry.status, DownloadStatus.pause);
  });

  test('pause during play-url preflight does not start transfer', () async {
    final entry = await _createEntry(testDir);
    final mediaStarted = Completer<void>();
    final releaseMedia = Completer<BiliDownloadMediaInfo>();
    var transferStartCount = 0;
    final service = DownloadService.test(
      downloadDanmaku: (_) async => true,
      downloadMedia: ({required entry, source, pageData, ep}) {
        mediaStarted.complete();
        return releaseMedia.future;
      },
      createDownloadManager:
          ({
            required url,
            required path,
            required onReceiveProgress,
            required onDone,
          }) {
            transferStartCount++;
            throw StateError('media transfer must not start after pause');
          },
    );

    final start = service.startDownload(entry);
    await mediaStarted.future;
    expect(entry.status, DownloadStatus.getPlayUrl);

    await service.cancelDownload(isDelete: false, downloadNext: false);
    expect(entry.status, DownloadStatus.pause);

    releaseMedia.complete(_mediaInfo);
    await start;

    expect(transferStartCount, 0);
    expect(service.curDownload.value, same(entry));
    expect(entry.status, DownloadStatus.pause);
  });

  test('late transfer success cannot complete a paused entry', () async {
    final entry = await _createEntry(testDir);
    late _ControlledDownloadTask task;
    final service = DownloadService.test(
      downloadDanmaku: (_) async => true,
      downloadMedia: ({required entry, source, pageData, ep}) async =>
          _mediaInfo,
      createDownloadManager:
          ({
            required url,
            required path,
            required onReceiveProgress,
            required onDone,
          }) {
            return task = _ControlledDownloadTask(onDone);
          },
    );
    service.waitDownloadQueue.add(entry);

    await service.startDownload(entry);
    await service.cancelDownload(isDelete: false, downloadNext: false);
    expect(entry.status, DownloadStatus.pause);

    task.complete();
    await Future<void>.delayed(Duration.zero);

    expect(service.curDownload.value, same(entry));
    expect(entry.isCompleted, isFalse);
    expect(entry.status, DownloadStatus.pause);
    expect(service.waitDownloadQueue, contains(same(entry)));
    expect(service.downloadList, isEmpty);
  });

  test('pause wins while completion metadata is being persisted', () async {
    final entry = await _createEntry(testDir);
    final persistStarted = Completer<void>();
    final releasePersist = Completer<void>();
    final persistedStates = <({bool isCompleted, DownloadStatus status})>[];
    late _ControlledDownloadTask task;
    final service = DownloadService.test(
      downloadDanmaku: (_) async => true,
      downloadMedia: ({required entry, source, pageData, ep}) async =>
          _mediaInfo,
      createDownloadManager:
          ({
            required url,
            required path,
            required onReceiveProgress,
            required onDone,
          }) {
            return task = _ControlledDownloadTask(onDone);
          },
      persistEntry: (entry) async {
        final state = (
          isCompleted: entry.isCompleted,
          status: entry.status,
        );
        persistedStates.add(state);
        if (state.isCompleted && !persistStarted.isCompleted) {
          persistStarted.complete();
          await releasePersist.future;
        }
      },
    );
    service.waitDownloadQueue.add(entry);

    await service.startDownload(entry);
    task.complete();
    await persistStarted.future;

    final pause = service.cancelDownload(
      isDelete: false,
      downloadNext: false,
    );
    await Future<void>.delayed(Duration.zero);
    releasePersist.complete();
    await pause;

    expect(service.curDownload.value, same(entry));
    expect(entry.isCompleted, isFalse);
    expect(entry.status, DownloadStatus.pause);
    expect(service.waitDownloadQueue, contains(same(entry)));
    expect(service.downloadList, isEmpty);
    expect(
      persistedStates.last,
      (isCompleted: false, status: DownloadStatus.pause),
    );
  });

  test(
    'deleted entry cannot resurrect when a replacement start supersedes cancel',
    () async {
      final firstEntry = await _createEntry(testDir, cid: 2);
      final secondEntry = await _createEntry(testDir, cid: 3);
      final persistStarted = Completer<void>();
      final releasePersist = Completer<void>();
      final tasks = <_ControlledDownloadTask>[];
      final service = DownloadService.test(
        downloadDanmaku: (_) async => true,
        downloadMedia: ({required entry, source, pageData, ep}) async =>
            _mediaInfo,
        createDownloadManager:
            ({
              required url,
              required path,
              required onReceiveProgress,
              required onDone,
            }) {
              final task = _ControlledDownloadTask(onDone);
              tasks.add(task);
              return task;
            },
        persistEntry: (entry) async {
          if (identical(entry, firstEntry) &&
              entry.isCompleted &&
              !persistStarted.isCompleted) {
            persistStarted.complete();
            await releasePersist.future;
          }
        },
      );
      service.waitDownloadQueue.addAll([firstEntry, secondEntry]);

      await service.startDownload(firstEntry);
      tasks.single.complete();
      await persistStarted.future;

      final deletion = service.deleteDownload(
        entry: firstEntry,
        removeList: true,
        removeQueue: true,
        downloadNext: false,
      );
      await Future<void>.delayed(Duration.zero);
      final secondStart = service.startDownload(secondEntry);
      await Future<void>.delayed(Duration.zero);

      releasePersist.complete();
      await Future.wait([deletion, secondStart]);
      await Future<void>.delayed(Duration.zero);

      expect(tasks, hasLength(2));
      expect(service.curDownload.value, same(secondEntry));
      expect(service.waitDownloadQueue, isNot(contains(same(firstEntry))));
      expect(service.downloadList, isNot(contains(same(firstEntry))));
      expect(Directory(firstEntry.entryDirPath).existsSync(), isFalse);
      expect(Directory(secondEntry.entryDirPath).existsSync(), isTrue);
    },
  );

  test(
    'a completed entry cannot release a replacement download',
    () async {
      final firstEntry = await _createEntry(testDir, cid: 2);
      final secondEntry = await _createEntry(testDir, cid: 3);
      final persistStarted = Completer<void>();
      final releasePersist = Completer<void>();
      final tasks = <_ControlledDownloadTask>[];
      final service = DownloadService.test(
        downloadDanmaku: (_) async => true,
        downloadMedia: ({required entry, source, pageData, ep}) async =>
            _mediaInfo,
        createDownloadManager:
            ({
              required url,
              required path,
              required onReceiveProgress,
              required onDone,
            }) {
              final task = _ControlledDownloadTask(onDone);
              tasks.add(task);
              return task;
            },
        persistEntry: (entry) async {
          if (identical(entry, firstEntry) && entry.isCompleted) {
            persistStarted.complete();
            await releasePersist.future;
          }
        },
      );
      service.waitDownloadQueue.addAll([firstEntry, secondEntry]);

      await service.startDownload(firstEntry);
      expect(tasks, hasLength(1));

      tasks.single.complete();
      await persistStarted.future;

      final secondStart = service.startDownload(secondEntry);
      await Future<void>.delayed(Duration.zero);
      expect(service.curDownload.value, same(firstEntry));

      releasePersist.complete();
      await secondStart;
      await Future<void>.delayed(Duration.zero);

      expect(tasks, hasLength(2));
      expect(service.curDownload.value, same(secondEntry));
      expect(service.downloadList, contains(same(firstEntry)));
      expect(service.waitDownloadQueue, isNot(contains(same(firstEntry))));
    },
  );
}

Future<BiliDownloadEntryInfo> _createEntry(
  Directory testDir, {
  int cid = 2,
}) async {
  final entryDir = await Directory(
    path.join(testDir.path, '1', 'c_$cid'),
  ).create(recursive: true);
  return BiliDownloadEntryInfo(
      isCompleted: false,
      totalBytes: 0,
      downloadedBytes: 0,
      title: 'test',
      typeTag: '80',
      cover: '',
      preferedVideoQuality: 80,
      guessedTotalBytes: 0,
      totalTimeMilli: 1000,
      danmakuCount: 0,
      avid: 1,
      bvid: 'BV1test',
      pageData: PageInfo(
        cid: cid,
        page: 1,
        hasAlias: false,
        tid: 0,
      ),
    )
    ..pageDirPath = entryDir.parent.path
    ..entryDirPath = entryDir.path
    ..status = DownloadStatus.wait;
}

class _ControlledDownloadTask implements DownloadTask {
  _ControlledDownloadTask(this._onDone);

  final void Function([Object? error]) _onDone;

  @override
  DownloadStatus status = DownloadStatus.downloading;

  void complete() {
    status = DownloadStatus.completed;
    _onDone();
  }

  @override
  Future<void> cancel({required bool isDelete}) async {
    if (status == DownloadStatus.downloading) {
      status = DownloadStatus.pause;
    }
  }
}

final BiliDownloadMediaInfo _mediaInfo = Type1(
  availablePeriodMilli: 0,
  description: 'test',
  format: 'mp4',
  intact: false,
  isDownloaded: false,
  isResolved: true,
  marlinToken: '',
  needLogin: false,
  needVip: false,
  parseTimestampMilli: 0,
  playerCodecConfigList: const [],
  playerError: 0,
  quality: 80,
  segmentList: [
    Type1Segment(
      backupUrls: const [],
      bytes: 1,
      md5: '',
      metaUrl: '',
      order: 1,
      url: 'https://example.invalid/media',
    ),
  ],
  timeLength: 0,
  typeTag: '80',
  videoCodecId: 0,
  videoProject: true,
);
