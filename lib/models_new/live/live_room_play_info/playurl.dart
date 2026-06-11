import 'package:PiliPlus/models_new/live/live_room_play_info/stream.dart';

class Playurl {
  List<Stream> stream;

  Playurl({
    required this.stream,
  });

  factory Playurl.fromJson(Map<String, dynamic> json) => Playurl(
    stream: (json['stream'] as List<dynamic>)
        .map((e) => Stream.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
