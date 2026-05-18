import 'package:PiliPlus/utils/path_utils.dart';
import 'package:path/path.dart' as path;

sealed class DataSource {
  final String videoSource;
  final String? audioSource;
  final int? qualityCode;

  DataSource({
    required this.videoSource,
    required this.audioSource,
    this.qualityCode,
  });
}

class NetworkSource extends DataSource {
  NetworkSource({
    required super.videoSource,
    required super.audioSource,
    super.qualityCode,
  });
}

class FileSource extends DataSource {
  final String dir;
  final bool isMp4;
  final String typeTag;

  FileSource({
    required this.dir,
    required this.isMp4,
    required bool hasDashAudio,
    required this.typeTag,
  }) : super(
         videoSource: path.join(
           dir,
           typeTag,
           isMp4 ? PathUtils.videoNameType1 : PathUtils.videoNameType2,
         ),
         audioSource: isMp4 || !hasDashAudio
             ? null
             : path.join(dir, typeTag, PathUtils.audioNameType2),
         qualityCode: int.tryParse(typeTag),
       );
}
