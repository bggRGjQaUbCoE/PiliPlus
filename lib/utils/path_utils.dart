import 'dart:io' show Platform, Process;

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path/path.dart' as path;

late final String tmpDirPath;

late final String appSupportDirPath;

late String downloadPath;

String get defDownloadPath =>
    path.join(appSupportDirPath, PathUtils.downloadDir);

abstract final class PathUtils {
  static const videoNameType1 = '0.mp4';
  static const _fileExt = '.m4s';
  static const audioNameType2 = 'audio$_fileExt';
  static const videoNameType2 = 'video$_fileExt';
  static const coverName = 'cover.jpg';
  static const danmakuName = 'danmaku.pb';
  static const downloadDir = 'download';

  static String buildShadersAbsolutePath(
    String baseDirectory,
    List<String> shaders,
  ) {
    return shaders
        .map((shader) => path.join(baseDirectory, shader))
        .join(Platform.isWindows ? ';' : ':');
  }

  static Future<void> openDir(String dirPath) async {
    try {
      final String executable;
      if (Platform.isWindows) {
        executable = 'explorer';
      } else if (Platform.isMacOS) {
        executable = 'open';
      } else if (Platform.isLinux) {
        executable = 'xdg-open';
      } else {
        throw UnimplementedError();
      }
      await Process.run(executable, [dirPath]);
    } catch (e) {
      SmartDialog.showToast(e.toString());
    }
  }
}
