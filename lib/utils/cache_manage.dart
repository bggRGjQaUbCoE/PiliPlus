import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

abstract class CacheManage {
  // 获取缓存目录
  static Future<int> loadApplicationCache() async {
    /// clear all of image in memory
    // clearMemoryImageCache();
    /// get ImageCache
    // var res = getMemoryImageCache();

    // 缓存大小
    // cached_network_image directory
    Directory tempDirectory = await getTemporaryDirectory();
    if (Utils.isDesktop) {
      final dir = Directory('${tempDirectory.path}/libCachedImageData');
      if (dir.existsSync()) {
        return await getTotalSizeOfFilesInDir(dir);
      } else {
        return 0;
      }
    }
    // get_storage directory
    Directory docDirectory = await getApplicationDocumentsDirectory();

    int cacheSize = 0;
    // 获取缓存大小
    if (tempDirectory.existsSync()) {
      cacheSize += await getTotalSizeOfFilesInDir(tempDirectory);
    }

    /// 获取缓存大小 dioCache
    if (docDirectory.existsSync()) {
      String dioCacheFileName =
          '${docDirectory.path}${Platform.pathSeparator}DioCache.db';
      var dioCacheFile = File(dioCacheFileName);
      if (dioCacheFile.existsSync()) {
        cacheSize += await getTotalSizeOfFilesInDir(dioCacheFile);
      }
    }

    return cacheSize;
  }

  // 循环计算文件的大小（递归）
  static Future<int> getTotalSizeOfFilesInDir(
    final FileSystemEntity file,
  ) async {
    if (file is File) {
      int length = await file.length();
      return int.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      int total = 0;
      for (final FileSystemEntity child in children) {
        total += await getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  // 缓存大小格式转换
  static String formatSize(num value) {
    List<String> unitArr = const ['B', 'K', 'M', 'G', 'T', 'P'];
    int index = 0;
    while (value >= 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr.getOrElse(index, orElse: () => '');
  }

  /// 清除 Documents 目录下的 DioCache.db
  static Future<void> clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (directory.existsSync()) {
      String dioCacheFileName =
          '${directory.path}${Platform.pathSeparator}DioCache.db';
      var dioCacheFile = File(dioCacheFileName);
      if (dioCacheFile.existsSync()) {
        dioCacheFile.delete();
      }
    }
  }

  // 清除 Library/Caches 目录及文件缓存
  static Future<void> clearLibraryCache() async {
    var tempDirectory = await getTemporaryDirectory();
    if (Utils.isDesktop) {
      final dir = Directory('${tempDirectory.path}/libCachedImageData');
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
      return;
    }
    if (tempDirectory.existsSync()) {
      // await appDocDir.delete(recursive: true);
      final List<FileSystemEntity> children = tempDirectory.listSync(
        recursive: false,
      );
      for (final FileSystemEntity file in children) {
        await file.delete(recursive: true);
      }
    }
  }

  /// 递归方式删除目录及文件
  static Future<void> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }

  static Future<void> autoClearCache() async {
    if (Pref.autoClearCache) {
      await clearLibraryCache();
    } else {
      final maxCacheSize = Pref.maxCacheSize;
      if (maxCacheSize != 0) {
        final currCache = await loadApplicationCache();
        if (currCache >= maxCacheSize) {
          await clearLibraryCache();
        }
      }
    }
  }
}
