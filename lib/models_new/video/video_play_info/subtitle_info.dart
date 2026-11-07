import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';

class SubtitleInfo {
  List<Subtitle>? subtitles;

  SubtitleInfo.fromJson(Map<String, dynamic> json) {
    if (json['subtitles'] case final List list when list.isNotEmpty) {
      subtitles =
          list.map((e) => Subtitle.fromJson(e as Map<String, dynamic>)).toList()
            ..sort();
    }
  }
}
