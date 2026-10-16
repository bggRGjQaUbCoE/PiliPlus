import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/url_info.dart';

class CodecItem {
  String? codecName;
  LiveQuality currentQn;
  List<LiveQuality> acceptQn;
  String baseUrl;
  List<UrlInfo> urlInfo;

  CodecItem({
    this.codecName,
    required this.currentQn,
    required this.acceptQn,
    required this.baseUrl,
    required this.urlInfo,
  });

  factory CodecItem.fromJson(
    Map<String, dynamic> json,
    List<LiveQuality>? liveQn,
  ) => CodecItem(
    codecName: json['codec_name'],
    currentQn: LiveQuality.fromFormat(json['current_qn'] as int, liveQn),
    acceptQn: (json['accept_qn'] as List)
        .map((e) => LiveQuality.fromFormat(e, liveQn))
        .toList(),
    baseUrl: json['base_url'] as String,
    urlInfo: (json['url_info'] as List<dynamic>)
        .map((e) => UrlInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
