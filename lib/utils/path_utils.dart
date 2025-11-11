import 'dart:io' show Platform;

import 'package:path/path.dart' as path;

late final String tmpDirPath;

late final String appSupportDirPath;

late String downloadPath;

String get defDownloadPath =>
    path.join(appSupportDirPath, PathUtils.downloadDir);

abstract final class PathUtils {
  static const videoNameType1 = '0.mp4';
  static const audioNameType2 = 'audio.m4a';
  static const videoNameType2 = 'video.mp4';
  static const coverName = 'cover.jpg';
  static const danmakuName = 'danmaku.pb.gz';
  static const downloadDir = 'download';

  static String buildShadersAbsolutePath(
    String baseDirectory,
    List<String> shaders,
  ) {
    return shaders
        .map((shader) => path.join(baseDirectory, shader))
        .join(Platform.isWindows ? ';' : ':');
  }
}
