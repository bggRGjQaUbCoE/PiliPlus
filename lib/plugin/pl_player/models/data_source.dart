import 'package:PiliPlus/utils/path_utils.dart';
import 'package:media_kit_video/media_kit_video.dart'
    show HdrSourceDescriptor;
import 'package:path/path.dart' as path;

sealed class DataSource {
  final String videoSource;
  final String? audioSource;
  final bool allowLegacyFallback;

  DataSource({
    required this.videoSource,
    required this.audioSource,
    this.allowLegacyFallback = false,
  });
}

class NetworkSource extends DataSource {
  NetworkSource({
    required super.videoSource,
    required super.audioSource,
    super.allowLegacyFallback = false,
    this.sourceHint,
  });

  /// Source facts derived from the playurl API metadata. Used only when the
  /// player has no verified facts for these exact URLs yet; a wrong guess
  /// costs one review correction rebuild, never a wrong route.
  final HdrSourceDescriptor? sourceHint;
}

class FileSource extends DataSource {
  final String dir;
  final bool isMp4;

  FileSource({
    required this.dir,
    required this.isMp4,
    required bool hasDashAudio,
    required String typeTag,
  }) : super(
         videoSource: path.join(
           dir,
           typeTag,
           isMp4 ? PathUtils.videoNameType1 : PathUtils.videoNameType2,
         ),
         audioSource: isMp4 || !hasDashAudio
             ? null
             : path.join(dir, typeTag, PathUtils.audioNameType2),
       );
}
