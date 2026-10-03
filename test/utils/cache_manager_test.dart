import 'dart:io';

import 'package:PiliPlus/utils/cache_manager.dart';
import 'package:PiliPlus/utils/path_utils.dart' as paths;
import 'package:PiliPlus/utils/storage.dart';
import 'package:cached_network_image_ce/cached_network_image.dart' as cached;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory tempDir;
  late HttpServer server;
  late Uri imageUri;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('piliplus-cache-test-');
    paths.appSupportDirPath = tempDir.path;
    Hive.init('${tempDir.path}/storage');
    GStorage.setting = await Hive.openBox<dynamic>('setting');
  });

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0)
      ..listen((request) {
        request.response
          ..headers.contentType = ContentType('image', 'png')
          ..add(<int>[1, 2, 3, 4])
          ..close();
      });
    imageUri = Uri.parse(
      'http://${server.address.address}:${server.port}/image.png',
    );
  });

  tearDown(() async {
    if (cached.DefaultCacheManager.instance != null) {
      await cached.DefaultCacheManager.instance!.dispose();
    }
    await server.close(force: true);
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('retries failed temp init in support dir for cache operations', () async {
    late cached.DefaultCacheManager failedManager;
    await CacheManager.ensureInitialized(
      cacheDirectoryProvider: () {
        failedManager = cached.DefaultCacheManager.instance!;
        throw const FileSystemException('temporary directory unavailable');
      },
    );

    final manager = CacheManager.manager;
    expect(failedManager, isNot(same(manager)));
    expect(() => failedManager.cacheDir, throwsA(isA<TypeError>()));
    expect(
      manager.cacheDir,
      '${tempDir.path}${Platform.pathSeparator}image_cache${Platform.pathSeparator}cached_network_image_ce',
    );

    final downloaded = await manager.getSingleFile(imageUri.toString());
    expect(await downloaded.readAsBytes(), <int>[1, 2, 3, 4]);

    final stored = await manager.putFile(
      'https://example.com/stored.png',
      <int>[5, 6, 7],
      fileExtension: 'png',
    );
    expect(await stored.readAsBytes(), <int>[5, 6, 7]);
    await server.close(force: true);
    expect(
      (await manager.getSingleFile(imageUri.toString())).path,
      downloaded.path,
    );
    expect(cached.DefaultCacheManager.instance, same(manager));
  });

  test('keeps a working default cache and shares initialization', () async {
    var calls = 0;
    Future<Directory> provider() async {
      calls++;
      return Directory('${tempDir.path}/default');
    }

    await Future.wait([
      CacheManager.ensureInitialized(cacheDirectoryProvider: provider),
      CacheManager.ensureInitialized(cacheDirectoryProvider: provider),
    ]);
    final manager = CacheManager.manager;
    await CacheManager.ensureInitialized(cacheDirectoryProvider: provider);
    expect(calls, 1);
    expect(CacheManager.manager, same(manager));
    expect(cached.DefaultCacheManager.instance, same(manager));
    expect(manager.cacheDir, contains('default'));
  });

  test('cleans both failed singletons and allows a later retry', () async {
    final fallback = Directory('${tempDir.path}/image_cache');
    if (fallback.existsSync()) {
      await fallback.delete(recursive: true);
    }
    final blocker = File(fallback.path);
    await blocker.writeAsString('not a directory');
    try {
      await expectLater(
        CacheManager.ensureInitialized(
          cacheDirectoryProvider: () => throw const FileSystemException(
            'temporary directory unavailable',
          ),
        ),
        throwsA(
          isA<FileSystemException>()
              .having(
                (error) => error.message,
                'message',
                contains('temporary directory unavailable'),
              )
              .having(
                (error) => error.message,
                'message',
                contains('Application support directory:'),
              ),
        ),
      );
      expect(cached.DefaultCacheManager.instance, isNull);
    } finally {
      await blocker.delete();
    }

    await CacheManager.ensureInitialized(
      cacheDirectoryProvider: () => throw const FileSystemException(
        'temporary directory unavailable',
      ),
    );
    expect(cached.DefaultCacheManager.instance, same(CacheManager.manager));
  });
}
