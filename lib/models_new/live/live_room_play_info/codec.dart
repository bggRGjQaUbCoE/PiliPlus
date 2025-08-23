import 'package:PiliPlus/models_new/live/live_room_play_info/url_info.dart';
import 'package:PiliPlus/utils/extension.dart';

class CodecItem {
  String? codecName;
  int? currentQn;
  List<int>? acceptQn;
  String? baseUrl;
  List<UrlInfo>? urlInfo;
  dynamic hdrQn;
  int? dolbyType;
  String? attrName;
  int? hdrType;

  CodecItem({
    this.codecName,
    this.currentQn,
    this.acceptQn,
    this.baseUrl,
    this.urlInfo,
    this.hdrQn,
    this.dolbyType,
    this.attrName,
    this.hdrType,
  });

  factory CodecItem.fromJson(Map<String, dynamic> json) => CodecItem(
    codecName: json['codec_name'] as String?,
    currentQn: json['current_qn'] as int?,
    acceptQn: (json['accept_qn'] as List?)?.fromCast(),
    baseUrl: json['base_url'] as String?,
    urlInfo: (json['url_info'] as List<dynamic>?)
        ?.map((e) => UrlInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
    hdrQn: json['hdr_qn'] as dynamic,
    dolbyType: json['dolby_type'] as int?,
    attrName: json['attr_name'] as String?,
    hdrType: json['hdr_type'] as int?,
  );
}
