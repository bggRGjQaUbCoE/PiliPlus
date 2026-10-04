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
  /// The API URLs for exactly one selected DASH representation per stream.
  ///
  /// Keep them even while parallel loading is disabled: playback may start or
  /// be recreated after the setting changes, and [videoSource] may already
  /// have been rewritten to the user's manually selected CDN.
  final List<String> originalVideoUrls;
  final List<String> originalAudioUrls;
  final int? durationSeconds;

  NetworkSource({
    required super.videoSource,
    required super.audioSource,
    this.durationSeconds,
    Iterable<String> originalVideoUrls = const [],
    Iterable<String> originalAudioUrls = const [],
  }) : originalVideoUrls = List.unmodifiable(originalVideoUrls),
       originalAudioUrls = List.unmodifiable(originalAudioUrls);

  String get originalVideoSource =>
      originalVideoUrls.firstOrNull ?? videoSource;

  String? get originalAudioSource =>
      originalAudioUrls.firstOrNull ?? audioSource;
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
