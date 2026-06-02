import 'dart:io' show Directory, File;

import 'package:PiliPlus/utils/extension/file_ext.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract final class CacheManager {
  static late final DefaultCacheManager manager;

  static Future<void> ensureInitialized() =>
      DefaultCacheManager.init().then((i) => manager = i);

  // 获取缓存目录
  @pragma('vm:notify-debugger-on-exception')
  static Future<int> loadApplicationCache() async {
    try {
      final Directory tempDirectory = await getTemporaryDirectory();
      if (PlatformUtils.isDesktop) {
        return manager.getTotalLength();
      }

      if (tempDirectory.existsSync()) {
        return await getTotalSizeOfFilesInDir(tempDirectory);
      }
    } catch (_) {}
    return 0;
  }

  // 循环计算文件的大小
  @pragma('vm:notify-debugger-on-exception')
  static Future<int> getTotalSizeOfFilesInDir(final Directory file) async {
    int total = 0;
    await for (final child in file.list(recursive: false)) {
      if (child is File) {
        total += await child.length();
      } else if (child is Directory) {
        if (path.equals(child.path, manager.cacheDir)) {
          total += manager.getTotalLength();
        } else {
          await for (final i in child.list(recursive: true)) {
            if (i is File) {
              total += await i.length();
            }
          }
        }
      }
    }
    return total;
  }

  // 清除 Library/Caches 目录及文件缓存
  @pragma('vm:notify-debugger-on-exception')
  static Future<void> clearLibraryCache() async {
    try {
      await manager.emptyCache();
      if (PlatformUtils.isDesktop) return;

      final tempDirectory = await getTemporaryDirectory();
      if (tempDirectory.existsSync()) {
        final children = tempDirectory.list(recursive: false);
        await for (final file in children) {
          await file.delete(recursive: true);
        }
      }
    } catch (_) {}
  }

  static Future<void> autoClearCache() async {
    // TODO: remove
    Directory(
      '${(await getTemporaryDirectory()).path}/libCachedImageData',
    ).tryDel(recursive: true);
    final maxCacheSize = Pref.maxCacheSize;
    if (maxCacheSize != 0) {
      final currCache = await loadApplicationCache();
      if (currCache >= maxCacheSize) {
        await clearLibraryCache();
      }
    }
  }
}
