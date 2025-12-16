import 'package:PiliPlus/models_new/live/live_room_play_info/stream.dart';

class Playurl {
  int? cid;
  List<Stream>? stream;

  Playurl({
    this.cid,
    this.stream,
  });

  factory Playurl.fromJson(Map<String, dynamic> json) => Playurl(
    cid: json['cid'] as int?,
    stream: (json['stream'] as List<dynamic>?)
        ?.map((e) => Stream.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
