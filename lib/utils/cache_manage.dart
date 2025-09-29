import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/utils/extension.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:PiliPlus/utils/utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path_provider/path_provider.dart';

abstract class CacheManage {
  // 获取缓存目录
  static Future<int> loadApplicationCache([
    final num maxSize = double.infinity,
  ]) async {
    try {
      Directory tempDirectory = await getTemporaryDirectory();
      if (Utils.isDesktop) {
        final dir = Directory('${tempDirectory.path}/libCachedImageData');
        if (dir.existsSync()) {
          return await getTotalSizeOfFilesInDir(dir, maxSize);
        } else {
          return 0;
        }
      }

      if (tempDirectory.existsSync()) {
        return await getTotalSizeOfFilesInDir(tempDirectory, maxSize);
      }
    } catch (_) {
      if (kDebugMode) rethrow;
    }
    return 0;
  }

  // 循环计算文件的大小
  static Future<int> getTotalSizeOfFilesInDir(
    final Directory file, [
    final num maxSize = double.infinity,
  ]) async {
    final children = file.list(recursive: true);
    int total = 0;
    await for (final child in children) {
      if (child is File) {
        total += await child.length();
        if (total >= maxSize) break;
      }
    }
    return total;
  }

  // 缓存大小格式转换
  static String formatSize(num value) {
    const unitArr = ['B', 'K', 'M', 'G', 'T', 'P'];
    int index = 0;
    while (value >= 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr.getOrElse(index, orElse: () => '');
  }

  // 清除 Library/Caches 目录及文件缓存
  static Future<void> clearLibraryCache() async {
    try {
      var tempDirectory = await getTemporaryDirectory();
      if (Utils.isDesktop) {
        final dir = Directory('${tempDirectory.path}/libCachedImageData');
        if (dir.existsSync()) {
          await dir.delete(recursive: true);
        }
        return;
      }
      if (tempDirectory.existsSync()) {
        final children = tempDirectory.list(recursive: false);
        await for (final file in children) {
          await file.delete(recursive: true);
        }
      }
    } catch (_) {
      if (kDebugMode) rethrow;
    }
  }

  static Future<void> autoClearCache() async {
    if (Pref.autoClearCache) {
      await clearLibraryCache();
    } else {
      final maxCacheSize = Pref.maxCacheSize;
      if (maxCacheSize != 0) {
        final currCache = await loadApplicationCache(maxCacheSize);
        if (currCache >= maxCacheSize) {
          await clearLibraryCache();
        }
      }
    }
  }
}
