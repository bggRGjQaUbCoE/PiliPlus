import 'package:PiliPlus/models_new/live/live_room_play_info/playurl.dart';

class PlayurlInfo {
  Playurl? playurl;

  PlayurlInfo({this.playurl});

  factory PlayurlInfo.fromJson(Map<String, dynamic> json) => PlayurlInfo(
    playurl: json['playurl'] == null
        ? null
        : Playurl.fromJson(json['playurl'] as Map<String, dynamic>),
  );
}
