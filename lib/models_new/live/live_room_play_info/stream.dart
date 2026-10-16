import 'package:PiliPlus/models/common/video/live_quality.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/format.dart';

class Stream {
  String? protocolName;
  List<Format> format;

  Stream({this.protocolName, required this.format});

  factory Stream.fromJson(
    Map<String, dynamic> json,
    List<LiveQuality>? liveQn,
  ) => Stream(
    protocolName: json['protocol_name'],
    format: (json['format'] as List<dynamic>)
        .map((e) => Format.fromJson(e as Map<String, dynamic>, liveQn))
        .toList(),
  );
}
