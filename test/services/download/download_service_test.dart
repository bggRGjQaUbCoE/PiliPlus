import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/models_new/download/bili_download_entry_info.dart';
import 'package:PiliPlus/models_new/download/bili_download_media_file_info.dart';
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
}

Future<BiliDownloadEntryInfo> _createEntry(Directory testDir) async {
  final entryDir = await Directory(
    path.join(testDir.path, '1', 'c_2'),
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
        cid: 2,
        page: 1,
        hasAlias: false,
        tid: 0,
      ),
    )
    ..pageDirPath = entryDir.parent.path
    ..entryDirPath = entryDir.path
    ..status = DownloadStatus.wait;
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
