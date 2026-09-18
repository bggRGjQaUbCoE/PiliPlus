import 'dart:convert';
import 'dart:io';

import 'package:PiliPlus/models_new/sponsor_block/segment_item.dart';
import 'package:PiliPlus/models_new/sponsor_block/snapshot.dart';
import 'package:PiliPlus/services/download/sponsor_block_cache.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  test('番剧片段可以保存和读取，更新失败时保留已有信息', () async {
    final directory = await Directory.systemTemp.createTemp('pgc-skip-test-');
    addTearDown(() => directory.delete(recursive: true));
    final target = SponsorBlockTarget(
      directory: directory.path,
      bvid: 'BV1test',
      cid: 100,
      durationMs: 120000,
      createdAt: 1,
      source: .pgc,
      videoType: .pgc,
      epid: 20,
    );
    await File(path.join(directory.path, 'entry.json')).writeAsString(
      jsonEncode({
        'bvid': target.bvid,
        'source': {'cid': target.cid},
        'ep': {'episode_id': target.epid},
        'time_create_stamp': target.createdAt,
      }),
    );
    var requests = 0;
    var server = 'https://community.example';
    final cache = SponsorBlockCache(
      server: () => server,
      fetch: (_, _, _) {
        requests++;
        throw const SponsorBlockFetchException('测试请求失败');
      },
    );
    final saved = await cache.update(
      target,
      segments: [
        SegmentItemModel.fromPgcJson({
          'clipType': 'CLIP_TYPE_OP',
          'start': 0,
          'end': 30,
        }, 120000),
      ],
    );
    expect(saved.isUsable, isTrue);
    expect(requests, 0);

    server = 'https://another.example';
    final snapshot = (await cache.read(target)).snapshot!;
    expect(snapshot.source, SponsorBlockSource.pgc);
    expect(snapshot.playableSegments(120000).single.segment, [0, 30000]);

    final file = File(path.join(directory.path, PathUtils.pgcSkipName));
    final original = await file.readAsString();
    final failed = await cache.update(target, refresh: true);
    expect(failed.status, SponsorBlockCacheStatus.failed);
    expect(requests, 1);
    expect(await file.readAsString(), original);
  });
}
