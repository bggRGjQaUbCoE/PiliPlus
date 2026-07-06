import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';

class SubtitleInfo {
  String? lan;
  String? lanDoc;
  List<Subtitle>? subtitles;

  SubtitleInfo({this.lan, this.lanDoc, this.subtitles});

  factory SubtitleInfo.fromJson(Map<String, dynamic> json) => SubtitleInfo(
    lan: json['lan'] as String?,
    lanDoc: json['lan_doc'] as String?,
    subtitles:
        (json['subtitles'] as List<dynamic>?)
            ?.map((e) => Subtitle.fromJson(e as Map<String, dynamic>))
            .toList()
          ?..sort(),
  );
}
