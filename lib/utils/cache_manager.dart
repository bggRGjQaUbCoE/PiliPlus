import 'dart:io' show Directory;

import 'package:PiliPlus/common/constants.dart';
import 'package:PiliPlus/utils/path_utils.dart';
import 'package:PiliPlus/utils/platform_utils.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract final class CacheManager {
  static late final DefaultCacheManager manager;

  static Future<void> ensureInitialized() => DefaultCacheManager.init(
    maxNrOfCacheLength: Pref.maxCacheSize.toInt(),
    cacheDirectoryProvider: () async {
      final directory = await getTemporaryDirectory();
      tmpDirPath = directory.path;
      return PlatformUtils.isDesktop
          ? Directory(path.join(directory.path, Constants.appName))
          : directory;
    },
  ).then((i) => manager = i);

  static int loadApplicationCache() => manager.getTotalLength();

  static Future<void> clearLibraryCache() => manager.emptyCache();
}
