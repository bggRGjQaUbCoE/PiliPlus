import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/models_new/live/live_room_play_info/stream.dart';

class Playurl {
  late List<Stream> stream;

  Playurl({
    required this.stream,
  });

  Playurl.fromJson(Map<String, dynamic> json) {
    final liveQn = (json['g_qn_desc'] as List<dynamic>?)
        ?.map((e) => LiveQuality.fromJson(e as Map<String, dynamic>))
        .toList();
    stream = (json['stream'] as List<dynamic>)
        .map((e) => Stream.fromJson(e as Map<String, dynamic>, liveQn))
        .toList();
  }
}
