import 'package:PiliPlus/utils/path_utils.dart';
import 'package:path/path.dart' as path;

sealed class DataSource {
  final String videoSource;
  final String? audioSource;

  const DataSource({
    required this.videoSource,
    this.audioSource,
  });
}

class NetworkSource extends DataSource {
  const NetworkSource({
    required super.videoSource,
    super.audioSource,
  });
}

class FileSource implements DataSource {
  @override
  String get videoSource => path.join(
    dir,
    typeTag,
    mp4Video ? PathUtils.videoNameType1 : PathUtils.videoNameType2,
  );

  @override
  String? get audioSource =>
      mp4Video ? null : path.join(dir, typeTag, PathUtils.audioNameType2);

  final bool mp4Video;
  final String dir;
  final String typeTag;

  const FileSource({
    required this.dir,
    required this.typeTag,
    this.mp4Video = false,
  });
}
