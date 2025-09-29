import 'package:PiliPlus/models_new/video/video_play_info/subtitle.dart';

class SubtitleInfo {
  String? lan;
  String? lanDoc;
  List<Subtitle>? subtitles;

  SubtitleInfo({this.lan, this.lanDoc, this.subtitles});

  SubtitleInfo.fromJson(Map<String, dynamic> json) {
    lan = json['lan'] as String?;
    lanDoc = json['lan_doc'] as String?;
    final List? list = json['subtitles'];
    if (list != null && list.isNotEmpty) {
      subtitles = <Subtitle>[];
      int index = 0;
      for (var e in list) {
        final item = Subtitle.fromJson(e);
        if (item.lan!.contains('zh')) {
          subtitles!.insert(index, item);
          index++;
        } else {
          subtitles!.add(item);
        }
      }
    }
  }
}
