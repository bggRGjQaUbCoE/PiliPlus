import 'dart:io';

import 'package:PiliPlus/http/api.dart';
import 'package:PiliPlus/http/init.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/http/search.dart';
import 'package:PiliPlus/http/video.dart';
import 'package:PiliPlus/models/common/video/video_type.dart';
import 'package:PiliPlus/utils/accounts/account.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory temp;
  final requests = <RequestOptions>[];
  // An explicit account must survive every retry, rather than falling back to
  // the user's configured video account and recording preview watch progress.
  const account = NoAccount();
  late Map<String, dynamic> Function(RequestOptions) respond;

  setUpAll(() async {
    temp = await Directory.systemTemp.createTemp('piliplus-preview-account-');
    Hive.init(temp.path);
    GStorage.setting = await Hive.openBox('setting');
    GStorage.localCache = await Hive.openBox('localCache');
    await GStorage.localCache.put(
      LocalCacheKey.timeStamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    await GStorage.localCache.put(LocalCacheKey.mixinKey, 'test-wbi-key');
    Request();
    Request.dio.interceptors
      ..clear()
      ..add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response(
                requestOptions: options,
                data: respond(options),
                statusCode: 200,
              ),
            );
          },
        ),
      );
  });

  setUp(requests.clear);

  tearDownAll(() async {
    Request.dio.close(force: true);
    await Hive.close();
    await temp.delete(recursive: true);
  });

  test('cover preview CID lookup keeps its explicit account', () async {
    respond = (_) => {
      'code': 0,
      'data': [
        {'cid': 42, 'page': 1, 'part': 'Preview'},
      ],
    };
    final page = await SearchHttp.ab2cWithDimension(aid: 1, account: account);
    expect(page?.cid, 42);
    expect(requests.single.path, Api.ab2c);
    expect(requests.single.extra['account'], same(account));
  });

  test('DRM fallback retains the account and playback options', () async {
    respond = (options) => options.path == Api.ogvUrl
        ? {
            'code': 0,
            'data': {
              'arc': {'is_drm': true},
            },
          }
        : {
            'code': 0,
            'result': {
              'video_info': {'quality': 16},
            },
          };
    final result = await VideoHttp.videoUrl(
      avid: 1,
      cid: 42,
      qn: 16,
      epid: 3,
      seasonId: 4,
      tryLook: false,
      videoType: VideoType.pgc,
      account: account,
      language: 'ja',
      voiceBalance: true,
    );
    expect(result, isA<Success>());
    expect(requests.map((e) => e.path), [Api.ogvUrl, Api.pgcUrl]);
    for (final request in requests) {
      expect(request.extra['account'], same(account));
      expect(request.queryParameters['cur_language'], 'ja');
      expect(request.queryParameters['voice_balance'], 1);
    }
  });

  test('UGC to PGC retry keeps its explicit account', () async {
    respond = (options) => options.path == Api.ugcUrl
        ? {'code': -404, 'message': 'retry as PGC'}
        : {
            'code': 0,
            'data': {
              'video_info': {'quality': 16},
            },
          };
    final result = await VideoHttp.videoUrl(
      avid: 1,
      cid: 42,
      qn: 16,
      epid: 3,
      tryLook: false,
      videoType: VideoType.ugc,
      account: account,
    );
    expect(result, isA<Success>());
    expect(requests.map((e) => e.path), [Api.ugcUrl, Api.ogvUrl]);
    expect(
      requests.every((e) => identical(e.extra['account'], account)),
      isTrue,
    );
  });
}
