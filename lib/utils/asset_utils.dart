import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

abstract final class AssetUtils {
  /// from media-kit AssetLoader
  static String? tryGetPath(String key) {
    if (Platform.isWindows || Platform.isLinux) {
      return path.join(
        path.dirname(Platform.resolvedExecutable),
        'data',
        'flutter_assets',
        key,
      );
    } else if (Platform.isMacOS) {
      return path.join(
        path.dirname(Platform.resolvedExecutable),
        '..',
        'Frameworks',
        'App.framework',
        'Resources',
        'flutter_assets',
        key,
      );
    } else if (Platform.isIOS) {
      return path.join(
        path.dirname(Platform.resolvedExecutable),
        'Frameworks',
        'App.framework',
        'flutter_assets',
        key,
      );
    }
    return null;
  }

  static FutureOr<String> getOrCopy(
    String src,
    Iterable<String> files,
    String dst,
  ) async {
    final parsedSrc = tryGetPath(src);
    if (parsedSrc != null) {
      final srcDir = Directory(parsedSrc);
      if (srcDir.existsSync()) {
        return srcDir.absolute.path;
      }
    }

    final dstDir = Directory(dst);
    if (!dstDir.existsSync()) {
      await dstDir.create(recursive: true);
    }

    for (final file in files) {
      final targetFile = File(path.join(dst, file));
      if (targetFile.existsSync()) {
        continue;
      }

      try {
        final data = await rootBundle.load(file);
        await targetFile.writeAsBytes(data.buffer.asUint8List());
      } catch (_) {}
    }
    return dst;
  }
}
