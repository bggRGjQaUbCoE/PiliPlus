import 'dart:io' show File;

import 'package:PiliPlus/utils/path_utils.dart';
import 'package:path/path.dart' as path;

sealed class DataSource {
  final String videoSource;
  final String? audioSource;

  DataSource({
    required this.videoSource,
    required this.audioSource,
  });
}

class NetworkSource extends DataSource {
  NetworkSource({
    required super.videoSource,
    required super.audioSource,
  });
}

class FileSource extends DataSource {
  final String dir;
  final bool isMp4;
  final bool hasDashAudio;

  FileSource({
    required this.dir,
    required this.isMp4,
    this.hasDashAudio = true,
    required String typeTag,
  }) : super(
         videoSource: path.join(
           dir,
           typeTag,
           isMp4 ? PathUtils.videoNameType1 : PathUtils.videoNameType2,
         ),
         audioSource: _resolveAudioSource(
           dir: dir,
           typeTag: typeTag,
           isMp4: isMp4,
           hasDashAudio: hasDashAudio,
         ),
       );

  static String? _resolveAudioSource({
    required String dir,
    required String typeTag,
    required bool isMp4,
    required bool hasDashAudio,
  }) {
    if (isMp4 || !hasDashAudio) {
      return null;
    }
    final audioSource = path.join(dir, typeTag, PathUtils.audioNameType2);
    return File(audioSource).existsSync() ? audioSource : null;
  }
}
