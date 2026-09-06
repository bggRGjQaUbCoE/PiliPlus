import 'dart:io' show Platform;

import 'package:path/path.dart' as path;

late final String tmpDirPath;

late final String appSupportDirPath;

late String downloadPath;

String get defDownloadPath =>
    path.join(appSupportDirPath, PathUtils.downloadDir);

abstract final class PathUtils {
  // Pass --dart-define=pili.dataSuffix=test to keep a development instance
  // separate from the default instance. An empty value preserves old paths.
  static const _rawDataSuffix = String.fromEnvironment('pili.dataSuffix');
  static final dataSuffix = _sanitizeDataSuffix(_rawDataSuffix);

  static const videoNameType1 = '0.mp4';
  static const _fileExt = '.m4s';
  static const audioNameType2 = 'audio$_fileExt';
  static const videoNameType2 = 'video$_fileExt';
  static const coverName = 'cover.jpg';
  static const danmakuName = 'danmaku.pb';
  static const downloadDir = 'download';

  static String withDataSuffix(String basePath) {
    if (dataSuffix.isEmpty) return basePath;
    return path.join(basePath, 'profiles', dataSuffix);
  }

  static String _sanitizeDataSuffix(String value) {
    final suffix = value.trim();
    if (suffix.isEmpty) return '';
    return suffix.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
  }

  static String buildShadersAbsolutePath(
    String baseDirectory,
    List<String> shaders,
  ) {
    return shaders
        .map((shader) => path.join(baseDirectory, shader))
        .join(Platform.isWindows ? ';' : ':');
  }
}
